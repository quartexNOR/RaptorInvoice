  unit jlgifcodec;

  interface

  uses windows, sysutils, classes, graphics,
  jlcommon, jlraster, jlpalette;


  const
  // LZW encoding and decoding support
  NoLZWCode = 4096;

  // logical screen descriptor packed field masks
  GIF_GLOBALCOLORTABLE        = $80;
  GIF_COLORRESOLUTION         = $70;
  GIF_GLOBALCOLORTABLESORTED  = $08;
  GIF_COLORTABLESIZE          = $07;

  // image flags
  GIF_LOCALCOLORTABLE         = $80;
  GIF_INTERLACED              = $40;
  GIF_LOCALCOLORTABLESORTED   = $20;

  // block identifiers
  GIF_PLAINTEXT               = $01;
  GIF_GRAPHICCONTROLEXTENSION = $F9;
  GIF_COMMENTEXTENSION        = $FE;
  GIF_APPLICATIONEXTENSION    = $FF;
  GIF_IMAGEDESCRIPTOR         = Ord(',');
  GIF_EXTENSIONINTRODUCER     = Ord('!');
  GIF_TRAILER                 = Ord(';');

  type

  TGIFHeader = packed record
    Signature:  array[0..2] of Char; // magic ID 'GIF'
    Version:    array[0..2] of Char;   // '87a' or '89a'
  end;

  TLogicalScreenDescriptor = packed record
    ScreenWidth:  Word;
    ScreenHeight: Word;
    PackedFields,
    BackgroundColorIndex, // index into global color table
    AspectRatio: Byte;    // actual ratio = (AspectRatio + 15) / 64
  end;

  TImageDescriptor = packed record
    Left: Word;		 // X position of image with respect to logical screen
    Top: Word;		 // Y position
    Width: Word;
    Height: Word;
    PackedFields: Byte;
  end;

  TGifColorScheme      = (csUnknown, csIndexed);
  TGifCompressionType  = (ctUnknown,ctNone,ctLZW);

  PImageProperties = ^TImageProperties;
  TImageProperties = record
    Version: Cardinal;                 // TIF, PSP, GIF
    Width,                             // all images
    Height: Cardinal;                  // all images
    ColorScheme: TGifColorScheme;         // all images
    BitsPerSample,                     // all Images
    SamplesPerPixel,                   // all images
    BitsPerPixel: Byte;                // all images
    Compression: TGifCompressionType;     // all images
    Interlaced,                        // GIF, PNG
    LocalColorTable: Boolean;          // image uses an own color palette
  end;

  TJLGIFCodec = Class(TJLCustomCodec)
  Private
    FImageProperties: TImageProperties;
    FInitialCodeSize: Byte;
    Procedure   Decode(var Source,Dest:Pointer;
                PackedSize,UnpackedSize: Integer);

    Function    SkipExtensions(Const Stream:TStream):Byte;
    function    ReadImageProperties(Stream: TStream;
                ImageIndex:Cardinal): Boolean;
  Protected
    Function    GetCodecCaps:TJLCodecCaps;override;
    Function    GetCodecDescription:AnsiString;override;
    Function    GetCodecExtension:AnsiString;override;
  Public
    Function    Eval(Stream:TStream):Boolean;override;
    Procedure   LoadFromStream(Stream:TStream;
                Raster:TJLCustomRaster);override;
    Procedure   SaveToStream(Stream:TStream;
                Raster:TJLCustomRaster);override;
  End;

  implementation


  //###########################################################################
  // TJLGIFCodec
  //###########################################################################

  Function TJLGIFCodec.GetCodecCaps:TJLCodecCaps;
  Begin
    result:=[ccRead];
  end;

  Function TJLGIFCodec.GetCodecDescription:AnsiString;
  Begin
    result:='Graphics Interchange Format';
  end;

  Function TJLGIFCodec.GetCodecExtension:AnsiString;
  Begin
    result:='.gif';
  end;

  function TJLGIFCodec.SkipExtensions(Const Stream:TStream):Byte;
  var
    Increment: Byte;
  begin
    with Stream do
    begin
      // iterate through the blocks until first image is found
      repeat
        ReadBuffer(Result, 1);
        if Result = GIF_EXTENSIONINTRODUCER then
        begin
          // skip any extension
          ReadBuffer(Result, 1);
          case Result of
            GIF_PLAINTEXT:
            begin
              // block size of text grid data
              ReadBuffer(Increment, 1);
              Seek(Increment, soFromCurrent);
              // skip variable lengthed text block
              repeat
                // block size
                ReadBuffer(Increment, 1);
                if Increment = 0 then Break;
                Seek(Increment, soFromCurrent);
              until False;
            end;

            GIF_GRAPHICCONTROLEXTENSION:
            begin
              // block size
              ReadBuffer(Increment, 1);
              // skip block and its terminator
              Seek(Increment + 1, soFromCurrent);
            end;

            GIF_COMMENTEXTENSION:
            repeat
              // block size
              ReadBuffer(Increment, 1);
              if Increment = 0 then Break;
              Seek(Increment, soFromCurrent);
            until False;

            GIF_APPLICATIONEXTENSION:
            begin
              repeat
                ReadBuffer(Increment, 1);
                if Increment = 0 then Break;
                Seek(Increment, soFromCurrent);
              until False;
            end;
          end;
        end;
      until (Result = GIF_IMAGEDESCRIPTOR)
      or (Result = GIF_TRAILER);
    end;
  end;

  Function TJLGIFCodec.Eval(Stream:TStream):Boolean;
  var
    Header:       TGIFHeader;
    LastPosition: Int64;
  begin
    with Stream do
    begin
      LastPosition := Position;
      try
        Result := (Size - Position) > (SizeOf(TGIFHeader)
        + SizeOf(TLogicalScreenDescriptor) + SizeOf(TImageDescriptor));
        if Result then
        begin
          Result:=Read(Header, SizeOf(Header))=SizeOf(header);
          If result then
          Result := UpperCase(Header.Signature) = 'GIF';
        end;
      finally
        Position := LastPosition;
      end;
    end;
  end;

  Procedure TJLGIFCodec.LoadFromStream(Stream:TStream;
            Raster:TJLCustomRaster);
  var
    Header: TGIFHeader;
    ScreenDescriptor: TLogicalScreenDescriptor;
    ImageDescriptor: TImageDescriptor;
    I: Longword;
    BlockID: Byte;
    InitCodeSize: Byte;
    RawData,
    Run: PByte;
    TargetBuffer,
    TargetRun,
    Line: Pointer;
    Pass,
    Increment,
    Marker: Integer;
    FTemp:          TRGBTriple;
    FColors:        Integer;
    FBasePosition:  Int64;
  begin
    If (Raster<>NIL) and (Stream<>NIL) then
    Begin
      if not Raster.Empty then
      Raster.Release;

      FBasePosition := Stream.Position;
      if ReadImageProperties(Stream, 0) then
      begin
        with Stream, FImageProperties do
        begin
          Position := FBasePosition;
          ReadBuffer(Header, SizeOf(Header));

          try
            Raster.Allocate(Width,Height,rf8Bit);
            Raster.DefinePalette(plUser);
            //Raster.PaletteType:=plUser;
          except
            on e: exception do
            Raise EJLCodec.Create(e.message);
          end;

          ReadBuffer(ScreenDescriptor, SizeOf(ScreenDescriptor));

            if (ScreenDescriptor.PackedFields and GIF_GLOBALCOLORTABLE)<>0 then
            begin
              FColors:=(2 shl (ScreenDescriptor.PackedFields and GIF_COLORTABLESIZE));
              for I := 0 to FColors -1 do
              begin
                ReadBuffer(FTemp,SizeOf(FTemp));
                with Raster.RasterInfo^.riPalData[i] do
                Begin
                  rgbBlue:=FTemp.rgbtRed;
                  rgbGreen:=FTemp.rgbtGreen;
                  rgbRed:=FTemp.rgbtBlue;
                end;
              end;
            end;

            BlockID := SkipExtensions(Stream);
            if BlockID = GIF_IMAGEDESCRIPTOR then
            begin
              ReadBuffer(ImageDescriptor, SizeOf(TImageDescriptor));
              if (ImageDescriptor.PackedFields and GIF_LOCALCOLORTABLE)<>0 then
              begin
                FColors:=(2 shl (ImageDescriptor.PackedFields and GIF_COLORTABLESIZE));

                Raster.RasterInfo^.riPalCnt:=FColors;
                Raster.RasterInfo^.riPalSize:=FColors * SizeOf(TRGBQuad);

                for I := 0 to FColors -1 do
                begin
                  ReadBuffer(FTemp,SizeOf(FTemp));
                  with Raster.RasterInfo^.riPalData[i] do
                  Begin
                    rgbBlue:=FTemp.rgbtRed;
                    rgbGreen:=FTemp.rgbtGreen;
                    rgbRed:=FTemp.rgbtBlue;
                  end;
                end;
              end;

              ReadBuffer(InitCodeSize, 1);
              Marker := Position;
              Pass := 0;
              Increment := 0;
              repeat
                if Read(Increment, 1) = 0 then
                Break;
                Inc(Pass, Increment);
                Seek(Increment, soFromCurrent);
              until Increment = 0;

              GetMem(RawData, Pass);
              GetMem(TargetBuffer, Width * (Height + 1));

              try
                Position := Marker;
                Increment := 0;
                Run := RawData;
                repeat
                  if Read(Increment, 1) = 0 then
                  Break;
                  Read(Run^, Increment);
                  Inc(Run, Increment);
                until Increment = 0;

                Run:=RawData;
                FInitialCodeSize:=InitCodeSize;
                Decode(pointer(Run),TargetBuffer,
                Pass,Width * Height);

                if (ImageDescriptor.PackedFields and GIF_INTERLACED)=0 then
                begin
                  TargetRun := TargetBuffer;
                  for I := 0 to Height - 1 do
                  begin
                    Line := Raster.Scanline[I];
                    Move(TargetRun^, Line^, Width);
                    Inc(PByte(TargetRun), Width);
                  end;
                end else
                begin
                  TargetRun := TargetBuffer;
                  for Pass := 0 to 3 do
                  begin
                    If Pass=0 then
                    Begin
                      I := 0;
                      Increment := 8;
                    end else
                    if Pass=1 then
                    Begin
                      I := 4;
                      Increment := 8;
                    end else
                    If pass=2 then
                    Begin
                      I := 2;
                      Increment := 4;
                    end else
                    Begin
                      I := 1;
                      Increment := 2;
                    end;

                    while I < Height do
                    begin
                      Line := Raster.Scanline[I];
                      Move(TargetRun^, Line^, Width);
                      Inc(PByte(TargetRun), Width);
                      Inc(I, Increment);
                    end;
                  end;
                end;
              finally
                if Assigned(TargetBuffer) then
                FreeMem(TargetBuffer);
                
                if Assigned(RawData) then
                FreeMem(RawData);
              end;
            end;

          Raster.UpdatePalette;
        end;
      end;
    end;
  end;

  Procedure TJLGIFCodec.SaveToStream(Stream:TStream;
            Raster:TJLCustomRaster);
  Begin
  end;


  function  TJLGIFCodec.ReadImageProperties(Stream: TStream;
            ImageIndex:Cardinal): Boolean;
  var
    Header: TGIFHeader;
    ScreenDescriptor: TLogicalScreenDescriptor;
    ImageDescriptor: TImageDescriptor;
    BlockID: Integer;
  begin
    Fillchar(FImageProperties, SizeOf(FImageProperties),#0);
    Result := False;

    with Stream, FImageProperties do
    begin
      ReadBuffer(Header, SizeOf(Header));
      if UpperCase(Header.Signature) = 'GIF' then
      begin
        Version := StrToInt(Copy(Header.Version, 1, 2));
        ColorScheme := csIndexed;
        SamplesPerPixel := 1;

        // might be overwritten
        BitsPerSample := 8;
        Compression := ctLZW;

        // general information
        ReadBuffer(ScreenDescriptor, SizeOf(ScreenDescriptor));

        // skip global color table if given
        if (ScreenDescriptor.PackedFields and GIF_GLOBALCOLORTABLE) <> 0 then
        begin
          BitsPerSample := (ScreenDescriptor.PackedFields and GIF_COLORTABLESIZE) + 1;
          // the global color table immediately follows the screen descriptor
          Seek(3 * (1 shl BitsPerSample), soFromCurrent);
        end;

        BlockID := SkipExtensions(Stream);

        // image found?
        if BlockID = GIF_IMAGEDESCRIPTOR then
        begin
          ReadBuffer(ImageDescriptor, SizeOf(TImageDescriptor));
          Width := ImageDescriptor.Width;
          if Width = 0 then Width := ScreenDescriptor.ScreenWidth;
          Height := ImageDescriptor.Height;
          if Height = 0 then Height := ScreenDescriptor.ScreenHeight;

          // if there is a local color table then override the already set one
          LocalColorTable := (ImageDescriptor.PackedFields and GIF_LOCALCOLORTABLE) <> 0;
          if LocalColorTable then
          BitsPerSample := (ImageDescriptor.PackedFields and GIF_LOCALCOLORTABLE) + 1;
          Interlaced := (ImageDescriptor.PackedFields and GIF_INTERLACED) <> 0;
        end;

        BitsPerPixel := SamplesPerPixel * BitsPerSample;

        Result := True;
      end;
    end;
  end;

  procedure TJLGIFCodec.Decode(var Source, Dest: Pointer; PackedSize,
            UnpackedSize: Integer);
  var
    I: Integer;
    Data,           // current data
    Bits,           // counter for bit management
    Code: Cardinal; // current code value
    SourcePtr: PByte;
    InCode: Cardinal; // Buffer for passed code
    CodeSize: Cardinal;
    CodeMask: Cardinal;
    FreeCode: Cardinal;
    OldCode: Cardinal;
    Prefix: array[0..4095] of Cardinal; // LZW prefix
    Suffix,                             // LZW suffix
    Stack: array [0..4095] of Byte;     // stack
    StackPointer: PByte;
    Target: PByte;
    FirstChar: Byte;  // Buffer for decoded byte
    ClearCode,
    EOICode: Word;
  begin
    Target := Dest;
    SourcePtr := Source;

    // initialize parameter
    CodeSize := FInitialCodeSize + 1;
    ClearCode := 1 shl FInitialCodeSize;
    EOICode := ClearCode + 1;
    FreeCode := ClearCode + 2;
    OldCode := NoLZWCode;
    CodeMask := (1 shl CodeSize) - 1;

    // init code table
    for I := 0 to ClearCode - 1 do
    begin
      Prefix[I] := NoLZWCode;
      Suffix[I] := I;
    end;

    // initialize stack
    StackPointer := @Stack;
    FirstChar := 0;

    Data := 0;
    Bits := 0;
    while (UnpackedSize > 0) and (PackedSize > 0) do
    begin
      // read code from bit stream
      Inc(Data, SourcePtr^ shl Bits);
      Inc(Bits, 8);
      while Bits >= CodeSize do
      begin
        // current code
        Code := Data and CodeMask;
        // prepare next run
        Data := Data shr CodeSize;
        Dec(Bits, CodeSize);

        // decoding finished?
        if Code = EOICode then
        Break;

        // handling of clear codes
        if Code = ClearCode then
        begin
          // reset of all variables
          CodeSize := FInitialCodeSize + 1;
          CodeMask := (1 shl CodeSize) - 1;
          FreeCode := ClearCode + 2;
          OldCode := NoLZWCode;
          Continue;
        end;

        // check whether it is a valid, already registered code
        if Code > FreeCode then
        Break;

        // handling for the first LZW code: print and keep it
        if OldCode = NoLZWCode then
        begin
          FirstChar := Suffix[Code];
          Target^ := FirstChar;
          Inc(Target);
          Dec(UnpackedSize);
          OldCode := Code;
          Continue;
        end;

        // keep the passed LZW code
        InCode := Code;

        // the first LZW code is always smaller than FFirstCode
        if Code = FreeCode then
        begin
          StackPointer^ := FirstChar;
          Inc(StackPointer);
          Code := OldCode;
        end;

        // loop to put decoded bytes onto the stack
        while Code > ClearCode do
        begin
          StackPointer^ := Suffix[Code];
          Inc(StackPointer);
          Code := Prefix[Code];
        end;

        // place new code into code table
        FirstChar := Suffix[Code];
        StackPointer^ := FirstChar;
        Inc(StackPointer);
        Prefix[FreeCode] := OldCode;
        Suffix[FreeCode] := FirstChar;

        // increase code size if necessary
        if (FreeCode = CodeMask)
        and (CodeSize < 12) then
        begin
          Inc(CodeSize);
          CodeMask := (1 shl CodeSize) - 1;
        end;

        if FreeCode < 4095 then
        Inc(FreeCode);

        // put decoded bytes (from the stack) into the target Buffer
        OldCode := InCode;
        repeat
          Dec(StackPointer);
          Target^ := StackPointer^;
          Inc(Target);
          Dec(UnpackedSize);
        until StackPointer = @Stack;
      end;
      Inc(SourcePtr);
      Dec(PackedSize);
    end;
  end;



  end.
