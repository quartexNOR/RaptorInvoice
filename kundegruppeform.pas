  unit kundegruppeform;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  clientform, ActnList, StdCtrls, RzLabel, ExtCtrls, RzPanel, DBCtrls,
  RzDBNav, RzButton, RzBckgnd, globalvalues, db, data, RzDBEdit, RzTabs,
  Mask, RzEdit, RzRadChk, RzDBChk, RzSndMsg, RzSpnEdt, RzDBSpin, RzDlgBtn,
  ImgList;

  type TfrmKundeGruppe = class(TfrmClient)
    RzGroupBox1: TRzGroupBox;
    RzTabControl1: TRzTabControl;
    Panel4: TPanel;
    RzDBMemo1: TRzDBMemo;
    lbNavn: TRzLabel;
    nNavn: TRzDBEdit;
    lbRabatt: TRzLabel;
    RzGroupBox2: TRzGroupBox;
    Label1: TLabel;
    nAktivRabatt: TRzDBCheckBox;
    lbValgFriId: TRzLabel;
    nRefNum: TRzDBEdit;
    nRabatt: TRzDBSpinner;
    RzSeparator2: TRzSeparator;
    procedure DoCancelExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
  private
    { Private declarations }
  Protected
    Function GetNavigatorDataset:TDataset;override;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmKundeGruppe.FormShow(Sender: TObject);
  begin
    inherited;
    lbHelp1.Caption:=Format(lbHelp1.Caption,[DIALOG_KUNDEGRUPPE_TOPIC]);
    If RecordMode=arAppend then
    begin
      lbTitle.Caption:=DIALOG_KUNDEGRUPPE_TITLEAppend;
      self.DisableNavigator;
      //Navigator.Enabled:=False;
      If not appdata.KundeGrupper.ReadOnly then
      Begin
        AppData.kundegrupper.Append;
        Appdata.KundeGrupperAktiv.asBoolean:=True;
      end;
    end else
    Begin
      lbTitle.Caption:=DIALOG_KUNDEGRUPPE_TITLEEdit;
      If not appdata.KundeGrupper.ReadOnly then
      AppData.kundegrupper.Edit;
      self.EnableNavigator;
      //Navigator.Enabled:=True;
    End;
    ActiveControl:=nNavn;
    nLocked.Visible:=appdata.KundeGrupper.ReadOnly;
  end;

  Function TfrmKundeGruppe.GetNavigatorDataset:TDataset;
  Begin
    result:=inherited GetNavigatorDataset;
    if not (csDestroying in ComponentState)
    and not application.Terminated then
    result:=Appdata.Produkter;
  end;

  procedure TfrmKundeGruppe.DoCancelExecute(Sender: TObject);
  begin
    try
      If not Appdata.KundeGrupper.ReadOnly then
      Begin
        With AppData.Kundegrupper do
        begin
          Cancel;
          CommitUpdates;
        end;
      end;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoCancelExecute()',e.message);
    end;
    inherited;
  end;

  procedure TfrmKundeGruppe.FormClose(Sender: TObject;var Action: TCloseAction);
  begin
    inherited;
    If (Appdata.Kundegrupper.State=dsInsert)
    or (Appdata.Kundegrupper.State=dsEdit) then
    DOCancel.Execute;
  end;

  procedure TfrmKundeGruppe.DoOKExecute(Sender: TObject);
  begin
    lbNavn.Blinking:=False;
    lbRabatt.Blinking:=False;

    If length(trim(AppData.KundeGrupperTittel.Value))=0 then
    Begin
      CauseFieldError('Tittel');
      lbNavn.Blinking:=True;
      nNavn.SetFocus;
      exit;
    end;

    If lowercase(trim(Appdata.KundeGrupperTittel.Value))='ny kunde' then
    Begin
      ShowMessage('Dette navnet kan ikke benyttes. Det er reservert.');
      lbNavn.Blinking:=True;
      nNavn.SetFocus;
      exit;
    end;

    If AppData.KundeGrupperRabatt.Value<1 then
    Begin
      CauseFieldError('Rabatt');
      lbRabatt.Blinking:=True;
      nRabatt.SetFocus;
      exit;
    end;

    If (AppData.Kundegrupper.State=dsEdit)
    or (AppData.Kundegrupper.State=dsInsert) then
    Begin
      try
        If not Appdata.KundeGrupper.ReadOnly then
        Begin
          With AppData.Kundegrupper do
          Begin
            Post;
            ApplyUpdates;
            CommitUpdates;
          end;
        end;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoOKExecute()',e.message);
      end;
    end;

    inherited;
  end;

end.
