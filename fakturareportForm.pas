  unit fakturareportForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, reportclientForm, ImgList, ActnList, RzPanel, ppViewr,
  StdCtrls, RzLabel, ExtCtrls, DBCtrls, RzDBNav, RzButton, RzBckgnd,
  Menus, globalvalues, ppMemo, ppBands, ppCtrls, ppReport, ppStrtch,
  ppSubRpt, ppPrnabl, ppClass, ppCache, ppProd, ppDB, ppComm, ppRelatv,
  ppDBPipe, data, RzCommon, RzForms, RzSndMsg, RzDlgBtn, ppModule, raCodMod;

  Type

  TfrmFakturaReport = class(TfrmReportClient)
    FakturaDataPipe: TppDBPipeline;
    FakturaReport: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppLabel1: TppLabel;
    ppDBText5: TppDBText;
    ppLabel6: TppLabel;
    ppDBText7: TppDBText;
    ppLabel8: TppLabel;
    ppLabel9: TppLabel;
    nFirmaNavn: TppLabel;
    nFirmaTelefon: TppLabel;
    nFirmaFaks: TppLabel;
    nFirmaEPost: TppLabel;
    nFirmaInternett: TppLabel;
    nKundeNavn: TppDBText;
    nKundeAdresse: TppDBText;
    nKundePostNr: TppDBText;
    nKundePostSted: TppDBText;
    ppDBText21: TppDBText;
    nMerk: TppDBText;
    ppLabel35: TppLabel;
    ppLabel13: TppLabel;
    ppLabel14: TppLabel;
    ppLabel15: TppLabel;
    ppLabel16: TppLabel;
    nKundeAdresse2: TppDBText;
    ppDetailBand1: TppDetailBand;
    ppShape4: TppShape;
    ppSubReport1: TppSubReport;
    ppChildReport1: TppChildReport;
    ppDetailBand3: TppDetailBand;
    ppDBText12: TppDBText;
    ppDBText13: TppDBText;
    ppDBText14: TppDBText;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
    ppLine4: TppLine;
    ppDBText17: TppDBText;
    ppFooterBand2: TppFooterBand;
    ppLabel39: TppLabel;
    ppLine1: TppLine;
    ppLabel40: TppLabel;
    ppLabel42: TppLabel;
    ppLabel45: TppLabel;
    ppLabel47: TppLabel;
    ppLabel48: TppLabel;
    ppLabel49: TppLabel;
    ppLabel50: TppLabel;
    ppLabel51: TppLabel;
    ppFooterBand1: TppFooterBand;
    ppDBText1: TppDBText;
    ppLine3: TppLine;
    ppDBMemo1: TppDBMemo;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppLabel17: TppLabel;
    ppLabel18: TppLabel;
    ppLabel19: TppLabel;
    ppLabel20: TppLabel;
    ppLabel3: TppLabel;
    ppLabel36: TppLabel;
    ppLabel37: TppLabel;
    ppLabel10: TppLabel;
    ppLabel38: TppLabel;
    ppDBText6: TppDBText;
    ppLabel4: TppLabel;
    ppLabel12: TppLabel;
    ppDBText8: TppDBText;
    RzFormState1: TRzFormState;
    RzRegIniFile1: TRzRegIniFile;
    ppLabel2: TppLabel;
    ppLabel7: TppLabel;
    ppLabel11: TppLabel;
    ppLabel21: TppLabel;
    ppLabel22: TppLabel;
    ppLabel23: TppLabel;
    ppLabel24: TppLabel;
    lbPurreGebyr: TppLabel;
    nPurregebyr: TppLabel;
    lbRenter: TppLabel;
    nRenter: TppLabel;
    raCodeModule2: TraCodeModule;
    ppDBText9: TppDBText;
    ppDBText10: TppDBText;
    ppDBText11: TppDBText;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    FakturaPipe: TppDBPipeline;
    ppLabel5: TppLabel;
    ppLabel25: TppLabel;
    procedure nFirmaNavnGetText(Sender: TObject; var Text: String);
    procedure ppLabel13GetText(Sender: TObject; var Text: String);
    procedure ppLabel14GetText(Sender: TObject; var Text: String);
    procedure ppLabel15GetText(Sender: TObject; var Text: String);
    procedure ppLabel16GetText(Sender: TObject; var Text: String);
    procedure ppLabel42GetText(Sender: TObject; var Text: String);
    procedure ppLabel40GetText(Sender: TObject; var Text: String);
    procedure nKundeAdresse2GetText(Sender: TObject; var Text: String);
    procedure ppLabel38GetText(Sender: TObject; var Text: String);
    procedure ppLabel3GetText(Sender: TObject; var Text: String);
    procedure ppLabel37GetText(Sender: TObject; var Text: String);
    procedure ppLabel36GetText(Sender: TObject; var Text: String);
    procedure ppLabel10GetText(Sender: TObject; var Text: String);
    procedure ppDBText21GetText(Sender: TObject; var Text: String);
    procedure ppLabel4GetText(Sender: TObject; var Text: String);
    procedure ppDBText6GetText(Sender: TObject; var Text: String);
    procedure ppLabel17GetText(Sender: TObject; var Text: String);
    procedure ppLabel18GetText(Sender: TObject; var Text: String);
    procedure ppLabel19GetText(Sender: TObject; var Text: String);
    procedure ppLabel20GetText(Sender: TObject; var Text: String);
    procedure ppDBText15GetText(Sender: TObject; var Text: String);
    procedure ppDBText17GetText(Sender: TObject; var Text: String);
    procedure ppLabel1GetText(Sender: TObject; var Text: String);
    procedure ppDBText16GetText(Sender: TObject; var Text: String);
    procedure ppDBText14GetText(Sender: TObject; var Text: String);
    procedure ppDBText8GetText(Sender: TObject; var Text: String);
    procedure nMerkGetText(Sender: TObject; var Text: String);
    procedure ppLabel2GetText(Sender: TObject; var Text: String);
    procedure ppLabel11GetText(Sender: TObject; var Text: String);
    procedure ppLabel24GetText(Sender: TObject; var Text: String);
    procedure ppLabel23GetText(Sender: TObject; var Text: String);
    procedure nPurregebyrGetText(Sender: TObject; var Text: String);
    procedure nRenterGetText(Sender: TObject; var Text: String);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Function  RemoveKr(Value:String):String;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmFakturaReport.FormShow(Sender: TObject);
  begin
    If appdata.GetPurringer=0 then
    Begin
      lbPurreGebyr.Visible:=False;
      lbRenter.Visible:=False;
      nPurreGebyr.Visible:=False;
      nRenter.Visible:=False;
    end;
    inherited;
  end;

  procedure TfrmFakturaReport.nFirmaNavnGetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_FIRMA);
  end;

  procedure TfrmFakturaReport.ppLabel13GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_TELEFON);
  end;

  procedure TfrmFakturaReport.ppLabel14GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_FAX);
  end;

  procedure TfrmFakturaReport.ppLabel15GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_EMAIL);
  end;

  procedure TfrmFakturaReport.ppLabel16GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_WWW);
  end;

  procedure TfrmFakturaReport.ppLabel42GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
  begin
    FValue:=Appdata.FakturaPris.AsCurrency - AppData.FakturaData.GetSum('eksmva');
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

  procedure TfrmFakturaReport.nKundeAdresse2GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Faktura.FieldByName('Adresse2').AsString;
    if length(Text)=0 then
    text:='-';
  end;

  procedure TfrmFakturaReport.ppLabel38GetText(Sender: TObject;var Text: String);
  var
    FEnd:   TDateTime;
    FDager: Integer;
  begin
    { Regne ut forfallsdato }
    FEnd  :=AppData.FakturaDato.AsDateTime;
    FDager:=AppData.FakturaBetalingsfrist.asInteger;
    FEnd:=(FEnd + FDager);
    Text:=DateToStr(FEnd);
  end;

  procedure TfrmFakturaReport.ppLabel3GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_KONTIE);
  end;

  procedure TfrmFakturaReport.ppDBText21GetText(Sender: TObject;var Text: String);
  begin
    If (appdata.GetPurringer>0)
    or (Appdata.FakturaForfallt.asBoolean=True) then
    Text:='** Omgående' else
    Text:=(Text + ' ' + 'dager');
  end;

  procedure TfrmFakturaReport.ppLabel4GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_B);
  end;

  procedure TfrmFakturaReport.ppDBText6GetText(Sender: TObject;var Text: String);
  begin
    if length(Text)=0 then
    Text:='-';
  end;

  procedure TfrmFakturaReport.ppLabel17GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_FIRMA);
  end;

  procedure TfrmFakturaReport.ppLabel18GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_A);
  end;

  procedure TfrmFakturaReport.ppLabel19GetText(Sender: TObject;var Text: String);
  begin
    Text:=IntToStr(AppData.Prefs.ReadInteger(PREFS_POSTNR));
  end;

  procedure TfrmFakturaReport.ppLabel20GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_STED);
  end;

  procedure TfrmFakturaReport.ppDBText15GetText(Sender: TObject;var Text: String);
  begin
    text:=Text+'%';
  end;

  procedure TfrmFakturaReport.ppDBText17GetText(Sender: TObject;var Text: String);
  begin
    text:=Text + '%';
  end;

  procedure TfrmFakturaReport.ppLabel1GetText(Sender: TObject;var Text: String);
  begin
    Case Appdata.FakturaStatus.asInteger of
    FAKTURA_BETALT,FAKTURA_KREDITNOTA:
      Begin
        Text:=StatusToPrintStr(AppData.FakturaStatus.asInteger);
      end;
    else
      Begin
        if (appdata.fakturaVarsel.asInteger>0) then
        Text:='Inkassovarsel' else
        If (appdata.fakturapurringer.asInteger>0) then
        Text:='Purring' else
        Text:=StatusToPrintStr(AppData.FakturaStatus.asInteger);
      end;
    end;
  end;

  procedure TfrmFakturaReport.ppDBText16GetText(Sender: TObject;var Text: String);
  begin
    text:=RemoveKr(text);
  end;

  Function TfrmFakturaReport.RemoveKr(Value:String):String;
  var
    xpos: Integer;
  begin
    xpos:=pos('kr ',lowercase(value));
    if xpos>0 then
    Delete(value,1,xpos + 2);
    result:=Value;
  end;

  procedure TfrmFakturaReport.ppDBText14GetText(Sender: TObject;var Text: String);
  begin
    text:=removeKr(Text);
  end;

  procedure TfrmFakturaReport.ppDBText8GetText(Sender: TObject;var Text: String);
  begin
    text:=removeKr(Text);
  end;

  procedure TfrmFakturaReport.nMerkGetText(Sender: TObject;var Text: String);
  begin
    If appdata.fakturastatus.AsInteger=FAKTURA_KREDITNOTA then
    text:='Refereres til faktura nummer: ' +
    Appdata.fakturaFakturaRef.AsString;
  end;

  procedure TfrmFakturaReport.ppLabel11GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Prefs.ReadString(PREFS_ORGID);
  end;

  procedure TfrmFakturaReport.ppLabel24GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Faktura.FieldbyName('dinref').asString;
  end;

  procedure TfrmFakturaReport.ppLabel23GetText(Sender: TObject;var Text: String);
  begin
    Text:=AppData.Faktura.FieldbyName('minref').asString;
  end;

  procedure TfrmFakturaReport.ppLabel40GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
  begin
    FValue:=AppData.FakturaData.GetSum('eksmva');
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

  procedure TfrmFakturaReport.nPurregebyrGetText(Sender: TObject;var Text: String);
  begin
    If appdata.GetPurringer>0 then
    Text:='Kr. ' + CurrToStrF(appdata.GetGebyrValue,ffFixed,2) else
    Text:='Kr. 0,0';
  end;

  procedure TfrmFakturaReport.nRenterGetText(Sender: TObject;var Text: String);
  begin
    If appdata.GetPurringer>0 then
    Text:='Kr. ' + CurrToStrF(appdata.GetRentervalue,ffFixed,2) else
    Text:='Kr. 0,0';
  end;

  procedure TfrmFakturaReport.ppLabel2GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
  begin
    FValue:=AppData.FakturaPris.Value;
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

  procedure TfrmFakturaReport.ppLabel36GetText(Sender: TObject;var Text: String);
  var
    FText:  String;
    xpos:   Integer;
    FValue: Currency;
  begin
    {FValue:=AppData.FakturaPris.Value;
    If GetPurringer>0 then
    Begin
      //FValue:=FValue + (FValue - AppData.FakturaData.GetSum('eksmva'));
      FValue:=FValue + GetGebyrValue;
      FValue:=FValue + GetRenterValue;
    end;}
    FValue:=Appdata.FakturaTotal.asCurrency;
    FText:=CurrToStrF(FValue,ffFixed,2);

    xpos:=pos(',',FText);
    if xpos>0 then
    Delete(FText,xpos,length(FText));

    Text:=FText;
  end;

  procedure TfrmFakturaReport.ppLabel10GetText(Sender: TObject;var Text: String);
  var
    FValue: Currency;
  begin
    {FValue:=AppData.FakturaPris.Value;
    If GetPurringer>0 then
    Begin
      //FValue:=FValue + (FValue - AppData.FakturaData.GetSum('eksmva'));
      FValue:=FValue + GetGebyrValue;
      FValue:=FValue + GetRenterValue;
    end;}
    FValue:=Appdata.FakturaTotal.asCurrency;
    Text:=CurrToStrF(FValue,ffFixed,2);
  end;

  procedure TfrmFakturaReport.ppLabel37GetText(Sender: TObject;var Text: String);
  var
    FText:  String;
    xpos:   Integer;
    FValue: Currency;
  begin
    {FValue:=AppData.FakturaPris.Value;
    If GetPurringer>0 then
    Begin
      //FValue:=FValue + (FValue - AppData.FakturaData.GetSum('eksmva'));
      FValue:=FValue + GetGebyrValue;
      FValue:=FValue + GetRenterValue;
    end;}
    FValue:=Appdata.FakturaTotal.asCurrency;
    FText:=CurrToStrF(FValue,ffFixed,2);

    xpos:=pos(',',FText);
    if xpos>0 then
    Delete(FText,1,xpos);

    Ftext:=trim(FText);

    Text:=FText;
  end;

  procedure TfrmFakturaReport.FormClose(Sender: TObject;var Action: TCloseAction);
  begin
    fakturaPipe.close;
    FakturaDataPipe.close;
  end;

end.
