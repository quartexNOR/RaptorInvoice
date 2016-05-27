  unit settingsForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, Data, clientform, ImgList, ActnList,
  StdCtrls, Rzcommon, RzLabel, ExtCtrls, RzPanel, DBCtrls, RzDBNav,
  RzButton, RzBckgnd, RzEdit, RzDBEdit, Mask, RzTabs,
  globalvalues,RzSndMsg, RzDlgBtn, RzRadGrp, RzRadChk, RzLstBox;

  Type

  TfrmSettings = class(TfrmClient)
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    lbKunde: TRzLabel;
    lbAdresse: TRzLabel;
    lbPostNr: TRzLabel;
    RzLabel6: TRzLabel;
    lbSted: TRzLabel;
    RzLabel8: TRzLabel;
    nFirma: TRzEdit;
    nAdresse: TRzEdit;
    nTelefon: TRzEdit;
    nPostNr: TRzEdit;
    nFaks: TRzEdit;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    nEPost: TRzEdit;
    nInterNett: TRzEdit;
    TabSheet2: TRzTabSheet;
    nSted: TRzEdit;
    RzLabel3: TRzLabel;
    nKonto: TRzEdit;
    lbFaktura: TRzLabel;
    lbPurring: TRzLabel;
    lbInkasso: TRzLabel;
    lbKreditere: TRzLabel;
    nFakturaTekst: TRzEdit;
    nPurringTekst: TRzEdit;
    nInkassoTekst: TRzEdit;
    nKreditereTekst: TRzEdit;
    RzSeparator2: TRzSeparator;
    lbAdresse2: TRzLabel;
    nAdresse2: TRzEdit;
    RzLabel4: TRzLabel;
    DORegister: TAction;
    RzLabel5: TRzLabel;
    nOrgId: TRzEdit;
    RzGroupBox1: TRzGroupBox;
    Label1: TLabel;
    RzLabel7: TRzLabel;
    nRef: TRzEdit;
    TabSheet3: TRzTabSheet;
    RzGroupBox2: TRzGroupBox;
    RzLabel9: TRzLabel;
    nPurreGebyr: TRzMaskEdit;
    RzLabel10: TRzLabel;
    nRentesats: TRzMaskEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DoShowLicense: TAction;
    procedure nPostNrKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmSettings.FormShow(Sender: TObject);
  begin
    inherited;
    nFirma.Text:=Appdata.Prefs.ReadString(PREFS_FIRMA);
    nAdresse.Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_A);
    nAdresse2.Text:=AppData.Prefs.ReadString(PREFS_ADRESSE_B);
    nPostNr.Text:=IntToStr(AppData.Prefs.ReadInteger(PREFS_POSTNR));
    nSted.Text:=AppData.Prefs.ReadString(PREFS_STED);
    nTelefon.Text:=AppData.Prefs.ReadString(PREFS_TELEFON);
    nFaks.Text:=AppData.Prefs.ReadString(PREFS_FAX);
    nEPost.Text:=AppData.Prefs.ReadString(PREFS_EMAIL);
    nInternett.Text:=AppData.Prefs.ReadString(PREFS_WWW);
    nKonto.Text:=AppData.Prefs.ReadString(PREFS_KONTIE);
    nOrgId.Text:=Appdata.Prefs.ReadString(PREFS_ORGID);
    nPurreGebyr.Text:=IntToStr(AppData.Prefs.ReadInteger(PREFS_PURREGEBYR));
    nRenteSats.Text:=IntToSTr(AppData.Prefs.ReadInteger(PREFS_RENTESATS));
    nFakturaTekst.Text:=AppData.Prefs.ReadString(PREFS_FAKTURATEXT);
    nPurringTekst.Text:=AppData.Prefs.ReadString(PREFS_PURRETEXT);
    nInkassoTekst.Text:=AppData.Prefs.ReadString(PREFS_INKASSOTEXT);
    nkreditereTekst.Text:=Appdata.Prefs.ReadString(PREFS_KREDITTERETEXT);
    nRef.Text:=AppData.Prefs.ReadString(PREFS_REFERANSE_NAVN);
  end;

  procedure TfrmSettings.nPostNrKeyPress(Sender: TObject; var Key: Char);
  begin
    If  (pos(key,CHARSET_NUMERIC)<1)
    and (Key<>#8) then
    begin
      key:=#0;
      exit;
    End;
  end;

  procedure TfrmSettings.DoOKExecute(Sender: TObject);
  begin
    try
      try
        With AppData.Prefs do
        begin
          WriteString(PREFS_FIRMA,nFirma.Text);
          WriteString(PREFS_ADRESSE_A,nAdresse.Text);
          WriteString(PREFS_ADRESSE_B,nAdresse2.Text);
          WriteInteger(PREFS_POSTNR,StrToInt(nPostNr.Text));
          WriteString(PREFS_STED,nSted.Text);
          WriteString(PREFS_TELEFON,nTelefon.Text);
          WriteString(PREFS_FAX,nFaks.Text);
          WriteString(PREFS_EMAIL,nEPost.Text);
          WriteString(PREFS_WWW,nInternett.Text);
          WriteString(PREFS_KONTIE,nKonto.Text);
          WriteString(PREFS_ORGID,nOrgId.Text);
          WriteInteger(PREFS_PURREGEBYR,StrToInt(trim(nPurreGebyr.Text)));
          WriteInteger(PREFS_RENTESATS,StrToInt(trim(nRenteSats.Text)));
          WriteString(PREFS_FAKTURATEXT,nFakturaTekst.Text);
          WriteString(PREFS_PURRETEXT,nPurringTekst.Text);
          WriteString(PREFS_INKASSOTEXT,nInkassoTekst.Text);
          WriteString(PREFS_KREDITTERETEXT,nkreditereTekst.Text);
          WriteString(PREFS_REFERANSE_NAVN,nRef.Text);
        end;
      except
        on exception do;
      end;
    finally
      Appdata.UpdatePrefs;
    end;
    inherited;
  end;

  end.
