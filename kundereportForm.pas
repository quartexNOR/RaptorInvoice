  unit kundereportForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, reportclientForm, Menus, ImgList, ActnList, ppViewr, StdCtrls,
  RzLabel, ExtCtrls, RzPanel, DBCtrls, RzDBNav, RzButton, RzBckgnd, data,
  globalvalues, ppCtrls, ppBands, ppVar, ppPrnabl, ppClass, ppCache,
  ppProd, ppReport, ppDB, ppComm, ppRelatv, ppDBPipe, RzCommon, RzForms,
  ppModule, raCodMod, Db, VolgaTbl, VolgaQry, RzSndMsg, RzDlgBtn;

  Type TfrmKundeReport = class(TfrmReportClient)
    SalgsBasePipe: TppDBPipeline;
    FakturaJournal: TppReport;
    ppHeaderBand4: TppHeaderBand;
    ppShape1: TppShape;
    ppLabel12: TppLabel;
    ppLabel22: TppLabel;
    nFirmaNavn: TppLabel;
    nFirmaAdresse: TppLabel;
    nPostNr: TppLabel;
    nSted: TppLabel;
    ppSystemVariable3: TppSystemVariable;
    ppLabel28: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppLabel30: TppLabel;
    ppLabel31: TppLabel;
    ppLabel4: TppLabel;
    nFirmaAdresse2: TppLabel;
    ppDetailBand5: TppDetailBand;
    ppDBText23: TppDBText;
    ppDBText24: TppDBText;
    ppDBText1: TppDBText;
    RzFormState1: TRzFormState;
    RzRegIniFile1: TRzRegIniFile;
    raCodeModule1: TraCodeModule;
    ppFooterBand1: TppFooterBand;
    ppLine1: TppLine;
    ppLabel3: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel8: TppLabel;
    LiveDataDS: TDataSource;
    LiveData: TVolgaQuery;
    procedure nFirmaNavnGetText(Sender: TObject; var Text: String);
    procedure nFirmaAdresseGetText(Sender: TObject; var Text: String);
    procedure nFirmaAdresse2GetText(Sender: TObject; var Text: String);
    procedure nPostNrGetText(Sender: TObject; var Text: String);
    procedure nStedGetText(Sender: TObject; var Text: String);
    procedure ppLabel5GetText(Sender: TObject; var Text: String);
    procedure ppLabel7GetText(Sender: TObject; var Text: String);
    procedure ppLabel2GetText(Sender: TObject; var Text: String);
    procedure FormShow(Sender: TObject);
  private
    //
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmKundeReport.nFirmaNavnGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_FIRMA);
  end;

  procedure TfrmKundeReport.nFirmaAdresseGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_A);
  end;

  procedure TfrmKundeReport.nFirmaAdresse2GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_B);
  end;

  procedure TfrmKundeReport.nPostNrGetText(Sender: TObject;var Text: String);
  begin
    Text:=IntToStr(AppData.Prefs.ReadInteger(PREFS_POSTNR));
  end;

  procedure TfrmKundeReport.nStedGetText(Sender: TObject; var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_STED);
  end;

  procedure TfrmKundeReport.ppLabel5GetText(Sender: TObject;var Text: String);
  begin
    text:=IntToStr(appdata.kunder.recordcount);
  end;

  procedure TfrmKundeReport.ppLabel7GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
  begin
    { Get total }
    FValue:=appdata.kunder.GetSum('salg');
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

  procedure TfrmKundeReport.ppLabel2GetText(Sender: TObject;var Text: String);
  begin
    text:=IntToStr(appdata.faktura.recordcount);
  end;

  procedure TfrmKundeReport.FormShow(Sender: TObject);
  begin
    livedata.open;
    inherited;
  end;

end.
