  unit ubetaltreportform;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  reportclientForm, Menus, ImgList, ActnList, ppViewr, StdCtrls, RzLabel,
  ExtCtrls, RzPanel, DBCtrls, RzDBNav, RzButton, RzBckgnd, ppCtrls,
  ppBands, ppVar, ppPrnabl, ppClass, ppCache, ppProd, ppReport, ppDB,
  ppComm, ppRelatv, ppDBPipe, globalvalues, data, RzCommon, RzForms, Db,
  VolgaTbl, VolgaQry, RzSndMsg, RzDlgBtn;

  type TfrmFordringJournal = class(TfrmReportClient)
    FakturaJournalPipe: TppDBPipeline;
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
    ppLabel4: TppLabel;
    ppLabel7: TppLabel;
    nFirmaAdresse2: TppLabel;
    ppDetailBand5: TppDetailBand;
    ppDBText23: TppDBText;
    ppDBText24: TppDBText;
    nFakturaStatus: TppDBText;
    nReferanse: TppLabel;
    nBetalt: TppLabel;
    RzFormState1: TRzFormState;
    RzRegIniFile1: TRzRegIniFile;
    ppFooterBand1: TppFooterBand;
    ppLine1: TppLine;
    ppLabel3: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel8: TppLabel;
    LiveDataDS: TDataSource;
    LiveQuery: TVolgaQuery;
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
    ppLabel9: TppLabel;
    LiveQueryDinRef: TStringField;
    LiveQueryMinRef: TStringField;
    LiveQueryRentesats: TFloatField;
    LiveQueryGebyr: TCurrencyField;
    procedure nBetaltGetText(Sender: TObject; var Text: String);
    procedure nReferanseGetText(Sender: TObject; var Text: String);
    procedure nFakturaStatusGetText(Sender: TObject; var Text: String);
    procedure nFirmaNavnGetText(Sender: TObject; var Text: String);
    procedure nFirmaAdresseGetText(Sender: TObject; var Text: String);
    procedure nFirmaAdresse2GetText(Sender: TObject; var Text: String);
    procedure nPostNrGetText(Sender: TObject; var Text: String);
    procedure nStedGetText(Sender: TObject; var Text: String);
    procedure ppLabel5GetText(Sender: TObject; var Text: String);
    procedure ppLabel8GetText(Sender: TObject; var Text: String);
    procedure ppLabel1GetText(Sender: TObject; var Text: String);
    procedure FormShow(Sender: TObject);
    procedure ppLabel9GetText(Sender: TObject; var Text: String);
  private
    Function getLivePurringer:Integer;
    Function getLiveGebyrValue:Currency;
    Function getLiveRenterValue:Currency;
  public
  end;

  implementation

  {$R *.DFM}

  Function TfrmFordringJournal.getLivePurringer:Integer;
  Begin
    result:=LiveQueryPurringer.Value + LiveQueryVarsel.Value;
  end;

  Function TfrmFordringJournal.getLiveGebyrValue:Currency;
  Begin
    Result:=(LiveQueryGebyr.AsCurrency * getLivePurringer);
  end;

  Function TfrmFordringJournal.getLiveRenterValue:Currency;
  Begin
    result:=(LiveQueryRenteSats.asCurrency * getLivePurringer);
  end;

  procedure TfrmFordringJournal.nBetaltGetText(Sender: TObject;var Text: String);
  var
    FDato:  TDate;
    FDager: Integer;
  begin
    FDato:=LiveQueryDato.Value;
    FDager:=LiveQueryBetalingsfrist.value;
    FDato:=FDato + FDager;
    Text:=DateToStr(FDato);
  end;

  procedure TfrmFordringJournal.nReferanseGetText(Sender: TObject;var Text: String);
  begin
    If LiveQueryStatus.Value=FAKTURA_KREDITNOTA then
    Text:=LiveQueryFakturaRef.asString else
    Text:='--';
  end;

  procedure TfrmFordringJournal.nFakturaStatusGetText(Sender: TObject;var Text: String);
  begin
    Text:=StatusToPrintStr(LiveQueryStatus.Value);
  end;

  procedure TfrmFordringJournal.nFirmaNavnGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_FIRMA);
  end;

  procedure TfrmFordringJournal.nFirmaAdresseGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_A);
  end;

  procedure TfrmFordringJournal.nFirmaAdresse2GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_B);
  end;

  procedure TfrmFordringJournal.nPostNrGetText(Sender: TObject;var Text: String);
  begin
    Text:=IntToStr(AppData.Prefs.ReadInteger(PREFS_POSTNR));
  end;

  procedure TfrmFordringJournal.nStedGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_STED);
  end;

  procedure TfrmFordringJournal.ppLabel5GetText(Sender: TObject;var Text: String);
  begin
    text:=IntToStr(Appdata.kunder.recordcount);
  end;

  procedure TfrmFordringJournal.ppLabel8GetText(Sender: TObject;var Text: String);
  begin
    text:=IntToStr(LiveQuery.recordcount);
  end;

  procedure TfrmFordringJournal.ppLabel1GetText(Sender: TObject;var Text: String);
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

  procedure TfrmFordringJournal.FormShow(Sender: TObject);
  begin
    LiveQuery.open;
    inherited;
  end;

  procedure TfrmFordringJournal.ppLabel9GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
    {Function getLivePurringer:Integer;
    Begin
      result:=LiveQueryPurringer.Value + LiveQueryVarsel.Value;
    end;

    Function getLiveGebyrValue:Currency;
    Begin
      Result:=(LiveQueryGebyr.AsCurrency * getLivePurringer);
    end;

    Function getLiveRenterValue:Currency;
    Begin
      result:=(LiveQueryRenteSats.asCurrency * getLivePurringer);
    end;}

  begin
    FValue:=LiveQueryPris.Value;
    If getLivePurringer>0 then
    Begin
      FValue:=FValue + getLiveGebyrValue;
      FValue:=FValue + getLiveRenterValue;
    end;
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

end.
