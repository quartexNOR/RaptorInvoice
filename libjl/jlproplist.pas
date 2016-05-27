  unit jlproplist;

  interface

  uses sysutils, classes, variants,
  jlcommon, jldatabuffer;

  type

  TJLCustomPropList = Class(TJLCommonComponent)
  Private
    FData:      TStringList;
    Function    GetCount:Integer;
  Protected
    Function    ObjectHasData:Boolean;override;
    Procedure   BeforeReadObject;override;
    Procedure   ReadObject(Const Reader:TJLReader);override;
    Procedure   WriteObject(Const Writer:TJLWriter);override;
  Protected
    Property    Count:Integer read GetCount;
  Public
    Procedure   Clear;
    Function    Add(PropName:String):Boolean;
    Function    Delete(PropName:String):Boolean;
    Function    Read(PropName:String):Variant;
    Procedure   Write(PropName:String;Value:Variant);

    Procedure   SaveToStream(Stream:TStream);
    procedure   LoadFromStream(Stream:TStream);
    Procedure   LoadFromFile(Filename:String);
    Procedure   SaveToFile(Filename:String);

    Procedure   BeforeDestruction;Override;
    Constructor Create(AOwner:TComponent);override;
    Destructor  Destroy;Override;
  End;

  TJLPropList = Class(TJLCustomPropList)
  Public
    Property  Count;
  End;

  implementation

  //##########################################################################
  // TJLCustomPropList
  //##########################################################################

  Constructor TJLCustomPropList.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FData:=TStringList.Create;
  end;

  Destructor TJLCustomPropList.Destroy;
  Begin
    FData.free;
    inherited;
  end;

  Procedure TJLCustomPropList.BeforeDestruction;
  Begin
    inherited;
    if ObjectHasData then
    Clear;
  end;

  Procedure TJLCustomPropList.SaveToStream(Stream:TStream);
  var
    FWriter:  TJLWriter;
  Begin
    FWriter:=TJLWriterStream.Create(Stream);
    try
      BeforeWriteObject;
      try
        WriteObject(FWriter);
      finally
        AfterWriteObject;
      end;
    finally
      FWriter.free;
    end;
  end;

  procedure TJLCustomPropList.LoadFromStream(Stream:TStream);
  var
    FReader:  TJLReader;
  Begin
    FReader:=TJLReaderStream.Create(Stream);
    try
      BeforeReadObject;
      try
        ReadObject(FReader);
      finally
        AfterReadObject;
      end;
    finally
      FReader.free;
    end;
  end;

  Procedure TJLCustomPropList.LoadFromFile(Filename:String);
  var
    FStream:  TFileStream;
  Begin
    FStream:=TFileStream.Create(Filename,fmOpenRead);
    try
      LoadFromStream(FStream);
    finally
      FStream.free;
    end;
  end;

  Procedure TJLCustomPropList.SaveToFile(Filename:String);
  var
    FStream:  TFileStream;
  Begin
    FStream:=TFileStream.Create(Filename,fmCreate);
    try
      SaveToStream(FStream);
    finally
      FStream.free;
    end;
  end;

  Function TJLCustomPropList.GetCount:Integer;
  Begin
    result:=FData.count;
  End;
  
  Function TJLCustomPropList.Read(PropName:String):Variant;
  var
    FIndex:   Integer;
    FTemp:    TJLBufferMemory;
    FReader:  TJLReader;
  Begin
    PropName:=trim(lowercase(propName));
    result:=Length(propname)>0;
    if result then
    Begin
      FIndex:=FData.IndexOf(propname);
      Result:=FIndex>=0;
      if result then
      Begin
        FTemp:=TJLBufferMemory(FData.Objects[FIndex]);
        Result:=FTemp.MakeReader(FReader);
        If result then
        Begin
          try
            result:=FReader.ReadVariant;
          finally
            FReader.free;
          end;
        end;
      end;
    end;
  end;

  Procedure TJLCustomPropList.Write(PropName:String;Value:Variant);
  var
    FIndex:   Integer;
    FTemp:    TJLBufferMemory;
    FWriter:  TJLWriter;
  Begin
    PropName:=trim(lowercase(propName));
    if Length(propname)>0 then
    Begin
      FIndex:=FData.IndexOf(propname);
      if FIndex<0 then
      Begin
        (* add property automatically *)
        if Add(propname) then
        FIndex:=FData.IndexOf(propname);
      end;

      if FIndex>=0 then
      Begin
        FTemp:=TJLBufferMemory(FData.Objects[FIndex]);
        FTemp.Release;
        if FTemp.MakeWriter(FWriter) then
        Begin
          try
            FWriter.WriteVariant(Value);
          finally
            FWriter.free;
          end;
        end;
      end;
    end;
  end;

  Function TJLCustomPropList.Add(PropName:String):Boolean;
  var
    FTemp:  TJLBufferMemory;
  Begin
    PropName:=trim(lowercase(propName));
    result:=Length(propname)>0;
    if result then
    Begin
      result:=FData.IndexOf(propname)<0;
      if result then
      Begin
        FTemp:=TJLBufferMemory.Create(NIL);
        FData.AddObject(PropName,FTemp);
      end;
    end;
  end;

  Function TJLCustomPropList.Delete(PropName:String):Boolean;
  var
    FIndex: Integer;
    FTemp:  TJLBufferMemory;
  Begin
    PropName:=trim(lowercase(propName));
    result:=Length(propname)>0;
    if result then
    Begin
      FIndex:=FData.IndexOf(propname);
      Result:=FIndex>=0;
      if result then
      Begin
        FTemp:=TJLBufferMemory(FData.Objects[FIndex]);
        FreeAndNil(FTemp);
        FData.Objects[FIndex]:=NIL;
        FData.Delete(FIndex);
      end;
    end;
  end;

  Function TJLCustomPropList.ObjectHasData:Boolean;
  Begin
    result:=FData.Count>0;
  end;

  Procedure TJLCustomPropList.Clear;
  var
    x:      Integer;
    FTemp:  TJLBufferMemory;
  Begin
    if FData.Count>0 then
    Begin
      try
        for x:=1 to FData.Count do
        Begin
          FTemp:=TJLBufferMemory(FData.Objects[x-1]);
          FreeAndNil(FTemp);
          FData.Objects[x-1]:=NIL;
        end;
      finally
        FData.Clear;
      end;
    end;
  end;
  
  Procedure TJLCustomPropList.BeforeReadObject;
  Begin
    Clear;
  end;

  Procedure TJLCustomPropList.ReadObject(Const Reader:TJLReader);
  var
    FCount: Integer;
    FName:  AnsiString;
    FTemp:  TJLBufferMemory;
    FRaw:   TStream;
  Begin
    inherited;
    FCount:=Reader.ReadInt;
    If FCount>0 then
    Begin
      While FCount>0 do
      Begin
        FName:=Reader.ReadString;
        FTemp:=TJLBufferMemory.Create(NIL);

        FRaw:=Reader.ReadStream;
        try
          FTemp.ContentFromStream(FRaw);
        finally
          FRaw.free;
        end;

        FData.AddObject(FName,FTemp);
        dec(FCount);
      end;
    end;
  end;

  Procedure TJLCustomPropList.WriteObject(Const Writer:TJLWriter);
  var
    x:      Integer;
    FTemp:  TJLBufferMemory;
    FRaw:   TStream;
  Begin
    inherited;
    Writer.WriteInt(FData.Count);
    if FData.Count>0 then
    Begin
      for x:=1 to FData.Count do
      Begin
        Writer.WriteString(FData[x-1]);
        FTemp:=TJLBufferMemory(FData.Objects[x-1]);
        FRaw:=FTemp.toStream;
        try
          FRaw.Position:=0;
          Writer.WriteStream(FRaw,False);
        finally
          FRaw.free;
        end;
      end;
    end;
  end;
  
  end.
