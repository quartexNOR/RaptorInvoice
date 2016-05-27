  unit jlpalette;

  {$I 'jldefs.inc'}

  interface

  uses sysutils, classes, jlcommon, windows,
  graphics;

  type

  TJLPaletteType  = (plNone=0,plNetscape=1,plIndexed,plUser);

  TRGBQuadArray   = Packed Array[0..255] of TRGBQuad;
  PRGBQuadArray   = ^TRGBQuadArray;

  Function  JL_DIBAllocColorTable(Const ACount:Integer;
            out outTable:PRGBQuadArray):Boolean;

  Function  JL_DIBGetColorTableFromDC(Const Handle:HDC;out outCount:Integer;
            out outTable:PRGBQuad):Boolean;

  Function  JL_DIBMakePalette(Const AKind:TJLPaletteType;
            out outCount:Integer;out outTable:PRGBQuadArray):Boolean;

  Function  JL_LogPaletteAlloc(const ACount:Integer;
            out outPalette:PLogPalette):Boolean;

  Function  JL_LogPaletteFree(Const APalette:PLogPalette):Boolean;

  Function  JL_LogPaletteToDIBColorTable(Const APalData:PLogPalette;
            out outDibColorTable:PRGBQuadArray):Boolean;

  Function  JL_LogPaletteSetColor(Const APalette:PLogPalette;
            Const Index:Integer;Value:TColor):Boolean;

  Function  JL_LogPaletteGetColor(Const APalette:PLogPalette;
            Const Index:Integer;out OutColor:TColor):Boolean;

  implementation


  Function  JL_DIBGetColorTableFromDC(Const Handle:HDC;out outCount:Integer;
            out outTable:PRGBQuad):Boolean;
  var
    FSize:  Integer;
    FTemp:  PRGBQuad;
  Begin
    outTable:=NIL;
    outCount:=0;
    result:=Handle<>0;
    If result then
    Begin
      FSize:=SizeOf(TRGBQuad) * 256;
      GetMem(FTemp,FSize);
      result:=FTemp<>NIL;
      If result then
      Begin
        outCount:=GetDIBColorTable(Handle,0,256,FTemp^);
        result:=OutCount>0;
        If result then
        Begin
          If outCount<256 then
          Begin
            FSize:=outCount * SizeOf(TRGBQuad);
            GetMem(outTable,FSize);
            result:=outTable<>NIL;
            If result then
            Begin
              move(FTemp^,outTable^,FSize);
              FreeMem(FTemp);
            end;
          end else
          outTable:=FTemp;
        end else
        FreeMem(FTemp);
      end;
    end;
  end;

  Function  JL_DIBMakePalette(Const AKind:TJLPaletteType;
            out outCount:Integer;out outTable:PRGBQuadArray):Boolean;
  {$I 'userpalette.inc'}
  var
    r,g,b:    Byte;
    FIndex:   Integer;
  Begin
    result:=False;
    outCount:=0;
    outTable:=NIL;
    
    If AKind<>plNone then
    Begin
      Case AKind of
      plNetscape:
        Begin
          if JL_DIBAllocColorTable(216,outTable) then
          Begin
            outCount:=216;
            for r:=0 to 5 do
            for g:=0 to 5 do
            for b:=0 to 5 do
            Begin
              FIndex:=b + g*6 + r*36;
              With outTable^[FIndex] do
              Begin
                rgbRed:=    r * 51;
                rgbGreen:=  g * 51;
                rgbBlue:=   b * 51;
              end;
            end;
            result:=True;
          end;
        end;
      plIndexed:
        Begin
          if JL_DIBAllocColorTable(256,outTable) then
          Begin
            outCount:=256;
            for r:=0 to 7 do
            for g:=0 to 7 do
            for b:=0 to 3 do
            Begin
              FIndex:=b + (g shl 2) + (r shl 5);
              With outTable^[FIndex] do
              Begin
                rgbRed:=    r * 36;
                rgbGreen:=  g * 36;
                rgbBlue:=   b * 84;
              end;
            end;
            result:=True;
          end;
        end;
      plUser:
        Begin
          If JL_DIBAllocColorTable(256,outTable) then
          Begin
            outCount:=256;
            for FIndex:=1 to 256 do
            PLongword(@outTable^[FIndex-1])^:=Default_PAL[FIndex-1];
            result:=True;
          end;
        end;
      end;
    end;
  end;

  Function  JL_LogPaletteAlloc(const ACount:Integer;
            out outPalette:PLogPalette):Boolean;
  var
    FSize:  Integer;
  Begin
    result:=ACount>0;
    If result then
    Begin
      FSize:=SizeOf(TLogPalette) + (ACount * SizeOf(TPaletteEntry));
      outPalette:=Allocmem(FSize);
      Fillchar(outPalette^,FSize,#0);
      outPalette^.palVersion:=$300;
      outPalette^.palNumEntries:=ACount;
    end else
    outPalette:=NIL;
  end;

  Function JL_LogPaletteFree(Const APalette:PLogPalette):Boolean;
  var
    FSize:  Integer;
  Begin
    result:=APalette<>NIL;
    If result then
    Begin
      FSize:=SizeOf(TLogPalette)
      + (APalette^.palNumEntries * SizeOf(TPaletteEntry));
      Fillchar(APalette^,FSize,#0);
      FreeMem(APalette);
    end;
  end;

  Function JL_LogPaletteToDIBColorTable(Const APalData:PLogPalette;
           out outDibColorTable:PRGBQuadArray):Boolean;
  var
    src:    PPaletteEntry;
    x:      Integer;
    FSize:  Integer;
  Begin
    result:=(APalData<>NIL)
    and (APalData^.palVersion=$300)
    and (APalData^.palNumEntries>0);
    If result then
    Begin
      FSize:=SizeOf(TRGBQuad) * APalData^.palNumEntries;
      try
        outDibColorTable:=AllocMem(FSize);
        fillchar(outDibColorTable^,FSize,0);
      except
        on exception do
        Begin
          outDibColorTable:=NIL;
          Result:=False;
          exit;
        end;
      end;

      src:=@APalData^.palPalEntry[0];
      for x:=1 to APalData^.palNumEntries do
      Begin
        with outDibColorTable^[x-1] do
        Begin
          rgbRed:=src^.peRed;
          rgbGreen:=src^.peGreen;
          rgbBlue:=src^.peBlue;
        end;
        inc(src);
      end;
    end else
    outDibColorTable:=NIL;
  end;

  Function  JL_LogPaletteSetColor(Const APalette:PLogPalette;
            Const Index:Integer;Value:TColor):Boolean;
  var
    FEntry: PPaletteEntry;
  Begin
    result:=(APalette<>NIL)
    and (APalette^.palVersion=$300)
    and (APalette^.palNumEntries>0);
    If result then
    Begin
      result:=(Index>=0) and (index<APalette^.palNumEntries);
      if result then
      Begin
        FEntry:=@APalette^.palPalEntry[0];
        inc(FEntry,index);
        If (Value shr 24)=$FF then
        Value:=graphics.ColorToRGB(Value);
        FEntry^.peRed:=GetRValue(Value);
        FEntry^.peGreen:=GetGValue(Value);
        FEntry^.peBlue:=GetBValue(Value);
      end;
    end;
  end;

  Function  JL_LogPaletteGetColor(Const APalette:PLogPalette;
            Const Index:Integer;out OutColor:TColor):Boolean;
  var
    FEntry: PPaletteEntry;
  Begin
    result:=(APalette<>NIL)
    and (APalette^.palVersion=$300)
    and (APalette^.palNumEntries>0);
    If result then
    Begin
      result:=(Index>=0) and (index<APalette^.palNumEntries);
      if result then
      Begin
        FEntry:=@APalette^.palPalEntry[0];
        inc(FEntry,index);
        outColor:=RGB(FEntry^.peRed,FEntry^.peGreen,FEntry^.peBlue);
      end;
    end;
  end;

  Function JL_DIBAllocColorTable(Const ACount:Integer;
           out outTable:PRGBQuadArray):Boolean;
  var
    FSize:  Integer;
  Begin
    result:=False;
    outTable:=NIL;

    If ACount>0 then
    Begin
      FSize:=ACount * SizeOf(TRGBQuad);

      try
        outTable:=AllocMem(FSize);
      except
        on exception do
        exit;
      end;
      
      fillchar(outTable^,FSize,#0);
      result:=True;
    end;
  end;


  end.
