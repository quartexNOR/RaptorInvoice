  unit jlcommon;

  {$I 'jldefs.inc'}

  interface                                                           

  uses
  windows, typinfo, sysutils, classes,  variants, math, strutils;

  Const
  CNT_JL_KILOBYTE  = 1024;
  CNT_JL_MEGABYTE  = 1048576;
  CNT_JL_2MEGABYTE = CNT_JL_MEGABYTE * 2;
  CNT_JL_TAB       = #09;
  CNT_JL_CR        = #13;
  CNT_JL_LF        = #10;
  CNT_JL_CRLF      = CNT_JL_CR + CNT_JL_LF;
  CNT_JL_MAXSTRING = CNT_JL_MEGABYTE;

  Const
  CNT_JL_Numeric     = '0123456789';
  CNT_JL_Symbolic    = '.,;-|/\!"#%&()[]@<>*' + '''';
  CNT_JL_Characters  = 'abcdefghijklmnopqrstuvwxyzæøå '
                      + 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ';

  CNT_JL_EditCodes   = #08 { backspace }
                     + #24 {cut} ;

  CNT_JL_CharSet     = CNT_JL_Characters + CNT_JL_Numeric + CNT_JL_Symbolic;

  CNT_JL_ANSICharset = [#9,#10,#13,#32,'.',',','0'..'9','A'..'Z','a'..'z',
                        'Æ','Ø','Å','æ','ø','å',';','=',':','+','/','\',
                        '(',')','[',']','&','%','$','#','"','!','{','}','*',
                        '<','>','@','^','''','|','§','?','£','_','-','~','´'];

  varBlob = 65;

  CNT_JL_ASTRING_HEADER   = $DB07;
  CNT_JL_WSTRING_HEADER   = $DB09;
  CNT_JL_VARIANT_HEADER   = $DB0A;
  CNT_JL_COMPONT_HEADER   = $DBCA;

  Type

  EJLException        = Class(Exception);
  EJLBitsException    = Class(EJLException);

  (* 2 bit datatype *)
  TDio    = 0..3;

  (* 4 bit datatype *)
  TNibble = 0..15;

  (* 24 bit datatype *)
  PJLTriple = ^TJLTriple;
  TJLTriple = Packed Record
    nA: Byte;
    nB: Byte;
    nC: Byte;
  End;

  (* 32 bit datatype *)
  PJLQuad = ^TJLQuad;
  TJLQuad = Packed Record
    nA: Byte;
    nB: Byte;
    nC: Byte;
    nD: Byte;
  End;

  TJLPercent    = 0..100;
  TJLGematria   = (gmCommon,gmHebrew,gmBeatus,gmSepSephos);
  TJLWinOSType = (otUnknown,otWin95,otWin98,otWinME,otWinNT,otWin2000,
                  otWinXP,otVista,otWin7);

  TPtrArray   = Packed Array of Pointer;
  TStrArray   = Packed Array of String;
  TWordArray  = Packed Array of Word;
  TIntArray   = Packed Array of Integer;
  TLongArray  = Packed Array of Longword;
  TPointArray = Packed Array of TPoint;
  TRectArray  = Packed Array of TRect;
  TInt64Array = Packed Array of Int64;

  TJLExposure  = (esNone,esPartly,esCompletely);
  TJLFileScanOptions = set of (doIncludeSystemFiles,doIncludeHiddenFiles);

  { TJLString = Class
  Private
    FData:    String;
    Function  GetValue:String;
    Procedure SetValue(Value:String);
  Public
    Property  Value:String read GetValue write SetValue;
  End;        }

  //###########################################################################
  // Hash and CRC methods
  //###########################################################################

  Function  JL_ELFHash(Const Buffer;Const Bytes:Integer):Longword;overload;
  Function  JL_ELFHash(Const Value:String):Longword;overload;

  //###########################################################################
  // Number manipulation methods
  //###########################################################################

  Function  JL_Locate(Const Value:Integer;
            Const Domain:TIntArray):Integer;overload;

  Function  JL_Locate(Const Value:Longword;
            Const Domain:TLongArray):Integer;overload;

  Function  JL_Sum(Const Domain:TIntArray):Integer;

  Function  JL_Smallest(Const Primary,Secondary:Integer):Integer;overload;
  Function  JL_Smallest(Const Domain:TIntArray):Integer;overload;

  Function  JL_Largest(Const Primary,Secondary:Integer):Integer;overload;
  Function  JL_Largest(Const Domain:TIntArray):Integer;overload;

  Function  JL_PercentOfValue(Const Value,Total:Integer):Integer;overload;
  Function  JL_PercentOfValue(Const Value:Double;Total:Double):Double;overload;

  Function  JL_Middle(Const Primary,Secondary:Integer):Integer;

  Function  JL_IntAverage(Const Domain:TIntArray):Integer;

  Function  JL_IntPositive(Const Value:Integer):Integer;

  Function  JL_Diff(Const Primary,Secondary:Int64;
            Const Exclusive:Boolean=False):Int64;overload;

  Function  JL_Diff(Const Primary,Secondary:Integer;
            Const Exclusive:Boolean=False):Integer;overload;

  Function  JL_Diff(Const Primary,Secondary:Longword;
            Const Exclusive:Boolean=False):Longword;overload;

  Procedure JL_Swap(Var Primary,Secondary:Word);overload;
  Procedure JL_Swap(Var Primary,Secondary:Integer);overload;
  Procedure JL_Swap(Var Primary,Secondary:Longword);overload;
  Procedure JL_Swap(Var Primary,Secondary:Int64);overload;
  Procedure JL_Swap(Var Primary,Secondary:String);overload;

  Function  JL_Wrap(Const Value,LowRange,HighRange:Integer):Integer;

  Procedure JL_SwapLess(var Primary,Secondary:Integer);
  Procedure JL_SwapMore(var Primary,Secondary:Integer);

  Function  JL_ToNearest(Const Value,Factor:Integer):Integer;overload;
  Function  JL_ToNearest(Const Value,Factor:Integer;
            Const Progressive:Boolean):Integer;overload;

  Function  JL_StrideAlign(Const Value,ElementSize:Integer;
            Const AlignSize:Integer=4):Integer;

  Function  JL_PrimeNumber(Const Value:Longword):Boolean;
  Function  JL_PrimeNumberFind(Const Value:Longword):Longword;

  //###########################################################################
  // Binary number encoding/decoding methods
  //###########################################################################

  Function  JL_BinToInt(Const Value:String):Integer;
  Function  JL_IntToBin(Value:Integer):String;

  Function  JL_BinToWord(Const Value:String):Word;
  Function  JL_WordToBin(Value:Word):String;

  Function  JL_BinToByte(Const Value:String):Byte;
  Function  JL_ByteToBin(Value:Byte):String;

  Function  JL_LongToBin(Value:Longword):String;
  Function  JL_BinToLong(Const Value:String):Longword;

  //###########################################################################
  // RLE Compression
  //###########################################################################

  Function  JL_RLECompress(const Source,Target;
            SourceSize:Longword;Fetch:Byte):Longword;

  Function  JL_RLEDecompress(const Source,Target;
            TargetSize:Longword;Fetch:Byte):Longword;

  //###########################################################################
  // Memory methods
  //###########################################################################

  Procedure JL_FillWord(dstAddr:PWord;
            Const inCount:Integer;Const Value:Word);
  Procedure JL_FillTriple(dstAddr:PRGBTriple;
            Const inCount:Integer;Const Value:TRGBTriple);
  Procedure JL_FillLong(dstAddr:PLongword;
            Const inCount:Integer;Const Value:Longword);

  Procedure JL_MoveWord(SrcAddr,DstAddr:PWord;Const inCount:Integer);
  Procedure JL_MoveTriple(SrcAddr,DstAddr:PJLTriple;Const inCount:Integer);
  Procedure JL_MoveLong(SrcAddr,DstAddr:PLongword;Const inCount:Integer);

  //###########################################################################
  // Datatype encoding / decoding
  //###########################################################################

  Function  JL_MakeNibble(Const HighBits,LowBits:TDio):TNibble;
  Function  JL_MakeByte(Const HighBits,LowBits:TNibble):Byte;
  Function  JL_MakeWord(Const HighByte,LowByte:Byte):Word;
  Function  JL_MakeLong(Const HighWord,LowWord:Word):Longword;
  Function  JL_MakeTriple(Const aByte,bByte,cByte:Byte):TJLTriple;
  Function  JL_MakeQuad(Const aByte,bByte,cByte,dByte:Byte):TJLQuad;
  Function  JL_MakeRect(Const Left,Top,Right,Bottom:Integer):TRect;
  Function  JL_MakePTR(Const Data:Pointer;Const Value:Integer):Pointer;
  Function  JL_MakePoint(Const Left,Top:Integer):TPoint;

  Procedure JL_NibbleToDios(Const Value:TNibble;
            var HighBits,LowBits:TDio);

  Procedure JL_ByteToNibbles(Const Value:Byte;var HighBits,LowBits:TNibble);
  Procedure JL_WordToBytes(Const Value:Word;var HighByte,LowByte:Byte);
  Procedure JL_LongToWords(Const Value:Longword;Var HighWord,LowWord:Word);
  Procedure JL_TripleToBytes(Const Value:TJLTriple;
            Var aByte,bByte,cByte:Byte);
  Procedure JL_QuadToBytes(Const Value:TJLQuad;
            Var aByte,bByte,cByte,dByte:Byte);

  //###########################################################################
  // Graphical helper methods
  //###########################################################################

  Procedure JL_PntRotate(var Points:TPointArray;
            Const xOrg,yOrg:Integer;Const Angle:Extended);
  Function  JL_RectGrowWidth(Const Source:TRect;
            Const Factor:Integer):TRect;
  Function  JL_RectShrinkWidth(Const Source:TRect;
            Const Factor:Integer):TRect;
  Function  JL_RectGrowHeight(Const Source:TRect;
            Const Factor:Integer):TRect;
  Function  JL_RectShrinkHeight(Const Source:TRect;
            Const Factor:Integer):TRect;
  Function  JL_RectHeight(Const ARect:TRect):Integer;
  Function  JL_RectWidth(Const ARect:TRect):Integer;
  Function  JL_RectAdjust(Const ChildRect:TRect;Const X,Y:Integer):TRect;
  Procedure JL_RectFit(Const WorldRect:TRect;Const ObjRect:TRect;
            out Value:TRect);

  Function  JL_RectToStr(Const Value:TRect;
            Const LineFeed:Boolean=True):String;
  Function  JL_RectFrom(Const Domain:TPointArray;
            var Value:TRect):Boolean;
  Function  JL_RectEqual(Const Primary,Secondary:TRect):Boolean;
  function  JL_RectUnion(const Primary,Secondary:TRect):TRect;
  Function  JL_RectInterior(Const Value:TRect):TRect;
  Function  JL_RectExterior(Const Value:TRect):TRect;
  Function  JL_RectWithin(Const objRect,worldRect:TRect):Boolean;

  Function  JL_RectClip(Const Domain:TRect;var Value:TRect):Boolean;overload;

  function  JL_RectIntersect(const Primary,Secondary:TRect;
            var Intersection:TRect): Boolean;

  Function  JL_RectDiff(Const Primary,Secondary:TRect;
            var Width,Height:Integer):Boolean;

  function  JL_RectArea(const inRect:TRect):Int64;

  Function  JL_RectExpose(Const objRect,worldRect:TRect):TJLExposure;
  Procedure JL_RectRealize(var Value:TRect);
  Function  JL_RectValid(Const Value:TRect):Boolean;

  Function  JL_PntDistance(Const Primary,Secondary:TPoint):Integer;

  Function  JL_PntInRect(Const Primary:TRect;
            Const Value:TPoint):Boolean;

  Function  JL_PntInPolygon(Const Domain:TPointArray;
            Const Value:TPoint):Boolean;

  Function  JL_PosInRect(Const Primary:TRect;
            Const Left,Top:Integer):Boolean;

  Function  JL_PosInPolygon(Const Domain:TPointArray;
            Const Left,Top:Integer):Boolean;

  Function  JL_PosDistance(Const Left,Top,Right,Bottom:Integer):Integer;

  Function  JL_LineClip(Domain:TRect;var Left,Top,Right,Bottom:Integer):Boolean;


  Function  JL_SetClipRect(Const Handle:HDC;Const aRect:TRect):Boolean;
  Procedure JL_RemoveClipRect(Handle:HDC);
  Function  JL_GetWin32Error(Const Code:Integer):String;

  //###########################################################################
  // File methods
  //###########################################################################

  Function  JL_GetTempFileName:String;
  Function  JL_FileSize(Const Filename:String):Int64;
  Function  JL_FileModified(Const Filename:String):TDateTime;
  Function  JL_FileCreated(Const Filename:String):TDateTime;

  function  JL_FileTimeToDateTime(filetime:TFileTime):TDateTime;
  function  JL_FileTimeToTime(filetime:TFileTime):TDateTime;
  function  JL_FileTimeToDate(filetime:TFileTime):TDateTime;

  Function  JL_DeleteFolder(FolderPath:String):Boolean;
  Function  JL_DeleteFolderContent(FolderPath:String):Boolean;

  Function  JL_FolderSubDirectoryCount(Const FolderPath:String;
            var Count:Integer):Boolean;

  Function  JL_FolderExamineFiles(Const FolderPath:String;
            var Value:TStrArray;
            var Count:Integer;
            Const Options:TJLFileScanOptions=
            [doIncludeSystemFiles,doIncludeHiddenFiles]):Boolean;

  Function  JL_FolderExamineDirectories(Const FolderPath:String;
            var Value:TStrArray;
            var Count:Integer):Boolean;

  Function  JL_FolderPathUntangle(Const Value:String):String;

  Function  JL_FolderSizeBytes(Const FolderPath:String;
            var Value:Int64):Boolean;

  Function  JL_FolderFileCount(Const FolderPath:String;
            var Value:Int64):Boolean;

  Function  JL_FolderSizeKb(Const FolderPath:String;
            var Value:Int64):Boolean;

  Function  JL_FolderSizeMb(Const FolderPath:String;
            var Value:Int64):Boolean;

  Function  JL_MakeDir(Const Value:String):Boolean;
                   
  Function  JL_FileToStr(Const Filename:String;
            Var Value:String):Boolean;

  Function  JL_StrToFile(Const Filename:String;
            Const Value:String):Boolean;

  Function  JL_StreamToStr(Const Stream:TStream;
            var Value:String):Boolean;
            
  //###########################################################################
  // Array methods
  //###########################################################################

  Procedure JL_StrArrayAdd(Const Value:String;
            Var Domain:TStrArray);

  Procedure JL_StrArrayDelete(Var Domain:TStrArray;
            Const Index:Integer);

  Procedure JL_IntArrayAdd(Var Domain:TIntArray;
            Const Value:Integer);

  Procedure JL_IntArrayDelete(var Domain:TIntArray;
            Const Index:Integer);

  Procedure JL_Int64ArrayDelete(var Domain:TInt64Array;
            Const Index:Integer);

  Procedure JL_LongArrayDelete(var Domain:TLongArray;
            Const Index:Integer);

  Procedure JL_WordArrayDelete(var Domain:TWordArray;
            Const Index:Integer);

  Procedure JL_RectArrayDelete(var Domain:TRectArray;
            Const Index:Integer);

  Procedure JL_PntArrayDelete(var Domain:TPointArray;
            Const Index:Integer);

  Function  JL_PntToStr(Const Value:TPoint):String;

  Function  JL_StrArray(Const Domain:Array of String):TStrArray;
  Function  JL_WordArray(Const Domain:Array of Word):TWordArray;
  Function  JL_IntArray(Const Domain:Array of Integer):TIntArray;
  Function  JL_PntArray(Const Domain:Array of TPoint):TPointArray;
  Function  JL_LongArray(Const Domain:Array of Longword):TLongArray;
  Function  JL_Int64Array(Const Domain:Array of Int64):TInt64Array;

  //###########################################################################
  // Sorting methods
  //###########################################################################

  Procedure JL_SortStr(Const Domain:TStrArray;
            Const Decending:Boolean=True);

  Procedure JL_SortWord(Const Domain:TWordArray;
            Const Decending:Boolean=True);

  Procedure JL_SortInt(Const Domain:TIntArray;
            Const Decending:Boolean=True);

  Procedure JL_SortLong(Const Domain:TLongArray;
            Const Decending:Boolean=True);

  //###########################################################################
  // String methods
  //###########################################################################

  Function  JL_StrClip(Value:String;MaxLen:Integer):String;

  Function  JL_StrPush(Const Value:String;var Domain:String):Boolean;

  Procedure JL_StrAdd(Const Value:String;var Domain:String;
            Const AddCRLF:Boolean=False);overload;

  Function  JL_StrAdd(Const Value:String;Var Domain:String;
            Const LengthLimit:Integer):Boolean;overload;

  Function  JL_StrToElements(Const Value:String;
            var Domain:TStrArray;
            Const Delimiter:Char=' '):Integer;

  Function  JL_CharIsNumeric(Const Value:AnsiChar):Boolean;
  Function  JL_CharIsAlpha(Const Value:AnsiChar):Boolean;
  Function  JL_CharIsAlphaNumeric(Const Value:Char):Boolean;
  Function  JL_CharIsAnsi(Const Value:AnsiChar):Boolean;

  function  JL_URLDecode(Const Value:String):String;
  function  JL_URLEncode(Const Value:String):String;

  Function  JL_CharToGematria(Value:String;
            Const Codex:TJLGematria):Integer;

  Function  JL_StrToGematria(Value:String;
            Const Codex:TJLGematria):Integer;

  Function  JL_RightStr(Const Value:String;Count:Integer):String;


  Function  JL_StrIsNumeric(Value:String):Boolean;
  Function  JL_StrIsFloat(Value:String):Boolean;
  Function  JL_StrIsBoolean(Value:String):Boolean;

  Function  JL_Locate(Const Value:String;
            Const Domain:TStrArray):Integer;overload;

  //###########################################################################
  // Bit and masking methods
  //###########################################################################

  Function  JL_BitGet(Const Index:Integer;Const Buffer):Boolean;
  Procedure JL_BitSet(Const Index:Integer;var Buffer;
            Const Value:Boolean);

  Function  JL_MaskValidValue(Const Value:Longword):Boolean;
  Function  JL_MaskSet(Const Mask,Value:Longword):Longword;overload;
  Function  JL_MaskSet(Const Mask:Longword;
            Const Values:Array of Longword):Longword;overload;
  Function  JL_MaskGet(Const Mask,Value:Longword):Boolean;overload;
  Function  JL_MaskGet(Const Mask:Longword;
            Const Values:Array of Longword):Boolean;overload;
  Function  JL_MaskClr(Const Mask,Value:Longword):Longword;overload;
  Function  JL_MaskClr(Const Mask:Longword;
            Const Values:Array of Longword):Longword;overload;

  function  JL_BitsSetInByte(Const Value:Byte):Integer;

  Function  JL_VariantToStream(Const Value:Variant):TStream;overload;
  Function  JL_VariantToStream(Const Value:Variant;
            Stream:TStream):Int64;overload;
  Function  JL_StreamToVariant(Const Value:TStream;
            FromPos:Boolean=False;Dispose:Boolean=False):Variant;


  Function  JL_GetObjectPath(Const AObject:TPersistent):String;
  Function  JL_GetObjectUnit(Const AObject:TPersistent):String;

  Function  JL_StrToGUID(const Value:AnsiString):TGUID;
  Function  JL_GUIDToStr(const GUID:TGUID):AnsiString;

  Function  JL_GetOSType(out Value:TJLWinOSType):Boolean;

  var
  JL_INVALIDRECT:  TRect  = (left:-1;top:-1;right:-1;bottom:-1);
  JL_NULLRECT:     TRect  = (left:0;top:0;right:0;bottom:0);
  JL_NULLPOINT:    TPoint = (x:0;y:0);
  JL_VOIDRECT:     TRect  = (left:MAXINT;top:MAXINT;
                                right:-MAXINT;bottom:-MAXINT);

  implementation

  Resourcestring
  ERR_JL_MASK_INVALIDMASK    = 'Invalid mask value %d';
  ERR_JL_BITS_INVALIDOFFSET  = 'Invalid bit offset, expected 0..%d, not %d';
  ERR_JL_InvalidGUID         = '[%s] is not a valid GUID value';

  const
  JLByteBits:  array [0..255] of Integer =
  (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
  1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
  2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
  3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
  4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8);

  JL_GEMATRIA_HEBREW:  Array [0..25] of Integer =
  (0,2,100,4,0,80,3,5,10,10,20,30,40,50,0,80,100,200,300,9,6,6,6,60,10,7);

  JL_GEMATRIA_COMMON:  Array [0..25] of Integer =
  (1,2,700,4,5,500,3,8,10,10,20,30,40,50,70,80,600,100,
  200,300,400,6,800,60,10,7);

  JL_GEMATRIA_BEATUS:  Array [0..25] of Integer =
  (1,2,90,4,5,6,7,8,10,10,20,30,40,50,70,80,100,200,300,400,6,6,6,60,10,7);

  JL_GEMATRIA_SEPSEPHOS: Array [0..25] of Integer =
  (1,2,3,4,5,6,7,8,10,100,10,20,30,40,50,3,70,80,200,300,400,6,80,60,10,800);

  Function JL_SetClipRect(Const Handle:HDC;Const aRect:TRect):Boolean;
  var
    FClip:  HRGN;
    FState: Integer;
  Begin
    (* Allocate region *)
    FClip:=Windows.CreateRectRgn(aRect.left,aRect.top,
    aRect.right,aRect.bottom);

    result:=FClip<>ERROR;
    If result then
    Begin
      (* Select region into hdc.
        NOTE: WinAPI creates a copy of our region. Many
        people forget this - and fails to free the region
        after selecting it, leading to a small but
        significant memory leak. *)
      FState:=Windows.SelectClipRgn(Handle,FClip);

      (* delete our clip region *)
      windows.DeleteObject(FClip);

      (* delete old region [if any] *)
      result:=(FState in [ERROR,NULLREGION])=False;

    end;
  end;

  Procedure JL_RemoveClipRect(Handle:HDC);
  Begin
    Windows.SelectClipRgn(Handle,0);
  end;

  Function JL_GetWin32Error(Const Code:Integer):String;
  Begin
    result:=sysutils.SysErrorMessage(Code);
  end;


  //#########################################################################
  //  Method:     JL_GUIDToStr()
  //  Purpose:    Convert a GUID structure to a AnsiString
  //  Returns:    AnsiString representation of a GUID structure
  //
  //  Parameters: Value:  TGUID
  //
  //  Comments:   This function is a rip-off from CLX.
  //              It is platform independent, thus i included it here.
  //#########################################################################
  Function JL_GUIDToStr(const GUID:TGUID):AnsiString;
  begin
    SetLength(Result, 38);
    StrLFmt(@Result[1],38,'{%.8x-%.4x-%.4x-%.2x%.2x-%.2x%.2x%.2x%.2x%.2x%.2x}',
    [GUID.D1, GUID.D2, GUID.D3, GUID.D4[0], GUID.D4[1], GUID.D4[2], GUID.D4[3],
    GUID.D4[4], GUID.D4[5], GUID.D4[6], GUID.D4[7]]);
  end;

  //#########################################################################
  //  Method:     JL_StrToGUID()
  //  Purpose:    Convert a AnsiString to a GUID structure
  //  Returns:    GUID data structure
  //
  //  Parameters: Value:  AnsiString
  //
  //  Comments:   This function is a rip-off from CLX.
  //              It is platform independent, thus i included it here.
  //#########################################################################
  function JL_StrToGUID(const Value:AnsiString):TGUID;
  (* var
    i:  Integer;
    src, dest: PAnsiChar;

    function _HexChar(Const C: AnsiChar): Byte;
    begin
      case C of
        '0'..'9': Result := Byte(c) - Byte('0');
        'a'..'f': Result := (Byte(c) - Byte('a')) + 10;
        'A'..'F': Result := (Byte(c) - Byte('A')) + 10;
      else        Raise Exception.CreateFmt(ERR_JL_InvalidGUID,[Value]);
      end;
    end;

    function _HexByte(Const P:PAnsiChar): Char;
    begin
      Result:=Char((_HexChar(p[0]) shl 4)+_HexChar(p[1]));
    end;
        *)
  begin
    (* If Length(Value)=38 then
    Begin
      dest := @Result;
      src := PAnsiChar(Value);
      Inc(src);

      for i := 0 to 3 do
      dest[i] := PAnsiChar(_HexByte(src+(3-i)*2));

      Inc(src, 8);
      Inc(dest, 4);
      if src[0] <> '-' then
      Raise Exception.CreateFmt(ERR_JL_InvalidGUID,[Value]);

      Inc(src);
      for i := 0 to 1 do
      begin
        dest^ := _HexByte(src+2);
        Inc(dest);
        dest^ := _HexByte(src);
        Inc(dest);
        Inc(src, 4);
        if src[0] <> '-' then
        Raise Exception.CreateFmt(ERR_JL_InvalidGUID,[Value]);
        inc(src);
      end;

      dest^ := _HexByte(src);
      Inc(dest);
      Inc(src, 2);
      dest^ := _HexByte(src);
      Inc(dest);
      Inc(src, 2);
      if src[0] <> '-' then
      Raise Exception.CreateFmt(ERR_JL_InvalidGUID,[Value]);

      Inc(src);
      for i := 0 to 5 do
      begin
        dest^:=_HexByte(src);
        Inc(dest);
        Inc(src, 2);
      end;
    end else
    Raise Exception.CreateFmt(ERR_JL_InvalidGUID,[Value]);    *)
  end;



  Function  JL_CharToGematria(Value:String;
            Const Codex:TJLGematria):Integer;
  const
    Charset = 'abcdefghijklmnopqrstuvwxyz';
  var
    FIndex: Integer;
    FTemp:  String;
  Begin
    result:=0;
    FTemp:=value;
    FTemp:=lowercase(FTemp);
    FIndex:=pos(FTemp,Charset);
    If FIndex>0 then
    Begin
      dec(FIndex);
      Case codex of
      gmCommon:     inc(result,JL_GEMATRIA_COMMON[FIndex]);
      gmHebrew:     inc(result,JL_GEMATRIA_HEBREW[FIndex]);
      gmBeatus:     inc(result,JL_GEMATRIA_BEATUS[FIndex]);
      gmSepSephos:  inc(result,JL_GEMATRIA_SEPSEPHOS[FIndex]);
      end;
    end;
  end;

  Function JL_StrToGematria(Value:String;
           Const Codex:TJLGematria):Integer;
  var
    x:      Integer;
  Begin
    result:=0;
    value:=lowercase(trim(value));
    If length(value)>0 then
    for x:=1 to length(value) do
    inc(result,JL_CharToGematria(Value[x],Codex));
  end;

  function JL_BitsSetInByte(Const Value:Byte):Integer;
  begin
    Result:=JLByteBits[Value];
  end;

  Function JL_StrArray(Const Domain:Array of String):TStrArray;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    FCount:=Length(Domain);
    If FCount>0 then
    Begin
      SetLength(result,FCount);
      FCount:=0;
      For x:=low(Domain) to High(Domain) do
      Begin
        Result[FCount]:=Domain[x];
        inc(FCount);
      end;
    end else
    SetLength(Result,0);
  end;

  Procedure JL_StrArrayAdd(Const Value:String;Var Domain:TStrArray);
  Begin
    SetLength(Domain,Length(Domain)+1);
    Domain[High(Domain)]:=Value;
  end;

  Procedure JL_IntArrayAdd(Var Domain:TIntArray;Const Value:Integer);
  Begin
    SetLength(Domain,Length(Domain)+1);
    Domain[high(domain)]:=Value;
  end;

  Procedure JL_IntArrayDelete(var Domain:TIntArray;
            Const Index:Integer);
  var
    k: Integer;
  Begin
    If  (Index >=low(Domain))
    and (Index <=High(Domain)) then
    Begin
      If Index=High(Domain) then
      SetLength(Domain,Length(Domain)-1) else
      Begin
        for k:=index+1 to high(Domain) do
        Domain[k-1]:=domain[k];
        SetLength(Domain,length(Domain)-1);
      end;
    end;
  end;

  Procedure JL_Int64ArrayDelete(var Domain:TInt64Array;
            Const Index:Integer);
  var
    k: Integer;
  Begin
    If  (Index >=low(Domain))
    and (Index <=High(Domain)) then
    Begin
      If Index=High(Domain) then
      SetLength(Domain,Length(Domain)-1) else
      Begin
        for k:=index+1 to high(Domain) do
        Domain[k-1]:=domain[k];
        SetLength(Domain,length(Domain)-1);
      end;
    end;
  end;

  Procedure JL_LongArrayDelete(var Domain:TLongArray;
            Const Index:Integer);
  var
    k: Integer;
  Begin
    If  (Index >=low(Domain))
    and (Index <=High(Domain)) then
    Begin
      If Index=High(Domain) then
      SetLength(Domain,Length(Domain)-1) else
      Begin
        for k:=index+1 to high(Domain) do
        Domain[k-1]:=domain[k];
        SetLength(Domain,length(Domain)-1);
      end;
    end;
  end;

  Procedure JL_RectArrayDelete(var Domain:TRectArray;
            Const Index:Integer);
  var
    k: Integer;
  Begin
    If  (Index >=low(Domain))
    and (Index <=High(Domain)) then
    Begin
      If Index=High(Domain) then
      SetLength(Domain,Length(Domain)-1) else
      Begin
        for k:=index+1 to high(Domain) do
        Domain[k-1]:=domain[k];
        SetLength(Domain,length(Domain)-1);
      end;
    end;
  end;

  Procedure JL_WordArrayDelete(var Domain:TWordArray;
            Const Index:Integer);
  var
    k: Integer;
  Begin
    If  (Index >=low(Domain))
    and (Index <=High(Domain)) then
    Begin
      If Index=High(Domain) then
      SetLength(Domain,Length(Domain)-1) else
      Begin
        for k:=index+1 to high(Domain) do
        Domain[k-1]:=domain[k];
        SetLength(Domain,length(Domain)-1);
      end;
    end;
  end;

  Function JL_LineClip(Domain:TRect;
           var Left,Top,Right,Bottom:Integer):Boolean;
  var
    n:      Integer;
    xdiff:  Integer;
    yDiff:  Integer;
    a,b:    Single;
  begin
    (* realize domain if inverted *)
    If (Domain.right<Domain.left)
    or (Domain.Bottom<Domain.top) then
    JL_RectRealize(Domain);

    result:=JL_RectValid(domain);
    If result then
    Begin
      (* determine slope difference *)
      xDiff:=Left-Right;
      yDiff:=Top-Bottom;

      (* pure vertical line *)
      if xdiff=0 then
      begin
        //Top:=JL_Smallest(Domain.top,Domain.bottom);
        //Bottom:=JL_Largest(Domain.top,Domain.Bottom);
        Top:=math.EnsureRange(top,domain.top,domain.bottom);
        bottom:=math.EnsureRange(bottom,domain.Top,domain.bottom);

        if Top>Bottom then
        JL_Swap(Top,Bottom);

        {if Top>Domain.bottom then
        Top:=Domain.bottom else
        if Top<Domain.top then
        Top:=Domain.top;

        if Bottom>Domain.bottom then
        Bottom:=Domain.bottom else
        if Bottom<Domain.top then
        Bottom:=Domain.top;    }

        result:=(Left>=Domain.Left)
        and     (right<=Domain.Right)
        and     (top>=Domain.Top)
        and     (bottom<=Domain.Bottom);
      end else

      (* pure horizontal line *)
      if yDiff=0 then
      begin
        //Top:=math.EnsureRange(top,domain.top,domain.bottom);
        //bottom:=math.EnsureRange(bottom,domain.Top,domain.bottom);
        Left:=math.EnsureRange(Left,domain.left,domain.right);
        right:=math.EnsureRange(right,domain.left,domain.right);

        If right<Left then
        JL_Swap(right,left);

        {if Left<Domain.left then
        Left:=Domain.left else
        if Left>Domain.right then
        Left:=Domain.right;

        if Right<Domain.left then
        Right:=Domain.left else
        if Right>Domain.right then
        Right:=Domain.right;    }

        result:=(Left>=Domain.Left)
        and     (right<=Domain.Right)
        and     (top>=Domain.Top)
        and     (bottom<=Domain.Bottom);
      end else

      (* Ensure visible results *)
      if ((Top<Domain.top) and (Bottom<Domain.top))
      or ((Top>Domain.bottom) and (Bottom>Domain.bottom))
      or ((Left>Domain.right) and (Right>Domain.right))
      or ((Left<Domain.left) and (Right<Domain.left)) then
      Result:=False else
      Begin
        (* sloped line *)
        a:=ydiff / xdiff;
        b:=(Left * Bottom - Right * Top) / xdiff;

        if (Top<Domain.top) or (Bottom<Domain.top) then
        begin
          n := round ((Domain.top - b) / a);
          if (n>=Domain.left) and (n<=Domain.right) then
          if (Top<Domain.top) then
          begin
            Left:=n;
            Top:=Domain.top;
          end else
          begin
            Right:=n;
            Bottom:=Domain.top;
          end;
        end;

        if (Top>Domain.bottom) or (Bottom>Domain.bottom) then
        begin
          n := round ((Domain.bottom - b) / a);
          if (n>=Domain.left) and (n<=Domain.right) then
          if (Top>Domain.bottom) then
          begin
            Left:=n;
            Top:=Domain.bottom;
          end else
          begin
            Right:=n;
            Bottom:=Domain.bottom;
          end;
        end;

        if (Left<Domain.left) or (Right<Domain.left) then
        begin
          n:=round((Domain.left * a) + b);
          if (n <= Domain.bottom) and (n>=Domain.top) then
          if (Left<Domain.left) then
          begin
            Left:=Domain.left;
            Top:=n;
          end else
          begin
            Right:=Domain.left;
            Bottom:=n;
          end;
        end;

        if (Left>Domain.right) or (Right>Domain.right) then
        begin
          n:=round((Domain.right * a) + b);
          if (n<=Domain.bottom) and (n>=Domain.top) then
          if (Left>Domain.right) then
          begin
            Left:=Domain.right;
            Top:=n;
          end else
          begin
            Right:=Domain.right;
            Bottom:=n;
          end;
        end;
      end;
    end;
  end;

  Procedure JL_PntArrayDelete(var Domain:TPointArray;
            Const Index:Integer);
  var
    k: Integer;
  Begin
    If  (Index >=low(Domain))
    and (Index <=High(Domain)) then
    Begin
      If Index=High(Domain) then
      SetLength(Domain,Length(Domain)-1) else
      Begin
        for k:=index+1 to high(Domain) do
        Domain[k-1]:=domain[k];
        SetLength(Domain,length(Domain)-1);
      end;
    end;
  end;

  Procedure JL_StrArrayDelete(var Domain:TStrArray;
            Const Index:Integer);
  var
    k: Integer;
  Begin
    If  (Index >=low(Domain))
    and (Index <=High(Domain)) then
    Begin
      If Index=High(Domain) then
      SetLength(Domain,Length(Domain)-1) else
      Begin
        for k:=index+1 to high(Domain) do
        Domain[k-1]:=domain[k];
        SetLength(Domain,length(Domain)-1);
      end;
    end;
  end;

  Function JL_IntArray(Const Domain:Array of Integer):TIntArray;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    FCount:=Length(Domain);
    If FCount>0 then
    Begin
      SetLength(result,FCount);
      FCount:=0;
      For x:=low(Domain) to High(Domain) do
      Begin
        Result[FCount]:=Domain[x];
        inc(FCount);
      end;
    end else
    SetLength(Result,0);
  end;

  Function  JL_WordArray(Const Domain:Array of Word):TWordArray;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    FCount:=Length(Domain);
    If FCount>0 then
    Begin
      SetLength(result,FCount);
      FCount:=0;
      For x:=low(Domain) to High(Domain) do
      Begin
        Result[FCount]:=Domain[x];
        inc(FCount);
      end;
    end else
    SetLength(Result,0);
  end;

  Function JL_Int64Array(Const Domain:Array of Int64):TInt64Array;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    FCount:=Length(Domain);
    If FCount>0 then
    Begin
      SetLength(result,FCount);
      FCount:=0;
      For x:=low(Domain) to High(Domain) do
      Begin
        Result[FCount]:=Domain[x];
        inc(FCount);
      end;
    end else
    SetLength(Result,0);
  end;

  Function JL_LongArray(Const Domain:Array of Longword):TLongArray;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    FCount:=Length(Domain);
    If FCount>0 then
    Begin
      SetLength(result,FCount);
      FCount:=0;
      For x:=low(Domain) to High(Domain) do
      Begin
        Result[FCount]:=Domain[x];
        inc(FCount);
      end;
    end else
    SetLength(Result,0);
  end;

  Function  JL_PntArray(Const Domain:Array of TPoint):TPointArray;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    FCount:=Length(Domain);
    If FCount>0 then
    Begin
      SetLength(result,FCount);
      FCount:=0;
      For x:=low(Domain) to High(Domain) do
      Begin
        Result[FCount]:=Domain[x];
        inc(FCount);
      end;
    end else
    SetLength(Result,0);
  end;

  Function JL_MakePTR(Const Data:Pointer;Const Value:Integer):Pointer;
  Begin
    Result:=PTR(Integer(Data) + Value);
  end;

  Function  JL_BitGet(Const Index:Integer;Const Buffer):Boolean;
  var
    FValue: Byte;
    FAddr:  PByte;
    BitOfs: 0..255;
  Begin
    If Index>=0 then
    Begin
      BitOfs:=Index mod 8;
      FAddr:=JL_MakePTR(@Buffer,Index shr 3);
      FValue:=FAddr^;
      Result:=(FValue and (1 shl (BitOfs mod 8))) <> 0;
    end else
    Raise EJLBitsException.CreateFmt
    (ERR_JL_BITS_INVALIDOFFSET,[maxint-1,index]);
  end;

  Procedure  JL_BitSet(Const Index:Integer;var Buffer;
            Const Value:Boolean);
  var
    FByte:    Byte;
    FAddr:    PByte;
    BitOfs:   0..255;
    FCurrent: Boolean;
  Begin
    If Index>=0 then
    Begin
      FAddr:=JL_MakePTR(@Buffer,index shr 3);
      FByte:=FAddr^;
      BitOfs := Index mod 8;
      FCurrent:=(FByte and (1 shl (BitOfs mod 8))) <> 0;

      If Value then
      Begin
        (* set bit if not already set *)
        If FCurrent=False then
        FByte:=(FByte or (1 shl (BitOfs mod 8)));
        FAddr^:=FByte;
      end else
      Begin
        (* clear bit if already set *)
        If FCurrent then
        FByte:=(FByte and not (1 shl (BitOfs mod 8)));
        FAddr^:=FByte;
      end;

    end else
    Raise EJLBitsException.CreateFmt
    (ERR_JL_BITS_INVALIDOFFSET,[maxint-1,index]);
  end;

  Function  JL_StrToElements(Const Value:String;
            var Domain:TStrArray;
            Const Delimiter:Char=' '):Integer;
  var
    FLen:   Integer;
    x:      Integer;
    FTemp:  String;
  Begin
    FLen:=Length(Value);
    SetLength(Domain,0);

    If FLen>0 then
    Begin
      FTemp:='';
      for x:=1 to FLen do
      Begin
        If (Value[x]=Delimiter)
        or (x=FLen) then
        Begin
          If Length(FTemp)>0 then
          Begin
            If  (x=FLen)
            and (Value[x]<>Delimiter) then
            FTemp:=FTemp + Value[x];
            JL_StrArrayAdd(FTemp,Domain);
            FTemp:='';
          end;
        end else
        Ftemp:=FTemp + Value[x];
      end;
    end;
    Result:=Length(Domain);
  end;

  Function  JL_StreamToStr(Const Stream:TStream;
            var Value:String):Boolean;
  var
    FLen:   Int64;
    FUnit:  Integer;
    FSize:  Integer;
  Begin
    Value:='';
    result:=False;
    if Stream<>NIL then
    Begin
      FLen:=Stream.Size - Stream.Position;
      If FLen>0 then
      Begin
        FUnit:=SizeOf(Char);
        FSize:=FLen div FUnit;
        if FSize>0 then
        Begin
          SetLength(Value,FSize);
          FLen:=FSize * FUnit;
          result:=( Stream.Read(Value[1],FLen)>0 );
        end;
      end;
    end;
  end;

  Function  JL_StrToFile(Const Filename:String;
            Const Value:String):Boolean;
  var
    FLen: Integer;
    FFile:  TFileStream;
  Begin
    Result:=False;

    (* Create the file *)
    try
      FFile:=TFileStream.Create(Filename,fmCreate);
    except
      on exception do
      exit;
    end;

    (* write the data *)
    try
      FLen:=Length(Value);
      if FLen>0 then
      FFile.WriteBuffer(Value[1],FLen * SizeOf(Char) );

      result:=True;

    finally
      (* release file *)
      FFile.free;
    end;
  end;

  Function  JL_FileToStr(Const Filename:String;
            var Value:String):Boolean;
  var
    FFile:  TFileStream;
  Begin
    result:=False;
    SetLength(Value,0);
    if FileExists(Filename) then
    Begin

      (* attempt to access file *)
      try
        FFile:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
      except
        on exception do
        exit;
      end;

      try
        (* read file content into string *)
        If FFile.Size>=SizeOf(Char) then
        Begin
          SetLength(Value,FFile.Size div SizeOf(Char) );
          FFile.ReadBuffer(Value[1],FFile.Size);
        end;

        (* We are OK *)
        result:=true;
      finally
        (* release file obj *)
        FFile.free;
      end;
    end;
  end;

  Function JL_MakeDir(Const Value:String):Boolean;
  Begin
    result:=False;
    try
      mkdir(Value);
      result:=True;
    except
      on exception do
      exit;
    end;
  end;

  Function  JL_FolderSizeKb(Const FolderPath:String;
            var Value:Int64):Boolean;
  var
    FBytes: Int64;
  Begin
    result:=False;
    if JL_FolderSizeBytes(FolderPath,FBytes) then
    Begin
      Value:=Integer(FBytes div CNT_JL_KILOBYTE);
      result:=True;
    end else
    Value:=0;
  end;

  Function JL_FolderSizeMb(Const FolderPath:String;
           var Value:Int64):Boolean;
  var
    FBytes: Int64;
  Begin
    result:=False;
    if JL_FolderSizeBytes(FolderPath,FBytes) then
    Begin
      Value:=FBytes div CNT_JL_MEGABYTE;
      result:=True;
    end else
    Value:=0;
  end;

  Function  JL_FolderFileCount(Const FolderPath:String;
            var Value:Int64):Boolean;
  var
    FRec:   TSearchRec;
    FRoot:  String;
    FTemp:  String;
    FCount: Int64;
  Begin
    Value:=0;
    result:=False;
    
    if DirectoryExists(FolderPath) then
    Begin
      FRoot:=IncludeTrailingPathDelimiter(FolderPath) + '*.*';
      If FindFirst(FRoot,faAnyFile,FRec)=0 then
      Begin
        try
          Repeat
            If (FRec.Name<>'.') and (FRec.Name<>'..') then
            Begin
              FTemp:=IncludeTrailingPathDelimiter(FolderPath) + FRec.Name;
              If (FRec.Attr and faDirectory)=faDirectory then
              Begin
                If JL_FolderFileCount(FTemp,FCount) then
                Value:=Value + FCount;
              end else
              Value:=Value + 1;
            end;
          Until FindNext(FRec)<>0;

          result:=True;

        finally
          FindClose(FRec);
        end;
      end;
    end;
  end;

  Function  JL_FolderExamineFiles(Const FolderPath:String;
            var Value:TStrArray;
            var Count:Integer;
            Const Options:TJLFileScanOptions=
            [doIncludeSystemFiles,doIncludeHiddenFiles]):Boolean;
  var
    FTemp:  String;
    FRec:   TSearchRec;
    FSkip:  Boolean;
  Begin
    result:=false;
    Count:=0;
    SetLength(Value,0);
    FTemp:=Trim(FolderPath);

    if Length(FTemp)>0 then
    Begin
      if DirectoryExists(FTemp) then
      Begin
        FTemp:=IncludeTrailingPathDelimiter(FTemp);
        if FindFirst(FTemp + '*.*',faAnyFile,FRec)=0 then
        Begin
          try
            Repeat
              If  (FRec.Name<>'.')
              and (FRec.Name<>'..')
              and ((FRec.Attr and faDirectory)<>faDirectory) then
              Begin
                FSkip:=False;

                (* exclude system files? *)
                If not (doIncludeSystemFiles in Options)
                and ((FRec.Attr and faSysFile)=faSysFile) then
                FSkip:=True;

                (* exclude hidden files? *)
                If FSkip=False then
                Begin
                  If not (doIncludeHiddenFiles in Options)
                  and ((FRec.Attr and faHidden)=faHidden) then
                  FSkip:=True;
                end;

                If not FSkip then
                JL_StrArrayAdd(FRec.Name,Value);
              end;
            Until FindNext(FRec)<>0;
          finally
            FindClose(FRec);
            Count:=Length(Value);
          end;
          result:=True;
        end;
      end;
    end;
  end;

  Function  JL_FolderSubDirectoryCount(Const FolderPath:String;
            var Count:Integer):Boolean;
  var
    FTemp:  String;
    FRec:   TSearchRec;
  Begin
    result:=False;
    Count:=0;
    FTemp:=Trim(FolderPath);
    if length(FTemp)>0 then
    Begin
      if DirectoryExists(FTemp) then
      Begin
        FTemp:=IncludeTrailingPathDelimiter(FTemp);
        if FindFirst(FTemp + '*.*',faDirectory,FRec)=0 then
        Begin
          try
            Repeat
              If  (FRec.Name<>'.')
              and (FRec.Name<>'..')
              and ((FRec.Attr and faDirectory)=faDirectory) then
              inc(Count);
            Until FindNext(FRec)<>0;
            result:=True;
          finally
            FindClose(FRec);
          end;
        end;
      end;
    end;
  end;

  Function JL_FolderPathUntangle(Const Value:String):String;
  var
    x:      Integer;
    FParts: TStrArray;
  Begin
    result:='';
    If pos('\',value)>0 then
    Begin
      x:=JL_StrToElements(Value,FParts,'\');
      If x>0 then
      Begin

        (* Take [cd-up] into account *)
        for x:=Low(FParts) to high(FParts) do
        Begin
          If FParts[x]='..' then
          Begin
            FParts[x]:='';
            If x>Low(FParts) then
            FParts[x-1]:='';
          end;
        end;

        (* build new string *)
        for x:=Low(FParts) to high(FParts) do
        Begin
          If length(FParts[x])>0 then
          Begin
            result:=result + FParts[x];
            If x<high(Fparts) then
            result:=result + '\';
          end;
        end;

      end else
      result:=Value;
    end;
  end;

  Function  JL_FolderExamineDirectories(Const FolderPath:String;
            var Value:TStrArray;
            var Count:Integer):Boolean;
  var
    FTemp:  String;
    FRec:   TSearchRec;
  Begin
    Count:=0;
    SetLength(Value,0);
    FTemp:=Trim(FolderPath);
    Result:=DirectoryExists(FTemp);
    If result then
    Begin
      FTemp:=IncludeTrailingPathDelimiter(FTemp);
      Result:=FindFirst(FTemp + '*.*',faDirectory,FRec)=0;
      If result then
      Begin
        try
          Repeat
            If  (FRec.Name<>'.')
            and (FRec.Name<>'..')
            and ((FRec.Attr and faDirectory)=faDirectory) then
            JL_StrArrayAdd(FRec.Name,Value);
          Until FindNext(FRec)<>0;
        finally
          FindClose(FRec);
          Count:=Length(Value);
        end;
      end;
    end;
  end;

  Function JL_FolderSizeBytes(Const FolderPath:String;
           var Value:Int64):Boolean;
  var
    FRec:   TSearchRec;
    FRoot:  String;
    FTemp:  String;
    FSize:  Int64;
  Begin
    Value:=0;
    Result:=DirectoryExists(FolderPath);
    If Result then
    Begin
      FRoot:=IncludeTrailingPathDelimiter(FolderPath) + '*.*';
      If FindFirst(FRoot,faAnyFile,FRec)=0 then
      Begin
        try
          Repeat
            If (FRec.Name<>'.') and (FRec.Name<>'..') then
            Begin
              FTemp:=IncludeTrailingPathDelimiter(FolderPath) + FRec.Name;
              If (FRec.Attr and faDirectory)=faDirectory then
              Begin
                If JL_FolderSizeBytes(FTemp,FSize) then
                Value:=Value + FSize;
              end else
              Begin
                FSize:=JL_FileSize(FTemp);
                Value:=Value + FSize;
              end;
            end;
          Until FindNext(FRec)<>0;
        finally
          FindClose(FRec);
        end;
      end;
    end;
  end;

  Function JL_DeleteFolderContent(FolderPath:String):Boolean;
  var
    FRec:     TSearchRec;
    FRoot:    String;
    FFolders: TStrArray;
    FFiles:   TStrArray;
    FCount:   Integer;
  Begin
    Result:=DirectoryExists(FolderPath);
    If Result then
    Begin
      FRoot:=IncludeTrailingPathDelimiter(FolderPath) + '*.*';
      If FindFirst(FRoot,faAnyFile,FRec)=0 then
      Begin
        try
          Repeat
            If (FRec.Name<>'.') and (FRec.Name<>'..') then
            Begin
              If (FRec.Attr and faDirectory)=faDirectory then
              JL_StrArrayAdd(FRec.Name,FFolders) else
              JL_StrArrayAdd(FRec.Name,FFiles);
            end;
          Until FindNext(FRec)<>0;
        finally
          FindClose(FRec);
        end;

        FRoot:=IncludeTrailingPathDelimiter(FolderPath);

        (* delete files *)
        FCount:=Length(FFiles);
        While FCount>0 do
        Begin
          DeleteFile(FRoot + FFiles[FCount-1]);
          dec(FCount);
        end;
        SetLength(FFiles,0);

        (* delete folders *)
        FCount:=Length(FFolders);
        While FCount>0 do
        Begin
          JL_DeleteFolder(FRoot + FFolders[FCount-1]);
          dec(FCount);
        end;
        SetLength(FFolders,0);
      end;
    end;
  end;

  Function JL_DeleteFolder(FolderPath:String):Boolean;
  var
    FRec:     TSearchRec;
    FRoot:    String;
    FFolders: TStrArray;
    FFiles:   TStrArray;
    FCount:   Integer;
  Begin
    Result:=DirectoryExists(FolderPath);
    If Result then
    Begin
      FRoot:=IncludeTrailingPathDelimiter(FolderPath) + '*.*';
      If FindFirst(FRoot,faAnyFile,FRec)=0 then
      Begin
        try
          Repeat
            If (FRec.Name<>'.') and (FRec.Name<>'..') then
            Begin
              If (FRec.Attr and faDirectory)=faDirectory then
              JL_StrArrayAdd(FRec.Name,FFolders) else
              JL_StrArrayAdd(FRec.Name,FFiles);
            end;
          Until FindNext(FRec)<>0;
        finally
          FindClose(FRec);
        end;

        FRoot:=IncludeTrailingPathDelimiter(FolderPath);

        (* delete files *)
        FCount:=Length(FFiles);
        While FCount>0 do
        Begin
          DeleteFile(FRoot + FFiles[FCount-1]);
          dec(FCount);
        end;
        SetLength(FFiles,0);

        (* delete folders *)
        FCount:=Length(FFolders);
        While FCount>0 do
        Begin
          JL_DeleteFolder(FRoot + FFolders[FCount-1]);
          dec(FCount);
        end;
        SetLength(FFolders,0);

        (* delete top folder *)
        rmdir(FRoot);
      end;
    end;
  end;

  Function JL_FileSize(Const Filename:String):Int64;
  var
    FRec: TSearchRec;
  Begin
    if FindFirst(FileName, faAnyFile, FRec)=0 then
    Begin
      try
        With FRec.FindData do
        Result  := Int64(nFileSizeHigh) shl Int64(32) + Int64(nFileSizeLow);
      finally
        FindClose(FRec);
      end;
    end else
    result:=0;
  end;

  function JL_FileTimeToDate(filetime:TFileTime):TDateTime;
  var
    FSys: TSystemTime;
  begin
    if FileTimeToSystemTime(filetime,FSys) then
    result := EncodeDate(FSys.wYear,FSys.wMonth,FSys.wDay) else
    result:=0;
  end;

  function JL_FileTimeToTime(filetime:TFileTime):TDateTime;
  var
    systime:TSystemTime;
  begin
    if FileTimeToSystemTime(filetime,systime) then
    result :=EncodeTime(systime.wHour,systime.wMinute,systime.wSecond,
    systime.wMilliseconds) else
    result:=0;
  end;

  function JL_FileTimeToDateTime(filetime:TFileTime):TDateTime;
  begin
    result:=JL_FileTimeToDate(filetime) + JL_FileTimeToTime(filetime);
  end;

  Function JL_FileModified(Const Filename:String):TDateTime;
  var
    FRec: TSearchRec;
  Begin
    if FindFirst(FileName, faAnyFile, FRec)=0 then
    Begin
      try
        Result:=JL_FileTimeToDateTime(FRec.FindData.ftLastWriteTime);
      finally
        FindClose(FRec);
      end;
    end else
    result:=0;
  end;

  Function JL_FileCreated(Const Filename:String):TDateTime;
  var
    FRec: TSearchRec;
  Begin
    if FindFirst(FileName, faAnyFile, FRec)=0 then
    Begin
      try
        Result:=JL_FileTimeToDateTime(FRec.FindData.ftCreationTime);
      finally
        FindClose(FRec);
      end;
    end else
    result:=0;
  end;

  Function JL_CharIsNumeric(Const Value:AnsiChar):Boolean;
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    mov AL,Value
    cmp AL, $30   // 0
    jl @NoMatch   // it's before '0' so Result=False/Exit
    cmp AL, $39   // 9
    jg @NoMatch   // it's after '9' so Result=False/Exit
    jmp @Matched  // it's 0..9 so Result=True/Exit
  @NoMatch:
    mov Result,0
    jmp @TheEnd
  @Matched:
    mov Result,1
  @TheEnd:
  {$ELSE}
  Begin
    result:=byte(Value) in [Byte('0')..byte('9')];
  {$ENDIF}
  end;

  Function JL_CharIsAlpha(Const Value:AnsiChar):Boolean;
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    mov AL,Value
    cmp AL, $41   // A
    jl @NoMatch   // it's before 'A' so Result=False/Exit
    cmp AL, $7A   // z
    jg @NoMatch   // it's after 'z' so Result=False/Exit
    cmp AL, $5A   // Z
    jg @TryLower  // it's after 'Z' so see if it is lower now
    jmp @Matched  // it's A..Z so Result=True/Exit
  @TryLower:
    cmp AL, $61   // a
    jl @NoMatch   // it's before 'a' so Result=False/Exit
    jmp @Matched  // it's 'a'..'z' so Result=True/Exit
  @NoMatch:
    mov Result,0
    jmp @TheEnd
  @Matched:
    mov Result,1
  @TheEnd:
  {$ELSE}
  Begin
    result:=CharInSet(Value,
      ['A'..'Z','a'..'z']);
    {$ENDIF}
  end;

  Function JL_CharIsAlphaNumeric(Const Value:char):Boolean;
  Begin
    result:=CharInSet(Value,
    [ '0'..'9',
      'A'..'Z',
      'a'..'z' ]);
  end;

  function JL_URLEncode(Const Value:String):String;
  var
    I:  Integer;
    C:  Char;
  begin
    Result:='';
    I:=Length(Value);
    while I>0 do
    begin
      C:=Value[I];
      if C=' ' then
      Result:='+' + Result else
      Begin
        if JL_CharIsAlphaNumeric(C)
        or (C in ['.','-','_']) then
        Result:=C+Result else
        Result:='%' + IntToHex(Ord(C),2) + Result;
      end;
      Dec(I);
    end;
  end;

  function JL_URLDecode(Const Value:String):String;
  var
    I:  Integer;
    C:  Char;
  begin
    Result:='';
    I:=1;
    while I<=Length(Value) do
    begin
      C:=Value[I];
      if C='%' then
      begin
        Inc(I);
        Result := Result + Char(StrToInt('$' + Copy(Value,I,2)));
        Inc(I);
      end else
      if C='+' then
      Result:=Result+' ' else
      Result:=Result+C;
      Inc(I);
    end;
  end;

  Function JL_PntToStr(Const Value:TPoint):String;
  Begin
    Result:=IntToStr(Value.x) + ',' + IntToStr(Value.Y);
  end;

  procedure JL_PntRotate(var Points:TPointArray;
            Const xOrg,yOrg:Integer;Const Angle:Extended);
  var
    Sin, Cos: Extended;
    xPrime, yPrime: Integer;
    I: Integer;
  begin
    SinCos(Angle, Sin, Cos);
    for I := Low(Points) to High(Points) do
    with Points[I] do
    begin
      xPrime := X - xOrg;
      yPrime := Y - yOrg;
      X := Round(xPrime * Cos - yPrime * Sin) + xOrg;
      Y := Round(xPrime * Sin + yPrime * Cos) + yOrg;
    end;
  end;

  Function JL_RectShrinkHeight(Const Source:TRect;Const Factor:Integer):TRect;
  var
    FHeight:  Integer;
    FTemp:    Integer;
  Begin
    FHeight:=JL_RectHeight(Source);
    If (FHeight>0) and (Factor>=1) then
    Begin
      FTemp:=Factor shr 1;
      inc(Result.Top,FTemp);
      dec(Result.Bottom,FTemp);
    end else
    result:=Source;
  end;

  Function JL_RectGrowHeight(Const Source:TRect;Const Factor:Integer):TRect;
  var
    FHeight:  Integer;
    FTemp:    Integer;
  Begin
    FHeight:=JL_RectHeight(Source);
    If (FHeight>0) and (Factor>=1) then
    Begin
      FTemp:=Factor shr 1;
      dec(Result.Top,FTemp);
      inc(Result.Bottom,FTemp);
    end else
    result:=Source;
  end;

  Function JL_RectShrinkWidth(Const Source:TRect;Const Factor:Integer):TRect;
  var
    FWidth: Integer;
    FTemp:  Integer;
  Begin
    FWidth:=JL_RectWidth(Source);
    If (FWidth>0) and (Factor>=1) then
    Begin
      FTemp:=Factor shr 1;
      inc(Result.left,FTemp);
      dec(Result.right,FTemp);
    end else
    result:=Source;
  end;

  Function JL_RectGrowWidth(Const Source:TRect;Const Factor:Integer):TRect;
  var
    FWidth: Integer;
    FTemp:  Integer;
  Begin
    FWidth:=JL_RectWidth(Source);
    If (FWidth>0) and (Factor>=1) then
    Begin
      FTemp:=Factor shr 1;
      dec(Result.left,FTemp);
      inc(Result.right,FTemp);
    end else
    result:=Source;
  end;

  function JL_RectUnion(const Primary,Secondary:TRect):TRect;
  begin
    If JL_RectValid(Primary) then
    Begin
      If JL_RectValid(Secondary) then
      Begin
        if Secondary.Left<Primary.Left then
        Result.Left:=Secondary.Left;

        if Secondary.Top<Primary.Top then
        Result.Top := Secondary.Top;

        if Secondary.Right>Primary.Right then
        Result.Right := Secondary.Right;

        if Secondary.Bottom>Primary.Bottom then
        Result.Bottom := Secondary.Bottom;
      end else
      Result:=Primary;
    end else
    Result:=Primary;
  end;

  Function JL_RectHeight(Const ARect:TRect):Integer;
  Begin
    //if ARect.Bottom>ARect.top then
    result:=ARect.bottom-ARect.top //else
    //result:=ARect.top-ARect.bottom;
  end;

  Function JL_RectWidth(Const ARect:TRect):Integer;
  Begin
    //if ARect.right>ARect.left then
    Result:=ARect.Right-ARect.left// else
    //result:=ARect.left - ARect.right;
  end;

  Procedure JL_RectFit(Const WorldRect:TRect;
            Const ObjRect:TRect;out Value:TRect);
  var
    x1,y1:  Double;
    rc:     TRect;
    x,y:    Integer;
    Width,
    Height:    Integer;
    NewWidth,
    NewHeight:  Integer;
  Begin
    NewWidth:=JL_RectWidth(WorldRect);
    NewHeight:=JL_RectHeight(WorldRect);
    Width:=JL_RectWidth(objRect);
    Height:=JL_RectHeight(objRect);

    (* Check if objRect will fit as it is *)
    if (NewWidth>Width) and (newHeight>Height) then
    Begin
      Value:=worldrect;
      x:=(newwidth - Width) div 2;
      y:=(newheight - height) div 2;
      Value.Left:=Value.left + x;
      Value.right:=Value.left + width;
      Value.top:=Value.top + y;
      Value.Bottom:=Value.top + height;
    end else
    Begin
      x1:=(NewWidth/Width);
      y1:=(NewHeight/Height);
      if x1 > y1 then
      begin
        rc.top:=0;
        rc.bottom:=NewHeight;
        x:=trunc(Width*y1);
        rc.left:=(NewWidth-x) shr 1;
        rc.right:=rc.left+x;
      end else
      begin
        rc.left:=0;
        rc.right:=NewWidth;
        y:=trunc(Height*x1);
        rc.top:=(NewHeight-y) shr 1;
        rc.bottom:=rc.top+y;
      end;

      rc.top:=rc.top + worldrect.Top;
      rc.Bottom:=rc.Bottom + worldrect.top;
      rc.Left:=rc.Left + worldrect.left;
      rc.Right:=rc.Right + worldrect.left;    

      value:=rc;
    end;
  end;

  Function JL_RectAdjust(Const ChildRect:TRect;Const X,Y:Integer):TRect;
  Begin
    If x<0 then
    Begin
      result.left:=childrect.left + JL_IntPositive(x);
      result.right:=childrect.right - JL_IntPositive(x);
    end else
    Begin
      result.left:=childrect.left - x;
      result.right:=childrect.right + x;
    end;

    If y<0 then
    Begin
      result.top:=childrect.top + JL_IntPositive(y);
      result.bottom:=childrect.bottom - JL_IntPositive(y);
    end else
    Begin
      result.top:=childrect.top - y;
      result.bottom:=childrect.bottom + y;
    end;
  end;

  Function JL_RectEqual(Const Primary,Secondary:TRect):Boolean;
  Begin
    result:=(Primary.left=Secondary.left) and (Primary.top=Secondary.top)
    and (Primary.right=Secondary.right) and (Primary.bottom=Secondary.bottom);
  end;


  Function JL_PosDistance(Const Left,Top,Right,Bottom:Integer):Integer;
  var
    dx: Integer;
    dy: Integer;
  begin
    dx:=Left - Right;
    dy:=Top - Bottom;
    Result:=round(Sqrt((dx * dx) + (dy * dy)));
  end;

  Function  JL_PntDistance(Const Primary,Secondary:TPoint):Integer;
  var
    dx: Integer;
    dy: Integer;
  begin
    dx:=Primary.x - Secondary.x;
    dy:=Primary.y - Secondary.y;
    Result:=round(Sqrt((dx * dx) + (dy * dy)));
  end;

  Function JL_RectValid(Const Value:TRect):Boolean;
  Begin
    Result:=(Value.right  > Value.left)
    and     (Value.bottom > Value.top);
  end;

  Procedure JL_RectRealize(var Value:TRect);
  Begin
    If Value.left>Value.right then
    JL_Swap(Value.left,Value.right);

    If Value.Top>Value.Bottom then
    JL_Swap(Value.Top,Value.Bottom);
  end;

  Function JL_PntInRect(Const Primary:TRect;
           Const Value:TPoint):Boolean;
  Begin
    result:=(Value.X>=Primary.Left)
    and (Value.X<=Primary.right)
    and (Value.Y>=Primary.Top)
    and (Value.y<=Primary.bottom);
  end;

  Function JL_PosInRect(Const Primary:TRect;
           Const Left,Top:Integer):Boolean;
  Begin
    result:=(Left>=Primary.Left)
    and     (Left<=Primary.right)
    and     (Top>=Primary.Top)
    and     (Top<=Primary.bottom);
  end;

  Function  JL_PntInPolygon(Const Domain:TPointArray;
            Const Value:TPoint):Boolean;
  var
    K,J:    Integer;
    FCount: Integer;
    xdiv:   Integer;
    ydiv:   Integer;
    zdiv:   Integer;
  begin
    FCount:=Length(Domain);
    Result:=FCount>0;
    If Result then
    Begin
      J:=High(Domain)-1;
      for K:=Low(Domain) to High(Domain) do
      begin
        if  ((Domain[K].Y<=Value.y) and (Value.y<Domain[J].Y))
        or  ((Domain[J].Y <=Value.y) and (Value.y<Domain[K].Y)) then
        begin
          xdiv:=(Domain[j].X - Domain[K].X);
          ydiv:=(Value.y - Domain[K].Y);
          zdiv:=(Domain[j].Y - Domain[K].Y) + Domain[K].X;
          if Value.X<((xdiv*ydiv) / zdiv) then
          Result:=not Result;
        end;
        J:=K;
      end;
    end;
  end;

  Function  JL_PosInPolygon(Const Domain:TPointArray;
            Const Left,Top:Integer):Boolean;
  var
    K,J:    Integer;
    FCount: Integer;
    xdiv:   Integer;
    ydiv:   Integer;
    zdiv:   Integer;
  begin
    FCount:=Length(Domain);
    Result:=FCount>0;
    If Result then
    Begin
      J:=High(Domain)-1;
      for K:=Low(Domain) to High(Domain) do
      begin
        if  ((Domain[K].Y<=Top) and (Top<Domain[J].Y))
        or  ((Domain[J].Y <=Top) and (Top<Domain[K].Y)) then
        begin
          xdiv:=(Domain[j].X - Domain[K].X);
          ydiv:=(Top - Domain[K].Y);
          zdiv:=(Domain[j].Y - Domain[K].Y) + Domain[K].X;
          if Left<((xdiv*ydiv) / zdiv) then
          Result:=not Result;
        end;
        J:=K;
      end;
    end;
  end;

  Function JL_RectInterior(Const Value:TRect):TRect;
  Begin
    If  (Value.left<Value.right)
    and (Value.top<Value.Bottom) then
    Begin
      Result.left:=Value.Left + 1;
      result.top:=Value.top + 1;
      Result.right:=Value.Right -1;
      Result.Bottom:=Value.Bottom - 1;
    end else
    result:=JL_INVALIDRECT;
  end;

  Function JL_RectExterior(Const Value:TRect):TRect;
  Begin
    If  (Value.left<=Value.right)
    and (Value.top<=Value.Bottom) then
    Begin
      Result.left:=Value.Left - 1;
      result.top:=Value.top - 1;
      Result.right:=Value.Right + 1;
      Result.Bottom:=Value.Bottom + 1;
    end else
    result:=JL_INVALIDRECT;
  end;
  
  Function JL_RectWithin(Const objRect,worldRect:TRect):Boolean;
  Begin
    Result:=(objRect.left>=WorldRect.left)
    and (objRect.top>=worldRect.top)
    and (objRect.right<=worldRect.right)
    and (objRect.bottom<=worldrect.bottom);
  end;

  Function JL_RectExpose(Const objRect,worldRect:TRect):TJLExposure;
  Begin
    {$B+}
    If (objRect.Left>=worldRect.Right)
    or (objRect.Top>=worldRect.Bottom)
    or (objRect.Right<=worldRect.Left)
    or (objRect.Bottom<=worldRect.Top) then
    result:=esNone else
    if (objRect.Left<worldRect.Left)
    or (objRect.Top<worldRect.Top)
    or (objRect.Right>worldRect.Right-1)
    or (objRect.Bottom>worldRect.Bottom-1) then
    result:=esPartly else
    result:=esCompletely;
    {$B-}
  end;

  function  JL_RectIntersect(const Primary,Secondary:TRect;
            var Intersection:TRect):Boolean;
  begin
    Intersection:=Primary;

    if Secondary.Left>Primary.Left then
    Intersection.Left:=Secondary.Left;

    if Secondary.Top>Primary.Top then
    Intersection.Top:=Secondary.Top;

    if Secondary.Right<Primary.Right then
    Intersection.Right:=Secondary.Right;

    if Secondary.Bottom<Primary.Bottom then
    Intersection.Bottom:=Secondary.Bottom;

    Result:=(Intersection.right>Intersection.left)
    and (Intersection.bottom>Intersection.top);

    if not Result then
    Intersection:=JL_NULLRECT;
  end;

  function JL_RectArea(const inRect:TRect):Int64;
  begin
    (* find area of rectangle *)
    Result := (inRect.Right - inRect.Left) * (inRect.Bottom - inRect.Top);
  end;

  Function  JL_RectDiff(Const Primary,Secondary:TRect;
            var Width,Height:Integer):Boolean;
  Begin
    Width:=0;
    Height:=0;

    Result:=JL_RectValid(Primary);
    If result then
    Begin
      Result:=JL_RectValid(Secondary);
      If result then
      Begin

        If Primary.Left<>Secondary.Left then
        Width:=JL_Diff(Primary.Left,Secondary.Left);

        If Primary.Top<>Secondary.Top then
        Height:=JL_Diff(Primary.Top,Secondary.Top);

        If Primary.Right<>Secondary.Right then
        inc(Width,JL_Diff(Primary.Right,Secondary.Right));

        If Primary.bottom<>Secondary.bottom then
        inc(Height,JL_Diff(Primary.bottom,Secondary.bottom));

      end;
    end;
  end;

  Function  JL_RectClip(Const Domain:TRect;Var Value:TRect):Boolean;
  Begin
    Result:=JL_RectValid(Domain);
    If Result then
    Begin
      Result:=JL_RectValid(Value);
      If Result then
      Begin
        (* Make sure Value is visible within domain *)
        Result:=JL_RectExpose(Domain,Value)>esNone;
        If result then
        Begin
          If Value.Left<Domain.Left then
          Value.Left:=Domain.Left;

          If Value.Top<Domain.Top then
          Value.Top:=Domain.Top;

          If Value.right>Domain.right then
          Value.right:=Domain.right;

          If Value.bottom>Domain.bottom then
          Value.bottom:=Domain.bottom;
        end else
        Value:=JL_INVALIDRECT;
      end else
      value:=JL_INVALIDRECT;
    end else
    Value:=JL_INVALIDRECT;
  end;

  Function  JL_RectToStr(Const Value:TRect;
            Const LineFeed:Boolean=True):String;
  const
    EOL = #13#10;
  Begin
    Result:='Left: %d%sTop: %d%sRight: %d%sBottom: %d%s';
    If not LineFeed then
    Result:=Format(Result,[Value.left,' ',Value.top,' ',
    value.right,' ',value.bottom,' ']) else
    Result:=Format(Result,[Value.left,EOL,Value.top,EOL,
    value.right,EOL,value.bottom,EOL]);
  end;

  Function JL_RectFrom(Const Domain:TPointArray;
           var Value:TRect):Boolean;
  var
    x:      Integer;
    FCount: Integer;
  Begin
    FCount:=Length(Domain);
    Result:=FCount>2;
    if result then
    Begin
      Value:=JL_VOIDRECT;
      for x:=low(Domain) to high(Domain) do
      Begin
        If Domain[x].X<Value.left then
        Value.left:=Domain[x].x;

        if Domain[x].x>Value.right then
        Value.right:=Domain[x].x;

        if Domain[x].y<Value.top then
        Value.top:=Domain[x].y;

        if Domain[x].y>Value.bottom then
        Value.bottom:=Domain[x].y;
      end;

      (* align horizontal *)
      If Value.left>Value.right then
      JL_SwapMore(Value.left,Value.right);

      (* align vertical *)
      If Value.Top>Value.Bottom then
      JL_SwapMore(Value.top,Value.bottom);

      (* verify result *)
      Result:=(Value.left<Value.right)
      and     (Value.top<Value.Bottom);

      (* reset output if not a visible entity *)
      If not Result then
      Value:=JL_INVALIDRECT;
    end else
    Value:=JL_INVALIDRECT;
  end;

  Function JL_GetTempFileName:String;
  var
    tempPath: String;
    tempFile: String;
    FBufLen:  Cardinal;
    FLen:     Integer;
    FMoniker: String;
    mPPtr:    PAnsiChar;
  Begin
    SetLength(tempPath, MAX_PATH);
    Case SizeOf(Char) of
    SizeOf(AnsiChar):
      Begin
        mPPtr:=@tempPath[1];
        FBufLen:=MAX_PATH * SizeOf(AnsiChar);
        FLen:=GetTempPathA(FBufLen, mPPtr);
      end;
    SizeOf(WideChar):
      Begin
        FBufLen:=MAX_PATH * SizeOf(WideChar);
        FLen:=GetTempPathW(FBufLen, PWideChar(@tempPath[1]));
      end;
    end;

    if FLen>0 then
    Begin
      (* Trunc path *)
      If (FLen<FBufLen) then
      SetLength(tempPath,FLen);

      FMoniker:='JL_';
      SetLength(tempFile, MAX_PATH);
      Case SizeOf(Char) of
      SizeOf(AnsiChar):
        Begin
          FLen:=GetTempFileNameA(PAnsiChar(tempPath),
          PAnsiChar(FMoniker), 0,
          PAnsiChar(tempFile));
        end;
      SizeOf(WideChar):
        Begin
          FLen:=GetTempFileNameW(PWideChar(@tempPath[1]),
          PWideChar(@FMoniker[1]), 0,
          PWideChar(@tempFile[1]));
        end;
      end;

      if FLen<>0 then
      Result:=trim(tempFile);
    end;
  end;

  Function JL_RightStr(Const Value:String;Count:Integer):String;
  var
    FLen: Integer;
  Begin
    FLen:=Length(Value);
    If (FLen>0) and (Count>0) then
    Begin
      If Count>FLen then
      Count:=FLen;
      Result:=Copy(Value,(FLen-Count)+1,Count);
    end else
    result:='';
  end;

  Procedure JL_NibbleToDios(Const Value:TNibble;
            var HighBits,LowBits:TDio);
  Begin
    HighBits:=TDio(Value shr 2);
    LowBits:=TNibble(Byte(Value shl 2) shr 2);
  end;

  Procedure JL_QuadToBytes(Const Value:TJLQuad;
            Var aByte,bByte,cByte,dByte:Byte);
  Begin
    aByte:=Value.nA;
    bByte:=Value.nB;
    cByte:=Value.nC;
    dByte:=Value.nD;
  end;

  Procedure JL_TripleToBytes(Const Value:TJLTriple;
            Var aByte,bByte,cByte:Byte);
  Begin
    aByte:=Value.nA;
    bByte:=Value.nB;
    cByte:=Value.nC;
  end;

  Procedure JL_LongToWords(Const Value:Longword;Var HighWord,LowWord:Word);
  Begin
    HighWord:=Word(Value shr 16);
    LowWord:=Word(Value);
  end;

  Procedure JL_WordToBytes(Const Value:Word;var HighByte,LowByte:Byte);
  Begin
    HighByte:=Byte(Value shr 8);
    LowByte:=Byte(Value);
  end;

  Procedure JL_ByteToNibbles(Const Value:Byte;var HighBits,LowBits:TNibble);
  Begin
    HighBits:=Value shr 4;
    LowBits:=Byte(Value shl 4) shr 4;
  end;

  Function JL_MakeNibble(Const HighBits,LowBits:TDio):TNibble;
  Begin
    Result:=Byte(HighBits shl 2) or LowBits;
  end;

  Function JL_MakePoint(Const Left,Top:Integer):TPoint;
  Begin
    result.x:=Left;
    result.y:=Top;
  end;

  Function JL_MakeRect(Const Left,Top,Right,Bottom:Integer):TRect;
  Begin
    result.Left:=Left;
    result.Top:=Top;
    result.Right:=Right;
    Result.Bottom:=Bottom;
  end;

  Function JL_MakeByte(Const HighBits,LowBits:TNibble):Byte;
  Begin
    Result:=Byte(HighBits shl 4) or Lowbits;
  end;

  Function JL_MakeWord(Const HighByte,LowByte:Byte):Word;
  Begin
    Result:=word(HighByte shl 8) or LowByte;
  end;

  Function JL_MakeLong(Const HighWord,LowWord:Word):Longword;
  Begin
    Result:=Longword(Highword shl 16) or LowWord;
  end;

  Function JL_MakeTriple(Const aByte,bByte,cByte:Byte):TJLTriple;
  Begin
    Result.nA:=aByte;
    Result.nB:=bByte;
    Result.nC:=cByte;
  end;

  Function  JL_MakeQuad(Const aByte,bByte,cByte,dByte:Byte):TJLQuad;
  Begin
    Result.nA:=aByte;
    Result.nB:=bByte;
    Result.nC:=cByte;
    result.nD:=dByte;
  end;

  Function JL_CharIsAnsi(Const Value:AnsiChar):Boolean;
  Begin
    result:=Value in CNT_JL_ANSICharset;
  end;

  (* returns true if String is numeric (number) *)
  Function JL_StrisNumeric(Value:String):Boolean;
  var
    x:    Integer;
    FLen: Integer;
  Begin
    Value:=trim(Value);
    FLen:=Length(Value);
    Result:=FLen>0;
    If result then
    Begin
      for x:=1 to FLen do
      Begin
        Result:=pos(Value[x],CNT_JL_Numeric)>0;
        If not Result then
        Break;
      end;
    end;
  end;

  Function JL_StrIsBoolean(Value:String):Boolean;
  var
    FTemp:  String;
  Begin
    result:=False;
    Value:=lowercase(trim(Value));
    if Length(Value)>0 then
    result:=(FTemp='true') or (FTemp='false');
  end;

  Function JL_StrIsFloat(Value:String):Boolean;
  var
    xpos:     Integer;
    FFirst:   String;
    FSecond:  String;
  Begin
    Value:=trim(Value);
    Result:=Length(Value)>0;
    If result then
    Begin
      xpos:=pos('.',Value);
      result:=xpos>0;
      If result then
      Begin
        If xpos>1 then
        FFirst:=copy(Value,1,xpos-1);
        FSecond:=Copy(Value,xpos+1,length(Value));
        If length(FFirst)>0 then
        Begin
          If length(FSecond)>0 then
          Result:=JL_StrIsNumeric(FFirst) and JL_StrIsNumeric(FSecond) else
          result:=JL_StrIsNumeric(FSecond);
        end else
        Begin
          If length(FSecond)>0 then
          Result:=JL_StrIsNumeric(FSecond) else
          result:=False;
        end;
      end;
    end;
  end;

  Procedure JL_MoveWord(SrcAddr,DstAddr:PWord;Const inCount:Integer);
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    PUSH    ESI
    PUSH    EDI
    MOV     ESI,srcAddr
    MOV     EDI,dstAddr
    MOV     ECX,inCount
    CMP     EDI,ESI
    JE      @exit
    REP     MOVSW
  @exit:
    POP     EDI
    POP     ESI
  end;
  {$ELSE}
  type
    PLong = ^Longword;
  var
    FLongs:   Integer;
  Begin
    FLongs:=inCount shr 3;
    while FLongs>0 do
    Begin
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(dstAddr));inc(PLong(srcAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(dstAddr));inc(PLong(srcAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(dstAddr));inc(PLong(srcAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(dstAddr));inc(PLong(srcAddr));
      dec(FLongs);
    end;

    Case inCount mod 8 of
    1:  DstAddr^:=SrcAddr^;
    2:  PLong(DstAddr)^:=PLong(SrcAddr)^;
    3:  Begin
          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));
          DstAddr^:=SrcAddr^;
        end;
    4:  Begin
          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));
          PLong(DstAddr)^:=PLong(SrcAddr)^;
        end;
    5:  Begin
          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));

          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));

          DstAddr^:=SrcAddr^;
        end;
    6:  Begin
          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));

          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));

          PLong(DstAddr)^:=PLong(SrcAddr)^;
        end;
    7:  Begin
          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));

          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));

          PLong(DstAddr)^:=PLong(SrcAddr)^;
          inc(PLong(SrcAddr));
          inc(PLong(DstAddr));

          DstAddr^:=SrcAddr^;
        end;
    end;
  end;
  {$ENDIF}

  Procedure JL_MoveTriple(SrcAddr,DstAddr:PJLTriple;Const inCount:Integer);
  type
    PLong = ^Longword;
  var
    FLongs:   Integer;
  Begin
    FLongs:=inCount shr 3;
    while FLongs>0 do
    Begin
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(srcAddr));inc(PLong(dstAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(srcAddr));inc(PLong(dstAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(srcAddr));inc(PLong(dstAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(srcAddr));inc(PLong(dstAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(srcAddr));inc(PLong(dstAddr));
      PLong(dstAddr)^:=PLong(srcAddr)^;
      inc(PLong(srcAddr));inc(PLong(dstAddr));
      dec(FLongs);
    end;

    Case inCount mod 8 of
    1:  DstAddr^:=SrcAddr^;
    2:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    3:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    4:  Begin
        PLong(dstAddr)^:=PLong(srcAddr)^;
        inc(PLong(srcAddr));inc(PLong(dstAddr));
        PLong(dstAddr)^:=PLong(srcAddr)^;
        inc(PLong(srcAddr));inc(PLong(dstAddr));
        PLong(dstAddr)^:=PLong(srcAddr)^;
        end;
    5:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    6:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    7:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    end;
  end;

  Procedure JL_MoveLong(SrcAddr,DstAddr:PLongword;Const inCount:Integer);
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    PUSH    ESI
    PUSH    EDI

    MOV     ESI,srcAddr
    MOV     EDI,dstAddr
    MOV     EAX,inCount
    CMP     EDI,ESI
    JE      @exit

    REP     MOVSD
  @exit:
    POP     EDI
    POP     ESI
  end;
  {$ELSE}
  var
    FLongs:   Integer;
  Begin
    FLongs:=inCount shr 3;
    while FLongs>0 do
    Begin
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
      dec(FLongs);
    end;
    Case inCount mod 8 of
    1:  DstAddr^:=SrcAddr^;
    2:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    3:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    4:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    5:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    6:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    7:  Begin
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^; inc(SrcAddr); inc(DstAddr);
        DstAddr^:=SrcAddr^;
        end;
    end;
  end;
  {$ENDIF}

  Function JL_Wrap(Const Value,LowRange,HighRange:Integer):Integer;
  Begin
    If value>highrange then
    Begin
      Result:=lowrange + JL_Diff(highrange,(value-1));
      If Result>highrange then
      Result:=JL_Wrap(Result,LowRange,HighRange);
    end else
    If value<lowrange then
    Begin
      Result:=highrange - JL_Diff(lowrange,value+1);
      If result<LowRange then
      Result:=JL_Wrap(Result,LowRange,HighRange);
    end else
    result:=value;
  end;

  Function JL_ToNearest(Const Value,Factor:Integer):Integer;
  var
    FTemp: Integer;
  Begin
    Result:=Value;
    FTemp:=Value mod Factor;
    If FTemp>0 then
    inc(Result,Factor - FTemp);
  end;

  Function JL_ToNearest(Const Value,Factor:Integer;
           Const Progressive:Boolean):Integer;
  Begin
    If Progressive then
    Result := (1 + (Value - 1) div Factor) * Factor else
    Result := (Value div Factor) * Factor;
  end;

  Function JL_StrideAlign(Const Value,ElementSize:Integer;
           Const AlignSize:Integer=4):Integer;
  Begin
    Result:=Value * ElementSize;
    If (Result mod AlignSize)>0 then
    result:=( (Result + AlignSize) - (Result mod AlignSize) );
  end;

  Function  JL_Diff(Const Primary,Secondary:Longword;
            Const Exclusive:Boolean=False):Longword;
  Begin
    If Primary<>Secondary then
    Begin
      If Primary>Secondary then
      result:=Primary-Secondary else
      result:=Secondary-Primary;

      If Exclusive then
      If (Primary<1) or (Secondary<1) then
      inc(result);
    end else
    result:=0;
  end;

  Function  JL_Diff(Const Primary,Secondary:Integer;
            Const Exclusive:Boolean=False):Integer;
  Begin
    If Primary<>Secondary then
    Begin
      If Primary>Secondary then
      result:=Primary-Secondary else
      result:=Secondary-Primary;

      If Exclusive then
      If (Primary<1) or (Secondary<1) then
      inc(result);

      If result<0 then
      result:=Result-1 xor -1;
    end else
    result:=0;
  end;

  Function  JL_Diff(Const Primary,Secondary:Int64;
            Const Exclusive:Boolean=False):Int64;
  Begin
    If Primary<>Secondary then
    Begin
      If Primary>Secondary then
      result:=Primary-Secondary else
      result:=Secondary-Primary;

      If Exclusive then
      If (Primary<1) or (Secondary<1) then
      inc(result);

      If result<0 then
      result:=abs(result);
    end else
    result:=0;
  end;

  Function JL_IntPositive(Const Value:Integer):Integer;
  Begin
    If Value<0 then
    Result:=Value-1 xor -1 else
    result:=Value;
  end;

  Function JL_Middle(Const Primary,Secondary:Integer):Integer;
  Begin
    result:=(Primary div 2) + (Secondary div 2);
  end;

  Function JL_PercentOfValue(Const Value,Total:Integer):Integer;
  Begin
    If (Value<=Total) then
    Result := Trunc( (Value / Total) * 100 ) else
    result:=0;
  end;

  Function JL_PercentOfValue(Const Value:Double;Total:Double):Double;
  Begin
    If (Value<=Total) then
    Result := ( (Value / Total) * 100 ) else
    result:=0;
  end;

  Function  JL_Locate(Const Value:Integer;
            Const Domain:TIntArray):Integer;
  var
    x:      Integer;
  Begin
    Result:=Length(Domain);
    If Result>0 then
    Begin
      Result:=-1;
      for x:=low(Domain) to high(Domain) do
      Begin
        If Domain[x]=Value then
        Begin
          result:=x;
          Break;
        end;
      end;
    end else
    dec(result);
  end;

  Function  JL_Locate(Const Value:Longword;
            Const Domain:TLongArray):Integer;
  var
    x:      Integer;
  Begin
    result:=Length(Domain);
    If Result>0 then
    Begin
      Result:=-1;
      for x:=low(Domain) to high(Domain) do
      Begin
        If Domain[x]=Value then
        Begin
          result:=x;
          Break;
        end;
      end;
    end else
    dec(result);
  end;

  Function  JL_Locate(Const Value:String;
            Const Domain:TStrArray):Integer;
  var
    x:  Integer;
  Begin
    Result:=Length(Domain);
    If Result>0 then
    Begin
      Result:=-1;
      for x:=low(Domain) to high(Domain) do
      Begin
        If Domain[x]=Value then
        Begin
          result:=x;
          Break;
        end;
      end;
    end else
    dec(result);
  end;

  Function JL_Largest(Const Domain:TIntArray):Integer;
  var
    x:  Integer;
  Begin
    Result:=Length(Domain);
    If Result>0 then
    Begin
      Result:=0;
      for x:=low(Domain) to high(domain) do
      if domain[x]>result then
      result:=domain[x];
    end;
  end;

  Function JL_IntAverage(Const Domain:TIntArray):Integer;
  var
    x:      Integer;
    FCount: Integer;
    FTemp:  Int64;
  Begin
    result:=0;
    FCount:=Length(Domain);
    If FCount>1 then
    Begin
      FTemp:=0;
      for x:=Low(Domain) to high(domain) do
      inc(FTemp,Domain[x]);
      Result:=Integer(FTemp div FCount);
    end else
    If FCount>0 then
    Result:=Domain[0];
  end;

  Function JL_Sum(Const Domain:TIntArray):Integer;

  procedure _RaiseOverflowError;
  begin
    raise EIntOverflow.Create('Integer overflow');
  end;

  asm  // IN: EAX = ptr to Data, EDX = High(Data) = Count - 1
     // loop unrolled 4 times, 5 clocks per loop, 1.2 clocks per datum
      PUSH EBX
      MOV  ECX, EAX         // ecx = ptr to data
      MOV  EBX, EDX
      XOR  EAX, EAX
      AND  EDX, not 3
      AND  EBX, 3
      SHL  EDX, 2
      JMP  @Vector.Pointer[EBX*4]
  @Vector:
      DD @@1
      DD @@2
      DD @@3
      DD @@4
  @@4:
      ADD  EAX, [ECX+12+EDX]
      JO   _RaiseOverflowError
  @@3:
      ADD  EAX, [ECX+8+EDX]
      JO   _RaiseOverflowError
  @@2:
      ADD  EAX, [ECX+4+EDX]
      JO   _RaiseOverflowError
  @@1:
      ADD  EAX, [ECX+EDX]
      JO   _RaiseOverflowError
      SUB  EDX,16
      JNS  @@4
      POP  EBX
  end;

  Function JL_Largest(Const Primary,Secondary:Integer):Integer;
  Begin
  {$IFNDEF JL_USE_ASSEMBLER}
    If Primary>Secondary then
    result:=Primary else
    result:=Secondary;
  {$ELSE}
    Result:=Primary;
    asm
      mov ECX, Secondary    // Store I2 in ECX
      mov EDX, Primary    // Store I1 in EDX
      cmp EDX, ECX   // compare I2 to I1
      jg @TheEnd     // if I2>I1 then Exit {result already set}
      @ItIsLess:
      mov Result,ECX // result=I2/Exit
      @TheEnd:
    end;
  {$ENDIF}
  end;

  Function JL_Smallest(Const Primary,Secondary:Integer):Integer;
  begin
  {$IFDEF JL_USE_ASSEMBLER}
    Result:=Primary;
    asm
      mov ECX, Secondary    // Store I2 in ECX
      mov EDX, Primary    // Store I1 in EDX
      cmp EDX, ECX   // compare I2 to I1
      jl @TheEnd     // if I2<I1 then Exit {result already set}
    @ItIsLess:
      mov Result,ECX // result=I2/Exit
    @TheEnd:
    end;
  {$ELSE}
    If Primary<Secondary then
    result:=Primary else
    result:=Secondary;
  {$ENDIF}
  end;

  Function JL_Smallest(Const Domain:TIntArray):Integer;
  var
    x:  Integer;
  Begin
    result:=Length(Domain);
    If Result>0 then
    Begin
      Result:=MAXINT;
      for x:=low(Domain) to high(Domain) do
      If Domain[x]<Result then
      result:=Domain[x];
    end;
  end;

  Function JL_StrClip(Value:String;MaxLen:Integer):String;
  var
    FLen: Integer;
  Begin
    FLen:=Length(Value);
    if (FLen>MaxLen) and (maxlen>2) then
    Begin
      Delete(Value,1,JL_Diff(FLen,MaxLen) + 2);

      While (length(Value)>0)
      and (Value[1]=' ')
      or  (pos(Value[1],CNT_JL_Characters)<1) do
      Delete(Value,1,1);

      result:='..' + Value;
    end else
    result:=Value;
  end;

  Function JL_StrPush(Const Value:String;var Domain:String):Boolean;
  var
    FTemp:  WideString;
  Begin
    If length(Domain)>0 then
    Begin
      result:=Length(Value)>0;
      If result then
      Begin
        FTemp:=Domain;
        Domain:=Value + FTemp;
      end;
    end else
    Begin
      result:=Length(Value)>0;
      if result then
      Domain:=Value;
    end;
  end;

  Procedure JL_StrAdd(Const Value:String;var Domain:String;
            Const AddCRLF:Boolean=False);
  Begin
    If Length(Value)>0 then
    Begin
      If Length(Domain)>0 then
      Domain:=Domain + Value else
      Domain:=Value;
    end;
    if AddCRLF then
    Domain:=Domain + CNT_JL_CRLF;
  end;

  Function  JL_StrAdd(Const Value:String;var Domain:String;
            Const LengthLimit:Integer):Boolean;
  var
    FNewLen:  Integer;
  Begin
    result:=False;
    If Length(Value)>0 then
    Begin
      If LengthLimit>0 then
      Begin
        FNewLen:=Length(Domain) + Length(Value);
        Result:=FNewLen>=LengthLimit;

        If FNewLen>LengthLimit then
        Begin
          dec(FNewLen,LengthLimit);
          Result:=FNewLen>0;
          If result then
          Domain:=Domain + Copy(Value,1,FNewLen);
        end else
        JL_StrAdd(Value,Domain);
      end else
      JL_StrAdd(Value,Domain);
    end;
  end;

  Function JL_BinToByte(Const Value:String):Byte;
  var
    FPin: Integer;
  Begin
    Result:=0;
    FPin:=Length(Value);
    FPin:=math.EnsureRange(FPin,1,8);
    While FPin>0 do
    Begin
      If Value[FPin]='1' then
      Result:=result + (1 shl (8-FPin) );
      dec(FPin);
    end;
  end;

  Function JL_ByteToBin(Value:Byte):String;
  var
    FPin: Integer;
  Begin
    FPin:=8;
    Result:='00000000';
    while FPin>0 do
    begin
      if (Value and 1)=1 then
      result[FPin]:='1';
      dec(FPin);
      Value:=Value shr 1;
    end;
  end;

  Function JL_WordToBin(Value:Word):String;
  var
    FPin: Integer;
  Begin
    FPin:=16;
    Result:='0000000000000000';
    while FPin>0 do
    begin
      if (Value and 1)=1 then
      result[FPin]:='1';
      dec(FPin);
      Value:=Value shr 1;
    end;
  end;

  Function JL_BinToWord(Const Value:String):Word;
  var
    FPin: Integer;
  Begin
    Result:=0;
    FPin:=Length(Value);
    FPin:=math.EnsureRange(FPin,1,16);
    While FPin>0 do
    Begin
      If Value[FPin]='1' then
      Result:=result + (1 shl (16-FPin) );
      dec(FPin);
    end;
  end;


  Function JL_BinToLong(Const Value:String):Longword;
  var
    FPin: Integer;
  Begin
    Result:=0;
    FPin:=Length(Value);
    FPin:=math.EnsureRange(FPin,1,32);
    While FPin>0 do
    Begin
      If Value[FPin]='1' then
      Result:=result + (1 shl (16-FPin) );
      dec(FPin);
    end;
  end;

  Function JL_LongToBin(Value:Longword):String;
  var
    FPin: Integer;
  Begin
    FPin:=32;
    Result:='00000000000000000000000000000000';
    while FPin>0 do
    begin
      if (Value and 1)=1 then
      result[FPin]:='1';
      dec(FPin);
      Value:=Value shr 1;
    end;
  end;

  Function JL_BinToInt(Const Value:String):Integer;
  var
    FPin: Integer;
  Begin
    Result:=0;
    FPin:=Length(Value);
    FPin:=math.EnsureRange(FPin,1,32);
    While FPin>0 do
    Begin
      If Value[FPin]='1' then
      Result:=result + (1 shl (32-FPin) );
      dec(FPin);
    end;
  end;

  Function JL_IntToBin(Value:Integer):String;
  var
    FPin:   Integer;
    FData:  Longword absolute Value;
  Begin
    FPin:=32;
    Result:='00000000000000000000000000000000';
    while FData>0 do
    begin
      if (FData and 1)=1 then
      result[FPin]:='1';
      dec(FPin);
      FData:=FData shr 1;
    end;
  end;

  Procedure JL_Swap(Var Primary,Secondary:Integer);
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    MOV     ECX, [EAX]
    XCHG    ECX, [EDX]
    MOV     [EAX], ECX
  {$ELSE}
  var
    FTemp: Integer;
  Begin
    FTemp:=Primary;
    Primary:=Secondary;
    Secondary:=FTemp;
  {$ENDIF}
  end;

  Procedure JL_Swap(Var Primary,Secondary:Int64);
  var
    FTemp: Int64;
  Begin
    FTemp:=Primary;
    Primary:=Secondary;
    Secondary:=FTemp;
  end;

  Procedure JL_Swap(Var Primary,Secondary:String);
  var
    FTemp: String;
  Begin
    FTemp:=Primary;
    Primary:=Secondary;
    Secondary:=FTemp;
  end;

  Procedure JL_Swap(Var Primary,Secondary:Word);
  var
    FTemp:  Word;
  Begin
    FTemp:=Primary;
    Primary:=Secondary;
    Secondary:=FTemp;
  end;

  Procedure JL_Swap(Var Primary,Secondary:Longword);
  var
    FTemp: Longword;
  Begin
    FTemp:=Primary;
    Primary:=Secondary;
    Secondary:=FTemp;
  end;

  Procedure JL_SwapLess(var Primary,Secondary:Integer);
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    MOV     ECX, [EAX]
    CMP     ECX, [EDX]
    JNG     @_EXIT      //  JLE ?
    XCHG    ECX, [EDX]
    MOV     [EAX], ECX
    @_EXIT:
  {$ELSE}
  var
    FTemp:  Integer;
  Begin
    If Secondary<Primary then
    Begin
      FTemp:=Primary;
      Primary:=Secondary;
      Secondary:=FTemp;
    end;
  {$ENDIF}
  end;

  Procedure JL_SwapMore(var Primary,Secondary:Integer);
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    MOV     ECX, [EAX]
    CMP     ECX, [EDX]
    JG      @_EXIT
    XCHG    ECX, [EDX]
    MOV     [EAX], ECX
    @_EXIT:
  {$ELSE}
  var
    FTemp:  Integer;
  Begin
    If Secondary>Primary then
    Begin
      FTemp:=Secondary;
      Secondary:=Primary;
      Primary:=FTemp;
    end;
  {$ENDIF}
  end;

  function JL_PrimeNumber(Const Value:Longword):Boolean;
  var
    I, J : Longword;
  begin
    If Value>=4 then
    begin
      Result:=False;
      I:= (Value mod 6);
      if (I=1) or (I=5) then
      begin
        J := round(sqrt(Value));
        I := 5;
        while I <= J do
        begin
          if (Value mod I = 0) then
          Exit;
          if  (Value <> J)
          and (Value mod (I+2) = 0) then
          Exit;
          inc(I,6);
        end;
        Result := True;
      end;
    end else
    result:=(Value>1);
  end;

  function JL_PrimeNumberFind(Const Value:Longword):Longword;
  var
    I : Cardinal;
  begin
    If JL_PrimeNumber(Value) then
    Result:=Value else
    if Value=4 then
    result:=5 else
    Begin
      I:= ((Value+1) div 6) * 6 - 1;
      While True do
      Begin
        If JL_PrimeNumber(I+2) then
        Begin
          Inc(I,2);
          Break;
        end else
        If JL_PrimeNumber(I) then
        Break;
        inc(I,6);
      End;
      Result := I;
    end;
  end;

  Function JL_ELFHash(Const Value:String):Longword;
  var
    FAddr:  Pointer;
    FLen:   Integer;
  Begin
    FLen:=Length(Value);
    If FLen>0 then
    Begin
      FAddr:=@Value[1];
      FLen:=(FLen * Sizeof(Char));
      Result:=JL_ELFHash(FAddr^,FLen);
    end else
    result:=0;
  end;

  Function JL_ELFHash(Const Buffer;Const Bytes:Integer):Longword;
  {$IFDEF JL_USE_ASSEMBLER}
  asm
     mov   edx, eax
     xor   eax, eax
     test  edx, edx
     jz    @_EXIT
     sub   eax, [edx-4]
     jz    @_EXIT
     mov   ecx, eax
     sub   edx, eax
     xor   eax, eax
     push  ebx
  @Loop:
     movzx ebx, [edx+ecx]
     add   ebx, eax
     lea   eax, [ebx+ebx]
     shr   ebx, 20
     lea   eax, [8*eax]
     and   ebx, $0F00
     xor   eax, ebx
     add   ecx, 1
     jnz   @Loop
     shr   eax, 4
     pop   ebx
  @_EXIT:
  {$ELSE}
  var
    i:    Integer;
    x:    Cardinal;
    FSrc: PByte;
  Begin
    Result:=0;
    If bytes>0 then
    Begin
      FSrc:=@Buffer;
      for i:=1 to Bytes do
      begin
        Result := (Result shl 4) + FSrc^;
        x := Result and $F0000000;
        if (x <> 0) then
        Result := Result xor (x shr 24);
        Result := Result and (not x);
        inc(FSrc);
      end;
    end;
  {$ENDIF}
  end;

  //#########################################################################
  //  Method:     JL_RLEDeCompress()
  //  Purpose:    De-Compress memory segment using the Run Length scheme
  //  Returns:    Length of de-compressed data
  //
  //  Parameters:
  //              Source:     PTR to input data
  //              Target:     PTR to output data
  //              TargetSize: Length of target buffer
  //              Fetch:      Bytes per element
  //
  //  Comments:   See JL_RLECompress() for more info
  //  Warning:    See JL_RLECompress() for more info
  //#########################################################################
  function  JL_RLEDecompress(const Source,Target;
            TargetSize:Longword;Fetch:Byte):Longword;
  var
    I: Integer;
    SourcePtr,
    TargetPtr:  PByte;
    RunLength:  Longword;
    Counter:    Longword;

  begin
    Result := 0;
    Counter := 0;
    TargetPtr := @Target;
    SourcePtr := @Source;

    While Counter<TargetSize do
    Begin
      RunLength := 1 + (SourcePtr^ and $7F);
      if SourcePtr^ > $7F then
      begin
        (* decode RLE packed byte *)
        Inc(SourcePtr);
        for I := 0 to RunLength - 1 do
        begin
          Case Fetch of
          1:  TargetPtr^:=SourcePtr^;
          2:  PWord(TargetPtr)^:=PWord(SourcePtr)^;
          3:  PJLTriple(TargetPtr)^:=PJLTriple(SourcePtr)^;
          4:  PLongword(TargetPtr)^:=PLongword(SourcePTR)^;
          end;
          Inc(TargetPtr,Fetch);
        end;
        Inc(SourcePtr, Fetch);
        Inc(Result, Fetch + 1);
      end else
      begin
        (* decode NON-RLE packet *)
        Inc(SourcePtr);
        Move(SourcePtr^,targetptr^,RunLength);
        inc(targetptr,RunLength);
        inc(sourceptr,RunLength);
        Inc(Result, RunLength + 1)
      end;
      Inc(Counter, RunLength);
    end;
  end;

  //#########################################################################
  //  Method:     JLRLECompress()
  //  Purpose:    Compress memory segment using the Run Length scheme
  //  Returns:    Length of compressed data
  //
  //  Parameters:
  //              Source: PTR to input data
  //              Target: PTR to output data
  //              Size:   Length of input data
  //              Fetch:  Bytes per element (see comments below)
  //
  //  Comments:   RLE "compress" data by finding sequences of data
  //              that contains the same value. The collection of sequences
  //              is called a dictionary.
  //              In order to build such a dictionary, the compressor needs
  //              to know the size of each element being compressed.
  //              With images, this is typically 1..4 bytes, depenting on
  //              the pixel format (8bit=1, 15|16bit=2, 24Bit=3, 32Bit=4)
  //              repeated sequences of information, such as bitmaps and
  //  Warning:
  //              RLE is not suitable for all types of data. In some cases
  //              the output will be larger than input!
  //              AS A RULE, Calculate the size of the output
  //              buffer as: (input size*2 + 1)
  //#########################################################################

  function  JL_RLECompress(const Source,Target;
            SourceSize:Longword;Fetch:Byte):Longword;
  var
    DiffCount:  Integer;
    SameCount:  Integer;
    SourcePtr:  PByte;
    TargetPtr:  PByte;

    Procedure GetElement(Const src;var outValue);
    begin
      Case Fetch of
      1:  PByte(@outValue)^:=PByte(@src)^;
      2:  PWord(@outValue)^:=PWord(@src)^;
      3:  PJLTriple(@outValue)^:=PJLTriple(@src)^;
      4:  PLongword(@outValue)^:=PLongword(@src)^;
      end;
    end;

    function CountUniqueElements(P:PByte;Count:Integer):Integer;
    var
      N:            Integer;
      Element:      Longword;
      NextElement:  Longword;
    begin
        N:=0;
        Element:=0;
        NextElement:=0;
      If Count=1 then
      result:=Count else
      Begin
        GetElement(P^,Element);
        while Count>1 do
        begin
          Inc(P,Fetch);
          GetElement(P^,NextElement);
          If NextElement=Element then
          Break;
          Element:=NextElement;
          inc(N);
          Dec(Count);
        end;
        if NextElement=Element then
        result:=N else
        result:=N + 1;
      end;
    end;

    function CountEqualElements(P:PByte;Count:Integer):Integer;
    var
      Element,
      NextElement: Cardinal;
    begin
      Result:=1;
      Element:=0;
      NextElement:=0;
      GetElement(P^,Element);
      Dec(Count);
      while Count>0 do
      begin
        Inc(P, Fetch);
        GetElement(P^,NextElement);
        if NextElement<>Element then
        Break;
        Inc(Result);
        Dec(Count);
      end;
    end;

  begin
    Result:=0;
    SourcePtr := @Source;
    TargetPtr := @Target;
    while SourceSize > 0 do
    begin
      DiffCount := CountUniqueElements(SourcePtr,SourceSize);
      DiffCount:=math.EnsureRange(DiffCount,0,128);
      if DiffCount > 0 then
      begin
        (* create a raw, unaltered packet *)
        TargetPtr^:=DiffCount-1;
        Inc(TargetPtr);
        Dec(SourceSize, DiffCount);
        Move(targetPTR^,sourcePTR^,DiffCount);
        inc(SourcePtr,DiffCount);
        inc(TargetPTR,DiffCount);
        Inc(Result, (DiffCount * Fetch) + 1);
      end;

      SameCount := CountEqualElements(SourcePtr,SourceSize);
      SameCount:=math.EnsureRange(SameCount,0,128);
      if SameCount > 1 then
      begin
        (* create a RLE packet *)
        TargetPtr^ := (SameCount - 1) or $80; Inc(TargetPtr);
        Dec(SourceSize, SameCount);
        Inc(SourcePtr, (SameCount - 1) * Fetch);
        Inc(Result, Fetch + 1);

        TargetPtr^ := SourcePtr^;
        Inc(SourcePtr);
        Inc(TargetPtr);

        Case Fetch-1 of
        1:  PByte(TargetPtr)^:=PByte(SourcePtr)^;
        2:  PWord(TargetPtr)^:=PWord(SourcePtr)^;
        3:  PJLTriple(TargetPtr)^:=PJLTriple(SourcePtr)^;
        end;

        inc(SourcePtr,Fetch-1);
        inc(TargetPTR,Fetch-1);
      end;
    end;
  end;

  Function JL_MaskValidValue(Const Value:Longword):Boolean;
  Begin
    Case Value of
    1, 2, 4, 8, 16, 32, 64, 128,
    256, 512, 1024, 2048, 4096, 8192, 16384, 32768,
    65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608,
    16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824,
    2147483648: Result:=True else
    result:=False;
    end;
  end;

  Function JL_MaskSet(Const Mask,Value:Longword):Longword;overload;
  Begin
    If JL_MaskValidValue(Value) then
    Begin
      If not (Mask and Value=Value) then
      Result:=Mask or Value else
      result:=Mask;
    end else
    Raise Exception.CreateFmt(ERR_JL_MASK_INVALIDMASK,[Value]);
  end;

  Function  JL_MaskSet(Const Mask:Longword;
            Const Values:Array of Longword):Longword;overload;
  var
    FCount: Integer;
  Begin
    //FCount:=High(Values) - Low(Values) + 1;
    FCount:=Length(Values);
    If FCount>0 then
    Begin
      Result:=Mask;
      for FCount:=Low(Values) to High(Values) do
      Result:=JL_MaskSet(Result,Values[FCount]);
    end else
    result:=Mask;
  end;

  Function JL_MaskGet(Const Mask,Value:Longword):Boolean;overload;
  Begin
    If JL_MaskValidValue(Value) then
    Result:=(Mask and Value)=Value else
    Raise Exception.CreateFmt(ERR_JL_MASK_INVALIDMASK,[Value]);
  End;

  Function JL_MaskGet(Const Mask:Longword;
            Const Values:Array of Longword):Boolean;overload;
  var
    FCount: Integer;
  Begin
    result:=False;
    FCount:=Length(Values);
    If FCount>0 then
    Begin
      for FCount:=Low(Values) to High(Values) do
      Begin
        Result:=JL_MaskGet(Mask,Values[FCount]);
        If not result then
        break;
      end;
    end;
  end;

  Function JL_MaskClr(Const Mask,Value:Longword):Longword;overload;
  Begin
    If JL_MaskValidValue(Value) then
    Begin
      If (Mask and Value=Value) then
      result:=Mask xor Value else
      result:=Mask;
    end else
    Raise Exception.CreateFmt(ERR_JL_MASK_INVALIDMASK,[Value]);
  end;

  Function JL_MaskClr(Const Mask:Longword;
            Const Values:Array of Longword):Longword;overload;
  var
    FCount: Integer;
  Begin
    FCount:=Length(Values);
    If FCount>0 then
    Begin
      Result:=Mask;
      for FCount:=Low(Values) to High(Values) do
      result:=JL_MaskClr(Result,Values[FCount]);
    end else
    result:=Mask;
  end;

  Procedure JL_SortStr(Const Domain:TStrArray;
            Const Decending:Boolean=True);
  var
    x:          Integer;
    FCount:     Integer;
    FLower:     Integer;
    FLowRange:  Integer;
    FComplete:  Boolean;
    FSwap:      Boolean;
  Begin
    FCount:=Length(Domain);
    If FCount>1 then
    Begin
      FLowRange:=Low(Domain)+1;
      FLower:=FLowRange;

      Repeat
        (* Decend elements & mark change *)
        FComplete:=True;
        for x:=FLower to high(Domain) do
        Begin
          (* swap based on acending / decending criteria *)
          If Decending then
          FSwap:=AnsiCompareStr(Domain[x-1],Domain[x])<0 else
          FSwap:=AnsiCompareStr(Domain[x-1],Domain[x])>0;
          If FSwap then
          Begin
            JL_Swap(Domain[x-1],Domain[x]);
            FComplete:=False;
          end;
        end;

        (* are we done? *)
        If  (FComplete=False)
        and (FLower>FLowRange) then
        dec(FLower);
      Until FComplete;
    end;
  end;

  Procedure JL_SortInt(Const Domain:TIntArray;
            Const Decending:Boolean=True);
  var
    x:          Integer;
    FCount:     Integer;
    FLower:     Integer;
    FLowRange:  Integer;
    FComplete:  Boolean;
    FSwap:      Boolean;
  Begin
    FCount:=Length(Domain);
    If FCount>1 then
    Begin
      FLowRange:=Low(Domain)+1;
      FLower:=FLowRange;

      Repeat
        (* Decend elements & mark change *)
        FComplete:=True;
        for x:=FLower to high(Domain) do
        Begin
          (* swap based on acending / decending criteria *)
          If Decending then
          FSwap:=Domain[x-1]>Domain[x] else
          FSwap:=Domain[x-1]<Domain[x];
          If FSwap then
          Begin
            JL_Swap(Domain[x-1],Domain[x]);
            FComplete:=False;
          end;
        end;

        (* are we done? *)
        If  (FComplete=False)
        and (FLower>FLowRange) then
        dec(FLower);
      Until FComplete;
    end;
  end;

  Procedure JL_SortLong(Const Domain:TLongArray;
            Const Decending:Boolean=True);
  var
    x:          Integer;
    FCount:     Integer;
    FLower:     Integer;
    FLowRange:  Integer;
    FComplete:  Boolean;
    FSwap:      Boolean;
  Begin
    FCount:=Length(Domain);
    If FCount>1 then
    Begin
      FLowRange:=Low(Domain)+1;
      FLower:=FLowRange;

      Repeat
        (* Decend elements & mark change *)
        FComplete:=True;
        for x:=FLower to high(Domain) do
        Begin
          (* swap based on acending / decending criteria *)
          If Decending then
          FSwap:=Domain[x-1]>Domain[x] else
          FSwap:=Domain[x-1]<Domain[x];
          If FSwap then
          Begin
            JL_Swap(Domain[x-1],Domain[x]);
            FComplete:=False;
          end;
        end;

        (* are we done? *)
        If  (FComplete=False)
        and (FLower>FLowRange) then
        dec(FLower);
      Until FComplete;
    end;
  end;

  Procedure JL_SortWord(Const Domain:TWordArray;
            Const Decending:Boolean=True);
  var
    x:          Integer;
    FCount:     Integer;
    FLower:     Integer;
    FLowRange:  Integer;
    FComplete:  Boolean;
    FSwap:      Boolean;
  Begin
    FCount:=Length(Domain);
    If FCount>1 then
    Begin
      FLowRange:=Low(Domain)+1;
      FLower:=FLowRange;

      Repeat
        (* Decend elements & mark change *)
        FComplete:=True;
        for x:=FLower to high(Domain) do
        Begin
          (* swap based on acending / decending criteria *)
          If Decending then
          FSwap:=Domain[x-1]>Domain[x] else
          FSwap:=Domain[x-1]<Domain[x];
          If FSwap then
          Begin
            JL_Swap(Domain[x-1],Domain[x]);
            FComplete:=False;
          end;
        end;

        (* are we done? *)
        If  (FComplete=False)
        and (FLower>FLowRange) then
        dec(FLower);
      Until FComplete;
    end;
  end;

  Function JL_StreamToVariant(Const Value:TStream;
           FromPos:Boolean=False;Dispose:Boolean=False):Variant;
  var
    FData:  Pointer;
    FSize:  Int64;
  Begin
    Result:=UnAssigned;
    If Value<>NIL then
    Begin
      try
        If Value.Size>0 then
        Begin
          (* rewind if required *)
          If (FromPos=False) and (Value.Position>0) then
          Value.Position:=0;

          If FromPos then
          FSize:=Value.Size - Value.Position else
          FSize:=Value.Size;

          If FSize>0 then
          Begin
            (* create the result variant *)
            Result:=VarArrayCreate([0,Value.Size-1],varByte);

            (* lock memory & copy data *)
            FData:=varArrayLock(Result);
            try
              Value.Read(FData^,FSize);
            finally
              VarArrayUnLock(Result);
            end;
          end;
        end;
      finally
        (* dispose of stream instance? *)
        If Dispose then
        Value.free;
      end;
    end;
  end;

  Function JL_VariantToStream(Const Value:Variant):TStream;
  Begin
    result:=TMemoryStream.Create;
    If  not VarIsNull(Value)
    and not varIsEmpty(Value) then
    Begin
      try
        JL_VariantToStream(Value,Result);
      except
        on exception do
        Begin
          freeAndNil(result);
          Raise;
        end;
      end;
    end;
  end;

  Function JL_VariantToStream(Const Value:Variant;Stream:TStream):Int64;
  var
    FText:    String;
    FRoot:    Int64;
    FDataPTR: Pointer;
    FDataLen: Integer;

    Procedure AddVariantArray(Const inVar:Variant);
    var
      FDepth: Integer;
      x,y:    Integer;
    Begin
      If not VarIsEmpty(inVar) then
      Begin
        FDepth:=VarArrayDimCount(inVar);
        for y:=1 to FDepth do
        for x:=VarArrayLowBound(inVar,Y) to VarArrayHighBound(inVar,Y) do
        JL_VariantToStream(inVar[x],Stream);
      end;
    End;

  Begin
    result:=0;
    If (Stream<>NIL) and (Value<>NULL) then
    Begin
      (* remember current stream position *)
      FRoot:=Stream.Position;

      If varIsArray(Value) then
      AddVariantArray(Value) else
      Begin
        (* write supported data *)
        With TVarData(Value) do
        Case TVarData(Value).VType of
        varSmallInt:  Stream.Write(VSmallInt,SizeOf(SmallInt));
        varInteger:   Stream.WriteBuffer(VInteger,SizeOf(Integer));
        varSingle:    Stream.WriteBuffer(VSingle,SizeOf(Single));
        varDouble:    Stream.WriteBuffer(VDouble,SizeOf(Double));
        varCurrency:  Stream.WriteBuffer(VCurrency,SizeOf(Currency));
        varDate:      Stream.WriteBuffer(VDate,SizeOf(TDateTime));
        varError:     Stream.WriteBuffer(VError,SizeOf(Longint));
        varBoolean:   Stream.WriteBuffer(VBoolean,SizeOf(WordBool));
        varShortInt:  Stream.WriteBuffer(VShortInt,SizeOf(ShortInt));
        varByte:      Stream.WriteBuffer(VByte,SizeOf(Byte));
        varWord:      Stream.WriteBuffer(VWord,SizeOf(Word));
        varLongWord:  Stream.WriteBuffer(VLongword,SizeOf(Longword));
        varInt64:     Stream.WriteBuffer(VInt64,SizeOf(Int64));
        varVariant:   JL_VariantToStream(PVariant(VPointer)^,Stream);
        //varArray:     AddVariantArray(Value);
        varBlob:
          Begin
            (*  Blob variants are not supported in Delphi by default(!).
                Found this solution in Peter Below's wonderfull works. *)
            FDataLen:=RawData[2];
            FDataPTR:=Pointer(RawData[3]);
            If (FDataPTR<>NIL) and (FDataLen>0) then
            Stream.Write(FDataPTR^,FDataLen);
          end;

        varOleStr:
          Begin
            FText:=OleStrToString(TVarData(Value).VOleStr);
            If length(FText)>0 then
            Begin
              FDataLen:=Length(FText) * SizeOf(Char);
              Stream.WriteBuffer(FText[1],FDataLen);
            end;
          end;

        varString:
          Begin
            FText:=variants.VarToStr(Value);
            If length(FText)>0 then
            Begin
              FDataLen:=Length(FText) * SizeOf(Char);
              Stream.WriteBuffer(FText[1],FDataLen);
            end;
          end;

        end;
      end;

      (* return # of bytes written *)
      result:=Stream.Position - FRoot;
    end;
  end;



  Procedure JL_FillWord(dstAddr:PWord;Const inCount:Integer;Const Value:Word);
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    PUSH   EDI
    PUSH   EBX
    shl    edx,1
    MOV    EBX, EDX
    MOV    EDI, EAX
    MOV    EAX, ECX
    MOV    CX, AX
    SHL    EAX, 16
    MOV    AX, CX
    MOV    ECX, EDX
    SHR    ECX, 2
    JZ     @Word
    REP    STOSD
  @Word:
    MOV    ECX, EBX
    AND    ECX, 2
    JZ     @Byte
    MOV    [EDI], AX
    ADD    EDI, 2
  @Byte:
    MOV    ECX, EBX
    AND    ECX, 1
    JZ     @Exit
    MOV    [EDI], AL
  @Exit:
    POP    EBX
    POP    EDI
  end;
  {$ELSE}
  var
    FTemp:  Longword;
    FLongs: Integer;
  Begin
    FTemp:=Value shl 16 or Value;
    FLongs:=inCount shr 3;
    while FLongs>0 do
    Begin
      PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
      PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
      PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
      PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
      dec(FLongs);
    end;

    Case inCount mod 8 of
    1:  dstAddr^:=Value;
    2:  PLongword(dstAddr)^:=FTemp;
    3:  Begin
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          dstAddr^:=Value;
        end;
    4:  Begin
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          PLongword(dstAddr)^:=FTemp;
        end;
    5:  Begin
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          dstAddr^:=Value;
        end;
    6:  Begin
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          PLongword(dstAddr)^:=FTemp;
        end;
    7:  Begin
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          PLongword(dstAddr)^:=FTemp; inc(PLongword(dstAddr));
          dstAddr^:=Value;
        end;
    end;
  end;
  {$ENDIF}

  Procedure JL_FillTriple(dstAddr:PRGBTriple;
            Const inCount:Integer;Const Value:TRGBTriple);
  var
    FLongs: Integer;
  Begin
    FLongs:=inCount shr 3;
    While FLongs>0 do
    Begin
      dstAddr^:=Value;inc(dstAddr);
      dstAddr^:=Value;inc(dstAddr);
      dstAddr^:=Value;inc(dstAddr);
      dstAddr^:=Value;inc(dstAddr);
      dstAddr^:=Value;inc(dstAddr);
      dstAddr^:=Value;inc(dstAddr);
      dstAddr^:=Value;inc(dstAddr);
      dstAddr^:=Value;inc(dstAddr);
      dec(FLongs);
    end;

    Case (inCount mod 8) of
    1:  dstAddr^:=Value;
    2:  Begin
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;
        end;
    3:  Begin
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;
        end;
    4:  Begin
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;
        end;
    5:  Begin
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;
        end;
    6:  Begin
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;
        end;
    7:  Begin
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;inc(dstAddr);
          dstAddr^:=Value;
        end;
    end;
  end;

  Procedure JL_FillLong(dstAddr:PLongword;Const inCount:Integer;
            Const Value:Longword);
  {$IFDEF JL_USE_ASSEMBLER}
  asm
    PUSH    EDI
    MOV     EDI,EAX
    MOV     EAX,ECX
    MOV     ECX,EDX
    TEST    ECX,ECX
    JS      @exit
    REP     STOSD
    @exit:
    POP     EDI
  end;
  {$ELSE}
  var
    FLongs: Integer;
  Begin
    FLongs:=inCount shr 3;
    While FLongs>0 do
    Begin
      dstAddr^:=Value; inc(dstAddr);
      dstAddr^:=Value; inc(dstAddr);
      dstAddr^:=Value; inc(dstAddr);
      dstAddr^:=Value; inc(dstAddr);
      dstAddr^:=Value; inc(dstAddr);
      dstAddr^:=Value; inc(dstAddr);
      dstAddr^:=Value; inc(dstAddr);
      dstAddr^:=Value; inc(dstAddr);
      dec(FLongs);
    end;

    Case inCount mod 8 of
    1:  dstAddr^:=Value;
    2:  Begin
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value;
        end;
    3:  Begin
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value;
        end;
    4:  Begin
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value;
        end;
    5:  Begin
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value;
        end;
    6:  Begin
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value;
        end;
    7:  Begin
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value; inc(dstAddr);
          dstAddr^:=Value;
        end;
    end;
  end;
  {$ENDIF}

  Function JL_GetObjectUnit(Const AObject:TPersistent):String;
  var
    ptrTypeData: PTypeData;
  begin
    SetLength(result,0);
    if (AObject<>NIL)
    and (AObject.ClassInfo<>nil) then
    begin
      ptrTypeData:=GetTypeData(AObject.ClassInfo);
      Result:=ptrTypeData^.UnitName;
    end;
  end;

  Function JL_GetObjectPath(Const AObject:TPersistent):String;
  var
    FAncestor:  TClass;
  Begin
    SetLength(result,0);
    If AObject<>NIL then
    Begin
      FAncestor:=AObject.ClassParent;
      While FAncestor<>NIL do
      Begin
        If Length(Result)>0 then
        Result:=(FAncestor.ClassName + '.' + Result) else
        Result:=FAncestor.ClassName;
        FAncestor:=FAncestor.ClassParent;
      end;
    end;
    If Length(Result)>0 then
    result:=result + '.' + AObject.ClassName else
    result:=AObject.ClassName;
  end;

  Function JL_GetOSType(out Value:TJLWinOSType):Boolean;
  var
    FInfo: TOSVersionInfoA;
  begin
    (* default to unknown *)
    Value:=otUnknown;

    (* prepare version-info call *)
    fillchar(FInfo,SizeOf(FInfo),#0);
    FInfo.dwOSVersionInfoSize:=sizeof(FInfo);

    (* Call OS to get info *)
    result:=GetVersionExA(FInfo);
    If result then
    Begin
      Case FInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT:
        Begin
          if FInfo.dwMajorVersion <= 4 then
          Value:=otWinNT else

          if (FInfo.dwMajorVersion = 5)
          and (FInfo.dwMinorVersion = 0) then
          Value:=otWin2000 else

          if (FInfo.dwMajorVersion = 5)
          and (FInfo.dwMinorVersion = 1) then
          Value:=otWinXP else

          if (FInfo.dwMajorVersion = 6)
          and (FInfo.dwMinorVersion=0) then
          Value:=otVista else

          if (FInfo.dwMajorVersion=6)
          and (FInfo.dwMinorVersion=1) then
          Value:=otWin7;
        end;
      VER_PLATFORM_WIN32_WINDOWS:
        Begin
         if (FInfo.dwMajorVersion = 4)
         and (FInfo.dwMinorVersion = 0) then
         Value:=otWin95 else

         if (FInfo.dwMajorVersion = 4)
         and (FInfo.dwMinorVersion = 10) then
         Value:=otWin98 else

         if (FInfo.dwMajorVersion = 4)
         and (FInfo.dwMinorVersion = 90) then
         Value:=otWinME;
        end;
      end;
    End;
  End;


  end.
