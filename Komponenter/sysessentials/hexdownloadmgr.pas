  unit hexdownloadmgr;

  Interface

  uses Forms, Windows,SysUtils, Classes, contnrs, wininet, syncobjs,
  comobj, hexbase, hexmoniker;

  Const
  ERR_HEX_DownloadAllreadyActive  = 'Download prosess is already active error';

  Type
  { Base exception }
  EHexDownloadManager       = Class(EHEXException);

  { exceptions for THexDownloadManager }
  EHexDownloadAlreadyActive = Class(EHexDownloadManager);

  { Forward declarations }
  THexDownloadManager       = Class;
  THexDownload              = Class;

  THexDownloadCompleteEvent = Procedure (Sender:TObject;Download:THexDownload) of Object;
  THexDownloadProgressEvent = Procedure (Sender:TObject;Download:THexDownload;APos:LongInt;ATotal:Longint) of Object;
  THexDownloadFailedEvent   = Procedure (Sender:TObject;Download:THexDownload) of Object;
  THexDownloadAddedEvent    = Procedure (Sender:TObject;Download:THexDownload) of Object;
  THexDownloadDeletedEvent  = Procedure (Sender:TObject;Download:THexDownload) of Object;

  ISysDownloadManager = Interface
    ['{C4FD307B-78A6-41DF-930B-8DF3DF23D5E1}']
    Procedure NotifyProgress(Download:THexDownload;APos:LongInt;ATotal:LongInt);
    Procedure NotifyComplete(Download:THexDownload);
    Procedure NotifyFailed(Download:THexDownload);
  End;

  IHexDownload = interface
    ['{E7D95AAD-BAD1-447C-A524-C31258EC9FB7}']
    Procedure SetUrl(Value:String);
  End;

  THexDownloadThread = Class(TThread)
  Private
    FUrl:       String;
    FPosition:  Longint;
    FTotal:     Longint;
    FFilename:  String;
    FFailed:    Boolean;
    FReferer:   String;
    FManager:   ISysDownloadManager;
    FDownload:  THexDownload;
    Procedure   NotifyProgress;
    Procedure   NotifyComplete;
  Protected
    Procedure   Execute;Override;
  Public
    Property    Url:String write FUrl;
    Property    Referer: String write FReferer;
    Property    Filename:String write FFilename;
    Property    Manager:ISysDownloadManager write Fmanager;
    Property    Download:THexDownload write FDownload;
    Property    Failed:Boolean read FFailed;
  End;

  THexDownload = Class(TInterfacedObject,IHexDownload)
  Private
    FUrl:       String;
    FThread:    THexDownloadThread;
    FParent:    THexDownloadManager;
    FTag:       Integer;
    FTag2:      Integer;
    FIdent:     Integer;
    FReferer:   String;
    FFilename:  String;
    FUrlParser: THexUrlMoniker;
    FOldName:   String;
    Procedure   HandleThreadDone(Sender:TObject);
    Function    GetActive:Boolean;
  Protected
    Procedure   SetUrl(Value:String);
  Public
    Property    Active:Boolean read GetActive;
    Property    Identifier:Integer read FIdent write FIdent;
    Property    Referer: String read FReferer write FReferer;
    property    RemoteFileName: string read FOldName;
    Property    LocalFilename:String read FFilename;
    Property    Url:String read FUrl;

    Property    Tag:Integer read FTag write FTag;
    Property    Tag2:Integer read FTag2 write FTag2;
    Procedure   CopyTo(Const TargetFileName:String);
    Procedure   StreamTo(Stream:TStream);
    Function    GetData:TMemoryStream;
    Function    ToString:String;
    Procedure   Start;
    Procedure   Stop;
    Constructor Create(Parent:THexDownloadManager);
    Destructor  Destroy;Override;
    Procedure   BeforeDestruction;Override;
  End;

  THexDownloadManager = Class(THexCustomComponent,ISysDownloadManager)
  Private
    FObjects:   TObjectList;
    FLock:      TCriticalSection;
    FAddLock:   TCriticalSection;
    FOnComplete:THexDownloadCompleteEvent;
    FOnProgress:THexDownloadProgressEvent;
    FOnFailed:  THexDownloadFailedEvent;
    FOnAdded:   THexDownloadAddedEvent;
    FOnDeleted: THexDownloadDeletedEvent;
    Function    GetItem(Index:Integer):THexDownload;
    Function    GetCount:Integer;
    Function    GetActiveCount:Integer;
    Procedure   NotifyProgress(Download:THexDownload;APos:LongInt;ATotal:LongInt);
    Procedure   NotifyComplete(Download:THexDownload);
    Procedure   NotifyFailed(Download:THexDownload);
  Public
    property    ActiveCount:Integer read GetActiveCount;
    Property    Items[index:Integer]:THexDownload read GetItem;
    Property    Count:Integer read GetCount;
    Function    Add(Const Url:String;Identifier:Integer):THexDownload;
    Procedure   Delete(Index:Integer);Overload;
    Procedure   Delete(Item:THexDownload);Overload;
    Function    IndexOf(Item:THexDownload):Integer;
    Procedure   StopAll;
    Procedure   StartAll;
    Procedure   Clear;
    Constructor Create(AOwner:TComponent);Override;
    Destructor  Destroy;Override;
  Published
    Property    OnDownloadComplete:THexDownloadCompleteEvent read FOnComplete write FOnComplete;
    Property    OnDownloadFailed:THexDownloadFailedEvent read FOnFailed write FOnFailed;
    Property    OnDownloadProgress:THexDownloadProgressEvent read FOnProgress write FOnProgress;
    Property    OnDownloadAdded:THexDownloadAddedEvent read FOnAdded write FOnAdded;
    Property    OnDownloadDeleted:THexDownloadDeletedEvent read FOnDeleted write FOnDeleted;
  End;

  Implementation

  function GetTemporaryFileName : string;
  var
    lpPathBuffer : PChar;
    Ftext:  String;
  const
    MAX_PATH = 144;
  begin
    GetMem(lpPathBuffer, MAX_PATH);
    try
      GetTempPath(MAX_PATH, lpPathBuffer);

      FText:=CreateClassID;
      delete(FText,1,1);
      delete(Ftext,length(FText),1);
      FText:=StringReplace(FText,'-','',[rfReplaceAll]);
      FText:=FText + '.tmp';

      Result:=strPas(lpPathBuffer);
      result:=IncludeTrailingBackSlash(result) + FText;
    finally
      FreeMem(lpPathBuffer, MAX_PATH);
    end;
  end;

  //##############################################################
  //THexDownloadManager
  //##############################################################

  Constructor THexDownloadManager.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FObjects:=TObjectList.Create(True);
    FLock:=TCriticalSection.Create;
    FAddLock:=TCriticalSection.Create;
  end;

  Destructor THexDownloadManager.Destroy;
  begin
    FLock.free;
    FAddLock.free;
    FObjects.free;
    inherited;
  end;

  Function THexDownloadManager.GetItem(Index:Integer):THexDownload;
  begin
    result:=THexDownload(FObjects[index]);
  end;

  Function THexDownloadManager.GetActiveCount:Integer;
  var
    x:  Integer;
  begin
    result:=0;
    FAddLock.Enter;
    try
      for x:=1 to FObjects.Count do
      If Items[x-1].Active then
      inc(Result);
    finally
      FAddLock.Leave;
    end;
  end;

  Function THexDownloadManager.GetCount:Integer;
  begin
    result:=FObjects.Count;
  end;

  Function THexDownloadManager.Add(Const Url:String;Identifier:Integer):THexDownload;
  var
    FItem:  THexDownload;
  begin
    result:=NIL;
    FAddLock.Enter;
    try

      try
        FItem:=THexDownload.Create(Self);
      except
        on exception do
        begin
          Raise EHexDownloadManager.CreateFmt(ERR_HEX_FailedAddElement,['THexDownload']);
          exit;
        end;
      end;

      FItem.Identifier:=Identifier;
      IHexDownload(FItem).SetUrl(Url);

      try
        FObjects.Add(FItem);
      except
        on e: exception do
        begin
          FItem.free;
          Raise EHexDownloadManager.CreateFmt(ERR_HEX_FailedAddElement,['THexDownload']);
          exit;
        end;
      end;

      result:=FItem;

      If assigned(FOnAdded) then
      FOnAdded(self,FItem);

    finally
      FAddLock.Leave;
    end;
  end;

  Procedure THexDownloadManager.NotifyProgress(Download:THexDownload;APos:LongInt;ATotal:LongInt);
  Begin
    FLock.Enter;
    try
      try
        If assigned(FOnProgress) then
        FOnProgress(self,download,APos,Atotal);
      except
        on exception do;
      end;
    finally
      FLock.Leave;
    end;
  end;

  Procedure THexDownloadManager.NotifyFailed(Download:THexDownload);
  Begin
    FLock.Enter;
    try
      try
        if assigned(FOnFailed) then
        FOnFailed(self, Download);
      except
        on exception do;
      end;
    finally
      FLock.Leave;
    end;
  end;

  Procedure THexDownloadManager.NotifyComplete(Download:THexDownload);
  Begin
    FLock.Enter;
    try
      try
        if assigned(FOnComplete) then
        FOnComplete(self,Download);
      except
        on exception do;
      end;
    finally
      FLock.Leave;
    end;
  end;

  Procedure THexDownloadManager.Delete(Index:Integer);
  var
    FObject: THexDownload;
  begin
    FAddLock.Enter;

    try
      try
        FObject:=THexDownload(FObjects[index]);
        FObjects.Extract(FObject);

        if assigned(FOnDeleted) then
        FOnDeleted(self,FObject);

        FObject.free;
      except
        on e: exception do
        Raise EHEXFailedDeleteElement.CreateFmt(ERR_HEX_FailedDeleteElement,['THexDownload']);
      end;
    finally
      FAddLock.Leave;
    end;
  end;

  Procedure THexDownloadManager.Delete(Item:THexDownload);
  Begin
    try
      Delete(FObjects.IndexOf(Item));
    except
      raise;
    end;
  end;

  Function THexDownloadManager.IndexOf(Item:THexDownload):Integer;
  begin
    result:=FObjects.IndexOf(Item);
  end;

  Procedure THexDownloadManager.StopAll;
  var
    x:  Integer;
  begin
    FLock.Enter;
    try
      for x:=1 to FObjects.Count do
      If Items[x-1].Active then
      Items[x-1].Stop;
    finally
      Flock.Leave;
    end;
  end;

  Procedure THexDownloadManager.StartAll;
  var
    x:  Integer;
  begin
    FLock.Enter;
    try
      for x:=1 to FObjects.Count do
      If not Items[x-1].Active then
      Items[x-1].Start;
    finally
      FLock.Leave;
    end;
  end;

  Procedure THexDownloadManager.Clear;
  Begin
    FLock.Enter;
    try
      StopAll;
      While FObjects.Count>0 do
      Delete(0);
    finally
      Flock.Leave;
    end;
  end;

  //##############################################################
  //THexDownload
  //##############################################################

  Constructor THexDownload.Create(Parent:THexDownloadManager);
  begin
    inherited Create;
    FUrlParser:=THexUrlMoniker.Create(NIL);
    FParent:=Parent;
  end;

  Destructor THexDownload.Destroy;
  Begin
    FUrlParser.free;
    inherited;
  end;

  Function THexDownload.GetActive:Boolean;
  begin
    result:=Assigned(Fthread);
  end;

  Procedure THexDownload.BeforeDestruction;
  Begin
    If Assigned(FThread) then
    Begin
      FThread.Suspend;
      FThread.OnTerminate:=NIL;
      FThread.Terminate;
    end;

    if length(FFilename)>0 then
    begin
      try
        if fileexists(FFilename) then
        Deletefile(FFilename);
      except
        on exception do;
      end;
    end;

    inherited;
  end;

  Procedure THexDownload.HandleThreadDone(Sender:TObject);
  Begin
    { Download failed, we need to notify parent }
    If Fthread.Failed then
    Begin
      Fthread.Suspend;
      FreeAndNil(FThread);
      try
        ISysDownloadManager(FParent).NotifyFailed(self);
      except
        on exception do;
      end;
      exit;
    end;

    { Download successfull, just release }
    FreeAndNil(FThread);
  end;

  Procedure THexDownload.SetUrl(Value:String);
  Begin
    If (Value<>FUrl) then
    begin
      FUrl:=Value;
      FurlParser.Decode(Value);
      FOldName:=FurlParser.Filename;
    end;
  end;

  Procedure THexDownload.CopyTo(Const TargetFileName:String);
  var
    FSource,FTarget:  TFileStream;
  Begin
    { Nothing to save? }
    If length(FFilename)=0 then
    exit;

    try
      FSource:=TFileStream.Create(FFilename,fmopenRead);

      try
        Ftarget:=TFileStream.Create(targetFileName,fmCreate);
      except
        on exception do
        Begin
          FSource.free;
          exit;
        end;
      end;

      try
        Ftarget.CopyFrom(FSource,FSource.Size);
      finally
        FSource.free;
        Ftarget.free;
      end;
    except
      on exception do
      exit;
    end;
  end;

  Procedure THexDownload.StreamTo(Stream:TStream);
  var
    FFile:  TFileStream;
  Begin
    { Nothing to save? }
    If length(FFilename)=0 then
    exit;

    try
      FFile:=TFileStream.Create(FFilename,fmOpenRead);
    except
      on exception do
      Begin
        raise;
        exit;
      end;
    end;
    
    try
      Stream.CopyFrom(FFile,FFile.Size);
    finally
      Stream.seek(0,0);
      FFile.free;
    end;
  end;

  Function THexDownload.ToString:String;
  var
    FData:  TStream;
  Begin
    FData:=GetData;
    try
      Setlength(result,FData.Size);
      FillChar(pointer(@result[1])^,FData.Size,#32);
      FData.Read(pointer(@result[1])^,FData.Size);
    finally
      FData.free;
    end;
  end;

  Function THexDownload.GetData:TMemoryStream;
  Begin
    { Nothing to save? }
    If length(FFilename)=0 then
    Begin
      result:=NIL;
      exit;
    end;

    result:=TMemoryStream.Create;
    try
      StreamTo(result);
    except
      on exception do
      begin
        FreeAndNil(result);
        raise;
      end;
    end;
  end;

  Procedure THexDownload.Start;
  Begin
    If FThread<>NIL then
    begin
      Raise EHexDownloadAlreadyActive.Create(ERR_HEX_DownloadAllreadyActive);
      exit;
    end;

    { have this object been downloaded before? }
    if length(FFilename)>0 then
    Begin
      try
        if fileexists(FFilename) then
        Deletefile(FFilename);
      except
        on exception do;
      end;
    end else
    FFilename:=GetTemporaryFileName;

    { clone a new download thread }
    try
      Fthread:=THexDownloadThread.Create(TRUE);
    except
      on e: exception do
      begin
        Raise EHEXInternalError.CreateFmt(ERR_HEX_InternalError,[e.message]);
        exit;
      end;
    end;

    FThread.Filename:=FFilename;
    Fthread.Manager:=ISysDownloadManager(FParent);
    Fthread.Url:=FUrl;
    Fthread.Download:=Self;
    Fthread.OnTerminate:=HandleThreadDone;
    Fthread.Resume;
  End;

  Procedure THexDownload.Stop;
  Begin
    If not assigned(FThread) then
    exit;

    try
      Fthread.Suspend;
      FThread.OnTerminate:=NIL;
    finally
      FreeAndNil(FThread);
    end;
  End;

  //##############################################################
  //THexDownloadTask
  //##############################################################

  Procedure THexDownloadThread.NotifyProgress;
  Begin
    If assigned(FManager) then
    begin
      try
        FManager.NotifyProgress(FDownload,FPosition,FTotal);
      except
        on exception do;
      end;
    end;
  end;

  Procedure THexDownloadThread.NotifyComplete;
  Begin
    if assigned(FManager) then
    begin
      try
        FManager.NotifyComplete(FDownload);
      except
        on exception do;
      end;
    end;
  end;

  Procedure THexDownloadThread.Execute;
  Const
    BufferSize    = 4096;
  var
    FSession:     HInternet;
    FHandle:      HInternet;
    FBuffer:      array[1..BufferSize] of Byte;
    FHeader:      String;

    FReserved:    DWord;
    FBuffLen:     DWord;

    BufferLen:    DWORD;
    FFile:        TFileStream;
  Begin
    FFailed:=False;
    FUrl:=trim(Furl);
    FFilename:=trim(FFilename);

    If (Length(FUrl)=0)
    or (length(FFilename)=0) then
    Begin
      FFailed:=True;
      Terminate;
      exit;
    end;

    { Delete temp file If (4 some reason) it exists }
    If fileexists(FFilename) then
    Begin
      try
        DeleteFile(FFilename);
      except
        on exception do
        Begin
          FFailed:=True;
          Terminate;
          exit;
        end;
      end;
    end;

    { Create a new internet session }
    FSession := InternetOpen(PChar('Mozilla'),INTERNET_OPEN_TYPE_DIRECT,nil, nil, 0);
    if (FSession=NIL) then
    Begin
      FFailed:=True;
      Terminate;
      exit;
    end;

    try
      { Create a remote file handle }
      { can also use : INTERNET_FLAG_KEEP_CONNECTION }
      FHeader:='Accept: */*';
      If Length(FReferer)>0 then
      FHeader:=FHeader + ';Referer: ' + FReferer;
      FHandle := InternetOpenURL(FSession,PChar(Furl),PChar(FHeader),StrLen(PChar(FHeader)),INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_RAW_DATA,0);

      { did not work? }
      If (FHandle=NIL) then
      Begin
        { no need to release session,
          that is released in the finally section }
        FFailed:=True;
        Terminate;
        exit;
      end;

      try
        FReserved:=0;
        FbuffLen:=SizeOf(FTotal);

        { get the remote file size }
        if not HttpQueryInfo
          (
          FHandle,
          HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER,
          pointer(@FTotal),
          FBuffLen,
          FReserved
          ) then
        Begin
          { filesize is unknown }
          FTotal:=0;
        end;

        { Create the temp file }
        try
          FFile:=TFileStream.Create(FFilename,fmCreate or fmShareDenyWrite);
        except
          on exception do
          Begin
            FFailed:=True;
            Exit;
          end;
        end;

        FFile.Seek(0,0);

        try
          repeat
            if (Terminated)
            or (FFailed) then
            break;

            { Keep reading until entire file is complete }
            if InternetReadFile(FHandle, @FBuffer,SizeOf(FBuffer), BufferLen) then
            Begin
              If BufferLen>0 then
              begin
                FFile.WriteBuffer(FBuffer,SizeOf(FBuffer));
                inc(FPosition,Bufferlen);
                Synchronize(NotifyProgress);
              end else
              Break;
            end else
            Break;
          until BufferLen = 0;
        finally
          FFile.free;
        end;

        { just checking }
        If  (Fposition<FTotal)
        and (FTotal>0) then
        FFailed:=True;

        { Did this download complete? }
        If  (FFailed=False)
        and (FPosition>=FTotal)
        and (Terminated=False) then
        Synchronize(NotifyComplete);
      finally
        InternetCloseHandle(FHandle);
      end;
    finally
      InternetCloseHandle(FSession);
    end;
    Terminate;
  end;

  end.
 