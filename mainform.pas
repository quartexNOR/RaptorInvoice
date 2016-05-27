  unit mainform;

  Interface

  Uses
  jlcommon,
  Windows, Forms, SysUtils, Classes, Graphics, Controls, Dialogs,
  ImgList, Menus, ActnList, StdCtrls, Mask, ExtCtrls, db, ComCtrls, ToolWin,
  VolgaTbl, RzCommon, RzForms, RzBorder, RzDBLbl, RzButton, 
  RzCmboBx, RzEdit, RzTabs, RzGroupBar, RzSplit, RzLabel, RzPrgres, RzStatus,
  RzPanel, dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBTLCl, dxGrClms,
  RzDBNav, RzBckgnd, oppdaterForm,
  globalvalues, dxExEdtr, dxCalc,
  RzBmpBtn, Grids, DBGrids, RzDBGrid,
  DateUtils;

  Type


  TfrmMain = class(TForm)
    LargeActions: TActionList;
    DoAddLeverandor: TAction;
    DoAddProduct: TAction;
    DoAddFactura: TAction;
    DoFakturer: TAction;
    DoAddKunde: TAction;
    DoEditRecord: TAction;
    DoDeleteRecord: TAction;
    DoFakturerAlle: TAction;
    DoFindRecord: TAction;
    DoExit: TAction;
    DoCopyRecord: TAction;
    DoProcess: TAction;
    DoKrediter: TAction;
    DoPurring: TAction;
    DoInkasso: TAction;
    DoPrintFaktura: TAction;
    DoBetale: TAction;
    DoEditFaktura: TAction;
    Statusbar: TRzStatusBar;
    RzSplitter2: TRzSplitter;
    nActiveData: TRzGroupBar;
    JournalGruppe: TRzGroup;
    DoFakturaJournal: TAction;
    LargeImages: TImageList;
    SmallImages: TImageList;
    DoSettings: TAction;
    DoFordringJournal: TAction;
    DoKundeRapport: TAction;
    DoHelp: TAction;
    DoGotoKunde: TAction;
    Groups: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    TabSheet3: TRzTabSheet;
    TabSheet4: TRzTabSheet;
    LeverandorGridPanel: TPanel;
    ProdukterGridPanel: TPanel;
    KunderGridPanel: TPanel;
    FakturaGridPanel: TPanel;
    LeverandorGrid: TdxDBGrid;
    ProdukterGrid: TdxDBGrid;
    KunderGrid: TdxDBGrid;
    GridSplitter: TRzSplitter;
    FakturaEgenskaper: TRzGroupBox;
    lbPurringer: TRzLabel;
    lbInkassoVarsel: TRzLabel;
    lbPurringerCount: TRzDBLabel;
    lbInkassoVarselCount: TRzDBLabel;
    lbForfallInfo: TRzLabel;
    RzBitBtn1: TRzBitBtn;
    FakturaNavigator: TRzDBNavigator;
    FakturaGrid: TdxDBGrid;
    DoEditPurringer: TAction;
    MainMenu1: TMainMenu;
    Fil1: TMenuItem;
    Rediger1: TMenuItem;
    Faktura1: TMenuItem;
    Journaler1: TMenuItem;
    Hjelp1: TMenuItem;
    Nyfaktura1: TMenuItem;
    NyKunde1: TMenuItem;
    Nyleverandr1: TMenuItem;
    Nyttprodukt1: TMenuItem;
    N1: TMenuItem;
    Avslutt1: TMenuItem;
    Kopier1: TMenuItem;
    Slett1: TMenuItem;
    Rediger2: TMenuItem;
    Sk1: TMenuItem;
    Instillinger1: TMenuItem;
    N3: TMenuItem;
    Betale1: TMenuItem;
    Redigerepurringer1: TMenuItem;
    Fakturer1: TMenuItem;
    Faktureralle1: TMenuItem;
    Kredittere1: TMenuItem;
    Varsel1: TMenuItem;
    Purring1: TMenuItem;
    N4: TMenuItem;
    Fakturajournal1: TMenuItem;
    Fordringjournal1: TMenuItem;
    KundeJournal1: TMenuItem;
    Skrivut1: TMenuItem;
    Dokumentasjon1: TMenuItem;
    LeverandorGridColumn1: TdxDBGridColumn;
    LeverandorGridColumn2: TdxDBGridColumn;
    LeverandorGridColumn3: TdxDBGridColumn;
    LeverandorGridColumn4: TdxDBGridColumn;
    LeverandorGridColumn5: TdxDBGridColumn;
    ProdukterGridColumn1: TdxDBGridColumn;
    ProdukterGridColumn2: TdxDBGridColumn;
    ProdukterGridColumn3: TdxDBGridColumn;
    ProdukterGridColumn4: TdxDBGridColumn;
    ProdukterGridColumn5: TdxDBGridColumn;
    ProdukterGridColumn6: TdxDBGridColumn;
    KunderGridColumn1: TdxDBGridColumn;
    KunderGridColumn2: TdxDBGridColumn;
    KunderGridColumn3: TdxDBGridColumn;
    KunderGridColumn4: TdxDBGridColumn;
    KunderGridColumn5: TdxDBGridColumn;
    FakturaGridColumn1: TdxDBGridColumn;
    FakturaGridColumn2: TdxDBGridColumn;
    FakturaGridColumn3: TdxDBGridColumn;
    FakturaGridColumn4: TdxDBGridColumn;
    FakturaGridColumn5: TdxDBGridColumn;
    FakturaGridColumn6: TdxDBGridColumn;
    ToolBar3: TToolBar;
    ToolButton7: TToolButton;
    ToolButton10: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    DoOpenStore: TAction;
    DoCloseStore: TAction;
    DoSetRowSelect: TAction;
    DoSetColSelect: TAction;
    LargeImagesGrey: TImageList;
    LargeImagesHot: TImageList;
    DoEditKundeGrupper: TAction;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    TabSheet5: TRzTabSheet;
    RzPanel1: TRzPanel;
    DoShowInfo: TAction;
    Vis1: TMenuItem;
    Informasjon1: TMenuItem;
    Activation: TTimer;
    RzGroup1: TRzGroup;
    PopupMenu1: TPopupMenu;
    Nyfaktura2: TMenuItem;
    Betale2: TMenuItem;
    Fakturer2: TMenuItem;
    Kredittere2: TMenuItem;
    Betale3: TMenuItem;
    Purring2: TMenuItem;
    Varsel2: TMenuItem;
    N2: TMenuItem;
    RzStatusPane1: TRzStatusPane;
    RzLabel1: TRzLabel;
    RzSeparator1: TRzSeparator;
    RzGroup3: TRzGroup;
    edTarget: TRzComboBox;
    RzButton1: TRzButton;
    lbOmsetning: TRzLEDDisplay;
    lbMVA: TRzLEDDisplay;
    RzLabel2: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel5: TRzLabel;
    RzButton2: TRzButton;
    DoUpdateKeyNumbers: TAction;
    DoGotoItem: TAction;
    edRef: TRzNumericEdit;
    Sk2: TMenuItem;
    Rediger4: TMenuItem;
    Kopier2: TMenuItem;
    Slett2: TMenuItem;
    RzURLLabel1: TRzURLLabel;
    RzLabel6: TRzLabel;
    RzURLLabel2: TRzURLLabel;
    RzURLLabel3: TRzURLLabel;
    RzURLLabel4: TRzURLLabel;
    RzURLLabel5: TRzURLLabel;
    RzURLLabel6: TRzURLLabel;
    RzURLLabel8: TRzURLLabel;
    RzLabel8: TRzLabel;
    RzURLLabel9: TRzURLLabel;
    RzURLLabel10: TRzURLLabel;
    RzURLLabel11: TRzURLLabel;
    RzLabel9: TRzLabel;
    RzURLLabel12: TRzURLLabel;
    RzURLLabel13: TRzURLLabel;
    RzURLLabel14: TRzURLLabel;
    RzSeparator2: TRzSeparator;
    Image2: TImage;
    lbAppInfo: TRzLabel;
    MainToolbar: TRzToolbar;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    RzSpacer1: TRzSpacer;
    RzToolButton3: TRzToolButton;
    RzToolButton4: TRzToolButton;
    RzToolButton5: TRzToolButton;
    RzSpacer2: TRzSpacer;
    RzToolButton6: TRzToolButton;
    RzToolButton7: TRzToolButton;
    RzToolButton8: TRzToolButton;
    RzToolButton9: TRzToolButton;
    RzToolButton10: TRzToolButton;
    RzToolButton11: TRzToolButton;
    Headerpanel: TRzPanel;
    dbimage_locked: TImage;
    dbimage_open: TImage;
    lbTitle: TRzLabel;
    dbStatus: TImage;
    lbUke: TRzLabel;
    SideButtonPanel: TRzPanel;
    RzToolButton12: TRzToolButton;
    RzToolButton13: TRzToolButton;
    RzToolButton14: TRzToolButton;
    RzToolButton15: TRzToolButton;
    RzToolButton16: TRzToolButton;
    RzToolButton17: TRzToolButton;
    Status: TRzStatusPane;
    Redigerepurringer2: TMenuItem;
    N6: TMenuItem;
    Viskundeprofil1: TMenuItem;
    N5: TMenuItem;
    RzURLLabel7: TRzURLLabel;
    RzGroup2: TRzGroup;
    RzToolButton18: TRzToolButton;
    procedure DoAddLeverandorExecute(Sender: TObject);
    procedure DoAddProductExecute(Sender: TObject);
    procedure GroupsChange(Sender: TObject);
    procedure DoAddFacturaExecute(Sender: TObject);
    procedure DoFakturerExecute(Sender: TObject);
    procedure DoAddKundeExecute(Sender: TObject);
    procedure DoEditRecordExecute(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure DoDeleteRecordExecute(Sender: TObject);
    procedure DoFakturerAlleExecute(Sender: TObject);
    procedure DoFindRecordExecute(Sender: TObject);
    procedure DoExitExecute(Sender: TObject);
    procedure DoCopyRecordExecute(Sender: TObject);
    procedure DoKrediterExecute(Sender: TObject);
    procedure DoPurringExecute(Sender: TObject);
    procedure DoInkassoExecute(Sender: TObject);
    procedure DoBetaleExecute(Sender: TObject);
    procedure DoProcessExecute(Sender: TObject);
    procedure DoFakturaJournalExecute(Sender: TObject);
    procedure DoPrintFakturaExecute(Sender: TObject);
    procedure DoSettingsExecute(Sender: TObject);
    procedure DoFordringJournalExecute(Sender: TObject);
    procedure DoKundeRapportExecute(Sender: TObject);
    procedure DoHelpExecute(Sender: TObject);
    procedure DoGotoKundeExecute(Sender: TObject);
    procedure DataGridColumnClick(Sender: TObject;Column: TdxDBTreeListColumn);
    procedure FormCreate(Sender: TObject);
    procedure DoEditPurringerExecute(Sender: TObject);
    procedure FakturaGridChangeNode(Sender: TObject; OldNode,Node: TdxTreeListNode);
    procedure DoOpenStoreExecute(Sender: TObject);
    procedure DoCloseStoreExecute(Sender: TObject);
    procedure DoSetRowSelectExecute(Sender: TObject);
    procedure DoSetColSelectExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoEditKundeGrupperExecute(Sender: TObject);
    procedure FakturaGridColumn3GetText(Sender: TObject;
      ANode: TdxTreeListNode; var AText: String);
    procedure DoShowInfoExecute(Sender: TObject);
    procedure FakturaGridColumn3CustomDrawCell(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
      AColumn: TdxTreeListColumn; ASelected, AFocused,
      ANewItemRow: Boolean; var AText: String; var AColor: TColor;
      AFont: TFont; var AAlignment: TAlignment; var ADone: Boolean);
    procedure ActivationTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoUpdateKeyNumbersExecute(Sender: TObject);
    procedure DoGotoItemExecute(Sender: TObject);
    procedure DoGotoItemUpdate(Sender: TObject);
    procedure DoUpdateKeyNumbersUpdate(Sender: TObject);
    procedure DoSetRowSelectUpdate(Sender: TObject);
    procedure DoSetColSelectUpdate(Sender: TObject);
    procedure RzURLLabel3Click(Sender: TObject);
    procedure RzURLLabel12Click(Sender: TObject);
    procedure RzURLLabel13Click(Sender: TObject);
    procedure DoFakturerUpdate(Sender: TObject);
    procedure DoGotoKundeUpdate(Sender: TObject);
    procedure DoBetaleUpdate(Sender: TObject);
    procedure DoKrediterUpdate(Sender: TObject);
    procedure DoPurringUpdate(Sender: TObject);
    procedure DoInkassoUpdate(Sender: TObject);
    procedure DoEditRecordUpdate(Sender: TObject);
    procedure DoCopyRecordUpdate(Sender: TObject);
    procedure DoDeleteRecordUpdate(Sender: TObject);
    procedure DoProcessUpdate(Sender: TObject);
    procedure DoFakturerAlleUpdate(Sender: TObject);
    procedure DoEditPurringerUpdate(Sender: TObject);
    procedure DoFakturaJournalUpdate(Sender: TObject);
    procedure DoKundeRapportUpdate(Sender: TObject);
    procedure DoFordringJournalUpdate(Sender: TObject);
    procedure DoPrintFakturaUpdate(Sender: TObject);
    procedure DoAddLeverandorUpdate(Sender: TObject);
    procedure DoAddProductUpdate(Sender: TObject);
    procedure DoAddKundeUpdate(Sender: TObject);
    procedure DoAddFacturaUpdate(Sender: TObject);
    procedure DoSettingsUpdate(Sender: TObject);
    procedure DoCloseStoreUpdate(Sender: TObject);
    procedure DoOpenStoreUpdate(Sender: TObject);
    procedure DoFindRecordUpdate(Sender: TObject);
    procedure DoEditKundeGrupperUpdate(Sender: TObject);
    procedure DoShowInfoUpdate(Sender: TObject);
    procedure RzURLLabel7Click(Sender: TObject);
  private
    Procedure   SetGroup(Group:Integer);
    Procedure   UpdateButtonStates;
    Procedure   UpdateDbStatus;
    Procedure   SearchFor(Kind:Integer);
  Private
    Procedure   HandleDataStoreOpen(Sender:TObject;APath:String);
    Procedure   HandleDataStoreClosed(Sender:TObject);
    Procedure   HandleBeforeDataStoreClosed(Sender:TObject;APath:String);

    procedure   HandleDataStoreProcessBegins(Sender:TObject;AMax:Integer);
    Procedure   HandleDataStoreProcessUpdate(Sender:TObject;APos,AMax:Integer);
    Procedure   HandleDataStoreProcessDone(Sender:TObject);
    Procedure   HandleDataStoreMessage(Sender:TObject;Value:String);
    procedure   HandleDataStoreUpdate(Sender:TObject);
  public
    { public declarations }
  end;

  var
  frmMain: TfrmMain;

  implementation

  uses data, 
  shellapi,
  clientform, leverandorForm, kundeForm, productform, fakturaform,
  fakturereForm, fakturerAlleForm, loadform, searchForm, settingsForm,
  fakturareportForm, reportclientForm, fakturajournalform, ubetaltreportform,
  kundereportForm, kundegruppeform, editpurringerform, grupperForm, betaleForm;

  {$R *.DFM}


  Const
  CNT_MAINFORM_STATUS_DBUPDATED =
  'Database oppdatert. Ingen nye forfallte fakturaer funnet.';

  CNT_MAINFORM_STATUS_DBUPDATED2 =
  'Database oppdatert. %d faktura oppdatert.';

  CNT_MAINFORM_STATUS_FAKTURAFORFALL0 =
  'Denne fakturaen forfaller i dag';

  CNT_MAINFORM_STATUS_FAKTURAFORFALL1 =
  'Denne fakturaen forfaller om 1 dag';

  CNT_MAINFORM_STATUS_FAKTURAFORFALL2 =
  'Denne fakturaen forfaller om %d dager';

  CNT_MAINFORM_STATUS_FAKTURABETALT =
  'Fakturaen er betalt';

  CNT_MAINFORM_STATUS_FAKTURAIKKEFAKTURERT =
  'Faktura er ikke fakturert';

  CNT_MAINFORM_STATUS_FAKTURAKREDITTNOTA =
  'Faktura er kredittert';

  CNT_MAINFORM_STATUS_FAKTURAFORFALLT =
  'Faktura har forfallt';

  CNT_MAINFORM_DIALOG_TITLE_DELETERECORD = 'Slette oppføring';
  CNT_MAINFORM_DIALOG_TEXT_DELETERECORD =
  'Sletting av registeroppføring er permanent' + #13 +
  'og kan ikke angres eller tilbakestilles!' + #13 +
  'Vil du fremdeles slette informasjonen?';

  //##########################################################################
  // Standard event handlers
  //##########################################################################

  procedure TfrmMain.FormCreate(Sender: TObject);
  var
    FOsKind:  TJLWinOSType;
  begin
    Caption:=Application_Title;
    lbAppInfo.Caption:=appData.AboutText;

    {if jlcommon.JL_GetOSType(FOsKind) then
    Begin
      If (FOsKind in [otVista,otWin7]) then
      Begin
        headerpanel.Color:=clWhite;
        sidebuttonpanel.Color:=clWhite;
        rzsplitter2.color:=clWhite;
        rzsplitter2.LowerRight.BorderColor:=clWhite;
        rzsplitter2.UpperLeft.BorderColor:=clWhite;
      end else
      Begin
        (* Setup toolbar for XP look *)
        MainToolbar.VisualStyle:=vsGradient;
        MainToolbar.GradientColorStyle:=gcsMSOffice;
        MainToolbar.BorderSides:=MainToolbar.BorderSides + [sdTop];

        SideButtonPanel.VisualStyle:=vsGradient;
        SideButtonPanel.GradientColorStyle:=gcsMSOffice;

        Headerpanel.VisualStyle:=vsGradient;
        HeaderPanel.GradientColorStyle:=gcsMSOffice;

        Statusbar.VisualStyle:=vsGradient;
        Statusbar.GradientColorStyle:=gcsMSOffice;
      end;
    end;    }

    (* Assign Datastore event handlers *)
    Appdata.OnDataStoreOpen:=HandleDataStoreOpen;
    AppData.OnDataStoreClose:=HandleDataStoreClosed;
    AppData.OnBeforeDataStoreClose:=HandleBeforeDataStoreClosed;
    Appdata.OnProcessBegins:=HandleDataStoreProcessBegins;
    AppData.OnProcessUpdate:=HandleDataStoreProcessUpdate;
    AppData.OnProcessDone:=HandleDataStoreProcessDone;
    Appdata.OnMessage:=HandleDataStoreMessage;
    AppData.OnUpdate:=HandleDataStoreUpdate;

    (* update database status info *)
    UpdateDbStatus;
  end;

  procedure TfrmMain.FormShow(Sender: TObject);
  begin
    Activation.Enabled:=True;
  end;

  procedure TfrmMain.ActivationTimer(Sender: TObject);
  begin
    Activation.Enabled:=False;
    DoOpenStore.Execute;
  end;

  procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    If Appdata.DataStoreActive then
    AppData.CloseDataStore;
  end;

  //##########################################################################
  // Datastore event handlers
  //##########################################################################

  Procedure TfrmMain.HandleDataStoreOpen(Sender:TObject;APath:String);
  Begin
    (* Laste inn tidligere settings for grids *)
    try
      leverandorgrid.LoadFromIniFile(APath + 'leverandor_grid.ini');
      ProdukterGrid.LoadFromIniFile(APath + 'produkter_grid.ini');
      KunderGrid.LoadFromIniFile(APath + 'kunder_grid.ini');
      FakturaGrid.LoadFromIniFile(APath + 'faktura_grid.ini');
    except
      on exception do;
    end;

    LeverandorGrid.Enabled:=True;
    ProdukterGrid.Enabled:=True;
    KunderGrid.Enabled:=True;
    FakturaGrid.Enabled:=True;

    UpdateDbStatus;
    SetGroup(GROUP_ALLE);
    UpdateButtonStates;

    If Appdata.Prefs.ReadBoolean(PREFS_ROWSELECT) then
    doSetRowSelect.Execute else
    DoSetColSelect.Execute;

    dbstatus.visible:=True;
    If appdata.DataStoreReadonly then
    dbstatus.picture.Assign(dbimage_locked.picture) else
    dbstatus.picture.Assign(dbimage_open.picture);
  end;

  Procedure TfrmMain.HandleDataStoreClosed(Sender:TObject);
  Begin
    (* Disable GUI *)
    LeverandorGrid.Enabled:=False;
    ProdukterGrid.Enabled:=False;
    KunderGrid.Enabled:=False;
    FakturaGrid.Enabled:=False;

    lbTitle.Caption:=Application.Title;
    lbForfallInfo.Caption:='';
    lbOmsetning.Caption:='';
    lbMVA.Caption:='';
  end;

  Procedure TfrmMain.HandleBeforeDataStoreClosed(Sender:TObject;APath:String);
  Begin

    dbstatus.visible:=False;
    dbStatus.picture.assign(NIL);

    (* Lagre grid instillinger *)
    try
      leverandorgrid.SaveToIniFile(APath + 'leverandor_grid.ini');
      ProdukterGrid.SaveToIniFile(APath + 'produkter_grid.ini');
      KunderGrid.SaveToIniFile(APath + 'kunder_grid.ini');
      FakturaGrid.SaveToIniFile(APath + 'faktura_grid.ini');
    except
      on exception do;
    end;

    //browser.Clear;

    (* save settings *)
    Appdata.UpdatePrefs;
  end;

  procedure TfrmMain.HandleDataStoreProcessBegins(Sender:TObject;AMax:Integer);
  Begin
    Cursor:=crHourGlass;
    Application.ProcessMessages;
  end;

  Procedure TfrmMain.HandleDataStoreProcessUpdate(Sender:TObject;APos,AMax:Integer);
  Begin
    //Application.ProcessMessages;
  end;

  Procedure TfrmMain.HandleDataStoreProcessDone(Sender:TObject);
  Begin
    Cursor:=crDefault;
    //Application.ProcessMessages;
  end;

  Procedure TfrmMain.HandleDataStoreMessage(Sender:TObject;Value:String);
  Begin
    Status.Caption:=Value;
  end;

  procedure TfrmMain.HandleDataStoreUpdate(Sender:TObject);
  Begin
    If (Groups.TabIndex=GROUP_FAKTURA) then
    UpdateButtonStates;
    UpdateDbStatus;
  end;

  procedure TfrmMain.DoEditRecordUpdate(Sender: TObject);
  var
    FDataset: TVolgaTable;
  begin
    If not (csDestroying in ComponentState) then
    begin
      if (Groups.TabIndex<>GROUP_ALLE)
      and appdata.DataStoreActive then
      Begin
        Case Groups.TabIndex of
        GROUP_FAKTURA:      FDataset:=appdata.Faktura;
        GROUP_LEVERANDORER: FDataset:=appdata.Leverandorer;
        GROUP_PRODUKTER:    FDataset:=appdata.Produkter;
        GROUP_KUNDER:       FDataset:=appdata.Kunder;
        else                FDataset:=NIL;
        end;
        DoEditRecord.Enabled:=(FDataset<>NIL)
        and Appdata.DatasetReady(FDataset)
        and (FDataset.RecNo>0);
      end else
      DoEditRecord.Enabled:=False;
    end;
  end;

  procedure TfrmMain.DoCopyRecordUpdate(Sender: TObject);
  var
    FDataset: TVolgaTable;
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if  (Groups.TabIndex<>GROUP_ALLE)
      and appdata.DataStoreActive then
      Begin
        Case Groups.TabIndex of
        GROUP_FAKTURA:      FDataset:=appdata.Faktura;
        GROUP_LEVERANDORER: FDataset:=appdata.Leverandorer;
        GROUP_PRODUKTER:    FDataset:=appdata.Produkter;
        GROUP_KUNDER:       FDataset:=appdata.Kunder;
        else                FDataset:=NIL;
        end;
        DoCopyRecord.Enabled:=(FDataset<>NIL)
        and Appdata.DatasetReady(FDataset)
        and (FDataset.RecNo>0);
      end else
      DoCopyRecord.Enabled:=False;
    end;
  end;

  procedure TfrmMain.DoDeleteRecordUpdate(Sender: TObject);
  var
    FDataset: TVolgaTable;
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if (Groups.TabIndex<>GROUP_ALLE)
      and (Groups.TabIndex<>GROUP_FAKTURA)
      and appdata.DataStoreActive then
      Begin
        Case Groups.TabIndex of
        GROUP_LEVERANDORER: FDataset:=appdata.Leverandorer;
        GROUP_PRODUKTER:    FDataset:=appdata.Produkter;
        GROUP_KUNDER:       FDataset:=appdata.Kunder;
        else                FDataset:=NIL;
        end;
        DoDeleteRecord.Enabled:=(FDataset<>NIL)
        and Appdata.DatasetReady(FDataset)
        and (FDataset.RecNo>0);
      end else
      DoDeleteRecord.Enabled:=False;
    end;
  end;


  procedure TfrmMain.DoEditPurringerUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if (Groups.TabIndex=GROUP_FAKTURA)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (appdata.Faktura.RecNo>0) then
      Begin
        DoEditPurringer.enabled:=
        (appdata.fakturastatus.value=FAKTURA_FAKTURERT)
        and ( (appdata.FakturaPurringer.Value>0)
        or (appdata.FakturaVarsel.Value>0) )
        and appdata.FakturaForfallt.Value;
      end else
      DoEditPurringer.Enabled:=False;
    end;
  end;

  procedure TfrmMain.DoFakturerAlleUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoFakturerAlle.enabled:=(Groups.TabIndex=GROUP_FAKTURA)
      and assigned(appdata)
      and appdata.DataSetReady(appdata.Faktura);
    end;
  end;

  procedure TfrmMain.DoFakturaJournalUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoFakturaJournal.enabled:=assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura);
    end;
  end;

  procedure TfrmMain.DoKundeRapportUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoKundeRapport.enabled:=assigned(appdata)
      and Appdata.DataSetReady(Appdata.kunder);
    end;
  end;

  procedure TfrmMain.DoFordringJournalUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoFordringJournal.enabled:=assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura);
    end;
  end;

  procedure TfrmMain.DoAddLeverandorUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoAddLeverandor.enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoAddProductUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoAddProduct.enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoAddKundeUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoAddKunde.enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoAddFacturaUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoAddFactura.enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoFindRecordUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoFindRecord.enabled:=(Groups.TabIndex<>GROUP_ALLE)
      and assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoFakturerUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoFakturer.enabled:=(Groups.TabIndex=GROUP_FAKTURA)
      and assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (Appdata.Faktura.RecNo>0)
      and (appdata.fakturastatus.value=FAKTURA_IKKEFAKTURERT);
    end;
  end;

  procedure TfrmMain.DoSettingsUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoSettings.Enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoShowInfoUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoShowInfo.Enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoEditKundeGrupperUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoEditKundeGrupper.Enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoCloseStoreUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoCloseStore.Enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoOpenStoreUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoOpenStore.Enabled:=assigned(appdata)
      and (appdata.DataStoreActive=False);
    end;
  end;

  procedure TfrmMain.DoPrintFakturaUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoPrintFaktura.enabled:=(Groups.TabIndex=GROUP_FAKTURA)
      and assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (appdata.Faktura.RecNo>0)
      and (appdata.fakturastatus.value<>FAKTURA_IKKEFAKTURERT);
    end;
  end;

  procedure TfrmMain.DoGotoKundeUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoGotoKunde.enabled:=(Groups.TabIndex=GROUP_FAKTURA)
      and assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (appdata.Faktura.RecNo>0)
      and (appdata.datasetready(appdata.Kunder));
    end;
  end;

  procedure TfrmMain.DoBetaleUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoBetale.Enabled:= (Groups.TabIndex=GROUP_FAKTURA)
      and assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (appdata.Faktura.RecNo>0)
      and (appdata.fakturastatus.value=FAKTURA_FAKTURERT);
    end;
  end;

  procedure TfrmMain.DoKrediterUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoKrediter.enabled:=(Groups.TabIndex=GROUP_FAKTURA)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (appdata.Faktura.RecNo>0)
      and (appdata.fakturastatus.value=FAKTURA_FAKTURERT);
    end;
  end;

  procedure TfrmMain.DoPurringUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoPurring.enabled:=(Groups.TabIndex=GROUP_FAKTURA)
      and assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (appdata.Faktura.RecNo>0)
      and (appdata.fakturastatus.value=FAKTURA_FAKTURERT)
      and AppData.FakturaForfallt.Value;
    end;
  end;

  procedure TfrmMain.DoInkassoUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    Begin
      DoInkasso.enabled:= (Groups.TabIndex=GROUP_FAKTURA)
      and assigned(appdata)
      and Appdata.DataSetReady(Appdata.Faktura)
      and (appdata.Faktura.RecNo>0)
      and (appdata.fakturastatus.value=FAKTURA_FAKTURERT)
      and AppData.FakturaForfallt.Value
      and (appdata.FakturaPurringer.Value>1);
    end;
  end;

  //##########################################################################
  // Procs for updating GUI based on state (see above)
  //##########################################################################

  Procedure TfrmMain.UpdateButtonStates;
  var
    FEnd:   TDateTime;
    FDays:  Integer;
  Begin
    if not (csDestroying in ComponentState)
    and (Groups.tabindex=GROUP_FAKTURA)
    and assigned(appdata)
    and appdata.DataStoreActive
    and appdata.DataSetReady(appdata.faktura) then
    Begin
      Case appdata.fakturastatus.value of
      FAKTURA_BETALT:
        lbForfallInfo.Caption:=CNT_MAINFORM_STATUS_FAKTURABETALT;
      FAKTURA_IKKEFAKTURERT:
        lbForfallInfo.Caption:=CNT_MAINFORM_STATUS_FAKTURAIKKEFAKTURERT;
      FAKTURA_KREDITNOTA:
        lbForfallInfo.Caption:=CNT_MAINFORM_STATUS_FAKTURAKREDITTNOTA;
      FAKTURA_FAKTURERT:
        Begin
          (* is this invoice due? *)
          If AppData.FakturaForfallt.Value=True then
          begin
            lbForfallInfo.Caption:=CNT_MAINFORM_STATUS_FAKTURAFORFALLT;
            exit;
          end;
                          
          (* Regne ut forfallsdato *)
          { FEnd:=AppData.FakturaDato.Value;
          FDays:=AppData.FakturaBetalingsFrist.Value; }
          FEnd:=dateutils.IncDay(AppData.FakturaDato.Value,
          AppData.FakturaBetalingsFrist.Value);

          if not dateutils.WithinPastDays(Now,AppData.FakturaDato.Value,
          AppData.FakturaBetalingsFrist.Value) then
          Begin
            lbForfallInfo.Caption:='Forfallt!';
            exit;
          end;

          //FEnd:=FEnd + FDays;
          FDays:=dateutils.DaysBetween(now,FEnd);

          Case FDays of
          0:    lbForfallInfo.Caption:=CNT_MAINFORM_STATUS_FAKTURAFORFALL0;
          1:    lbForfallInfo.Caption:=CNT_MAINFORM_STATUS_FAKTURAFORFALL1;
          else  lbForfallInfo.Caption:=Format
                (CNT_MAINFORM_STATUS_FAKTURAFORFALL2,[FDays]);
          end;
        End;
      end;
    end;
  end;

  Procedure TfrmMain.UpdateDbStatus;
  var
    nMonth, nDay, nYear: Word;
    FText:  String;
  Begin

    (* display month & date information *)
    deCodeDate(now, nYear, nMonth, nDay);
    lbuke.caption:='Uke ' + IntToStr(dateutils.WeekOfTheYear(now))
    + ', ' + IntToStr((nMonth div 3)+1)
    + ' Kvartal, ' + IntToStr(nYear) + ' ';

    (* check that we can display database information *)
    If (Appdata.DataStoreActive=False) then
    exit;

    lbOmsetning.Caption:=CurrToStr(round(Appdata.Prefs.ReadCurrency(PREFS_LASTOMSETTING)));
    lbMVA.Caption:=CurrToStr(Round(Appdata.Prefs.ReadCurrency(PREFS_LASTMVA)));

    { Panel headers }
    FText:=AppData.Prefs.ReadString(PREFS_FIRMA) + ' ' + Fheaders[Groups.TabIndex];
    If (FText<>lbTitle.Caption) then
    lbTitle.Caption:=FText;
  End;

  //##########################################################################
  // Group functions. Depends on Visual TPageControl named Group.
  //##########################################################################

  Procedure TfrmMain.SetGroup(Group:Integer);
  begin
    (* check that we can do this *)
    if not (csDestroying in ComponentState)
    and assigned(appdata)
    and appdata.DataStoreActive then
    Begin
      { switch to correct group }
      If (Group<>Groups.TabIndex) then
      Groups.TabIndex:=Group;
      UpdateDbStatus;
    end;
  End;

  procedure TfrmMain.GroupsChange(Sender: TObject);
  begin
    SetGroup(Groups.TabIndex);
  end;

  //##########################################################################
  // Action event handlers for buttons
  //##########################################################################

  procedure TfrmMain.DoExitExecute(Sender: TObject);
  begin
    Close;
  end;

  procedure TfrmMain.DoCopyRecordExecute(Sender: TObject);
  begin
    (* check that we can do this *)
    If (Appdata.DataStoreActive=False) then
    exit;

    try
      try
        Case Groups.TabIndex of
        GROUP_LEVERANDORER: Appdata.CopyLeverandor;
        GROUP_PRODUKTER:    Appdata.CopyProdukt;
        GROUP_KUNDER:       Appdata.CopyKunde;
        GROUP_FAKTURA:      Appdata.CopyFaktura(False);
        end;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoCopyRecordExecute()',e.message);
      end;
    finally
      UpdateDbStatus;
    end;
  end;

  procedure TfrmMain.DoEditRecordExecute(Sender: TObject);
  var
    FTable:   TVolgaTable;
    FWindow:  TfrmClient;
  begin
    (* check that we can do this *)
    If (Appdata.DataStoreActive=False) then
    exit;

    { Get table reference }
    Case Groups.TabIndex of
    GROUP_PRODUKTER:    FTable:=Appdata.Produkter;
    GROUP_LEVERANDORER: FTable:=Appdata.Leverandorer;
    GROUP_KUNDER:       FTable:=Appdata.Kunder;
    GROUP_FAKTURA:      FTable:=Appdata.Faktura;
    else
      Exit;
    End;

    (* check that table is ready *)
    if not appdata.DataSetReady(FTable) then
    exit;

    { Create a window }
    try
      Case Groups.TabIndex of
      GROUP_LEVERANDORER: FWindow:=TfrmLeverandor.Create(Self);
      GROUP_PRODUKTER:    FWindow:=TfrmProduct.Create(Self);
      GROUP_KUNDER:       FWindow:=TfrmKunde.Create(self);
      GROUP_FAKTURA:
        Begin
          if (Appdata.FakturaStatus.Value<>FAKTURA_IKKEFAKTURERT) then
          FWindow:=TfrmFakturaReport.Create(self) else
          FWindow:=TfrmFaktura.Create(self);
        end;
      else
        exit;
      End;
    except
      on e: exception do
      Begin
        ErrorDialog(ClassName,'DoEditRecordExecute()',e.message);
        exit;
      end;
    end;

    try
      FWindow.RecordMode:=arEdit;
      FWindow.ShowModal;
    finally
      FWindow.free;
    end;
  end;

  procedure TfrmMain.DoDeleteRecordExecute(Sender: TObject);
  begin
    try

      (* Undersøke om bruker virkelig ønsker dette *)
      If Application.MessageBox
      (PChar(CNT_MAINFORM_DIALOG_TEXT_DELETERECORD),
      PChar(CNT_MAINFORM_DIALOG_TITLE_DELETERECORD),
      MB_YESNO or MB_ICONQUESTION)=IDNO then
      exit;

      try
        Case Groups.TabIndex of
        GROUP_LEVERANDORER: Appdata.DeleteLeverandor;
        GROUP_KUNDER:       Appdata.DeleteKunde;
        GROUP_PRODUKTER:    Appdata.DeleteProdukt;
        End;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoDeleteRecordExecute()',e.message);
      end;
      
    finally
      UpdateDbStatus;
    end;
  end;

  procedure TfrmMain.DoFindRecordExecute(Sender: TObject);
  begin
    (* check that we can do this *)
    If (Appdata.DataStoreActive=False) then
    exit;

    If (Groups.TabIndex<>GROUP_ALLE) then
    SearchFor(Groups.TabIndex-1) else
    SearchFor(Group_ALLE);
  end;

  //###########################################################
  //  Kunde funksjoner
  //###########################################################

  procedure TfrmMain.DoAddKundeExecute(Sender: TObject);
  begin
    (* check that we can do this *)
    If (Appdata.DataStoreActive=False) then
    exit;

    (* switch grid display? *)
    If Groups.TabIndex<>GROUP_KUNDER then
    SetGroup(GROUP_KUNDER);

    With TfrmKunde.Create(self) do
    Begin
      RecordMode:=arAppend;
      try
        ShowModal;
      finally
        Free;
      end;
    End;
    UpdateDbStatus;
  end;

  //###########################################################
  //  Leverandør funksjoner
  //###########################################################

  procedure TfrmMain.DoAddLeverandorExecute(Sender: TObject);
  begin
    (* check that we can do this *)
    If (Appdata.DataStoreActive=False) then
    exit;

    If Groups.TabIndex<>GROUP_LEVERANDORER then
    SetGroup(GROUP_LEVERANDORER);

    With TfrmLeverandor.Create(Self) do
    Begin
      RecordMode:=arAppend;
      try
        ShowModal;
      finally
        Free;
      end;
    End;
    UpdateDbStatus;
  end;

  //###########################################################
  //  Produkt funksjoner
  //###########################################################

  Procedure TfrmMain.DoAddProductExecute(Sender: TObject);
  begin
    (* check that we can do this *)
    If (Appdata.DataStoreActive=False) then
    exit;

    (* switch grid display? *)
    If Groups.TabIndex<>GROUP_PRODUKTER then
    SetGroup(GROUP_PRODUKTER);

    With TfrmProduct.Create(Self) do
    Begin
      recordMode:=arAppend;
      try
        ShowModal;
      except
        Free;
      end;
    end;

    UpdateDbStatus;
  end;

  //###########################################################
  //  Faktura funksjoner
  //###########################################################

  procedure TfrmMain.DoFakturerAlleExecute(Sender: TObject);
  Begin
    (* check that table is ready *)
    if not Appdata.DataSetReady(Appdata.Faktura) then
    exit;

    try
      Appdata.FakturerAlle;
    except
      on exception do;
    end;

    updateDbStatus;
  end;

  procedure TfrmMain.DoFakturerExecute(Sender: TObject);
  begin
    try
      Appdata.Fakturer;
      DoProcess.Execute;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoFakturerExecute()',e.message);
    end;
  end;

  procedure TfrmMain.DoAddFacturaExecute(Sender: TObject);
  begin
    (* switch grid display? *)
    If (Groups.TabIndex<>GROUP_FAKTURA) then
    SetGroup(GROUP_FAKTURA);

    With TfrmFaktura.Create(self) do
    Begin
      RecordMode:=arAppend;
      try
        Showmodal;
      finally
        Free;
      end;
    End;

    UpdateDbStatus;
    UpdateButtonStates;
  end;

  procedure TfrmMain.DoKrediterExecute(Sender: TObject);
  Begin
    try
      try
        AppData.KrediterFaktura;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoKrediterExecute()',e.message);
      end;
    finally
      UpdateDbStatus;
      UpdateButtonStates;
    end;
  end;

  procedure TfrmMain.DoPurringExecute(Sender: TObject);
  begin
    try
      try
        AppData.PurrFaktura;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoPurringExecute()',e.message);
      end;
    finally
      UpdateDbStatus;
      UpdateButtonStates;
    end;
  end;

  procedure TfrmMain.DoInkassoExecute(Sender: TObject);
  Begin
    try
      AppData.VarsleFaktura;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoInkassoExecute()',e.message);
    end;
  end;

  procedure TfrmMain.DoBetaleExecute(Sender: TObject);
  begin
    try
      Appdata.BetalFaktura;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoBetaleExecute()',e.message);
    end;
  end;

  procedure TfrmMain.DoHelpExecute(Sender: TObject);
  var
    FFile:  String;
  begin
    { display help documentation }
    FFile:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.Exename));
    FFile:=FFile + 'data\raptor.chm';
    ShellExecute(0,'open',PChar(FFile),NIL,NIL,SW_SHOWDEFAULT	);
  end;

  procedure TfrmMain.DoProcessUpdate(Sender: TObject);
  begin
    if not (csDestroying in ComponentState) then
    Begin
      Doprocess.enabled:=assigned(appdata)
      and appdata.DataSetReady(appdata.Faktura)
      and (AppData.DataStoreReadOnly=false);
    end;
  end;

  procedure TfrmMain.DoProcessExecute(Sender: TObject);
  var
    //FEnd:         TDateTime;
    //FDager:       Integer;
    FIndex:       Integer;
    FOldFiltered: Boolean;
    FOldFilter:   String;
    FOldSorting:  TVolgaSortOptions;
    FForfall:     Integer;

    FObj: TJLInvoice;

    FCash:  Currency;
    FMVA:   Currency;
    mText:  String;

    mForm:  TfrmUpdate;

  begin
    (* ta vare på instillinger for faktura*)
    FOldSorting:=Appdata.Faktura.SortOptions;
    FOldFilter:=AppData.Faktura.Filter;
    FOldFiltered:=AppData.Faktura.Filtered;

    FIndex:=0;
    FForfall:=0;

    mForm:=TfrmUpdate.Create(self);
    mForm.Show;
    try
      (* Disable interaction *)
      frmMain.Enabled:=False;
      frmMain.Cursor:=crHourGlass;

      (* housekeeping before run *)
      Status.Caption:='Oppdaterer database..';

      (* reset instillinger for vårt behov *)
      AppData.Faktura.DisableControls;

      (* Remember current position *)
      FIndex:=AppData.Faktura.RecNo;

      Appdata.faktura.filtered:=False;
      Appdata.Faktura.Filter:='';
      AppData.Faktura.SortOptions:=[vsoDescendSort];

      (* gå til første faktura *)
      AppData.Faktura.First;

      FCash:=0;
      FMVA:=0;

      mForm.barProgress.Max:=appdata.Faktura.RecordCount;
      mform.barProgress.Min:=0;

      While not appdata.faktura.Eof do
      Begin
        mForm.barProgress.Position:=mForm.barProgress.Position + 1;
        mform.barProgress.Invalidate;
        application.ProcessMessages;

        (* hopp over ufakturerte eller betalte fakturaer *)
        {If (AppData.FakturaStatus.Value<>FAKTURA_FAKTURERT) then
        Begin
          Appdata.Faktura.Next;
          Continue;
        end;    }

        (* Har faktura forfallt? *)
        {if not dateutils.WithinPastDays(Now,AppData.FakturaDato.Value,
        AppData.FakturaBetalingsFrist.Value) then
        Begin
          try
            AppData.Faktura.Edit;
            AppData.FakturaForfallt.AsBoolean:=True;
            AppData.Faktura.Post;
            AppData.Faktura.ApplyUpdates;
            AppData.Faktura.CommitUpdates;
          except
            on e: exception do
            Begin
              ErrorDialog(ClassName,'DoUpdate()',e.message);
              Break;
            end;
          end;
          inc(FForfall);
        end;   }

        if appdata.InvoiceObjget(FObj) then
        Begin
          try
            (* Prepare invoice *)
            Fobj.Update;

            Case FObj.State of
            isIssued, isPayed:
              Begin
                FCash:=FCash + FObj.Items.CalcSubTotal(true) ;
                FMVA:=FMVA + FObj.Items.CalcVatOnly;
              end;
            isCredited:
              Begin
                FCash:=FCash - FObj.Items.CalcSubTotal(true) ;
                FMVA:=FMVA - FObj.Items.CalcVatOnly;
              end;
            end;

            (* Only process issued invoices *)
            If FObj.State=isIssued then
            Begin
              (* Only process non-due payments *)
              if FObj.Forfallt then
              appdata.InvoiceObjSet(FObj);
            end;

          finally
            FreeAndNIL(FObj);
          end;
          //Break;
        end;

        (* Regne ut forfallsdato *)
        {FEnd:=AppData.FakturaDato.Value;
        FDager:=AppData.FakturaBetalingsfrist.Value;
        FEnd:=FEnd + FDager;    }

        (* forfallt? *)
        {If (Now>=FEnd) then
        begin
          try
            AppData.Faktura.Edit;
            AppData.FakturaForfallt.AsBoolean:=True;
            AppData.Faktura.Post;
            AppData.Faktura.ApplyUpdates;
            AppData.Faktura.CommitUpdates;
          except
            on e: exception do
            Begin
              ErrorDialog(ClassName,'DoUpdate()',e.message);
              Break;
            end;
          end;
          inc(FForfall);
        End;    }

        AppData.Faktura.Next;
      end;

      mText:='Omsetning = %s' + #13 + 'MVA = %s';

      //showmessage( Format(mText,[CurrToStr(FCash),currToStr(FMVA)]) );

      Appdata.Prefs.WriteCurrency(PREFS_LASTOMSETTING,FCash);
      AppData.Prefs.WriteCurrency(PREFS_LASTMVA,FMva);

    //lbOmsetning.Caption:=CurrToStr(round(Appdata.Prefs.ReadCurrency(PREFS_LASTOMSETTING)));
    //lbMVA.Caption:=CurrToStr(Round(Appdata.Prefs.ReadCurrency(PREFS_LASTMVA)));



    finally
      FreeAndNIL(mForm);

      self.cursor:=crDefault;
      frmMain.Enabled:=True;

      (* Sette tilbake instillinger fra tidligere *)
      Appdata.Faktura.SortOptions:=FOldSorting;
      AppData.Faktura.Filter:=FOldFilter;
      Appdata.Faktura.filtered:=FOldFiltered;
      AppData.Faktura.RecNo:=FIndex;
      AppData.Faktura.EnableControls;

      If FForfall=0 then
      Status.Caption:=CNT_MAINFORM_STATUS_DBUPDATED else
      Status.Caption:=Format(CNT_MAINFORM_STATUS_DBUPDATED2,[FForfall]);
    end;
  end;

  procedure TfrmMain.DoFakturaJournalExecute(Sender: TObject);
  var
    FText:  String;
  begin
    if (Appdata.faktura.active=False)
    or (appdata.faktura.recordcount=0) then
    Begin
      FText:='Ingen registrerte fakturaer!';
      Application.MessageBox(PChar(FText),'Faktura Journal',MB_OK	or MB_ICONINFORMATION);
      exit;
    End;

    (* vis vindue *)
    With TfrmFakturaJournal.Create(self) do
    Begin
      try
        Showmodal;
      finally
        Free;
      end;
    End;
  end;

  procedure TfrmMain.DoPrintFakturaExecute(Sender: TObject);
  begin
    (* check that we can do this *)
    If (Appdata.DataStoreActive=False) then
    exit;

    With TfrmFakturaReport.Create(self) do
    begin
      try
        With Reportviewer do
        Begin
          Report:=FakturaReport;
          RegenerateReport;
          Print;
        end;
      finally
        Free;
      end;
    End;
  end;

  procedure TfrmMain.DoSettingsExecute(Sender: TObject);
  begin
    If appdata.DataStoreActive then
    With TfrmSettings.Create(Self) do
    Begin
      try
        If ShowModal=mrOK then
        UpdateDbStatus;
      finally
        Free;
      end;
    End;
  end;

  procedure TfrmMain.DoFordringJournalExecute(Sender: TObject);
  var
    FText:  String;
  begin
    { check that we can do this }
    if (Appdata.faktura.active=False)
    or (appdata.faktura.recordcount=0) then
    Begin
      FText:='Ingen registrerte fakturaer!';
      Application.MessageBox(PChar(FText),'Fordring Journal',MB_OK	or MB_ICONINFORMATION);
      exit;
    End;

    With TfrmFordringJournal.Create(self) do
    Begin
      try
        Showmodal;
      finally
        Free;
      end;
    End;
  end;

  procedure TfrmMain.DoKundeRapportExecute(Sender: TObject);
  var
    Ftext:    String;
  begin
    (* check that we can do this *)
    if (Appdata.kunder.active=False)
    or (appdata.kunder.recordcount=0) then
    Begin
      FText:='Ingen registrerte kunder!';
      Application.MessageBox(PChar(FText),'Kunde Journal',MB_OK	or MB_ICONINFORMATION);
      exit;
    End;

    With TfrmKundeReport.Create(self) do
    Begin
      try
        ShowModal;
      finally
        Free;
      end;
    end;
  end;

  procedure TfrmMain.DataGridColumnClick(Sender: TObject;Column: TdxDBTreeListColumn);
  var
    x:      Integer;
    FGrid:  TDXDBGrid;
    FTable: TVolgaTable;
  begin
    If (Column.Field=NIL)
    or (TDXDBGrid(Sender).DataSource=NIL)
    or (TDXDBGrid(Sender).DataSource.DataSet=NIL)
    or (TDXDBGrid(Sender).DataSource.DataSet.Active=False) then
    exit;

    (* get grid and table *)
    FGrid :=TDXDBGrid(Sender);
    FTable:=TVolgaTable(FGrid.DataSource.DataSet);

    (* just exit if this is a calculated field *)
    if Column.Field.Calculated then
    exit;

    (* remove sorting from other fields *)
    for x:=1 to FGrid.ColumnCount do
    begin
      If (FGrid.Columns[x-1]<>Column) then
      FGrid.Columns[x-1].Sorted:=csNone;
    end;

    try
      (* sort data according to new specs *)
      if (vsoDescendSort in FTable.SortOptions) then
      Begin
        FTable.Sortoptions:=[];
        TdxDBGridColumn(Column).Sorted:=csDown;
      end else
      Begin
        FTable.Sortoptions:=[vsoDescendSort];
        TdxDBGridColumn(Column).Sorted:=csUp;
      end;
      FTable.IndexFieldNames:=column.Field.FieldName;
    except
      on exception do;
    end;
  end;

  Procedure TfrmMain.SearchFor(Kind:Integer);
  Begin
    With TfrmSearch.Create(Self) do
    Begin
      try
        AType.ItemIndex:=Kind;
        If Showmodal=mrOK then
        Begin
          SetGroup(GlobalValues.FFindGroup);
          Case FFindGroup of
          GROUP_LEVERANDORER: AppData.Leverandorer.Find('Id',[FFindId],True);
          GROUP_FAKTURA:      AppData.Faktura.Find('Id',[FFindId],True);
          GROUP_KUNDER:       AppData.Kunder.Find('Id',[FFindId],True);
          GROUP_PRODUKTER:    AppData.Produkter.Find('Id',[FFindId],True);
          End;
          DoEditRecord.Execute;
        End;
      finally
        Free;
      end;
    End;
  End;

  procedure TfrmMain.GridDblClick(Sender: TObject);
  begin
    DoEditRecord.Execute;
  end;

  procedure TfrmMain.DoGotoKundeExecute(Sender: TObject);
  var
    FKundeNavn: String;
    FForm:  TfrmKunde;
  begin
    FKundeNavn:=trim(appdata.FakturaKunde.Value);
    if Length(FKundeNavn)>0 then
    Begin
      If Appdata.Kunder.Like('firma',FKundeNavn,true,true) then
      Begin

        (* Skape kundeform *)
        try
          FForm:=TfrmKunde.Create(self);
        except
          on e: exception do
          Begin
            globalvalues.ErrorDialog(self.Name,
            'DoGotoKundeExecute',e.message);
            exit;
          end;
        end;

        (* vise kundeform *)
        try
          FForm.RecordMode:=arEdit;
          FForm.ShowModal;
        finally
          FreeAndNIL(FForm);
        end;
      
      end;
    end;
  end;

  procedure TfrmMain.DoEditPurringerExecute(Sender: TObject);
  var
    FForm:  TfrmEditPurringer;
  begin
    (* Lage vindue for purringer *)
    try
      FForm:=TfrmEditPurringer.Create(self);
    except
      on e: exception do
      Begin
        globalvalues.ErrorDialog(self.Name,
        'DoEditPurringerExecute',e.message);
        exit;
      end;
    end;

    (* vis vindue for purringer *)
    try
      FForm.ShowModal;
    finally
      FreeAndNIL(FForm);
    end;
  end;

  procedure TfrmMain.FakturaGridChangeNode(Sender: TObject;
            OldNode,Node: TdxTreeListNode);
  begin
    UpdateButtonStates;
  end;

  procedure TfrmMain.DoOpenStoreExecute(Sender: TObject);
  begin
    With TfrmLoader.Create(Self) do
    Begin
      try
        ShowModal;
      finally
        Free;
      end;
    end;
  end;

  procedure TfrmMain.DoCloseStoreExecute(Sender: TObject);
  begin
    if not (csDestroying in ComponentState) then
    SetGroup(GROUP_ALLE);

    AppData.CloseDataStore;
  end;

  procedure TfrmMain.DoSetRowSelectExecute(Sender: TObject);
  begin
    //btnSelectRows.Down:=True;
    LeverandorGrid.OptionsView:=LeverandorGrid.OptionsView + [edgoRowSelect];
    KunderGrid.OptionsView:=KunderGrid.OptionsView + [edgoRowSelect];
    ProdukterGrid.OptionsView:=ProdukterGrid.OptionsView + [edgoRowSelect];
    FakturaGrid.OptionsView:=FakturaGrid.OptionsView + [edgoRowSelect];

    (* save changes *)
    If Appdata.DataStoreActive then
    Begin
      Appdata.Prefs.WriteBoolean(PREFS_ROWSELECT,True);
      AppData.UpdatePrefs;
    end;
  end;

  procedure TfrmMain.DoSetColSelectExecute(Sender: TObject);
  begin
    //btnSelectCols.Down:=True;
    LeverandorGrid.OptionsView:=LeverandorGrid.OptionsView - [edgoRowSelect];
    KunderGrid.OptionsView:=KunderGrid.OptionsView - [edgoRowSelect];
    ProdukterGrid.OptionsView:=ProdukterGrid.OptionsView - [edgoRowSelect];
    FakturaGrid.OptionsView:=FakturaGrid.OptionsView - [edgoRowSelect];

    (* save changes *)
    If Appdata.DataStoreActive then
    Begin
      Appdata.Prefs.WriteBoolean(PREFS_ROWSELECT,False);
      AppData.UpdatePrefs;
    end;
  end;

  procedure TfrmMain.DoEditKundeGrupperExecute(Sender: TObject);
  var
    FForm:  TfrmGrupper;
  begin
    (* skape vindue for kundegruppe *)
    try
      FForm:=TfrmGrupper.Create(self);
    except
      on e: exception do
      Begin
        globalvalues.ErrorDialog(self.Name,
        'DoEditKundeGrupperExecute',e.message);
        exit;
      end;
    end;

    (* vis vindue for kundegruppe *)
    try
      FForm.ShowModal;
    finally
      FreeAndNIL(FForm);
    end;
  end;

  procedure TfrmMain.FakturaGridColumn3GetText(Sender: TObject;ANode: TdxTreeListNode; var AText: String);
  begin
    If Appdata.FakturaStatus.Value=FAKTURA_KREDITNOTA then
    AText:='Kr. -' + CurrToStrF(AppData.FakturaTotal.Value,ffFixed,2);
  end;

  procedure TfrmMain.DoShowInfoExecute(Sender: TObject);
  begin
    SetGroup(GROUP_ALLE);
  end;

  procedure TfrmMain.FakturaGridColumn3CustomDrawCell(Sender: TObject;
            ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
            AColumn: TdxTreeListColumn; ASelected, AFocused,
            ANewItemRow:Boolean; var AText: String; var AColor: TColor;
            AFont: TFont; var AAlignment: TAlignment;
            var ADone: Boolean);
  var
    dx,dy:  Integer;
  begin
    If Appdata.FakturaStatus.value=FAKTURA_KREDITNOTA then
    Begin
      ACanvas.Brush.Color:=AColor;
      ACanvas.FillRect(ARect);

      dx:=ARect.Right - ACanvas.TextWidth(AText);
      dy:=ARect.Top + (((ARect.Bottom-ARect.Top) div 2)
      - (ACanvas.TextHeight(AText) div 2));

      ACanvas.Font.Assign(AFont);
      ACanvas.Textout(dx,dy,AText);

      ACanvas.Pen.Color:=clNavy;
      inc(dy,ACanvas.TextHeight(AText));
      ACanvas.MoveTo(dx,dy);
      ACanvas.LineTo(ARect.Right,dy);

      SmallImages.draw(ACanvas,ARect.Left+2,ARect.Top+3,9,True);

      ADone:=True;
      exit;
    end;

    If Appdata.FakturaForfallt.Value then
    Begin
      If Appdata.FakturaStatus.value<>FAKTURA_BETALT then
      Begin
        ACanvas.Brush.Color:=AColor;
        ACanvas.FillRect(ARect);

        dx:=ARect.Right - ACanvas.TextWidth(AText);
        dy:=ARect.Top + (((ARect.Bottom-ARect.Top) div 2)
        - (ACanvas.TextHeight(AText) div 2));

        ACanvas.Font.Assign(AFont);
        ACanvas.Textout(dx,dy,AText);

        SmallImages.draw(ACanvas,ARect.Left+2,ARect.Top+1,8,True);

        ADone:=True;
      end;
    end;
  end;

  procedure TfrmMain.DoUpdateKeyNumbersExecute(Sender: TObject);
  begin
    DoProcess.Execute;
    UpdateDbStatus;
  end;

  procedure TfrmMain.DoGotoItemExecute(Sender: TObject);
  var
    FId:      Integer;

    Procedure FindRecord(Const aTable:TVolgaTable);
    var
      FRec: Integer;
    Begin
      if appdata.GotoRecord(aTable,FId,FRec) then
      DoEditRecord.Execute else
      Begin
        if not edref.Focused then
        Begin
          edRef.SetFocus;
          edRef.SelectAll;
        end;
      end;
    end;

  begin
    FId:=edRef.IntValue;
    case edTarget.ItemIndex of
    0: { Faktura}
      begin
        (* switch grid display? *)
        If (Groups.TabIndex<>GROUP_FAKTURA) then
        SetGroup(GROUP_FAKTURA);
        FindRecord(appdata.faktura);
      end;
    1: { Kunde }
      begin
        (* switch grid display? *)
        If (Groups.TabIndex<>GROUP_KUNDER) then
        SetGroup(GROUP_KUNDER);
        FindRecord(appdata.Kunder);
      end;
    2: { Produkt }
      begin
        (* switch grid display? *)
        If (Groups.TabIndex<>GROUP_PRODUKTER) then
        SetGroup(GROUP_PRODUKTER);
        FindRecord(appdata.Produkter);
      end;
    3: { Leverandør }
      begin
        (* switch grid display? *)
        If (Groups.TabIndex<>GROUP_LEVERANDORER) then
        SetGroup(GROUP_LEVERANDORER);
        FindRecord(appdata.Leverandorer);
      end;
    end;
  end;

  procedure TfrmMain.DoGotoItemUpdate(Sender: TObject);
  var
    FText:  String;
  begin
    If not (csDestroying in ComponentState) then
    Begin
      if assigned(appdata)
      and appdata.DataStoreActive then
      Begin
        Ftext:=trim(edRef.Text);
        DoGotoItem.Enabled:=(Length(FText)>0) and (edRef.IntValue>0);
      end else
      DoGotoItem.Enabled:=False;
    end;
  end;

  procedure TfrmMain.DoUpdateKeyNumbersUpdate(Sender: TObject);
  begin
    if not (csDestroying in ComponentState) then
    Begin
      DoUpdateKeyNumbers.Enabled:=assigned(appdata)
      and appdata.DataSetReady(appdata.Faktura);
    end;
  end;

  procedure TfrmMain.DoSetRowSelectUpdate(Sender: TObject);
  begin
    if not (csDestroying in ComponentState) then
    Begin
      DoSetRowSelect.Enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.DoSetColSelectUpdate(Sender: TObject);
  begin
    if not (csDestroying in ComponentState) then
    Begin
      DoSetColSelect.Enabled:=assigned(appdata)
      and appdata.DataStoreActive;
    end;
  end;

  procedure TfrmMain.RzURLLabel3Click(Sender: TObject);
  begin
    DoFindRecord.Execute;
  end;

  procedure TfrmMain.RzURLLabel12Click(Sender: TObject);
  begin
    DoSettings.Execute;
  end;

  procedure TfrmMain.RzURLLabel13Click(Sender: TObject);
  begin
    DoHelp.Execute;
  end;

  procedure TfrmMain.RzURLLabel7Click(Sender: TObject);
  begin
    DoExit.Execute;
  end;

  end.
