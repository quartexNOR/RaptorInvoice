  unit clientform;

  interface

  uses
  Forms, Windows, Messages, SysUtils, Classes, Graphics, db,
  Controls, Dialogs, StdCtrls, ExtCtrls, ActnList, ImgList, DBCtrls,
  globalvalues, data, RzLabel, RzDlgBtn, RzBckgnd, RzButton, RzStatus,
  RzPanel, RzDBNav, RzSndMsg;

  Type

  TfrmClient = class(TForm)
    ActionList1: TActionList;
    DoOK: TAction;
    DoCancel: TAction;
    RzSeparator1: TRzSeparator;
    RzPanel1: TRzPanel;
    Image2: TImage;
    lbTitle: TRzLabel;
    lbHelp1: TRzLabel;
    lbHelp2: TRzLabel;
    Image1: TImage;
    DoSendMail: TAction;
    Mailer: TRzSendMessage;
    DoFindOrgId: TAction;
    RzDialogButtons1: TRzDialogButtons;
    NavigatorPanel: TPanel;
    nLocked: TImage;
    dbximages: TImageList;
    dbxActions: TActionList;
    doGoFirst: TAction;
    doGoBack: TAction;
    doGoForward: TAction;
    doGoLast: TAction;
    dbxPanel: TRzPanel;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    RzToolButton3: TRzToolButton;
    RzToolButton4: TRzToolButton;
    procedure DoCancelExecute(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure DoSendMailExecute(Sender: TObject);
    procedure DoFindOrgIdExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure doGoFirstUpdate(Sender: TObject);
    procedure doGoFirstExecute(Sender: TObject);
    procedure doGoBackUpdate(Sender: TObject);
    procedure doGoBackExecute(Sender: TObject);
    procedure doGoForwardExecute(Sender: TObject);
    procedure doGoForwardUpdate(Sender: TObject);
    procedure doGoLastExecute(Sender: TObject);
    procedure doGoLastUpdate(Sender: TObject);
  private
    FDataMode:  TAppRecordMode;
    FUseDS:     Boolean;
    FDataset:   TDataset;
    FNavEn:     Boolean;
    FChanged:   Boolean;
  protected
    Property    GetUsesDataset:Boolean read FUseDS;

    Function    GetMailAdresse:String;Virtual;
    Function    GetSearchKeyword:String;Virtual;
    Procedure   CauseFieldError(FieldName:String);
    Procedure   CauseAdresseError;

    Function    BeforeNavigate:Boolean;virtual;
    Function    GetNavigatorDataset:TDataset;virtual;
    Procedure   HideNavigator;
    procedure   ShowNavigator;
    Procedure   EnableNavigator;
    procedure   DisableNavigator;

    Procedure   SetChanged(Value:Boolean);
    Function    GetChanged:Boolean;
    Procedure   ResetChanged;

    Procedure   HandleEditChanged(Sender:TObject);

    Function    MVAListTo(Const aList:TStrings):Boolean;
  public
    Property    RecordMode: TAppRecordMode read FDataMode write FDataMode;
  end;

  implementation

  {$R *.DFM}

  uses shellapi, jlcommon;

  procedure TfrmClient.FormCreate(Sender: TObject);
  begin
    ResetChanged;
    FDataset:=GetNavigatorDataset;
    FUseDS:=assigned(FDataset)
    and FDataset.Active;
  end;

  Procedure TfrmClient.HandleEditChanged(Sender:TObject);
  Begin
    If GetChanged=False then
    Begin
      If FUseDS then
      Begin
        If not AppData.DataStoreReadOnly then
        Begin
          If (FDataset.State in [dsEdit,dsInsert]) then
          SetChanged(true);
        end;
      end;
    end;
  end;

  Procedure TfrmClient.SetChanged(Value:Boolean);
  Begin
    FChanged:=Value;
  end;

  Function TfrmClient.GetChanged:Boolean;
  Begin
    result:=FChanged;
  end;

  Procedure TfrmClient.ResetChanged;
  Begin
    FChanged:=False;
  end;
  
  Function TfrmClient.BeforeNavigate:Boolean;
  Begin
    result:=True;
  end;
  
  Function TfrmClient.GetNavigatorDataset:TDataset;
  Begin
    result:=NIL;
  end;

  Procedure TfrmClient.EnableNavigator;
  Begin
    FNavEn:=True;
  end;

  procedure TfrmClient.DisableNavigator;
  Begin
    FNavEn:=False;
  end;

  Procedure TfrmClient.HideNavigator;
  Begin
    dbxpanel.Visible:=False;
  end;

  procedure TfrmClient.ShowNavigator;
  Begin
   dbxpanel.Visible:=True;
  end;
  
  Function TfrmClient.MVAListTo(Const aList:TStrings):Boolean;
  var
    x:  Integer;
    FMVAList: TIntArray;
    FTitle: String;
  begin
    result:=False;
    if aList<>NIL then
    Begin
      if appdata.GetMVAList(FMVAList) then
      Begin
        aList.BeginUpdate;
        try
          aList.Clear;
          for x:=Low(FMVAList) to high(FMVAList) do
          Begin
            FTitle:=IntToStr(FMVAList[x]) + '%';
            aList.Add(FTitle)
          end;
          result:=Length(FMVAList)>0;
        finally
          aList.EndUpdate;
        end;
      end;
    end;
  end;

  procedure TfrmClient.DoCancelExecute(Sender: TObject);
  begin
    modalresult:=mrCancel;
  end;

  procedure TfrmClient.DoOKExecute(Sender: TObject);
  begin
    modalresult:=mrOK;
  end;

  Function TfrmClient.GetMailAdresse:String;
  Begin
    result:='none@nowhere.com';
  end;

  Function TfrmClient.GetSearchKeyWord:String;
  Begin
    result:='';
  end;

  Procedure TfrmClient.CauseFieldError(FieldName:String);
  var
    FText:  String;
  begin
    FText:=Format('Feltet "%s" inneholder ingen eller feil informasjon',[fieldname]);
    Application.MessageBox(PChar(FText),'Informasjonsfeil',MB_ICONINFORMATION);
  End;

  Procedure TfrmClient.CauseAdresseError;
  var
    FText:  String;
  begin
    FText:='Feltene Adresse 1 og Adresse 2 må begge fylles ut!'#13;
    FText:=FText + 'Hvis du kun har en adresse, bruk minus (-) symbolet til å fylle ut Adresse 2 feltet med.';
    Application.MessageBox(PChar(FText),'Adressefeil',MB_ICONINFORMATION);
  End;


  procedure TfrmClient.DoSendMailExecute(Sender: TObject);
  var
    FValue: String;
  begin
    Mailer.toRecipients.add(GetMailAdresse);
    mailer.MessageText.add(AppData.Prefs.ReadString(PREFS_FIRMA));
    mailer.MessageText.Add('Kontaktperson: ' + AppData.Prefs.ReadString(PREFS_REFERANSE_NAVN));

    FValue:=AppData.Prefs.ReadString(PREFS_ADRESSE_A);
    If length(FValue)>0 then
    if (FValue<>'-') then
    Mailer.MessageText.add(FValue);

    FValue:=AppData.Prefs.ReadString(PREFS_ADRESSE_B);
    If length(FValue)>0 then
    if (FValue<>'-') then
    Mailer.MessageText.add(FValue);

    mailer.MessageText.add(IntToStr(AppData.Prefs.ReadInteger(PREFS_POSTNR))
    + ' ' + AppData.Prefs.ReadString(PREFS_STED));

    mailer.MessageText.add('Telefon: ' + AppData.Prefs.ReadString(PREFS_TELEFON));
    mailer.MessageText.add('Fax: ' + AppData.Prefs.ReadString(PREFS_FAX));
    mailer.MessageText.add('Epost: ' + AppData.Prefs.ReadString(PREFS_EMAIL));
    mailer.MessageText.add('Nettsted: ' + AppData.Prefs.ReadString(PREFS_WWW));

    try
      mailer.Send;
    except
      on e: exception do
      ShowMessage('Programmet klarte ikke skape meldingen: ' + e.message);
    end;
  end;

  procedure TfrmClient.DoFindOrgIdExecute(Sender: TObject);
  var
    FText:  String;
    FUrl:   String;
  begin
    FText:=GetSearchKeyword;
    If Length(FText)=0 then
    ShowMessage('Navnet er desverre ikke mulig å søke etter')
    else
    Begin
      FText:=StringReplace(FText,#32,'%20',[rfReplaceAll]);
      FUrl:='http://www3.brreg.no/oppslag/enhet/treffliste.jsp?navn=§name§&orgform=0&fylke=0&kommune=0';
      FUrl:=StringReplace(FUrl,'§name§',FText,[rfReplaceAll]);
      ShellExecute(0,'open',PChar(FUrl),NIL,NIL,SW_SHOWDEFAULT);
    end;
  end;

  procedure TfrmClient.doGoFirstExecute(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if BeforeNavigate then
      FDataset.First;
    end;
  end;

  procedure TfrmClient.doGoFirstUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      If  (FUseDS=True)
      and (FDataset<>NIL)
      and (FDataset.Active) then
      Begin
        DoGoFirst.Enabled:=(FDataset.RecordCount>1)
        and ( (FDataset.RecNo>1) or (FDataset.recNo=-1) );
      end else
      DoGoFirst.Enabled:=False;
    end;
  end;

  procedure TfrmClient.doGoBackExecute(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if BeforeNavigate then
      FDataset.Prior;
    end;
  end;

  procedure TfrmClient.doGoBackUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      If  (FUseDS=True)
      and (FDataset<>NIL)
      and (FDataset.Active) then
      Begin
        doGoBack.Enabled:=(FDataset.RecordCount>1)
        and ( (FDataset.RecNo>1) or (FDataset.recNo=-1) );
      end else
      doGoBack.Enabled:=False;
    end;
  end;

  procedure TfrmClient.doGoForwardExecute(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if BeforeNavigate then
      FDataset.Next;
    end;
  end;

  procedure TfrmClient.doGoForwardUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      If  (FUseDS=True)
      and (FDataset<>NIL)
      and (FDataset.Active) then
      Begin
        If  FDataset.state=dsInsert then
        DoGoForward.Enabled:=false else
        doGoForward.Enabled:=(FDataset.RecordCount>0)
        and (FDataset.RecNo<FDataset.RecordCount);
      end else
      DoGoForward.Enabled:=False;
    end;
  end;

  procedure TfrmClient.doGoLastExecute(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if BeforeNavigate then
      FDataset.Last;
    end;
  end;

  procedure TfrmClient.doGoLastUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      If  (FUseDS=True)
      and (FDataset<>NIL)
      and (FDataset.Active) then
      Begin
        If  FDataset.state=dsInsert then
        doGoLast.Enabled:=false else
        doGoLast.Enabled:=(FDataset.RecordCount>0)
        and (FDataset.RecNo<FDataset.RecordCount);
      end else
      doGoLast.Enabled:=False;
    end;
  end;

end.
