  unit fakturajournalform;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, reportclientForm, Menus, ImgList, ActnList, ppViewr,
  StdCtrls, RzLabel, ExtCtrls, RzPanel, DBCtrls, RzDBNav, RzButton,
  RzBckgnd, data, globalvalues, ppDB, ppDBPipe, ppCtrls, ppBands, ppVar,
  ppPrnabl, ppClass, ppCache, ppComm, ppRelatv, ppProd, ppReport, RzCommon,
  RzForms, Db, VolgaTbl, VolgaQry, RzSndMsg, RzDlgBtn;

  Type

  TfrmFakturaJournal = class(TfrmReportClient)
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
    ppLabel32: TppLabel;
    ppLabel33: TppLabel;
    ppLabel34: TppLabel;
    ppLabel4: TppLabel;
    nFirmaAdresse2: TppLabel;
    ppDetailBand5: TppDetailBand;
    ppDBText23: TppDBText;
    ppDBText24: TppDBText;
    nFakturaStatus: TppDBText;
    nReferanse: TppLabel;
    nProdukter: TppLabel;
    FakturaJournalPipe: TppDBPipeline;
    RzFormState1: TRzFormState;
    RzRegIniFile1: TRzRegIniFile;
    ppFooterBand1: TppFooterBand;
    ppLabel3: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLine1: TppLine;
    LiveQuery: TVolgaQuery;
    LiveData: TDataSource;
    LiveQueryID: TIntegerField;
    LiveQueryKunde: TStringField;
    LiveQueryAdresse: TStringField;
    LiveQueryAdresse2: TStringField;
    LiveQueryPostNr: TStringField;
    LiveQuerySted: TStringField;
    LiveQueryDato: TDateTimeField;
    LiveQueryBetalingsfrist: TIntegerField;
    LiveQueryRabatt: TIntegerField;
    LiveQueryStatus: TIntegerField;
    LiveQueryPris: TCurrencyField;
    LiveQueryMerk: TStringField;
    LiveQueryTekst: TMemoField;
    LiveQueryFakturaRef: TIntegerField;
    LiveQueryPurringer: TIntegerField;
    LiveQueryVarsel: TIntegerField;
    LiveQueryForfallt: TBooleanField;
    LiveItems: TVolgaQuery;
    LiveQueryDinRef: TStringField;
    LiveQueryMinRef: TStringField;
    LiveQueryRentesats: TFloatField;
    LiveQueryGebyr: TCurrencyField;
    ppLabel8: TppLabel;
    procedure nProdukterGetText(Sender: TObject; var Text: String);
    procedure nFakturaStatusGetText(Sender: TObject; var Text: String);
    procedure nFirmaNavnGetText(Sender: TObject; var Text: String);
    procedure nFirmaAdresseGetText(Sender: TObject; var Text: String);
    procedure nFirmaAdresse2GetText(Sender: TObject; var Text: String);
    procedure nPostNrGetText(Sender: TObject; var Text: String);
    procedure nStedGetText(Sender: TObject; var Text: String);
    procedure nReferanseGetText(Sender: TObject; var Text: String);
    procedure ppLabel7GetText(Sender: TObject; var Text: String);
    procedure ppLabel5GetText(Sender: TObject; var Text: String);
    procedure ppLabel2GetText(Sender: TObject; var Text: String);
    procedure FormShow(Sender: TObject);
    procedure LiveQueryAfterScroll(DataSet: TDataSet);
    procedure ppLabel8GetText(Sender: TObject; var Text: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Function getLivePurringer:Integer;
    Function getLiveGebyrValue:Currency;
    Function getLiveRenterValue:Currency;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  Function TfrmFakturaJournal.getLivePurringer:Integer;
  Begin
    result:=LiveQueryPurringer.Value + LiveQueryVarsel.Value;
  end;

  Function TfrmFakturaJournal.getLiveGebyrValue:Currency;
  Begin
    Result:=(LiveQueryGebyr.AsCurrency * getLivePurringer);
  end;

  Function TfrmFakturaJournal.getLiveRenterValue:Currency;
  Begin
    result:=(LiveQueryRenteSats.asCurrency * getLivePurringer);
  end;

  procedure TfrmFakturaJournal.nProdukterGetText(Sender: TObject;var Text: String);
  begin
    If LiveItems.Active then
    Text:=IntToStr(Round(liveitems.GetSum('antall'))) else
    Text:='-';
  end;

  procedure TfrmFakturaJournal.nFakturaStatusGetText(Sender: TObject;var Text: String);
  begin
    Text:=StatusToPrintStr(LiveQueryStatus.Value);
  end;

  procedure TfrmFakturaJournal.nFirmaNavnGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_FIRMA);
  end;

  procedure TfrmFakturaJournal.nFirmaAdresseGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_A);
  end;

  procedure TfrmFakturaJournal.nFirmaAdresse2GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_B);
  end;

  procedure TfrmFakturaJournal.nPostNrGetText(Sender: TObject;var Text: String);
  begin
    Text:=IntToStr(AppData.Prefs.ReadInteger(PREFS_POSTNR));
  end;

  procedure TfrmFakturaJournal.nStedGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_STED);
  end;

  procedure TfrmFakturaJournal.nReferanseGetText(Sender: TObject;var Text: String);
  begin
    If LiveQueryStatus.Value=FAKTURA_KREDITNOTA then
    Text:=LiveQueryfakturaref.asString else
    Text:='--';
  end;

  procedure TfrmFakturaJournal.ppLabel7GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
  begin
    FValue:=LiveQuery.GetSum('pris');
    livequery.first;
    while not livequery.Eof do
    Begin
      If getLivePurringer>0 then
      Begin
        FValue:=FValue + getLiveGebyrValue;
        FValue:=FValue + getLiveRenterValue;
      end;
      livequery.next;
    end;
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

  procedure TfrmFakturaJournal.ppLabel5GetText(Sender: TObject;var Text: String);
  begin
    inherited;
    text:=IntToStr(Appdata.kunder.recordcount);
  end;

  procedure TfrmFakturaJournal.ppLabel2GetText(Sender: TObject;var Text: String);
  begin
    Text:=IntToStr(LiveQuery.RecordCount);
  end;

  procedure TfrmFakturaJournal.FormShow(Sender: TObject);
  begin
    LiveQuery.Active:=True;
    inherited;
  end;

  procedure TfrmFakturaJournal.LiveQueryAfterScroll(DataSet: TDataSet);
  begin
    inherited;

    (* lukk tabellen hvis active *)
    If LiveItems.Active then
    LiveItems.close;

    (* lookup saker *)
    try
      LiveItems.sql.clear;
      LiveItems.sql.add('select antall,fakturaid from fakturadata where fakturaid=' + LiveQueryId.asString);
      liveItems.open;
    except
      on exception do
      LiveItems.Close;
    end;
  end;

  procedure TfrmFakturaJournal.ppLabel8GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
  begin
    FValue:=LiveQueryPris.Value;
    If getLivePurringer>0 then
    Begin
      FValue:=FValue + getLiveGebyrValue;
      FValue:=FValue + getLiveRenterValue;
    end;
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

  procedure TfrmFakturaJournal.FormClose(Sender: TObject;var Action: TCloseAction);
  begin
    FakturaJournalPipe.close;
    LiveQuery.Close;
    LiveItems.Close;
  end;

end.
