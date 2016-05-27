  unit jlraster;

  {$I 'jldefs.inc'}

  interface

  {$DEFINE USE_BETA}

  uses windows, sysutils, classes, math, graphics,
  jlcommon, jldatabuffer, jlpalette, jldibapi;

  (* To-Do:
     -More GetCodec functions, f.ex by extension
     -Codec input & output string generators (file filters)
     -Add PNG codecs (use delphi's JPG unit this time)
     -Transfer the other drawing operation to TJLRawCanvas
     -Add Native win32 font support (drop the bitmap fonts)
     -Finally create shapes and brush painting support
  *)

  Const
  ERR_JL_RASTER_EMPTY
  = 'The surface object is empty error';

  type

  EJLCodec        = Class(Exception);
  EJLCustomRaster = Class(Exception);
  EJLRasterCanvas = Class(Exception);

  TJLCustomRaster = Class;
  TJLCustomCodec  = Class;
  TJLDIBRaster    = Class;
  TJLUNIRaster    = Class;
  TJLRawCanvas    = Class;
  TJLCodecClass   = Class of TJLCustomCodec;


  TJLRasterFormat = (rfNone=0,rf8Bit,rf15Bit,rf16Bit,rf24Bit,rf32Bit);
  TJLCodecCaps    = Set of (ccRead,ccWrite);
  TJLPenMode      = (pmCopy,pmBlend);

  TJLRasterCloneOptions = set of (coPalette,coSize,coContent);

  PJLRasterInfo = ^TJLRasterInfo;
  TJLRasterInfo = Record
    riSize:         Integer;
    riFormat:       TJLRasterFormat;
    riEmpty:        Boolean;
    riWidth:        Integer;
    riHeight:       Integer;
    riPitch:        Integer;
    riPxBuffer:     Pointer;
    riPxBufferSize: Integer;
    riPixelBytes:   Integer;
    riPixelBits:    Integer;
    riBoundsRect:   TRect;
    riClipRect:     TRect;
    riClipped:      Boolean;
    riPenMode:      TJLPenMode;
    riPenAlpha:     Byte;
    riTransparent:  Boolean;
    riTransColor:   TColor;
    riTransIndex:   Byte;
    riPalMatchMode: TJLPaletteType;
    riPalData:      TRGBQuadArray;
    riPalCnt:       Integer;
    riPalSize:      Integer;
    riNative:       Longword;
    riColor:        TColor;
    riUseExcept:    Boolean;
    riLastError:    Array[1..512] of AnsiChar;
  End;

  TJLRegionProc = Procedure(Const Info:PJLRasterInfo;
                  Const Region:TRect;Const inData);cdecl;

  {
  TJLColProc  =   Procedure(Const Info:PJLRasterInfo;Const Col:Integer;
                  Row,inCount:Integer;Const inData);cdecl;

  TJLRowProc  =   Procedure(Const Info:PJLRasterInfo;Const Row:Integer;
                  Col,inCount:Integer;Const inData);cdecl;
  }

  PJLBlitOperation = ^TJLBlitOperation;
  TJLBlitOperation = Record
    boSource:   PJLRasterInfo;
    boTarget:   PJLRasterInfo;
    boWidth:    Integer;
    boHeight:   Integer;
    boSrcRect:  TRect;
    boDstRect:  TRect;
    boSrcAddr:  PByte;
    boDstAddr:  PByte;
  End;


  TJLBlitProc = Procedure (const Operation:PJLBlitOperation);register;

  TJLCustomCodec = Class(TObject)
  Protected
    Function    GetCodecCaps:TJLCodecCaps;virtual;abstract;
    Function    GetCodecDescription:AnsiString;virtual;abstract;
    Function    GetCodecExtension:AnsiString;virtual;abstract;
  Public
    Function    Eval(Stream:TStream):Boolean;Virtual;abstract;
    Procedure   LoadFromStream(Stream:TStream;
                Raster:TJLCustomRaster);virtual;abstract;
    Procedure   SaveToStream(Stream:TStream;
                Raster:TJLCustomRaster);virtual;abstract;
  public
    Property    Description:AnsiString read GetCodecDescription;
    Property    Extension:AnsiString read GetCodecExtension;
    Property    CoCaps:TJLCodecCaps read GetCodecCaps;
  End;

  TJLCustomRaster = Class(TJLCommonComponent)
  Private
    FInfo:          TJLRasterInfo;
    FInfoRef:       PJLRasterInfo;
    FUpdateCnt:     Integer;
    FCanvas:        TJLRawCanvas;
    FOnBeforeAlloc: TNotifyEvent;
    FOnAfterAlloc:  TNotifyEvent;
    FOnBeforeRelease:TNotifyEvent;
    FOnAfterRelease:TNotifyEvent;
    FOnPalColorChange: TNotifyEvent;
    FOnUpdateBegins:TNotifyEvent;
    FOnUpdateEnds:  TNotifyEvent;
  Private
    Procedure   SetClipRect(Value:TRect);
    Function    GetScanLn(Const Index:Integer):Pointer;
    Function    GetPalColor(Const Index:Integer):TColor;
    Procedure   SetPalColor(Const Index:Integer;Value:TColor);
    Procedure   SetTransparentColor(Value:TColor);
    Procedure   SetTransparent(Const Value:Boolean);
  Protected
    Procedure   SignalBeforeAlloc;dynamic;
    Procedure   SignalAfterAlloc;dynamic;
    Procedure   SignalBeforeRelease;dynamic;
    procedure   SignalAfterRelease;dynamic;
    procedure   SignalPalColorChange;dynamic;
    Procedure   SignalUpdateBegins;dynamic;
    procedure   SignalUpdateEnds;dynamic;
  Protected
    Procedure   SetLastError(Const Value:String);
    Procedure   ResetLastError;
    Function    MakeCanvas(out Canvas:TJLRawCanvas):Boolean;
    Procedure   SetUseExceptions(Value:Boolean);
    Function    GetCanvas:TJLRawCanvas;

    Function    DoAllocPixels(Const AWidth,AHeight:Integer;
                Const AFormat:TJLRasterFormat;
                var outBuffer:Pointer;var outPitch:Integer;
                var outBufSize:Integer):Boolean;virtual;abstract;
    Function    DoReleasePixels(Const inBuffer:Pointer):Boolean;virtual;abstract;

    Function    DoHasPalette:Boolean;

    Procedure   DoReleasePalette;virtual;
  Protected
    (* Extended persistency inherited from TJLComponentCustom *)
    Function    ObjectHasData:Boolean;Override;
    Procedure   ReadObject(Const Reader:TJLReader);override;
    Procedure   WriteObject(Const Writer:TJLWriter);override;
  Public
    Property    Scanline[Const Index:Integer]:Pointer read GetScanLn;
    Property    RasterInfo:PJLRasterInfo read FInfoRef;
    Property    PixelFormat:TJLRasterFormat read FInfo.riFormat;
    Property    PixelBuffer:Pointer read FInfo.riPxBuffer;
    Property    PixelBufferSize:Integer read FInfo.riPxBufferSize;
    Property    PixelSize:Integer read FInfo.riPixelBytes;
    Property    PixelBits:Integer read FInfo.riPixelBits;
    Property    Empty:Boolean read FInfo.riEmpty;
    Property    Pitch:Integer read FInfo.riPitch;
    Property    Width:Integer read FInfo.riWidth;
    Property    Height:Integer read FInfo.riHeight;
    Property    BoundsRect:TRect read FInfo.riBoundsRect;
    Property    ClipRect:TRect read FInfo.riClipRect
                Write SetClipRect;
    Property    Clipped:Boolean read FInfo.riClipped;

    Property    Canvas:TJLRawCanvas read GetCanvas;

    Function    LoadFromStream(Const Stream:TStream):Boolean;
    Function    LoadFromFile(Const Filename:String):Boolean;
    Function    LoadFromBuffer(Const Buffer:TJLBufferCustom):Boolean;

    Function    SaveToStream(Const Stream:TStream;
                Codec:TJLCustomCodec):Boolean;
    Function    SaveToFile(Const Filename:String;
                Codec:TJLCustomCodec):Boolean;
    Function    SaveToBuffer(Const Buffer:TJLBufferCustom;
                Codec:TJLCustomCodec):Boolean;

    { Property    PaletteType:TJLPaletteType
                read FInfo.riPalKind write SetPaletteType; }

    Property    PaletteAllocated:Boolean read DoHasPalette;
    Property    Colors[Const Index:Integer]:TColor
                read GetPalColor write SetPalColor;
    Property    ColorCount:Integer read FInfo.riPalCnt;

    Property    TransparentColor:TColor
                read FInfo.riTransColor write SetTransparentColor;
    Property    Transparent:Boolean
                read FInfo.riTransparent write SetTransparent;

    Function    Clone(Const AOptions:
                TJLRasterCloneOptions=[]):TJLCustomRaster;virtual;abstract;
    Function    ReMap(Const APalType:TJLPaletteType):TJLCustomRaster;
    Function    UpdatePalette:Boolean;
    Function    PixelAddr(Const Col,Row:Integer):Pointer;

    Procedure   Assign(Source:TPersistent);Override;

    Function    IsUpdating:Boolean;
    Function    BeginUpdate:Boolean;
    Procedure   EndUpdate;

    Function    GetLastError:String;

    Function    DefinePalette(Const Colors:PRGBQuadArray;
                Const Count:Integer):Boolean;overload;virtual;
    Function    DefinePalette(Const Kind:TJLPaletteType):Boolean;overload;virtual;

    //Function    MakeTempDC(out Value:PJLDCData):Boolean;
    Function    MakeStream(out Stream:TStream):Boolean;

    Function    Allocate(AWidth:Integer;AHeight:Integer;
                Const AFormat:TJLRasterFormat=rf24Bit):Boolean;
    Procedure   AdjustToBoundsRect(Var Value:TRect);
    Procedure   AdjustToClipRect(var Value:TRect);
    Function    AdjustToClipRectEx(var Value:TRect):Boolean;
    Procedure   RemoveClipRect;
    Function    Release:Boolean;

    Procedure   BeforeDestruction;override;
    Constructor Create(AOwner:TComponent);override;
    Destructor  Destroy;Override;
  Public
    Property    OnBeforeAllocate:TNotifyEvent
                read FOnBeforeAlloc write FOnBeforeAlloc;

    Property    OnAfterAlloc:TNotifyEvent
                Read FOnAfterAlloc write FOnAfterAlloc;

    Property    OnBeforeRelease:TNotifyEvent
                read FOnBeforeRelease write FOnBeforeRelease;

    Property    OnAfterRelease:TNotifyEvent
                read  FOnAfterRelease write FOnAfterRelease;

    Property    OnPalColorChanged:TNotifyEvent
                read FOnPalColorChange write FOnPalColorChange;

    Property    OnUpdateBegins:TNotifyEvent
                read FOnUpdateBegins write FOnUpdateBegins;

    Property    OnUpdateEnds:TNotifyEvent
                read FOnUpdateEnds write FOnUpdateEnds;
  Published
    Property    UseExceptions:Boolean read FInfo.riUseExcept
                write SetUseExceptions;
  End;

  TJLUNIRaster = Class(TJLCustomRaster)
  Protected
    Function    DoAllocPixels(Const AWidth,AHeight:Integer;
                Const AFormat:TJLRasterFormat;var outBuffer:Pointer;
                var outPitch:Integer;var outBufSize:Integer):Boolean;override;
    Function    DoReleasePixels(Const inBuffer:Pointer):Boolean;override;
  Public
    Function    Clone(Const AOptions:
                TJLRasterCloneOptions=[]):TJLCustomRaster;override;
  End;

  TJLDIBRaster = Class(TJLCustomRaster)
  Private
    FDC:        HDC;
    FBitmap:    HBitmap;
    FDInfo:     PBitmapInfo;
    FOldBmp:    HBitmap;
    Procedure   ReleaseDevContext(var DeviceContext:HDC);
  Protected
    Function    DoAllocPixels(Const AWidth,AHeight:Integer;
                Const AFormat:TJLRasterFormat;var outBuffer:Pointer;
                var outPitch:Integer;var outBufSize:Integer):Boolean;override;
    Function    DoReleasePixels(Const inBuffer:Pointer):Boolean;override;
  Public
    Property    DC:HDC read FDC;
    Function    Clone(Const AOptions:
                TJLRasterCloneOptions=[]):TJLCustomRaster;override;

    Function    DefinePalette(Const Colors:PRGBQuadArray;
                Const Count:Integer):Boolean;override;

    Function    DefinePalette(Const Kind:TJLPaletteType):Boolean;override;

    Procedure   Assign(Source:TPersistent);Override;
  End;

  TJLGraphicWrapper = Class(TGraphic)
  Private
    FRaster:    TJLCustomRaster;
    wd,hd:      Integer;
    FFormat:    TJLRasterFormat;
    Procedure   RealizeRaster;
    Procedure   SetFormat(Value:TJLRasterFormat);
  Protected
    procedure   SetHeight(Value:Integer);override;
    procedure   SetWidth(Value:Integer);override;
    function    GetWidth:Integer;override;
    function    GetHeight:Integer;override;
    function    GetEmpty:Boolean;override;
  Protected
    procedure   Draw(ACanvas:TCanvas; const Rect:TRect);override;
  Public
    Property    PixelFormat:TJLRasterFormat read FFormat write SetFormat;
    procedure   LoadFromStream(Stream: TStream);override;
    procedure   SaveToStream(Stream: TStream);override;

    procedure   LoadFromClipboardFormat(AFormat:Word;AData:THandle;
                APalette:HPALETTE);override;

    procedure   SaveToClipboardFormat(var AFormat:Word;var AData:THandle;
                var APalette:HPALETTE);override;

    Constructor Create(Raster:TJLCustomRaster);reintroduce;
    Destructor  Destroy;Override;
  End;

  TJLRawCanvas = Class(TObject)
  Private
    FParent:    TJLCustomRaster;
    FInfo:      PJLRasterInfo;
    Function    GetAlpha:Byte;
    Procedure   SetAlpha(Const Value:Byte);
    Function    GetPenMode:TJLPenMode;
    Function    GetColor:TColor;
    Procedure   SetColor(Const Value:TColor);
    Procedure   SetPenMode(Const Value:TJLPenMode);
    Function    GetBoundsRect:TRect;
    Function    GetWidth:Integer;
    Function    GetHeight:Integer;
    Function    GetClipRect:TRect;
    Function    GetIsClipped:Boolean;
  Protected
    Function    ValidSurface(const Info:PJLRasterInfo):Boolean;
  Public
    Property    Parent:TJLCustomRaster read FParent;
    Property    PenMode:TJLPenMode read GetPenMode write SetPenMode;
    Property    PenAlpha:Byte read GetAlpha write SetAlpha;
    Property    Color:TColor read GetColor write SetColor;
    Function    GetPixel(Const Col,Row:Integer):TColor;
    Property    BoundsRect:TRect read GetBoundsRect;
    Property    ClipRect:TRect read GetClipRect;
    Property    Clipped:Boolean read GetIsClipped;
    Property    Width:Integer read GetWidth;
    Property    Height:Integer read GetHeight;

    Procedure   SetClipRect(ARect:TRect);
    procedure   RemoveClipRect;
    Procedure   AdjustToClipRect(var aRect:TRect);

    Procedure   SetPixel(Const Col,Row:Integer);overload;
    Procedure   SetPixel(Const Col,Row:Integer;AColor:TColor);overload;

    Procedure   FillRect(ARect:TRect);overload;
    Procedure   FillRect(ARect:TRect;Const AColor:TColor);overload;

    Procedure   VLine(Col,Row:Integer;ACount:Integer);
    Procedure   HLine(Col,Row:Integer;ACount:Integer);

    Procedure   Line(Left,Top,Right,Bottom:Integer);

    Procedure   Draw(Target:TJLCustomRaster;srcRect:TRect;
                dstX,dstY:Integer);overload;
    Procedure   Draw(Target:TJLCustomRaster;dstX,dstY:Integer);Overload;
    Procedure   Draw(Target:HDC;dstX,dstY:Integer);Overload;

    (* Stretchdraw support *)
    Procedure   Draw(Target:TJLCustomRaster;srcRect:TRect;
                dstRect:TRect;Options:Integer);overload;

    Procedure   Draw(Target:HDC;srcRect:TRect;
                dstRect:TRect;Options:Integer);overload;

    Constructor Create(Const Raster:TJLCustomRaster);
  End;


  Function  JL_MatchColor(Const Info:PJLRasterInfo;
            R,G,B:Byte):Byte;overload;

  Function  JL_MatchColor(Const Info:PJLRasterInfo;
            Const Value:TColor):Byte;Overload;

  Function  JL_MatchColor(Const Info:PJLRasterInfo;
            Const Value:TRGBTriple):Byte;overload;

  Function  JL_MatchColor(Const Info:PJLRasterInfo;
            Const Value:TRGBQuad):Byte;overload;

  Function  JL_RegisterCodec(Const Codec:TJLCustomCodec):Boolean;

  Function  JL_FindCodecFor(Const Stream:TStream;
            out outCodec:TJLCustomCodec):Boolean;overload;

  Function  JL_FindCodecFor(Const Buffer:TJLBufferCustom;
            out outCodec:TJLCustomCodec):Boolean;overload;

  Function  JL_FindCodecFor(Const Filename:String;
            out outCodec:TJLCustomCodec):Boolean;overload;

  Function  JL_GetCodecByClass(Const AClass:TJLCodecClass;
            out outCodec:TJLCustomCodec):Boolean;

  { Function  JL_DibMake(Const Width,Height:Integer;
            AFormat:TJLRasterFormat;
            out outData:PJLDCData;
            out outError:AnsiString;
            Const CompatibleDC:HDC=0):Boolean;

  Function  JL_DibRelease(Const Data:PJLDCData;
            out outError:AnsiString):Boolean;      }

  { Function  JL_DibFromRaster(Const Data:PJLDCData;
            Const Raster:TJLCustomRaster;
            out outError:AnsiString):Boolean;

  Function  JL_DibToRaster(Const Data:PJLDCData;
            Const Raster:TJLCustomRaster;
            out outError:AnsiString):Boolean;    }

  { Function  JL_RxGetPenColor(Const Info:PJLRasterInfo;
            out outValue:TColor):Boolean; }

  { Function  JL_RxSetPenColor(Const Info:PJLRasterInfo;
            Const Value:TColor):Boolean;  }

  { Function  JL_RxSetPenMode(Const Info:PJLRasterInfo;
            Const Value:TJLPenMode):Boolean;    }

  { Function  JL_RxGetPenMode(Const Info:PJLRasterInfo;
            out Value:TJLPenMode):Boolean;    }

  { Function  JL_RxSetPenAlpha(Const Info:PJLRasterInfo;
            Const Value:Byte):Boolean; }

  { Function  JL_RxGetPenAlpha(Const Info:PJLRasterInfo;
            out outValue:Byte):Boolean; }

  { Function  JL_RxFillRect(Const Info:PJLRasterInfo;
            ARect:TRect):Boolean;overload;

  Function  JL_RxFillRect(Const Info:PJLRasterInfo;ARect:TRect;
            Const AColor:TColor):Boolean;overload; }

  { Function  JL_RxAdjustToBoundsRect(Const Info:PJLRasterInfo;
            var Value:TRect):Boolean; }

  //Function  JL_RxSetClipRect(Const Info:PJLRasterInfo;Value:TRect):Boolean;
  //Function  JL_RxRemoveClipRect(Const Info:PJLRasterInfo):Boolean;

  Procedure JL_RxSetLastError(Const Info:PJLRasterInfo;
            Value:AnsiString);

  implementation

  uses jlbmpcodec, jlgifcodec, jljpgCodec;

  (* forward declarations *)
  Procedure _RegionByte(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;forward;
  Procedure _RegionWord(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;forward;
  Procedure _RegionTriple(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;forward;
  Procedure _RegionLong(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;forward;

  Procedure _BlendPixel(Const Info:PJLRasterInfo;
            Const thisPixel,thatPixel;Const Factor:Byte;
            out outPixel);forward;

  Procedure _ColorToNative(Const Info:PJLRasterInfo;
            Color:TColor;out outNative);forward;

  Procedure _NativeToColor(Const Info:PJLRasterInfo;
            Const InData;out outColor:TColor);forward;

  Procedure _FillCol(Const Info:PJLRasterInfo;Const Col:Integer;
            Row,inCount:Integer;Const inData);forward;

  Procedure _FillRow(Const Info:PJLRasterInfo;Const Row:Integer;
            Col,inCount:Integer;Const inData);forward;

  Procedure _FillRegion(Const Info:PJLRasterInfo;
            Region:TRect;var inData);forward;

  Procedure _ReadPixel(Const Info:PJLRasterInfo;
            Const Col,Row:Integer;out outData);forward;

  Procedure _WritePixel(Const Info:PJLRasterInfo;
            Const Col,Row:Integer;Const inData);forward;

  var
  _rkPxBytes: Array[rfNone..rf32Bit] of Integer
              = (0,1,2,2,3,4);

  _rkPxBits:  Array[rfNone..rf32Bit] of Integer
              =(0,8,15,16,24,32);

  _rkRegion:  Array[rf8Bit..rf32Bit] of TJLRegionProc
              =(_RegionByte,_RegionWord,_RegionWord,
              _RegionTriple,_RegionLong);

  _rkCopyLut: Array[rf8Bit..rf32Bit,rf8Bit..rf32Bit] of
              TJLBlitProc;

  _Codecs:    Array of TJLCustomCodec;

  {Function  JL_DibToRaster(Const Data:PJLDCData;
            Const Raster:TJLCustomRaster;
            out outError:AnsiString):Boolean;
  Begin
    result:=Data<>NIL;
    If result then
    Begin
      Result:=Data^.ddSize=SizeOf(TJLDCData);
      if result then
      Begin
        Result:=Raster<>NIL;
        if result then
        Begin

          If (Raster is TJLDibRaster) then
          Begin
            //
          end else
          if (Raster is TJLUniRaster) then
          Begin
            //
          end;

        end else
        outError:='Invalid raster error, parameter is NIL';
      end else
      outError:='Unknown or invalid infostructure header error';
    end else
    outError:='Infostructure pointer is NIL error';
  end;

  Function  JL_DibFromRaster(Const Data:PJLDCData;
            Const Raster:TJLCustomRaster;
            out outError:AnsiString):Boolean;
  var
    FRes:   Integer;
    FTemp:  PJLDCData;
  Begin
    result:=Data<>NIL;
    If result then
    Begin
      Result:=Data^.ddSize=SizeOf(TJLDCData);
      if result then
      Begin
        Result:=Raster<>NIL;
        if result then
        Begin
          result:=Raster.Empty=False;
          If result then
          Begin
            If (Raster.Width<>Data^.ddWidth)
            or (Raster.Height<>Data^.ddHeight) then
            Begin
              result:=JL_DibMake(Raster.width,Raster.Height,
              FTemp,outError,ord(Raster.PixelFormat),Data^.ddDC);
              If result then
              Begin
                try
                  If FTemp^.ddFormat=DIB_FORMAT_8Bit then
                  FRes:=windows.SetDIBits(FTemp^.ddDC,FTemp^.ddNewBmp,
                  0,Raster.Height,Raster.PixelBuffer,
                  FTemp^.ddInfo^,DIB_PAL_COLORS) else

                  FRes:=windows.SetDIBits(0,FTemp^.ddNewBmp,0,Raster.Height,
                  Raster.PixelBuffer,FTemp^.ddInfo^,DIB_RGB_COLORS);

                  If FRes<>0 then
                  Begin
                    bitblt(Data^.ddDC,0,0,Data^.ddWidth,Data^.ddHeight,
                    FTemp^.ddDC,0,0,srccopy);
                  end else
                  outError:=Format('SetDIBits failed with "%s"',
                  [SysErrorMessage(windows.GetLastError)]);
                finally
                  JL_DibRelease(FTemp,outError);
                end;
              end;
            end else
            Begin
              If Data^.ddFormat=DIB_FORMAT_8Bit then
              FRes:=windows.SetDIBits(Data^.ddDC,Data^.ddNewBmp,
              0,Raster.Height,Raster.PixelBuffer,
              Data^.ddInfo^,DIB_PAL_COLORS) else
              FRes:=windows.SetDIBits(0,Data^.ddNewBmp,0,Raster.Height,
              Raster.PixelBuffer,Data^.ddInfo^,DIB_RGB_COLORS);
              if FRes=0 then
              outError:=Format('SetDIBits failed with "%s"',
              [SysErrorMessage(windows.GetLastError)]);
            end;
          end else
          outError:='The raster has no data error';
        end else
        outError:='Invalid raster error, parameter is NIL';
      end else
      outError:='Unknown or invalid infstructure header error';
    end else
    outError:='Infostructure pointer is NIL error';
  end;           }

  //###########################################################################
  // TJLDIBRaster
  //###########################################################################

  Function TJLDIBRaster.Clone(Const AOptions:
           TJLRasterCloneOptions=[]):TJLCustomRaster;
  var
    FTemp:  TRGBQuadArray;
  Begin
    result:=TJLDIBRaster.Create(self.Owner);
    If AOptions=[coPalette,coSize,coContent] then
    result.Assign(self) else
    Begin
      if  (coSize in AOptions)
      or  (coContent in AOptions) then
      Begin
        If not Empty then
        Begin
          result.Allocate(Width,Height,PixelFormat);
          If  (coPalette in AOptions)
          and (DoHasPalette) then
          Begin
            FTemp:=RasterInfo^.riPalData;
            Result.DefinePalette(@FTemp,RasterInfo^.riPalCnt);
            result.RasterInfo^.riPalMatchMode:=RasterInfo^.riPalMatchMode;
          end;
        end;
      end;
    end;
  end;

  Procedure TJLDIBRaster.Assign(Source:TPersistent);
  var
    wd,hd:    Integer;
    FFormat:  TJLRasterFormat;
  Begin
    If Source<>NIL then
    Begin
      If Source<>Self then
      Begin
        If (Source is TGraphic) then
        Begin
          If (source is TBitmap) then
          Begin
            wd:=TBitmap(source).Width;
            hd:=TBitmap(Source).Height;

            Case TBitmap(Source).PixelFormat of
            pf8bit:   FFormat:=rf8Bit;
            pf15bit:  FFormat:=rf15Bit;
            pf16bit:  FFormat:=rf16Bit;
            pf24bit:  FFormat:=rf24Bit;
            pf32bit:  FFormat:=rf32Bit;
            else      FFormat:=rfNone;
            end;

            If FFormat>rfNone then
            Begin
              Allocate(wd,hd,FFormat);
              bitblt(FDC,0,0,wd,hd,TBitmap(Source).Canvas.Handle,0,0,srccopy);
            end;
          end else
          Begin


            // Figure somthing out, native blit
          end;
        end else
        Begin
          Inherited;
        end;
      end;
    end else
    if not (csLoading in ComponentState) then
    Release;
  end;

  Function TJLDIBRaster.DoAllocPixels(Const AWidth,AHeight:Integer;
           Const AFormat:TJLRasterFormat;var outBuffer:Pointer;
           var outPitch:Integer;var outBufSize:Integer):Boolean;
  Const
    BitComp: Array[rf8Bit..rf32Bit] of Integer
    = (BI_RGB,BI_BITFIELDS,BI_BITFIELDS,BI_RGB,BI_RGB);
  var
    FSize:  Integer;
    FFace:  PLongword;
    FPal:   PRGBQuad;
    src:    pointer;
  Begin
    (* Allocate Device context *)
    FDC:=CreateCompatibleDC(0);
    Result:=FDC<>0;
    If result then
    Begin

      (* Calculate size of BitmapInfo structure *)
      If AFormat=rf8Bit then
      FSize:=SizeOf(TBitmapInfo) + (256 * SizeOf(DWord)) else
      FSize:=SizeOf(TBitmapInfo) + (002 * SizeOf(DWord));

      (* Allocate bitmapinfo *)
      try
        FDInfo:=Allocmem(FSize);
      except
        on e: exception do
        Begin
          result:=False;
          SetLastError('Failed to allocate bitmapinfo structure');
          ReleaseDevContext(FDC);
          exit;
        end;
      end;

      (* Populate info header  *)
      FDInfo^.bmiHeader.biSize:=SizeOf(TBitmapInfoHeader);
      FDInfo^.bmiHeader.biBitCount:=_rkPxBits[AFormat];;
      FDInfo^.bmiHeader.biPlanes:=1;
      FDInfo^.bmiHeader.biWidth:=AWidth;
      FDInfo^.bmiHeader.biHeight:=-abs(AHeight);
      FDInfo^.bmiHeader.biCompression:=BitComp[AFormat];

      case AFormat of
      rf8Bit:
        Begin
          FDInfo^.bmiHeader.biClrUsed:=0;
          FPal:=@FDInfo^.bmiColors[0];
          src:=@RasterInfo^.riPalData[0];
          move(src^,FPal^,RasterInfo^.riPalSize);
        end;
      rf15Bit:
        begin
          FFace:=@FDInfo^.bmiColors[0];
          FDInfo^.bmiHeader.biBitCount:=16;
          FFace^:=$7C00; inc(FFace);
          FFace^:=$03E0; inc(FFace);
          FFace^:=$03E0;
        end;
      rf16Bit:
        begin
          FFace:=@FDInfo^.bmiColors[0];
          FFace^:=$F800; inc(FFace);
          FFace^:=$07E0; inc(FFace);
          FFace^:=$001F;
        end;
      end;

      (* Allocate DIB section *)
      FBitmap:=CreateDibSection(0,FDInfo^,DIB_RGB_COLORS,outBuffer,0,0);
      If FBitmap=0 then
      Begin
        result:=False;
        SetLastError('CreateDibSection failed');
        ReleaseDevContext(FDC);
        FreeMem(FDInfo);
        exit;
      end;

      (* Select bitmap into device context *)
      FOldBmp:=SelectObject(FDC,FBitmap);

      (* Define surface values *)
      outPitch:=JL_StrideAlign(AWidth,_rkPxBytes[AFormat]);
      outBufSize:=outPitch * AHeight;

    end else
    SetLastError('CreateCompatibleDC failed with '
    + SysErrorMessage(windows.GetLastError) );
  end;

  Function TJLDIBRaster.DoReleasePixels(Const inBuffer:Pointer):Boolean;
  Begin
    result:=FDC<>0;
    If result then
    Begin
      try
        (* re-insert original bitmap handle *)
        FOldBmp:=SelectObject(FDC,FOldBmp);

        (* Delete DibSection *)
        DeleteObject(FBitmap);

        (* Delete the DIB *)
        DeleteDC(FDC);
      finally
        FreeMem(FDInfo);
        FDInfo:=NIL;
        FDC:=0;
        FOldBmp:=0;
      end;
    end else
    SetLastError('No device context is allocated error');
  end;

  Procedure TJLDIBRaster.ReleaseDevContext(var DeviceContext:HDC);
  var
    FTemp:  HDC;
  Begin
    If DeviceContext<>0 then
    Begin
      FTemp:=DeviceContext;
      DeviceContext:=0;
      If not DeleteDC(FTemp) then
      SetLastError( SysErrorMessage(windows.GetLastError) );
    end;
  end;

  Function TJLDIBRaster.DefinePalette(Const Kind:TJLPaletteType):Boolean;
  var
    FTemp:  TRGBQuadArray;
    FCount: Integer;
  Begin
    Result:=Inherited DefinePalette(Kind);
    If result then
    Begin
      If not Empty and (FDC<>0) then
      Begin
        FTemp:=RasterInfo^.riPalData;
        FCount:=RasterInfo^.riPalCnt;
        SetDIBColorTable(FDC,0,FCount,FTemp);
      end;
    end;
  end;

  Function TJLDIBRaster.DefinePalette(Const Colors:PRGBQuadArray;
           Const Count:Integer):Boolean;
  var
    FTemp: TRGBQuadArray;
  Begin
    result:=Inherited DefinePalette(Colors,Count);
    If result then
    Begin
      If not Empty and (FDC<>0) then
      Begin
        FTemp:=RasterInfo^.riPalData;
        SetDIBColorTable(FDC,0,Count,FTemp);
      end;
    end;
  end;

  //###########################################################################
  // TJLUNIRaster
  //###########################################################################

  Function  TJLUNIRaster.Clone(Const AOptions:
            TJLRasterCloneOptions=[]):TJLCustomRaster;
  var
    FTemp:  TRGBQuadArray;
  Begin
    result:=TJLUNIRaster.Create(Self.Owner);
    if not Empty then
    Begin
      if AOptions=[coPalette,coSize,coContent] then
      result.Assign(self) else
      Begin
        If (coSize in AOptions) then
        Begin
          result.Allocate(Width,Height,PixelFormat);
          If  (coPalette in AOptions)
          and DoHasPalette then
          Begin
            FTemp:=RasterInfo^.riPalData;
            Result.DefinePalette(@FTemp,RasterInfo^.riPalCnt);
            result.RasterInfo^.riPalMatchMode:=RasterInfo^.riPalMatchMode;
          end;
        end;
      end;
    end;
  end;

  Function  TJLUNIRaster.DoAllocPixels(Const AWidth,AHeight:Integer;
            Const AFormat:TJLRasterFormat;var outBuffer:Pointer;
            var outPitch:Integer;var outBufSize:Integer):Boolean;
  Begin
    result:=True;
    outPitch:=JL_StrideAlign(AWidth,_rkPxBytes[AFormat]);
    outBufSize:=outPitch * AHeight;
    try
      outBuffer:=AllocMem(outBufSize);
      result:=True;
    except
      on e: exception do
      Begin
        outPitch:=0;
        outBufSize:=0;
        outBuffer:=NIL;
        SetLastError(e.message);
      end;
    end;
  end;

  Function TJLUNIRaster.DoReleasePixels(Const inBuffer:Pointer):Boolean;
  Begin
    result:=inBuffer<>NIL;
    If result then
    Begin
      try
        FreeMem(inBuffer);
      except
        on e: exception do
        Begin
          result:=False;
          SetLastError(e.message);
        end;
      end;
    end else
    SetLastError('Invalid pixelbuffer error, parameter was NIL');
  end;

  //###########################################################################
  // TJLGraphicWrapper
  //###########################################################################

  Constructor TJLGraphicWrapper.Create(Raster:TJLCustomRaster);
  Begin
    inherited Create;
    FRaster:=Raster;
    wd:=FRaster.Width;
    hd:=FRaster.Height;
    FFormat:=FRaster.PixelFormat;
  end;

  Destructor TJLGraphicWrapper.Destroy;
  Begin
    FRaster:=NIL;
    inherited;
  end;

  Procedure TJLGraphicWrapper.RealizeRaster;
  Begin
    If  (FFormat>rfNone)
    and (wd>0) and (hd>0) then
    FRaster.Allocate(wd,hd,FFormat)
  end;
  
  Procedure TJLGraphicWrapper.SetFormat(Value:TJLRasterFormat);
  Begin
    If Value<>FFormat then
    Begin
      If (Value=rfNone)
      and (GetEmpty=False) then
      FRaster.Release;

      FFormat:=Value;
      RealizeRaster;
    end;
  end;

  procedure TJLGraphicWrapper.SetHeight(Value:Integer);
  Begin
    If Value<>hd then
    Begin
      If (Value<1)
      and (GetEmpty=False) then
      FRaster.Release;

      hd:=math.EnsureRange(Value,0,MAXINT-1);
      RealizeRaster;
    end;
  end;

  procedure TJLGraphicWrapper.SetWidth(Value:Integer);
  Begin
    If Value<>wd then
    Begin
      If (Value<1)
      and (GetEmpty=False) then
      FRaster.Release;

      wd:=math.EnsureRange(Value,0,MAXINT-1);
      RealizeRaster;
    end;
  end;

  function TJLGraphicWrapper.GetEmpty:Boolean;
  Begin
    Result:=FRaster.Empty;
  end;

  function TJLGraphicWrapper.GetWidth:Integer;
  Begin
    If FRaster.Empty then
    result:=wd else
    result:=FRaster.Width;
  end;

  function TJLGraphicWrapper.GetHeight:Integer;
  Begin
    If FRaster.Empty then
    result:=hd else
    Result:=FRaster.Height;
  end;

  procedure TJLGraphicWrapper.LoadFromStream(Stream:TStream);
  var
    FCodec: TJLCustomCodec;
  Begin
    If JL_GetCodecByClass(TJLBitmapCodec,FCodec) then
    FCodec.LoadFromStream(Stream,FRaster);
  end;

  procedure TJLGraphicWrapper.SaveToStream(Stream:TStream);
  var
    FCodec: TJLCustomCodec;
  Begin
    If JL_GetCodecByClass(TJLBitmapCodec,FCodec) then
    FCodec.SaveToStream(Stream,FRaster);
  end;

  procedure TJLGraphicWrapper.LoadFromClipboardFormat(AFormat:Word;
            AData:THandle;APalette:HPALETTE);
  Begin
    //?
  end;

  procedure TJLGraphicWrapper.SaveToClipboardFormat(var AFormat:Word;
            var AData:THandle;var APalette:HPALETTE);
  Begin
    //?
  end;

  procedure TJLGraphicWrapper.Draw(ACanvas:TCanvas;const Rect:TRect);
  Begin
    If  (FRaster.Empty=False)
    and (ACanvas<>NIL)
    and (Rect.left<Rect.right)
    and (Rect.top<Rect.bottom) then
    Begin
      If (FRaster is TJLDibRaster) then
      Begin
        If  (JL_RectWidth(Rect)=wd)
        and (JL_RectHeight(Rect)=hd) then
        Bitblt(ACanvas.Handle,Rect.left,Rect.top,wd,hd,
        TJLDibRaster(FRaster).dc,0,0,srccopy) else
        StretchBlt(ACanvas.Handle,Rect.left,Rect.top,JL_RectWidth(Rect),
        JL_RectHeight(Rect),
        TJLDibRaster(FRaster).DC,0,0,wd,hd,srccopy);
      end;
    end;
  end;

  //###########################################################################
  // 8bit copy procs
  //###########################################################################

  Procedure _Copy8bitTo8Bit(Const Operation:PJLBlitOperation);register;
  var
    src:  PByte;
    dst:  PByte;
    x:    Integer;
  Begin
    src:=Operation^.boSrcAddr;
    dst:=Operation^.boDstAddr;
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin dst^:=src^; inc(src); inc(dst); end;
  end;

  Procedure _Copy8BitTo15Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PByte;
    dst:    PWord;
    x:      Integer;
    FColor: TColor;
  Begin
    src:=Operation^.boSrcAddr;
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      _NativeToColor(Operation^.boSource,src^,FColor);
      _ColorToNative(Operation^.boTarget,FColor,dst^);
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy8BitTo16Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PByte;
    dst:    PWord;
    x:      Integer;
    FColor: TColor;
  Begin
    src:=Operation^.boSrcAddr;
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      _NativeToColor(Operation^.boSource,src^,FColor);
      _ColorToNative(Operation^.boTarget,FColor,dst^);
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy8BitTo24Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PByte;
    dst:    PRGBTriple;
    x:      Integer;
    FColor: TColor;
  Begin
    src:=Operation^.boSrcAddr;
    dst:=PRGBTriple(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      _NativeToColor(Operation^.boSource,src^,FColor);
      _ColorToNative(Operation^.boTarget,FColor,dst^);
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy8BitTo32Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PByte;
    dst:    PRGBQuad;
    x:      Integer;
    FColor: TColor;
  Begin
    src:=Operation^.boSrcAddr;
    dst:=PRGBQuad(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      _NativeToColor(Operation^.boSource,src^,FColor);
      _ColorToNative(Operation^.boTarget,FColor,dst^);
      inc(src); inc(dst);
    end;
  end;

  //###########################################################################
  // 15bit copy procs
  //###########################################################################

  Procedure _Copy15bitTo8Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PByte;
    r,g,b:  Byte;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=Operation^.boDstAddr;
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      r:=((src^ and $7C00) shr 10) shl 3;
      g:=((src^ and $03E0) shr 5) shl 3;
      b:=(src^ and $001F) shl 3;
      dst^:=JL_MatchColor(Operation^.boTarget,R,G,B);
      inc(src);
      inc(dst);
    end;
  end;

  Procedure _Copy15bitTo15Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=src^;
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy15bitTo16Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=(src^ and $1F) or ((src^ and $7FE0) shl 1);
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy15bitTo24Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PRGBTriple;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PRGBTriple(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^.rgbtRed:=((src^ and $7C00) shr 10) shl 3;
      dst^.rgbtGreen:=((src^ and $03E0) shr 5) shl 3;
      dst^.rgbtBlue:=(src^ and $001F) shl 3;
      inc(dst); inc(src);
    end;
  end;

  Procedure _Copy15bitTo32Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PRGBQuad;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PRGBQuad(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^.rgbRed:=((src^ and $7C00) shr 10) shl 3;
      dst^.rgbGreen:=((src^ and $03E0) shr 5) shl 3;
      dst^.rgbBlue:=(src^ and $001F) shl 3;
      inc(dst); inc(src);
    end;
  end;

  //###########################################################################
  // 16bit copy procs
  //###########################################################################

  Procedure _Copy16bitTo8Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PByte;
    r,g,b:  Byte;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=Operation^.boDstAddr;
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      r:=Byte(((src^ and $F800) shr 11) shl 3);
      g:=Byte(((src^ and $07E0) shr 5) shl 2);
      b:=Byte((src^ and $001F) shl 3);
      dst^:=JL_MatchColor(Operation^.boTarget,R,G,B);
      inc(src);
      inc(dst);
    end;
  end;

  Procedure _Copy16bitTo15Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=(src^ and $1F) or ((src^ and $FFC0) shr 1);
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy16bitTo16Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=src^;
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy16bitTo24Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PRGBTriple;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PRGBTriple(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^.rgbtRed:=(((src^ and $F800) shr 11) shl 3);
      dst^.rgbtGreen:=byte(((src^ and $07E0) shr 5) shl 2);
      dst^.rgbtBlue:=byte((src^ and $001F) shl 3);
      inc(dst); inc(src);
    end;
  end;

  Procedure _Copy16bitTo32Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PWord;
    dst:    PRGBQuad;
    x:      Integer;
  Begin
    src:=PWord(Operation^.boSrcAddr);
    dst:=PRGBQuad(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^.rgbRed:=(((src^ and $F800) shr 11) shl 3);
      dst^.rgbGreen:=byte(((src^ and $07E0) shr 5) shl 2);
      dst^.rgbBlue:=byte((src^ and $001F) shl 3);
      inc(dst); inc(src);
    end;
  end;

  //###########################################################################
  // 24bit copy procs
  //###########################################################################

  Procedure _Copy24bitTo8Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBTriple;
    dst:    PByte;
    x:      Integer;
  Begin
    src:=PRGBTriple(Operation^.boSrcAddr);
    dst:=PByte(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=JL_MatchColor(Operation^.boTarget,
      src^.rgbtRed,src^.rgbtGreen,src^.rgbtBlue);
      inc(dst); inc(src);
    end;
  end;

  Procedure _Copy24bitTo15Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBTriple;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PRGBTriple(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=Word(src^.rgbtRed shr 3 shl 10 or src^.rgbtGreen shr 3 shl 5
      or src^.rgbtBlue shr 3);
      inc(dst); inc(src);
    end;
  end;

  Procedure _Copy24bitTo16Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBTriple;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PRGBTriple(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=(src^.rgbtRed shr 3) shl 11 or (src^.rgbtGreen shr 2) shl 5
      or (src^.rgbtBlue shr 3);
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy24bitTo24Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBTriple;
    dst:    PRGBTriple;
    x:      Integer;
  Begin
    src:=PRGBTriple(Operation^.boSrcAddr);
    dst:=PRGBTriple(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=src^;
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy24bitTo32Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBTriple;
    dst:    PRGBQuad;
    x:      Integer;
  Begin
    src:=PRGBTriple(Operation^.boSrcAddr);
    dst:=PRGBQuad(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^.rgbRed:=src^.rgbtRed;
      dst^.rgbGreen:=src^.rgbtGreen;
      dst^.rgbBlue:=src^.rgbtBlue;
      inc(src); inc(dst);
    end;
  end;

  //###########################################################################
  // 32bit copy procs
  //###########################################################################

  Procedure _Copy32bitTo8Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBQuad;
    dst:    PByte;
    x:      Integer;
  Begin
    src:=PRGBQuad(Operation^.boSrcAddr);
    dst:=PByte(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=JL_MatchColor(Operation^.boTarget,
      src^.rgbRed,src^.rgbGreen,src^.rgbBlue);
      inc(dst); inc(src);
    end;
  end;

  Procedure _Copy32bitTo15Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBQuad;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PRGBQuad(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=Word(src^.rgbRed shr 3 shl 10
      or src^.rgbGreen shr 3 shl 5
      or src^.rgbBlue shr 3);
      inc(dst); inc(src);
    end;
  end;

  Procedure _Copy32bitTo16Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBQuad;
    dst:    PWord;
    x:      Integer;
  Begin
    src:=PRGBQuad(Operation^.boSrcAddr);
    dst:=PWord(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=(src^.rgbRed shr 3) shl 11
      or (src^.rgbGreen shr 2) shl 5
      or (src^.rgbBlue shr 3);
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy32bitTo24Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PRGBQuad;
    dst:    PRGBTriple;
    x:      Integer;
  Begin
    src:=PRGBQuad(Operation^.boSrcAddr);
    dst:=PRGBTriple(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^.rgbtRed:=src^.rgbRed;
      dst^.rgbtGreen:=src^.rgbGreen;
      dst^.rgbtBlue:=src^.rgbBlue;
      inc(src); inc(dst);
    end;
  end;

  Procedure _Copy32bitTo32Bit(Const Operation:PJLBlitOperation);register;
  var
    src:    PLongword;
    dst:    PLongword;
    x:      Integer;
  Begin
    src:=PLongword(Operation^.boSrcAddr);
    dst:=PLongword(Operation^.boDstAddr);
    for x:=Operation^.boDstRect.left to Operation^.boDstRect.right do
    Begin
      dst^:=src^;
      inc(src); inc(dst);
    end;
  end;


  Procedure _CopyPixel(Const srcInfo:PJLRasterInfo;
            const dstInfo:PJLRasterInfo;
            var ThisPixel;var ThatPixel);
  var
    rs,gs,bs: Byte;
  Begin
    Case SrcInfo^.riPixelBytes of
    1:
      Begin

        Case dstInfo^.riPixelBytes of
        1:  Byte(ThatPixel):=Byte(Thispixel);
        2:
          Begin
            With srcInfo^.riPalData[Byte(ThisPixel)] do
            Begin
              rs:=rgbRed;
              gs:=rgbGreen;
              bs:=rgbBlue;
            end;
            if dstInfo^.riFormat=rf15bit then
            Word(ThatPixel):=(Rs shr 3) shl 10 + (Gs shr 3) shl 5 + (Bs shr 3) else
            Word(ThatPixel):=(Rs shr 3) shl 11 or (Gs shr 2) shl 5 or (Bs shr 3);
          end;
        3:
          Begin
            with TRGBTriple(thatpixel) do
            Begin
              rgbtRed:=srcInfo^.riPalData[Byte(ThisPixel)].rgbRed;
              rgbtGreen:=srcInfo^.riPalData[Byte(ThisPixel)].rgbGreen;
              rgbtBlue:=srcInfo^.riPalData[Byte(ThisPixel)].rgbBlue;
            end;
          end;
        4:
          Begin
            with TRGBQuad(thatpixel) do
            Begin
              rgbRed:=srcInfo^.riPalData[Byte(ThisPixel)].rgbRed;
              rgbGreen:=srcInfo^.riPalData[Byte(ThisPixel)].rgbGreen;
              rgbBlue:=srcInfo^.riPalData[Byte(ThisPixel)].rgbBlue;
            end;
          end;
        end;

      end;
    2:
      Begin

        Case dstInfo^.riPixelBytes of
        1:
          Begin
            if dstInfo^.riFormat=rf15bit then
            Begin
              rs:=((Word(thisPixel) and $7C00) shr 10) shl 3;
              gs:=((Word(thisPixel) and $03E0) shr 5) shl 3;
              bs:= (Word(thisPixel) and $001F) shl 3;
            end else
            Begin
              rs:=((Word(thisPixel) and $F800) shr 11) shl 3;
              gs:=((Word(thisPixel) and $07E0) shr 5) shl 2;
              bs:=(Word(thisPixel) and $001F) shl 3;
            end;
            Byte(thatpixel):=JL_MatchColor(dstInfo,rs,gs,bs);
          end;

        2:  Word(Thatpixel):=word(Thispixel);

        3:
          Begin
            if dstInfo^.riFormat=rf15bit then
            Begin
              rs:=((Word(thisPixel) and $7C00) shr 10) shl 3;
              gs:=((Word(thisPixel) and $03E0) shr 5) shl 3;
              bs:= (Word(thisPixel) and $001F) shl 3;
            end else
            Begin
              rs:=((Word(thisPixel) and $F800) shr 11) shl 3;
              gs:=((Word(thisPixel) and $07E0) shr 5) shl 2;
              bs:=(Word(thisPixel) and $001F) shl 3;
            end;
            with TRGBTriple(thatpixel) do
            Begin
              rgbtRed:=rs;
              rgbtGreen:=gs;
              rgbtBlue:=bs;
            end;
          end;
        4:
          Begin
            if dstInfo^.riFormat=rf15bit then
            Begin
              rs:=((Word(thisPixel) and $7C00) shr 10) shl 3;
              gs:=((Word(thisPixel) and $03E0) shr 5) shl 3;
              bs:= (Word(thisPixel) and $001F) shl 3;
            end else
            Begin
              rs:=((Word(thisPixel) and $F800) shr 11) shl 3;
              gs:=((Word(thisPixel) and $07E0) shr 5) shl 2;
              bs:=(Word(thisPixel) and $001F) shl 3;
            end;
            with TRGBQuad(thatpixel) do
            Begin
              rgbRed:=rs;
              rgbGreen:=gs;
              rgbBlue:=bs;
            end;
          end;
        end;


      end;
    3:
      Begin

        Case dstInfo^.riPixelBytes of
        1:
          Begin
            with TRGBTriple(thispixel) do
            Begin
              rs:=rgbtRed;
              gs:=rgbtGreen;
              bs:=rgbtBlue;
            end;
            Byte(thatpixel):=JL_MatchColor(dstInfo,rs,gs,bs);
          end;
        2:
          Begin
            with TRGBTriple(thispixel) do
            Begin
              rs:=rgbtRed;
              gs:=rgbtGreen;
              bs:=rgbtBlue;
            end;
            if dstInfo^.riFormat=rf15bit then
            Word(ThatPixel):=(Rs shr 3) shl 10 + (Gs shr 3) shl 5 + (Bs shr 3) else
            Word(ThatPixel):=(Rs shr 3) shl 11 or (Gs shr 2) shl 5 or (Bs shr 3);
          end;
        3:  TRGBTriple(thatpixel):=TRGBTriple(thispixel);
        4:
          Begin
            with TRGBQuad(thatpixel) do
            Begin
              rgbRed:=TRGBTriple(thispixel).rgbtRed;
              rgbGreen:=TRGBTriple(thispixel).rgbtGreen;
              rgbBlue:=TRGBTriple(thispixel).rgbtBlue;
            end;
          end;
        end;

      end;
    4:
      Begin

        Case dstInfo^.riPixelBytes of
        1:
          Begin
            with TRGBQuad(thatpixel) do
            Begin
              rs:=rgbRed;
              gs:=rgbGreen;
              bs:=rgbBlue;
            end;
            Byte(thatpixel):=JL_MatchColor(dstInfo,rs,gs,bs);
          end;
        2:
          Begin
            with TRGBQuad(thatpixel) do
            Begin
              rs:=rgbRed;
              gs:=rgbGreen;
              bs:=rgbBlue;
            end;
            if dstInfo^.riFormat=rf15bit then
            Word(ThatPixel):=(Rs shr 3) shl 10 + (Gs shr 3) shl 5 + (Bs shr 3) else
            Word(ThatPixel):=(Rs shr 3) shl 11 or (Gs shr 2) shl 5 or (Bs shr 3);
          end;
        3:
          Begin
            with TRGBTriple(thatpixel) do
            Begin
              rgbtRed:=TRGBQuad(thispixel).rgbRed;
              rgbtGreen:=TRGBQuad(thispixel).rgbGreen;
              rgbtBlue:=TRGBQuad(thispixel).rgbBlue;
            end;
          end;
        4: Longword(Thatpixel):=longword(thispixel);
        end;

      end;
    end;
  end;

  //###########################################################################
  // TJLRawCanvas
  //###########################################################################

  Constructor TJLRawCanvas.Create(Const Raster:TJLCustomRaster);
  Begin
    inherited Create;
    If Raster<>NIL then
    Begin
      FParent:=Raster;
      FInfo:=Raster.RasterInfo;
    end else
    Raise EJLRasterCanvas.Create('Raster parameter is NIL error');
  end;

  Function TJLRawCanvas.ValidSurface(const Info:PJLRasterInfo):Boolean;
  Begin
    If Info<>NIL then
    Begin
      If Info^.riSize=sizeOf(TJLRasterInfo) then
      Begin
        result:=Info^.riEmpty=False;
        if not result then
        JL_RxSetLastError(FInfo,ERR_JL_RASTER_EMPTY);
      end else
      result:=False;
    end else
    result:=False;
  end;

  Procedure TJLRawCanvas.HLine(Col,Row:Integer;ACount:Integer);
  var
    FTemp:  Integer;
    FRight: Integer;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        If Col<FInfo^.riClipRect.Left then
        Begin
          FTemp:=JL_Diff(col,FInfo^.riClipRect.Left);
          dec(ACount,FTemp);
          col:=FInfo^.riClipRect.Left;
        end;

        FRight:=(Col + ACount)-1;
        If FRight > FInfo^.riClipRect.Right then
        Begin
          FTemp:=JL_Diff(FRight,FInfo^.riClipRect.right);
          dec(ACount,FTemp);
        end;

        If ACount>0 then
        _FillRow(FInfo,row,col,ACount,FInfo^.riNative);
      end else
      FParent.SetLastError(ERR_JL_RASTER_EMPTY);
    end;
  end;

  Procedure TJLRawCanvas.VLine(Col,Row:Integer;ACount:Integer);
  var
    FBottom:  Integer;
    FTemp:    Integer;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        (* Always from the top-down *)
        If (Row + ACount)<Row then
        Begin
          ACount:=abs(ACount);
          dec(Row,ACount);
        end;

        (* Clip top *)
        If Row<FInfo^.riClipRect.top then
        Begin
          FTemp:=JL_Diff(Row,FInfo^.riClipRect.top);
          dec(ACount,FTemp);
          Row:=FInfo^.riClipRect.top;
        end;

        If ACount>0 then
        Begin

          (* clip bottom *)
          FBottom:=((Row + ACount)-1);
          If FBottom > FInfo^.riClipRect.bottom then
          Begin
            FTemp:=JL_Diff(FBottom,FInfo^.riClipRect.bottom);
            dec(ACount,FTemp);
          end;

          if ACount>0 then
          _FillCol(FInfo,col,row,ACount,FInfo^.riNative);
        end;
      end else
      FParent.SetLastError(ERR_JL_RASTER_EMPTY);
    end;
  end;

  Procedure TJLRawCanvas.AdjustToClipRect(var aRect:TRect);
  Begin
    if FInfo<>NIl then
    Begin
      if not FInfo.riEmpty then
      Begin
        JL_RectRealize(aRect);
        If aRect.left<FInfo.riClipRect.Left then
        aRect.Left:=FInfo.riClipRect.Left else
        if aRect.left>FInfo.riClipRect.Right then
        aRect.left:=FInfo.riClipRect.Right;
        If aRect.right<FInfo.riClipRect.Left then
        aRect.right:=FInfo.riClipRect.Left else
        if aRect.right>FInfo.riClipRect.Right
        then aRect.right:=FInfo.riClipRect.Right;
        if aRect.Top<FInfo.riClipRect.Top then
        aRect.top:=FInfo.riClipRect.Top else
        if aRect.top>FInfo.riClipRect.bottom then
        aRect.top:=FInfo.riClipRect.bottom;
        if aRect.bottom<FInfo.riClipRect.Top then
        aRect.bottom:=FInfo.riClipRect.Top else
        if aRect.bottom>FInfo.riClipRect.bottom then
        aRect.bottom:=FInfo.riClipRect.Bottom;
      end else
      Begin
        aRect:=JL_NULLRECT;
        JL_RxSetLastError(FInfo,ERR_JL_RASTER_EMPTY);
      end;
    end else
    aRect:=JL_NULLRECT;
  end;

  Procedure TJLRawCanvas.SetClipRect(ARect:TRect);
  Begin
    if FParent<>NIL then
    FParent.SetClipRect(ARect);
  end;

  procedure TJLRawCanvas.RemoveClipRect;
  Begin
    if FParent<>NIL then
    FParent.RemoveClipRect;
  end;

  Function TJLRawCanvas.GetPixel(Const Col,Row:Integer):TColor;
  var
    FTemp:  Longword;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        If  (Col>=FInfo^.riBoundsRect.Left)
        and (Col<=FInfo^.riBoundsRect.Right)
        and (Row>=FInfo^.riBoundsRect.Top)
        and (Row<=FInfo^.riBoundsRect.Bottom) then
        Begin
          _ReadPixel(FInfo,Col,Row,FTemp);
          _NativeToColor(FInfo,FTemp,Result);
        end else
        result:=clNone;
      end else
      Begin
        result:=clNone;
        FParent.SetLastError(ERR_JL_RASTER_EMPTY);
      end;
    end else
    result:=clNone;
  end;

  Procedure TJLRawCanvas.Line(Left,Top,Right,Bottom:Integer);
  var
    ix, iy, pp, cp: Integer;
    dr,du,i,FPixels: Integer;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        if JL_LineClip(FInfo^.riClipRect,Left,Top,Right,Bottom) then
        Begin
          (* vertical? *)
          If Left=Right then
          Begin
            If Bottom<Top then
            JL_Swap(Bottom,Top);
            FPixels:=Bottom - Top + 1;
            _FillCol(FInfo,Left,Top,FPixels,FInfo^.riNative);
          end else

          (* horizontal? *)
          if top=Bottom then
          Begin
            If Right<Left then
            JL_Swap(Right,Left);

            FPixels:=Right-Left + 1;
            _FillRow(FInfo,Top,Left,FPixels,FInfo^.riNative);
          end else
          Begin
            (* odd line *)
            dec(right,left);
            dec(bottom,top);

            if right>0 then
            ix := +1 else
            ix := -1; cp := -1;

            if bottom>0 then
            iy := +1 else
            iy := -1;

            right:=abs(right);
            bottom:=abs(bottom);

            if right>=bottom then
            begin
              dr:= bottom shl 1;
              du:= dr - right shl 1;
              pp := dr-right;
              for i := 0 to right do
              begin
                SetPixel(Left,Top);
                inc(left,ix);
                if pp > cp then
                begin
                  inc(top,iy);
                  inc(pp,du);
                end else
                inc(pp,dr);
              end;
            end else
            begin
              dr := right shl 1;
              du := dr - bottom shl 1;
              pp := dr-bottom;
              for i := 0 to bottom do
              begin
                SetPixel(Left,Top);
                inc(top,iy);
                if pp > cp then
                begin
                  inc(left,ix);
                  inc(pp,du);
                end else
                inc(pp,dr);
              end;
            end;
          end;
        end;
      end else
      FParent.SetLastError(ERR_JL_RASTER_EMPTY);
    end;
  end;

  Function TJLRawCanvas.GetAlpha:Byte;
  Begin
    If (FInfo<>NIL)
    and (FInfo^.riSize=SizeOf(TJLRasterInfo)) then
    result:=FInfo^.riPenAlpha else
    result:=0;
  end;

  Procedure TJLRawCanvas.SetAlpha(Const Value:Byte);
  Begin
    If (FInfo<>NIL)
    and (FInfo^.riSize=SizeOf(TJLRasterInfo)) then
    FInfo^.riPenAlpha:=Value;
  end;

  Procedure TJLRawCanvas.SetPenMode(Const Value:TJLPenMode);
  Begin
    If (FInfo<>NIL)
    and (FInfo^.riSize=SizeOf(TJLRasterInfo)) then
    FInfo^.riPenMode:=Value;
  end;

  Function TJLRawCanvas.GetBoundsRect:TRect;
  Begin
    result:=FInfo^.riBoundsRect;
  end;

  Function TJLRawCanvas.GetClipRect:TRect;
  Begin
    if ValidSurface(FInfo) then
    result:=FInfo^.riClipRect else
    result:=JL_NULLRECT;
  end;

  Function TJLRawCanvas.GetIsClipped:Boolean;
  Begin
    result:=FInfo^.riClipped;
  end;

  Function TJLRawCanvas.GetWidth:Integer;
  Begin
    result:=FInfo^.riWidth;
  end;

  Function TJLRawCanvas.GetHeight:Integer;
  Begin
    result:=FInfo^.riHeight;
  end;

  Function TJLRawCanvas.GetPenMode:TJLPenMode;
  Begin
    If (FInfo<>NIL)
    and (FInfo^.riSize=SizeOf(TJLRasterInfo)) then
    result:=FInfo^.riPenMode else
    result:=pmCopy;
  end;

  Function TJLRawCanvas.GetColor:TColor;
  Begin
    If  (FInfo<>NIL)
    and (FInfo^.riSize=SizeOf(TJLRasterInfo)) then
    result:=FInfo^.riColor else
    result:=clNone;
  end;

  Procedure TJLRawCanvas.SetColor(Const Value:TColor);
  Begin
    If (FInfo<>NIL)
    and (FInfo^.riSize=SizeOf(TJLRasterInfo)) then
    Begin
      If Value<>FInfo^.riColor then
      Begin
        FInfo^.riColor:=Value;
        _ColorToNative(FInfo,Value,FInfo^.riNative);
      end;
    end;
  end;

  Procedure TJLRawCanvas.FillRect(ARect:TRect);
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        FParent.AdjustToClipRect(ARect);
        if JL_RectValid(aRect) then
        _FillRegion(FInfo,ARect,FInfo^.riNative);
      end else
      JL_RxSetLastError(FInfo,ERR_JL_RASTER_EMPTY);
    end;
  end;

  Procedure TJLRawCanvas.FillRect(ARect:TRect;Const AColor:TColor);
  var
    FTemp:  Longword;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        FParent.AdjustToClipRect(ARect);
        if JL_RectValid(aRect) then
        Begin
          If AColor<>FInfo^.riColor then
          Begin
            FTemp:=0;
            _ColorToNative(FInfo,AColor,FTemp);
            _FillRegion(FInfo,ARect,FTemp);
          end else
          _FillRegion(FInfo,ARect,FInfo^.riNative);
        end;
      end else
      JL_RxSetLastError(FInfo,ERR_JL_RASTER_EMPTY);
    end;
  end;

  Procedure TJLRawCanvas.Draw(Target:HDC;srcRect:TRect;
            dstRect:TRect;Options:Integer);
  var
    wd1,hd1,
    wd2,hd2:  Integer;
  Begin
    If target<>0 then
    Begin
      if ValidSurface(FInfo) then
      Begin
        if (FParent is TJLDibRaster) then
        Begin
          wd1:=srcRect.right-srcRect.left;
          hd1:=srcRect.Bottom-srcRect.top;
          wd2:=dstRect.right-dstRect.left;
          hd2:=dstRect.Bottom-dstRect.top;
          stretchblt(target,dstRect.Left,dstRect.Top,wd2,hd2,
          TJLDibRaster(FParent).DC,srcRect.left,srcRect.Top,wd1,hd1,SRCCOPY);
        end else
        Begin
          //Create temp DC
        end;
      end;
    end;
  end;

  Procedure TJLRawCanvas.Draw(Target:TJLCustomRaster;srcRect:TRect;
            dstRect:TRect;Options:Integer);
  Begin
  end;

  Procedure TJLRawCanvas.Draw(Target:HDC;dstX,dstY:Integer);
  Begin
    If Target<>0 then
    Begin
      if ValidSurface(FInfo) then
      Begin
        if (FParent is TJLDibRaster) then
        bitblt(target,dstx,dstY,FInfo^.riWidth,FInfo^.riHeight,
        TJLDibRaster(FParent).DC,0,0,srccopy);
      end;
    end;
  end;
  
  Procedure TJLRawCanvas.Draw(Target:TJLCustomRaster;dstX,dstY:Integer);
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Draw(Target,FParent.BoundsRect,dstX,dstY) else
      JL_RxSetLastError(FInfo,ERR_JL_RASTER_EMPTY);
    end;
  end;

  Procedure TJLRawCanvas.Draw(Target:TJLCustomRaster;
            srcRect:TRect;dstX,dstY:Integer);
  var
    wd,hd:      Integer;
    dstRect:    TRect;
    FTemp:      TRect;
    y:          Integer;
    FSrcPitch:  Integer;
    FDstPitch:  Integer;
    FCopyProc:  TJLBlitProc;
    FBlit:      TJLBlitOperation;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        FParent.AdjustToBoundsRect(srcRect);
        if jl_rectvalid(srcRect) then
        Begin
          wd:=jl_rectwidth(srcrect);
          hd:=jl_rectheight(srcrect);

          FTemp:=Rect(dstx,dsty,dstx + wd,dsty + hd);

          if JL_RectIntersect(target.ClipRect,FTemp,dstRect) then
          Begin
            wd:=jl_rectwidth(dstRect);
            hd:=jl_rectheight(dstRect);
            srcRect.Right:=srcRect.left + wd;
            srcRect.Bottom:=srcRect.top + hd;

            FBlit.boSource:=FInfo;
            FBlit.boTarget:=Target.RasterInfo;
            FBlit.boWidth:=wd;
            FBlit.boWidth:=hd;
            FBlit.boSrcRect:=srcRect;
            FBlit.boDstRect:=dstRect;
            FCopyProc:=_rkCopyLut[FInfo^.riFormat,FBlit.boTarget^.riFormat];

            FSrcPitch:=FBlit.boSource^.riPitch;
            FDstPitch:=FBlit.boTarget^.riPitch;

            FBlit.boSrcAddr:=FParent.PixelAddr(srcRect.left,srcRect.top);
            FBlit.boDstAddr:=Target.PixelAddr(dstRect.Left,dstRect.Top);

            for y:=srcRect.top to srcRect.bottom do
            Begin
              FCopyProc(@FBlit);
              inc(FBlit.boSrcAddr,FSrcPitch);
              inc(FBlit.boDstAddr,FDstPitch);
            end;

          end;
        end;
      end else
      JL_RxSetLastError(FInfo,ERR_JL_RASTER_EMPTY);
    end;
  end;

  Procedure TJLRawCanvas.SetPixel(Const Col,Row:Integer);
  var
    FAddr:  PByte;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        If  (Col>=FInfo^.riClipRect.Left)
        and (Col<=FInfo^.riClipRect.Right)
        and (Row>=FInfo^.riClipRect.Top)
        and (Row<=FInfo^.riClipRect.Bottom) then
        Begin
          (* Plain write or Alphablend? *)
          If FInfo^.riPenMode=pmCopy then
          _WritePixel(FInfo,Col,Row,FInfo^.riNative) else
          Begin
            (* Alphablend *)
            FAddr:=PTR(Integer(FInfo^.riPxBuffer)
            + (FInfo^.riPitch * row)
            + (Col * FInfo^.riPixelBytes));
            _BlendPixel(FInfo,FInfo^.riNative,FAddr^,FInfo^.riPenAlpha,FAddr^);
          end;
        end;
      end else
      FParent.SetLastError(ERR_JL_RASTER_EMPTY);
    end;
  end;

  Procedure TJLRawCanvas.SetPixel(Const Col,Row:Integer;AColor:TColor);
  var
    FTemp:  Longword;
    FAddr:  PByte;
  Begin
    if  (FInfo<>NIL) then
    Begin
      if (FInfo^.riEmpty=False) then
      Begin
        If  (Col>=FInfo^.riClipRect.Left)
        and (Col<=FInfo^.riClipRect.Right)
        and (Row>=FInfo^.riClipRect.Top)
        and (Row<=FInfo^.riClipRect.Bottom) then
        Begin
          (* Convert Color parameter to Native pixelformat *)
          _ColorToNative(FInfo,AColor,FTemp);

          (* Plain write or Alphablend? *)
          If FInfo^.riPenMode=pmCopy then
          _WritePixel(FInfo,Col,Row,FTemp) else
          Begin
            (* Alphablend *)
            FAddr:=PTR(Integer(FInfo^.riPxBuffer)
            + (FInfo^.riPitch * row)
            + (Col * FInfo^.riPixelBytes));
            _BlendPixel(FInfo,FTemp,FAddr^,FInfo^.riPenAlpha,FAddr^);
          end;
        end;
      end else
      FParent.SetLastError(ERR_JL_RASTER_EMPTY);
    end;
  end;

  //###########################################################################
  // TJLCustomRaster
  //###########################################################################

  Constructor TJLCustomRaster.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FCanvas:=NIL;
    FInfoRef:=@FInfo;
    Fillchar(FInfoRef^,SizeOf(FInfo),#0);
    FInfo.riSize:=SizeOf(FInfo);
    FInfo.riEmpty:=TRue;
    FInfo.riFormat:=rfNone;
    FInfo.riTransColor:=clNone;
    DefinePalette(plUser);
  end;
  
  Procedure TJLCustomRaster.BeforeDestruction;
  Begin
    If not Empty then
    Release;
    Inherited;
  end;

  Destructor TJLCustomRaster.Destroy;
  Begin
    if FCanvas<>NIL then
    FreeAndNIL(FCanvas);
    inherited;
  end;

  Function TJLCustomRaster.GetCanvas:TJLRawCanvas;
  Begin
    If FCanvas=NIL then
    Begin
      if MakeCanvas(FCanvas) then
      result:=FCanvas else
      result:=NIL;
    end else
    result:=FCanvas;
  end;

  Procedure TJLCustomRaster.SignalBeforeAlloc;
  Begin
    If not (csDestroying in ComponentState)
    and not (csDesigning in ComponentState)
    and not (csLoading in ComponentState)
    and not isUpdating
    and assigned(FOnBeforeAlloc) then
    FOnBeforeAlloc(self);
  end;
  
  Procedure TJLCustomRaster.SignalAfterAlloc;
  Begin
    If not  (csDestroying in ComponentState)
    and not (csDesigning in ComponentState)
    and not (csLoading in ComponentState)
    and not isUpdating
    and assigned(FOnAfterAlloc) then
    FOnAfterAlloc(self);
  end;

  Procedure TJLCustomRaster.SignalBeforeRelease;
  Begin
    If not  (csDestroying in ComponentState)
    and not (csDesigning in ComponentState)
    and not isUpdating
    and assigned(FOnBeforeRelease) then
    FOnBeforeRelease(self);
  end;

  procedure TJLCustomRaster.SignalAfterRelease;
  Begin
    If not  (csDestroying in ComponentState)
    and not (csDesigning in ComponentState)
    and not isUpdating
    and assigned(FOnAfterRelease) then
    FOnAfterRelease(self);
  end;

  procedure TJLCustomRaster.SignalPalColorChange;
  Begin
    If not (csDestroying in ComponentState)
    and not (csDesigning in ComponentState)
    and not isUpdating
    and assigned(FOnPalColorChange) then
    FOnPalColorChange(self);
  end;

  Procedure TJLCustomRaster.SignalUpdateBegins;
  Begin
    If not (csDestroying in ComponentState)
    and not (csDesigning in ComponentState)
    and assigned(FOnUpdateBegins) then
    FOnUpdateBegins(self);
  end;

  procedure TJLCustomRaster.SignalUpdateEnds;
  Begin
    If not (csDestroying in ComponentState)
    and not (csDesigning in ComponentState)
    and assigned(FOnUpdateEnds) then
    FOnUpdateEnds(self);
  end;
  
  Function TJLCustomRaster.isUpdating:Boolean;
  Begin
    result:=(FInfo.riEmpty=False)
    {and (FInfo.riPxBuffer<>NIL)
    and (FInfo.riPxBufferSize>0)  }
    and (FUpdateCnt>0);
  end;

  Function TJLCustomRaster.BeginUpdate:Boolean;
  Begin
    result:=FInfo.riEmpty=False;
    If result then
    Begin
      inc(FUpdateCnt);
      If FUpdateCnt=1 then
      SignalUpdateBegins;
    end;
  end;

  Procedure TJLCustomRaster.EndUpdate;
  Begin
    If FUpdateCnt>0 then
    Begin
      dec(FUpdateCnt);
      If FUpdateCnt=0 then
      SignalUpdateEnds;
    end;
  end;

  Procedure TJLCustomRaster.ResetLastError;
  Begin
    fillchar(FInfo.riLastError,sizeOf(FInfo.riLastError),#0);
  end;

  Procedure TJLCustomRaster.Assign(Source:TPersistent);
  var
    Info:     PJLRasterInfo;
    FPal:     TRGBQuadArray;
  Begin
    ResetLastError;
    If (Source<>NIL) then
    Begin
      if (Source<>Self) then
      Begin
        if (Source is TJLCustomRaster) then
        Begin
          If TJLCustomRaster(Source).Empty then
          Release Else
          Begin

            BeginUpdate;
            try
              (* Get surface info *)
              Info:=TJLCustomRaster(Source).RasterInfo;

              (* Allocate same surface *)
              Allocate(Info^.riWidth,Info^.riHeight,Info^.riFormat);

              if Info^.riFormat=rf8Bit then
              Begin
                (* copy palette over *)
                FPal:=info^.riPalData;
                DefinePalette(@FPal,Info^.riPalCnt);

                (* set matchmode *)
                FInfo.riPalMatchMode:=Info.riPalMatchMode;
              end;

              (* copy pixel buffer *)
              move(info^.riPxBuffer^,FInfo.riPxBuffer^,
              FInfo.riPxBufferSize);

            finally
              EndUpdate;
            end;

          end;
        end;
      end;
    end else
    Release;
  end;

  Function TJLCustomRaster.DoHasPalette:Boolean;
  Begin
    result:=(FInfo.riPalSize>0) and (FInfo.riPalCnt>0);
  end;

  Procedure TJLCustomRaster.DoReleasePalette;
  Begin
    If DoHasPalette then
    Begin
      Fillchar(FInfo.riPalData,SizeOf(FInfo.riPalData),#0);
      FInfo.riPalCnt:=0;
      FInfo.riPalSize:=0;
    end;
  end;

  Function TJLCustomRaster.DefinePalette(Const Kind:TJLPaletteType):Boolean;
  var
    FCount: Integer;
    FData:  PRGBQuadArray;
  Begin
    result:=False;
    ResetLastError;
    if JL_DIBMakePalette(Kind,FCount,FData) then
    Begin
      try
        FInfo.riPalMatchMode:=Kind;
        DefinePalette(FData,FCount);
        result:=True;
      finally
        FreeMem(FData);
      end;
    end;
  end;

  Function  TJLCustomRaster.DefinePalette(Const Colors:PRGBQuadArray;
            Const Count:Integer):Boolean;
  Begin
    result:=(Colors<>NIL) and (Count>0) and (Count<=256);
    If result then
    Begin
      (* Release current palette *)
      If DoHasPalette then
      DoReleasePalette;

      (* install current palette *)
      FInfo.riPalCnt:=Count;
      FInfo.riPalSize:=Count * SizeOf(TRGBQuad);
      move(Colors^,FInfo.riPalData,FInfo.riPalSize);
    end;
  end;

  Function TJLCustomRaster.ObjectHasData:Boolean;
  Begin
    result:=FInfo.riEmpty=False;
  end;

  Procedure TJLCustomRaster.ReadObject(Const Reader:TJLReader);
  var
    wd,hd:    Integer;
    FFormat:  TJLRasterFormat;
    FSize:    Integer;
  Begin
    wd:=Reader.ReadInt;
    hd:=Reader.ReadInt;
    FFormat:=TJLRasterFormat(Reader.ReadInt);
    if (wd>0) and (hd>0) and (FFormat>rfNone) then
    Begin
      Allocate(wd,hd,FFormat);
      FSize:=Reader.Readint;
      If FSize>0 then
      Begin
        (* Read pixeldata *)
        Reader.Read(FInfo.riPxBuffer^,FSize);

        (* Read palette *)
        if FFormat=rf8Bit then
        Begin
          FInfo.riPalCnt:=Reader.ReadInt;
          FInfo.riPalSize:=Reader.ReadInt;
          Reader.Read(FInfo.riPalData,FInfo.riPalSize);
        end;
      end;
    end;
  end;

  Procedure TJLCustomRaster.WriteObject(Const Writer:TJLWriter);
  Begin
    Writer.WriteInt(FInfo.riWidth);
    Writer.WriteInt(FInfo.riHeight);
    Writer.WriteInt(Ord(FInfo.riFormat));
    If FInfo.riEmpty=False then
    Begin
      (* write pixel data *)
      Writer.WriteInt(FInfo.riPxBufferSize);
      Writer.Write(FInfo.riPxBuffer^,FInfo.riPxBufferSize);

      (* write palette *)
      If FInfo.riFormat=rf8Bit then
      Begin
        Writer.WriteInt(FInfo.riPalCnt);
        Writer.WriteInt(FInfo.riPalSize);
        Writer.Write(FInfo.riPalData[0],FInfo.riPalSize);
      end;
    end;
  end;

  {Procedure TJLCustomRaster._ReadBin(Stream:TStream);
  var
    wd,hd:    Integer;
    FFormat:  TJLRasterFormat;
    FSize:    Integer;
    FReader:  TJLStreamReader;
  Begin
    FReader:=TJLStreamReader.Create(Stream);
    try
      wd:=FReader.ReadInt;
      hd:=FReader.ReadInt;
      FFormat:=TJLRasterFormat(FReader.ReadInt);
      if (wd>0) and (hd>0) and (FFormat>rfNone) then
      Begin
        Allocate(wd,hd,FFormat);
        FSize:=FReader.Readint;
        If FSize>0 then
        Begin
          (* Read pixeldata *)
          FReader.Read(FInfo.riPxBuffer^,FSize);

          (* Read palette *)
          if FFormat=rf8Bit then
          Begin
            FInfo.riPalCnt:=FReader.ReadInt;
            FInfo.riPalSize:=FReader.ReadInt;
            FReader.Read(FInfo.riPalData,FInfo.riPalSize);
          end;
        end;
      end;
    finally
      FReader.free;
    end;
  end;

  Procedure TJLCustomRaster._WriteBin(Stream:TStream);
  var
    FWriter:TJLStreamWriter;
  Begin
    FWriter:=TJLStreamWriter.Create(Stream);
    try
      FWriter.WriteInt(FInfo.riWidth);
      FWriter.WriteInt(FInfo.riHeight);
      FWriter.WriteInt(Ord(FInfo.riFormat));
      If FInfo.riEmpty=False then
      Begin
        (* write pixel data *)
        FWriter.WriteInt(FInfo.riPxBufferSize);
        FWriter.Write(FInfo.riPxBuffer^,FInfo.riPxBufferSize);

        (* write palette *)
        If FInfo.riFormat=rf8Bit then
        Begin
          FWriter.WriteInt(FInfo.riPalCnt);
          FWriter.WriteInt(FInfo.riPalSize);
          FWriter.Write(FInfo.riPalData[0],FInfo.riPalSize);
        end;

      end;
    finally
      FWriter.free;
    end;
  end;

  Procedure TJLCustomRaster.DefineProperties(Filer:TFiler);
  Begin
    inherited;
    Filer.DefineBinaryProperty('rstdat',_ReadBin,_WriteBin,
    FInfo.riEmpty=False);
  end;  }

  Function TJLCustomRaster.MakeCanvas(out Canvas:TJLRawCanvas):Boolean;
  Begin
    result:=True;
    try
      Canvas:=TJLRawCanvas.Create(self);
    except
      on e: exception do
      Begin
        result:=False;
        SetLastError(e.message);
      end;
    end;
  end;

  Function TJLCustomRaster.MakeStream(out Stream:TStream):Boolean;
  Begin
    result:=True;

    try
      Stream:=TMemoryStream.Create;
    except
      on e: exception do
      Begin
        result:=False;
        SetLastError(e.message);
      end;
    end;

    try
      Stream.WriteComponent(self);
      Stream.Position:=0;
    except
      on e: exception do
      Begin
        result:=False;
        FreeAndNil(Stream);
        SetLastError(e.message);
      end;
    end;
  end;

  {Function TJLCustomRaster.MakeTempDC(out Value:PJLDCData):Boolean;
  var
    FError: AnsiString;
  Begin
    (* Allocate TempDC data *)
    try
      Value:=allocMem(SizeOf(TJLDCData));
    except
      on e: exception do
      Begin
        Value:=NIL;
        SetlastError(e.message);
      end;
    end;

    (* Prepare data structure *)
    Fillchar(Value^,SizeOf(Value),#0);
    Value^.ddSize:=SizeOf(TJLDCData);

    (* Allocate tempDC *)
    result:=JL_DibFromRaster(Value,Self,FError);
    If not result then
    Begin
      FreeMem(Value);
      Value:=NIL;
      SetLastError(FError);
    end;
  end;     }

  Function  TJLCustomRaster.Allocate(AWidth:Integer;AHeight:Integer;
            Const AFormat:TJLRasterFormat=rf24Bit):Boolean;
  var
    FPitch: Integer;
    FData:  Pointer;
    FLen:   Integer;
  Begin
    ResetLastError;
    If not Empty then
    Release;

    (* signal event Before Alloc *)
    SignalBeforeAlloc;

    result:=DoAllocPixels(AWidth,AHeight,AFormat,FData,FPitch,FLen);
    If result then
    Begin
      FInfo.riEmpty:=False;
      FInfo.riFormat:=AFormat;
      FInfo.riWidth:=AWidth;
      FInfo.riHeight:=AHeight;
      FInfo.riPitch:=FPitch;
      FInfo.riPxBuffer:=FData;
      FInfo.riPxBufferSize:=FLen;
      FInfo.riBoundsRect:=Rect(0,0,AWidth-1,AHeight-1);
      FInfo.riClipRect:=FInfo.riBoundsRect;
      FInfo.riClipped:=False;
      FInfo.riPenMode:=pmCopy;
      FInfo.riPixelBytes:=_rkPxBytes[AFormat];
      FInfo.riPixelBits:=_rkPxBits[AFormat];
      FInfo.riPenAlpha:=128;

      { if  (AFormat=rf8Bit)
      and (DoHasPalette=False) then
      SetPaletteType(plNetscape);      }

      (* signal event After Alloc *)
      SignalAfterAlloc;
    end;
  end;

  Function TJLCustomRaster.Release:Boolean;
  Begin
    ResetLastError;
    result:=FInfo.riEmpty=False;
    If result then
    Begin
      (* signal event Before release *)
      SignalBeforeRelease;

      result:=DoReleasePixels(FInfo.riPxBuffer);
      If result then
      Begin
        If DoHasPalette then
        DoReleasePalette;

        Fillchar(FInfo,SizeOf(FInfo),#0);
        FInfo.riSize:=SizeOf(FInfo);
        FInfo.riEmpty:=True;
        FInfo.riFormat:=rfNone;
        FInfo.riTransColor:=clNone;
        FUpdateCnt:=0;

        (* signal event After release *)
        SignalAfterRelease;
      end;
    end else
    SetLastError(ERR_JL_RASTER_EMPTY);
  end;

  Function TJLCustomRaster.PixelAddr(Const Col,Row:Integer):Pointer;
  Begin
    If  (Col>=FInfo.riBoundsRect.Left)
    and (Col<=FInfo.riBoundsRect.Right)
    and (Row>=FInfo.riBoundsRect.Top)
    and (Row<=FInfo.riBoundsRect.Bottom) then
    Result:=PTR(Integer(FInfo.riPxBuffer)
    + (FInfo.riPitch * row)
    + (Col * FInfo.riPixelBytes)) else
    result:=NIL;
  end;

  Function TJLCustomRaster.AdjustToClipRectEx(var Value:TRect):Boolean;
  Begin
    AdjustToClipRect(Value);
    result:=jlcommon.JL_RectValid(Value);
  end;


  {Procedure TJLCustomRaster.HLine(Col,Row:Integer;ACount:Integer);
  var
    FTemp:  Integer;
    FRight: Integer;
  Begin
    If not Empty then
    Begin
      If Col<FInfo^.riClipRect.Left then
      Begin
        FTemp:=JL_Diff(col,FInfo^.riClipRect.Left);
        dec(ACount,FTemp);
        col:=FInfo^.riClipRect.Left;
      end;

      FRight:=(Col + ACount)-1;
      If FRight > FInfo^.riClipRect.Right then
      Begin
        FTemp:=JL_Diff(FRight,FInfo^.riClipRect.right);
        dec(ACount,FTemp);
      end;

      If ACount>0 then
      _FillRow(FInfo,row,col,ACount,FInfo^.riNative);
    end else
    SetLastError(ERR_JL_RASTER_EMPTY);
  end;

  Procedure TJLCustomRaster.VLine(Col,Row:Integer;ACount:Integer);
  var
    FBottom:  Integer;
    FTemp:    Integer;
  Begin
    If not Empty then
    Begin
      (* Always from the top-down *)
      If (Row + ACount)<Row then
      Begin
        ACount:=abs(ACount);
        dec(Row,ACount);
      end;

      (* Clip top *)
      If Row<FInfo^.riClipRect.top then
      Begin
        FTemp:=JL_Diff(Row,FInfo^.riClipRect.top);
        dec(ACount,FTemp);
        Row:=FInfo^.riClipRect.top;
      end;

      If ACount>0 then
      Begin

        (* clip bottom *)
        FBottom:=((Row + ACount)-1);
        If FBottom > FInfo^.riClipRect.bottom then
        Begin
          FTemp:=JL_Diff(FBottom,FInfo^.riClipRect.bottom);
          dec(ACount,FTemp);
        end;

        if ACount>0 then
        _FillCol(FInfo,col,row,ACount,FInfo^.riNative);
      end;
    end else
    SetLastError(ERR_JL_RASTER_EMPTY);
  end;        }

  Procedure TJLCustomRaster.AdjustToClipRect(var Value:TRect);
  Begin
    If not FInfo.riEmpty then
    Begin
      JL_RectRealize(Value);
      If Value.left<FInfo.riClipRect.Left then
      Value.Left:=FInfo.riClipRect.Left else
      if Value.left>FInfo.riClipRect.Right then
      Value.left:=FInfo.riClipRect.Right;
      If Value.right<FInfo.riClipRect.Left then
      Value.right:=FInfo.riClipRect.Left else
      if Value.right>FInfo.riClipRect.Right
      then Value.right:=FInfo.riClipRect.Right;
      if Value.Top<FInfo.riClipRect.Top then
      Value.top:=FInfo.riClipRect.Top else
      if Value.top>FInfo.riClipRect.bottom then
      Value.top:=FInfo.riClipRect.bottom;
      if Value.bottom<FInfo.riClipRect.Top then
      Value.bottom:=FInfo.riClipRect.Top else
      if Value.bottom>FInfo.riClipRect.bottom then
      Value.bottom:=FInfo.riClipRect.Bottom;
    end else
    Value:=JL_NULLRECT;
  end;
  
  Procedure TJLCustomRaster.AdjustToBoundsRect(Var Value:TRect);
  Begin
    If not FInfo.riEmpty then
    Begin
      JL_RectRealize(Value);
      If Value.left<FInfo.riBoundsRect.Left then
      Value.Left:=FInfo.riBoundsRect.Left else

      if Value.left>FInfo.riBoundsRect.Right then
      Value.left:=FInfo.riBoundsRect.Right;

      If Value.right<FInfo.riBoundsRect.Left then
      Value.right:=FInfo.riBoundsRect.Left else

      if Value.right>FInfo.riBoundsRect.Right
      then Value.right:=FInfo.riBoundsRect.Right;

      if Value.Top<FInfo.riBoundsRect.Top then
      Value.top:=FInfo.riBoundsRect.Top else

      if Value.top>FInfo.riBoundsRect.bottom then
      Value.top:=FInfo.riBoundsRect.bottom;

      if Value.bottom<FInfo.riBoundsRect.Top then
      Value.bottom:=FInfo.riBoundsRect.Top else

      if Value.bottom>FInfo.riBoundsRect.bottom then
      Value.bottom:=FInfo.riBoundsRect.Bottom;
    end;
  end;

  Procedure TJLCustomRaster.SetUseExceptions(Value:Boolean);
  Begin
    FInfo.riUseExcept:=Value;
  end;

  Procedure TJLCustomRaster.SetClipRect(Value:TRect);
  Begin
    If not Empty then
    Begin
      JL_RectRealize(Value);
      If JL_RectValid(Value) then
      Begin
        FInfo.riClipRect:=Value;
        AdjustToBoundsRect(FInfo.riClipRect);
        FInfo.riClipped:=JL_RectValid(FInfo.riClipRect);
        If not FInfo.riClipped then
        FInfo.riClipRect:=FInfo.riBoundsRect;
      end else
      RemoveClipRect;
    end;
  end;

  Procedure TJLCustomRaster.RemoveClipRect;
  Begin
    If not FInfo.riEmpty then
    Begin
      FInfo.riClipRect:=FInfo.riBoundsRect;
      FInfo.riClipped:=False;
    end;
  end;

  Procedure TJLCustomRaster.SetLastError(Const Value:String);
  Begin
    StrPCopy(@FInfo.riLastError[1],Value);
    If FInfo.riUseExcept then
    Raise EJLCustomRaster.CreateFmt
    ('Class %s threw exception "%s" in unit %s',
    [JL_GetObjectPath(self),Value,JL_GetObjectUnit(self)]);
  end;

  Function TJLCustomRaster.GetLastError:String;
  Begin
    Result:=StrPas(@FInfo.riLastError[1]);
  end;

  Function TJLCustomRaster.GetScanLn(Const Index:Integer):Pointer;
  Begin
    If not FInfo.riEmpty
    and (Index>=0) and (index<FInfo.riHeight) then
    result:=PTR(Integer(FInfo.riPxBuffer) + (Index * FInfo.riPitch)) else
    result:=NIL;
  end;

  Function TJLCustomRaster.LoadFromStream(Const Stream:TStream):Boolean;
  var
    FCodec: TJLCustomCodec;
  Begin
    result:=False;
    If JL_FindCodecFor(Stream,FCodec) then
    Begin
      try
        FCodec.LoadFromStream(Stream,self);
        result:=True;
      except
        on e: exception do
        SetLastError(e.message);
      end;
    end;
  end;

  Function TJLCustomRaster.LoadFromFile(Const Filename:String):Boolean;
  var
    FStream:  TFileStream;
  Begin
    FStream:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
    try
      result:=LoadFromStream(FStream);
    finally
      FStream.free;
    end;
  end;

  Function TJLCustomRaster.LoadFromBuffer(Const Buffer:TJLBufferCustom):Boolean;
  var
    FStream:  TJLBufferWrapper;
  Begin
    FStream:=TJLBufferWrapper.Create(Buffer);
    try
      result:=LoadFromStream(FStream);
    finally
      FStream.free;
    end;
  end;

  Function TJLCustomRaster.SaveToStream(Const Stream:TStream;
           Codec:TJLCustomCodec):Boolean;
  Begin
    result:=Stream<>NIL;
    If result then
    Begin
      If Codec=NIL then
      Begin
        result:=JL_GetCodecByClass(TJLBitmapCodec,Codec);
        If not result then
        SetLastError('No output codec available error');
      end;

      If result then
      Begin
        result:=(ccWrite in Codec.CoCaps);
        If result then
        Begin
          try
            Codec.SaveToStream(Stream,self);
          except
            on e: exception do
            Begin
              result:=False;
              SetLastError(e.message);
            end;
          end;
        end else
        SetLastError('Codec does not support writing error');
      end else
      SetLastError('Invalid target stream error, parameter is NIL');
    end;
  end;

  Function TJLCustomRaster.SaveToFile(Const Filename:String;
           Codec:TJLCustomCodec):Boolean;
  var
    FFile:  TFileStream;
  Begin
    FFile:=TFileStream.Create(Filename,fmCreate);
    try
      result:=SaveToStream(FFile,Codec);
    finally
      FFile.free;
    end;
  end;

  Function TJLCustomRaster.SaveToBuffer(Const Buffer:TJLBufferCustom;
           Codec:TJLCustomCodec):Boolean;
  var
    FStream:  TJLBufferWrapper;
  Begin
    FStream:=TJLBufferWrapper.Create(Buffer);
    try
      Result:=SaveToStream(FStream,Codec);
    finally
      FStream.free;
    end;
  End;

  Function TJLCustomRaster.GetPalColor(Const Index:Integer):TColor;
  Begin
    ResetLastError;
    If DoHasPalette then
    Begin
      if (Index>=0) and (index<FInfo.riPalCnt) then
      result:=RGB(FInfo.riPalData[index].rgbRed,
      FInfo.riPalData[index].rgbGreen,
      FInfo.riPalData[index].rgbBlue) else
      Begin
        result:=clNone;
        SetLastError('Invalid color index error');
      end;
    end else
    Begin
      result:=clNone;
      SetLastError('No Palette allocated for raster');
    end;
  end;

  Function TJLCustomRaster.ReMap(Const APalType:TJLPaletteType):TJLCustomRaster;
  var
    x,y:  Integer;
    FTarget:  TJLRawCanvas;
    FSource:  TJLRawCanvas;
  Begin
    result:=NIL;
    if not FInfo.riEmpty then
    Begin
      Result:=Clone([]);
      Result.Allocate(Width,height,rf8Bit);
      Result.DefinePalette(APalType);
      //result.PaletteType:=APalType;

      if Result.MakeCanvas(FTarget) then
      Begin
        try
          If self.MakeCanvas(FSource) then
          Begin
            try
              For y:=0 to FInfo.riBoundsRect.Bottom do
              for x:=0 to FInfo.riBoundsRect.Right do
              FTarget.SetPixel(x,y,FSource.GetPixel(x,y));
            finally
              FSource.free;
            end;
          end;
        finally
          FTarget.free;
        end;
      end;
    end;
  end;

  Function TJLCustomRaster.UpdatePalette:Boolean;
  var
    FTemp:  TRGBQuadArray;
  Begin
    ResetLastError;
    result:=(FInfo.riEmpty=False)
    and (FInfo.riFormat=rf8Bit)
    and DoHasPalette;
    If result then
    Begin
      {if FInfo.riPalKind=plUser then
      Begin}
        FTemp:=FInfo.riPalData;
        result:=DefinePalette(@FTemp,FInfo.riPalCnt);
      {end else
      SetLastError('A static palette can not be changed'); }
    end else
    SetLastError('No palette can be updated for the surface');
  end;

  Procedure TJLCustomRaster.SetTransparentColor(Value:TColor);
  Begin
    if (csLoading in ComponentState) then
    Begin
      If (Value shr 24)=$FF then
      Value:=graphics.ColorToRGB(Value);
      FInfo.riTransColor:=Value;
    end else
    Begin

    if FInfo.riEmpty=False then
    Begin
      If Value<>FInfo.riTransColor then
      Begin
        If Value<>clNone then
        Begin
          If (Value shr 24)=$FF then
          Value:=graphics.ColorToRGB(Value);
          FInfo.riTransColor:=Value;

          If FInfo.riFormat=rf8Bit then
          FInfo.riTransIndex:=JL_MatchColor(@FInfo,Value);
        end else
        SetLastError('Invalid transparent color');
      end;
    end;

    end;
  end;

  Procedure TJLCustomRaster.SetTransparent(Const Value:Boolean);
  Begin
    if (csLoading in ComponentState) then
    FInfo.riTransparent:=Value else
    Begin
      If FInfo.riEmpty=False then
      FInfo.riTransparent:=Value else
      SetLastError(ERR_JL_RASTER_EMPTY);
    end;
  end;
  
  Procedure TJLCustomRaster.SetPalColor(Const Index:Integer;Value:TColor);
  Begin
    If DoHasPalette then
    Begin
      If (Index>=0) and (index<FInfo.riPalCnt) then
      Begin
        { If FInfo.riPalKind=plUser then
        Begin   }
          If (Value shr 24)=$FF then
          Value:=graphics.ColorToRGB(Value);
          With FInfo.riPalData[index] do
          Begin
            rgbRed:=GetRvalue(Value);
            rgbGreen:=GetGValue(Value);
            rgbBlue:=GetBValue(Value);
          end;

          (* Signal color-changed event *)
          SignalPalColorChange;

        {end else
        SetLastError('Can not change a static palette');   }
      end else
      SetLastError(Format('Invalid color index error, expected %d..%d not %d',
      [0,FInfo.riPalCnt,Index]));
    end else
    SetLastError('No palette defined for surface error');
  end;

  (*
  Procedure TJLCustomRaster.SetPaletteType(Const value:TJLPaletteType);
  {$I 'userpalette.inc'}
  var
    x:      Integer;
    FCount: Integer;
    FData:  PRGBQuadArray;
  Begin
    { If  (FInfo.riEmpty=False)
    and (FInfo.riFormat=rf8Bit) then
    Begin  }
      Case Value of
        plNone: DoReleasePalette;
        plNetscape:
          Begin
            if JL_AllocNetscapeColorTable(FCount,FData) then
            Begin
              try
                DefinePalette(FData,FCount,plNetScape);
              finally
                FreeMem(FData);
              end;
            end else
            SetLastError('Failed to allocate netscape palette error');
          end;
        plIndexed:
          Begin
            if JL_AllocIndexedColorTable(FCount,FData) then
            Begin
              try
                DefinePalette(FData,FCount,plNetScape);
              finally
                FreeMem(FData);
              end;
            end else
            SetLastError('Failed to allocate indexed palette error');
          end;
        plUser:
          Begin
            If JL_AllocDibColorTable(256,FData) then
            Begin
              try
	              for x:=1 to 256 do
                PLongword(@FData^[x-1])^:=Default_PAL[x-1];
                DefinePalette(FData,256,plUser);
              finally
                FreeMem(FData);
              end;
            end else
            SetLastError('Failed to allocate userpalette error');
          end;
      end;
    { end else
    SetLastError('No palette can be set for the current raster');  }
  end;      *)

  //###########################################################################
  // TJLJPGCodec
  //###########################################################################
  {
  Function TJLPNGCodec.GetCodecCaps:TJLCodecCaps;
  Begin
    result:=[ccRead];
  end;

  Function TJLPNGCodec.GetCodecDescription:AnsiString;
  Begin
    result:='PNG image';
  end;

  Function TJLPNGCodec.GetCodecExtension:AnsiString;
  Begin
    result:='.png';
  end;

  Function TJLPNGCodec.Eval(Const Stream:TStream):Boolean;
  Begin
  end;

  Procedure TJLPNGCodec.LoadFromStream(Const Stream:TStream;
            Const Raster:TJLCustomRaster);
  Begin
  end;

  Procedure TJLPNGCodec.SaveToStream(Const Stream:TStream;
            Const Raster:TJLCustomRaster);
  Begin
  end;
  }

  //###########################################################################
  //
  //###########################################################################

  Procedure _WritePixel(Const Info:PJLRasterInfo;
            Const Col,Row:Integer;Const inData);
  Begin
    Case Info^.riPixelBytes of
    1:  PByte(Integer(Info^.riPxBuffer)
        + (Info^.riPitch * row) + Col )^:=Byte(inData);
    2:  PWord(Integer(Info^.riPxBuffer)
        + (Info^.riPitch * row) + (Col * 2))^:=Word(inData);
    3:  PRGBTriple(Integer(Info^.riPxBuffer)
        + (Info^.riPitch * row) + (Col * 3))^:=TRGBTriple(inData);
    4:  PLongword(Integer(Info^.riPxBuffer)
        + (Info^.riPitch * row) + (Col * 4))^:=Longword(inData);
    end;
  end;

  Procedure _ReadPixel(Const Info:PJLRasterInfo;
            Const Col,Row:Integer;out outData);
  Begin
    Case Info^.riPixelBytes of
    1:  Byte(outData):=PByte(Integer(Info^.riPxBuffer)
              + (Info^.riPitch * row) + Col)^;
    2:  Word(outData):=PWord(Integer(Info^.riPxBuffer)
        + (Info^.riPitch * row) + (Col * 2))^;
    3:  TRGBTriple(outData):=PRGBTriple(Integer(Info^.riPxBuffer)
        + (Info^.riPitch * row) + (Col * 3))^;
    4:  Longword(outData):=PLongword(Integer(Info^.riPxBuffer)
        + (Info^.riPitch * row) + (Col * 4))^;
    end;
  end;

  Procedure _BlendPixel(Const Info:PJLRasterInfo;
            Const thisPixel,thatPixel;Const Factor:Byte;
            out outPixel);
  var
    rs,gs,bs,
    rd,gd,bd: Byte;
    rx,gx,bx: Byte;
  Begin
    Case Info^.riFormat of
    rf8Bit:
      Begin
        With Info^.riPalData[Byte(ThisPixel)] do
        Begin
          rs:=rgbRed;
          gs:=rgbGreen;
          bs:=rgbBlue;
        end;

        With Info^.riPalData[Byte(thatPixel)] do
        Begin
          rd:=rgbRed;
          gd:=rgbGreen;
          bd:=rgbBlue;
        end;

        rx:=Byte(((rs-rd) * Factor) shr 8 + rd);
        gx:=Byte(((gs-gd) * Factor) shr 8 + gd);
        bx:=Byte(((bs-bd) * Factor) shr 8 + bd);
        Byte(outPixel):=JL_MatchColor(Info,rx,gx,bx);
      end;
    rf15Bit:
      Begin
        rs:=((Word(thisPixel) and $7C00) shr 10) shl 3;
        gs:=((Word(thisPixel) and $03E0) shr 5) shl 3;
        bs:= (Word(thisPixel) and $001F) shl 3;
        rd:=((Word(thatPixel) and $7C00) shr 10) shl 3;
        gd:=((Word(thatPixel) and $03E0) shr 5) shl 3;
        bd:= (Word(thatPixel) and $001F) shl 3;
        rx:=Byte(((rs-rd) * Factor) shr 8 + rd);
        gx:=Byte(((gs-gd) * Factor) shr 8 + gd);
        bx:=Byte(((bs-bd) * Factor) shr 8 + bd);
        Word(outPixel):=(Rx shr 3) shl 10 + (Gx shr 3) shl 5 + (Bx shr 3);
      end;
    rf16Bit:
      Begin
        rs:=((Word(thisPixel) and $F800) shr 11) shl 3;
        gs:=((Word(thisPixel) and $07E0) shr 5) shl 2;
        bs:=(Word(thisPixel) and $001F) shl 3;
        rd:=((Word(thatPixel) and $F800) shr 11) shl 3;
        gd:=((Word(thatPixel) and $07E0) shr 5) shl 2;
        bd:=(Word(thatPixel) and $001F) shl 3;
        rx:=byte(((rs-rd) * Factor) shr 8 + rd);
        gx:=byte(((gs-gd) * Factor) shr 8 + gd);
        bx:=byte(((bs-bd) * Factor) shr 8 + bd);
        Word(outPixel):=(Rx shr 3) shl 11 or
        (Gx shr 2) shl 5 or (Bx shr 3);
      end;
    rf24Bit:
      Begin
        With TRGBTriple(thispixel) do
        Begin
          rs:=rgbtRed;
          gs:=rgbtGreen;
          bs:=rgbtBlue;
        end;

        With TRGBTriple(thatPixel) do
        Begin
          rd:=rgbtRed;
          gd:=rgbtGreen;
          bd:=rgbtBlue;
        end;

        with TRGBTriple(outPixel) do
        Begin
          rgbtRed:=byte(((rs-rd) * Factor) shr 8 + rd);
          rgbtGreen:=byte(((gs-gd) * Factor) shr 8 + gd);
          rgbtBlue:=byte(((bs-bd) * Factor) shr 8 + bd);
        end;
      end;
    rf32Bit:
      Begin
        with TRGBQuad(thisPixel) do
        Begin
          rs:=rgbRed;
          gs:=rgbGreen;
          bs:=rgbBlue;
        end;

        With TRGBQuad(thatPixel) do
        Begin
          rd:=rgbRed;
          gd:=rgbGreen;
          bd:=rgbBlue;
        end;

        With TRGBQuad(outPixel) do
        Begin
          rgbRed:=byte(((rs-rd) * Factor) shr 8 + rd);
          rgbGreen:=byte(((gs-gd) * Factor) shr 8 + gd);
          rgbBlue:=byte(((bs-bd) * Factor) shr 8 + bd);
        end;
      end;
    end;
  end;

  Procedure _RegionByte(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;
  var
    FLongs:     Integer;
    cols,rows:  Integer;
    FRoot:      PByte;
  Begin
    (* Break it down into cols & rows *)
    Cols:=Region.Right + 1;
    dec(Cols,Region.Left);

    rows:=Region.Bottom + 1;
    dec(rows,Region.Top);

    FLongs:=Rows shr 3;

    FRoot:=PTR(Integer(Info^.riPxBuffer) + (Info^.riPitch * Region.Top)
    + (Region.Left * Info^.riPixelBytes));
    While FLongs>0 do
    Begin
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      Fillchar(FRoot^,Cols,Byte(inData)); inc(FRoot,Info^.riPitch);
      dec(FLongs);
    end;

    Case Rows mod 8 of
    1:  Fillchar(FRoot^,Cols,Byte(inData));
    2:  Begin
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));
        end;
    3:  Begin
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));
        end;
    4:  Begin
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));
        end;
    5:  Begin
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));
        end;
    6:  Begin
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));
        end;
    7:  Begin
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));inc(FRoot,Info^.riPitch);
          Fillchar(FRoot^,Cols,Byte(inData));
        end;
    end;
  end;

  Procedure _RegionWord(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;
  var
    FLongs:     Integer;
    cols,rows:  Integer;
    FRoot:      PByte;
  Begin
    (* Break it down into cols & rows *)
    Cols:=Region.Right + 1;
    dec(Cols,Region.Left);

    rows:=Region.Bottom + 1;
    dec(rows,Region.Top);

    FLongs:=Rows shr 3;

    FRoot:=PTR(Integer(Info^.riPxBuffer) + (Info^.riPitch * Region.Top)
    + (Region.Left * Info^.riPixelBytes));
    While FLongs>0 do
    Begin
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      JL_FillWord(PWord(FRoot),Cols,word(inData)); inc(FRoot,Info^.riPitch);
      dec(FLongs);
    end;

    Case Rows mod 8 of
    1:  JL_FillWord(PWord(FRoot),Cols,word(inData));
    2:  Begin
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));
        end;
    3:  Begin
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));
        end;
    4:  Begin
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));
        end;
    5:  Begin
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));
        end;
    6:  Begin
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));
        end;
    7:  Begin
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));inc(FRoot,Info^.riPitch);
        JL_FillWord(PWord(FRoot),Cols,word(inData));
        end;
    end;
  end;

  procedure _RegionTriple(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;
  var
    FLongs:     Integer;
    cols,rows:  Integer;
    FRoot:      PByte;
  Begin
    (* Break it down into cols & rows *)
    Cols:=Region.Right + 1;
    dec(Cols,Region.Left);

    rows:=Region.Bottom + 1;
    dec(rows,Region.Top);

    FLongs:=Rows shr 3;

    FRoot:=PTR(Integer(Info^.riPxBuffer) + (Info^.riPitch * Region.Top)
    + (Region.Left * Info^.riPixelBytes));
    While FLongs>0 do
    Begin
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
      inc(FRoot,Info^.riPitch);
      dec(FLongs);
    end;

    Case Rows mod 8 of
    1:  JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
    2:  Begin
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        end;
    3:  Begin
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        end;
    4:  Begin
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        end;
    5:  Begin
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        end;
    6:  Begin
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        end;
    7:  Begin
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillTriple(PRGBTriple(FRoot),Cols,TRGBTriple(inData));
        end;
    end;
  end;

  Procedure _RegionLong(Const Info:PJLRasterInfo;
            Const Region:TRect;Const inData);cdecl;
  var
    FLongs,
    cols,rows:  Integer;
    FRoot:      PByte;
  Begin
    (* Break it down into cols & rows *)
    Cols:=Region.Right + 1;
    dec(Cols,Region.Left);

    rows:=Region.Bottom + 1;
    dec(rows,Region.Top);

    FLongs:=Rows shr 3;

    FRoot:=PTR(Integer(Info^.riPxBuffer) + (Info^.riPitch * Region.Top)
    + (Region.Left * Info^.riPixelBytes));
    While FLongs>0 do
    Begin
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
      inc(FRoot,Info^.riPitch);
      dec(FLongs);
    end;

    Case Rows mod 8 of
    1:  JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
    2:  Begin
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        end;
    3:  Begin
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        end;
    4:  Begin
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        end;
    5:  Begin
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        end;
    6:  Begin
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        end;
    7:  Begin
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        inc(FRoot,Info^.riPitch);
        JL_FillLong(PLongword(FRoot),Cols,Longword(inData));
        end;
    end;
  end;

  Procedure _FillRow(Const Info:PJLRasterInfo;Const Row:Integer;
            Col,inCount:Integer;Const inData);
  var
    FLongs:   Integer;
    FSingles: Integer;
    FAddr:    PByte;
  Begin
    FAddr:=PTR(Integer(Info^.riPxBuffer)
    + (Info^.riPitch * row)
    + (Col * Info^.riPixelBytes));

    If Info^.riPenMode=pmCopy then
    Begin
      Case Info^.riPixelBytes of
      1: Fillchar(FAddr^,inCount,Byte(indata));
      2: JL_FillWord(PWord(FAddr),inCount,word(inData));
      3: JL_FillTriple(PRGBTriple(FAddr),inCount,TRGBTriple(inData));
      4: JL_FillLong(PLongword(FAddr),inCount,Longword(inData));
      end;
    end else
    Begin
      FLongs:=inCount shr 3;
      FSingles:=inCount mod 8;
      While FLongs>0 do
      Begin
        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);

        dec(FLongs);
      end;

      while FSingles>0 do
      Begin
        _BlendPixel(Info,inData,FAddr^,Info^.riPenAlpha,FAddr^);
        inc(FAddr,Info^.riPixelBytes);
        dec(FSingles);
      end;
    end;
  end;

  Procedure _FillCol(Const Info:PJLRasterInfo;Const Col:Integer;
            Row,inCount:Integer;Const inData);
  var
    FLongs:   Integer;
    FSingles: Integer;
    dst:      PByte;
  Begin
    FLongs:=inCount shr 3;
    FSingles:=inCount mod 8;

    dst:=PTR(Integer(Info^.riPxBuffer)
    + (Info^.riPitch * row)
    + (Col * Info^.riPixelBytes));

    If Info^.riPenMode=pmCopy then
    Begin
      Case Info^.riPixelBytes of
      1:
        Begin
          while FLongs>0 do
          Begin
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dec(FLongs);
          end;
          While FSingles>0 do
          Begin
            dst^:=Byte(inData); inc(dst,Info^.riPitch);
            dec(FSingles);
          end;
        end;
      2:
        Begin
          while FLongs>0 do
          Begin
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            dec(FLongs);
          end;
          While FSingles>0 do
          Begin
            PWord(dst)^:=Word(inData); inc(dst,Info^.riPitch);
            dec(FSingles);
          end;
        end;
      3:
        Begin
          while FLongs>0 do
          Begin
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            PRGBTriple(dst)^:=TRGBTriple(inData);inc(dst,Info^.riPitch);
            dec(FLongs);
          end;
          While FSingles>0 do
          Begin
            PRGBTriple(dst)^:=TRGBTriple(inData); inc(dst,Info^.riPitch);
            dec(FSingles);
          end;
        end;
      4:
        Begin
          while FLongs>0 do
          Begin
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            PLongword(dst)^:=Longword(inData);inc(dst,Info^.riPitch);
            dec(FLongs);
          end;
          While FSingles>0 do
          Begin
            PLongword(dst)^:=Longword(inData); inc(dst,Info^.riPitch);
            dec(FSingles);
          end;
        end;
      end;

    end else
    Begin
      While FLongs>0 do
      Begin
        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);

        dec(FLongs);
      end;

      while FSingles>0 do
      Begin
        _BlendPixel(Info,inData,dst^,Info^.riPenAlpha,dst^);
        inc(dst,Info^.riPitch);
        dec(FSingles);
      end;
    end;
  end;

  Procedure _FillRegion(Const Info:PJLRasterInfo;
            Region:TRect;var inData);
  var
    y:        Integer;
    wd,hd:    Integer;
    FLongs:   Integer;
  Begin
    If Info^.riPenMode=pmCopy then
    _rkRegion[Info^.riFormat](Info,Region,inData) else
    Begin
      y:=Region.Top;
      wd:=Region.right - Region.left + 1;
      hd:=Region.bottom - Region.top + 1;

      FLongs:=hd shr 3;
      while FLongs>0 do
      Begin
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        _FillRow(Info,y,Region.left,wd,inData); inc(y);
        dec(FLongs);
      end;

      Case hd mod 8 of
      1:  _FillRow(Info,y,Region.left,wd,inData);
      2:  Begin
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData);
          end;
      3:  Begin
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData);
          end;
      4:  Begin
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData);
          end;
      5:  Begin
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData);
          end;
      6:  Begin
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData);
          end;
      7:  Begin
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData); inc(y);
            _FillRow(Info,y,Region.left,wd,inData);
          end;
      end;
    end;
  end;

  Function  JL_MatchColor(Const Info:PJLRasterInfo;R,G,B:Byte):Byte;
  var
    pc:     PRGBQuad;
    i,x,d:  Integer;
  Begin
    if  (Info<>NIL)
    and (info^.riFormat=rf8Bit) then
    Begin
      Case Info^.riPalMatchMode of
      plNetscape:
        Begin
          R := (R+25) div 51;
          G := (G+25) div 51;
          B := (B+25) div 51;
          result := B + 6 * G + 36 * R;
        end;
      plIndexed:
        Begin
          R := (R+17) div 36;
          G := (G+17) div 36;
          B := (B+41) div 84;
          result := B + (G shl 2) + (R shl 5);
        end;
      plUser:
        Begin
	        x:=765;
          result:=0;
          pc:=@Info^.riPalData[0];
          for i:=0 to Info^.riPalCnt-1 do
          begin
            if pc^.rgbBlue>b then
            d:=pc^.rgbBlue-b else
            d:=b-pc^.rgbBlue;

            if pc^.rgbGreen>g then
            Inc(d,pc^.rgbGreen-g) else
            Inc(d,g-pc^.rgbGreen);

            if pc^.rgbRed>r then
            Inc(d,pc^.rgbRed-r) else
            Inc(d,r-pc^.rgbRed);

            if d<x then
            begin
              x:=d;
              result:=i;
            end;

            Inc(pc);
          end;
        end;
      else
      Result:=0;
      end;
    end else
    result:=0;
  end;

  Function JL_MatchColor(Const Info:PJLRasterInfo;Const Value:TColor):Byte;
  var
    FTemp:  TColor;
    FUse:   PColor;
  Begin
    If (Value shr 24)=$FF then
    Begin
      FTemp:=graphics.ColorToRGB(Value);
      FUse:=@FTemp;
    end else
    FUse:=@Value;
    result:=JL_MatchColor(Info,
    Byte(FUse^),
    Byte(FUse^ shr 8),
    byte(FUse^ shr 16)
    );
  end;

  Function JL_MatchColor(Const Info:PJLRasterInfo;Const Value:TRGBQuad):Byte;
  Begin
    result:=JL_MatchColor(Info,Value.rgbRed,value.rgbGreen,Value.rgbBlue);
  end;

  Function JL_MatchColor(Const Info:PJLRasterInfo;Const Value:TRGBTriple):Byte;
  Begin
    result:=JL_MatchColor(Info,Value.rgbtRed,value.rgbtGreen,Value.rgbtBlue);
  end;

  Procedure _NativeToColor(Const Info:PJLRasterInfo;
            Const InData;out outColor:TColor);
  var
    r,g,b:  Byte;
  Begin
    Case Info^.riFormat of
    rf8Bit:   with Info^.riPalData[Byte(inData)] do
              outColor:=RGB(rgbRed,rgbgreen,rgbBlue);
    rf15Bit:
      Begin
        r:=((Word(InData) and $7C00) shr 10) shl 3;
        g:=((Word(InData) and $03E0) shr 5) shl 3;
        b:= (Word(InData) and $001F) shl 3;
        outColor:=RGB(r,g,b);
      end;
    rf16Bit:
      Begin
        r:=((Word(InData) and $F800) shr 11) shl 3;
        g:=((Word(InData) and $07E0) shr 5) shl 2;
        b:=(Word(InData) and $001F) shl 3;
        outColor:=RGB(r,g,b);
      end;
    rf24Bit:
      With TRGBTriple(InData) do
      outColor:=RGB(rgbtRed,rgbtGreen,rgbtBlue);
    rf32Bit:
      With TRGBQuad(inData) do
      outColor:=RGB(rgbRed,rgbGreen,rgbBlue);
    end;
  end;

  Procedure _ColorToNative(Const Info:PJLRasterInfo;
            Color:TColor;out outNative);
  var
    r,g,b:  Byte;
  Begin
    If (Color shr 24)=$FF then
    Color:=graphics.ColorToRGB(Color);

    r:=Byte(Color);
    g:=Byte(Color shr 8);
    b:=Byte(Color shr 16);

    { r:=GetRValue(Color);
    g:=GetGValue(Color);
    b:=GetBvalue(Color); }

    Case Info^.riFormat of
    rf8Bit:   Byte(outNative):=JL_MatchColor(Info,R,G,B);
    rf15Bit:  Word(outNative):= ((R shr 3) shl 10)
              + ((G shr 3) shl 5)
              + (B shr 3);
    rf16Bit:  Word(outNative):=((r shr 3) shl 11)
              + ((g shr 2) shl 5)
              + (b shr 3);
    rf24Bit:
      With TRGBTriple(outNative) do
      Begin
        rgbtRed:=r;
        rgbtGreen:=g;
        rgbtBlue:=b;
        {rgbtRed:=GetRValue(Color);
        rgbtGreen:=GetGValue(Color);
        rgbtBlue:=GetBValue(Color);   }
      end;

    rf32Bit:
      With TRGBQuad(outNative) do
      Begin
        rgbRed:=r;
        rgbGreen:=g;
        rgbBlue:=b;
        { rgbRed:=GetRValue(Color);
        rgbGreen:=GetGValue(Color);
        rgbBlue:=GetBValue(Color); }
      end;
    end;
  end;

  Function  JL_FindCodecFor(Const Stream:TStream;
            out outCodec:TJLCustomCodec):Boolean;
  var
    FCount: Integer;
    x:      Integer;
  Begin
    outCodec:=NIL;
    result:=Stream<>NIL;
    If result then
    Begin
      FCount:=Length(_Codecs);
      result:=FCount>0;
      If result then
      Begin
        for x:=Low(_Codecs) to high(_Codecs) do
        Begin
          result:=_Codecs[x].Eval(Stream);
          If result then
          Begin
            outCodec:=_Codecs[x];
            Break;
          end;
        end;
      end;
    end;
  end;

  Function  JL_GetCodecByClass(Const AClass:TJLCodecClass;
            out outCodec:TJLCustomCodec):Boolean;
  var
    x:  Integer;
  Begin
    outCodec:=NIL;
    result:=Length(_Codecs)>0;
    If result then
    Begin
      for x:=low(_Codecs) to high(_Codecs) do
      Begin
        result:=_Codecs[x].ClassName=AClass.ClassName;
        If result then
        Begin
          outCodec:=_Codecs[x];
          Break;
        end;
      end;
    end;
  end;

  Function  JL_FindCodecFor(Const Buffer:TJLBufferCustom;
            out outCodec:TJLCustomCodec):Boolean;overload;
  var
    FStream:  TJLBufferWrapper;
  Begin
    FStream:=TJLBufferWrapper.Create(Buffer);
    try
      result:=JL_FindCodecFor(FStream,outCodec);
    finally
      FStream.free;
    end;
  end;

  Function  JL_FindCodecFor(Const Filename:String;
            out outCodec:TJLCustomCodec):Boolean;overload;
  var
    FStream:  TStream;
  Begin
    FStream:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
    try
      result:=JL_FindCodecFor(FStream,outCodec);
    finally
      FStream.free;
    end;
  end;

  Function JL_RegisterCodec(Const Codec:TJLCustomCodec):Boolean;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    result:=Codec<>NIL;
    If result then
    Begin
      FCount:=Length(_Codecs);
      If FCount>0 then
      Begin
        (* Check if the codec is already installed *)
        for x:=1 to FCount do
        Begin
          if _Codecs[x-1]=Codec then
          Begin
            result:=False;
            Break;
          end;
        end;
      end;

      (* register the codec in the array *)
      If result then
      Begin
        SetLength(_Codecs,FCount+1);
        _Codecs[FCount]:=Codec;
      end;
    end;
  end;

  Procedure ReleaseCodecs;
  var
    x:  Integer;
  Begin
    try
      for x:=1 to length(_Codecs) do
      _Codecs[x-1].free;
    finally
      SetLength(_Codecs,0);
    end;
  end;

  Procedure JL_RxSetLastError(Const Info:PJLRasterInfo;
            Value:AnsiString);
  Begin
    If (Info<>NIL) and (Info^.riSize=SizeOf(TJLRasterInfo)) then
    Begin
      StrPCopy(@Info.riLastError[1],Value);
      If Info^.riUseExcept then
      Raise EJLCustomRaster.Create(Value);
    end;
  end;

  { Function JL_RxGetPenAlpha(Const Info:PJLRasterInfo;
           out outValue:Byte):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    outValue:=Info^.riPenAlpha;
  end;  }

  { Function JL_RxSetPenAlpha(Const Info:PJLRasterInfo;
           Const Value:Byte):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Info^.riPenAlpha:=Value;
  end;  }

  { Function JL_RxGetPenMode(Const Info:PJLRasterInfo;
           out Value:TJLPenMode):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Value:=Info^.riPenMode;
  end;  }

  { Function  JL_RxSetPenMode(Const Info:PJLRasterInfo;
            Const Value:TJLPenMode):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Info^.riPenMode:=Value;
  end; }

  { Function JL_RxGetPenColor(Const Info:PJLRasterInfo;
           out outValue:TColor):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    outValue:=Info^.riColor;
  end;  }

  { Function JL_RxSetPenColor(Const Info:PJLRasterInfo;
           Const Value:TColor):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Begin
      If Value<>Info^.riColor then
      Begin
        Info^.riColor:=Value;
        _ColorToNative(Info,Value,Info^.riNative);
      end;
    end;
  end;  }

  { Function JL_RxRemoveClipRect(Const Info:PJLRasterInfo):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Begin
      Result:=Info^.riEmpty=False;
      If result then
      Begin
        Info^.riClipRect:=Info^.riBoundsRect;
        Info^.riClipped:=False;
      end else
      JL_RxSetLastError(Info,ERR_JL_RASTER_EMPTY);
    end;
  end;  }

  { Function JL_RxSetClipRect(Const Info:PJLRasterInfo;Value:TRect):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Begin
      Result:=Info^.riEmpty=False;
      If result then
      Begin
        JL_RectRealize(Value);
        result:=(Value.right>Value.left)
        and (Value.Bottom>Value.top);
        If result then
        Begin
          Info.riClipRect:=Value;
          JL_RxAdjustToBoundsRect(Info,Info^.riClipRect);
          Info^.riClipped:=(Info^.riClipRect.right>Info^.riClipRect.left)
          and (Info^.riClipRect.Bottom>Info^.riClipRect.top);
          If not Info^.riClipped then
          result:=JL_RxRemoveClipRect(Info);
        end else
        Result:=JL_RxRemoveClipRect(Info);
      end else
      JL_RxSetLastError(Info,ERR_JL_RASTER_EMPTY);
    end;
  end;     }

  {Function  JL_RxAdjustToBoundsRect(Const Info:PJLRasterInfo;
            var Value:TRect):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Begin
      Result:=Info^.riEmpty=False;
      If result then
      Begin
        JL_RectRealize(Value);
        If Value.left<Info.riBoundsRect.Left then
        Value.Left:=Info.riBoundsRect.Left else

        if Value.left>Info.riBoundsRect.Right then
        Value.left:=Info.riBoundsRect.Right;

        If Value.right<Info.riBoundsRect.Left then
        Value.right:=Info.riBoundsRect.Left else

        if Value.right>Info.riBoundsRect.Right
        then Value.right:=Info.riBoundsRect.Right;

        if Value.Top<Info.riBoundsRect.Top then
        Value.top:=Info.riBoundsRect.Top else

        if Value.top>Info.riBoundsRect.bottom then
        Value.top:=Info.riBoundsRect.bottom;

        if Value.bottom<Info.riBoundsRect.Top then
        Value.bottom:=Info.riBoundsRect.Top else

        if Value.bottom>Info.riBoundsRect.bottom then
        Value.bottom:=Info.riBoundsRect.Bottom;
      end else
      JL_RxSetLastError(Info,ERR_JL_RASTER_EMPTY);
    end;
  end;  }

  { Function JL_RxAdjustToClipRect(Const Info:PJLRasterInfo;
           var Value:TRect):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Begin
      Result:=Info^.riEmpty=False;
      If result then
      Begin
        JL_RectRealize(Value);
        If Value.left<Info.riClipRect.Left then
        Value.Left:=Info.riClipRect.Left else

        if Value.left>Info.riClipRect.Right then
        Value.left:=Info.riClipRect.Right;

        If Value.right<Info.riClipRect.Left then
        Value.right:=Info.riClipRect.Left else

        if Value.right>Info.riClipRect.Right
        then Value.right:=Info.riClipRect.Right;

        if Value.Top<Info.riClipRect.Top then
        Value.top:=Info.riClipRect.Top else

        if Value.top>Info.riClipRect.bottom then
        Value.top:=Info.riClipRect.bottom;

        if Value.bottom<Info.riClipRect.Top then
        Value.bottom:=Info.riClipRect.Top else

        if Value.bottom>Info.riClipRect.bottom then
        Value.bottom:=Info.riClipRect.Bottom;

      end else
      JL_RxSetLastError(Info,ERR_JL_RASTER_EMPTY);
    end;
  end;       }

  { Function JL_RxFillRect(Const Info:PJLRasterInfo;ARect:TRect):Boolean;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Begin
      Result:=Info^.riEmpty=False;
      If result then
      Begin
        result:=JL_RxAdjustToClipRect(Info,ARect);
        If result then
        _FillRegion(Info,ARect,Info^.riNative);
      end else
      JL_RxSetLastError(Info,ERR_JL_RASTER_EMPTY);
    end;
  end;      }

  { Function  JL_RxFillRect(Const Info:PJLRasterInfo;ARect:TRect;
            Const AColor:TColor):Boolean;
  var
    FTemp:  Longword;
  Begin
    result:=(Info<>NIL)
    and (Info^.riSize=SizeOf(TJLRasterInfo));
    If result then
    Begin
      Result:=Info^.riEmpty=False;
      If result then
      Begin
        result:=JL_RxAdjustToClipRect(Info,ARect);
        If result and JL_RectValid(ARect) then
        Begin
          If AColor<>Info^.riColor then
          Begin
            FTemp:=0;
            _ColorToNative(Info,AColor,FTemp);
            _FillRegion(Info,ARect,FTemp);
          end else
          _FillRegion(Info,ARect,Info^.riNative);
        end;
      end else
      JL_RxSetLastError(Info,ERR_JL_RASTER_EMPTY);
    end;
  end;   }

  Initialization
  Begin
    _rkCopyLut[rf8Bit,rf8Bit]:=_Copy8bitTo8Bit;
    _rkCopyLut[rf8Bit,rf15Bit]:=_Copy8bitTo15Bit;
    _rkCopyLut[rf8Bit,rf16Bit]:=_Copy8bitTo16Bit;
    _rkCopyLut[rf8Bit,rf24Bit]:=_Copy8bitTo24Bit;
    _rkCopyLut[rf8Bit,rf32Bit]:=_Copy8bitTo32Bit;

    _rkCopyLut[rf15Bit,rf8Bit]:=_Copy15bitTo8Bit;
    _rkCopyLut[rf15Bit,rf15Bit]:=_Copy15bitTo15Bit;
    _rkCopyLut[rf15Bit,rf16Bit]:=_Copy15bitTo16Bit;
    _rkCopyLut[rf15Bit,rf24Bit]:=_Copy15bitTo24Bit;
    _rkCopyLut[rf15Bit,rf32Bit]:=_Copy15bitTo32Bit;

    _rkCopyLut[rf16Bit,rf8Bit]:=_Copy16bitTo8Bit;
    _rkCopyLut[rf16Bit,rf15Bit]:=_Copy16bitTo15Bit;
    _rkCopyLut[rf16Bit,rf16Bit]:=_Copy16bitTo16Bit;
    _rkCopyLut[rf16Bit,rf24Bit]:=_Copy16bitTo24Bit;
    _rkCopyLut[rf16Bit,rf32Bit]:=_Copy16bitTo32Bit;

    _rkCopyLut[rf24Bit,rf8Bit]:=_Copy24bitTo8Bit;
    _rkCopyLut[rf24Bit,rf15Bit]:=_Copy24bitTo15Bit;
    _rkCopyLut[rf24Bit,rf16Bit]:=_Copy24bitTo16Bit;
    _rkCopyLut[rf24Bit,rf24Bit]:=_Copy24bitTo24Bit;
    _rkCopyLut[rf24Bit,rf32Bit]:=_Copy24bitTo32Bit;

    _rkCopyLut[rf32Bit,rf8Bit]:=_Copy32bitTo8Bit;
    _rkCopyLut[rf32Bit,rf15Bit]:=_Copy32bitTo15Bit;
    _rkCopyLut[rf32Bit,rf16Bit]:=_Copy32bitTo16Bit;
    _rkCopyLut[rf32Bit,rf24Bit]:=_Copy32bitTo24Bit;
    _rkCopyLut[rf32Bit,rf32Bit]:=_Copy32bitTo32Bit;

    JL_RegisterCodec(TJLBitmapCodec.Create);
    JL_RegisterCodec(TJLGIFCodec.Create);
    JL_RegisterCodec(TJLJPGCodec.Create);
  end;

  finalization
  ReleaseCodecs;

  end.
