  unit leverandorForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, clientform, ActnList, StdCtrls, ExtCtrls, Mask,
  ComCtrls, ImgList, db, DBCtrls, globalvalues, data,
  RzButton, RzBckgnd, RzLabel, RzStatus, RzPanel, RzDBNav,
  RzDTP, RzRadChk, RzSpnEdt, RzPopups, RzDBEdit, RzTabs, RzEdit, RzSndMsg,
  RzDlgBtn;

  Type

  TfrmLeverandor = class(TfrmClient)
    RzGroupBox1: TRzGroupBox;
    nFirma: TRzDBEdit;
    nAdresse: TRzDBEdit;
    nSted: TRzDBEdit;
    RzPageControl1: TRzPageControl;
    TabSheet3: TRzTabSheet;
    TabSheet4: TRzTabSheet;
    nInternKontakt: TRzDBEdit;
    nEMail: TRzDBEdit;
    nWWW: TRzDBEdit;
    nOrgId: TRzDBEdit;
    Panel4: TPanel;
    nNotes: TRzDBMemo;
    lbFirma: TRzLabel;
    lbAdresse: TRzLabel;
    lbPostNr: TRzLabel;
    lbSted: TRzLabel;
    lbFaks: TRzLabel;
    RzLabel9: TRzLabel;
    RzLabel10: TRzLabel;
    RzLabel11: TRzLabel;
    RzLabel12: TRzLabel;
    nPostNr: TRzDBEdit;
    nTelefon: TRzDBEdit;
    nFaks: TRzDBEdit;
    lbadresse2: TRzLabel;
    nAdresse2: TRzDBEdit;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    DoBrowse: TAction;
    Panel6: TPanel;
    Image3: TImage;
    RzBitBtn3: TRzBitBtn;
    lbTelefon: TRzLabel;
    procedure FormShow(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure nPostNrExit(Sender: TObject);
    procedure nTelefonKeyPress(Sender: TObject; var Key: Char);
    procedure nFaksKeyPress(Sender: TObject; var Key: Char);
    procedure nPostNrKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoBrowseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoBrowseUpdate(Sender: TObject);
    procedure DoSendMailUpdate(Sender: TObject);
    procedure DoFindOrgIdUpdate(Sender: TObject);
  private
    //
  Protected
    (* Navigator methods *)
    Function  GetNavigatorDataset:TDataset;override;
    Function  BeforeNavigate:Boolean;Override;
    Procedure SetChangeEvents;
    procedure ClearChangeEvents;
  protected
    Function  GetMailAdresse:String;override;
    Function  GetSearchKeyWord:String;override;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  uses shellapi;

  procedure TfrmLeverandor.FormCreate(Sender: TObject);
  begin
    inherited;
    //
  end;

  Procedure TfrmLeverandor.SetChangeEvents;
  Begin
    nFirma.OnChange:=HandleEditChanged;
    nAdresse.OnChange:=HandleEditChanged;
    nAdresse2.OnChange:=HandleEditChanged;
    nPostNr.OnChange:=HandleEditChanged;
    nSted.OnChange:=HandleEditChanged;
    nTelefon.OnChange:=HandleEditChanged;
    nFaks.OnChange:=HandleEditChanged;
    nInternKontakt.OnChange:=HandleEditChanged;
    nEmail.OnChange:=HandleEditChanged;
    nWWW.OnChange:=HandleEditChanged;
    nOrgId.OnChange:=HandleEditChanged;
    nNotes.OnChange:=HandleEditChanged;
  end;

  procedure TfrmLeverandor.ClearChangeEvents;
  Begin
    nFirma.OnChange:=NIL;
    nAdresse.OnChange:=NIL;
    nAdresse2.OnChange:=NIL;
    nPostNr.OnChange:=NIL;
    nSted.OnChange:=NIL;
    nTelefon.OnChange:=NIL;
    nFaks.OnChange:=NIL;
    nInternKontakt.OnChange:=NIL;
    nEmail.OnChange:=NIL;
    nWWW.OnChange:=NIL;
    nOrgId.OnChange:=NIL;
    nNotes.OnChange:=NIL;
  end;
  
  procedure TfrmLeverandor.FormShow(Sender: TObject);
  begin
    inherited;
    lbHelp1.Caption:=Format(lbHelp1.Caption,[DIALOG_LEVERANDOR_TOPIC]);
    If RecordMode=arAppend then
    begin
      lbTitle.Caption:=DIALOG_LEVERANDOR_TITLEAPPEND;
      self.DisableNavigator;
      If not AppData.DataStoreReadOnly then
      Begin
        AppData.Leverandorer.Append;
        SetChangeEvents;
      end;
    end else
    Begin
      lbTitle.Caption:=DIALOG_LEVERANDOR_TITLEEDIT;
      self.EnableNavigator;
      If not AppData.DataStoreReadOnly then
      Begin
        AppData.Leverandorer.Edit;
        SetChangeEvents;
      end;
    End;
    nLocked.visible:=Appdata.leverandorer.ReadOnly;
  end;

  Function TfrmLeverandor.GetNavigatorDataset:TDataset;
  Begin
    result:=inherited GetNavigatorDataset;
    if not (csDestroying in ComponentState)
    and not application.Terminated then
    result:=Appdata.Leverandorer;
  end;

  Function TfrmLeverandor.BeforeNavigate:Boolean;
  Begin
    result:=Inherited BeforeNavigate;
    if (appdata.leverandorer.state in [dsInsert,dsEdit]) then
    Begin
      If  (GetChanged=False)
      and (appdata.leverandorer.state=dsInsert) then
      Begin
        Showmessage('Cancel new record?');
        appdata.leverandorer.Cancel;
        exit;
      end;

      If GetChanged then
      Begin

        if application.MessageBox('Oppdatere leverandør?',Application_Title,
        MB_YESNO or MB_ICONQUESTION)=ID_YES then
        Begin
          appdata.leverandorer.Post;
          appdata.leverandorer.ApplyUpdates;
        end else
        appdata.leverandorer.Cancel;

        ResetChanged;

      end;
    end;
  end;
  
  procedure TfrmLeverandor.DoCancelExecute(Sender: TObject);
  begin
    If not Appdata.leverandorer.ReadOnly then
    Begin
      If (AppData.Leverandorer.State=dsEdit)
      or (AppData.Leverandorer.State=dsInsert) then
      Begin
        try
          With AppData.Leverandorer do
          Begin
            Cancel;
            CommitUpdates;
          end;
        except
          on e: exception do
          ErrorDialog(ClassName,'DoCancelExecute()',e.message);
        end;
      end;
    end;
    inherited;
  end;

  procedure TfrmLeverandor.DoOKExecute(Sender: TObject);
  var
    FText:  String;
    FText2: String;
  begin
    (* check that we can do this *)
    If AppData.DataStoreReadOnly then
    Begin
      Inherited;
      exit;
    end;

    lbPostNr.Blinking:=False;
    lbSted.Blinking:=False;
    lbAdresse.Blinking:=False;
    lbAdresse2.Blinking:=False;
    lbFirma.Blinking:=False;

    { Check leverandør field }
    FText:=trim(Appdata.leverandorerFirma.Value);
    if Length(FText)=0 then
    Begin
      CauseFieldError('leverandør');
      lbFirma.Blinking:=True;
      nFirma.SetFocus;
      modalresult:=mrNone;
      exit;
    End;

    { Check Adresse1 field }
    FText:=trim(AppData.LeverandorerAdresse.Value);
    FText2:=trim(Appdata.LeverandorerAdresse2.Value);

    { Begge adressene tomme? }
    If  (Length(FText)=0)
    and (Length(FText2)=0) then
    Begin
      CauseAdresseError;
      lbAdresse.Blinking:=True;
      lbAdresse2.Blinking:=True;
      nAdresse.SetFocus;
      modalresult:=mrNone;
      exit;
    end;

    { adresse1 tom? }
    If  (Length(FText)=0)
    and (Length(FText2)>0) then
    Begin
      CauseAdresseError;
      lbAdresse.Blinking:=True;
      nAdresse.SetFocus;
      modalresult:=mrNone;
      exit;
    end;

    { adresse2 tom? }
    If  (Length(FText2)=0)
    and (Length(FText)>0) then
    Begin
      CauseAdresseError;
      lbAdresse2.Blinking:=True;
      nAdresse2.SetFocus;
      modalresult:=mrNone;
      exit;
    end;

    { Check sted field }
    FText:=trim(AppData.LeverandorerSted.Value);
    if Length(FText)=0 then
    Begin
      CauseFieldError('sted');
      lbSted.Blinking:=True;
      nSted.SetFocus;
      modalresult:=mrNone;
      exit;
    End;

    { Sjekk postnummer felt }
    FText:=trim(Appdata.LeverandorerPostNr.Value);
    If Length(FText)=0 then
    Begin
      CauseFieldError('postnummer');
      lbPostNr.Blinking:=True;
      nPostNr.SetFocus;
      modalresult:=mrNone;
      exit;
    End;

    If (AppData.Leverandorer.State=dsEdit)
    or (AppData.Leverandorer.State=dsInsert) then
    Begin
      try
        With AppData.Leverandorer do
        Begin
          Post;
          ApplyUpdates;
          CommitUpdates;
        end;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoOKExecute()',e.message);
      end;
    end;
    inherited;
  end;

  Function TFrmLeverandor.GetMailAdresse:String;
  Begin
    result:=AppData.LeverandorerEMail.Value;
  end;

  procedure TfrmLeverandor.nPostNrExit(Sender: TObject);
  begin
    try
      If length(nSted.Text)=0 then
      If AppData.PostSteder.Find('PostNr',[nPostNr.Text],True) then
      Appdata.LeverandorerSted.asstring:=Appdata.PostStederSted.AsString;
    except
      on e: exception do
      ErrorDialog(ClassName,'nPostNrExit()',e.message);
    end;
  end;

  procedure TfrmLeverandor.nTelefonKeyPress(Sender: TObject; var Key: Char);
  begin
    If pos(Key,CHARSET_NUMERIC)<1 then
    begin
      Beep;
      Key:=#0;
    end;
  end;

  procedure TfrmLeverandor.nFaksKeyPress(Sender: TObject; var Key: Char);
  begin
    If pos(Key,CHARSET_NUMERIC)<1 then
    begin
      Beep;
      Key:=#0;
    end;
  end;

  procedure TfrmLeverandor.nPostNrKeyPress(Sender: TObject; var Key: Char);
  begin
    If pos(Key,CHARSET_NUMERIC)<1 then
    begin
      Beep;
      Key:=#0;
    end;
  end;

  procedure TfrmLeverandor.FormClose(Sender: TObject;var Action: TCloseAction);
  begin
    inherited;
    If (Appdata.Leverandorer.State=dsInsert)
    or (Appdata.Leverandorer.State=dsEdit) then
    DOCancel.Execute;
  end;

  procedure TfrmLeverandor.DoBrowseExecute(Sender: TObject);
  var
    FUrl: String;
  begin
    FUrl:=appdata.leverandorerInterNett.AsString;
    If Length(FUrl)>0 then
    ShellExecute(0,'open',PChar(FUrl),NIL,NIL,SW_SHOWDEFAULT) else
    ShowMessage('Adressen er ikke gyldig');
  end;

  Function TfrmLeverandor.GetSearchKeyWord:String;
  Begin
    result:=AppData.LeverandorerFirma.AsString;
  end;

  procedure TfrmLeverandor.DoBrowseUpdate(Sender: TObject);
  var
    FText:  String;
  begin
    inherited;
    if not (csDestroying in ComponentState) then
    Begin
      FText:=trim(nWWW.Text);
      DoBrowse.Enabled:=Length(FText)>0;
    end;
  end;

  procedure TfrmLeverandor.DoSendMailUpdate(Sender: TObject);
  var
    FText:  String;
  begin
    inherited;
    if not (csDestroying in ComponentState) then
    Begin
      FText:=trim(nEmail.Text);
      DoSendMail.Enabled:=Length(FText)>0;
    end;
  end;

  procedure TfrmLeverandor.DoFindOrgIdUpdate(Sender: TObject);
  var
    FText:  String;
  begin
    inherited;
    if not (csDestroying in ComponentState) then
    Begin
      FText:=trim(nOrgId.Text);
      DoFindOrgId.Enabled:=Length(FText)>0;
    end;
  end;

end.
