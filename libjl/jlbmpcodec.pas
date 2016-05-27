  unit jlbmpcodec;

  interface

  uses windows, sysutils, classes, graphics,
  jlcommon, jlraster, jlpalette;

  type

  TJLBitmapCodec = Class(TJLCustomCodec)
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
  // TJLBitmapCodec
  //###########################################################################

  Function TJLBitmapCodec.GetCodecCaps:TJLCodecCaps;
  Begin
    result:=[ccRead,ccWrite];
  end;

  Function TJLBitmapCodec.GetCodecDescription:AnsiString;
  Begin
    result:='Windows Bitmap';
  end;

  Function TJLBitmapCodec.GetCodecExtension:AnsiString;
  Begin
    result:='.bmp';
  end;

  Function TJLBitmapCodec.Eval(Stream:TStream):Boolean;
  var
    FHead:  TBitmapFileHeader;
    FRead:  Integer;
  Begin
    result:=Stream<>NIL;
    If result then
    Begin
      FRead:=0;
      try
        FRead:=Stream.Read(FHead,SizeOf(FHead));
        Result:=FRead=SizeOf(FHead);
        If result then
        result:=FHead.bfType=19778; {"BM"}
      finally
        Stream.Seek(-FRead,soFromCurrent);
      end;
    end;
  end;

  Procedure TJLBitmapCodec.LoadFromStream(Stream:TStream;
            Raster:TJLCustomRaster);
  type
    TBMPMask = Packed Record
      RedMask:    Longword;
      GreenMask:  Longword;
      BlueMask:   Longword;
    End;

  var
    FFileHeader:  TBitmapFileHeader;
    FFileInfo:    TBitmapInfoHeader;
    FAddr:        PByte;
    FRow:         Integer;
    FOrigo:       Int64;
    FColors:      Integer;
    FColItem:     Integer;
    FPalBuffer:   PRGBQuadArray;
    FRLEBuffer:   PByte;
    FRLESize:     Integer;

    FMask:        TBMPMask;
    FTarget:      TJLRasterFormat;
    FCanvas:      TJLRawCanvas;

    procedure DecodeRLE8(pb:PByte);
    var
      x,y,z,i,s: Integer;
    begin
      y:=0;
      x:=0;
      while y<Raster.Height do
      begin
        if pb^=0 then
        begin
          Inc(pb);
          case pb^ of
            0:  begin
                Inc(y);
                x:=0;
                end;
            1: Break;
            2: begin
                Inc(pb); Inc(x,pb^);
                Inc(pb); Inc(y,pb^);
              end;
            else
            begin
              i:=pb^;
              s:=(i+1)and(not 1);
              z:=s-1;
              Inc(pb);
              if x+s>Raster.Width then
              s:=Raster.Width-x;

              (* normal or inverted scanlines? *)
              If FFileInfo.biHeight>0 then
              Move(pb^,Raster.PixelAddr(x,Raster.height-y-1)^,s) else
              Move(pb^,Raster.PixelAddr(x,y)^,s);

              Inc(pb,z);
              Inc(x,i);
            end;
          end;
        end else
        begin
          i:=pb^; Inc(pb);
          if i+x>Raster.Width then
          i:=Raster.Width-x;

          FCanvas.Color:=Raster.Colors[pb^];
          If FFileInfo.biHeight>0 then
          FCanvas.HLine(x,Raster.height-y-1,i) else
          FCanvas.HLine(x,y,i);

          {JL_RxFillRow(Raster.RasterInfo,Raster.height-y-1,x,i,pb^) else
          JL_RxFillRow(Raster.RasterInfo,y,x,i,pb^);}

          Inc(x,i);
        end;
        Inc(pb);
      end;
    end;

  Begin
    If Stream<>NIL then
    Begin
      If Raster<>NIL then
      Begin
        FCanvas:=TJLRawCanvas.Create(Raster);
        try

          (* Release raster if already allocated *)
          If not Raster.Empty then
          Raster.Release;

          FOrigo:=Stream.Position;
          If Stream.Read(FFileheader,SizeOf(FFileheader))=SizeOf(FFileHeader)
          then
          Begin
            if FFileHeader.bfType=19778 then
            Begin

              (* Load the info block *)
              If Stream.Read(FFileInfo,SizeOf(FFileInfo))<>
              SizeOf(FFileInfo) then
              Raise EJLCodec.Create('Failed to read file-info block error');

              FPalBuffer:=NIL;
              //FColors:=0;

              (* OK, let the show begin *)
              Case FFileInfo.biBitCount of
              8:  Begin
                    if FFileInfo.biClrUsed=0 then
                    FColors:=256 else
                    FColors:=FFileInfo.biClrUsed;

                    If JL_DIBAllocColortable(FColors,FPalBuffer) then
                    Begin
                      for FColItem:=1 to FColors do
                      Begin
                        Stream.ReadBuffer(FPalBuffer^[FColItem-1],SizeOf(TRGBQuad));
                        FPalBuffer^[FColItem-1].rgbReserved:=0;
                      end;
                      //Stream.ReadBuffer(FPalBuffer^,SizeOf(TRGBQuad) * FColors);
                    end else
                    Raise EJLCodec.Create('Failed to allocate palette buffer');

                try
                  If not Raster.DefinePalette(FPalBuffer,FColors) then
                  Raise Exception.Create('Failed to apply palette to raster');
                finally
                  Freemem(FPalBuffer);
                end;


                    Raster.Allocate(abs(FFileInfo.biWidth),
                    abs(FFileInfo.biHeight),rf8Bit);


                    If FFileInfo.biCompression=BI_RLE8 then
                    Begin
                      FRLESize:=FFileHeader.bfSize - FFileHeader.bfOffBits;
                      Getmem(FRLEBuffer,FRLESize);
                      If FRLEBuffer<>NIL then
                      Begin
                        try
                          Stream.ReadBuffer(FRLEBuffer^,FRLESize);
                          DecodeRLE8(FRLEBuffer);
                        finally
                          FreeMem(FRLEBuffer);
                        end;
                      end else
                      Raise EJLCodec.Create
                      ('Failed to allocate RLE compression buffer');
                    end;
                  end;
              16: Begin
                    FTarget:=rfNone;
                    If FFileInfo.biCompression=BI_BITFIELDS then
                    Begin
                      Stream.Read(FMask,SizeOf(FMask));
                      if  (FMask.RedMask=$7C00)
                      and (FMask.GreenMask=$03E0)
                      and (FMask.BlueMask=$001F) then
                      FTarget:=rf15Bit else

                      If  (FMask.RedMask=$F800)
                      and (FMask.GreenMask=$07E0)
                      and (FMask.BlueMask=$001F) then
                      FTarget:=rf16Bit;
                    end else
                    If FFileInfo.biCompression=BI_RGB then
                    FTarget:=rf15Bit else
                    FTarget:=rf16Bit;

                    If FTarget>rfNone then
                    Raster.Allocate(abs(FFileInfo.biWidth),
                    abs(FFileInfo.biHeight),FTarget) else
                    Raise EJLCodec.Create('Unknown 555/565 configuration');
                  end;
              24: Begin
                    Raster.Allocate(abs(FFileInfo.biWidth),
                    abs(FFileInfo.biHeight));
                  end;
              32: Begin
                    Raster.Allocate(abs(FFileInfo.biWidth),
                    abs(FFileInfo.biHeight),rf32Bit);
                  end;
              else
                Raise EJLCodec.Create('Can not load bitmap error,'
                +' unknown bitdepth');
              end;

              (* Load the scanlines. This is for the unpacked formats *)
              If FFileInfo.biCompression<>BI_RLE8 then
              Begin
                Stream.Position:=FOrigo + FFileheader.bfOffBits;
                FAddr:=Raster.Scanline[FFileInfo.biHeight-1];
                for FRow:=1 to Raster.Height do
                Begin
                  Stream.Read(FAddr^,Raster.Pitch);
                  dec(FAddr,Raster.Pitch);
                end;
              end;

              { If  (FFileInfo.biBitCount=8)
              and (FPalBuffer<>NIl) then
              Begin
                try
                  If not Raster.DefinePalette(FPalBuffer,FColors) then
                  Raise Exception.Create('Failed to apply palette to raster');
                finally
                  Freemem(FPalBuffer);
                end;
              end;      }

            end else
            Raise EJLCodec.Create('Can not load bitmap error, unknown file signature');
          end else
          Raise EJLCodec.Create('Failed to read file header error');
        finally
          FCanvas.free;
        end;
      end else
      Raise EJLCodec.Create('Invalid target raster, parameter is NIL');
    end else
    Raise EJLCodec.Create('Invalid codec input error, parameter is NIL');
  end;

  Procedure TJLBitmapCodec.SaveToStream(Stream:TStream;
            Raster:TJLCustomRaster);
  type
    TBMPMask = Packed Record
      RedMask:    Longword;
      GreenMask:  Longword;
      BlueMask:   Longword;
    End;

  var
    FMask:    TBMPMask;
    FAddr:    PByte;
    FFileHeader:  TBitmapFileHeader;
    FFileInfo:    TBitmapInfoHeader;
    x:  Integer;
  Begin
    If Stream<>NIL then
    Begin
      If Raster<>NIL then
      Begin
        If not Raster.Empty then
        Begin

          { Prepare info header }
          FFileInfo.biSize:=SizeOf(FFileInfo);
          FFileInfo.biWidth:=Raster.Width;
          FFileInfo.biHeight:=Raster.Height;
          FFileInfo.biPlanes:=1;
          FFileInfo.biXPelsPerMeter:=0;
          FFileInfo.biYPelsPerMeter:=0;
          FFileInfo.biClrUsed:=0;
          FFileInfo.biClrImportant:=0;

          Case Raster.PixelFormat of
          rf8Bit:
            Begin
              FFileInfo.biBitCount:=8;
              If Raster.RasterInfo^.riPalSize>0 then
              Begin
                FFileInfo.biCompression:=BI_RGB;
                FFileInfo.biSizeImage:=Raster.PixelBufferSize;
              end else
              Raise EJLCodec.Create('Failed to obtain palette data error');
            end;
          rf15Bit:
            Begin
              FMask.RedMask:=$7C00;
              FMask.GreenMask:=$03E0;
              FMask.BlueMask:=$001F;
              FFileInfo.biBitCount:=16;
              FFileInfo.biCompression:=BI_BITFIELDS;
            end;
          rf16Bit:
            Begin
              FMask.RedMask:=$F800;
              FMask.GreenMask:=$07E0;
              FMask.BlueMask:=$001F;
              FFileInfo.biBitCount:=16;
            end;
          rf24Bit:  FFileInfo.biBitCount:=24;
          rf32Bit:  FFileInfo.biBitCount:=32;
          end;

          { Prepare file header}
          FFileHeader.bfType:=19778;
          FFileHeader.bfSize:=SizeOf(FFileHeader) + SizeOf(FFileInfo);
          FFileHeader.bfReserved1:=0;
          FFileHeader.bfReserved2:=0;
          FFileHeader.bfOffBits:=SizeOf(FFileHeader) + SizeOf(FFileInfo);

          Case Raster.PixelFormat of
          rf8Bit:
            Begin
              Inc(FFileHeader.bfSize,Raster.RasterInfo^.riPalSize);
              inc(FFileHeader.bfOffBits,Raster.RasterInfo^.riPalSize);
              inc(FFileHeader.bfSize,raster.PixelBufferSize);
            end;
          rf15Bit,rf16Bit:
            Begin
              inc(FFileHeader.bfSize,SizeOf(FMask));
              inc(FFileHeader.bfOffBits,SizeOf(FMask));
            end;
          end;

          try
            (* write file header & Info header *)
            Stream.WriteBuffer(FFileHeader,SizeOf(FFileHeader));
            Stream.WriteBuffer(FFileInfo,SizeOf(FFileInfo));

            (* write mask for 15/16 bit mode *)
            If FFileInfo.biBitCount=16 then
            Stream.WriteBuffer(FMask,SizeOf(FMask)) else

            If FFileInfo.biBitCount=8 then
            Begin
              Stream.Write(Raster.RasterInfo^.riPalData,
              Raster.RasterInfo^.riPalSize);
            end;

            FAddr:=Raster.Scanline[Raster.Height-1];
            for x:=1 to Raster.Height do
            Begin
              Stream.Write(FAddr^,Raster.Pitch);
              dec(FAddr,Raster.Pitch);
            end;

          except
            on e: exception do
            Raise;
          end;

        end;
      end else
      Raise EJLCodec.Create('Invalid target raster, parameter is NIL');
    end else
    Raise EJLCodec.Create('Invalid codec input error, parameter is NIL');
  end;


  end.
