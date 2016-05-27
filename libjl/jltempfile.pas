  unit jltempfile;

  interface

  uses sysutils, classes, syncobjs, jlcommon;

  type

  TJLTempFile = Class(TComponent)
  Private
    FFile:      TStream;
    FFilename:  String;
    FEnabled:   Boolean;
    FEnLock:    TSimpleRWSync;
    FLock:      TCriticalSection;
    FOnMake:    TNotifyEvent;
    FOnRelease: TNotifyEvent;
    Function    GetEnabled:Boolean;
    Procedure   SetEnabledValue(Value:Boolean);
    Procedure   SetEnabled(Value:Boolean);
  Protected
    Procedure   MakeStream;
    Procedure   ReleaseStream;
  Public
    Property    Filename:String read FFileName;
    Property    Stream:TStream read FFile;
    Function    LockFile(out Stream:TStream):Boolean;
    Procedure   UnLockFile;
    Procedure   BeforeDestruction;Override;
    Procedure   Loaded;Override;
    Constructor Create(AOwner:TComponent);Override;
    Destructor  Destroy;Override;
  Published
    Property    Enabled:Boolean read GetEnabled write SetEnabled;

    Property    OnFileOpen:TNotifyEvent
                read FOnMake write FOnMake;

    Property    OnFileClosed:TNotifyEvent
                read FOnRelease write FOnRelease;
  End;

  implementation

  Constructor TJLTempFile.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FLock:=TCriticalSection.Create;
    FEnLock:=TSimpleRWSync.Create;
  end;

  Destructor  TJLTempFile.Destroy;
  Begin
    FLock.free;
    FEnLock.free;
    inherited;
  end;

  Procedure TJLTempFile.Loaded;
  Begin
    inherited;
    if GetEnabled then
    Begin
      SetEnabledValue(False);
      MakeStream;
    end;
  end;

  Procedure TJLTempFile.BeforeDestruction;
  Begin
    (* Release the filestream *)
    ReleaseStream;
    inherited;
  end;

  Function TJLTempFile.LockFile(out Stream:TStream):Boolean;
  Begin
    Result:=GetEnabled;
    if result then
    Begin
      FLock.Enter;
      Stream:=FFile;
    end;
  end;

  Procedure TJLTempFile.UnLockFile;
  Begin
    FLock.Leave;
  end;

  Procedure TJLTempFile.ReleaseStream;
  Begin
    if not (csDesigning in ComponentState) then
    Begin
      FLock.Enter;
      try
        (* Release the stream object *)
        If (FFile<>NIL) then
        FreeAndNil(FFile);

        (* delete the file *)
        if (length(FFilename)>0)
        and FileExists(FFilename) then
        Begin
          DeleteFile(FFilename);
          SetLength(FFilename,0);
        end;
      finally
        FLock.Leave;
      end;

      (* Signal release event *)
      if assigned(FOnRelease)
      and not (csDestroying in ComponentState) then
      FOnRelease(Self);
    end;
  end;

  Procedure TJLTempFile.MakeStream;
  Begin
    if not (csDesigning in ComponentState)
    and not (csLoading in ComponentState) then
    Begin
      FLock.Enter;
      try

        (* Generate temp filename *)
        FFileName:=JL_GetTempFileName;

        (* Create stream object *)
        try
          FFile:=TFileStream.Create(FFilename,fmCreate);
        except
          on exception do
          Begin
            SetLength(FFilename,0);
            Raise;
          end;
        end;
        
      finally
        FLock.Leave;
      end;

      (* Signal Create event *)
      if assigned(FOnMake)
      and not (csLoading in ComponentState) then
      FOnMake(Self);
    end;
  end;

  Function TJLTempFile.GetEnabled:Boolean;
  Begin
    FEnLock.BeginRead;
    try
      Result:=FEnabled;
    finally
      FEnLock.EndRead;
    end;
  end;

  Procedure TJLTempFile.SetEnabledValue(Value:Boolean);
  Begin
    FEnLock.BeginWrite;
    try
      FEnabled:=Value;
    finally
      FEnLock.EndWrite;
    end;
  end;

  Procedure TJLTempFile.SetEnabled(Value:Boolean);
  Begin
    if Value<>GetEnabled then
    Begin
      (* delete any stream already present *)
      If GetEnabled then
      Begin
        ReleaseStream;
        SetEnabledValue(False);
      end;

      (* create new stream of Active *)
      If Value then
      MakeStream;

      (* Save state *)
      SetEnabledValue(Value);
    end;
  end;


  end.
