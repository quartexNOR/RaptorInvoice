  unit jllanguage;

  interface

  uses
  sysutils, classes, inifiles, syncobjs;

  Const
  CNT_JL_LANGUAGEFILE_MACRO_BEGIN = '{';
  CNT_JL_LANGUAGEFILE_MACRO_END   = '}';
  CNT_JL_LANGUAGEFILE_LINEFEED    = '|';
  CNT_JL_LANGUAGEFILE_NAMESTOP    = ':';

  type

  TJLLanguageFile = Class(TComponent)
  Private
    FLock:      TCriticalSection;
    FLanguage:  TInifile;
    FFilename:  TFileName;
  Protected
    Function    GetActive:Boolean;
    Procedure   SetActive(Value:Boolean);
    Procedure   SetFileName(Value:TFileName);
    Function    IniFormat(IniFile:TCustomIniFile;
                Value:String):String;
  Public
    Function    ReadStr(Section,Ident,DefValue:String):String;
    Function    ReadInt(Section,Ident:String;DefValue:Integer):Integer;
    Function    ReadCurr(Section,Ident:String;DefValue:Currency):Currency;
    Function    FormatLangStr(Value:String):String;
    Function    Open(Filename:String):Boolean;
    Function    Close:Boolean;
  Published
    Property    Filename:TFilename read FFilename write SetFileName;
    Property    Enabled:Boolean read GetActive write SetActive;
    Constructor Create(AOwner:TComponent);override;
    Destructor  Destroy;Override;
  End;

  implementation

  //###########################################################################
  // TJLLanguageFile
  //###########################################################################

  Constructor TJLLanguageFile.Create(AOwner:TComponent);
  Begin
    inherited Create(Aowner);
    FLock:=TCriticalSection.Create;
    FLanguage:=NIL;
  end;

  Destructor TJLLanguageFile.Destroy;
  Begin
    FLock.Enter;
    try
      if FLanguage<>NIl then
      FreeAndNIL(FLanguage);
    finally
      FLock.Leave;
    end;

    FreeAndNIL(FLock);
    inherited;
  end;

  Function TJLLanguageFile.GetActive:Boolean;
  Begin
    FLock.Enter;
    try
      result:=assigned(FLanguage);
    finally
      FLock.Leave;
    end;
  end;

  Procedure TJLLanguageFile.SetActive(Value:Boolean);
  Begin
    If Value<>GetActive then
    Begin
      Close;
      if Value then
      Open(FFilename);
    end;
  end;

  Procedure TJLLanguageFile.SetFileName(Value:TFilename);
  Begin
    if (csDesigning in ComponentState) then
    FFilename:=Value else
    Begin
      If not GetActive then
      FFileName:=Value else
      Raise Exception.Create
      ('Filename can not be changed in active component');
    end;
  end;

  Function TJLLanguageFile.IniFormat(IniFile:TCustomIniFile;
           Value:String):String;
  var
    x,y:    Integer;
    FLen:   Integer;
    FEnd:   Integer;
    FName:  String;
    FSec:   String;
  Begin
    Value:=trim(Value);
    Flen:=Length(Value);
    SetLength(result,0);
    If FLen>0 then
    Begin
      x:=0;
      while x<FLen do
      Begin
        inc(x);
        
        if Value[x]=CNT_JL_LANGUAGEFILE_MACRO_BEGIN then
        Begin
          (* locate end of macro *)
          FEnd:=0;
          for y:=x+1 to FLen do
          Begin
            if value[y]=CNT_JL_LANGUAGEFILE_MACRO_END then
            Begin
              FEnd:=y;
              Break;
            end;
          end;

          if FEnd>0 then
          Begin

            FName:=Copy(Value,x+1,(y-x)-1);
            x:=y;

            y:=pos(CNT_JL_LANGUAGEFILE_NAMESTOP,FName);
            if y>0 then
            Begin
              FSec:=Copy(FName,1,y-1);
              Delete(FName,1,y);
              result:=result + IniFile.ReadString(FSec,FName,'');
            end else
            result:=result + CNT_JL_LANGUAGEFILE_MACRO_BEGIN
            + FName + CNT_JL_LANGUAGEFILE_MACRO_END;

          end else
          result:=result + Value[x];
        end else
        result:=result + Value[x];
      end;
    end;
  end;

  Function TJLLanguageFile.Open(Filename:String):Boolean;
  Begin
    result:=FileExists(Filename);
    If result then
    Begin
      FLock.Enter;
      try
        result:=False;

        (* release previous language data *)
        if assigned(Flanguage) then
        FreeAndNil(Flanguage);

        try
          Flanguage:=TIniFile.Create(Filename);
          result:=True;
        except
          on exception do
          exit;
        end;

      finally
        FLock.Leave;
      end;
    end;
  end;

  Function TJLLanguageFile.Close:Boolean;
  Begin
    FLock.Enter;
    try
      result:=assigned(Flanguage);
      If result then
      FreeAndNIL(Flanguage);
    finally
      FLock.Leave;
    end;
  end;

  Function TJLLanguageFile.FormatLangStr(Value:String):String;
  Begin
    FLock.Enter;
    try
      If Flanguage<>NIL then
      Begin
        if pos(CNT_JL_LANGUAGEFILE_MACRO_BEGIN,result)>0 then
        result:=IniFormat(Flanguage,result) else
        result:=Value;
      end else
      result:=Value;
    finally
      FLock.Leave;
    end;
  end;

  Function TJLLanguageFile.ReadStr(Section,Ident,DefValue:String):String;
  Begin
    FLock.Enter;
    try
      If Flanguage<>NIL then
      Begin
        result:=Flanguage.ReadString(Section,Ident,DefValue);

        (* add support for extended formating *)
        if pos(CNT_JL_LANGUAGEFILE_MACRO_BEGIN,result)>0 then
        result:=IniFormat(Flanguage,result);

        if pos(CNT_JL_LANGUAGEFILE_LINEFEED,result)>0 then
        result:=StringReplace(result,CNT_JL_LANGUAGEFILE_LINEFEED,
        #13,[rfReplaceAll]);

      end else
      result:=DefValue;
    finally
      FLock.Leave;
    end;
  end;

  Function TJLLanguageFile.ReadInt(Section,Ident:String;
           DefValue:Integer):Integer;
  Begin
    FLock.Enter;
    try
      If Flanguage<>NIL then
      result:=Flanguage.ReadInteger(Section,Ident,DefValue) else
      result:=DefValue;
    finally
      FLock.Leave;
    end;
  end;

  Function TJLLanguageFile.ReadCurr(Section,Ident:String;
           DefValue:Currency):Currency;
  Begin
    FLock.Enter;
    try
      If Flanguage<>NIL then
      result:=FLanguage.ReadFloat(section,ident,defvalue) else
      result:=DefValue;
    finally
      FLock.Leave;
    end;
  end;
  
  end.
