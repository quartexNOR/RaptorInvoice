  unit dbdata;

  interface

  uses
  SysUtils, Classes, DB, VolgaTbl,
  globalvalues;

  type

  TDataStore = class(TDataModule)
    Leverandorer: TVolgaTable;
    LeverandorerId: TIntegerField;
    LeverandorerFirma: TStringField;
    LeverandorerAdresse: TStringField;
    LeverandorerAdresse2: TStringField;
    LeverandorerSted: TStringField;
    LeverandorerPostnr: TStringField;
    LeverandorerTelefon: TStringField;
    LeverandorerFax: TStringField;
    LeverandorerEmail: TStringField;
    LeverandorerInternett: TStringField;
    LeverandorerKontaktperson: TStringField;
    LeverandorerOrganisasjonsId: TStringField;
    LeverandorerKommentarer: TMemoField;
    Produkter: TVolgaTable;
    ProdukterId: TIntegerField;
    ProdukterLeverandorId: TIntegerField;
    ProdukterLeverandorRef: TStringField;
    ProdukterTittel: TStringField;
    ProdukterType: TStringField;
    ProdukterInnPris: TCurrencyField;
    ProdukterUtPris: TCurrencyField;
    ProdukterMva: TIntegerField;
    ProdukterBeskrivelse: TMemoField;
    ProdukterAvanse: TIntegerField;
    LeverandorerDs: TDataSource;
    ProdukterDs: TDataSource;
    Faktura: TVolgaTable;
    FakturaID: TIntegerField;
    FakturaKunde: TStringField;
    FakturaAdresse: TStringField;
    FakturaAdresse2: TStringField;
    FakturaPostNr: TStringField;
    FakturaSted: TStringField;
    FakturaDato: TDateTimeField;
    FakturaBetalingsfrist: TIntegerField;
    FakturaRabatt: TIntegerField;
    FakturaStatus: TIntegerField;
    FakturaPris: TCurrencyField;
    FakturaMerk: TStringField;
    FakturaTekst: TMemoField;
    FakturaFakturaRef: TIntegerField;
    FakturaPurringer: TIntegerField;
    FakturaVarsel: TIntegerField;
    FakturaForfallt: TBooleanField;
    FakturaForfall: TDateTimeField;
    FakturaDinRef: TStringField;
    FakturaMinRef: TStringField;
    FakturaRentesats: TFloatField;
    FakturaGebyr: TCurrencyField;
    FakturaTotal: TCurrencyField;
    FakturaPurredato: TDateTimeField;
    FakturaDs: TDataSource;
    FakturaData: TVolgaTable;
    FakturaDataFakturaId: TIntegerField;
    FakturaDataProdukt: TStringField;
    FakturaDataAntall: TFloatField;
    FakturaDataPris: TCurrencyField;
    FakturaDataMva: TIntegerField;
    FakturaDataRabatt: TIntegerField;
    FakturaDataEksMva: TCurrencyField;
    FakturaDataInkMva: TCurrencyField;
    FaturaDataDs: TDataSource;
    Kunder: TVolgaTable;
    KunderId: TIntegerField;
    KunderGruppe: TIntegerField;
    KunderFirma: TStringField;
    KunderAdresse: TStringField;
    KunderAdresse2: TStringField;
    KunderPostnr: TStringField;
    KunderSted: TStringField;
    KunderTelefon: TStringField;
    KunderFax: TStringField;
    KunderEmail: TStringField;
    KunderInternett: TStringField;
    KunderKontaktperson: TStringField;
    KunderOrganisasjonsId: TStringField;
    KunderKommentarer: TMemoField;
    KunderSalg: TCurrencyField;
    KunderDs: TDataSource;
    dbase: TVolgaDatabase;
    KundeGrupperDS: TDataSource;
    KundeGrupper: TVolgaTable;
    KundeGrupperId: TAutoIncField;
    KundeGrupperTittel: TStringField;
    KundeGrupperRabatt: TIntegerField;
    KundeGrupperNotater: TMemoField;
    KundeGrupperAktiv: TBooleanField;
    KundeGrupperTag: TStringField;
    procedure LeverandorerBeforePost(DataSet: TDataSet);
    procedure LeverandorerNewRecord(DataSet: TDataSet);
    procedure ProdukterBeforePost(DataSet: TDataSet);
    procedure ProdukterCalcFields(DataSet: TDataSet);
    procedure FakturaAfterScroll(DataSet: TDataSet);
    procedure FakturaBeforePost(DataSet: TDataSet);
    procedure FakturaCalcFields(DataSet: TDataSet);
    procedure FakturaNewRecord(DataSet: TDataSet);
    procedure KunderBeforePost(DataSet: TDataSet);
    procedure KunderNewRecord(DataSet: TDataSet);
    procedure KundeGrupperNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
    FPrefs:     TJLPropertyBag;
    FActive:    Boolean;
    FTables:    Array[0..5] of TVolgaTable;
    FDataPath:  String;
  Protected
    Function    GetRenterValue:Currency;
    Function    GetDagerSidenForfall:Integer;
    Function    GetGebyrValue:currency;
    Function    GetPurringer:Integer;
    Procedure   FilterFakturaDataById(Value:Integer);
    Function    DataSetReady(Dataset:TVolgaTable):Boolean;
    Procedure   ResetPrefs;
  Public
    Procedure   UpdatePrefs;
    Property    Preferences:TJLPropertyBag read FPrefs;
    Function    Active:Boolean;
    Function    Open(FolderName:String):Boolean;
    Function    Close:Boolean;
  public
    Procedure   BeforeDestruction;Override;
    Constructor Create(AOwner:TComponent);Override;
    Destructor  Destroy;Override;
  end;

  var
  DataStore: TDataStore;

  implementation

  {$R *.dfm}

  Constructor TDataStore.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FPrefs:=TJLPropertyBag.Create;

    (* build list of tables *)
    FTables[0]:=Leverandorer;
    FTables[1]:=Produkter;
    FTables[2]:=Kunder;
    FTables[3]:=FakturaData;
    FTables[4]:=Faktura;
    FTables[5]:=KundeGrupper;
  end;

  Destructor TDataStore.Destroy;
  Begin
    FPrefs.free;
    inherited;
  end;

  Procedure TDataStore.BeforeDestruction;
  Begin
    If Active then
    Close;
    inherited;
  end;
  
  Function TDataStore.Active:Boolean;
  Begin
    result:=FActive;
  end;

  Function TDataStore.DataSetReady(Dataset:TVolgaTable):Boolean;
  Begin
    result:=True;
    If (Dataset=NIL)
    or (FActive=False)
    or (DataSet.Active=False)
    or (Dataset.RecordCount=0) then
    Result:=False;
  end;

  Function TDataStore.Open(FolderName:String):Boolean;
  var
    FTables:  Array[0..5] of TVolgaTable;
    x,y: Integer;
    FPrefsFile: String;
  Begin
    result:=False;
    (* close data access if already open *)
    If Active then
    Begin
      if not Close then
      exit;
    end;

    (* Open database *)
    try
      dbase.DataBasePath:=FolderName;
    except
      on exception do
      Raise Exception.CreateFmt
      (DIALOG_KanIkkeOpenDbMappe,[FolderName]);
    end;

    { attempt to open data tables }
    for x:=low(FTables) to high(FTables) do
    Begin
      try
        (* set sorting options *)
        FTables[x].SortOptions:=[];

        (* read only mode? *)
        FTables[x].ReadOnly:=False;

        (* activate table *)
        FTables[x].Active:=True;
      except
        on exception do
        Begin
          (* shut down previously successfull tables *)
          if x>0 then
          Begin
            for y:=Low(FTables) to X-1 do
            FTables[y].Active:=False;
          end;
        end;
      end;
    End;

    (* load prefs file, or generate default preferences *)
    FPrefsFile:=IncludeTrailingPathDelimiter(FolderName) + 'prefs.dat';
    If not FileExists(Fprefsfile) then
    Begin
      (* lag en ny og blank settings fil *)
      ResetPrefs;
      FPrefs.SaveToFile(FprefsFile);
    end else
    FPrefs.LoadFromFile(FPrefsFile);

    (* remember datapath *)
    FDataPath:=IncludeTrailingPathDelimiter(FolderName);

    (* set datastore to active *)
    FActive:=True;
    Result:=True;
  end;

  Function TDataStore.Close:Boolean;
  var
    x:  Integer;
  Begin
    result:=False;
    If Active then
    Begin
      for x:=Low(FTables) to high(FTables) do
      Begin
        try
          FTables[x].Active:=False;
        except
          on exception do
          Continue;
        end;
      end;

      dbase.DataBasePath:='';
      FDataPath:='';
      FActive:=False;
      Result:=True;
    end;
  end;

  Procedure TDataStore.UpdatePrefs;
  var
    FPrefsFile: String;
  Begin
    (* check that we can do this *)
    If FActive then
    Begin
      (* update disk prefs file *)
      FPrefsFile:=IncludeTrailingPathDelimiter(FDataPath) + 'prefs.dat';
      try
        FPrefs.SaveToFile(FPrefsFile);
      except
        on exception do;
      end;
    end;
  end;

  Procedure TDataStore.ResetPrefs;
  Begin
    FPrefs.Clear;

    (* løpende id nummer *)
    FPrefs.WriteInteger(PREFS_FAKTURAID,DEFAULT_FAKTURA_NUMBER);
    FPrefs.WriteInteger(PREFS_KUNDEID,DEFAULT_KUNDE_NUMBER);
    FPrefs.WriteInteger(PREFS_LEVERANDORID,DEFAULT_LEVERANDOR_NUMBER);
    FPrefs.WriteInteger(PREFS_PRODUKTID,DEFAULT_PRODUKT_NUMBER);

    (* firma personalia *)
    FPrefs.WriteString(PREFS_FIRMA,'Mitt Firma DA');
    FPrefs.WriteString(PREFS_ADRESSE_A,'-');
    FPrefs.WriteString(PREFS_ADRESSE_B,'Fiktivstien 1b');
    FPrefs.WriteInteger(PREFS_POSTNR,3152);
    FPrefs.WriteString(PREFS_STED,'Tolvsrød');
    FPrefs.WriteString(PREFS_TELEFON,'33333337');
    FPrefs.WriteString(PREFS_FAX,'33333338');
    FPrefs.WriteString(PREFS_EMAIL,'post@mittfirma.no');
    FPrefs.WriteString(PREFS_WWW,'http://www.mittfirma.no');
    FPrefs.WriteString(PREFS_ORGID,'123456789 MVA');
    FPrefs.WriteString(PREFS_KONTIE,'0000.00.00000');
    FPrefs.WriteString(PREFS_REFERANSE_NAVN,'Ola Nordmann');

    (* tekster *)
    FPrefs.WriteString(PREFS_FAKTURATEXT,
    'Takk for handelen! Vi håper å høre fra deg igjen.');

    FPrefs.WriteString(PREFS_PURRETEXT,
    'Har du glemt oss? Vi minner om utestående faktura.');

    FPrefs.WriteString(PREFS_INKASSOTEXT,
    'Vi varsler herved at utestående faktura må betales omgående før inkasso.');

    FPrefs.WriteString(PREFS_KREDITTERETEXT,
    'Beløpet er kredittert.');

    (* annet *)
    FPrefs.WriteInteger(PREFS_PURREGEBYR,53);
    FPrefs.WriteInteger(PREFS_RENTESATS,3);

    (* Interne "huskelapper" *)
    FPrefs.WriteInteger(PREFS_AVANSE,3);
    FPrefs.WriteInteger(PREFS_MVA,0);
    FPrefs.WriteDate(PREFS_LASTRUN,Now);
    FPrefs.WriteBoolean(PREFS_ROWSELECT,True);

    (* salgstall *)
    FPrefs.WriteCurrency(PREFS_LASTOMSETTING,0.0);
    FPrefs.WriteCurrency(PREFS_LASTMVA,0.0);
    FPrefs.WriteCurrency(PREFS_LASTRABATT,0.0);
  end;

  Function TDataStore.GetPurringer:Integer;
  Begin
    result:=0;
    if DataSetReady(Faktura) then
    result:=(FakturaPurringer.AsInteger + fakturaVarsel.AsInteger);
  end;

  Function TDataStore.GetGebyrValue:currency;
  Begin
    result:=0.0;
    if DataSetReady(Faktura) then
    Result:=(FakturaGebyr.AsCurrency * GetPurringer);
  end;

  Function TDataStore.GetDagerSidenForfall:Integer;
  var
    FDato:  TDateTime;
    FDager: Integer;
  Begin
    result:=0;
    if DataSetReady(Faktura) then
    Begin
      FDato:=FakturaDato.AsDateTime;
      FDager:=FakturaBetalingsfrist.AsInteger;
      FDato:=FDato + FDager;

      If (fakturapurredato.AsDateTime>FDato) then
      Result:=DaysBetween(fakturapurredato.AsDateTime,FDato);
    end;
  end;

  Function TDataStore.GetRenterValue:Currency;
  begin
    result:=0.0;
    if DataSetReady(Faktura) then
    Begin
      result:=FakturaPris.AsCurrency * FakturaRenteSats.AsCurrency;
      Result:=Result * GetDagerSidenForfall;
      Result:=Result / 3600;
      {Result:=(((FakturaPris.AsCurrency * FakturaRenteSats.AsCurrency)
      * GetDagerSidenForfall) / 3600); }
    end;
  end;

  
  procedure TDataStore.LeverandorerBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    (* Check that this is a new record *)
    If leverandorer.State=dsInsert then
    Begin
      (* update ID number *)
      FValue:=FPrefs.ReadInteger(PREFS_LEVERANDORID) + 1;
      FPrefs.WriteInteger(PREFS_LEVERANDORID,FValue);

      (* update prefs on disk *)
      UpdatePrefs;
    end;
  end;

  procedure TDataStore.LeverandorerNewRecord(DataSet: TDataSet);
  begin
    { Sette ny ID på ny leverandør }
    LeverandorerId.AsInteger:=FPrefs.ReadInteger(PREFS_LEVERANDORID);
    LeverandorerFirma.AsString:='Ny leverandør';
  end;

  procedure TDataStore.ProdukterBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    { oppdatere produkt-id for neste produkt }
    If produkter.State=dsInsert then
    begin
      FValue:=FPrefs.ReadInteger(PREFS_PRODUKTID) + 1;
      FPrefs.WriteInteger(PREFS_PRODUKTID,FValue);
      UpdatePrefs;
    end;
  end;

  procedure TDataStore.ProdukterCalcFields(DataSet: TDataSet);
  begin
    (* kalkulere avanse *)
    If (ProdukterAvanse.asInteger<4) then
    if (ProdukterAvanse.asInteger>=0) then
    ProdukterUtPris.AsCurrency:=
    (ProdukterInnPris.AsCurrency * FAvanser[ProdukterAvanse.AsInteger]);
  end;


  Procedure TDataStore.FilterFakturaDataById(Value:Integer);
  Begin
    If FActive then
    Begin
      If FakturaData.Active then
      Begin
        (* remove current filtering *)
        If FakturaData.Filtered then
        Begin
          Fakturadata.filtered:=False;
          fakturadata.filter:='';
        end;

        { Filter the fakturadata table to Active record }
        FakturaData.Filter:='FakturaId = ' + IntToStr(Value);
        FakturaData.Filtered:=True;
      end;
    end;
  end;


  procedure TDataStore.FakturaAfterScroll(DataSet: TDataSet);
  begin
    { filtrer fakturadata kun til å vise info rellatert
      til aktive faktura }
    FilterFakturaDataById(FakturaId.Value);
  end;

  procedure TDataStore.FakturaBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    { oppdatere register faktura id for neste faktura }
    If faktura.State=dsInsert then
    Begin
      FValue:=FPrefs.ReadInteger(PREFS_FAKTURAID) + 1;
      FPrefs.WriteInteger(PREFS_FAKTURAID,FValue);
      UpdatePrefs;
    end;
  end;

  procedure TDataStore.FakturaCalcFields(DataSet: TDataSet);
  var
    FValue: Currency;
  begin
    (* calculate "total" field value *)
    FValue:=FakturaPris.Value;
    If GetPurringer>0 then
    Begin
      FValue:=FValue + GetGebyrValue;
      FValue:=FValue + GetRenterValue;
    end;
    FakturaTotal.AsCurrency:=FValue;
  end;

  procedure TDataStore.FakturaNewRecord(DataSet: TDataSet);
  begin
    { Sette ny ID på ny faktura }
    FakturaId.AsInteger:=FPrefs.ReadInteger(PREFS_FAKTURAID);
    FakturaDato.AsDateTime:=Now;
    FakturaBetalingsfrist.AsInteger:=30;
    FakturaRenteSats.AsFloat:=FPrefs.ReadInteger(PREFS_RENTESATS);
    FakturaGebyr.AsCurrency:=FPrefs.ReadInteger(PREFS_PURREGEBYR);
    FakturaDinRef.AsString:=FPrefs.ReadString(PREFS_REFERANSE_NAVN);
    FakturaTekst.AsString:=FPrefs.ReadString(PREFS_FAKTURATEXT);
  end;

  procedure TDataStore.KunderBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    If kunder.state=dsInsert then
    Begin
      FValue:=FPrefs.ReadInteger(PREFS_KUNDEID) + 1;
      FPrefs.WriteInteger(PREFS_KUNDEID,FValue);
      UpdatePrefs;
    end;
  end;

  procedure TDataStore.KunderNewRecord(DataSet: TDataSet);
  begin
    { Sette ny ID på ny kunde }
    KunderId.AsInteger:=FPrefs.ReadInteger(PREFS_KUNDEID);
    KunderGruppe.AsInteger:=1;
    KunderFirma.AsString:='Ny kunde';
  end;

  procedure TDataStore.KundeGrupperNewRecord(DataSet: TDataSet);
  begin
    KundeGrupperAktiv.AsBoolean:=True;
    KundeGrupperTittel.AsString:='Ny kundegruppe';
  end;

end.
