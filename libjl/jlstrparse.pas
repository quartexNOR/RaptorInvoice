  unit jlstrparse;

  interface

  uses sysutils, classes, contnrs;

  type

  (* Text element object. Represents one word in a phrase *)
  TJLTextElement = Class(TObject)
  Private
    FText:      String;
    FPosition:  Integer;
  protected
    Procedure   SetText(Const Value:String);virtual;
    Procedure   SetTextPos(Const Value:Integer);virtual;
  Published
    Property    Value:String read FText;
    Property    Position:Integer read FPosition;
  End;

  (* Text elements collection. Represents a string of words *)
  TJLTextElements = Class(TObject)
  Private
    FObjects:   TObjectList;
  Protected
    Function    GetItem(Index:Integer):TJLTextElement;virtual;
    Function    GetCount:Integer;virtual;
    Function    AddElement(AText:String;
                APosition:Integer):TJLTextElement;virtual;
  Public
    Property    Items[index:Integer]:TJLTextElement read GetItem;default;
    Property    Count:Integer read GetCount;
    Procedure   Delete(Index:Integer);overload;
    Procedure   Delete(Item:TJLTextElement);overload;
    Function    IndexOf(Value:String):Integer;
    Function    ObjectOf(Value:String):TJLTextElement;
    Procedure   Clear;virtual;
    Constructor Create;
    Destructor  Destroy;override;
  End;

  { Actual text divider class }
  TJLTextParser = Class(TObject)
  Private
    FText:        String;
    FObjects:     TJLTextElements;
    FDelimiter:   Char;
  Protected
    Procedure     SetDelimiter(Value:Char);virtual;
    Procedure     SetText(Value:String);virtual;
    Procedure     DelimitTextBuffer;virtual;
  Public
    Property      Text:String read FText write SetText;
    Property      Elements:TJLTextElements read FObjects;

    Class Function util_CharIsText(Const Value:Char;
                   Const IncludeSpace:Boolean=False):Boolean;

    Class Function util_TraverseText(Const Buffer;
                   Const Size:integer;
                   Const Delimiter:Char;
                   Offset:Integer):Integer;

    Class Function util_SeekChar(Const Buffer;
                   Const Size:Integer;
                   Const Offset:Integer):Integer;

    Class Function util_NextWord(Const Buffer;
                   Const Size:Integer;
                   Const Delimiter:Char;
                   Const Offset:Integer):Integer;

    Procedure     LoadFromFile(Filename:String);
    Procedure     SaveToFile(Filename:String);
    Procedure     LoadFromStream(Stream:TStream);
    Procedure     SaveToStream(Stream:TStream);
    Procedure     Clear;
    Procedure     ParseText;overload;
    Procedure     ParseText(Text:String);overload;
    Constructor   Create;virtual;
    Destructor    Destroy;Override;
  Published
    Property      Delimiter:Char read FDelimiter write SetDelimiter;
  End;

  implementation

  Const
  CNT_ERROR_TEXTPARSER_BUFFER_RANGE
  = 'Buffer range error, exptected offset %d..%d, not %d';

  //###############################################################
  // TJLTextParser
  //###############################################################

  Constructor TJLTextParser.Create;
  Begin
    inherited;
    FObjects:=TJLTextElements.Create;
    FDelimiter:=' ';
  End;

  Destructor TJLTextParser.Destroy;
  Begin
    FObjects.free;
    inherited;
  End;

  Class Function TJLTextParser.util_CharIsText(Const Value:Char;
        Const IncludeSpace:Boolean=False):Boolean;
  var
    FWork:  AnsiChar;
  Begin
    (* Take height for widestring *)
    FWork:=AnsiChar(Value);

    (* check without space *)
    if not IncludeSpace then
    result:=(FWork in [#9,#10,#13,#33..#34])
    or (FWork in [#65..#126])
    or (FWork in [#128,#162..#165])
    or (FWork in ['æ','ø','å','Æ','Ø','Å'])

    (* check with space *)
    else
    result:=(FWork in [#9,#10,#13,#32..#34])
    or (FWork in [#65..#126])
    or (FWork in [#128,#162..#165])
    or (FWork in ['æ','ø','å','Æ','Ø','Å']);
  end;


  Class Function TJLTextParser.util_TraverseText(Const Buffer;
           Const Size:integer;
           Const Delimiter:Char;
           Offset:Integer):Integer;
  Var
    FAddr:  PChar;
    x:      Integer;
  begin
    result:=-1;
    If Size>0 then
    Begin
      FAddr:=@Buffer;
      If FAddr<>NIL then
      Begin
        if (Offset>=0) and (Offset<Size) then
        Begin
          inc(FAddr,Offset);
          for x:=Offset to Size-1 do
          Begin
            if FAddr^=Delimiter then
            Begin
              result:=x;
              Break;
            end;
            inc(FAddr);
          end;
        end else
        Raise Exception.CreateFmt
        (CNT_ERROR_TEXTPARSER_BUFFER_RANGE,[0,Size-1,Offset]);
      end;
    end;
  End;

  Procedure TJLTextParser.Clear;
  Begin
    FText:='';
    FObjects.Clear;
  End;

  Procedure TJLTextParser.ParseText(Text:String);
  Begin
    { Keep new data }
    FText:=Text;

    { Process the data }
    try
      DelimitTextBuffer;
    except
      on exception do
      Raise;
    end;
  End;

  Procedure TJLTextParser.ParseText;
  Begin
    { Process current content }
    try
      DelimitTextBuffer;
    except
      on exception do
      Raise;
    end;
  End;

  Procedure TJLTextParser.LoadFromFile(Filename:String);
  var
    FStream:  TFileStream;
  Begin
    FStream:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
    try
      LoadFromStream(FStream);
    finally
      FreeAndNIL(FStream);
    end;
  End;

  Procedure TJLTextParser.SaveToFile(Filename:String);
  var
    FStream:  TFileStream;
  Begin
    FStream:=TFileStream.Create(Filename,fmCreate);
    try
      SaveToStream(FStream);
    finally
      FreeAndNIL(FStream);
    end;
  End;

  Procedure TJLTextParser.LoadFromStream(Stream:TStream);
  var
    FLen: Integer;
  Begin
    Clear;
    If Stream<>NIL then
    Begin
      FLen:=Stream.Size-Stream.Position;
      if FLen>0 then
      Begin
        try
          SetLength(FText,FLen);
          Stream.Read(FText[1],FLen);
        except
          on exception do
          Raise;
        end;
      end;
    end else
    Raise Exception.Create('Source stream is NIL error');
  End;

  Procedure TJLTextParser.SaveToStream(Stream:TStream);
  Begin
    if assigned(Stream) then
    Begin
      if length(FText)>0 then
      Begin
        try
          Stream.WriteBuffer(FText[1],Length(FText));
        except
          on exception do
          Raise;
        end;
      end;
    end else
    Raise Exception.Create('Target stream is NIL error');
  End;

  Procedure TJLTextParser.SetText(Value:String);
  Begin
    Clear;
    FText:=Value;
  end;

  Procedure TJLTextParser.SetDelimiter(Value:Char);
  Begin
    If Value<>FDelimiter then
    Begin
      if util_CharIsText(Value,true) then
      FDelimiter:=Value else
      raise Exception.Create('Invalid text delimiter error');
    end;
  end;

  Procedure TJLTextParser.DelimitTextBuffer;
  var
    Xpos:     Integer;
    AWork:    Integer;
    AText:    String;
    PBuffer:  PChar;
    FLen:     Integer;
  Begin
    { Reset work variables }
    Atext:='';
    Awork:=0;
    FObjects.Clear;

    FLen:=Length(FText);
    if FLen>0 then
    Begin
      If FDelimiter<>#0 then
      Begin
        { Get a handle on our data }
        PBuffer:=@FText[1];

        {Get the start of the first word}
        Xpos:=util_SeekChar(PBuffer^,FLen,0);
        if xpos=-1 then
        begin
          If FLen>0 then
          FObjects.AddElement(FText,1);
          exit;
        end;

        While (Xpos<FLen) do
        begin
          (* Find End of Word *)
          AWork:=util_TraverseText(PBuffer^,FLen,FDelimiter,XPos);
          If AWork>Xpos then
          Begin
            if xpos=0 then
            AText:=Copy(PBuffer,xpos,(Awork-xpos)) else
            AText:=Copy(PBuffer,xpos,(Awork-xpos)+1);
            FObjects.AddElement(AText,xpos+1);

            (* Find beginning of next word, or break out if buffer end *)
            Xpos:=AWork;
            AWork:=util_NextWord(PBuffer^,FLen,FDelimiter,Xpos);
            If AWork>Xpos then
            Xpos:=AWork else
            Break;
          end else
          break;
        end;

        if (xpos>=0) and (Awork=-1) then
        begin
          Atext:=Copy(FText,xpos,Length(FText));
          if length(AText)>0 then
          FObjects.AddElement(AText,xpos+1);
        end;
      end else
      Raise Exception.Create('Text delimiter cannot be null');
    end;
  End;

  Class Function TJLTextParser.util_SeekChar(Const Buffer;
           Const Size:Integer;
           Const Offset:Integer):Integer;
  var
    x:      Integer;
    FAddr:  PChar;
  Begin
    Result:=-1;
    FAddr:=@Buffer;
    If FAddr<>NIL then
    Begin
      If Size>0 then
      Begin
        If (Offset>=0) and (Offset<Size) then
        Begin
          inc(FAddr,Offset);
          for x:=Offset to Size-1 do
          Begin
            If util_CharIsText(FAddr^) then
            Begin
              result:=x;
              Break;
            end;
            inc(FAddr);
          end;
        end else
        Raise Exception.CreateFmt
        (CNT_ERROR_TEXTPARSER_BUFFER_RANGE,[0,Size-1,Offset]);
      end;
    end;
  End;

  Class Function TJLTextParser.util_NextWord(Const Buffer;
           Const Size:Integer;
           Const Delimiter:Char;
           Const Offset:Integer):Integer;
  Var
    FAddr:  PChar;
    x:      Integer;
  begin
    result:=-1;
    If Size>0 then
    Begin
      FAddr:=@Buffer;
      If FAddr<>NIL then
      Begin
        if (Offset>=0) and (Offset<Size) then
        Begin
          inc(FAddr,Offset);
          for x:=Offset to Size-1 do
          Begin
            if (FAddr^<>Delimiter)
            and util_CharIsText(FAddr^) then
            Begin
              result:=x;
              Break;
            end;
            inc(FAddr);
          end;
        end else
        Raise Exception.CreateFmt
        (CNT_ERROR_TEXTPARSER_BUFFER_RANGE,[0,Size-1,Offset]);
      end;
    end;
  End;

  //###############################################################
  // TJLTextElement
  //###############################################################

  Procedure TJLTextElement.SetText(Const Value:String);
  Begin
    FText:=Value;
  end;

  Procedure TJLTextElement.SetTextPos(Const Value:Integer);
  Begin
    FPosition:=Value;
  end;

  //###############################################################
  // TJLTextElements
  //###############################################################

  Constructor TJLTextElements.Create;
  Begin
    inherited;
    FObjects:=TObjectList.Create(True);
  End;

  Destructor TJLTextElements.Destroy;
  Begin
    FObjects.free;
    inherited;
  End;

  Procedure TJLTextElements.Clear;
  Begin
    FObjects.Clear;
  End;

  Function TJLTextElements.IndexOf(Value:String):Integer;
  var
    x:  Integer;
  Begin
    result:=-1;
    for x:=1 to FObjects.Count do
    begin
      If Items[x-1].Value=Value then
      begin
        result:=(x-1);
        Break;
      end;
    end;
  End;

  Function TJLTextElements.ObjectOf(Value:String):TJLTextElement;
  var
    x:  Integer;
  Begin
    result:=NIL;
    for x:=1 to FObjects.Count do
    begin
      If Items[x-1].Value=Value then
      begin
        result:=Items[x-1];
        Break;
      end;
    end;
  End;

  Function TJLTextElements.GetItem(Index:Integer):TJLTextElement;
  Begin
    result:=TJLTextElement(FObjects[index]);
  End;

  Function TJLTextElements.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  End;

  Procedure TJLTextElements.Delete(Index:Integer);
  Begin
    FObjects.Delete(Index);
  End;

  Procedure TJLTextElements.Delete(Item:TJLTextElement);
  var
    FIndex: Integer;
  Begin
    If Item<>NIL then
    Begin
      FIndex:=FObjects.IndexOf(Item);
      If (FIndex>=0) and (FIndex<FObjects.Count) then
      FObjects.Delete(FIndex);
    end;
  End;

  Function TJLTextElements.AddElement(AText:String;
           APosition:Integer):TJLTextElement;
  Begin
    { Create a new text element }
    Result:=TJLTextElement.Create;
    Result.SetText(AText);
    result.SetTextPos(APosition);

    { add element to collection }
    try
      FObjects.Add(Result);
    except
      on exception do
      Begin
        FreeAndNIL(Result);
        Raise;
      end;
    end;

  end;

  end.
