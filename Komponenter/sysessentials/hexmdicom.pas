  unit hexmdicom;

  interface

  Uses Windows, Forms, sysutils, classes, messages, controls,
  hexbase;

  { Message declarations }
  Const
  WM_HEXCOMMESSAGE      = WM_USER + $1673;
  WM_HEXCLIENTCONNECT   = WM_HEXCOMMESSAGE + $1674;
  WM_HEXCLIENTDISCONNECT= WM_HEXCOMMESSAGE + $1675;
  WM_HEXCOMUSER         = WM_HEXCOMMESSAGE + $4000;

  Const
  RESULT_OK     = 1;
  RESULT_FAILED = 0;

  Type

  PHexCmdPacket = ^THexCmdpacket;
  THexCmdPacket = Packed Record
    Sender:   TObject;
    Command:  Integer;
    Data:     Pointer;
  End;

  THexMDIClient = Class;

  THexCmdRecievedEvent      = Procedure (Sender:TObject;Command:Integer;Data:Pointer) of Object;
  THexClientConnectEvent    = Procedure (Sender:TObject;Client:THexMDIClient) of Object;
  THexClientDisconnectEvent = Procedure (Sender:TObject;Client:THexMDIClient) of Object;

  THexMDIHost = Class(THexCustomComponent)
  private
    FObjects:         TList;
    FOnCmdRecieved:   THexCmdRecievedEvent;
    FOnClientConnect: THexClientConnectEvent;
    FOnClientDisconnect:  THexClientDisconnectEvent;
    Function          GetCount:Integer;
    Function          GetItem(index:Integer):TObject;
  Protected
    procedure       WMHexComMessage(var Message: TMessage);
    Procedure       WMHexClientDisconnect(Var message: TMessage);
    Procedure       WMHexClientConnect(Var Message: Tmessage);
  Public
    Property        ClientCount:Integer read GetCount;
    Property        Client[index:integer]:TObject read GetItem;
    function        Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
    Function        Send(clientindex:Integer;cmd:Integer;data:pointer):Boolean;
    Procedure       DisconnectAll;
    Procedure       Disconnect(Index:Integer);
    Procedure       SendToAll(cmd:Integer;data:pointer);
    Constructor     Create(AOwner:TComponent);Override;
    Destructor      Destroy;Override;
  Published
    Property        OnClientConnected: THexClientConnectEvent read FOnClientConnect write FOnClientConnect;
    Property        OnClientDisconnected: THexClientDisConnectEvent read FOnClientDisconnect write FOnClientDisconnect;
    Property        OnCommandRecieved: THexCmdRecievedEvent read FOncmdRecieved write FOncmdRecieved;
  End;

  THexMDIClient = Class(THexCustomComponent)
  private
    FConnected:       Boolean;
    FOnCmdRecieved:   THexCmdRecievedEvent;
    FOnConnected:     TNotifyEvent;
    FOnDisconnected:  TNotifyevent;
    FHostName:        String;
    FHost:            THexMDIHost;
  Public
    property          Connected:Boolean read FConnected;
    function          Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
    Function          Send(cmd:Integer;Data:pointer):Boolean;
    Procedure         Connect;
    Procedure         Disconnect;
    Constructor       Create(Aowner:TComponent);Override;
  Published
    Property          HostName:String read FHostName write FHostName;
    Property          OnCommandRecieved: THexCmdRecievedEvent read FOncmdRecieved write FOncmdRecieved;
    Property          OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    Property          OnDisconnected: TNotifyEvent read FOnDisConnected write FOnDisConnected;
  End;

  implementation

  //######################################################################
  // THexMDIClient
  //######################################################################

  Constructor THexMDIClient.Create(Aowner:TComponent);
  Begin
    { make sure this is a form }
    If not (AOwner is TForm) then
    Begin
      Raise Exception.Create('This component can only be placed on a Form');
      exit;
    end;

    inherited Create(Aowner);
  end;

  Function THexMDIClient.Send(cmd:Integer;data:pointer):Boolean;
  var
    FData:  THexCmdPacket;
  Begin
    { Are we connected to host? }
    If not Connected then
    Begin
      result:=False;
      exit;
    end;

    { populate data packet }
    FData.Sender:=self;
    FData.Command:=cmd;
    FData.Data:=Data;

    { send to host }
    result:=FHost.Perform
      (
      WM_HEXCOMMESSAGE,
      Integer(self),
      integer(pointer(@FData))
      )=RESULT_OK;
  end;

  Procedure THexMDIClient.Connect;
  var
    x,y:      Integer;
    FCom:     TComponent;
  Begin
    { already connected? }
    If Connected then
    exit;

    for x:=1 to screen.FormCount do
    Begin
      for y:=1 to screen.Forms[x-1].ComponentCount do
      Begin
        FCom:=Screen.Forms[x-1].Components[y-1];
        If  (FCom is THexMDIHost)
        and (FCom.name = HostName) then
        Begin
          { attempt to connect }
          If THexMDIHost(FCom).Perform(WM_HEXCLIENTCONNECT,Integer(self),0)=RESULT_OK then
          Begin
            { we are connected }
            FConnected:=True;
            FHost:=THexMDIHost(FCom);

            Owner.FreeNotification(self);

            if assigned(FOnConnected) then
            FOnConnected(self);
          end;
          Break;
        end;
      end;
    end;
  end;

  Procedure THexMDIClient.Disconnect;
  Begin
    { check that we can do this }
    If not Connected then
    exit;

    { if the app is closing down, sending a disconnect
      will cause an exception }
    if (csDestroying in FHost.componentstate) then
    exit;

    If FHost.Perform(WM_HEXCLIENTDISCONNECT,Integer(self),0)=RESULT_OK then
    Begin
      FConnected:=False;
      FHost:=NIL;

      if assigned(FOnDisconnected) then
      FOnDisconnected(self);
    end;
  end;

  function THexMDIClient.Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
  var
    FData:  PHexCmdPacket;
  Begin
    { any point to this? }
    if not assigned(OnCommandRecieved) then
    begin
      Result:=RESULT_FAILED;
      exit;
    end;

    { make sure we are connected }
    if not Connected then
    begin
      result:=RESULT_FAILED;
      exit;
    end;

    { we only accept this command }
    if not msg=WM_HEXCOMMESSAGE then
    begin
      result:=RESULT_Failed;
      exit;
    end;

    { Get a ptr to the packet WParam is the host component!}
    FData:=pointer(LParam);

    { notify our host app }
    OnCommandRecieved(FHost,FData^.Command,FData^.Data);

    result:=RESULT_OK;
  end;

  //######################################################################
  // THexMDIHost
  //######################################################################

  Constructor THexMDIHost.Create(Aowner:TComponent);
  Begin
    { make sure this is a form }
    If not (AOwner is TForm) then
    Begin
      Raise Exception.Create('This component can only be placed on a Form');
      exit;
    end;

    inherited Create(AOwner);
    FObjects:=TList.Create;
  end;

  Destructor THexMDIHost.Destroy;
  begin
    FObjects.free;
    inherited;
  end;

  function THexMDIHost.Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
  var
    FMessage: Tmessage;
  Begin
    FMessage.Msg:=msg;
    FMessage.WParam:=WParam;
    Fmessage.LParam:=LParam;
    FMessage.Result:=0;

    Case msg of
    WM_HEXCLIENTCONNECT:    WMHexClientConnect(FMessage);
    WM_HexClientDisconnect: WMHexClientDisconnect(FMessage);
    WM_HexComMessage:       WMHexComMessage(Fmessage);
    else
      Begin
        result:=RESULT_FAILED;
        exit;
      end;
    end;

    result:=FMessage.Result;
  end;

  Procedure THexMDIHost.WMHexComMessage(var Message: TMessage);
  var
    FData:  PHexCmdPacket;
    FClient:  THexMDIClient;
  Begin
    { any point to this? }
    if not assigned(OnCommandRecieved) then
    begin
      message.Result:=RESULT_FAILED;
      exit;
    end;

    FClient:=THexMDIClient(Message.WParam); { client object }
    FData:=PHexCmdPacket(Message.LParam);   { data package }

    { Client not in our collection? }
    If Fobjects.IndexOf(FClient)=-1 then
    Begin
      message.result:=RESULT_FAILED;
      exit;
    end;

    { notify our host app }
    OnCommandRecieved(FClient,FData^.Command,FData^.Data);

    Message.result:=RESULT_OK;
  end;

  Procedure THexMDIHost.WMHexClientDisconnect(Var message: TMessage);
  var
    FIndex:   Integer;
    FClient:  THexMDIClient;
  Begin
    FClient:=THexMDIClient(Message.WParam);
    FIndex:=FObjects.IndexOf(FClient);

    { Object not in our collection? }
    If FIndex=-1 then
    exit;

    if assigned(FOnClientDisConnect) then
    FOnClientDisConnect(self,FClient);

    { remove client from our list }
    FObjects.Delete(FIndex);

    { you are now disconnected }
    message.Result:=RESULT_OK;
  end;

  Procedure THexMDIHost.WMHexClientConnect(Var Message: TMessage);
  var
    FClient:  THexMDIClient;
  Begin
    { Typecast the sender }
    FClient:=THexMDIClient(Message.WParam);

    { object already in collection? }
    If not FObjects.IndexOf(FClient)=-1 then
    exit;

    { add client to our list }
    FObjects.Add(FClient);

    if assigned(FOnClientConnect) then
    FOnClientConnect(self,FClient);

    { you are connected }
    message.Result:=RESULT_OK;
  end;

  Function THexMDIHost.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  end;

  Function THexMDIHost.GetItem(Index:Integer):TObject;
  Begin
    result:=TObject(FObjects[index]);
  end;

  Procedure THexMDIHost.DisconnectAll;
  Begin
    { disconnect all connected clients }
    while FObjects.Count>0 do
    THexMDIClient(FObjects[0]).Disconnect;
  end;

  Procedure THexMDIHost.Disconnect(Index:Integer);
  Begin
    THexMDIClient(FObjects[index]).Disconnect;
  end;

  Function THexMDIHost.Send(ClientIndex:Integer;cmd:Integer;data:pointer):Boolean;
  var
    FData:  THexCmdPacket;
    FClient:  THexMDIClient;
  begin
    { No such object in our collection? }
    If (FObjects.Count=0)
    or (ClientIndex<0)
    or (ClientIndex>FObjects.Count-1) then
    Begin
      result:=False;
      exit;
    end;

    { populate data packet }
    FData.Sender:=self;
    FData.Command:=cmd;
    FData.Data:=data;

    { Typecast our client }
    FClient:=THexMDIClient(FObjects[ClientIndex]);

    { send packet }
    result:=FClient.perform(WM_HEXCOMMESSAGE,Integer(self),Integer(pointer(@FData)))=RESULT_OK;
  end;

  Procedure THexMDIHost.SendToAll(cmd:Integer;data:pointer);
  var
    x:  Integer;
  Begin
    If Fobjects.Count>0 then
    begin
      for x:=1 to FObjects.Count do
      Send(x-1,cmd,data);
    end;
  end;

  end.
