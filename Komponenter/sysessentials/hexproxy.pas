  unit hexproxy;

  interface

  uses sysutils, classes, hexbase;

  { What are proxies?
    =================
    A proxy is a middle-tier component that provides standard
    access methods to various information or media.
    Typical uses are for:

    * Directory listing (poor, but an example)
    * Custom binary cab files
    * Thumbnail binary files
    * installed network adapters
    * all of the above, but via Http, ftp or whatever protocol

    The concept is that no matter what media a proxy represents,
    or indeed, how complex the technical aspects of accessing it are -
    it can be accessed through the simple THexCustomProxy api.
  }

  Const
  ERR_HEX_ProxyFailedOpen   = 'Proxy failed to open : %s';
  ERR_Hex_ProxyFailedAccess = 'Failed to access proxy item : %s';

  Type
  { forward declarations }
  THexCustomProxy           = Class;
  THexCustomProxyItem       = Class;

  { General exceptions }
  EHexProxy                 = Class(EHEXException);
  EHexProxyFailedOpen       = Class(EHexProxy);
  EHexProxyFailedAccess     = Class(EHexProxy);

  { Events }
  THexProxyOpenedEvent      = Procedure (Sender:TObject) of Object;
  THexProxyClosedEvent      = Procedure (Sender:TObject) of Object;

  THexCustomProxyItem = Class(TInterfacedObject)
  Private
    FOwner:         THexCustomProxy;
  Public
    Function        ToString:String;Virtual;abstract;
    Property        Owner: THexCustomProxy read FOwner;
    Constructor     Create(Proxy:THexCustomProxy);virtual;
  End;

  THexCustomProxy = Class(THexCustomComponent)
  private
    FItemIndex:     Integer;
    FActive:        Boolean;
    FOnOpen:        THexProxyOpenedEvent;
    FOnClosed:      THexProxyClosedEvent;
  protected
    { these work fine as they are }
    Procedure       DoActiveChanged;virtual;
    Procedure       DoSetActive(Value:Boolean);virtual;

    { these must be overriden by decendants. }
    Function        DoGetItem:THexCustomProxyItem;virtual;
    Function        DoGetCount:Integer;virtual;
    Procedure       DoOpen(Value:String);Virtual;abstract;
    Procedure       DoClose;virtual;abstract;
    Function        DoGetEditable:Boolean;Virtual;
  Public
    Property        Editable:Boolean read DoGetEditable;
    Property        ItemIndex: Integer read FItemIndex;
    Property        OnOpen:THexProxyOpenedEvent read FOnOpen write FOnOpen;
    Property        OnClose:THexProxyClosedEvent read FOnClosed write FOnClosed;
    Property        Active:Boolean read FActive;
    Property        SelectedItem:THexCustomProxyItem read DoGetItem;

    Procedure       Open(Const Value:String);overload;
    Procedure       Open;Overload;
    Procedure       First;
    Procedure       Last;
    Function        MoreItems:Boolean;
    Procedure       Next;
    Procedure       Previous;
    Procedure       Close;
    Function        ToString:String;Virtual;abstract;
    Constructor     Create(AOwner:TComponent);Override;
    Destructor      Destroy;Override;
  End;

  implementation

  //#####################################################################
  // THexCustomProxy
  //#####################################################################

  Constructor THexCustomProxy.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FItemIndex:=-1;
  end;

  Destructor THexCustomProxy.Destroy;
  Begin
    Inherited;
  end;

  Function THexCustomProxy.DoGetCount:Integer;
  Begin
    result:=0;
  end;

  Procedure THexCustomProxy.First;
  Begin
    If DoGetCount=0 then
    FItemIndex:=-1 else
    FItemIndex:=0;
  end;

  Procedure THexCustomProxy.Last;
  Begin
    If DoGetCount=0 then
    FItemIndex:=-1 else
    FItemIndex:=DoGetCount-1;
  end;

  Function THexCustomProxy.MoreItems:Boolean;
  Begin
    If DoGetCount=0 then
    result:=False else
    Begin
      If FItemIndex>=DoGetCount then
      result:=False else
      result:=True;
    end;
  end;

  Procedure THexCustomProxy.Next;
  Begin
    If DoGetCount=0 then
    FItemIndex:=-1 else
    Begin
      If FItemIndex>=DoGetCount then
      exit else
      inc(FItemIndex);
    end;
  end;

  Procedure THexCustomProxy.Previous;
  Begin
    If DoGetCount=0 then
    FItemIndex:=-1 else
    If FItemIndex>0 then
    dec(FItemIndex);
  end;

  Procedure THexCustomProxy.Open;
  Begin
    try
      Open('');
    except
      on exception do
      raise;
    end;
  end;

  Procedure THexCustomProxy.Open(Const Value:String);
  Begin
    if Active then
    Close;

    try
      DoOpen(Value);
    except
      on exception do
      Begin
        raise;
        exit;
      end;
    end;

    If DoGetCount>0 then
    FItemIndex:=0;
  end;

  Procedure THexCustomProxy.Close;
  Begin
    If Active then
    Begin
      try
        DoClose;
      except
        on exception do
        Begin
          raise;
        end;
      end;
    end;
  end;

  Function THexCustomProxy.DoGetItem:THexCustomProxyItem;
  Begin
    result:=NIL;
  end;

  Function THexCustomProxy.DoGetEditable:Boolean;
  Begin
    result:=False;
  end;

  Procedure THexCustomProxy.DoSetActive(Value:Boolean);
  Begin
    If (Value<>FActive) then
    Begin
      FActive:=Value;
      DoActiveChanged;
    end;
  end;

  Procedure THexCustomProxy.DoActiveChanged;
  Begin
    { notify caller of state change }
    if Active then
    Begin
      If assigned(FOnOpen) then
      FOnOpen(self);
    end else
    If assigned(FOnClosed) then FOnClosed(Self);
  end;

  //#####################################################################
  // THexProxyItem
  //#####################################################################

  Constructor THexCustomProxyItem.Create(proxy:THexCustomProxy);
  begin
    inherited Create;
    FOwner:=Proxy;
  end;

  end.
