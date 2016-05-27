  unit jlmsghandler;

  interface

  uses sysutils, classes, wintypes,
  messages, forms, jldatabuffer;

  Const
  ERR_JL_MsgHandler_CanNotBeActive  = 'State can not be active';

  ERR_JL_MsgServer_ServerActive     = 'Server state can not be active';
  ERR_JL_MsgServer_ServerNotActive  = 'Server state must be active';

  ERR_JL_MsgClient_FailedResolve    = 'Failed to resolve message host';
  ERR_JL_MsgClient_FailedConnect    = 'Connection failed';

  Const
  JL_MESSAGESERVER_PREFIX  = 'JLMSVR:';

  (* messages used to establish server instances and availability *)
  Const
  WM_SERVER_PONG          = 1;
  WM_SERVER_PING          = 0;

  (* messages clients send to servers *)
  Const
  WM_CLIENT_CONNECT       = WM_USER + 65790;
  WM_CLIENT_DISCONNECT    = WM_USER + 65791;
  WM_CLIENT_DELIVER       = WM_USER + 65792;

  (* messages servers send back to clients *)
  Const
  WM_SERVER_DISCONNECT    = WM_USER + 65795;
  WM_SERVER_CONNECTED     = WM_USER + 65796;
  WM_SERVER_DELIVERED     = WM_USER + 65797;
  WM_SERVER_DELIVER       = WM_USER + 65798;

  type

  {TJLMsgReader = Class;
  TJLMsgWriter = Class;  }

  (* exception classes *)
  EJLMsgHandler = Class(Exception);
  EJLMsgServer  = Class(EJLMsgHandler);
  EJLMsgClient  = Class(EJLMsgHandler);

  TJLMsgHandle  = HWND;

  (* Message Server Events *)
  TJLMsgServerClientConnectEvent = Procedure
  (Sender:TObject;AHandle:TJLMsgHandle) of Object;

  TJLMsgServerClientDisconnectEvent = Procedure
  (Sender:TObject;AHandle:TJLMsgHandle) of Object;

  TJLMsgServerRecievedEvent = Procedure
  (Sender:TObject;Const Request:TJLReader;
  Const Response:TJLWriter) of Object;

  (* Message Client events *)
  TJLMsgClientRecievedEvent = Procedure
  (Sender:TObject;Const Request:TJLReader) of Object;

  (* internal data packet used to transport data between processes *)
  PSithMessageData = ^TJLMessageData;
  TJLMessageData = Record
    mdSenderHandle:         TJLMsgHandle;
    mdFrequency:            Integer;
    mdDeliveryNotification: Boolean;
    mdData:                 Pointer;
    mdBytes:                Integer;
  End;

  TJLMsgEvents =  Set of (meBeforeOpen,meAfterOpen,meBeforeClose,
                    meAfterClose,meOpen,meClose,meMessage);

  TJLMsgOptions = set of (moEncryption);

  TJLMsgHandler = Class(TComponent)
  Private
    FActive:      Boolean;
    FWinhandle:   TJLMsgHandle;
    FOnBefOpen:   TNotifyEvent;
    FOnAftOpen:   TNotifyEvent;
    FOnBefClose:  TNotifyEvent;
    FOnAftClose:  TNotifyEvent;
    FOnOpen:      TNotifyEvent;
    FOnClose:     TNotifyEvent;
    FEvents:      TJLMsgEvents;
    FOptions:     TJLMsgOptions;
    Procedure     SetActive(Const Value:Boolean);
    Procedure     SetOptions(Const Value:TJLMsgOptions);
  Protected
    Procedure     SendToDefaultHandler(var Msg:TMessage);
    Procedure     WndProc(var msg: TMessage);virtual;
    Procedure     DoBeforeOpen;
    Procedure     DoAfterOpen;
    Procedure     DoBeforeClose;
    procedure     DoAfterClose;
    Procedure     SessionBegins;virtual;
    Procedure     SessionEnds;virtual;
    Procedure     DoOpen;
    Procedure     DoClose;
  Public
    Property      Options: TJLMsgOptions read FOptions write SetOptions;

    Property      Events:TJLMsgEvents read FEvents write FEvents;
    property      OnOpened:TNotifyEvent
                  Read FOnOpen write FOnOpen;
    Property      OnClosed:TNotifyEvent
                  Read FOnClose write FOnClose;
    Property      OnBeforeOpen:TNotifyEvent
                  Read FOnBefOpen write FOnBefOpen;
    Property      OnBeforeClose:TNotifyEvent
                  Read FOnBefClose write FOnBefClose;
    Property      OnAfterOpen:TNotifyEvent
                  Read FOnAftOpen write FOnAftOpen;
    Property      OnAfterClose:TNotifyEvent
                  Read FOnAftClose write FOnAftClose;
    Property      Handle: TJLMsgHandle read FWinHandle;
    Property      Active:Boolean read FActive write SetActive;
    Procedure     Open;virtual;
    procedure     Close;virtual;
    procedure     Loaded;Override;
    Constructor   Create(AOwner:TComponent);override;
    Procedure     BeforeDestruction;Override;
  End;

  {
  TJLMsgReader = Class(TObject)
  Private
    FData:      TStream;
    FSender:    TJLMsgHandle;
    Function    GetSize:Integer;
  Public
    Property    Sender:TJLMsgHandle read FSender;
    Property    Size:Integer read GetSize;
    Function    Read(var outData;Const outBytes:Integer):Boolean;
    Constructor Create(Const inStream:TStream;Const inSender:TJLMsgHandle);
  End;

  TJLMsgWriter = Class(TObject)
  Private
    FData:      TStream;
    FReciever:  TJLMsgHandle;
  Public
    Property    Reciever:TJLMsgHandle read FReciever;
    Procedure   Write(var inData;Const inBytes:Integer);
    Constructor Create(Const outStream:TStream;Const inReciever:TJLMsgHandle);
  End;       }

  TJLMsgServer = Class(TJLMsgHandler)
  Private
    FServer:      String;
    FAppName:     String;
    FFrequency:   Integer;
    FOnConnect:   TJLMsgServerClientConnectEvent;
    FOnDisConnect:TJLMsgServerClientDisconnectEvent;
    FOnMessage:   TJLMsgServerRecievedEvent;
    FSysMessage:  Cardinal;
    FOwnsMessage: Boolean;
    FClients:     TList;
  Private
    Procedure     SetFrequency(Const Value:Integer);
    Procedure     SetServerName(Const Value:String);
    Procedure     SetSoftwareName(Const Value:String);
    Function      GetFrequency:Integer;
    Function      GetServerName:String;
    Function      GetSoftwareName:String;
    Function      GetCount:Integer;
    Function      GetItem(Const Index:Integer):TJLMsgHandle;
  Protected
    Procedure     SessionBegins;override;
    Procedure     SessionEnds;override;
    Procedure     WndProc(var msg: TMessage);override;
  Public
    Property      Count:Integer read GetCount;
    Property      Items[Const Index:Integer]:TJLMsgHandle read GetItem;
    Procedure     DisconnectAll;
    Procedure     Disconnect(Const Client:TJLMsgHandle);
    Procedure     BroadCast(Const Exclude:TJLMsgHandle;var Data;Const Bytes:Integer);
    Procedure     Write(Const Reciever:TJLMsgHandle;var Data;Const Bytes:Integer);
  Published
    Property      Active;
    Property      OnOpened;
    Property      OnClosed;
    Property      OnBeforeOpen;
    Property      OnBeforeClose;
    Property      OnAfterOpen;
    Property      OnAfterClose;
    Property      Events;
    Property      Options;

    Property      OnClientConnect:TJLMsgServerClientConnectEvent
                  read FOnConnect write FOnConnect;

    Property      OnClientDisconnect:TJLMsgServerClientDisconnectEvent
                  read FOnDisconnect write FOnDisconnect;

    property      OnMessage:TJLMsgServerRecievedEvent
                  read FOnMessage write FOnMessage;

    Property      ServerName:String
                  read GetServerName write SetServerName;

    Property      Software:String
                  read GetSoftwareName write SetSoftwareName;

    Property      Frequency:Integer
                  read GetFrequency write SetFrequency;

    Constructor   Create(AOwner:TComponent);override;
    Destructor    Destroy;Override;
  End;

  TJLMsgClient = Class(TJLMsgHandler)
  Private
    FServer:          String;
    FFrequency:       Integer;
    FSYSMESSAGE:      Cardinal;
    FOnline:          Boolean;
    FConnected:       Boolean;
    FServerHandle:    TJLMsgHandle;
    FMemPool:         TList;
    FOnMessage:       TJLMsgClientRecievedEvent;
    Procedure         ClearMemPool;
    Procedure         Write(var Data;Const Bytes:Integer;
                      Const Blocking:Boolean=False);
  Private
    Procedure         SetServer(Const Value:String);
    Procedure         SetFrequency(Const Value:Integer);
    Function          ResolveServer(var outError:String):Boolean;
    Function          GetFullServerName:String;
  Protected
    Procedure         WndProc(var msg: TMessage);override;
    Procedure         SessionBegins;override;
    Procedure         SessionEnds;override;
  Public
    Property          FullServerName:String read GetFullServerName;
    Property          ServerHandle: TJLMsgHandle read FServerHandle;
    Procedure         Close;Override;

    Function          BeginWrite(var outWriter:TJLWriter):Boolean;
    Procedure         EndWrite(Const Writer:TJLWriter);

    Constructor       Create(AOwner:TComponent);Override;
    Destructor        Destroy;Override;
  Published
    Property          Active;
    Property          OnOpened;
    Property          OnClosed;
    Property          OnBeforeOpen;
    Property          OnBeforeClose;
    Property          OnAfterOpen;
    Property          OnAfterClose;
    Property          Events;
    Property          Options;
    Property          ServerName:String read FServer write SetServer;
    Property          Frequency:Integer read FFrequency write SetFrequency;
    Property          OnMessage:TJLMsgClientRecievedEvent
                      read FOnMessage write FOnMessage;
  End;

  implementation

  //##########################################################################
  // TJLMsgClient
  //##########################################################################

  Constructor TJLMsgClient.Create(AOwner:TComponent);
  Begin
    inherited;
    FMemPool:=TList.Create;
    FServer:='JLSvr';
    FFrequency:=65536;
  end;

  Destructor TJLMsgClient.Destroy;
  Begin
    ClearMemPool;
    FMemPool.free;
    inherited;
  end;

  Procedure TJLMsgClient.ClearMemPool;
  Begin
    While FMemPool.Count>0 do
    Begin
      FreeMem(FMemPool[0]);
      FMemPool.Delete(0);
    end;
  end;

  Procedure TJLMsgClient.Close;
  Begin
    If Active then
    PostMessage(FServerHandle,FSYSMESSAGE,
    WM_CLIENT_DISCONNECT,Handle);
    inherited;
  end;

  Procedure TJLMsgClient.SetServer(Const Value:String);
  Begin
    If (csLoading in ComponentState)
    or (csDesigning in ComponentState) then
    FServer:=trim(Value) else
    If not Active then
    FServer:=trim(Value);
  end;

  Procedure TJLMsgClient.SetFrequency(Const Value:Integer);
  Begin
    If (csLoading in ComponentState)
    or (csDesigning in ComponentState) then
    FFrequency:=Value else
    Begin
      If not Active then
      FFrequency:=Value;
    end;
  end;

  Function TJLMsgClient.GetFullServerName:String;
  Begin
    If Active then
    Result:=Uppercase(JL_MESSAGESERVER_PREFIX + FServer
    + ':' + IntToStr(FFrequency)) else
    result:='';
  end;

  Function TJLMsgClient.BeginWrite(var outWriter:TJLWriter):Boolean;
  var
    FData:    TStream;
    FWriter:  TJLWriterStream;
  Begin
    result:=False;
    outWriter:=NIL;

    try
      FData:=TMemoryStream.Create;
    except
      on exception do
      exit;
    end;

    try
      FWriter:=TJLWriterStream.Create(FData);
    except
      on exception do
      Begin
        FreeAndNil(FData);
        exit;
      end;
    end;

    outWriter:=FWriter;
    result:=True;
  end;

  Procedure TJLMsgClient.EndWrite(Const Writer:TJLWriter);
  var
    FData:  TMemoryStream;
  Begin
    If  (Writer<>NIL)
    and (Writer is TJLWriterStream) then
    Begin
      FData:=TMemoryStream(TJLWriterStream(Writer).DataStream);
      try
        FData.Position:=0;
        Write(FData.Memory^,FData.Size);
      finally
        Writer.free;
        FData.free;
      end;
    end;
  end;
  
  Procedure TJLMsgClient.Write(var Data;Const Bytes:Integer;
            Const Blocking:Boolean=False);
  var
    FMessage: PSithMessageData;
  Begin
    if Active then
    Begin
      If Bytes>0 then
      Begin
        If not (csDesigning in ComponentState) then
        Begin
          New(FMessage);
          FMessage^.mdSenderHandle:=Handle;
          FMessage^.mdFrequency:=FFrequency;
          FMessage^.mdBytes:=Bytes;
          FMessage^.mdData:=AllocMem(Bytes);
          Move(Data,FMessage^.mdData^,Bytes);

          If Blocking then
          Begin
            (* set owned-data to false *)
            FMessage^.mdDeliveryNotification:=False;

            (* send message & wait for response *)
            SendMessage(FServerHandle,FSYSMESSAGE,
            WM_CLIENT_DELIVER,Integer(FMessage));

            (* release memory allocation *)
            FreeMem(Fmessage^.mdData);

            (* dispose of message *)
            Dispose(FMessage);
          end else
          Begin
            (* Add Memory Allocation to memory pool *)
            FMemPool.Add(FMessage^.mdData);

            (* set owned-data to true *)
            FMessage^.mdDeliveryNotification:=True;

            (* send the message away *)
            Postmessage(FServerHandle,FSYSMESSAGE,
            WM_CLIENT_DELIVER,Integer(FMessage));
          end;
        end;
      end;
    end;
  end;

  Procedure TJLMsgClient.WndProc(var msg: TMessage);
  var
    FMessage: PSithMessageData;
    FIndex:   Integer;
    FIn:      TMemoryStream;
    FReq:     TJLReaderStream;
  Begin
    If msg.Msg=FSYSMESSAGE then
    Begin
      msg.Result:=1;
      Case msg.WParam of
      WM_SERVER_PONG:
        Begin
          FServerHandle:=msg.LParam;
          FOnline:=True;
        end;
      WM_SERVER_DISCONNECT:
        Begin
          if msg.LParam<>0 then
          Begin
            FMessage:=Pointer(msg.LParam);
            If FMessage^.mdFrequency=FFrequency then
            Begin
              If Active then
              Close;
            end;
          end;
        end;
      WM_SERVER_CONNECTED:    FConnected:=True;
      WM_SERVER_DELIVERED:
        Begin
          If msg.LParam<>0 then
          Begin
            FMessage:=Pointer(msg.LParam);
            If FMessage^.mdData<>NIL then
            Begin
              FIndex:=FMemPool.IndexOf(FMessage^.mdData);
              If FIndex>=0 then
              Begin
                FreeMem(FMemPool[FIndex]);
                FmemPool.Delete(FIndex);
              end;
            end;
            Dispose(FMessage);
          end;
        end;
      WM_SERVER_DELIVER:
        Begin
          If msg.LParam<>0 then
          Begin
            FMessage:=Pointer(msg.LParam);

            If (meMessage in Events) then
            Begin
              If assigned(FOnMessage) then
              Begin
                If FMessage.mdSenderHandle=FServerHandle then
                Begin
                  FIn:=TMemoryStream.Create;
                  try
                    FIn.WriteBuffer(FMessage^.mdData^,FMessage^.mdBytes);
                    FIn.Position:=0;

                    FReq:=TJLReaderStream.Create(FIn);
                    try
                      FOnMessage(self,FReq);
                    finally
                      FReq.Free;
                    end;

                  finally
                    FIn.free;
                  end;
                end;
              end;
            end;
          end;
        end;
      else
        SendToDefaultHandler(msg);
      end;
    end else
    Inherited;
  end;

  Function TJLMsgClient.ResolveServer(var outError:String):Boolean;
  var
    FToken:   String;
    x:        Integer;
  begin
    (* as far as we know, there can be other instances of this server name  *)
    FOnline:=False;

    (*  use the servername to register for a unique message.
        if this is already taken, then the message will directly to that
        server *)
    FToken:=uppercase(JL_MESSAGESERVER_PREFIX + FServer);
    FSysMessage:=RegisterWindowMessage(PAnsiChar(FToken));

    (* send out a blocking PING, if we recieve a PONG response, then
       we can connect to the server *)
    //SendMessage(HWND_BROADCAST,FSYSMESSAGE,WM_SERVER_PING,Handle);
    PostMessage(HWND_BROADCAST,FSYSMESSAGE,WM_SERVER_PING,Handle);

    for x:=1 to 20 do
    Begin
      sleep(20);
      Application.ProcessMessages;
      If FOnline then
      Break;
    end;

    (*  if some other server sent a pong message back, then we know we
        have other instances hosting the server name *)
    Result:=FOnline;
    If not Result then
    outError:=ERR_JL_MsgClient_FailedResolve;
  end;

  Procedure TJLMsgClient.SessionBegins;
  var
    FMessage: TJLMessageData;
    FError:   String;
    x:        Integer;
  Begin
    (* Resolve server *)
    If not ResolveServer(FError) then
    Begin
      Close;
      Raise EJLMsgClient.Create(FError);
    end;

    (* send a connect request *)
    FConnected:=False;
    FMessage.mdSenderHandle:=Handle;
    FMessage.mdFrequency:=FFrequency;
    Fmessage.mdData:=NIL;

    PostMessage(FServerHandle,FSYSMESSAGE,
    WM_CLIENT_CONNECT,Integer(@FMessage));

    for x:=1 to 10 do
    Begin
      sleep(10);
      Application.ProcessMessages;
    end;

    (* not connected? Shut down*)
    If not FConnected then
    Begin
      Close;
      Raise EJLMsgClient.Create
      (ERR_JL_MsgClient_FailedConnect);
    end;
    DoOpen;
  end;

  Procedure TJLMsgClient.SessionEnds;
  Begin
    FConnected:=False;
    FServerHandle:=0;
    FOnline:=False;
    ClearMemPool;
    DoClose;
  end;

  //##########################################################################
  // TJLMsgServer
  //##########################################################################

  Constructor TJLMsgServer.Create(AOwner:TComponent);
  Begin
    inherited;
    FClients:=TList.Create;
    FServer:='JLSvr';
    FAppName:='Unknown';
    FFrequency:=65536;
  end;

  Destructor TJLMsgServer.Destroy;
  begin
    FClients.free;
    inherited;
  end;

  Function TJLMsgServer.GetCount:Integer;
  Begin
    result:=FClients.Count;
  end;

  Function TJLMsgServer.GetItem(Const Index:Integer):TJLMsgHandle;
  Begin
    Result:=TJLMsgHandle(FClients[index]);
  end;
  
  Procedure TJLMsgServer.SessionBegins;
  var
    FToken:   String;
    x:        Integer;
  begin
    (* as far as we know, there can be other instances of this server name  *)
    FOwnsMessage:=False;

    (*  use the servername to register for a unique message.
        if this is already taken, then the message will direct to that
        server *)
    FToken:=Uppercase(JL_MESSAGESERVER_PREFIX + FServer);
    FSysMessage:=RegisterWindowMessage(PAnsiChar(FToken));

    (* send out a test signal, if we recieve it in our messagehandler,
        and the handle is our own - then we know we are alone *)
    Postmessage(HWND_BROADCAST,FSYSMESSAGE,0,Handle);

    for x:=1 to 20 do
    Begin
      sleep(20);
      Application.ProcessMessages;
      If FOwnsMessage then
      Break;
    end;

    (*  if some other server sent a pong message back, then we know we
        have other instances alive with this message *)
    If not FOwnsMessage then
    Begin
      Close;
      Raise Exception.Create('A server with this name is already running error');
    end;

    inherited;
  end;

  Procedure TJLMsgServer.SessionEnds;
  Begin
    inherited;
  end;

  Function TJLMsgServer.GetFrequency:Integer;
  Begin
    Result:=FFrequency;
  end;
  
  Function TJLMsgServer.GetServerName:String;
  Begin
    Result:=FServer;
  end;

  Function TJLMsgServer.GetSoftwareName:String;
  Begin
    result:=FAppName;
  end;

  Procedure TJLMsgServer.SetFrequency(Const Value:Integer);
  Begin
    If Value<>FFrequency then
    Begin
      If (csLoading in ComponentState)
      or (csDesigning in ComponentState) then
      FFrequency:=Value else
      Begin
        If Active then
        Raise EJLMsgServer.Create(ERR_JL_MsgServer_ServerActive) else
        FFrequency:=Value;
      end;
    end;
  end;

  Procedure TJLMsgServer.SetSoftwareName(Const Value:String);
  Begin
    If Value<>FAppName then
    Begin
      If (csLoading in ComponentState)
      or (csDesigning in ComponentState) then
      FAppName:=Value else
      Begin
        If Active then
        Raise EJLMsgServer.Create(ERR_JL_MsgServer_ServerActive) else
        FAppName:=Value;
      end;
    end;
  end;

  Procedure TJLMsgServer.SetServerName(Const Value:String);
  Begin
    If Value<>FServer then
    Begin
      If (csLoading in ComponentState)
      or (csDesigning in ComponentState) then
      FServer:=Value else
      Begin
        If Active then
        Raise EJLMsgServer.Create(ERR_JL_MsgServer_ServerActive) else
        FServer:=Value;
      end;
    end;
  end;

  Procedure TJLMsgServer.DisconnectAll;
  Begin
  end;
  
  Procedure TJLMsgServer.Disconnect(Const Client:TJLMsgHandle);
  Begin
  end;
  
  Procedure TJLMsgServer.BroadCast(Const Exclude:TJLMsgHandle;var Data;
            Const Bytes:Integer);
  var
    z:        Integer;
    FHandle:  TJLMsgHandle;
  Begin
    If Active then
    Begin
      If not (csDesigning in ComponentState) then
      Begin
        If FClients.Count>0 then
        Begin
          for z:=1 to FClients.Count do
          Begin
            FHandle:=Integer(FClients[z-1]);
            if FHandle<>Exclude then
            Write(FHandle,data,bytes);
          end;
        end;
      end;
    end else
    Raise EJLMsgServer.Create(ERR_JL_MsgServer_ServerNotActive);
  end;
  
  Procedure TJLMsgServer.Write(Const Reciever:TJLMsgHandle;
            var Data;Const Bytes:Integer);
  var
    FMessage: TJLMessageData;
  Begin
    If Active then
    Begin
      If not (csDesigning in ComponentState) then
      Begin
        If FClients.IndexOf(pointer(Reciever))>=0 then
        Begin
          FMessage.mdSenderHandle:=Handle;
          FMessage.mdFrequency:=FFrequency;
          FMessage.mdDeliveryNotification:=False;
          FMessage.mdData:=@Data;
          FMessage.mdBytes:=Bytes;
          SendMessage(Reciever,FSYSMESSAGE,
          WM_SERVER_DELIVER,Integer(@FMessage));
        end;
      end;
    end else
    Raise EJLMsgServer.Create(ERR_JL_MsgServer_ServerNotActive);
  end;

  Procedure TJLMsgServer.WndProc(var msg: TMessage);
  var
    FMessage:   PSithMessageData;
    FIndex:     Integer;
    FIn,FOut:   TMemoryStream;
    FReq:       TJLReader;
    FRes:       TJLWriter;
  Begin
    msg.Result:=0;
    If not (csDestroying in ComponentState) then
    Begin

    If msg.Msg=FSYSMESSAGE then
    Begin
      Case msg.WParam of
      WM_SERVER_PONG: FOwnsMessage:=TJLMsgHandle(msg.LParam)=Handle;
      WM_SERVER_PING:
        Begin
          If TJLMsgHandle(msg.LParam)<>Handle then
          SendMessage(msg.LParam,FSYSMESSAGE,WM_SERVER_PONG,Handle) else
          FOwnsMessage:=True;
        end;
      WM_CLIENT_CONNECT:
        Begin
          If msg.LParam<>0 then
          Begin
            FMessage:=Pointer(msg.LParam);
            If FMessage.mdFrequency=FFrequency then
            Begin
              If FClients.IndexOf(pointer(FMessage^.mdSenderHandle))=-1 then
              Begin
                FClients.Add(Pointer(FMessage^.mdSenderHandle));
                SendMessage(FMessage^.mdSenderHandle,
                FSYSMESSAGE,WM_SERVER_CONNECTED,0);
                If assigned(FOnConnect) then
                FOnConnect(self,FMessage^.mdSenderHandle);
              end;
            end;
          end;
        end;
      WM_CLIENT_DISCONNECT:
        Begin
          If msg.LParam<>0 then
          Begin
            FIndex:=FClients.IndexOf(pointer(msg.LParam));
            If FIndex>=0 then
            Begin
              FClients.Delete(FIndex);
              if assigned(FOnDisConnect) then
              FOnDisconnect(self,msg.LParam);
            end;
          end;
        end;
      WM_CLIENT_DELIVER:
        Begin
          If msg.LParam<>0 then
          Begin
            FMessage:=Pointer(msg.LParam);
            If FMessage^.mdFrequency=FFrequency then
            Begin

              If (meMessage in Events) then
              If assigned(FOnMessage) then
              Begin
                FIn:=TMemoryStream.Create;
                try
                  FOut:=TMemoryStream.Create;
                  try
                    FIn.WriteBuffer(FMessage^.mdData^,FMessage.mdBytes);
                    FIn.Position:=0;

                    FReq:=TJLReaderStream.Create(FIn); //,FMessage^.mdSenderHandle
                    try
                      FRes:=TJLWriterStream.Create(Fout); //,FMessage^.mdSenderHandle
                      try
                        If assigned(FOnMessage) then
                        FOnMessage(self,FReq,FRes);

                        (* send reply *)
                        if FOut.Size>0 then
                        Begin
                          FOut.Position:=0;
                          Write(FMessage^.mdSenderHandle,FOut.Memory^,
                          FOut.Size);
                        end;

                      finally
                        FRes.free;
                      end;
                    finally
                      FReq.free;
                    end;
                  finally
                    FOut.free;
                  end;
                finally
                  FIn.free;
                end;
              end;

              (* the data memory is bound to the sender, we must
                  return a packet so it can be released in
                  its own process space *)
              If Fmessage^.mdDeliveryNotification then
              PostMessage(Fmessage^.mdSenderHandle,
              FSYSMESSAGE,WM_SERVER_DELIVERED,msg.LParam);
            end;
          end;
        end;
      end;
    end else
    Inherited;

    end;
  end;

  //##########################################################################
  // TJLMsgHandler
  //##########################################################################

  Constructor TJLMsgHandler.Create(AOwner:TComponent);
  Begin
    inherited;
    FEvents:=[meBeforeOpen,meAfterOpen,meBeforeClose,
    meAfterClose,meOpen,meClose,meMessage];
  end;

  Procedure TJLMsgHandler.BeforeDestruction;
  Begin
    If FActive then
    Close;
    inherited;
  end;

  procedure TJLMsgHandler.Loaded;
  Begin
    inherited;
    If (FActive=True) and (FWinhandle=0) then
    Begin
      FActive:=False;
      Open;
    end;
  end;
  
  Procedure TJLMsgHandler.SessionBegins;
  Begin
    DoOpen;
  end;

  Procedure TJLMsgHandler.SessionEnds;
  Begin
    DoClose;
  end;

  Procedure TJLMsgHandler.DoOpen;
  Begin
    If  not (csDestroying in ComponentState)
    and assigned(FOnOpen)
    and (meOpen in FEvents) then
    FOnOpen(self);
  end;

  Procedure TJLMsgHandler.DoClose;
  Begin
    If  not (csDestroying in ComponentState)
    and assigned(FOnClose)
    and (meClose in FEvents) then
    FOnClose(self);
  end;

  Procedure TJLMsgHandler.DoBeforeOpen;
  Begin
    If not (csDestroying in ComponentState)
    and assigned(FOnBefOpen)
    and (meBeforeOpen in FEvents) then
    FOnBefOpen(self);
  end;

  Procedure TJLMsgHandler.DoAfterOpen;
  Begin
    If not (csDestroying in ComponentState)
    and assigned(FOnAftOpen)
    and (meAfterOpen in FEvents) then
    FOnAftOpen(self);
  end;

  Procedure TJLMsgHandler.DoBeforeClose;
  Begin
    If not (csDestroying in ComponentState)
    and assigned(FOnBefClose)
    and (meBeforeClose in FEvents) then
    FOnBefClose(self);
  end;

  procedure TJLMsgHandler.DoAfterClose;
  Begin
    If not (csDestroying in ComponentState)
    and assigned(FOnAftClose)
    and (meAfterClose in FEvents) then
    FOnAftClose(self);
  end;

  Procedure TJLMsgHandler.SendToDefaultHandler(var Msg:TMessage);
  Begin
    msg.Result := DefWindowProc(FWinHandle,Msg.Msg,Msg.wParam,Msg.lParam);
  end;

  procedure TJLMsgHandler.WndProc(var msg: TMessage);
  begin
    (* this is an ancestor class, so we let windows handle the message *)
    SendToDefaultHandler(msg);
  end;

  Procedure TJLMsgHandler.SetActive(Const Value:Boolean);
  Begin
    If Value<>FActive then
    Begin
      If Value then
      Open else
      Close;
    end;
  end;

  Procedure TJLMsgHandler.Open;
  Begin
    If not FActive then
    Begin
      FActive:=True;
      If not (csDesigning in ComponentState)
      and not (csLoading in ComponentState) then
      Begin
        DoBeforeOpen;
        {$warnings off}
        FWinHandle := AllocateHWND(WndProc);
        {$warnings on}
        SessionBegins;
        DoAfterOpen;
      End;
    end;
  end;

  Procedure TJLMsgHandler.SetOptions(Const Value:TJLMsgOptions);
  Begin
    If Value<>FOptions then
    Begin
      If (csLoading in ComponentState)
      or (csDesigning in ComponentState) then
      FOptions:=Value else
      Begin
        If Active then
        Raise EJLMsgServer.Create(ERR_JL_MsgHandler_CanNotBeActive) else
        FOptions:=Value;
      end;
    end;
  end;

  procedure TJLMsgHandler.Close;
  var
    Instance: Pointer;
  Begin
    If FActive then
    Begin
      FActive:=False;
      If not (csDesigning in ComponentState)
      and not (csLoading in ComponentState) then
      Begin
        DoBeforeClose;
        Instance := Pointer(GetWindowLong(FWinHandle, GWL_WNDPROC));
        if Instance <> @DefWindowProc then
        begin
          SetWindowLong(FWinHandle, GWL_WNDPROC, Longint(@DefWindowProc));
          {$warnings off}
          FreeObjectInstance(Instance);
          {$warnings on}
        end;
        DestroyWindow(FWinHandle);
        FWinHandle:=0;
        SessionEnds;
        DoAfterClose;
      end;
    end;
  end;

  end.
