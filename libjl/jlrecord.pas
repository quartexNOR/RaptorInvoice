  unit jlrecord;

  interface

  uses sysutils, classes, math, contnrs,
  jlcommon, jldatabuffer;

  const
  ERR_RECORDFIELD_INVALIDNAME =
  'Invalid field name [%s] error';

  ERR_RECORDFIELD_FailedSet =
  'Writing to field buffer [%s] failed error';

  ERR_RECORDFIELD_FailedGet =
  'Reading from field buffer [%s] failed error';

  ERR_RECORDFIELD_FieldIsEmpty
  = 'Record field is empty [%s] error';

  type

  EJLRecordFieldError = Class(Exception);
  EJLRecordError      = Class(Exception);

  TJLRecordField = Class(TJLBufferMemory)
  Private
    FName:      AnsiString;
    FNameHash:  Longword;
    Procedure   SetFName(Value:AnsiString);
    Function    GetOffset:Integer;
    Function    GetItemIndex:Integer;
  Protected
    Function    GetDisplayName:AnsiString;virtual;
    Procedure   BeforeReadObject;override;
    Procedure   ReadObject(Const Reader:TJLReader);override;
    Procedure   WriteObject(Const Writer:TJLWriter);override;
    Procedure   DoReleaseData;override;
  Protected
    Procedure   SignalWrite;
    Procedure   SignalRead;
    procedure   SignalRelease;
  Public
    Property    DisplayName:AnsiString read GetDisplayName;
    Property    ItemIndex:Integer read GetItemIndex;
    Property    FieldSignature:Longword read FNameHash;
    Property    FieldPosition:Integer read GetOffset;
    Property    FieldName:AnsiString read FName write SetFName;
  End;

  TJLFieldBoolean = Class(TJLRecordField)
  Private
    Function    GetValue:Boolean;
    Procedure   SetValue(Const NewValue:Boolean);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:Boolean read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldByte = Class(TJLRecordField)
  Private
    Function    GetValue:Byte;
    Procedure   SetValue(Const NewValue:Byte);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:Byte read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldCurrency = Class(TJLRecordField)
  Private
    Function    GetValue:Currency;
    Procedure   SetValue(Const NewValue:Currency);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:Currency read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldData = Class(TJLRecordField)
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Procedure   LoadFromFile(Const Filename:AnsiString);
    procedure   SaveToFile(Const Filename:AnsiString);
    Procedure   LoadFromStream(Const Stream:TStream);
    procedure   SaveToStream(Const Stream:TStream);
    Function    toString:AnsiString;override;
  End;

  TJLFieldDateTime = Class(TJLRecordField)
  Private
    Function    GetValue:TDateTime;
    Procedure   SetValue(Const NewValue:TDateTime);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:TDateTime read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldDouble = Class(TJLRecordField)
  Private
    Function    GetValue:Double;
    Procedure   SetValue(Const NewValue:Double);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:Double read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldGUID = Class(TJLRecordField)
  Private
    Function    GetValue:TGUID;
    Procedure   SetValue(Const NewValue:TGUID);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:TGUID read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldInteger = Class(TJLRecordField)
  Private
    Function    GetValue:Integer;
    Procedure   SetValue(Const NewValue:Integer);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:Integer read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldInt64 = Class(TJLRecordField)
  Private
    Function    GetValue:Int64;
    Procedure   SetValue(Const NewValue:Int64);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:Int64 read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLFieldString = Class(TJLRecordField)
  Private
    FLength:    Integer;
    FExplicit:  Boolean;
    Function    GetValue:AnsiString;
    Procedure   SetValue(NewValue:AnsiString);
    Procedure   SetFieldLength(Value:Integer);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:AnsiString read GetValue write SetValue;
    Property    Length:Integer read FLength write SetFieldLength;
    Property    Explicit:Boolean read FExplicit write FExplicit;
    Function    toString:AnsiString;override;
    Constructor Create(AOwner:TComponent);Override;
  End;

  TJLFieldLong = Class(TJLRecordField)
  Private
    Function    GetValue:Longword;
    Procedure   SetValue(Const NewValue:Longword);
  Protected
    Function    GetDisplayName:AnsiString;Override;
  Public
    Property    Value:Longword read GetValue write SetValue;
    Function    toString:AnsiString;override;
  End;

  TJLRecordFieldClass = Class of TJLRecordField;
  TJLRecordFieldArray = Array of TJLRecordFieldClass;

  TJLCustomRecord = Class(TJLCommonComponent)
  Private
    FObjects:   TObjectList;
    Function    GetCount:Integer;
    Function    GetItem(Index:Integer):TJLRecordField;
    Procedure   SetItem(index:Integer;value:TJLRecordField);
    Function    GetField(AName:AnsiString):TJLRecordField;
    Procedure   SetField(AName:AnsiString;Value:TJLRecordField);
  Protected
    Procedure   BeforeReadObject;Override;
    Procedure   ReadObject(Const Reader:TJLReader);Override;
    Procedure   WriteObject(Const Writer:TJLWriter);Override;
  Protected
    Property    Fields[aName:AnsiString]:TJLRecordField
                read GetField write SetField;
    Property    Items[index:Integer]:TJLRecordField
                read GetItem write SetItem;
    Property    Count:Integer read GetCount;
  Public
    Function    Add(aName:AnsiString;
                Const aFieldClass:TJLRecordFieldClass):TJLRecordField;
    Function    AddInteger(aName:AnsiString):TJLFieldInteger;
    Function    AddAnsiStr(aName:AnsiString):TJLFieldString;
    Function    AddByte(aName:AnsiString):TJLFieldByte;
    Function    AddBool(aName:AnsiString):TJLFieldBoolean;
    Function    AddCurrency(aName:AnsiString):TJLFieldCurrency;
    Function    AddData(aName:AnsiString):TJLFieldData;
    Function    AddDateTime(aName:AnsiString):TJLFieldDateTime;
    Function    AddDouble(aName:AnsiString):TJLFieldDouble;
    Function    AddGUID(aName:AnsiString):TJLFieldGUID;
    Function    AddInt64(aName:AnsiString):TJLFieldInt64;
    Function    AddLong(aName:AnsiString):TJLFieldLong;

    Procedure   WriteInt(aName:AnsiString;Value:Integer);
    procedure   WriteStr(aName:AnsiString;Value:AnsiString);
    Procedure   WriteByte(aName:AnsiString;Value:Byte);
    procedure   WriteBool(aName:AnsiString;Value:Boolean);
    procedure   WriteCurrency(aName:AnsiString;Value:Currency);
    procedure   WriteData(aName:AnsiString;Value:TStream);
    procedure   WriteDateTime(aName:AnsiString;Value:TDateTime);
    procedure   WriteDouble(aName:AnsiString;Value:Double);
    Procedure   WriteGUID(aName:AnsiString;Value:TGUID);
    Procedure   WriteInt64(aName:AnsiString;Value:Int64);
    Procedure   WriteLong(aName:AnsiString;Value:Longword);

    Function    IndexOf(aName:AnsiString):Integer;
    Function    ObjectOf(aName:AnsiString):TJLRecordField;
    Constructor Create(AOwner:TComponent);override;
    Destructor  Destroy;Override;
  End;

  TJLRecord = Class(TJLCustomRecord)
  Public
    Property  Fields;
    property  Items;
    Property  Count;
  End;

  Procedure JLRegisterRecordField(AClass:TJLRecordFieldClass);

  Function  JLRecordFieldKnown(AClass:TJLRecordFieldClass):Boolean;

  Function  JLRecordFieldClassFromName(aName:AnsiString;
            out AClass:TJLRecordFieldClass):Boolean;

  Function  JLRecordInstanceFromName(aName:AnsiString;
            out Value:TJLRecordField):Boolean;

  implementation

  Var
  _FieldClasses:  TJLRecordFieldArray;

  Procedure JLRegisterRecordField(AClass:TJLRecordFieldClass);
  var
    FLen: Integer;
  Begin
    if (AClass<>NIL)
    and (JLRecordFieldKnown(AClass)=False) then
    Begin
      FLen:=Length(_FieldClasses);
      Setlength(_FieldClasses,FLen+1);
      _FieldClasses[FLen]:=AClass;
    end;
  end;

  Function JLRecordFieldKnown(AClass:TJLRecordFieldClass):Boolean;
  var
    x:  Integer;
  Begin
    result:=AClass<>NIl;
    if result then
    Begin
      result:=Length(_FieldClasses)>0;
      If result then
      begin
        result:=False;
        for x:=low(_FieldClasses) to high(_FieldClasses) do
        Begin
          result:=_FieldClasses[x]=AClass;
          if result then
          break;
        end;
      end;
    End;
  end;

  Function JLRecordFieldClassFromName(aName:AnsiString;
            out AClass:TJLRecordFieldClass):Boolean;
  var
    x:  Integer;
  Begin
    AClass:=NIL;
    result:=Length(_FieldClasses)>0;
    If result then
    begin
      result:=False;
      for x:=low(_FieldClasses) to high(_FieldClasses) do
      Begin
        result:=_FieldClasses[x].ClassName=aName;
        If result then
        Begin
          AClass:=_FieldClasses[x];
          break;
        end;
      end;
    end;
  end;

  Function  JLRecordInstanceFromName(aName:AnsiString;
            out Value:TJLRecordField):Boolean;
  var
    FClass: TJLRecordFieldClass;
  Begin
    result:=JLRecordFieldClassFromName(aName,FClass);
    if result then
    Value:=FClass.Create(NIL);
  end;

  //##########################################################################
  // TJLCustomRecord
  //##########################################################################

  Constructor TJLCustomRecord.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FObjects:=TObjectList.Create(True);
  end;

  Destructor TJLCustomRecord.Destroy;
  Begin
    FObjects.free;
    inherited;
  end;

  Procedure TJLCustomRecord.WriteInt(aName:AnsiString;Value:Integer);
  Begin
  end;
  
  procedure TJLCustomRecord.WriteStr(aName:AnsiString;Value:AnsiString);
  Begin
  end;

  Procedure TJLCustomRecord.WriteByte(aName:AnsiString;Value:Byte);
  Begin
  end;

  procedure TJLCustomRecord.WriteBool(aName:AnsiString;Value:Boolean);
  Begin
  end;

  procedure TJLCustomRecord.WriteCurrency(aName:AnsiString;Value:Currency);
  Begin
  end;

  procedure TJLCustomRecord.WriteData(aName:AnsiString;Value:TStream);
  Begin
  end;

  procedure TJLCustomRecord.WriteDateTime(aName:AnsiString;Value:TDateTime);
  Begin
  end;

  procedure TJLCustomRecord.WriteDouble(aName:AnsiString;Value:Double);
  Begin
  end;

  Procedure TJLCustomRecord.WriteGUID(aName:AnsiString;Value:TGUID);
  Begin
  end;

  Procedure TJLCustomRecord.WriteInt64(aName:AnsiString;Value:Int64);
  Begin
  end;

  Procedure TJLCustomRecord.WriteLong(aName:AnsiString;Value:Longword);
  Begin
  end;

  Function TJLCustomRecord.AddInteger(aName:AnsiString):TJLFieldInteger;
  Begin
    result:=TJLFieldInteger(Add(aName,TJLFieldInteger));
  end;

  Function TJLCustomRecord.AddAnsiStr(aName:AnsiString):TJLFieldString;
  Begin
    result:=TJLFieldString(Add(aName,TJLFieldString));
  end;

  Function TJLCustomRecord.AddByte(aName:AnsiString):TJLFieldByte;
  Begin
    result:=TJLFieldByte(Add(aName,TJLFieldByte));
  end;
  
  Function TJLCustomRecord.AddBool(aName:AnsiString):TJLFieldBoolean;
  Begin
    result:=TJLFieldBoolean(Add(aName,TJLFieldBoolean));
  end;

  Function TJLCustomRecord.AddCurrency(aName:AnsiString):TJLFieldCurrency;
  Begin
    result:=TJLFieldCurrency(Add(aName,TJLFieldCurrency));
  end;

  Function TJLCustomRecord.AddData(aName:AnsiString):TJLFieldData;
  Begin
    result:=TJLFieldData(Add(aName,TJLFieldData));
  end;

  Function TJLCustomRecord.AddDateTime(aName:AnsiString):TJLFieldDateTime;
  Begin
    result:=TJLFieldDateTime(Add(aName,TJLFieldDateTime));
  end;

  Function TJLCustomRecord.AddDouble(aName:AnsiString):TJLFieldDouble;
  Begin
    result:=TJLFieldDouble(Add(aName,TJLFieldDouble));
  end;

  Function TJLCustomRecord.AddGUID(aName:AnsiString):TJLFieldGUID;
  Begin
    result:=TJLFieldGUID(Add(aName,TJLFieldGUID));
  end;

  Function TJLCustomRecord.AddInt64(aName:AnsiString):TJLFieldInt64;
  Begin
    result:=TJLFieldInt64(Add(aName,TJLFieldInt64));
  end;

  Function TJLCustomRecord.AddLong(aName:AnsiString):TJLFieldLong;
  Begin
    result:=TJLFieldLong(Add(aName,TJLFieldLong));
  end; 

  Function TJLCustomRecord.Add(aName:AnsiString;
           Const aFieldClass:TJLRecordFieldClass):TJLRecordField;
  Begin
    result:=ObjectOf(aName);
    if result=NIL then
    Begin
      if aFieldClass<>NIL then
      Begin
        Result:=aFieldClass.Create(self);
        Result.FieldName:=aName;
        FObjects.Add(result);
      end else
      result:=NIL;
    end;
  end;

  Procedure TJLCustomRecord.BeforeReadObject;
  Begin
    inherited;
    FObjects.Clear;
  end;

  Procedure TJLCustomRecord.ReadObject(Const Reader:TJLReader);
  var
    x:      Integer;
    FTemp:  TJLRecordField;
  Begin
    inherited;
    x:=Reader.ReadInt;
    While x>0 do
    Begin
      if JLRecordInstanceFromname(Reader.ReadString,FTemp) then
      FObjects.Add(FTemp);
      dec(x);
    end;
  end;

  Procedure TJLCustomRecord.WriteObject(Const Writer:TJLWriter);
  var
    x:  Integer;
  Begin
    inherited;
    x:=FObjects.Count;
    Writer.WriteInt(x);
    if x>0 then
    for x:=1 to FObjects.Count do
    Begin
      Writer.WriteString(Items[x-1].ClassName);
      Items[x-1].WriteObject(Writer);
    end;
  end;

  Function TJLCustomRecord.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  end;

  Function TJLCustomRecord.GetItem(Index:Integer):TJLRecordField;
  Begin
    result:=TJLRecordField(FObjects[index]);
  end;

  Procedure TJLCustomRecord.SetItem(index:Integer;value:TJLRecordField);
  Begin
    TJLRecordField(FObjects[index]).Assign(Value);
  end;

  Function TJLCustomRecord.GetField(AName:AnsiString):TJLRecordField;
  Begin
    result:=ObjectOf(aName);
  end;

  Procedure TJLCustomRecord.SetField(AName:AnsiString;Value:TJLRecordField);
  var
    FItem: TJLRecordField;
  Begin
    FItem:=ObjectOf(aName);
    If FItem<>NIL then
    FItem.assign(Value);
  end;

  Function TJLCustomRecord.IndexOf(aName:AnsiString):Integer;
  var
    x:  integer;
  Begin
    result:=-1;
    aName:=Lowercase(trim(aName));
    if length(aName)>0 then
    Begin
      for x:=1 to FObjects.Count do
      Begin
        if lowercase(GetItem(x-1).Name)=aName then
        Begin
          result:=x-1;
          Break;
        end;
      end;
    end;
  end;

  Function TJLCustomRecord.ObjectOf(aName:AnsiString):TJLRecordField;
  var
    x:      integer;
    FItem:  TJLRecordField;
  Begin
    result:=NIL;
    aName:=Lowercase(trim(aName));
    if length(aName)>0 then
    Begin
      for x:=1 to FObjects.Count do
      Begin
        FItem:=GetItem(x-1);
        if lowercase(FItem.Name)=aName then
        Begin
          result:=FItem;
          Break;
        end;
      end;
    end;
  end;

  //##########################################################################
  // TJLFieldLong
  //##########################################################################

  Function TJLFieldLong.toString:AnsiString;
  Begin
    Result:=IntToStr(Value);
  end;

  Function TJLFieldLong.GetDisplayName:AnsiString;
  Begin
    Result:='Longword';
  end;

  Function TJLFieldLong.GetValue:Longword;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldLong.SetValue(Const NewValue:Longword);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;

  //##########################################################################
  // TSRLFieldInt64
  //##########################################################################

  Function TJLFieldInt64.toString:AnsiString;
  Begin
    Result:=IntToStr(Value);
  end;

  Function TJLFieldInt64.GetDisplayName:AnsiString;
  Begin
    Result:='Int64';
  end;

  Function TJLFieldInt64.GetValue:Int64;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldInt64.SetValue(Const NewValue:Int64);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;

  //##########################################################################
  // TJLFieldInteger
  //##########################################################################

  Function TJLFieldInteger.toString:AnsiString;
  Begin
    Result:=IntToStr(Value);
  end;

  Function TJLFieldInteger.GetDisplayName:AnsiString;
  Begin
    Result:='Integer';
  end;

  Function TJLFieldInteger.GetValue:Integer;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldInteger.SetValue(Const NewValue:Integer);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;

  //##########################################################################
  // TJLFieldGUID
  //##########################################################################

  Function TJLFieldGUID.toString:AnsiString;
  Begin
    Result:=JL_GUIDToStr(Value);
  end;

  Function TJLFieldGUID.GetDisplayName:AnsiString;
  Begin
    Result:='GUID';
  end;

  Function TJLFieldGUID.GetValue:TGUID;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldGUID.SetValue(Const NewValue:TGUID);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;


  //##########################################################################
  // TJLFieldDateTime
  //##########################################################################

  Function TJLFieldDateTime.toString:AnsiString;
  Begin
    Result:=DateTimeToStr(Value);
  end;

  Function TJLFieldDateTime.GetDisplayName:AnsiString;
  Begin
    Result:='DateTime';
  end;

  Function TJLFieldDateTime.GetValue:TDateTime;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldDateTime.SetValue(Const NewValue:TDateTime);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;

  //##########################################################################
  // TJLFieldDouble
  //##########################################################################

  Function TJLFieldDouble.toString:AnsiString;
  Begin
    Result:=FloatToStr(Value);
  end;

  Function TJLFieldDouble.GetDisplayName:AnsiString;
  Begin
    Result:='Double';
  end;

  Function TJLFieldDouble.GetValue:Double;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RecordField_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldDouble.SetValue(Const NewValue:Double);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;


  //##########################################################################
  // TJLFieldData
  //##########################################################################

  Function TJLFieldData.toString:AnsiString;
  Begin
    Result:='[Binary]';
  end;
  
  Function TJLFieldData.GetDisplayName:AnsiString;
  Begin
    Result:='Binary';
  end;

  Procedure TJLFieldData.LoadFromFile(Const Filename:AnsiString);
  var
    FFile:TFileStream;
  Begin
    FFile:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
    try
      LoadFromStream(FFile);
      SignalWrite;
    finally
      FFile.free;
    end;
  end;

  procedure TJLFieldData.SaveToFile(Const Filename:AnsiString);
  var
    FFile: TFileStream;
  Begin
    FFile:=TFileStream.Create(Filename,fmCreate);
    try
      SaveToStream(FFile);
      SignalRead;
    finally
      FFile.free;
    end;
  end;

  Procedure TJLFieldData.LoadFromStream(Const Stream:TStream);
  Begin
    ContentFromStream(Stream);
    SignalWrite;
  end;

  procedure TJLFieldData.SaveToStream(Const Stream:TStream);
  Begin
    ContentToStream(Stream);
    SignalRead;
  end;

  //##########################################################################
  // TJLFieldCurrency
  //##########################################################################

  Function TJLFieldCurrency.toString:AnsiString;
  Begin
    Result:=CurrToStr(Value);
  end;

  Function TJLFieldCurrency.GetDisplayName:AnsiString;
  Begin
    Result:='Currency';
  end;

  Function TJLFieldCurrency.GetValue:Currency;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldCurrency.SetValue(Const NewValue:Currency);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;


  //##########################################################################
  // TJLFieldByte
  //##########################################################################

  Function TJLFieldByte.toString:AnsiString;
  Begin
    Result:=IntToStr(Value);
  end;

  Function TJLFieldByte.GetDisplayName:AnsiString;
  Begin
    Result:='Byte';
  end;

  Function TJLFieldByte.GetValue:Byte;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldByte.SetValue(Const NewValue:Byte);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;
  
  //##########################################################################
  // TJLFieldBoolean
  //##########################################################################

  Function TJLFieldBoolean.toString:AnsiString;
  Begin
    Result:=BoolToStr(Value,True);
  end;

  Function TJLFieldBoolean.GetDisplayName:AnsiString;
  Begin
    Result:='Boolean';
  end;

  Function TJLFieldBoolean.GetValue:Boolean;
  Begin
    If not Empty then
    Begin
      If Read(0,SizeOf(Result),Result)<SizeOf(Result) then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FieldIsEmpty,[FieldName]);
  end;

  Procedure TJLFieldBoolean.SetValue(Const NewValue:Boolean);
  Begin
    If Write(0,SizeOf(NewValue),NewValue)<SizeOf(NewValue) then
    Raise EJLRecordFieldError.CreateFmt
    (ERR_RECORDFIELD_FailedSet,[FieldName]) else
    SignalWrite;
  end;


  //##########################################################################
  // TJLFieldString
  //##########################################################################

  Constructor TJLFieldString.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FLength:=0;
    FExplicit:=False;
  end;

  Function TJLFieldString.toString:AnsiString;
  Begin
    Result:=Value;
  end;

  Function TJLFieldString.GetDisplayName:AnsiString;
  Begin
    Result:='String';
  end;

  Procedure TJLFieldString.SetFieldLength(Value:Integer);
  Begin
    If  FExplicit
    and (Value<>FLength) then
    Begin
      Value:=math.EnsureRange(Value,0,MAXINT-1);
      If Value>0 then
      Begin
        FLength:=Value;
        If FLength<>Size then
        Size:=FLength;
      end else
      Begin
        FLength:=0;
        Release;
      end;
    end;
  end;

  Function TJLFieldString.GetValue:AnsiString;
  Begin
    If not Empty then
    Begin
      SetLength(Result,Size);
      If Read(0,Size,pointer(@Result[1])^)<Size then
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_FailedGet,[FieldName]) else
      SignalRead;
    end else
    Result:='';
  end;

  Procedure TJLFieldString.SetValue(NewValue:AnsiString);
  var
    FLen: Integer;
  Begin
    FLen:=system.Length(NewValue);
    If FLen>0 then
    Begin
      (* cut string to length if explicit *)
      If FExplicit then
      Begin
        If FLen>FLength then
        FLen:=FLength;
      end else
      Size:=FLen;

      If FLen>0 then
      Begin
        If Write(0,FLen,NewValue[1])<FLen then
        Raise EJLRecordFieldError.CreateFmt
        (ERR_RECORDFIELD_FailedSet,[FieldName]) else
        SignalWrite;
      end else
      Release;

    end else
    Release;
  end;

  //##########################################################################
  // TJLRecordField
  //##########################################################################

  Function TJLRecordField.GetDisplayName:AnsiString;
  Begin
    Result:='Unknown';
  end;

  { Function TJLRecordField.GetParent:TSRLRecord;
  Begin
    Result:=TSRLRecord(inherited GetParent);
  end; }

  Procedure TJLRecordField.SignalWrite;
  Begin
    if not (csDestroying in ComponentState) then
    Begin
      { If  (Parent<>NIL)
      and (ISRLObject(Parent).QueryObjectState([osDestroying,osUpdating,
      osReadWrite,osSilent])=False)
      and assigned(Parent.OnFieldWrite) then
      Parent.OnFieldWrite(Parent,Self); }
    end;
  end;

  Procedure TJLRecordField.SignalRead;
  Begin
    if not (csDestroying in ComponentState) then
    Begin
      { If  (Parent<>NIL)
      and (ISRLObject(Parent).QueryObjectState([osDestroying,osUpdating,
      osReadWrite,osSilent])=False)
      and assigned(Parent.OnFieldRead) then
      Parent.OnFieldRead(Parent,Self);      }
    end;
  end;

  Procedure TJLRecordField.SignalRelease;
  Begin
    if not (csDestroying in ComponentState) then
    Begin
      { If  (Parent<>NIL)
      and (ISRLObject(Parent).QueryObjectState([osDestroying,osUpdating,
      osReadWrite,osSilent])=False)
      and assigned(Parent.OnFieldReleased) then
      Parent.OnFieldReleased(Parent,Self);  }
    end;
  end;
  
  Procedure TJLRecordField.SetFName(Value:AnsiString);
  var
    FOld: AnsiString;
  Begin
    If Value<>FName then
    Begin
      FOld:=FName;
      Value:=trim(Value);
      If system.Length(Value)>0 then
      Begin
        FName:=Value;
        Value:=LowerCase(Value);
        FNameHash:=JL_ELFHash(Value);
        (*
        If not (osSilent in ObjectState) then
        Begin
          If  (length(FOld)>0)
          and (Parent<>NIL)
          and (Parent.ObjectState=[]) then
          Begin
            if assigned(parent.OnRecordRenamed) then
            Parent.OnRecordRenamed(self,FOld,FName);
          end;
        end;
        *)
      end else
      Raise EJLRecordFieldError.CreateFmt
      (ERR_RECORDFIELD_INVALIDNAME,[Value]);
    end;
  end;

  Procedure TJLRecordField.BeforeReadObject;
  Begin
    inherited;
    FName:='';
    FNameHash:=0;
  end;

  Procedure TJLRecordField.ReadObject(Const Reader:TJLReader);
  Begin
    inherited;
    FNameHash:=Reader.ReadLong;
    FName:=Reader.ReadString;
  end;

  Procedure TJLRecordField.WriteObject(Const Writer:TJLWriter);
  Begin
    inherited;
    Writer.WriteLong(FNameHash);
    Writer.WriteString(FName);
  end;

  Function TJLRecordField.GetOffset:Integer;
  { var
    x:      Integer;
    FIndex: Integer; }
  Begin
    result:=0;
    { If Parent<>NIL then
    Begin
      FIndex:=Parent.IndexOf(self);
      If FIndex>0 then
      Begin
        for x:=0 to FIndex-1 do
        Result:=Result + Parent[x].Size;
      end;
    end;  }
  end;

  Function TJLRecordField.GetItemIndex:Integer;
  Begin
    result:=-1;
    { If Parent<>NIL then
    Result:=Parent.IndexOf(self) else
    Result:=-1;       }
  end;

  Procedure TJLRecordField.DoReleaseData;
  Begin
    inherited;
    SignalRelease;
  end;

  Initialization
  Begin
    JLRegisterRecordField(TJLFieldBoolean);
    JLRegisterRecordField(TJLFieldByte);
    JLRegisterRecordField(TJLFieldCurrency);
    JLRegisterRecordField(TJLFieldData);
    JLRegisterRecordField(TJLFieldDateTime);
    JLRegisterRecordField(TJLFieldDouble);
    JLRegisterRecordField(TJLFieldGUID);
    JLRegisterRecordField(TJLFieldInt64);
    JLRegisterRecordField(TJLFieldInteger);
    JLRegisterRecordField(TJLFieldLong);
    JLRegisterRecordField(TJLFieldString);
  end;

  Finalization
  SetLength(_FieldClasses,0);


  end.
