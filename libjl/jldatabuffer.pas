  unit jldatabuffer;

  {$I 'jldefs.inc'}

  interface

  uses sysutils, classes, math,
  {$IFDEF JL_ALLOW_VARIANTS}
  variants,
  {$ENDIF}
  jlcommon;

  (* Data cache-size for IO operations *)
  Const
  CNT_JL_IOCACHE_SIZE     = 65536;


  type

  (* Data cache byte array type *)
  TJLIOCache = packed
  Array[1..CNT_JL_IOCACHE_SIZE] of Byte;

  TJLReader         = Class;
  TJLWriter         = Class;
  TJLWriterBuffer   = Class;
  TJLReaderBuffer   = Class;
  TJLReaderStream   = Class;
  TJLWriterStream   = Class;

  TJLBufferCustom   = Class;
  TJLBufferMemory   = Class;
  TJLBufferDisk     = Class;

  (* Exceptions *)
  EJLBuffer         = Class(EJLException);
  EJLReader         = Class(EJLException);
  EJLWriter         = Class(EJLException);
  EJLBufferWrapper  = Class(EJLException);

  TJLDataCapabilities  = set of (mcScale,mcOwned,mcRead,mcWrite);

  TJLCommonObject = Class(TPersistent)
  Protected
    (* Standard persistency *)
    Function  ObjectHasData:Boolean;virtual;
    Procedure DefineProperties(Filer:TFiler);Override;
  Protected
    (* extended persistency *)
    Procedure BeforeReadObject;virtual;
    Procedure AfterReadObject;virtual;
    Procedure BeforeWriteObject;Virtual;
    Procedure AfterWriteObject;Virtual;
    Procedure ReadObject(Const Reader:TJLReader);virtual;
    Procedure WriteObject(Const Writer:TJLWriter);virtual;
  Public
    Procedure LoadFromStream(Stream:TStream);virtual;
    procedure SaveToStream(Stream:TStream);virtual;
    Procedure SaveToFile(Filename:String);virtual;
    Procedure LoadFromFile(Filename:String);virtual;
  End;

  TJLCommonComponent = Class(TComponent)
  Private
    Procedure   ReadComponentBin(Stream:TStream);
    Procedure   WriteComponentBin(Stream:TStream);
  Protected
    (* Standard persistency *)
    Function    ObjectHasData:Boolean;virtual;
    Procedure   DefineProperties(Filer:TFiler);override;

    (* extended persistency *)
    Procedure   BeforeReadObject;virtual;
    Procedure   AfterReadObject;virtual;
    Procedure   BeforeWriteObject;Virtual;
    Procedure   AfterWriteObject;Virtual;
    Procedure   ReadObject(Const Reader:TJLReader);virtual;
    Procedure   WriteObject(Const Writer:TJLWriter);virtual;
  End;

  TJLBufferCustom = Class(TJLCommonComponent)
  private
    FCaps:      TJLDataCapabilities;
    Procedure   SetSize(Const Value:Int64);
    {$IFDEF JL_ALLOW_VARIANTS}
    Function    GetVariant:Variant;
    Procedure   SetVariant(Value:Variant);
    {$ENDIF}
  Protected
    (* extended persistency *)
    Function    ObjectHasData:Boolean;override;
    Procedure   BeforeReadObject;override;
    Procedure   ReadObject(Const Reader:TJLReader);override;
    Procedure   WriteObject(Const Writer:TJLWriter);override;
  Protected
    (* Decendants must override these methods *)
    Function    GetEmpty:Boolean;
    Function    DoGetCapabilities:TJLDataCapabilities;virtual;abstract;
    Function    DoGetDataSize:Int64;virtual;abstract;
    Procedure   DoReleaseData;virtual;abstract;
    Procedure   DoGrowDataBy(Const Value:Integer);virtual;abstract;
    Procedure   DoShrinkDataBy(Const Value:Integer);virtual;abstract;

    Procedure   DoReadData(Start:Int64;var Buffer;
                BufLen:Integer);virtual;abstract;

    Procedure   DoWriteData(Start:Int64;Const Buffer;
                BufLen:Integer);virtual;abstract;

    Procedure   DoFillData(Start:Int64;FillLength:Int64;
                Const Data;DataLen:Integer);virtual;

    Procedure   DoZeroData;virtual;
  Public
    Property    Empty:Boolean read GetEmpty;
    Property    Capabilities:TJLDataCapabilities read FCaps;
    Property    Size:Int64 read DoGetDataSize write SetSize;

    Procedure   Assign(Source:TPersistent);Override;

    Function    Read(Const Offset:Int64;ReadLen:Integer;
                var Data):Integer;overload;

    Function    Write(Const Offset:Int64;WriteLen:Integer;
                Const Data):Integer;overload;

    Function    CopyFrom(Offset:Int64;CopyLen:Integer;
                Const Reader:TJLReader):Integer;

    Function    CopyTo(Offset:Int64;CopyLen:Integer;
                Const Writer:TJLWriter):Integer;

    Procedure   Append(Const Data:TJLBufferCustom);overload;
    Procedure   Append(Const Stream:TStream);overload;
    Procedure   Append(Const Data;Const DataLen:Integer);overload;

    Function    Fill(Const Offset:Int64;Const FillLength:Int64;
                Const Data;Const DataLen:Integer):Int64;
    Procedure   Zero;

    Function    ContentIsAscii(Const ByteLen:Int64=0):Boolean;

    Procedure   Insert(Const Offset:Int64;Const Data;DataLen:Integer);
    Procedure   Remove(Const Offset:Int64;RemoveLen:Integer);

    Function    Find(Const Data;Const DataLen:Integer;
                var Offset:Int64):Boolean;
                
    Function    Push(Const Data;DataLen:Integer):Integer;
    Function    Poll(Var Data;DataLen:Integer):Integer;
    Function    HashCode:Longword;virtual;

    Function    ContentTo(Const Writer:TJLWriter):Int64;
    Function    ContentToData(Const Data:TJLBufferCustom):Int64;
    Function    ContentToStream(Const Stream:TStream):Int64;overload;
    procedure   ContentToFile(Const Filename:AnsiString);
    Function    ContentToBuffer(var Buffer;
                Const BufLen:Integer):Integer;

    Procedure   ContentFrom(Const Reader:TJLReader);
    Procedure   ContentFromStream(Const Stream:TStream);
    Procedure   ContentFromData(Const Data:TJLBufferCustom);
    Procedure   ContentFromFile(Const Filename:AnsiString);
    Procedure   ContentFromBuffer(Const Buffer;
                Const BufLen:Integer);

    {$IFDEF JL_ALLOW_VARIANTS}
    Procedure   AddVariantData(Const inVar:Variant);
    Procedure   AddVariantArray(Const inVar:Variant);
    Function    ContentToVariant:Variant;
    Procedure   ContentFromVariant(Const Value:Variant);
    Property    VariantValue:Variant read GetVariant Write SetVariant;
    {$ENDIF}
    
    Function    toString:AnsiString;virtual;
    Function    toStream:TStream;virtual;

    Function    MakeReader(out outReader:TJLReader):Boolean;
    Function    MakeWriter(out outWriter:TJLWriter):Boolean;
    Function    MakeStreamWrapper(out outStream:TStream):Boolean;

    Procedure   Release;
    Procedure   AfterConstruction;Override;
    Destructor  Destroy;Override;
  End;

  TJLReader = Class
  Private
    FOffset:    Int64;
    Function    DoReadAnsiString:AnsiString;
    Function    DoReadWideString:WideString;
  protected
    Procedure   Advance(Const Value:Integer);
  Public
    Property    Position:Int64 read FOffset;
    Function    ReadNone(Length:Integer):Integer;
    Function    ReadPointer:Pointer;
    Function    ReadByte:Byte;
    Function    ReadBool:Boolean;
    Function    ReadWord:Word;
    Function    ReadSmall:Smallint;
    Function    ReadInt:Integer;
    Function    ReadLong:longword;
    Function    ReadInt64:Int64;
    Function    ReadCurrency:Currency;
    Function    ReadDouble:Double;
    Function    ReadShort:ShortInt;
    Function    ReadSingle:Single;
    Function    ReadDateTime:TDateTime;
    Function    ReadGUID:TGUID;

    Function    ReadToEOL:AnsiString;virtual;
    Function    ReadAsc(Const Terminator:AnsiString
                =CNT_JL_CRLF):AnsiString;overload;
    Function    ReadAsc(Const Length:Integer):AnsiString;overload;
    Function    ReadString:AnsiString;
    Function    ReadWideString:WideString;

    Function    CopyTo(Const Writer:TJLWriter;
                CopyLen:Integer):Integer;Overload;

    Function    CopyTo(Const Stream:TStream;
                Const CopyLen:Integer):Integer;overload;

    Function    CopyTo(Const Binary:TJLBufferCustom;
                Const CopyLen:Integer):Integer;overload;

    Function    ReadStream:TStream;
    Function    ReadData:TJLBufferCustom;
    Function    ContentToStream:TStream;
    Function    ContentToData:TJLBufferCustom;

    {$IFDEF JL_ALLOW_VARIANTS}
    Function    ReadVariant:Variant;
    {$ENDIF}
    Procedure   Reset;Virtual;

    Function    Read(var Data;DataLen:Integer):Integer;virtual;abstract;
  End;

  TJLWriter = Class
  Private
    FOffset:    Int64;
  protected
    Procedure   Advance(Const Value:Integer);
  Public
    Procedure   WritePointer(Const Value:Pointer);
    {$IFDEF JL_ALLOW_VARIANTS}
    Procedure   WriteVariant(Const Value:Variant);
    {$ENDIF}
    Procedure   WriteCRLF(Const Times:Integer=1);
    Procedure   WriteByte(Const Value:Byte);
    Procedure   WriteBool(Const Value:Boolean);
    Procedure   WriteWord(Const Value:Word);
    Procedure   WriteShort(Const Value:Shortint);
    Procedure   WriteSmall(Const Value:SmallInt);
    procedure   WriteInt(Const Value:Integer);
    Procedure   WriteLong(Const Value:Longword);
    procedure   WriteInt64(Const Value:Int64);
    Procedure   WriteCurrency(Const Value:Currency);
    procedure   WriteDouble(Const Value:Double);
    Procedure   WriteSingle(Const Value:Single);
    procedure   WriteDateTime(Const Value:TDateTime);
    Procedure   WriteString(Const Value:AnsiString);
    Procedure   WriteWideString(Const Value:WideString);
    Procedure   WriteAsc(Value:AnsiString;
                Const Delimiter:AnsiString=CNT_JL_CRLF);
    Procedure   WriteStreamContent(Const Value:TStream;
                Const Disposable:Boolean=False);
    Procedure   WriteDataContent(Const Value:TJLBufferCustom;
                Const Disposable:Boolean=False);
    procedure   WriteStream(Const Value:TStream;
                Const Disposable:Boolean);
    Procedure   WriteData(Const Value:TJLBufferCustom;
                Const Disposable:Boolean);
    Procedure   WriteGUID(Const Value:TGUID);
    Procedure   WriteFile(Const Filename:AnsiString);
    Function    CopyFrom(Const Reader:TJLReader;
                DataLen:Int64):Int64;overload;
    Function    CopyFrom(Const Stream:TStream;
                Const DataLen:Int64):Int64;overload;
    Function    CopyFrom(Const Data:TJLBufferCustom;
                Const DataLen:Int64):Int64;overload;
    Function    Write(Const Data;DataLen:Integer):Integer;virtual;abstract;
    Property    Position:Int64 read FOffset;
    Procedure   Reset;Virtual;
  End;

  TJLWriterBuffer = Class(TJLWriter)
  Private
    FData:      TJLBufferCustom;
  Public
    Property    Data:TJLBufferCustom read FData;
    Function    Write(Const Data;DataLen:Integer):Integer;override;
    Constructor Create(Const Target:TJLBufferCustom);reintroduce;
  End;

  TJLReaderBuffer = Class(TJLReader)
  Private
    FData:      TJLBufferCustom;
  Public
    Function    Read(var Data;DataLen:Integer):Integer;override;
    Constructor Create(Const Source:TJLBufferCustom);reintroduce;
  End;

  TJLWriterStream = Class(TJLWriter)
  Private
    FStream:    TStream;
  Public
    Property    DataStream:TStream read FStream;
    Function    Write(Const Data;DataLen:Integer):Integer;override;
    Constructor Create(Const Target:TStream);reintroduce;
  End;

  TJLReaderStream = Class(TJLReader)
  Private
    FStream:    TStream;
  Public
    Function    Read(var Data;DataLen:Integer):Integer;override;
    Constructor Create(Const Source:TStream);reintroduce;
  End;

  TJLBufferMemory = Class(TJLBufferCustom)
  Private
    FDataPTR:   PByte;
    FDataLen:   Integer;
  Public
    Function    BasePTR:PByte;
    Function    AddrOf(Const ByteIndex:Integer):PByte;
  Protected
    Function    DoGetCapabilities:TJLDataCapabilities;override;
    Function    DoGetDataSize:Int64;override;
    Procedure   DoReleaseData;override;

    Procedure   DoReadData(Start:Int64;var Buffer;
                BufLen:Integer);override;

    Procedure   DoWriteData(Start:Int64;Const Buffer;
                BufLen:Integer);override;

    Procedure   DoFillData(Start:Int64;FillLength:Int64;
                Const Data;DataLen:Integer);override;

    Procedure   DoGrowDataBy(Const Value:Integer);override;
    Procedure   DoShrinkDataBy(Const Value:Integer);override;
    Procedure   DoZeroData;override;
  End;

  TJLBufferDisk = Class(TJLBufferCustom)
  Private
    FFilename:  AnsiString;
    FFile:      TFileStream;
  Protected
    Function    DoGetCapabilities:TJLDataCapabilities;override;
    Function    DoGetDataSize:Int64;override;
    Procedure   DoReleaseData;override;

    Procedure   DoReadData(Start:Int64;var Buffer;
                BufLen:Integer);override;

    Procedure   DoWriteData(Start:Int64;Const Buffer;
                BufLen:Integer);override;

    Procedure   DoGrowDataBy(Const Value:Integer);override;
    Procedure   DoShrinkDataBy(Const Value:Integer);override;
  Public
    Property    FileStream:TFileStream read FFile;
    Property    Filename:AnsiString read FFilename;
    Constructor Create(AOwner:TComponent);override;
    Destructor  Destroy;Override;
  End;

  TJLBufferWrapper = Class(TStream)
  Private
    FDataObj:   TJLBufferCustom;
    FOffset:    Int64;
  Protected
    function    GetSize:Int64;override;
    procedure   SetSize(NewSize:Longint);override;
  Public
    Property    DataObject:TJLBufferCustom read FDataObj;
    function    Read(var Buffer; Count:Longint): Longint;override;
    function    Write(const Buffer;Count:Longint): Longint;override;
    function    Seek(const Offset:Int64;Origin:TSeekOrigin): Int64;override;
    Constructor Create(Const Target:TJLBufferCustom);reintroduce;
  End;

  implementation

  Const

  (* Error messages for TJLBufferCustom decendants *)

  ERR_JL_DATA_RELEASENOTSUPPORTED
  = 'Memory capabillities does not support release';

  ERR_JL_DATA_SCALENOTSUPPORTED
  = 'Memory capabillities does not support scaling';

  ERR_JL_DATA_READNOTSUPPORTED
  = 'Memory capabillities does not support read';

  ERR_JL_DATA_SOURCEREADNOTSUPPORTED
  = 'Capabillities of memory source does not support read';

  ERR_JL_DATA_WRITENOTSUPPORTED
  = 'Memory capabillities does not support read';

  ERR_JL_DATA_SCALEFAILED
  = 'Memory scale operation failed: %s';

  ERR_JL_DATA_BYTEINDEXVIOLATION
  = 'Memory byte index violation, expected %d..%d not %d';

  ERR_JL_DATA_INVALIDDATASOURCE
  = 'Invalid datasource for operation';

  ERR_JL_DATA_INVALIDSTREAMSOURCE
  = 'Invalid streamsource for operation';

  ERR_JL_DATA_INVALIDWRITETARGET
  = 'Invalid write target for operation';

  ERR_JL_DATA_INVALIDREADTARGET
  = 'Invalid read target for operation';

  ERR_JL_DATA_INVALIDINDEX
  = 'Index out of range error, expected 0..%d not %d';

  ERR_JL_DATA_EMPTY
  = 'Memory resource contains no data error';

  ERR_JL_DATA_INVALIDAPPENDSOURCE
  ='Invalid append source, container is NIL or out of scope error';

  ERR_JL_DATA_INSUFFICIENT
  = 'Insufficient memory to represent datatype';

  ERR_JL_DATA_FAILEDMAKEWRITER
  = 'Failed to create writer object for target error';

  ERR_JL_DATA_FAILEDMAKEREADER
  = 'Failed to create reader object from source error';

  (* Error messages for TJLReader decendants *)
  ERR_JL_READER_INVALIDSOURCE      = 'Invalid source medium error';
  ERR_JL_READER_FAILEDREAD         = 'Read failed on source medium';
  ERR_JL_READER_INVALIDDATASOURCE  = 'Invalid data source for read operation';
  ERR_JL_READER_INVALIDOBJECT      = 'Invalid object for read operation';
  ERR_JL_READER_INVALIDHEADER      = 'Invalid header, expected %d not %d';

  (* Error messages for TJLWriter decendants *)
  ERR_JL_WRITER_INVALIDTARGET       = 'Invalid target medium error';
  ERR_JL_WRITER_FAILEDWRITE         = 'Write failed on target medium';
  ERR_JL_WRITER_INVALIDDATASOURCE   = 'Invalid data source for write operation';
  ERR_JL_WRITER_INVALIDOBJECT       = 'Invalid object for write operation';

  (* Errors for TJLDataStream *)
  ERR_JL_DATASTREAM_INVALIDTARGET   = 'Invalid target error, dataobject is NIL';

  //##########################################################################
  // TJLCommonObject
  //##########################################################################

  Procedure TJLCommonObject.LoadFromStream(Stream:TStream);
  var
    FReader:  TJLReaderStream;
  Begin
    BeforeReadObject;
    FReader:=TJLReaderStream.Create(Stream);
    try
      ReadObject(FReader);
    finally
      FReader.free;
      AfterReadObject;
    end;
  End;

  procedure TJLCommonObject.SaveToStream(Stream:TStream);
  var
    FWriter:  TJLWriterStream;
  Begin
    BeforeWriteObject;
    FWriter:=TJLWriterStream.Create(Stream);
    try
      WriteObject(FWriter);
    finally
      FWriter.free;
      AfterWriteObject;
    end;
  End;

  Procedure TJLCommonObject.SaveToFile(Filename:String);
  var
    FFile:  TFileStream;
  Begin
    FFile:=TFileStream.Create(Filename,fmCreate);
    try
      SaveToStream(FFile);
    finally
      FFile.free;
    end;
  End;

  Procedure TJLCommonObject.LoadFromFile(Filename:String);
  var
    FFile:  TFileStream;
  Begin
    FFile:=TFileStream.Create(Filename,fmOpenRead);
    try
      LoadFromStream(FFile);
    finally
      FFile.free;
    end;
  End;

  Function TJLCommonObject.ObjectHasData:Boolean;
  Begin
    result:=False;
  End;

  Procedure TJLCommonObject.DefineProperties(Filer:TFiler);
  Begin
    inherited DefineProperties(Filer);
    Filer.DefineBinaryProperty('bin_data',LoadFromStream,
    SaveToStream,ObjectHasData);
  End;

  Procedure TJLCommonObject.BeforeReadObject;
  Begin
  End;

  Procedure TJLCommonObject.AfterReadObject;
  Begin
  End;

  Procedure TJLCommonObject.BeforeWriteObject;
  Begin
  End;

  Procedure TJLCommonObject.AfterWriteObject;
  Begin
  End;

  Procedure TJLCommonObject.ReadObject(Const Reader:TJLReader);
  { var
    FReader: TReader;
    FStream:  TStream;
    PropName, PropValue: string; }
  begin
    { FStream:=Reader.ReadStream;
    try
      FReader:=TReader.Create(FStream, $FFF) ;
      try
        FStream.Position := 0;
        FReader.ReadListBegin;
        while not FReader.EndOfList do
        begin
          PropName := Reader.ReadString;
          PropValue := Reader.ReadString;
          SetPropValue(Self, PropName, PropValue) ;
        end;
      finally
        FreeAndNil(FReader);
      end;
    finally
      FStream.free;
    end;    }
  end;

  Procedure TJLCommonObject.WriteObject(Const Writer:TJLWriter);
  { var
    PropName,
    PropValue:  string;
    cnt:        Integer;
    lPropInfo:  PPropInfo;
    lPropCount: Integer;
    lPropList:  PPropList;
    lPropType:  PPTypeInfo;
    FTemp:      TMemoryStream;
    FWriter:    TWriter; }
  Begin
    { FTemp:=TMemoryStream.Create;
    try
      FWriter:=TWriter.Create(FTemp,$FFF);
      try
        lPropCount := GetPropList(PTypeInfo(ClassInfo), lPropList) ;
        FTemp.Size := 0;
        FWriter.WriteListBegin;
        for cnt:=0 to lPropCount-1 do
        begin
          lPropInfo := lPropList^[cnt];
          lPropType := lPropInfo^.PropType;
          if lPropType^.Kind = tkMethod then
          Continue;

          PropName := lPropInfo.Name;
          PropValue := VarToStr(GetPropValue(self,PropName));
          Writer.WriteString(PropName);
          Writer.WriteString(PropValue);
        end;
      finally
        FWriter.FlushBuffer;
        FWriter.free;
      end;
    finally
      FTemp.Position:=0;
      Writer.WriteStreamContent(FTemp);
      FTemp.free;
    end;      }
  end;


  //##########################################################################
  // TJLBufferWrapper
  //##########################################################################

  Constructor TJLBufferWrapper.Create(Const Target:TJLBufferCustom);
  Begin
    inherited Create;
    If Target<>NIl then
    FDataObj:=Target else
    Raise EJLBufferWrapper.Create(ERR_JL_DATASTREAM_INVALIDTARGET);
  end;

  function TJLBufferWrapper.GetSize:Int64;
  Begin
    result:=FDataObj.Size;
  end;

  procedure TJLBufferWrapper.SetSize(NewSize:Longint);
  Begin
    FDataObj.Size:=NewSize;
  end;

  function TJLBufferWrapper.Read(var Buffer;Count:Longint):Longint;
  Begin
    result:=FDataObj.Read(FOffset,Count,Buffer);
    inc(FOffset,Result);
  end;

  function TJLBufferWrapper.Write(const Buffer;Count:Longint): Longint;
  Begin
    If FOffset=FDataObj.Size then
    Begin
      FDataObj.Append(Buffer,Count);
      Result:=Count;
    end else
    result:=FDataObj.Write(FOffset,Count,Buffer);
    inc(FOffset,Result);
  end;

  function TJLBufferWrapper.Seek(const Offset:Int64;Origin:TSeekOrigin):Int64;
  Begin
    Case Origin of
    soBeginning:
      Begin
        if Offset>0 then
        FOffset:=Math.EnsureRange(Offset,0,FDataObj.Size);
      end;
    soCurrent:
      Begin
        FOffset:=math.EnsureRange(FOffset + Offset,0,FDataObj.Size);
      end;
    soEnd:
      Begin
        If Offset>0 then
        FOffset:=FDataObj.Size-1 else
        FOffset:=math.EnsureRange(FOffset-(abs(Offset)),0,FDataObj.Size);
      end;
    end;
    result:=FOffset;
  end;

  //##########################################################################
  // TJLBufferMemory
  //##########################################################################

  Function TJLBufferMemory.BasePTR:PByte;
  Begin
    If FDataPTR<>NIL then
    Result:=FDataPTR else
    Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
  end;

  Function TJLBufferMemory.AddrOf(Const ByteIndex:Integer):PByte;
  Begin
    If (ByteIndex>=0) and (ByteIndex<FDataLen) then
    Result:=PTR(Integer(FDataPTR) + ByteIndex) else
    Raise EJLBuffer.CreateFmt
    (ERR_JL_DATA_BYTEINDEXVIOLATION,[0,FDataLEN,ByteIndex]);
  end;

  Function TJLBufferMemory.DoGetCapabilities:TJLDataCapabilities;
  Begin
    Result:=[mcScale,mcOwned,mcRead,mcWrite];
  end;

  Function TJLBufferMemory.DoGetDataSize:Int64;
  Begin
    If FDataPTR<>NIL then
    Result:=FDataLen else
    result:=0;
  end;

  Procedure TJLBufferMemory.DoReleaseData;
  Begin
    If FDataPTR<>NIL then
    Begin
      Freemem(FDataPTR);
      FDataPTR:=NIL;
      FDataLEN:=0;
    end;
  end;

  Procedure TJLBufferMemory.DoReadData(Start:Int64;
            var Buffer;BufLen:Integer);
  var
    FSource:    PByte;
    FTarget:    PByte;
  Begin
    (* Calculate PTR's *)
    FSource:=PTR(Integer(FDataPTR) + Start);
    FTarget:=Addr(Buffer);

    If BufLen<17 then
    Begin
      Case BufLen of
      1:  PByte(FTarget)^:=FSource^;
      2:  PWord(FTarget)^:=PWord(FSource)^;
      3:  PJLTriple(FTarget)^:=PJLTriple(FSource)^;
      4:  PLongword(FTarget)^:=PLongword(FSource)^;
      5:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PByte(FTarget)^:=FSource^;
          end;
      6:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
          end;
      7:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
            inc(FSource,2);
            inc(FTarget,2);
            PByte(FTarget)^:=FSource^;
          end;
      8:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
          end;
      9:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PByte(FTarget)^:=FSource^;
          end;
      10: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
          end;
      11: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
            inc(FSource,2);
            inc(FTarget,2);
            PByte(FTarget)^:=FSource^;
          end;
      12: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
          end;
      13: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PByte(FTarget)^:=FSource^;
          end;
      14: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);
            inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
          end;
      15: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
            inc(FSource,2);inc(FTarget,2);
            PByte(FTarget)^:=FSource^;
          end;
      16: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
          end;
      end;
    end else
    move(FSource^,FTarget^,BufLen);
  end;

  Procedure TJLBufferMemory.DoWriteData(Start:Int64;
            Const Buffer;BufLen:Integer);
  var
    FSource:    PByte;
    FTarget:    PByte;
  Begin
    (* Calculate PTR's *)
    FSource:=Addr(Buffer);
    FTarget:=PTR(Integer(FDataPTR) + Start);

    If BufLen<17 then
    Begin
      Case BufLen of
      1:  PByte(FTarget)^:=PByte(FSource)^;
      2:  PWord(FTarget)^:=PWord(FSource)^;
      3:  PJLTriple(FTarget)^:=PJLTriple(FSource)^;
      4:  PLongword(FTarget)^:=PLongword(FSource)^;
      5:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PByte(FTarget)^:=FSource^;
          end;
      6:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
          end;
      7:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
            inc(FSource,2);inc(FTarget,2);
            PByte(FTarget)^:=FSource^;
          end;
      8:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
          end;
      9:  Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PByte(FTarget)^:=FSource^;
          end;
      10: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
          end;
      11: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
            inc(FSource,2);inc(FTarget,2);
            PByte(FTarget)^:=FSource^;
          end;
      12: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
          end;
      13: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PByte(FTarget)^:=FSource^;
          end;
      14: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
          end;
      15: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PWord(FTarget)^:=PWord(FSource)^;
            inc(FSource,2);inc(FTarget,2);
            PByte(FTarget)^:=FSource^;
          end;
      16: Begin
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
            inc(FSource,4);inc(FTarget,4);
            PLongword(FTarget)^:=PLongword(FSource)^;
          end;
      end;
    end else
    move(FSource^,FTarget^,BufLen);
  end;

  Procedure TJLBufferMemory.DoGrowDataBy(Const Value:Integer);
  var
    FNewSize: Integer;
  Begin
    If Value>0 then
    Begin
      If FDataPTR<>NIL then
      Begin
        FNewSize:=FDataLEN + Value;
        try
          ReAllocMem(FDataPTR,FNewSize);
          FDataLen:=FNewSize;
        except
          on e: exception do
          Raise EJLBuffer.CreateFmt('ReAllocation failed: %s (%d Mb)',
          [e.message, FNewSize div CNT_JL_MEGABYTE]);
        end;
      end else
      Begin
        FDataPTR:=AllocMem(Value);
        FDataLen:=Value;
      end;
    end;
  end;

  Procedure TJLBufferMemory.DoShrinkDataBy(Const Value:Integer);
  var
    FNewSize: Integer;
  Begin
    If Value>0 then
    Begin
      If FDataPTR<>NIL then
      Begin
        FNewSize:=math.EnsureRange(FDataLEN - Value,0,FDataLen);
        If FNewSize>0 then
        Begin
          try
            ReAllocMem(FDataPTR,FNewSize);
            FDataLen:=FNewSize;
          except
            on e: exception do
            Raise EJLBuffer.CreateFmt('ReAllocation failed: %s (%d Mb)',
            [e.message, FNewSize div CNT_JL_MEGABYTE]);
            end;
        end else
        DoReleaseData;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
    end;
  end;

  Procedure TJLBufferMemory.DoZeroData;
  Begin
    If FDataPTR<>NIL then
    FillChar(FDataPTR^,FDataLen,0) else
    Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
  end;

  Procedure TJLBufferMemory.DoFillData(Start:Int64;
            FillLength:Int64;Const Data;DataLen:Integer);
  var
    FSource:    PByte;
    FTarget:    PByte;
    FLongs:     Integer;
    FSingles:   Integer;
  Begin
    (* Initialize pointers *)
    FSource:=Addr(Data);
    FTarget:=PTR(Integer(FDataPTR) + Start);

    (* EVEN copy source into destination *)
    FLongs:=FillLength div DataLen;
    While FLongs>0 do
    Begin
      Move(FSource^,FTarget^,DataLen);
      inc(FTarget,DataLen);
      dec(FLongs);
    end;

    (* ODD copy of source into destination *)
    FSingles:=FillLength mod DataLen;
    If FSingles>0 then
    Begin
      Case FSingles of
      1: FTarget^:=FSource^;
      2: PWord(FTarget)^:=PWord(FSource)^;
      3: PJLTriple(FTarget)^:=PJLTriple(FSource)^;
      4: PLongword(FTarget)^:=PLongword(FSource)^;
      else
        Move(FSource^,FTarget^,FSingles);
      end;
    end;
  end;

  //##########################################################################
  // TJLWriterStream
  //##########################################################################

  Constructor TJLWriterStream.Create(Const Target:TStream);
  Begin
    inherited Create;
    if Target<>NIL then
    FStream:=target else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDTARGET);
  end;

  Function TJLWriterStream.Write(Const Data;
           DataLen:Integer):Integer;
  Begin
    If DataLen>0 then
    Begin
      Result:=FStream.Write(Data,DataLen);
      Advance(Result);
    end else
    result:=0;
  end;
  
  //##########################################################################
  // TJLReaderStream
  //##########################################################################

  Constructor TJLReaderStream.Create(Const Source:TStream);
  Begin
    inherited Create;
    if source<>NIL then
    FStream:=Source else
    Raise EJLReader.Create(ERR_JL_READER_INVALIDSOURCE);
  end;

  Function TJLReaderStream.Read(var Data;DataLen:Integer):Integer;
  Begin
    If DataLen>0 then
    Begin
      Result:=FStream.Read(Data,DataLen);
      Advance(Result);
    end else
    result:=0;
  end;

  //##########################################################################
  // TSRLDataWriter
  //##########################################################################

  Constructor TJLWriterBuffer.Create(Const Target:TJLBufferCustom);
  Begin
    inherited Create;
    If Target<>NIl then
    FData:=Target else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDTARGET);
  end;

  Function TJLWriterBuffer.Write(Const Data;DataLen:Integer):Integer;
  var
    FTotal: Int64;
  Begin
    If DataLen>0 then
    Begin
      FTotal:=FData.Size;
      If (FTotal>0) and (Position<FTotal) then
      FData.Write(Position,DataLen,Data) else
      FData.Append(Data,DataLen);

      Advance(DataLen);
      Result:=DataLen;
    end else
    result:=0;
  end;

  //##########################################################################
  // TJLReaderBuffer
  //##########################################################################

  Constructor TJLReaderBuffer.Create(Const Source:TJLBufferCustom);
  Begin
    inherited Create;
    If Source=NIl then
    Raise EJLReader.Create(ERR_JL_READER_INVALIDSOURCE) else
    FData:=Source;
  end;

  Function TJLReaderBuffer.Read(var Data;DataLen:Integer):Integer;
  Begin
    If DataLen>0 then
    Begin
      Result:=FData.Read(Position,DataLen,data);
      Advance(Result);
    end else
    result:=0;
  end;

  //##########################################################################
  // TJLBufferDisk
  //##########################################################################

  Constructor TJLBufferDisk.Create;
  Begin
    inherited;
    FFileName:=JL_GetTempFileName;
    if not (csDesigning in ComponentState) then
    FFile:=TFileStream.Create(FFilename,fmCreate);
  end;

  Destructor TJLBufferDisk.Destroy;
  Begin
    if not (csDesigning in ComponentState) then
    FreeAndNil(FFile);
    DeleteFile(FFileName);
    inherited;
  end;

  Function TJLBufferDisk.DoGetCapabilities:TJLDataCapabilities;
  Begin
    Result:=[mcScale,mcOwned,mcRead,mcWrite];
  end;

  Function TJLBufferDisk.DoGetDataSize:Int64;
  Begin
    if not (csDesigning in ComponentState) then
    Result:=FFile.Size else
    result:=0;
  end;

  Procedure TJLBufferDisk.DoReleaseData;
  Begin
    if not (csDesigning in ComponentState)
    and (FFile<>NIL) and (FFile.Size>0) then
    FFile.Size:=0;
  end;

  Procedure TJLBufferDisk.DoReadData(Start:Int64;
            var Buffer;BufLen:Integer);
  Begin
    if not (csDesigning in ComponentState) then
    Begin
      FFile.Position:=Start;
      FFile.Read(Buffer,BufLen);
    end;
  end;

  Procedure TJLBufferDisk.DoWriteData(Start:Int64;
            Const Buffer;BufLen:Integer);
  Begin
    if not (csDesigning in ComponentState) then
    Begin
      FFile.Position:=Start;
      FFile.Write(Buffer,BufLen);
    end;
  end;

  Procedure TJLBufferDisk.DoGrowDataBy(Const Value:Integer);
  Begin
    if not (csDesigning in ComponentState) then
    FFile.Size:=FFile.Size + Value;
  end;

  Procedure TJLBufferDisk.DoShrinkDataBy(Const Value:Integer);
  var
    FNewSize: Int64;
  Begin
    if not (csDesigning in ComponentState) then
    Begin
      FNewSize:=FFile.Size - Value;
      If FNewSize>0 then
      FFile.Size:=FNewSize else
      DoReleaseData;
    end;
  end;

  //##########################################################################
  // TJLReader
  //##########################################################################

  Procedure TJLReader.Reset;
  Begin
    FOffset:=0;
  end;

  Procedure TJLReader.Advance(Const Value:Integer);
  Begin
    If Value>0 then
    FOffset:=FOffset + Value;
  end;

  Function TJLReader.ReadByte:Byte;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadBool:Boolean;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadWord:Word;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadSmall:SmallInt;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadPointer:Pointer;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;
  
  Function TJLReader.ReadInt:Integer;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadLong:longword;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadInt64:Int64;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadCurrency:Currency;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadGUID:TGUID;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadShort:Shortint;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadSingle:Single;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadDouble:Double;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function TJLReader.ReadDateTime:TDateTime;
  Begin
    If Read(Result,SizeOf(Result))<SizeOf(Result) then
    Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
  end;

  Function  TJLReader.CopyTo(Const Writer:TJLWriter;
            CopyLen:Integer):Integer;
  var
    FRead:        Integer;
    FBytesToRead: Integer;
    FWritten:     Integer;
    FCache:       TJLIOCache;
  Begin
    If Writer<>NIL then
    Begin
      Result:=0;
      While CopyLen>0 do
      Begin
        FBytesToRead:=Math.EnsureRange(SizeOf(FCache),0,CopyLen);
        FRead:=Read(FCache,FBytesToRead);
        If FRead>0 then
        Begin
          FWritten:=Writer.Write(FCache,FRead);
          dec(CopyLen,FWritten);
          inc(Result,FWritten);
        end else
        Break;
      end;
    end else
    Raise EJLReader.Create(ERR_JL_READER_INVALIDOBJECT);
  end;

  Function TJLReader.CopyTo(Const Binary:TJLBufferCustom;
           Const CopyLen:Integer):Integer;
  var
    FWriter: TJLWriter;
  Begin
    If Binary<>NIL then
    Begin
      FWriter:=TJLWriterBuffer.Create(Binary);
      try
        Result:=CopyTo(FWriter,CopyLen);
      finally
        FWriter.free;
      end;
    end else
    Raise EJLReader.Create(ERR_JL_READER_INVALIDOBJECT);
  end;

  Function  TJLReader.CopyTo(Const Stream:TStream;
            Const CopyLen:Integer):Integer;
  var
    FWriter: TJLWriterStream;
  Begin
    If Stream<>NIL then
    Begin
      FWriter:=TJLWriterStream.Create(Stream);
      try
        Result:=CopyTo(FWriter,CopyLen);
      finally
        FWriter.free;
      end;
    end else
    Raise EJLReader.Create(ERR_JL_READER_INVALIDOBJECT);
  end;

  Function TJLReader.ContentToStream:TStream;
  var
    FRead:  Integer;
    FCache: TJLIOCache;
  Begin
    Result:=TMemoryStream.Create;
    try
      While True do
      Begin
        FRead:=Read(FCache,SizeOf(FCache));
        If FRead>0 then
        Result.WriteBuffer(FCache,FRead) else
        Break;
      end;
    except
      on e: exception do
      Begin
        FreeAndNil(Result);
        Raise EJLReader.Create(e.message);
      end;
    end;
  end;

  Function TJLReader.ReadNone(Length:Integer):Integer;
  var
    FToRead:  Integer;
    FRead:    Integer;
    FCache:   TJLIOCache;
  Begin
    result:=0;
    If Length>0 then
    Begin
      try
        While Length>0 do
        Begin
          FToRead:=Math.EnsureRange(SizeOf(FCache),0,Length);
          FRead:=Read(FCache,FToRead);
          If FRead>0 then
          Begin
            Length:=Length - FRead;
            Result:=Result + FRead;
          end else
          Break;
        end;
      except
        on e: exception do
        Raise EJLReader.Create(e.message);
      end;
    end;
  end;

  Function TJLReader.ContentToData:TJLBufferCustom;
  var
    FRead:  Integer;
    FCache: TJLIOCache;
  Begin
    Result:=TJLBufferMemory.Create(NIL);
    try
      While True do
      Begin
        FRead:=Read(FCache,SizeOf(FCache));
        If FRead>0 then
        Result.Append(FCache,FRead) else
        Break;
      end;
    except
      on e: exception do
      Begin
        FreeAndNil(Result);
        Raise EJLReader.Create(e.message);
      end;
    end;
  end;

  Function TJLReader.ReadAsc(Const Length:Integer):AnsiString;
  var
    FRead: Integer;
  Begin
    If Length>0 then
    Begin
      SetLength(Result,Length);
      FRead:=Read(Result[1],Length);
      If FRead<Length then
      SetLength(Result,FRead);
    end else
    Result:='';
  end;

  Function  TJLReader.ReadAsc(Const Terminator:AnsiString
            =CNT_JL_CRLF):AnsiString;
  var
    FCurrent: CHAR;
    FLen:     Integer;
  Begin
    result:='';
    FLen:=Length(Terminator);
    If FLen>0 then
    Begin
      While Read(FCurrent,1)=1 do
      Begin
        Result:=Result + FCurrent;
        If JL_RightStr(Result,FLen)=Terminator then
        Begin
          SetLength(Result,Length(Result) - FLen);
          Break;
        end;
      end;
    end else
    Begin
      While Read(FCurrent,1)=1 do
      Result:=Result + FCurrent;
    end;
  end;

  Function TJLReader.ReadToEOL:AnsiString;
  Begin
    Result:=ReadAsc;
  end;

  Function TJLReader.DoReadAnsiString:AnsiString;
  var
    FBytes: Integer;
    FLen:   Integer;
  Begin
    (* normal ansi string *)
    FBytes:=ReadInt;
    If FBytes>0 then
    Begin
      SetLength(Result,FBytes);
      FLen:=Read(Result[1],FBytes);
      If FLen<FBytes then
      Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
    end else
    Result:='';
  end;

  Function TJLReader.DoReadWideString:WideString;
  var
    FRead:  Integer;
    FBytes: Integer;
    FLen:   Integer;
  Begin
    FLen:=ReadWord;
    If FLen>0 then
    Begin
      FBytes:=FLen * 2;
      SetLength(Result,FLen);
      FRead:=Read(Result[1],FBytes);
      If FRead<FBytes then
      Raise EJLReader.Create(ERR_JL_READER_FAILEDREAD);
    end else
    result:='';
  end;

  Function TJLReader.ReadString:AnsiString;
  var
    FHead: Word;
  Begin
    (* Get String identifier *)
    FHead:=ReadWord;

    (* Support both ansi and widestring *)
    Case FHead of
    CNT_JL_ASTRING_HEADER: Result:=DoReadAnsiString;
    CNT_JL_WSTRING_HEADER: Result:=DoReadWideString;
    else
      Raise EJLReader.CreateFmt
      (ERR_JL_READER_INVALIDHEADER,[CNT_JL_ASTRING_HEADER,FHead]);
    End;
  end;

  Function TJLReader.ReadWideString:WideString;
  var
    FHead: Word;
  Begin
    (* Get String identifier *)
    FHead:=ReadWord;

    (* Support both ansi and widestring *)
    Case FHead of
    CNT_JL_ASTRING_HEADER: Result:=DoReadAnsiString;
    CNT_JL_WSTRING_HEADER: Result:=DoReadWideString;
    else
      Raise EJLReader.CreateFmt
      (ERR_JL_READER_INVALIDHEADER,[CNT_JL_ASTRING_HEADER,FHead]);
    End;
  end;

  {$IFDEF JL_ALLOW_VARIANTS}
  Function TJLReader.ReadVariant:Variant;
  var
    FTemp:    Word;
    FKind:    TVarType;
    FCount,x: Integer;
    FIsArray: Boolean;

    Function ReadVariantData:Variant;
    var
      FTyp: TVarType;
    Begin
      FTyp:=ReadWord;
      Case FTyp of
      varError:     Result:=VarAsError(ReadLong);
      varVariant:   Result:=ReadVariant;
      varByte:      Result:=ReadByte;
      varBoolean:   Result:=ReadBool;
      varShortInt:  Result:=ReadShort;
      varWord:      Result:=ReadWord;
      varSmallint:  Result:=ReadSmall;
      varInteger:   Result:=ReadInt;
      varLongWord:  Result:=ReadLong;
      varInt64:     Result:=ReadInt64;
      varSingle:    Result:=ReadSingle;
      varDouble:    Result:=ReadDouble;
      varCurrency:  Result:=ReadCurrency;
      varDate:      Result:=ReadDateTime;
      varString:    Result:=ReadString;
      varOleStr:    Result:=ReadWideString;
      end;
    end;

  Begin
    FTemp:=ReadWord;
    If FTemp=CNT_JL_VARIANT_HEADER then
    Begin
      (* read datatype *)
      FKind:=TVarType(ReadWord);

      If not (FKind in [varEmpty,varNull]) then
      Begin
        (* read array declaration *)
        FIsArray:=ReadBool;

        If FIsArray then
        Begin
          FCount:=ReadInt;
          Result:=VarArrayCreate([0,FCount-1],FKind);
          for x:=1 to FCount do
          VarArrayPut(Result,ReadVariantData,[0,x-1]);
        end else
        Result:=ReadVariantData;
      end else
      result:=NULL;

    end else
    Raise EJLReader.CreateFmt
    (ERR_JL_READER_INVALIDHEADER,
    [CNT_JL_VARIANT_HEADER,FTemp]);
  end;
  {$ENDIF}

  Function TJLReader.ReadData:TJLBufferCustom;
  var
    FTotal:   Int64;
    FToRead:  Integer;
    FRead:    Integer;
    FCache:   TJLIOCache;
  Begin
    Result:=TJLBufferMemory.Create(NIL);
    try
      FTotal:=ReadInt64;
      While FTotal>0 do
      Begin
        FToRead:=math.EnsureRange(SizeOf(FCache),0,FTotal);
        FRead:=Read(FCache,FToRead);
        If FRead>0 then
        Begin
          Result.Append(FCache,FRead);
          FTotal:=FTotal - FRead;
        end else
        Break;
      end;
    except
      on e: exception do
      Begin
        FreeAndNil(Result);
        raise EJLReader.Create(e.message);
      end;
    end;
  end;

  Function TJLReader.ReadStream:TStream;
  var
    FTotal:   Int64;
    FToRead:  Integer;
    FRead:    Integer;
    FCache:   TJLIOCache;
  Begin
    Result:=TMemoryStream.Create;
    try
      FTotal:=ReadInt64;
      While FTotal>0 do
      Begin
        FToRead:=math.EnsureRange(SizeOf(FCache),0,FTotal);
        FRead:=Read(FCache,FToRead);
        If FRead>0 then
        Begin
          Result.WriteBuffer(FCache,FRead);
          FTotal:=FTotal - FRead;
        end else
        Break;
      end;
      Result.Position:=0;
    except
      on e: exception do
      Begin
        FreeAndNil(Result);
        raise EJLReader.Create(e.message);
      end;
    end;
  end;

  //##########################################################################
  // TJLWriter
  //##########################################################################

  Procedure TJLWriter.Reset;
  Begin
    FOffset:=0;
  end;

  Procedure TJLWriter.Advance(Const Value:Integer);
  Begin
    If Value>0 then
    FOffset:=FOffset + Value;
  end;

  {$IFDEF JL_ALLOW_VARIANTS}
  Procedure TJLWriter.WriteVariant(Const Value:Variant);
  var
    FKind:    TVarType;
    FCount,x: Integer;
    FIsArray: Boolean;
    //FData:    PByte;

    Procedure WriteVariantData(Const VarValue:Variant);
    var
      FAddr:  PVarData;
    Begin
      FAddr:=FindVarData(VarValue);
      If FAddr<>NIL then
      Begin
        (* write datatype *)
        WriteWord(FAddr^.VType);

        (* write variant content *)
        Case FAddr^.VType of
        varVariant:   WriteVariantData(VarValue);
        varError:     WriteLong(TVarData(varValue).VError);
        varByte:      WriteByte(FAddr^.VByte);
        varBoolean:   WriteBool(FAddr^.VBoolean);
        varShortInt:  WriteShort(FAddr^.VShortInt);
        varWord:      WriteWord(FAddr^.VWord);
        varSmallint:  WriteSmall(FAddr^.VSmallInt);
        varInteger:   WriteInt(FAddr^.VInteger);
        varLongWord:  WriteLong(FAddr^.VLongWord);
        varInt64:     WriteInt64(FAddr^.VInt64);
        varSingle:    WriteSingle(FAddr^.VSingle);
        varDouble:    WriteDouble(FAddr^.VDouble);
        varCurrency:  WriteCurrency(FAddr^.VCurrency);
        varDate:      WriteDateTime(FAddr^.VDate);
        varString:    WriteString(AnsiString(FAddr^.VString));
        varOleStr:    WriteWideString(WideString(FAddr^.VString));
        end;
      end;
    end;
  Begin
    (* Extract datatype & exclude array info *)
    FKind:=VarType(Value) and varTypeMask;

    (* Write variant header *)
    WriteWord(CNT_JL_VARIANT_HEADER);

    (* write datatype *)
    WriteWord(FKind);

    (* Content is array? *)
    FIsArray:=VarIsArray(Value);

    (* write array declaration *)
    If not (FKind in [varEmpty,varNull]) then
    Begin
      (* write TRUE if variant is an array *)
      WriteBool(FIsArray);

      (* write each item if array, or just the single one.. *)
      If FIsArray then
      Begin
        (* write # of items *)
        FCount:=VarArrayHighBound(Value,1) - VarArrayLowBound(Value,1) + 1;
        WriteInt(FCount);

        (* write each element in array *)
        for x:=VarArrayLowBound(Value,1) to VarArrayHighBound(Value,1) do
        WriteVariantData(VarArrayGet(Value,[1,x-1]));

      end else
      WriteVariantData(Value);
    end;
  end;
  {$ENDIF}

  Procedure TJLWriter.WriteByte(Const Value:Byte);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteShort(Const Value:ShortInt);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;
  
  Procedure TJLWriter.WriteBool(Const Value:Boolean);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteWord(Const Value:Word);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteSmall(Const Value:SmallInt);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WritePointer(Const Value:Pointer);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;
  
  procedure TJLWriter.WriteInt(Const Value:Integer);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteLong(Const Value:Longword);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteGUID(Const Value:TGUID);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  procedure TJLWriter.WriteInt64(Const Value:Int64);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteCurrency(Const Value:Currency);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteSingle(Const Value:Single);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  procedure TJLWriter.WriteDouble(Const Value:Double);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  procedure TJLWriter.WriteDateTime(Const Value:TDateTime);
  Begin
    If Write(Value,SizeOf(Value))<SizeOf(Value) then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
  end;

  Procedure TJLWriter.WriteFile(Const Filename:AnsiString);
  var
    FFile: TFileStream;
  Begin
    FFile:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
    try
      WriteStreamContent(FFile,False);
    finally
      FFile.free;
    end;
  end;

  Procedure TJLWriter.WriteStreamContent(Const Value:TStream;
            Const Disposable:Boolean=False);
  var
    FTotal:     Int64;
    FRead:      Integer;
    FWritten:   Integer;
    FCache:     TJLIOCache;
  Begin
    If Value<>NIl then
    Begin
      try
        FTotal:=Value.Size;
        If FTotal>0 then
        Begin
          Value.Position:=0;
          Repeat
            FRead:=Value.Read(FCache,SizeOf(FCache));
            If FRead>0 then
            Begin
              FWritten:=Write(FCache,FRead);
              FTotal:=FTotal - FWritten;
            end;
          Until (FRead<1) or (FTotal<1);
        end;
      finally
        If Disposable then
        Value.free;
      end;
    end else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDDATASOURCE);
  end;

  Procedure TJLWriter.WriteDataContent(Const Value:TJLBufferCustom;
            Const Disposable:Boolean=False);
  var
    FBytes:   Integer;
    FRead:    Integer;
    FWritten: Integer;
    FOffset:  Integer;
    FCache:   TJLIOCache;
  Begin
    If (Value<>NIl) then
    Begin

      try
        FOffset:=0;
        FBytes:=Value.Size;

        Repeat
          FRead:=Value.Read(FOffset,SizeOf(FCache),FCache);
          If FRead>0 then
          Begin
            FWritten:=Write(FCache,FRead);
            FBytes:=FBytes-FWritten;
            FOffset:=FOffset + FWritten;
          end;
        Until (FRead<1) or (FBytes<1);

      finally
        If Disposable then
        Value.free;
      end;

    end else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDDATASOURCE);
  end;

  procedure TJLWriter.WriteData(Const Value:TJLBufferCustom;
            Const Disposable:Boolean);
  var
    FTemp:  Int64;
  Begin
    If Value<>NIl then
    Begin
      try
        FTemp:=Value.Size;
        WriteInt64(FTemp);
        If FTemp>0 then
        WriteDataContent(Value);
      finally
        If Disposable then
        Value.free;
      end;
    end else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDDATASOURCE);
  end;

  procedure TJLWriter.WriteStream(Const Value:TStream;
            Const Disposable:Boolean);
  Begin
    If Value<>NIl then
    Begin
      try
        WriteInt64(Value.Size);
        If Value.Size>0 then
        WriteStreamContent(Value);
      finally
        If Disposable then
        Value.free;
      end;
    end else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDDATASOURCE);
  end;

  Function TJLWriter.CopyFrom(Const Reader:TJLReader;
            DataLen:Int64):Int64;
  var
    FRead:        Integer;
    FBytesToRead: Integer;
    FCache:       TJLIOCache;
  Begin
    If Reader<>NIL then
    Begin
      result:=0;
      While DataLen>0 do
      Begin
        {FBytesToRead:=Sizeof(FCache);
        If FBytesToRead>DataLen then
        FBytesToRead:=DataLen; }
        FBytesToRead:=Math.EnsureRange(SizeOf(FCache),0,DataLen);

        FRead:=Reader.Read(FCache,FBytesToRead);
        If FRead>0 then
        Begin
          Write(FCache,FRead);
          DataLen:=DataLen - FRead;
          Result:=Result + FRead;
        end else
        Break;
      end;
    end else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDDATASOURCE);
  end;

  Function TJLWriter.CopyFrom(Const Stream:TStream;
           Const DataLen:Int64):Int64;
  var
    FReader: TJLReaderStream;
  Begin
    If Stream<>NIL then
    Begin
      FReader:=TJLReaderStream.Create(Stream);
      try
        Result:=CopyFrom(FReader,DataLen);
      finally
        FReader.free;
      end;
    end else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDDATASOURCE);
  end;

  Function TJLWriter.CopyFrom(Const Data:TJLBufferCustom;
           Const DataLen:Int64):Int64;
  var
    FReader: TJLReaderBuffer;
  Begin
    If Data<>NIL then
    Begin
      FReader:=TJLReaderBuffer.Create(Data);
      try
        Result:=CopyFrom(FReader,DataLen);
      finally
        FReader.free;
      end;
    end else
    Raise EJLWriter.Create(ERR_JL_WRITER_INVALIDDATASOURCE);
  end;

  Procedure TJLWriter.WriteCRLF(Const Times:Integer=1);
  var
    FLen:   Integer;
    FWord:  Word;
    FData:  Pointer;
  Begin
    If Times>0 then
    Begin
      FWord:=2573; // [#13,#10]

      If Times=1 then
      Write(FWord,SizeOf(FWord)) else

      if Times=2 then
      Begin
        Write(FWord,SizeOf(FWord));
        Write(FWord,SizeOf(FWord));
      end else

      if Times>2 then
      Begin
        FLen:=SizeOf(FWord) * Times;
        FData:=Allocmem(FLen);
        try
          JL_FillWord(FData,Times,FWord);
          Write(FData^,FLen);
        finally
          FreeMem(FData);
        end;
      end;
    end;
  end;

  Procedure TJLWriter.WriteAsc(Value:AnsiString;
            Const Delimiter:AnsiString=CNT_JL_CRLF);
  var
    FLen: Integer;
  Begin
    Value:=Value + Delimiter;
    FLen:=Length(Value);
    If FLen>0 then
    Write(Value[1],FLen);
  end;

  Procedure TJLWriter.WriteString(Const Value:AnsiString);
  var
    FLen: Integer;
  Begin
    (* write string header *)
    WriteWord(CNT_JL_ASTRING_HEADER);

    (* get length of data *)
    FLen:=Length(Value);

    (* write length of data *)
    WriteInt(FLen);

    (* Any the actual data *)
    {$WARNINGS OFF}
    If FLen>0 then
    If Write(Value[1],FLen)<FLen then
    Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
    {$WARNINGS ON}
  end;

  Procedure TJLWriter.WriteWideString(Const Value:WideString);
  var
    FLen: Integer;
  Begin
    (* write string header *)
    WriteWord(CNT_JL_WSTRING_HEADER);

    (* get length of data *)
    FLen:=Length(Value);

    (* write length of data *)
    WriteInt(FLen);

    (* Any the actual data *)
    {$WARNINGS OFF}
    If FLen>0 then
    Begin
      FLen:=FLen * 2;
      If Write(Value[1],FLen)<FLen then
      Raise EJLWriter.Create(ERR_JL_WRITER_FAILEDWRITE);
    end;
    {$WARNINGS ON}
  end;

  //##########################################################################
  // TJLCommonComponent
  //##########################################################################

  Function TJLCommonComponent.ObjectHasData:Boolean;
  Begin
    result:=False;
  end;

  Procedure TJLCommonComponent.ReadComponentBin(Stream:TStream);
  var
    FReader:      TJLReader;
  Begin
    BeforeReadObject;
    try
      FReader:=TJLReaderStream.Create(Stream);
      try
        ReadObject(FReader);
      Finally
        FReader.free;
      end;
    finally
      AfterReadObject;
    end;
  end;

  Procedure TJLCommonComponent.WriteComponentBin(Stream:TStream);
  var
    FWriter:  TJLWriter;
  Begin
    BeforeWriteObject;
    try
      FWriter:=TJLWriterStream.Create(Stream);
      try
        WriteObject(FWriter);
      finally
        FWriter.free;
      end;
    finally
      AfterWriteObject;
    end;
  end;

  Procedure TJLCommonComponent.DefineProperties(Filer:TFiler);
  Begin
    inherited;
    Filer.DefineBinaryProperty('CM_Data',
    ReadComponentBin,WriteComponentBin,ObjectHasData);
  end;

  Procedure TJLCommonComponent.BeforeReadObject;
  Begin
  end;

  Procedure TJLCommonComponent.AfterReadObject;
  Begin
  end;

  Procedure TJLCommonComponent.BeforeWriteObject;
  Begin
  end;

  Procedure TJLCommonComponent.AfterWriteObject;
  Begin
  end;

  Procedure TJLCommonComponent.ReadObject(Const Reader:TJLReader);
  { var
    FReader: TReader;
    FStream:  TStream;
    PropName, PropValue: string; }
  begin
    {FStream:=Reader.ReadStream;
    try
      FReader:=TReader.Create(FStream, $FFF) ;
      try
        FStream.Position := 0;
        FReader.ReadListBegin;
        while not FReader.EndOfList do
        begin
          PropName := Reader.ReadString;
          PropValue := Reader.ReadString;
          SetPropValue(Self, PropName, PropValue) ;
        end;
      finally
        FreeAndNil(FReader);
      end;
    finally
      FStream.free;
    end;   }
  end;

  Procedure TJLCommonComponent.WriteObject(Const Writer:TJLWriter);
  { var
    PropName,
    PropValue:  string;
    cnt:        Integer;
    lPropInfo:  PPropInfo;
    lPropCount: Integer;
    lPropList:  PPropList;
    lPropType:  PPTypeInfo;
    FTemp:      TMemoryStream;
    FWriter:    TWriter; }
  Begin
    {FTemp:=TMemoryStream.Create;
    try
      FWriter:=TWriter.Create(FTemp,$FFF);
      try
        lPropCount := GetPropList(PTypeInfo(ClassInfo), lPropList) ;
        FTemp.Size := 0;
        FWriter.WriteListBegin;
        for cnt:=0 to lPropCount-1 do
        begin
          lPropInfo := lPropList^[cnt];
          lPropType := lPropInfo^.PropType;
          if lPropType^.Kind = tkMethod then
          Continue;

          PropName := lPropInfo.Name;
          PropValue := GetPropValue(Self, PropName) ;
          Writer.WriteString(PropName);
          Writer.WriteString(PropValue);
        end;
      finally
        FWriter.FlushBuffer;
        FWriter.free;
      end;
    finally
      FTemp.Position:=0;
      Writer.WriteStreamContent(FTemp);
      FTemp.free;
    end;        }
  end;

  //##########################################################################
  // TJLBufferCustom
  //##########################################################################

  Procedure TJLBufferCustom.Assign(Source:TPersistent);
  Begin
    If Source<>NIl then
    Begin
      If (Source is TJLBufferCustom) then
      Begin
        Release;
        ContentFromData(TJLBufferCustom(Source));
      end else
      Inherited;
    end else
    Inherited;
  end;

  Destructor TJLBufferCustom.Destroy;
  Begin
    (* release memory if capabillities allow it *)
    If (mcOwned in FCaps) then
    Release;
    inherited;
  end;

  Procedure TJLBufferCustom.AfterConstruction;
  Begin
    inherited;
    (* Get memory capabillities *)
    FCaps:=DoGetCapabilities;
  end;

  Function TJLBufferCustom.MakeReader(out outReader:TJLReader):Boolean;
  Begin
    outReader:=TJLReaderBuffer.Create(self);
    result:=outReader<>NIL;
  end;

  Function TJLBufferCustom.MakeWriter(out outWriter:TJLWriter):Boolean;
  Begin
    outWriter:=TJLWriterBuffer.Create(self);
    result:=outWriter<>NIL;
  end;

  Function TJLBufferCustom.MakeStreamWrapper(out outStream:TStream):Boolean;
  Begin
    outStream:=TJLBufferWrapper.Create(self);
    result:=outStream<>NIL;
  end;

  {Function TJLBufferCustom.GetHasData:Boolean;
  Begin
    result:=GetEmpty=False;
  end; }

  Function TJLBufferCustom.ObjectHasData:Boolean;
  Begin
    result:=DoGetDataSize>0;
  end;

  Function TJLBufferCustom.GetEmpty:Boolean;
  Begin
    result:=DoGetDataSize<=0;
  end;

  Procedure TJLBufferCustom.BeforeReadObject;
  Begin
    Release;
  end;

  { Procedure TJLBufferCustom.AfterReadObject;
  Begin
  end;

  Procedure TJLBufferCustom.BeforeWriteObject;
  Begin
  end;

  Procedure TJLBufferCustom.AfterWriteObject;
  Begin
  end;     }

  Procedure TJLBufferCustom.ReadObject(Const Reader:TJLReader);
  var
    FTotal: Int64;
  Begin
    FTotal:=Reader.ReadInt64;
    If FTotal>0 then
    Reader.CopyTo(self,FTotal);
  end;

  Procedure TJLBufferCustom.WriteObject(Const Writer:TJLWriter);
  Begin
    Writer.WriteInt64(Size);
    if Size>0 then
    Writer.CopyFrom(self,Size);
  end;

  { Procedure TJLBufferCustom.ReadBin(Stream:TStream);
  var
    FReader:      TJLReader;
  Begin
    (* Release current data *)
    If not GetEmpty then
    Release;

    BeforeReadObject;
    try
      FReader:=TJLReaderStream.Create(Stream);
      try
        ReadObject(FReader);
      Finally
        FReader.free;
      end;
    finally
      AfterReadObject;
    end;
  end;

  Procedure TJLBufferCustom.WriteBin(Stream:TStream);
  var
    FWriter:  TJLWriter;
  Begin
    BeforeWriteObject;
    try
      FWriter:=TJLWriterStream.Create(Stream);
      try
        WriteObject(FWriter);
      finally
        FWriter.free;
      end;
    finally
      AfterWriteObject;
    end;
  end;

  Procedure TJLBufferCustom.DefineProperties(Filer:TFiler);
  Begin
    inherited;
    Filer.DefineBinaryProperty('Raw_Data',ReadBin,WriteBin,GetEmpty=False);
  end;  }

  (* IJLBinaryContent: ContentToBinary *)
  Function TJLBufferCustom.ContentToData(Const Data:TJLBufferCustom):Int64;
  var
    FWriter:  TJLWriter;
  Begin
    If (Data<>NIL) and (Data<>self) then
    Begin
      if Data.MakeWriter(FWriter) then
      Begin
        try
          result:=ContentTo(FWriter)
        finally
          FWriter.free;
        end;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_FAILEDMAKEWRITER);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDWRITETARGET);
  end;

  Procedure TJLBufferCustom.ContentFrom(Const Reader:TJLReader);
  var
    FOffset:      Int64;
    FBytesToRead: Integer;
    FBytesRead:   Integer;
    FCache:       TJLIOCache;
  Begin
    If Reader<>NIL then
    Begin
      If mcWrite in FCaps then
      Begin
        If mcScale in FCaps then
        Begin

         (* release current content *)
          If not Empty then
          Release;

          (* init *)
          FOffset:=0;

          Repeat
            (* attempt to read data *)
            FBytesToRead:=SizeOf(FCache);
            FBytesRead:=Reader.Read(FCache,FBytesToRead);
            If FBytesRead>0 then
            Begin
              Append(FCache,FBytesRead);
              FOffset:=FOffset + FBytesRead;
            end else
            Break;
          Until FBytesRead<1;

        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDDATASOURCE);
  end;

  (* IJLBinaryContent: ContentFromBinary *)
  Procedure TJLBufferCustom.ContentFromData(Const Data:TJLBufferCustom);
  var
    FReader:  TJLReader;
  Begin
    If Data<>NIL then
    Begin
      if Data.MakeReader(FReader) then
      Begin
        try
          ContentFrom(FReader);
        finally
          FReader.free;
        end;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_FAILEDMAKEREADER);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDDATASOURCE);
  end;

  Procedure TJLBufferCustom.ContentFromFile(Const Filename:AnsiString);
  var
    FFile: TFileStream;
    FReader:  TJLReader;
  Begin
    FFile:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
    try
      FReader:=TJLReaderStream.Create(FFile);
      try
        ContentFrom(FReader);
      finally
        FReader.free;
      end;
    finally
      FFile.free;
    end;
  end;

  procedure TJLBufferCustom.ContentToFile(Const Filename:AnsiString);
  var
    FFile:    TFileStream;
    FWriter:  TJLWriter;
  Begin
    FFile:=TFileStream.Create(Filename,fmCreate);
    try
      FWriter:=TJLWriterStream.Create(FFile);
      try
        ContentTo(FWriter)
      finally
        FWriter.free;
      end;
    finally
      FFile.free;
    end;
  end;

  (* IJLStreamableContent: ContentToStream *)
  Function TJLBufferCustom.toStream:TStream;
  Begin
    Result:=TMemoryStream.Create;
    try
      ContentToStream(Result);
    except
      on exception do
      Begin
        FreeAndNil(Result);
        Raise;
      end;
    end;
  end;
  
  (* IJLStreamableContent: ContentToStream *)
  Function TJLBufferCustom.ContentToStream(Const Stream:TStream):Int64;
  var
    FWriter:  TJLWriter;
  Begin
    If Stream<>NIL then
    Begin
      FWriter:=TJLWriterStream.Create(Stream);
      try
        result:=ContentTo(FWriter)
      finally
        FWriter.free;
      end;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDWRITETARGET);
  end;

  (* IJLStreamableContent: ContentToStream *)
  Procedure TJLBufferCustom.ContentFromStream(Const Stream:TStream);
  var
    FReader:  TJLReader;
  Begin
    If Stream<>NIL then
    Begin
      FReader:=TJLReaderStream.Create(Stream);
      try
        ContentFrom(FReader);
      finally
        FReader.free;
      end;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDDATASOURCE);
  end;

  Function TJLBufferCustom.ContentTo(Const Writer:TJLWriter):Int64;
  var
    FTotal:       Int64;
    FOffset:      Int64;
    FBytesToRead: Integer;
    FBytesRead:   Integer;
    FCache:       TJLIOCache;
  Begin
    If mcRead in FCaps then
    Begin
      Result:=DoGetDataSize;
      If Result>0 then
      Begin
        FTotal:=Result;
        FOffset:=0;
        Repeat
          {FBytesToRead:=SizeOf(FCache);
          If FBytesToRead>FTotal then
          FBytesToRead:=FTotal; }
          FBytesToRead:=Math.EnsureRange(SizeOf(FCache),0,FTotal);
          FBytesRead:=Read(FOffset,FBytesToRead,FCache);
          If FBytesRead>0 then
          Begin
            Writer.Write(FCache,FBytesRead);
            FOffset:=FOffset + FBytesRead;
            FTotal:=FTotal - FBytesRead;
          end;
        Until (FTotal<1) or (FBytesRead<1);
        (* Adjust result if we did not copy everything *)
        Result:=Result - FTotal;
      end;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
  end;
  
  (* IJLBufferedContent: ContentToBuffer *)
  Function  TJLBufferCustom.ContentToBuffer(var Buffer;
            Const BufLen:Integer):Integer;
  var
    FTotal: Integer;
  Begin
    If BufLen>0 then
    Begin
      If mcRead in FCaps then
      Begin
        FTotal:=DoGetDataSize;
        If FTotal>0 then
        Result:=Read(0,BufLen,Buffer) else
        Result:=0;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
    end else
    result:=0;
  end;

  (* IJLBufferedContent: ContentFromBuffer *)
  Procedure TJLBufferCustom.ContentFromBuffer(Const Buffer;
            Const BufLen:Integer);
  Begin
    If mcWrite in FCaps then
    Begin
      If mcScale in FCaps then
      Begin
        If not Empty then
        Release;
        Append(Buffer,BufLen);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
  end;

  Procedure TJLBufferCustom.DoFillData(Start:Int64;FillLength:Int64;
            Const Data;DataLen:Integer);
  var
    FToWrite: Integer;
  Begin
    (* Fill area with data *)
    {If DataLen>0 then
    Begin   }
      While FillLength>0 do
      Begin
        FToWrite:=DataLen;
        If FToWrite>FillLength then
        FToWrite:=FillLength;

        DoWriteData(Start,Data,FToWrite);
        FillLength:=FillLength - FToWrite;
        Start:=Start + FToWrite;
      end;
    //end;
  end;

  Function  TJLBufferCustom.ContentIsAscii(Const ByteLen:Int64=0):Boolean;
  var
    x:      Integer;
    FLen:   Int64;
    FChar:  Char;
  Begin
    result:=Empty=False;
    If result then
    Begin
      (* Do we support read caps? *)
      If (mcRead in FCaps) then
      Begin
        If ByteLen<1 then
        FLen:=Size else
        Begin
          FLen:=ByteLen;
          if FLen>Size then
          FLen:=Size;
        end;

        (* NOTE: Loop reduction is needed here *)
        for x:=1 to FLen do
        Begin
          result:=Read(x-1,1,FChar)>0;
          If result then
          Begin
            result:=JL_CharIsAnsi(FChar);
            If not result then
            Break;
          end;
        end;

      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
    end;
  end;

  Function  TJLBufferCustom.Fill(Const Offset:Int64;
            Const FillLength:Int64;
            Const Data;Const DataLen:Integer):Int64;
  var
    FTotal: Int64;
  Begin
    If not Empty then
    Begin
      If mcWrite in FCaps then
      Begin
        If  (FillLength>0)
        and (DataLen>0) then
        Begin
          FTotal:=DoGetDataSize;
          If (Offset>=0) and (Offset<FTotal) then
          Begin
            Result:=FTotal-Offset;
            If result>0 then
            DoFillData(Offset,Result,Data,DataLen);
          end else
          Raise EJLBuffer.CreateFmt
          (ERR_JL_DATA_BYTEINDEXVIOLATION,[0,FTotal,Offset]);
        end else
        result:=0;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
  end;

  Procedure TJLBufferCustom.DoZeroData;
  var
    FSize:  Int64;
    FCache: TJLIOCache;
  Begin
    FSize:=DoGetDataSize;
    FillChar(FCache,SizeOf(FCache),0);
    Fill(0,FSize,FCache,SizeOf(FCache));
  end;

  Procedure TJLBufferCustom.Zero;
  Begin
    If not Empty then
    Begin
      If mcWrite in FCaps then
      DoZeroData else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
  end;

  Procedure TJLBufferCustom.Append(Const Data:TJLBufferCustom);
  var
    FOffset:      Int64;
    FTotal:       Int64;
    FRead:        Integer;
    FBytesToRead: Integer;
    FCache:       TJLIOCache;
  Begin
    If mcScale in FCaps then
    Begin
      If mcWrite in FCaps then
      Begin
        If Data<>NIL then
        Begin
          (* does the source support read caps? *)
          If (mcRead in Data.Capabilities) then
          Begin

            FOffset:=0;
            FTotal:=Data.Size;

            Repeat
              FBytesToRead:=Math.EnsureRange(SizeOf(FCache),0,FTotal);
              {FBytesToRead:=SizeOf(FCache);
              If FBytesToRead>FTotal then
              FBytesToRead:=FTotal;}

              FRead:=Data.Read(FOffset,FBytesToRead,FCache);
              If FRead>0 then
              Begin
                Append(FCache,FRead);
                FTotal:=FTotal - FRead;
                FOffset:=FOffset + FRead;
              end;
            Until (FBytesToRead<1) or (FRead<1);

          end else
          Raise EJLBuffer.Create(ERR_JL_DATA_SOURCEREADNOTSUPPORTED);

        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDAPPENDSOURCE);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
  end;

  Procedure TJLBufferCustom.Append(Const Stream:TStream);
  var
    FTotal:       Int64;
    FRead:        Integer;
    FBytesToRead: Integer;
    FCache:       TJLIOCache;
  Begin
    If mcScale in FCaps then
    Begin
      If mcWrite in FCaps then
      Begin
        If Stream<>NIL then
        Begin
          FTotal:=Stream.Size-Stream.Position;
          If FTotal>0 then
          Begin

            Repeat
              {FBytesToRead:=SizeOf(TJLIOCache);
              If FBytesToRead>FTotal then
              FBytesToRead:=FTotal;    }
              FBytesToRead:=Math.EnsureRange(SizeOf(FCache),0,FTotal);
              FRead:=Stream.Read(FCache,FBytesToRead);
              If FRead>0 then
              Begin
                Append(FCache,FRead);
                FTotal:=FTotal - FRead;
              end;
            Until (FBytesToRead<1) or (FRead<1);

          end;
        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDSTREAMSOURCE);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
  end;

  Procedure TJLBufferCustom.Append(Const Data;Const DataLen:Integer);
  var
    FOffset: Int64;
  Begin
    If mcScale in FCaps then
    Begin
      If mcWrite in FCaps then
      Begin
        If DataLen>0 then
        Begin
          FOffset:=DoGetDataSize;
          DoGrowDataBy(DataLen);
          DoWriteData(FOffset,Data,DataLen);
        end;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
  end;

  Procedure TJLBufferCustom.Release;
  Begin
    If mcOwned in FCaps then
    DoReleaseData else
    Raise EJLBuffer.Create(ERR_JL_DATA_RELEASENOTSUPPORTED);
  end;

  Procedure TJLBufferCustom.SetSize(Const Value:Int64);
  var
    FFactor:  Int64;
    FOldSize: Int64;
  Begin
    If mcScale in FCaps then
    Begin
      If Value>0 then
      Begin
        (* Get current size *)
        FOldSize:=DoGetDataSize;

        (* Get difference between current size & new size *)
        FFactor:=JL_Diff(FOldSize,Value);

        (* only act if we need to *)
        If FFactor>0 then
        Begin
          try
            (* grow or shrink? *)
            If Value>FOldSize then
            DoGrowDataBy(FFactor) else

            if Value<FOldSize then
            DoShrinkDataBy(FFactor);
          except
            on e: exception do
            Raise EJLBuffer.CreateFmt
            (ERR_JL_DATA_SCALEFAILED,[e.message]);
          end;
        end;
      end else
      Release;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
  end;

  {$IFDEF JL_ALLOW_VARIANTS}
  Function TJLBufferCustom.ContentToVariant:Variant;
  var
    FTotal: Int64;
    FData:  PByte;
  Begin
    If mcRead in FCaps then
    Begin
      If not Empty then
      Begin
        FTotal:=DoGetDataSize;
        If FTotal>0 then
        Begin
          Result:=VarArrayCreate([0,FTotal],varByte);
          FData:=VarArrayLock(Result);
          try
            DoReadData(0,FTotal,FData^);
          finally
            VarArrayUnLock(Result);
          end;
        end else
        Result:=NULL;
      end else
      Result:=NULL;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
  end;

  (* IJLVariantContent: ContentFromVariant *)
  Procedure TJLBufferCustom.ContentFromVariant(Const Value:Variant);
  Begin
    If not Empty then
    Release;
    If VarIsArray(Value) then
    AddVariantArray(value) else
    AddVariantData(Value);
  end;

  Function TJLBufferCustom.GetVariant:Variant;
  Begin
    With TJLReaderBuffer.Create(self) do
    Begin
      try
        Result:=ReadVariant;
      finally
        Free;
      end;
    end;
  end;

  Procedure TJLBufferCustom.SetVariant(Value:Variant);
  Begin
    With TJLWriterBuffer.Create(self) do
    Begin
      try
        WriteVariant(Value);
      finally
        Free;
      end;
    end;
  end;

  (* recursive *)
  Procedure TJLBufferCustom.AddVariantData(Const inVar:Variant);
  var
    FAddr:  PVarData;
    FAText: AnsiString;
    FWText: WideString;
  Begin
    If not varIsEmpty(inVar) then
    Begin
      FAddr:=FindVarData(inVar);
      If FAddr<>NIL then
      Begin
        (* write variant content *)
        Case FAddr^.VType of
        varError:     Append(FAddr^.VError,SizeOf(FAddr^.VError));
        varByte:      Append(FAddr^.VByte,SizeOf(FAddr^.VByte));
        varBoolean:   Append(FAddr^.VBoolean,SizeOf(FAddr^.VBoolean));
        varShortInt:  Append(FAddr^.VShortInt,SizeOf(FAddr^.VShortInt));
        varWord:      Append(FAddr^.VWord,SizeOf(FAddr^.VWord));
        varSmallint:  Append(FAddr^.VSmallInt,SizeOf(FAddr^.VSmallInt));
        varInteger:   Append(FAddr^.VInteger,SizeOf(FAddr^.VInteger));
        varLongWord:  Append(FAddr^.VLongWord,SizeOf(FAddr^.VLongWord));
        varInt64:     Append(FAddr^.VInt64,SizeOf(FAddr^.VInt64));
        varSingle:    Append(FAddr^.VSingle,SizeOf(FAddr^.VSingle));
        varDouble:    Append(FAddr^.VDouble,SizeOf(FAddr^.VDouble));
        varCurrency:  Append(FAddr^.VCurrency,SizeOf(FAddr^.VCurrency));
        varDate:      Append(FAddr^.VDate,SizeOf(FAddr^.VDate));
        varVariant:
          Begin
            If VarIsArray(InVar) then
            AddVariantArray(inVar) else
            AddVariantData(inVar);
          end;
        varString:
          Begin
            FAText:=AnsiString(FAddr^.VString);
            If Length(FAText)>0 then
            Append(FAText[1],Length(FAText));
          end;
        varOleStr:
          Begin
            FWText:=AnsiString(FAddr^.VString);
            If Length(FWText)>0 then
            Append(FWText[1],Length(FAText) shl 1);
          end;
        end;
      end;
    end;
  end;

  (* recursive *)
  Procedure TJLBufferCustom.AddVariantArray(Const inVar:Variant);
  var
    FDepth: Integer;
    x,y:    Integer;
  Begin
    If not VarIsEmpty(inVar) then
    Begin
      FDepth:=VarArrayDimCount(inVar);
      for y:=1 to FDepth do
      Begin
        for x:=VarArrayLowBound(inVar,Y) to VarArrayHighBound(inVar,Y) do
        AddVariantData(inVar[x]);
      end;
    end;
  End;
  {$ENDIF}

  Function  TJLBufferCustom.Find(Const Data;Const DataLen:Integer;
            var Offset:Int64):Boolean;
  var
    FTotal:   Int64;
    FToScan:  Int64;
    src:      PByte;
    FByte:    Byte;
    FOffset:  Int64;
    x:        Int64;
    y:        Int64;
  Begin
    FTotal:=DoGetDataSize;
    Result:=FTotal>0;
    If Result then
    Begin
      Result:=mcRead in FCaps;
      If result then
      Begin
        Result:=(DataLen>0) and (FTotal>=DataLen);
        If result then
        Begin
          (* make compiler happy *)
          Result:=False;

          (* how many bytes must we scan? *)
          FToScan:=FTotal - DataLen;

          x:=0;
          While (x<=FToScan) do
          Begin
            (* setup source PTR *)
            src:=Addr(Data);

            (* setup target offset *)
            FOffset:=x;

            (* check memory by sampling *)
            y:=1;
            while y<DataLen do
            Begin
              (* break if not equal *)
              Read(FOffset,1,FByte);
              Result:=src^=FByte;
              If result=false then
              Break;

              inc(src);
              FOffset:=FOffset + 1;
              Y:=Y + 1;
            end;

            (* success? *)
            if Result then
            Begin
              Offset:=x;
              Break;
            end;

            x:=x + 1;
          end;

        end;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
    end;{ else
    Raise GetException.Create(ERR_JL_DATA_EMPTY);}
  end;

  Procedure TJLBufferCustom.Insert(Const Offset:Int64;
            Const Data;DataLen:Integer);
  var
    FTotal:       Int64;
    FBytesToPush: Int64;
    FBytesToRead: Integer;
    FPosition:    Int64;
    FFrom:        Int64;
    FTo:          Int64;
    FCache:       TJLIOCache;
  Begin
    If mcScale in FCaps then
    Begin
      If mcWrite in FCaps then
      Begin
        If mcRead in FCaps then
        Begin
          If DataLen>0 then
          Begin
            (* get current size *)
            FTotal:=DoGetDataSize;

            (* Insert into data? *)
            If (Offset>=0) and (Offset<FTotal) then
            Begin
              (* How many bytes should we push? *)
              FBytesToPush:=FTotal - Offset;
              If FBytesToPush>0 then
              Begin
                (* grow media to fit new data *)
                DoGrowDataBy(DataLen);

                (* calculate start position *)
                FPosition:=Offset + FBytesToPush;

                While FBytesToPush>0 do
                Begin
                  (* calculate how much data to read *)
                  {FBytesToRead:=SizeOf(FCache);
                  If FBytesToRead>FBytesToPush then
                  FBytesToRead:=FBytesToPush;    }
                  FBytesToRead:=Math.EnsureRange(SizeOf(FCache),0,FBytesToPush);

                  (* calculate read & write positions *)
                  FFrom:=FPosition - FBytesToRead;
                  FTo:=FPosition - (FBytesToRead - DataLen);

                  (* read data from the end *)
                  DoReadData(FFrom,FCache,FBytesToRead);

                  (* write data upwards *)
                  DoWriteData(FTo,FCache,FBytesToRead);

                  (* update offset values *)
                  FPosition:=FPosition - FBytesToRead;
                  FBytesToPush:=FBytesToPush - FBytesToRead;
                end;

                (* insert new data *)
                DoWriteData(FPosition,Data,DataLen);

              end else
              DoWriteData(FTotal,Data,DataLen);
            end else

            (* if @ end, use append instead *)
            If Offset=FTotal then
            Append(Data,DataLen) else

            (* outside of memory scope, raise exception *)
            Raise EJLBuffer.CreateFmt
            (ERR_JL_DATA_BYTEINDEXVIOLATION,[0,FTotal,Offset]);
          end;
        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
  end;

  Procedure TJLBufferCustom.Remove(Const Offset:Int64;RemoveLen:Integer);
  var
    FTemp:      Integer;
    FTop:       Int64;
    FBottom:    Int64;
    FToRead:    Integer;
    FToPoll:    Int64;
    FPosition:  Int64;
    FTotal:     Int64;
    FCache:     TJLIOCache;
  Begin
    If mcScale in FCaps then
    Begin
      If mcWrite in FCaps then
      Begin
        If mcRead in FCaps then
        Begin
          If RemoveLen>0 then
          Begin
            (* get current size *)
            FTotal:=DoGetDataSize;

            (* Remove from data? *)
            If (Offset>=0) and (Offset<FTotal) then
            Begin
              FTemp:=Offset + RemoveLen;
              If RemoveLen<>FTotal then
              Begin
                If FTemp<FTotal then
                Begin
                  FToPoll:=FTotal - (Offset + RemoveLen);
                  FTop:=Offset;
                  FBottom:=Offset + RemoveLen;

                  While FToPoll>0 do
                  Begin
                    FPosition:=FBottom;
                    FToRead:=Math.EnsureRange(SizeOf(FCache),0,FToPoll);
                    {FToRead:=SizeOf(FCache);
                    If FToRead>FToPoll then
                    FToRead:=FToPoll;     }

                    DoReadData(FPosition,FCache,FToRead);
                    DoWriteData(FTop,FCache,FToRead);

                    FTop:=FTop + FToRead;
                    FBottom:=FBottom + FToRead;
                    FToPoll:=FToPoll - FToRead;
                  end;
                  DoShrinkDataBy(RemoveLen);
                end else
                Release;
              end else
              Begin
                If FTemp>FTotal then
                Release else
                DoShrinkDataBy(FTotal - RemoveLen);
              end;

            end else
            Raise EJLBuffer.CreateFmt
            (ERR_JL_DATA_BYTEINDEXVIOLATION,[0,FTotal,Offset]);
          end;
        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
  end;

  Function TJLBufferCustom.Push(Const Data;DataLen:Integer):Integer;
  Begin
    If not Empty then
    Insert(0,Data,DataLen) else
    Append(Data,DataLen);
    Result:=DataLen;
  end;

  Function TJLBufferCustom.Poll(Var Data;DataLen:Integer):Integer;
  var
    FTotal:   Int64;
    FRemains: Int64;
  Begin
    If mcScale in FCaps then
    Begin
      If mcWrite in FCaps then
      Begin
        If mcRead in FCaps then
        Begin
          Result:=0;
          If DataLen>0 then
          Begin
            (* get current size *)
            FTotal:=DoGetDataSize;
            If FTotal>0 then
            Begin
              (* will any data remain? *)
              FRemains:=FTotal - DataLen;
              If FRemains>0 then
              Begin
                (* return data, keep the stub *)
                Result:=Read(0,DataLen,Data);
                Remove(0,DataLen);
              end else
              Begin
                (* return data, deplete buffer *)
                Result:=FTotal;
                DoReadData(0,Data,FTotal);
                Release;
              end;
            end;
          end;
        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
  end;

  Function TJLBufferCustom.HashCode:Longword;
  var
    i:      Int64;
    x:      Longword;
    FByte:  Byte;
    FTotal: Int64;
  Begin
    FTotal:=DoGetDataSize;
    If FTotal>0 then
    Begin
      Result:=0;
      i:=1;
      while i<=FTotal do
      begin
        Read(i-1,1,FByte);
        Result := (Result shl 4) + FByte;
        x := Result and $F0000000;
        if (x <> 0) then
        Result := Result xor (x shr 24);
        Result := Result and (not x);
        i:=i + 1;
      end;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
  end;

  Function TJLBufferCustom.toString:AnsiString;
  var
    FLen:   Integer;
    FRead:  Integer;
  Begin
    If mcRead in FCaps then
    Begin
      FLen:=DoGetDataSize;
      if math.InRange(FLen,1,MAXINT-1) then
      Begin
        SetLength(Result,FLen);
        FRead:=Read(0,FLen,Result[1]);
        If FRead<FLen then
        SetLength(Result,FRead);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
  end;

  Function  TJLBufferCustom.CopyTo(Offset:Int64;CopyLen:Integer;
                Const Writer:TJLWriter):Integer;
  var
    FToRead:  Integer;
    FRead:    Integer;
    FCache:   TJLIOCache;
  Begin
    If mcRead in FCaps then
    Begin
      If CopyLen>0 then
      Begin
        If Writer<>NIL then
        Begin
          Result:=0;

          While CopyLen>0 do
          Begin
            FToRead:=Math.EnsureRange(SizeOf(FCache),0,CopyLen);
            {FToRead:=SizeOf(FCache);
            If FToRead>CopyLen then
            FToRead:=CopyLen; }
            FRead:=Read(Offset,FToRead,FCache);
            If FRead>0 then
            Begin
              Writer.Write(FCache,FRead);
              Offset:=Offset + FRead;
              CopyLen:=CopyLen - FRead;
            end else
            Break;
          end;

        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDWRITETARGET);
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
  end;

  Function  TJLBufferCustom.Read(Const Offset:Int64;
            ReadLen:Integer;var Data):Integer;
  var
    FTotal:   Int64;
    FRemains: Int64;
  Begin
    If mcRead in FCaps then
    Begin
      Result:=0;
      If ReadLen>0 then
      Begin
        FTotal:=DoGetDataSize;
        If FTotal>0 then
        Begin
          If (Offset>=0) and (Offset<FTotal) then
          Begin
            (* Check that copy results in data move *)
            FRemains:=FTotal - Offset;
            If FRemains>0 then
            Begin
              If ReadLen>FRemains then
              ReadLen:=FRemains;

              (* Read data into buffer *)
              DoReadData(Offset,Data,ReadLen);

              (* return bytes moved *)
              Result:=ReadLen;
            end;
          end;
        end else
        Raise EJLBuffer.Create(ERR_JL_DATA_EMPTY);
      end;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_READNOTSUPPORTED);
  end;

  Function  TJLBufferCustom.CopyFrom(Offset:Int64;CopyLen:Integer;
            Const Reader:TJLReader):Integer;
  var
    FToRead:  Integer;
    FRead:    Integer;
    FCache:   TJLIOCache;
  Begin
    If mcWrite in FCaps then
    Begin
      If Reader<>NIL then
      Begin
        Result:=0;
        While CopyLen>0 do
        Begin
          FToRead:=Math.EnsureRange(SizeOf(FCache),0,CopyLen);
          {FToRead:=SizeOf(FCache);
          If FToRead>CopyLen then
          FToRead:=CopyLen;    }
          FRead:=Reader.Read(FCache,FToRead);
          If FRead>0 then
          Begin
            Write(Offset,FRead,FCache);
            Offset:=Offset + FRead;
            CopyLen:=CopyLen - FRead;
          end else
          Break;
        end;
      end else
      Raise EJLBuffer.Create(ERR_JL_DATA_INVALIDREADTARGET);
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
  end;

  Function  TJLBufferCustom.Write(Const Offset:Int64;
            WriteLen:Integer;Const Data):Integer;
  var
    FTotal:   Int64;
    FEnding:  Int64;
    FExtra:   Integer;
  Begin
    If mcWrite in FCaps then
    Begin
      Result:=0;
      If WriteLen>0 then
      Begin
        (* get current data size *)
        FTotal:=DoGetDataSize;
        If FTotal>0 then
        Begin
          (* offset within range of allocation? *)
          If (Offset>=0) and (Offset<FTotal) then
          Begin
            (* does this write exceed buffer? *)
            FEnding:=Offset + WriteLen;
            If FEnding>FTotal then
            Begin
              (* by how much? *)
              FExtra:=Integer(FEnding - FTotal);

              (* scale if possible, or clip the length *)
              If mcScale in FCaps then
              DoGrowDataBy(FExtra) else
              WriteLen:=WriteLen - FExtra;
            end;

            If WriteLen>0 then
            Begin
              DoWriteData(Offset,Data,WriteLen);
              Result:=WriteLen;
            end;

          end else
          Raise EJLBuffer.CreateFmt
          (ERR_JL_DATA_BYTEINDEXVIOLATION,[0,FTotal,Offset]);
        end else
        Begin
          If mcScale in FCaps then
          Begin
            (* allocate memory *)
            DoGrowDataBy(WriteLen);

            (* write data *)
            DoWriteData(0,Data,WriteLen);

            (* return bytes moved *)
            Result:=WriteLen;
          end else
          Raise EJLBuffer.Create(ERR_JL_DATA_SCALENOTSUPPORTED);
        end;
      end;
    end else
    Raise EJLBuffer.Create(ERR_JL_DATA_WRITENOTSUPPORTED);
  end;


  end.
