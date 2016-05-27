  unit hexgfxfileproxy;

  interface

  {$IFDEF WIN32}
  uses Forms, Windows, sysutils, classes, Graphics,
  hexbase, hexproxy;
  {$ENDIF}

  Type

  THexProxyImageItem = Class(THexCustomProxyItem)
  Private
    Function  DoGetExtension:String;
    Function  DoGetDescription: String;
  Public
    Property  Extension: String read DoGetExtension;
    Property  Description: String read DoGetDescription;
    Function  ToString:String;Override;
  End;

  IHexImageFormatProxy = Interface
    ['{B9834757-5DFF-4683-B767-E7712820047F}']
    Function  DoGetItemText:String;
    Function  DoGetExtension:String;
    Function  DogetDescription:String;
  End;

  THexImageFormatProxy = Class(THexCustomProxy,IHexImageFormatProxy)
  Private
    FItems:         TStringList;
    FDescriptions:  TStringList;
    FData:          THexProxyImageItem;
    Function        DoGetItemText:String;
    Function        DoGetExtension:String;
    Function        DoGetDescription:String;
  Protected
    Function        DoGetCount:Integer;override;
    Function        DoGetItem:THexCustomProxyItem;override;
    Function        GetItem:THexProxyImageItem;
    Procedure       DoOpen(Value:String);override;
    Procedure       DoClose;override;
  Public
    Property        SelectedItem:THexProxyImageItem read GetItem;
    Constructor     Create(AOwner:TComponent);Override;
    Destructor      Destroy;Override;
  Published
    Property        OnOpen;
    Property        OnClose;
  End;

  implementation

  //##############################################################
  // THexProxyImageItem
  //##############################################################

  Function THexProxyImageItem.ToString:String;
  Begin
    result:=DoGetExtension + ',' + DoGetDescription;
  end;

  Function THexProxyImageItem.DoGetExtension:String;
  Begin
    result:=IHexImageFormatProxy(THexImageFormatProxy(Owner)).DoGetExtension;
  end;

  Function THexProxyImageItem.DoGetDescription: String;
  Begin
    result:=IHexImageFormatProxy(THexImageFormatProxy(Owner)).DoGetDescription;
  end;

  //##############################################################
  // THexImageFormatProxy
  //##############################################################

  Constructor THexImageFormatProxy.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FItems:=TStringList.Create;
    FDescriptions:=TStringList.Create;
    FData:=THexProxyImageItem.Create(self);
  end;

  Destructor THexImageFormatProxy.Destroy;
  Begin
    FData.free;
    FDescriptions.free;
    FItems.free;
    inherited;
  end;

  Function THexImageFormatProxy.DoGetCount:Integer;
  Begin
    if not Active then
    result:=Inherited DoGetCount else
    result:=FItems.Count
  end;

  Function THexImageFormatProxy.DoGetItemText:String;
  Begin
    result:=FItems[ItemIndex] + ',' + FDescriptions[ItemIndex];
  end;

  Function THexImageFormatProxy.DoGetExtension:String;
  Begin
    result:=FItems[itemindex];
  end;

  Function THexImageFormatProxy.DoGetDescription:String;
  Begin
    result:=FDescriptions[itemindex];
  end;

  Function THexImageFormatProxy.DoGetItem:THexCustomProxyItem;
  Begin
    { not active? }
    if not Active then
    Begin
      result:=NIL;
      exit;
    end else
    result:=FData;
  end;

  Function THexImageFormatProxy.GetItem:THexProxyImageItem;
  Begin
    result:=THexProxyImageItem(DoGetItem);
  end;

  Procedure THexImageFormatProxy.DoOpen(Value:String);
 var
    x,xpos:   Integer;
    FBuffer:  String;
    FSegment: String;
    FTemp:    String;
  Begin
    { Grab compatible list segment }
    FBuffer:=GraphicFilter(TGraphic);

    x:=pos(')',FBuffer);
    if x>1 then
    delete(FBuffer,1,x+1) else
    exit;

    x:=Pos('|',FBuffer);
    If x>1 then
    delete(Fbuffer,1,x);

    FBuffer:=StringReplace(FBuffer,'|*','§',[rfReplaceAll]);

    for x:=1 to length(FBuffer) do
    begin
      if (FBuffer[x]='|')
      or (x=length(FBuffer)) then
      begin
        if length(FSegment)>0 then
        begin
          If x=Length(FBuffer) then
          FSegment:=FSegment + FBuffer[x];

          xpos:=Pos('§',FSegment);

          { Copy file extention }
          FItems.Add(Copy(FSegment,xpos+1,Length(FSegment)));

          { Grab description without filter *.? }
          FTemp:=Copy(FSegment,1,xpos-1);
          xpos:=Pos('(',FTemp);
          If xpos>0 then
          Delete(Ftemp,xpos,length(FTemp));

          FDescriptions.Add(FTemp);

          FSegment:='';
        end;
      end else
      FSegment:=FSegment + FBuffer[x];
    end;


    DoSetActive(True);
  end;

  Procedure THexImageFormatProxy.DoClose;
  Begin
    If Active then
    Begin
      FItems.Clear;
      FDescriptions.Clear;
      DoSetActive(False);
    end;
  end;

  end.
