  program raptor;

  {%ToDo 'raptor.todo'}

uses
  FastMM4,
  themes,
  Forms,
  mainform in 'mainform.pas' {frmMain},
  clientform in 'clientform.pas' {frmClient},
  globalvalues in 'globalvalues.pas',
  kundeForm in 'kundeForm.pas' {frmKunde},
  kundeValgForm in 'kundeValgForm.pas' {frmKundeValg},
  produktValgForm in 'produktValgForm.pas' {frmVelgProdukt},
  loadForm in 'loadForm.pas' {frmLoader},
  searchForm in 'searchForm.pas' {frmSearch},
  xplook in 'xplook.pas',
  fakturereForm in 'fakturereForm.pas' {frmFakturer},
  fakturaForm in 'fakturaForm.pas' {frmFaktura},
  productform in 'productform.pas' {frmProduct},
  leverandorForm in 'leverandorForm.pas' {frmLeverandor},
  reportclientForm in 'reportclientForm.pas' {frmReportClient},
  fakturareportForm in 'fakturareportForm.pas' {frmFakturaReport},
  settingsForm in 'settingsForm.pas' {frmSettings},
  data in 'data.pas' {AppData: TDataModule},
  fakturajournalform in 'fakturajournalform.pas' {frmFakturaJournal},
  ubetaltreportform in 'ubetaltreportform.pas' {frmFordringJournal},
  kundereportForm in 'kundereportForm.pas' {frmKundeReport},
  fakturerAlleForm in 'fakturerAlleForm.pas' {frmFakturerAlle},
  kundegruppeform in 'kundegruppeform.pas' {frmKundeGruppe},
  editpurringerform in 'editpurringerform.pas' {frmEditPurringer},
  grupperForm in 'grupperForm.pas' {frmGrupper},
  betaleForm in 'betaleForm.pas' {frmBetale},
  registerForm in 'registerForm.pas' {frmRegister},
  jlstrparse in '..\libjl\jlstrparse.pas',
  oppdaterForm in 'oppdaterForm.pas' {frmUpdate};

{$R *.RES}

  begin
    Application.Initialize;
    Application.Title := 'Faktura';
  Application.CreateForm(TAppData, AppData);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
  end.
