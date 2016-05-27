  unit kundeForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, clientform, ActnList, StdCtrls, ExtCtrls, Mask,
  ComCtrls, ImgList, db, DBCtrls, globalvalues, data,
  RzButton, RzBckgnd, RzLabel, RzStatus, RzPanel, RzDBNav,
  RzDTP, RzRadChk, RzSpnEdt, RzPopups, RzDBEdit, RzTabs, RzEdit, RzDBCmbo,
  RzSndMsg, RzDlgBtn;

  Type

  TfrmKunde = class(TfrmClient)
    RzGroupBox1: TRzGroupBox;
    RzPageControl1: TRzPageControl;
    TabSheet3: TRzTabSheet;
    TabSheet4: TRzTabSheet;
    Panel4: TPanel;
    RzDBMemo1: TRzDBMemo;
    lbKunde: TRzLabel;
    lbAdresse: TRzLabel;
    lbPostNr: TRzLabel;
    RzLabel6: TRzLabel;
    nAdresse: TRzDBEdit;
    nFirma: TRzDBEdit;
    lbSted: TRzLabel;
    RzLabel8: TRzLabel;
    nSted: TRzDBEdit;
    RzLabel9: TRzLabel;
    RzDBEdit1: TRzDBEdit;
    RzLabel10: TRzLabel;
    RzDBEdit2: TRzDBEdit;
    RzLabel11: TRzLabel;
    RzDBEdit3: TRzDBEdit;
    RzLabel12: TRzLabel;
    RzDBEdit4: TRzDBEdit;
    nPostNr: TRzDBEdit;
    lbAdresse2: TRzLabel;
    nAdresse2: TRzDBEdit;
    nTelefon: TRzDBEdit;
    nFaks: TRzDBEdit;
    nKundeGruppe: TRzDBLookupComboBox;
    RzLabel1: TRzLabel;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    Panel6: TPanel;
    Image3: TImage;
    RzBitBtn3: TRzBitBtn;
    procedure FormShow(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure nPostNrExit(Sender: TObject);
    procedure nTelefonKeyPress(Sender: TObject; var Key: Char);
    procedure nFaksKeyPress(Sender: TObject; var Key: Char);
    procedure nPostNrKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzBitBtn2Click(Sender: TObject);
  private
  protected
    Function  GetMailAdresse:String;override;
    Function  GetSearchKeyword:String;Override;
  Protected
    Function  BeforeNavigate:Boolean;override;
    Function  GetNavigatorDataset:TDataset;override;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  uses shellapi;

  procedure TfrmKunde.FormShow(Sender: TObject);
  begin
    inherited;
    lbHelp1.Caption:=Format(lbHelp1.Caption,[DIALOG_KUNDE_TOPIC]);
    If RecordMode=arAppend then
    begin
      lbTitle.Caption:=DIALOG_KUNDE_TITLEAPPEND;
      DisableNavigator;
      //Navigator.Enabled:=False;

      If not appdata.DataStoreReadOnly then
      AppData.Kunder.Append;
    end else
    Begin
      lbTitle.Caption:=DIALOG_KUNDE_TITLEEDIT;
      EnableNavigator;
      //Navigator.Enabled:=True;

      If not appdata.DataStoreReadOnly then
      AppData.Kunder.Edit;
    End;

    nLocked.Visible:=appdata.Kunder.ReadOnly;
  end;

  Function TfrmKunde.BeforeNavigate:Boolean;
  Begin
    result:=Inherited BeforeNavigate;
    if (appdata.kunder.state in [dsInsert,dsEdit]) then
    Begin
      if application.MessageBox('Oppdatere kunde?',Application_Title,
      MB_YESNO or MB_ICONQUESTION)=ID_YES then
      Begin
        appdata.kunder.Post;
        appdata.kunder.ApplyUpdates;
      end else
      appdata.kunder.Cancel;
    end;
  end;
  
  Function TfrmKunde.GetNavigatorDataset:TDataset;
  Begin
    result:=inherited GetNavigatorDataset;
    if not (csDestroying in ComponentState)
    and not application.Terminated then
    result:=Appdata.Kunder;
  end;

  procedure TfrmKunde.DoCancelExecute(Sender: TObject);
  begin
    If not appdata.DataStoreReadOnly then
    Begin
      if (appdata.kunder.state in [dsInsert,dsEdit]) then
      Begin
        try
          AppData.Kunder.Cancel;
          AppData.Kunder.ApplyUpdates;
          AppData.Kunder.CommitUpdates;
        except
          on e: exception do
          ErrorDialog(ClassName,'DoCancelExecute()',e.message);
        end;
      end;
    end;
    inherited;
  end;

  procedure TfrmKunde.DoOKExecute(Sender: TObject);
  var
    FText:  String;
    FText2: String;
  begin
    (* check if we can do this *)
    If appdata.DataStoreReadOnly then
    Begin
      inherited;
      exit;
    end;

    lbPostNr.Blinking:=False;
    lbSted.Blinking:=False;
    lbAdresse.Blinking:=False;
    lbAdresse2.Blinking:=False;
    lbkunde.Blinking:=False;

    { Check leverandør field }
    FText:=trim(Appdata.KunderFirma.asString);
    if Length(FText)=0 then
    Begin
      CauseFieldError('kunde');
      lbKunde.Blinking:=True;
      nFirma.SetFocus;
      exit;
    End;

    { Check Adresse1 field }
    FText:=trim(Appdata.KunderAdresse.asString);
    FText2:=trim(Appdata.KunderAdresse2.asString);

    { Begge adressene tomme? }
    If  (Length(FText)=0)
    and (Length(FText2)=0) then
    Begin
      CauseAdresseError;
      lbAdresse.Blinking:=True;
      lbAdresse2.Blinking:=True;
      nAdresse.SetFocus;
      exit;
    end;

    { adresse1 tom? }
    If  (Length(FText)=0)
    and (Length(FText2)>0) then
    Begin
      CauseAdresseError;
      lbAdresse.Blinking:=True;
      nAdresse.SetFocus;
      exit;
    end;

    { adresse2 tom? }
    If  (Length(FText2)=0)
    and (Length(FText)>0) then
    Begin
      CauseAdresseError;
      lbAdresse2.Blinking:=True;
      nAdresse2.SetFocus;
      exit;
    end;

    { Check sted field }
    FText:=trim(Appdata.KunderSted.asString);
    if Length(FText)=0 then
    Begin
      CauseFieldError('sted');
      lbSted.Blinking:=True;
      nSted.SetFocus;
      exit;
    End;

    { Sjekk postnummer felt }
    FText:=trim(Appdata.KunderPostNr.asString);
    If Length(FText)=0 then
    Begin
      CauseFieldError('postnummer');
      lbPostNr.Blinking:=True;
      nPostNr.SetFocus;
      exit;
    End;

    if (Appdata.kunder.State in [dsEdit,dsInsert]) then
    { If (AppData.Kunder.State=dsEdit)
    or (AppData.Kunder.State=dsInsert) then }
    Begin
      try
        With AppData.Kunder do
        Begin
          Appdata.KunderSalg.AsCurrency:=0;
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

  Function TfrmKunde.GetMailAdresse:String;
  Begin
    result:=AppData.KunderEmail.asString;
  end;

  Function TfrmKunde.GetSearchKeyWord:String;
  Begin
    result:=AppData.kunderFirma.asString;
  end;

  procedure TfrmKunde.nPostNrExit(Sender: TObject);
  begin
    If not AppData.DataStoreReadOnly then
    Begin
      try
        If length(nSted.Text)=0 then
        If AppData.PostSteder.Find('PostNr',[nPostNr.Text],True) then
        Appdata.KunderSted.AsString:=Appdata.PoststederSted.asString;
      except
        on e: exception do
        ErrorDialog(ClassName,'nPostNrExit()',e.message);
      end;
    end;
  end;

  procedure TfrmKunde.nTelefonKeyPress(Sender: TObject; var Key: Char);
  begin
    If pos(Key,CHARSET_NUMERIC)<1 then
    begin
      Beep;
      Key:=#0;
    end;
  end;

  procedure TfrmKunde.nFaksKeyPress(Sender: TObject; var Key: Char);
  begin
    If pos(Key,CHARSET_NUMERIC)<1 then
    begin
      Beep;
      Key:=#0;
    end;
  end;

  procedure TfrmKunde.nPostNrKeyPress(Sender: TObject; var Key: Char);
  begin
    If pos(Key,CHARSET_NUMERIC)<1 then
    begin
      Beep;
      Key:=#0;
    end;
  end;

  procedure TfrmKunde.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    inherited;
    { If (Appdata.Kunder.State=dsInsert)
    or (Appdata.Kunder.State=dsEdit) then   }
    if (Appdata.kunder.State in [dsEdit,dsInsert]) then
    DoCancel.Execute;
  end;

  procedure TfrmKunde.RzBitBtn2Click(Sender: TObject);
  var
    FUrl: String;
  begin
    FUrl:=appdata.KunderInterNett.asString;
    If Length(FUrl)>0 then
    ShellExecute(0,'open',PChar(FUrl),NIL,NIL,SW_SHOWDEFAULT) else
    ShowMessage('Adressen er ikke gyldig');
  end;

  end.
