  unit jldibapi;

  interface

  uses windows, sysutils, classes, math, graphics;

  type

  (* PTR to InfoStructure for DIB *)
  PJLDCData = ^TJLDCData;

  PJLDCEvent = ^TJLDCEvent;
  TJLDCEvent = Record
    dcInfo:   PJLDCData;
    dcEvent:  Integer;
    dcObjTag: Integer;
    dcParams: Array[1..3] of Integer;
  End;

  (* Our callback event *)
  TJLDIBCallbackEvent = Procedure (Const EventInfo:PJLDCEvent);

  (* Actual InfoStructure record *)
  TJLDCData = Record
    ddSize:     Integer;
    ddDC:       HDC;
    ddObjTag:   Integer;
    ddWidth:    Integer;
    ddHeight:   Integer;
    ddNewBmp:   HBitmap;
    ddOldBmp:   HBitmap;
    ddFormat:   Integer;
    ddPitch:    Integer;
    ddDataLen:  Integer;
    ddData:     Pointer;
    ddPalType:  Integer;
    ddInfo:     PBitmapInfo;
    ddUserData: Pointer;
  End;

  Const
  DIB_FORMAT_None   = 0;
  DIB_FORMAT_8BIT   = 1;
  DIB_FORMAT_15Bit  = 2;
  DIB_FORMAT_16Bit  = 3;
  DIB_FORMAT_24Bit  = 4;
  DIB_FORMAT_32Bit  = 5;

  DIB_PALETTE_NONE      = 0;
  DIB_PALETTE_NETSCAPE  = 1;
  DIB_PALETTE_INDEXED   = 2;
  DIB_PALETTE_USER      = 3;

  Function  JLDibAllocate(Const Width,Height:Integer;
            out outData:PJLDCData;
            AFormat:Integer=DIB_FORMAT_24Bit;
            APalette:Integer=DIB_PALETTE_NETSCAPE;
            ObjTag:Integer=0;
            Const CompatibleDC:HDC=0):Integer;

  Function  JLDibRelease(Const Data:PJLDCData):Integer;

  Function  JLDibSetUserData(Const DibInfo:PJLDCData;
            Const UserData:Pointer):Integer;

  Function  JLDibGetUserData(Const DibInfo:PJLDCData;
            out UserData:Pointer):Integer;

  Function  JLDibValid(Const DibInfo:PJLDCData;
            out outErr:Integer):Boolean;

  Function  JLDibGetStride(Const Value,ElementSize:Integer;
            Const AlignSize:Integer=4):Integer;
  Function  JLDibGetPixelBits(Const AFormat:Integer):Integer;
  Function  JLDibGetPixelBytes(Const AFormat:Integer):Integer;


  implementation

  var
  _PxBits:  Array[DIB_FORMAT_None..DIB_FORMAT_32Bit] of Integer
            =(0,8,15,16,24,32);

  _PxBytes: Array[DIB_FORMAT_None..DIB_FORMAT_32Bit] of Integer
            = (0,1,2,2,3,4);

  _PalColCount: Array[DIB_PALETTE_NONE..DIB_PALETTE_USER] of Integer
            = (0,   { No palette }
              216,  { Netscape 216 colours }
              256,  { Indexed 256 colours }
              256  { user 256 colours  }
              );

  Const
  ERR_DIB_NOERROR                   = 0;
  ERR_DIB_BASE                      = 1024;
  ERR_DIB_INFO_ISNIL                = ERR_DIB_BASE + 1;
  ERR_DIB_INFO_NOTVALID             = ERR_DIB_BASE + 2;
  ERR_DIB_WIDTH_INVALID             = ERR_DIB_BASE + 3;
  ERR_DIB_HEIGHT_INVALID            = ERR_DIB_BASE + 4;
  ERR_DIB_CREATE_DC_FAILED          = ERR_DIB_BASE + 5;
  ERR_DIB_CREATE_DIBSECTION_FAILED  = ERR_DIB_BASE + 6;
  ERR_DIB_CREATE_BITMAPINFO_FAILED  = ERR_DIB_BASE + 7;
  ERR_DIB_PALETTE_INVALID_COLOURS   = ERR_DIB_BASE + 8;
  ERR_DIB_FORMAT_INVALID            = ERR_DIB_BASE + 9;



  Function  JLDibGetPixelBytes(Const AFormat:Integer):Integer;
  Begin
    if AFormat in [DIB_FORMAT_None..DIB_FORMAT_32Bit] then
    result:=_PxBytes[AFormat] else
    result:=0;
  end;

  Function JLDibGetPixelBits(Const AFormat:Integer):Integer;
  Begin
    if AFormat in [DIB_FORMAT_None..DIB_FORMAT_32Bit] then
    result:=_PxBits[AFormat] else
    result:=0;
  end;

  Function  JLDibGetStride(Const Value,ElementSize:Integer;
            Const AlignSize:Integer=4):Integer;
  Begin
    Result:=Value * ElementSize;
    If (Result mod AlignSize)>0 then
    result:=( (Result + AlignSize) - (Result mod AlignSize) );
  end;

  Function JLDibValid(Const DibInfo:PJLDCData;
           out outErr:Integer):Boolean;
  Begin
    result:=(DibInfo<>NIL);
    if result then
    Begin
      result:=(DibInfo^.ddSize=SizeOf(TJLDCData));
      if not result then
      outErr:=ERR_DIB_INFO_NOTVALID else
      outErr:=ERR_DIB_NOERROR;
    end else
    outErr:=ERR_DIB_INFO_ISNIL;
  end;

  Function JLDibSetUserData(Const DibInfo:PJLDCData;
           Const UserData:Pointer):Integer;
  Begin
    if JLDibValid(DibInfo,result) then
    DibInfo^.ddUserData:=UserData;
  end;

  Function  JLDibGetUserData(Const DibInfo:PJLDCData;
            out UserData:Pointer):Integer;
  Begin
    if JLDibValid(DibInfo,result) then
    userData:=DibInfo^.ddUserData;
  end;

  Function  JLDibAllocate(Const Width,Height:Integer;
            out outData:PJLDCData;
            AFormat:Integer=DIB_FORMAT_24Bit;
            APalette:Integer=DIB_PALETTE_NETSCAPE;
            ObjTag:Integer=0;
            Const CompatibleDC:HDC=0):Integer;
  Const
    BitComp: Array[DIB_FORMAT_8Bit..DIB_FORMAT_32Bit] of Integer
    = (BI_RGB,BI_BITFIELDS,BI_BITFIELDS,BI_RGB,BI_RGB);
  var
    FDC:      HDC;
    FBitmap:  HBitmap;
    FDInfo:   PBitmapInfo;
    FSize:    Integer;
    FFace:    PLongword;
    FBuffer:  Pointer;
    FCount:   Integer;
  Begin
    If Width>0 then
    Begin
      if Height>0 then
      Begin
        if (AFormat in [DIB_FORMAT_8Bit..DIB_FORMAT_32Bit]) then
        Begin

          (* default to positive *)
          result:=ERR_DIB_NOERROR;

          (* Ensure palette type *)
          if AFormat<>DIB_FORMAT_8Bit then
          APalette:=DIB_PALETTE_NONE;

          (* Allocate Device context *)
          FDC:=CreateCompatibleDC(CompatibleDC);
          if FDC<>0 then
          Begin

            (* Calculate size of BitmapInfo structure *)
            If AFormat=DIB_FORMAT_8Bit then
            Begin
              (* Get number of colors in palette *)
              FCount:=_PalColCount[APalette];
              If FCount<1 then
              Begin
                (* Invalid palette *)
                result:=ERR_DIB_PALETTE_INVALID_COLOURS;
                DeleteDC(FDC);
                exit;
              end else
              FSize:=SizeOf(TBitmapInfo) + (FCount * SizeOf(DWord));
            end else
            FSize:=SizeOf(TBitmapInfo) + (002 * SizeOf(DWord));

            (* Allocate bitmapinfo *)
            try
              FDInfo:=Allocmem(FSize);
            except
              on e: exception do
              Begin
                result:=ERR_DIB_CREATE_BITMAPINFO_FAILED;
                DeleteDC(FDC);
                exit;
              end;
            end;

            (* Populate info header  *)
            FDInfo^.bmiHeader.biSize:=FSize;
            FDInfo^.bmiHeader.biBitCount:=_PxBits[AFormat];
            FDInfo^.bmiHeader.biPlanes:=1;
            FDInfo^.bmiHeader.biWidth:=Width;
            FDInfo^.bmiHeader.biHeight:=-abs(Height);
            FDInfo^.bmiHeader.biCompression:=BitComp[AFormat];

            FFace:=@FDInfo^.bmiColors[0];
            case AFormat of
            DIB_FORMAT_8Bit:
              Begin
                Case APalette of
                DIB_PALETTE_NONE:
                  Begin
                  end;
                DIB_PALETTE_NETSCAPE:
                  Begin
                  end;
                DIB_PALETTE_INDEXED:
                  Begin
                  end;
                DIB_PALETTE_USER:
                  Begin
                  end;
                end;
              end;
            DIB_FORMAT_15Bit:
              begin
                FDInfo^.bmiHeader.biBitCount:=16;
                FFace^:=$7C00; inc(FFace);
                FFace^:=$03E0; inc(FFace);
                FFace^:=$03E0;
              end;
            DIB_FORMAT_16Bit:
              begin
                FFace^:=$F800; inc(FFace);
                FFace^:=$07E0; inc(FFace);
                FFace^:=$001F;
              end;
            end;

            (* Allocate DIB section *)
            FBitmap:=CreateDibSection(0,FDInfo^,DIB_RGB_COLORS,FBuffer,0,0);
            If FBitmap=0 then
            Begin
              result:=ERR_DIB_CREATE_DIBSECTION_FAILED;
              //[SysErrorMessage(windows.GetLastError)]);
              DeleteDC(FDC);
              FreeMem(FDInfo);
              exit;
            end;

            Getmem(outData,SizeOf(TJLDCData));
            if outData<>NIl then
            Begin
              Fillchar(outData^,SizeOf(TJLDCData),#0);
              outData^.ddSize:=SizeOf(TJLDCData);
              outData^.ddDC:=FDC;
              outData^.ddWidth:=Width;
              outData^.ddHeight:=Height;
              outData^.ddObjTag:=ObjTag;
              outData^.ddNewBmp:=FBitmap;
              outData^.ddOldBmp:=SelectObject(FDC,FBitmap);
              outData^.ddPitch:=JLDibGetStride(Width,_PxBytes[AFormat]);
              outData^.ddDataLen:=(outData^.ddPitch * Width);
              outData^.ddData:=FBuffer;
              outData^.ddInfo:=FDInfo;
              outData^.ddFormat:=AFormat;
              outData^.ddPalType:=APalette;
            end else
            Begin
              DeleteObject(FBitmap);
              DeleteDC(FDC);
              FreeMem(FDInfo);
            end;

          end else
          result:=ERR_DIB_CREATE_DC_FAILED;
        end else
        result:=ERR_DIB_FORMAT_INVALID;
      end else
      result:=ERR_DIB_HEIGHT_INVALID;
    end else
    result:=ERR_DIB_WIDTH_INVALID;
  end;

  Function  JLDibRelease(Const Data:PJLDCData):Integer;
  Begin
    if JLDibValid(Data,result) then
    Begin
      try
        If (Data^.ddDC<>0) and (Data^.ddDataLen>0) then
        Begin
          SelectObject(Data^.ddDC,Data^.ddOldBmp);
          DeleteObject(Data^.ddNewBmp);
          DeleteDC(Data^.ddDC);
        end;

        if Data^.ddInfo<>NIl then
        Freemem(Data^.ddInfo);
      finally
        Fillchar(Data^,SizeOf(TJLDCData),#0);
        FreeMem(Data);
      end;
    end;
  end;


  end.
