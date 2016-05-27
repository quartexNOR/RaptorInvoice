  unit hexpropbag;

  interface

  Uses windows, sysutils, classes, registry, controls,
  hexencrypt, hexmime, hexbase, hexcab;

  Const
  ERR_HEX_FailedReadProperty  = 'Failed to read property: %s';
  ERR_HEX_FailedWriteProperty = 'Failed to write property: %s';

  Type

  EHexPropertyBag           = Class(EHexException);
  EHexFailedReadProperty    = Class(EHexPropertyBag);
  EHexFailedWriteProperty   = Class(EHexPropertyBag);

  THexPropertyBag = Class(THexCustomComponent)
  Private
    FData:      TStringlist;
    Function    EncodeValue(Value:String):String;
    Function    DecodeValue(Value:String):String;
    Function    GetEmpty:Boolean;
    Function    GetCount:Integer;
    Function    GetValue(index:Integer):String;
    Function    BinStreamToString(Stream:TStream):String;
    Function    BinStringToStream(Value:String):TStream;
    Function    ConvertToBinString(Value:String):String;
    Function    ConvertFromBinString(Value:String):String;
  Public
    Property    Empty:Boolean read GetEmpty;
    Property    Count:Integer read GetCount;
    Property    Properties[index:Integer]:String read GetValue;

    Procedure   WriteBoolean(AName:String;Value:Boolean);
    Procedure   WriteInteger(AName:String;Value:Integer);
    Procedure   WriteString(AName:String;Value:String);
    Procedure   WriteDate(AName:String;Value:TDate);
    Procedure   WriteStream(AName:String;Value:TStream);

    Function    ReadStream(AName:String):TStream;
    Function    ReadDate(AName:String):TDate;
    Function    ReadInteger(AName:String):Integer;
    Function    ReadBoolean(AName:String):Boolean;
    Function    ReadString(AName:String):String;

    Function    ToString:String;
    Procedure   SaveToStream(Stream:TStream);
    Procedure   SaveToFile(Const Filename:String);
    Procedure   SaveToCab(Const Token:String;Cab:THexCabinet);
    Procedure   LoadFromCab(Const Token:String;Cab:THexCabinet);
    Procedure   LoadFromFile(Const Filename:String);
    Procedure   LoadFromStream(Stream:TStream);
    Procedure   SaveToRegistry(Key:HKey;Path,KeyName:String);
    Procedure   LoadFromRegistry(Key:HKey;Path,KeyName:String);
    Procedure   Assign(Source: TPersistent);override;
    Procedure   Clear;
    Constructor Create(AOwner:TComponent);Override;
    Destructor  Destroy;Override;
  End;

  implementation

  Constructor THexPropertyBag.Create(AOwner:TComponent);
  begin
    inherited Create(AOwner);
    FData:=TStringList.Create;
  end;

  Destructor THexPropertyBag.Destroy;
  begin
    FData.free;
    inherited;
  end;

  Function THexPropertyBag.ConvertToBinString(Value:String):String;
  var
    x:  Integer;
  Begin
    result:='';
    for x:=1 to length(Value) do
    result:=result + IntToHex(Byte(Value[x]),2);
  end;

  Function THexPropertyBag.ConvertFromBinString(Value:String):String;
  var
    x:    Integer;
    FSeg: String;
  Begin
    result:='';
    x:=1;
    while x<length(value) do
    begin
      FSeg:=Copy(Value,x,2);
      inc(x,2);
      result:=result + chr(StrToInt('$' + FSeg));
    end;
  end;

  Function THexPropertyBag.BinStreamToString(Stream:TStream):String;
  var
    x:      Integer;
    FData:  Char;
  Begin
    Stream.seek(0,0);
    for x:=1 to Stream.Size do
    Begin
      Stream.Read(PChar(@FData)^,1);
      result:=result + IntToHex(byte(FData),2);
    end;
  end;

  Function THexPropertyBag.BinStringToStream(Value:String):TStream;
  var
    x:      Integer;
    FData:  Char;
  Begin
    result:=TMemoryStream.Create;
    x:=1;
    while x<Length(Value) do
    Begin
      FData:=chr(StrToInt('$' + copy(value,x,2)));
      result.write(pointer(@FData)^,1);
      inc(x,2);
    end;
    result.seek(0,0);
  end;

  Procedure THexPropertyBag.WriteDate(AName:String;Value:TDate);
  Begin
    try
      FData.Values[AName]:=EncodeValue(DateToStr(Value));
    except
      on  e: exception do
      raise EHexFailedWriteProperty.Create(
      ExceptFormat
        (
        'SetProperty()',
        e.message
        ));
    end;
  end;

  Procedure THexPropertyBag.WriteStream(AName:String;Value:TStream);
  Begin
    try
      FData.Values[AName]:=BinStreamToString(Value);
    except
      on  e: exception do
      raise EHexFailedWriteProperty.Create(
      ExceptFormat
        (
        'SetProperty()',
        e.message
        ));
    end;
  end;

  Function THexPropertyBag.ReadStream(AName:String):TStream;
  Begin
    try
      result:=BinStringToStream(FData.Values[AName]);
    except
      on  e: exception do
      raise EHexFailedReadProperty.Create(
      ExceptFormat
        (
        'SetProperty()',
        e.message
        ));
    end;
  end;

  Function THexPropertyBag.ReadDate(AName:String):TDate;
  Begin
    try
      result:=StrToDate(DecodeValue(FData.Values[AName]));
    except
      on  e: exception do
      raise EHexFailedReadProperty.Create(
      ExceptFormat
        (
        'SetProperty()',
        e.message
        ));
    end;
  end;

  Procedure THexPropertyBag.SaveToCab(Const Token:String;Cab:THexCabinet);
  var
    FTemp:  TMemoryStream;
  Begin
    FTemp:=TmemoryStream.Create;
    try
      FData.SaveToStream(FTemp);
      FTemp.Seek(0,0);

      try
        Cab.StoreStream(Token,FTemp);
      except
        on exception do
        raise;
      end;

    finally
      FTemp.Free;
    end;
  End;

  Procedure THexPropertyBag.LoadFromCab(Const Token:String;Cab:THexCabinet);
  var
    FTemp:  TMemoryStream;
  Begin
    FTemp:=TmemoryStream.Create;
    try

      { load the data from the cabinet }
      try
        Cab.ExtractToStream(Token,FTemp);
      except
        on exception do
        Begin
          raise;
          exit;
        end;
      end;

      { load the data from our stream }
      FTemp.Seek(0,0);
      FData.LoadFromStream(FTemp);

    finally
      FTemp.Free;
    end;
  End;

  Procedure THexPropertyBag.LoadFromFile(Const Filename:String);
  Begin
    FData.LoadFromFile(filename);
  end;

  Procedure THexPropertyBag.LoadFromStream(Stream:TStream);
  Begin
    FData.LoadFromStream(stream);
  end;

  Procedure THexPropertyBag.SaveToRegistry(Key:HKey;Path,KeyName:String);
  var
    FReg:   TRegistry;
    FText:  String;
  Begin
    FReg:=TRegistry.Create;
    try
      FReg.RootKey:=Key;
      if FReg.OpenKey(path,true) then
      Begin
        try
          FText:=FData.Text;
          FReg.WriteBinaryData(keyname,pointer(@FText[1])^,length(FText));
        finally
          FReg.CloseKey;
        end;
      end;
    finally
      FReg.free;
    end;
  end;

  Procedure THexPropertyBag.LoadFromRegistry(Key:HKey;Path,KeyName:String);
  var
    FReg:   TRegistry;
    FText:  String;
    FInfo:  TRegDataInfo;
  Begin
    FReg:=TRegistry.Create;
    try
      FReg.RootKey:=Key;
      if FReg.OpenKey(path,false) then
      Begin
        try
          if FReg.GetDataInfo(keyname,FInfo) then
          Begin
            setlength(FText,FInfo.DataSize);
            FReg.ReadBinaryData(KeyName,pointer(@FText[1])^,FInfo.DataSize);
            FData.Text:=FText;
          end;
        finally
          FReg.CloseKey;
        end;
      end;
    finally
      FReg.free;
    end;
  end;

  Function THexPropertyBag.GetEmpty:Boolean;
  Begin
    result:=Length(FData.Text)=0;
  end;

  Procedure THexPropertyBag.Clear;
  Begin
    FData.Clear;
  end;

  Function THexPropertyBag.ToString:String;
  Begin
    result:=FData.Text;
  end;

  Procedure THexPropertyBag.SaveToStream(Stream:TStream);
  Begin
    FData.SaveToStream(Stream);
  end;

  Procedure THexPropertyBag.SaveToFile(Const Filename:String);
  Begin
    FData.SaveToFile(filename);
  end;

  Function THexPropertyBag.GetCount:Integer;
  Begin
    result:=FData.Count;
  end;

  Function THexPropertyBag.GetValue(index:Integer):String;
  Begin
    result:=FData.Names[index];
  end;

  Function THexPropertybag.EncodeValue(Value:String):String;
  var
    x:  Integer;
  begin
    result:='';
    
    { url encode it }
    for x:=1 to length(value) do
    begin
      case char(value[x]) of
      #00:  result:=result + '%00';
      #32:  result:=result + '%32';
      '/':  result:=result + '%2f';
      '?':  result:=result + '%3F';
      '!':  result:=result + '%21';
      '@':  result:=result + '%40';
      '\':  result:=result + '%5C';
      '#':  result:=result + '%23';
      '$':  result:=result + '%24';
      '^':  result:=result + '%5E';
      '&':  result:=result + '%26';
      '%':  result:=result + '%25';
      '*':  result:=result + '%2A';
      '(':  result:=result + '%28';
      ')':  result:=result + '%29';
      '}':  result:=result + '%7D';
      ':':  result:=result + '%3A';
      ',':  result:=result + '%2C';
      '{':  result:=result + '%7B';
      '+':  result:=result + '%2B';
      '.':  result:=result + '%2E';
      '-':  result:=result + '%2D';
      '~':  result:=result + '%7E';
      '[':  result:=result + '%5B';
      '_':  result:=result + '%5F';
      ']':  result:=result + '%5D';
      '`':  result:=result + '%60';
      '=':  result:=result + '%3D';
      '"':  result:=result + '%27';
      else
        result:=result + value[x];
      end;
    end;

    result:=ConvertToBinString(Result);
  end;

  Function THexPropertyBag.DecodeValue(Value:String):String;
  var
    x:    Integer;
    FSeg: String;
  begin
    Value:=ConvertFromBinString(Value);

    x:=0;
    while x<length(Value) do
    begin
      inc(x);

      If value[x]='%' then
      Begin
        FSeg:=Copy(Value,x,3);
        inc(x,2);

        if fseg='%00' then result:=result + #00 else
        if FSeg='%2f' then result:=result + '/' else
        if FSeg='%3F' then result:=result + '?' else
        if FSeg='%21' then result:=result + '!' else
        if FSeg='%40' then result:=result + '@' else
        if FSeg='%5C' then result:=result + '\' else
        if FSeg='%23' then result:=result + '#' else
        if FSeg='%24' then result:=result + '$' else
        if fseg='%5E' then result:=result + '^' else
        if fseg='%26' then result:=result + '&' else
        if fseg='%25' then result:=result + '%' else
        if fseg='%2A' then result:=result + '*' else
        if fseg='%28' then result:=result + '(' else
        if fseg='%29' then result:=result + ')' else
        if fseg='%7D' then result:=result + '}' else
        if fseg='%3A' then result:=result + ':' else
        if fseg='%2C' then result:=result + ',' else
        if fseg='%7B' then result:=result + '{' else
        if fseg='%2B' then result:=result + '+' else
        if fseg='%2E' then result:=result + '.' else
        if fseg='%2D' then result:=result + '-' else
        if fseg='%7E' then result:=result + '~' else
        if fseg='%5B' then result:=result + '[' else
        if fseg='%5F' then result:=result + '_' else
        if fseg='%5D' then result:=result + ']' else
        if fseg='%60' then result:=result + '`' else
        if fseg='%3D' then result:=result + '=' else
        if fseg='%32' then result:=result + ' ' else
        if fseg='%27' then result:=result + '"';
      end else
      result:=result + value[x];
    end;
  end;

  Procedure THexPropertyBag.Assign(Source: TPersistent);
  var
    FData:  TStringStream;
  Begin
    FData:=TStringStream.Create(THexPropertyBag(Source).ToString);
    try
      FData.Seek(0,0);
      LoadFromStream(FData);
    finally
      FData.free;
    end;
  end;

  Procedure THexPropertyBag.WriteBoolean(AName:String;Value:Boolean);
  Begin
    try
      If value then
      FData.Values[AName]:='True' else
      FData.Values[AName]:='False';
    except
      on  e: exception do
      raise EHexFailedWriteProperty.Create(
      ExceptFormat
        (
        'SetProperty()',
        e.message
        ));
    end;
  end;

  Procedure THexPropertyBag.WriteInteger(AName:String;Value:Integer);
  Begin
    try
      FData.Values[AName]:=EncodeValue(IntToStr(Value));
    except
      on  e: exception do
      raise EHexFailedWriteProperty.Create(
      ExceptFormat
        (
        'SetProperty()',
        e.message
        ));
    end;
  end;

  Procedure THexPropertyBag.WriteString(AName:String;Value:String);
  Begin
    try
      FData.Values[AName]:=EncodeValue(Value);
    except
      on  e: exception do
      raise EHexFailedWriteProperty.Create(
      ExceptFormat
        (
        'SetProperty()',
        e.message
        ));
    end;
  end;

  Function THexPropertyBag.ReadInteger(AName:String):Integer;
  Begin
    try
      result:=StrToInt(DecodeValue(FData.Values[Aname]));
    except
      on  e: exception do
      raise EHexFailedReadProperty.Create(
      ExceptFormat
        (
        'AsInteger()',
        e.message
        ));
    end;
  end;

  Function THexPropertyBag.ReadBoolean(AName:String):Boolean;
  Begin
    try
      result:=(FData.Values[AName]='True');
    except
      on  e: exception do
      raise EHexFailedReadProperty.Create(
      ExceptFormat
        (
        'AsBoolean()',
        e.message
        ));
    end;
  end;

  Function THexPropertyBag.ReadString(AName:String):String;
  Begin
    try
      result:=DecodeValue(FData.Values[AName]);
    except
      on  e: exception do
      raise EHexFailedReadProperty.Create(
      ExceptFormat
        (
        'AsString()',
        e.message
        ));
    end;
  end;

  end.
 