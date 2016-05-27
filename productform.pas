  unit productform;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, clientform, ActnList, StdCtrls, ExtCtrls, 
  ComCtrls, ImgList, db, globalvalues, data, RzButton,
  RzBckgnd, RzLabel, RzStatus, RzPanel, RzDBNav, RzDTP, RzRadChk,
  RzPopups, RzDBEdit, RzTabs, RzEdit, RzCmboBx, RzDBCmbo, DBCtrls, Mask,
  RzSndMsg, RzDlgBtn;

    {if application.MessageBox('Oppdatere produkt?',Application_Title,
    MB_YESNO or MB_ICONQUESTION)=ID_YES then
    Begin
      appdata.produkter.Post;
      appdata.produkter.ApplyUpdates;
      Appdata.Produkter.edit;
    end; }

  Type

  TfrmProduct = class(TfrmClient)
    RzGroupBox1: TRzGroupBox;
    ANavn: TRzDBEdit;
    Atype: TRzDBEdit;
    ALeverandor: TRzDBLookupComboBox;
    AReferanse: TRzDBEdit;
    RzTabControl1: TRzTabControl;
    APris: TRzDBEdit;
    Panel4: TPanel;
    nNotater: TRzDBMemo;
    lbNavn: TRzLabel;
    lbType: TRzLabel;
    lbLeverandor: TRzLabel;
    lbInnPris: TRzLabel;
    lbLeverandorId: TRzLabel;
    nAvanse: TRzComboBox;
    lbAvanse: TRzLabel;
    lbUtPris: TRzLabel;
    bPris: TRzDBEdit;
    nMva: TRzComboBox;
    lbMVA: TRzLabel;
    RzLabel1: TRzLabel;
    DoUpdate: TAction;
    procedure FormShow(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure nAvanseChange(Sender: TObject);
    procedure APrisChange(Sender: TObject);
    procedure nMVAChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DoUpdateUpdate(Sender: TObject);
  private
    { Private declarations }
    //Procedure HandleAfterScroll(DataSet: TDataSet);
    Procedure UpdateProduktView;
  Protected
    Function  GetNavigatorDataset:TDataset;override;
    Function  BeforeNavigate:Boolean;override;
    Procedure SetChangeEvents;
    procedure ClearChangeEvents;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  uses jlcommon;

  procedure TfrmProduct.FormCreate(Sender: TObject);
  begin
    inherited;
    (* Setup MVA options *)
    MVAListTo(nMVA.Items);
  end;

  Procedure TfrmProduct.SetChangeEvents;
  Begin
    aNavn.OnChange:=HandleEditChanged;
    aType.OnChange:=HandleEditChanged;
    aLeverandor.OnClick:=HandleEditChanged;
    aReferanse.OnChange:=HandleEditChanged;
    //aPris.OnChange:=HandleEditChanged;
    //nAvanse.OnSelect:=HandleEditChanged;
    nMVA.OnSelect:=HandleEditChanged;
    bPris.OnChange:=HandleEditChanged;
    nNotater.OnChange:=HandleEditChanged;
  end;

  procedure TfrmProduct.ClearChangeEvents;
  Begin
    aNavn.OnChange:=NIL;
    aType.OnChange:=NIL;
    aLeverandor.OnClick:=NIL;
    aReferanse.OnChange:=NIL;
    //aPris.OnChange:=NIL;
    //nAvanse.OnSelect:=NIL;
    nMVA.OnSelect:=NIL;
    bPris.OnChange:=NIL;
    nNotater.OnChange:=NIL;
  end;

  procedure TfrmProduct.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    inherited;
    ClearChangeEvents;
    if (Appdata.Produkter.State in [dsInsert,dsEdit]) then
    DOCancel.Execute;
  end;

  Function TfrmProduct.GetNavigatorDataset:TDataset;
  Begin
    result:=inherited GetNavigatorDataset;
    if not (csDestroying in ComponentState)
    and not application.Terminated then
    result:=Appdata.Produkter;
  end;

  Function TfrmProduct.BeforeNavigate:Boolean;
  const
    CNT_MSG_CANCELADDPRODUCT =
    'Denne handlingen vil avbryte registreringen.' + #13 +
    'Er du sikker på at du ønsker dette?';

    CNT_MSG_CANCELEDITPRODUCT =
    'Du har endret produkt beskrivelsen.' + #13 +
    'Ønsker du å lagre forandringene?';
  Begin
    result:=Inherited BeforeNavigate;
    if (appdata.Produkter.state in [dsInsert,dsEdit]) then
    Begin

      Case appdata.Produkter.state of
      dsInsert:
        Begin
          if application.MessageBox(CNT_MSG_CANCELADDPRODUCT,
          Application_Title,MB_YESNO or MB_ICONQUESTION)=ID_YES then
          Begin
            (* Cancel new record *)
            appdata.Produkter.Cancel;
            ResetChanged;
          end else
          result:=False;
          exit;
        end;
      dsEdit:
        Begin
          If GetChanged then
          Begin
            if application.MessageBox(CNT_MSG_CANCELEDITPRODUCT,Application_Title,
            MB_YESNO or MB_ICONQUESTION)=ID_YES then
            Begin
              appdata.Produkter.Post;
              appdata.Produkter.ApplyUpdates;
            end else
            appdata.Produkter.Cancel;
            ResetChanged;
          end;
        end;
      end;
    end;
  end;

  procedure TfrmProduct.FormShow(Sender: TObject);
  { var
    FTemp:  String;
    FIndex: Integer;    }
  begin
    inherited;
    lbHelp1.Caption:=Format(lbHelp1.Caption,[DIALOG_PRODUKT_TOPIC]);
    If RecordMode=arAppend then
    begin
      lbTitle.Caption:=DIALOG_PRODUKT_TITLEAPPEND;
      DisableNavigator;
      //Navigator.Enabled:=False;

      If not Appdata.DataStoreReadOnly then
      Begin
        AppData.produkter.Append;
        SetChangeEvents;
      end;

      nAvanse.ItemIndex:=AppData.Prefs.ReadInteger(PREFS_AVANSE);
      nMva.ItemIndex:=Appdata.Prefs.ReadInteger(PREFS_MVA);
      nAvanseChange(self);
      nMVAChange(self);
    end else
    Begin
      lbTitle.Caption:=DIALOG_PRODUKT_TITLEEDIT;
      EnableNavigator;
      //Navigator.Enabled:=True;

      If not Appdata.DataStoreReadOnly then
      Begin
        AppData.Produkter.Edit;
        SetChangeEvents;
      end;

      UpdateProduktView;
    End;

    If Appdata.Produkter.ReadOnly then
    Begin
      aPris.Enabled:=False;
      bPris.Enabled:=False;
      nAvanse.Enabled:=False;
      nMVA.Enabled:=False;
      nLocked.visible:=True;
    end;
  end;

  Procedure TfrmProduct.UpdateProduktView;
  var
    FTemp:  String;
    FIndex: Integer;
  Begin
    (* Lookup MVA from our list *)
    FTemp:=AppData.ProdukterMva.AsString + '%';
    FIndex:=nMVA.Items.IndexOf(FTemp);
    If FIndex>=0 then
    nMVA.ItemIndex:=FIndex else
    nMVA.ItemIndex:=-1;

    nAvanse.ItemIndex:=AppData.ProdukterAvanse.Value;
    bPris.enabled:=nAvanse.ItemIndex=4;
  end;

  { Procedure TfrmProduct.HandleAfterScroll(DataSet: TDataSet);
  Begin
    If  (RecordMode<>arAppend)
    and (Appdata.DataStoreReadOnly=false) then
    Begin
      UpdateProduktView;
      AppData.Produkter.Edit;
    end;
  end;     }

  procedure TfrmProduct.DoCancelExecute(Sender: TObject);
  begin
    if (Appdata.Produkter.State in [dsEdit,dsInsert]) then
    Begin
      try
        AppData.produkter.Cancel;
        AppData.produkter.ApplyUpdates;
        Appdata.produkter.CommitUpdates;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoCancelExecute()',e.message);
      end;
    end;
    inherited;
  end;

  procedure TfrmProduct.DoOKExecute(Sender: TObject);
  var
    FText:  String;
  begin
    (* check that we can do this *)
    If AppData.DataStoreReadOnly then
    Begin
      Inherited;
      exit;
    end;

    lbNavn.Blinking:=False;
    lbLeverandor.Blinking:=False;
    lbInnPris.Blinking:=False;
    lbUtPris.Blinking:=False;

    { Validate name field }
    FText:=trim(AppData.ProdukterTittel.Value);
    if Length(FText)=0 then
    begin
      CauseFieldError('Navn');
      lbNavn.Blinking:=True;
      ANavn.SetFocus;
      modalresult:=mrNone;
      Exit;
    End;

    { Validate leverandør field }
    FText:=trim(ALeverandor.Text);
    if Length(FText)=0 then
    begin
      CauseFieldError('Leverandør');
      lbLeverandor.Blinking:=True;
      ALeverandor.SetFocus;
      modalresult:=mrNone;
      Exit;
    End;

    { Innpris rellativ? }
    if (nAvanse.ItemIndex<3) then
    begin
      { innpris mindre enn null kroner? }
      if Appdata.ProdukterInnPris.Value<0.0 then
      Begin
        CauseFieldError('InnPris');
        lbInnPris.Blinking:=True;
        APris.SetFocus;
        modalresult:=mrNone;
        Exit;
      End;
    end;

    { UtPris mindre enn innpris? }
    If Appdata.ProdukterUtPris.Value<=Appdata.ProdukterInnPris.Value then
    Begin
      CauseFieldError('UtPris');
      lbUtPris.Blinking:=True;
      APris.SetFocus;
      modalresult:=mrNone;
      Exit;
    End;

    if (Appdata.Produkter.State in [dsEdit,dsInsert]) then
    Begin
      try
        With AppData.Produkter do
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

    { store in registry }
    Appdata.Prefs.WriteInteger(PREFS_AVANSE,nAvanse.ItemIndex);
    Appdata.Prefs.WriteInteger(PREFS_MVA,nMva.ItemIndex);

    inherited;
  end;

  procedure TfrmProduct.nAvanseChange(Sender: TObject);
  begin
    inherited;

    (* check that we can do this *)
    If AppData.DataStoreReadOnly then
    exit;

    if (appdata.Produkter.State in [dsEdit,dsInsert]) then
    Begin
      try
        Appdata.ProdukterAvanse.AsInteger:=nAvanse.ItemIndex;
        If nAvanse.ItemIndex=4 then
        Begin
          If bPris.Enabled=False then
          Begin
            AppData.ProdukterUtPris.AsCurrency:=Appdata.ProdukterInnPris.AsCurrency;
            // * Appdata.ProdukterAvanse.AsInteger);
            bPris.Enabled:=True;
            bPris.SetFocus;
          end;
        end else
        Begin
          if bPris.Enabled then
          bPris.Enabled:=False;
          bpris.Update;
        End;

      except
        on e: exception do
        ErrorDialog(ClassName,'nAvanseChange()',e.message);
      end;
    end;
  end;

  procedure TfrmProduct.APrisChange(Sender: TObject);
  begin
    inherited;
    (* check that we can do this *)
    If AppData.DataStoreReadOnly=False then
    Begin
      if (Appdata.Produkter.State in [dsEdit,dsInsert]) then
      nAvanseChange(self);
    end;
  end;

  procedure TfrmProduct.nMVAChange(Sender: TObject);
  var
    FText:  String;
    FValue: Integer;
  begin
    inherited;
    If AppData.DataStoreReadOnly=False then
    Begin
      try
        FText:=trim(StringReplace(nMVA.Text,'%','',[rfReplaceAll]));
        If sysutils.TryStrToInt(FText,FValue) then
        Begin
          if (Appdata.Produkter.State in [dsEdit,dsInsert]) then
          AppData.ProdukterMVA.AsInteger:=FValue;
        end;
      except
        on e: exception do
        ErrorDialog(ClassName,'nMVAChange()',e.message);
      end;
    end;
  end;

  procedure TfrmProduct.DoUpdateUpdate(Sender: TObject);
  begin
    inherited;
    DoUpdate.enabled:=(AppData.DataStoreReadOnly=False)
    and (RecordMode=arEdit)
    and (Appdata.Produkter.State=dsEdit)
    and appdata.Produkter.NeedToSave;
  end;



end.
