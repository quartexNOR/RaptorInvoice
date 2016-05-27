  unit data;

  interface

  uses
  Windows, Forms, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  Db, VolgaTbl, RzCommon, ImgList, RzBHints,
  jlcommon,
  //jllanguage,
  globalvalues,
  DateUtils;

  Type

  TDataStoreOpenEvent = Procedure (sender:TObject;APath:String) of Object;
  TBeforeDataStoreCloseEvent    = Procedure (Sender:TObject;APath:String) of Object;
  TDataStoreClosedEvent         = Procedure (Sender:TObject) of Object;

  TDataStoreProcessBeginsEvent  = Procedure (Sender:TObject;Max:Integer) of Object;
  TDataStoreProcessUpdateEvent  = Procedure (Sender:TObject;APos:Integer;AMax:Integer) of Object;
  TDataStoreProcessDoneEvent    = Procedure (Sender:TObject) of Object;
  TDataStoreMessageEvent        = Procedure (Sender:TObject;Value:String) of Object;
  TDataStoreUpdateEvent         = Procedure (Sender:TObject) of Object;

  TErrorInfo = Record
    eiActive: Boolean;
    eiProc:   String;
    eiUnit:   String;
    eiText:   String;
  End;

  TAppData = class(TDataModule)
    Leverandorer: TVolgaTable;
    Produkter: TVolgaTable;
    LeverandorerDs: TDataSource;
    ProdukterDs: TDataSource;
    Faktura: TVolgaTable;
    FakturaDs: TDataSource;
    FakturaData: TVolgaTable;
    FaturaDataDs: TDataSource;
    Kunder: TVolgaTable;
    KunderDs: TDataSource;
    PostStederDs: TDataSource;
    FrameController: TRzFrameController;
    PostSteder: TVolgaTable;
    PostStederPostNr: TStringField;
    PostStederSted: TStringField;
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
    FakturaDataFakturaId: TIntegerField;
    FakturaDataProdukt: TStringField;
    FakturaDataAntall: TFloatField;
    FakturaDataPris: TCurrencyField;
    FakturaDataMva: TIntegerField;
    FakturaDataRabatt: TIntegerField;
    FakturaDataEksMva: TCurrencyField;
    FakturaDataInkMva: TCurrencyField;
    dbase: TVolgaDatabase;
    FakturaForfall: TDateTimeField;
    FakturaDinRef: TStringField;
    FakturaMinRef: TStringField;
    KundeGrupperDS: TDataSource;
    KundeGrupper: TVolgaTable;
    KundeGrupperId: TAutoIncField;
    KundeGrupperTittel: TStringField;
    KundeGrupperRabatt: TIntegerField;
    KundeGrupperNotater: TMemoField;
    KundeGrupperAktiv: TBooleanField;
    FakturaRentesats: TFloatField;
    FakturaGebyr: TCurrencyField;
    KundeGrupperTag: TStringField;
    FakturaTotal: TCurrencyField;
    SystemDb: TVolgaDatabase;
    FakturaPurredato: TDateTimeField;
    FakturaLev_kunde: TStringField;
    FakturaLev_addr1: TStringField;
    FakturaLev_addr2: TStringField;
    FakturaLev_postnr: TStringField;
    FakturaLev_sted: TStringField;
    procedure LeverandorerNewRecord(DataSet: TDataSet);
    procedure LeverandorerBeforePost(DataSet: TDataSet);
    procedure FakturaBeforePost(DataSet: TDataSet);
    procedure FakturaNewRecord(DataSet: TDataSet);
    procedure FakturaAfterScroll(DataSet: TDataSet);
    procedure ProdukterBeforePost(DataSet: TDataSet);
    procedure ProdukterNewRecord(DataSet: TDataSet);
    procedure KunderBeforePost(DataSet: TDataSet);
    procedure KunderNewRecord(DataSet: TDataSet);
    procedure ProdukterCalcFields(DataSet: TDataSet);
    procedure ProdukterAvanseChange(Sender: TField);
    procedure ProdukterLeverandorIdGetText(Sender: TField;var Text: String; DisplayText: Boolean);
    procedure FakturaStatusGetText(Sender: TField; var Text: String;DisplayText: Boolean);
    procedure FakturaForfalltGetText(Sender: TField; var Text: String;DisplayText: Boolean);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FakturaForfallGetText(Sender: TField; var Text: String;DisplayText: Boolean);
    procedure FakturaDatoGetText(Sender: TField; var Text: String;DisplayText: Boolean);
    procedure KunderGruppeGetText(Sender: TField; var Text: String;DisplayText: Boolean);
    procedure KundeGrupperRabattGetText(Sender: TField; var Text: String;DisplayText: Boolean);
    procedure KundeGrupperAktivGetText(Sender: TField; var Text: String;DisplayText: Boolean);
    procedure KundeGrupperNewRecord(DataSet: TDataSet);
    procedure FakturaCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    FOnOpen:          TDataStoreOpenEvent;
    FOnClose:         TDataStoreClosedEvent;
    FOnBefore:        TBeforeDataStoreCloseEvent;
    FOnProcessBegins: TDataStoreProcessBeginsEvent;
    FOnProcessUpdate: TDataStoreProcessUpdateEvent;
    FOnProcessDone:   TDataStoreProcessDoneEvent;
    FOnMessage:       TDataStoreMessageEvent;
    FOnUpdate:        TDataStoreUpdateEvent;
  private
    FActive:    Boolean;
    FReadOnly:  Boolean;
    FDataPath:  String;
    FAppInfo:   String;
    FMVAList:   Array of Integer;
    FLastError: TErrorInfo;
    FPrefs:     TJLPropertyBag;
  Protected
    Procedure PrintActiveInvoice(Copies:Integer=1);
    Procedure Fakturere(Dato:TDateTime;Pages:Integer);
    Procedure DataStoreProcessBegins(AMax:Integer);
    Procedure DataStoreProcessUpdate(APos,AMax:Integer);
    Procedure DataStoreProcessDone;
    Procedure DataStoreMessage(Value:String);
    Procedure DataStoreUpdate;
    Function  SetupApplication:Boolean;
  public
    Property  AboutText:String read FAppInfo;
    Property  Prefs:TJLPropertyBag read FPrefs write Fprefs;
    Procedure FilterFakturaDataById(Value:Integer);
    Function  DataSetReady(Dataset:TVolgaTable;
              Const MustHaveRecord:Boolean=True):Boolean;

    Procedure CopyFaktura(KeepHistory:Boolean);
    Procedure CopyLeverandor;
    Procedure CopyKunde;
    procedure CopyProdukt;
    Procedure CopyKundeGruppe;

    Procedure DeleteLeverandor;
    Procedure DeleteKunde;
    procedure DeleteProdukt;
    Procedure DeleteKundeGruppe;

    procedure Fakturer;
    Procedure FakturerAlle;
    Procedure KrediterFaktura;
    Procedure PurrFaktura;
    Procedure VarsleFaktura;
    Procedure BetalFaktura;

    Property  DataStoreActive:Boolean read FActive;
    Property  DataStoreReadOnly:Boolean read FReadOnly;
    Property  DataStorePath:String read FDataPath;
    Procedure OpenDataStore(AFolder:String);
    Procedure CloseDataStore;
    Procedure UpdatePrefs;
    Procedure ResetPrefs;

    Function  GetRenterValue:Currency;
    Function  GetDagerSidenForfall:Integer;
    Function  GetGebyrValue:currency;
    Function  GetPurringer:Integer;

    Function  GetMVAList(var Values:TIntArray):Boolean;
    Function  GetMVAListCount:Integer;

    Function  GetLastErrorStr(out Value:String):Boolean;
    Function  GetHasLastError:Boolean;
    Procedure SetLastError(AUnit,AProc,AText:String);
    Function  GetLastError(out Info:TErrorInfo):Boolean;
    Procedure ResetLastError;

    Function  GotoRecord(Table:TVolgaTable;Id:Integer;
              out OldRecNo:Integer):Boolean;

    Function  InvoiceObjGet(out Value:TJLInvoice):Boolean;
    Procedure InvoiceObjSet(Const Value:TJLInvoice);

  Published
    Property  OnDataStoreOpen: TDataStoreOpenEvent read FOnOpen write FOnOpen;
    Property  OnDataStoreClose: TDataStoreClosedEvent read FOnClose write FOnClose;
    Property  OnBeforeDataStoreClose: TBeforeDataStoreCloseEvent read FOnBefore write FOnBefore;
    Property  OnProcessBegins: TDataStoreProcessBeginsEvent read FOnprocessBegins write FOnProcessBegins;
    Property  OnProcessUpdate:TDataStoreProcessUpdateEvent read FOnProcessUpdate write FOnProcessUpdate;
    Property  OnProcessDone: TDataStoreProcessDoneEvent read FOnprocessDone write FOnProcessDone;
    Property  OnMessage: TDataStoreMessageEvent read FOnMessage write FOnMessage;
    Property  OnUpdate: TDataStoreUpdateEvent read FOnUpdate write FOnUpdate;
  end;

  var
  AppData: TAppData;

  implementation

  uses FileCtrl,
  clientform, betaleForm, fakturareportForm, fakturereForm, fakturerAlleForm;

  {$R *.DFM}

  //##########################################################################
  // TAppData
  //##########################################################################

  Function TAppData.SetupApplication:Boolean;
  var
    FPath:  String;
    FFile:  String;
    FText:  TStringList;
    Ftemp:  String;
    FValue: Integer;
    x:      Integer;
    FCount: Integer;

    Procedure DefaultMVA;
    Begin
      SetLength(FMVAList,4);
      FMVAList[0]:=25;
      FMVAList[1]:=14;
      FMVAList[2]:=08;
      FMVAList[3]:=00;
    end;

  Begin
    result:=False;

    (* Validate data directory *)
    FPath:=ExtractFilePath(Application.ExeName);
    FPath:=IncludeTrailingPathDelimiter(FPath) + 'data';
    If DirectoryExists(FPath)=False then
    exit;

    try
      (* Load AppInfo text *)
      FFile:=IncludeTrailingPathDelimiter(FPath) + 'appinfo.txt';
      If FileExists(FFile) then
      Begin
        FText:=TStringList.Create;
        try
          FText.LoadFromFile(FFile);
          FAppInfo:=FText.Text;
        finally
          FText.free;
        end;
      end else
      exit;

      (* Load text percentages *)
      FFile:=IncludeTrailingPathDelimiter(FPath) + 'mva.txt';
      If FileExists(FFile) then
      Begin
        FText:=TStringList.Create;
        try
          FText.LoadFromFile(FFile);
          for x:=1 to FText.Count do
          Begin
            FTemp:=trim(FText.Strings[x-1]);
            if length(FTemp)>0 then
            Begin
              If sysutils.TryStrToInt(FTemp,FValue) then
              Begin
                FCount:=Length(FMVAList);
                SetLength(FMVAList,FCount+1);
                FMVAList[FCount]:=FValue;
              end;
            end;
          end;
          if Length(FMVAList)<1 then
          DefaultMVA;
        finally
          FText.free;
        end;
      end else
      DefaultMVA;

      (* assign database path & setup zip-code table *)
      SystemDb.DataBasePath:=FPath;
      PostSteder.ReadOnly:=True;
      PostSteder.Active:=True;

      result:=True;
    except
      on exception do;
    end;
  end;

  Function TAppData.GetMVAList(var Values:TIntArray):Boolean;
  var
    FCount: Integer;
  Begin
    FCount:=Length(FMVAList);
    result:=FCount>0;
    if result then
    Begin
      SetLength(Values,FCount);
      for FCount:=Low(FMVAList) to high(FMVAList) do
      Values[FCount]:=FMVAList[FCount];
    end;
  end;

  Function TAppData.GetMVAListCount:Integer;
  Begin
    result:=Length(FMVAList);
  end;
  
  procedure TAppData.DataModuleCreate(Sender: TObject);
  begin
    (* Create preferences propertybag *)
    FPrefs:=TJLPropertyBag.Create;

    if not SetupApplication then
    Application.Terminate;
  end;

  procedure TAppData.DataModuleDestroy(Sender: TObject);
  begin
    (* shut down datastore *)
    If FActive then
    CloseDataStore;

    (* shut down lookup table *)
    If PostSteder.Active then
    PostSteder.Close;

    (* release prefs object *)
    if assigned(FPrefs) then
    FreeAndNIL(FPrefs);
  end;

  Procedure TAppData.InvoiceObjSet(Const Value:TJLInvoice);
  var
    x:  Integer;
    FCount: Integer;
    FItem:  TJLInvoiceItem;
  Begin
    if Value<>NIL then
    Begin

      if not (csDestroying in ComponentState)
      and DataStoreActive
      and DataSetReady(Faktura) then
      Begin

        if FakturaID.AsInteger = value.Id then
        Begin
          Faktura.Edit;

          FakturaDato.Value := value.FakturaDato;
          FakturaBetalingsfrist.Value:=value.Forfallsdager;
          FakturaForfallt.Value:=value.Forfallt;
          FakturaStatus.Value:=ord(value.State);
          FakturaPurringer.Value:=Value.Reminders;
          FakturaVarsel.Value:=Value.Warnings;
          FakturaRentesats.Value:=Value.RenteSats;
          FakturaGebyr.value:=Value.Gebyr;

          FakturaKunde.Value:=value.FakturaAdresse.Kunde;
          FakturaAdresse.Value:=value.FakturaAdresse.Adresse1;
          FakturaAdresse2.Value:=Value.FakturaAdresse.Adresse2;
          FakturaPostNr.Value:=value.FakturaAdresse.Sted;
          FakturaSted.Value:=value.FakturaAdresse.Stedsnavn;

          FakturaLev_kunde.Value:=value.MotakerAdresse.Kunde;
          FakturaLev_addr1.Value:=value.MotakerAdresse.Adresse1;
          FakturaLev_addr2.Value:=value.MotakerAdresse.Adresse2;
          FakturaLev_postnr.Value:=value.MotakerAdresse.Sted;
          FakturaLev_sted.Value:=value.MotakerAdresse.Stedsnavn;

          (* flush current invoice items *)
          FCount:=fakturadata.RecordCount;
          if FCount>0 then
          Begin
            While FCount>0 do
            Begin
              fakturadata.First;
              fakturadata.Delete;
              dec(FCount);
            end;
          end;

          (* Insert values from object *)
          for x:=1 to Value.Items.Count do
          Begin
            FItem:=Value.Items[x-1];
            fakturadata.Append;
            self.FakturaDataFakturaId.Value:=Value.Id;
            FakturaDataProdukt.Value:=FItem.Product;
            FakturaDataAntall.Value:=FItem.Count;
            FakturaDataPris.Value:=FItem.ItemPrice;
            FakturaDataMva.Value:=FItem.Vat;
            FakturaDataRabatt.Value:=FItem.Discount;
            FakturaDataEksMva.Value:=FItem.SumExVat;
            FakturaDataInkMva.Value:=FItem.SumIncVat;
            fakturadata.Post;
          end;
          fakturadata.ApplyUpdates;

          faktura.Post;
          faktura.ApplyUpdates;

        end else
        Raise Exception.Create('Faktura ID stemmer ikke med objekt');

      end else
      Raise Exception.Create('Kan ikke lagre faktura objekt, ingen tilgang');

    end else
    Raise Exception.Create('Kan ikke lagre faktura objekt, NIL error');
  end;

  Function TAppData.InvoiceObjGet(out Value:TJLInvoice):Boolean;
  var
    FItem:  TJLInvoiceItem;
  Begin
    result:=False;
    Value:=NIL;

    if not (csDestroying in ComponentState)
    and DataStoreActive
    and DataSetReady(Faktura) then
    Begin

      Value:=TJLInvoice.Create;

      try
        Value.BeginUpdate;

        (* faktura basis info *)
        value.Id:=FakturaID.Value;
        value.FakturaDato:=FakturaDato.Value;
        value.Forfallsdager:=FakturaBetalingsfrist.Value;
        value.Forfallt:=FakturaForfallt.Value;
        value.State:=TJLInvoiceState(FakturaStatus.Value);
        Value.Reminders:=FakturaPurringer.Value;
        Value.Warnings:=FakturaVarsel.Value;
        Value.RenteSats:=FakturaRentesats.Value;
        Value.Gebyr:=FakturaGebyr.AsCurrency;

        (* faktura adresse *)
        value.FakturaAdresse.Kunde:=FakturaKunde.Value;
        value.FakturaAdresse.Adresse1:=FakturaAdresse.Value;
        Value.FakturaAdresse.Adresse2:=FakturaAdresse2.Value;
        value.FakturaAdresse.Sted:=self.FakturaPostNr.Value;
        value.FakturaAdresse.Stedsnavn:=self.FakturaSted.Value;

        (* mottaker adresse *)
        value.MotakerAdresse.Kunde:=FakturaLev_kunde.Value;
        value.MotakerAdresse.Adresse1:=FakturaLev_addr1.Value;
        value.MotakerAdresse.Adresse2:=FakturaLev_addr2.Value;
        value.MotakerAdresse.Sted:=FakturaLev_postnr.Value;
        value.MotakerAdresse.Stedsnavn:=FakturaLev_sted.Value;

        (* Hent inn produktlinjer knyttet til faktura *)
        if fakturadata.RecordCount>0 then
        Begin
          fakturadata.First;
          While not fakturadata.Eof do
          Begin
            if value.Items.Add(FItem) then
            Begin
              FItem.BeginUpdate;
              FItem.Product:=FakturaDataProdukt.Value;
              FItem.Count:=FakturaDataAntall.Value;
              FItem.ItemPrice:=FakturaDataPris.AsCurrency;
              FItem.Vat:=FakturaDataMva.AsInteger;
              FItem.Discount:=FakturaDataRabatt.AsInteger;
              FItem.SumExVat:=FakturaDataEksMva.AsCurrency;
              FItem.SumIncVat:=FakturaDataInkMva.AsCurrency;
              FItem.EndUpdate;
            end else
            break;
            fakturadata.Next;
          end;
        end;
        Value.EndUpdate;

      except
        on e: exception do
        Begin
          FreeAndNIL(Value);
          Raise;
          exit;
        end;
      end;

      result:=True;
    end;
  end;

  Function TAppData.GetHasLastError:Boolean;
  Begin
    result:=FLastError.eiActive;
  end;

  Function TAppData.GetPurringer:Integer;
  Begin
    result:=0;
    If Faktura.Active then
    result:=(FakturaPurringer.AsInteger + fakturaVarsel.AsInteger);
  end;

  Function TAppData.GetGebyrValue:currency;
  Begin
    result:=0.0;
    If Faktura.Active then
    Result:=(FakturaGebyr.AsCurrency * GetPurringer);
  end;

  Function TAppData.GetDagerSidenForfall:Integer;
  var
    FDato:  TDateTime;
  Begin
    result:=0;
    If Faktura.Active then
    Begin
      FDato:=dateutils.IncDay(FakturaDato.Value,FakturaBetalingsfrist.Value);
      If (fakturapurredato.Value>FDato) then
      Result:=DaysBetween(fakturapurredato.Value,FDato);
    end;
  end;

  Function TAppData.GetRenterValue:Currency;
  begin
    If Faktura.Active then
    Result:=(((FakturaPris.Value * FakturaRenteSats.AsCurrency)
    * GetDagerSidenForfall) / 3600) else
    result:=0.0;
  end;


  Procedure TAppData.SetLastError(AUnit,AProc,AText:String);
  Begin
    FLastError.eiActive:=True;
    FLastError.eiProc:=AProc;
    FLastError.eiUnit:=AUnit;
    FLastError.eiText:=AText;
  end;

  Function TAppData.GetLastError(out Info:TErrorInfo):Boolean;
  Begin
    result:=FLastError.eiActive;
    If Result then
    Info:=FLastError else
    Begin
      Info.eiActive:=False;
      Info.eiProc:='';
      Info.eiUnit:='';
      Info.eiText:='';
    end;
  end;

  Function TAppData.GetLastErrorStr(out Value:String):Boolean;
  Begin
    result:=FLastError.eiActive;
    if result then
    Value:='Method ' + FLastError.eiProc + ' threw exception '
    + '[' + FLastError.eiText + ']' + ' in unit ' + FLastError.eiUnit else
    SetLength(Value,0);
  end;

  Procedure TAppData.ResetLastError;
  Begin
    FLastError.eiActive:=False;
    FLastError.eiProc:='';
    FLastError.eiUnit:='';
    FLastError.eiText:='';
  end;

  Procedure TAppData.DataStoreProcessBegins(AMax:Integer);
  Begin
    if Assigned(FOnprocessBegins) then
    FOnProcessBegins(self,AMax);
  end;

  Procedure TAppData.DataStoreProcessUpdate(APos,AMax:Integer);
  Begin
    If assigned(FOnProcessUpdate) then
    FOnProcessUpdate(self,APos,AMax);
  end;

  Procedure TAppData.DataStoreProcessDone;
  Begin
    If assigned(FOnProcessDone) then
    FOnProcessDone(self);
  end;

  Procedure TAppData.DataStoreMessage(Value:String);
  Begin
    If assigned(FOnMessage) then
    FOnMessage(self,Value);
  end;

  Procedure TAppData.DataStoreUpdate;
  Begin
    If assigned(FOnUpdate) then
    FOnUpdate(self);
  end;

  Procedure TAppData.ResetPrefs;
  Begin
    Prefs.Clear;

    (* løpende id nummer *)
    Prefs.WriteInteger(PREFS_FAKTURAID,DEFAULT_FAKTURA_NUMBER);
    Prefs.WriteInteger(PREFS_KUNDEID,DEFAULT_KUNDE_NUMBER);
    Prefs.WriteInteger(PREFS_LEVERANDORID,DEFAULT_LEVERANDOR_NUMBER);
    Prefs.WriteInteger(PREFS_PRODUKTID,DEFAULT_PRODUKT_NUMBER);

    (* firma personalia *)
    Prefs.WriteString(PREFS_FIRMA,'Mitt Firma DA');
    Prefs.WriteString(PREFS_ADRESSE_A,'-');
    Prefs.WriteString(PREFS_ADRESSE_B,'Fiktivstien 1b');
    Prefs.WriteInteger(PREFS_POSTNR,3152);
    Prefs.WriteString(PREFS_STED,'Tolvsrød');
    Prefs.WriteString(PREFS_TELEFON,'33333337');
    Prefs.WriteString(PREFS_FAX,'33333338');
    Prefs.WriteString(PREFS_EMAIL,'post@mittfirma.no');
    Prefs.WriteString(PREFS_WWW,'http://www.mittfirma.no');
    Prefs.WriteString(PREFS_ORGID,'123456789 MVA');
    Prefs.WriteString(PREFS_KONTIE,'0000.00.00000');
    Prefs.WriteString(PREFS_REFERANSE_NAVN,'Ola Nordmann');

    (* tekster *)
    Prefs.WriteString(PREFS_FAKTURATEXT,
    'Takk for handelen! Vi håper å høre fra deg igjen.');

    Prefs.WriteString(PREFS_PURRETEXT,
    'Har du glemt oss? Vi minner om utestående faktura.');

    Prefs.WriteString(PREFS_INKASSOTEXT,
    'Vi varsler herved at utestående faktura må betales omgående før inkasso.');

    Prefs.WriteString(PREFS_KREDITTERETEXT,
    'Beløpet er kredittert.');

    (* annet *)
    Prefs.WriteInteger(PREFS_PURREGEBYR,53);
    Prefs.WriteInteger(PREFS_RENTESATS,3);

    (* Interne "huskelapper" *)
    Prefs.WriteInteger(PREFS_AVANSE,3);
    Prefs.WriteInteger(PREFS_MVA,0);
    Prefs.WriteDate(PREFS_LASTRUN,Now);
    Prefs.WriteBoolean(PREFS_ROWSELECT,True);

    (* salgstall *)
    Prefs.WriteCurrency(PREFS_LASTOMSETTING,0.0);
    Prefs.WriteCurrency(PREFS_LASTMVA,0.0);
    Prefs.WriteCurrency(PREFS_LASTRABATT,0.0);
  end;

  Procedure TAppData.OpenDataStore(AFolder:String);
  var
    FTables:  Array[0..5] of TVolgaTable;
    x,y: Integer;
    FPrefsFile: String;
  Begin
    (* close data access if already open *)
    If FActive then
    CloseDataStore;

    (* Open database *)
    try
      dbase.DataBasePath:=AFolder;
    except
      on exception do
      Raise Exception.CreateFmt
      (DIALOG_KanIkkeOpenDbMappe,[AFolder]);
    end;

    (* build list of tables *)
    FTables[0]:=Leverandorer;
    FTables[1]:=Produkter;
    FTables[2]:=Kunder;
    FTables[3]:=FakturaData;
    FTables[4]:=Faktura;
    FTables[5]:=KundeGrupper;

    {If lcid.LicenseState=lsExpired then
    FReadOnly:=True else}
    FReadOnly:=False;

    { attempt to open data tables }
    x:=0;
    While x<6 do
    Begin
      try
        (* set sorting options *)
        FTables[x].SortOptions:=[];

        (* read only mode? *)
        FTables[x].ReadOnly:=FReadOnly;

        (* activate table *)
        FTables[x].Active:=True;
      except
        on e: exception do
        Begin
          (* shut down previously successfull tables *)
          if x>0 then
          Begin
            y:=0;
            while y<x do
            Begin
              FTables[y].Close;
              inc(y);
            end;
          end;
          (* raise exception *)
          Raise Exception.CreateFmt
            (
            'Det oppstod problemer med å åpne database tabellen [%s]'+#13+'%s',
            [FTables[x].TableName,e.message]
            );
        end;
      end;
      inc(x);
    End;

    (* load prefs file, or generate default preferences *)
    FPrefsFile:=IncludeTrailingPathDelimiter(AFolder) + 'prefs.dat';
    If not FileExists(Fprefsfile) then
    Begin
      (* lag en ny og blank settings fil *)
      ResetPrefs;
      Prefs.SaveToFile(FprefsFile);
    end else
    Prefs.LoadFromFile(FPrefsFile);

    (* remember datapath *)
    FDataPath:=IncludeTrailingPathDelimiter(AFolder);

    (* set datastore to active *)
    FActive:=True;

    (* notify main app *)
    If assigned(FOnOpen) then
    FOnOpen(self,FDataPath);

    DataStoreMessage(Prefs.ReadString(PREFS_FIRMA) + ' åpnet.');
  end;

  Procedure TAppData.UpdatePrefs;
  var
    FPrefsFile: String;
  Begin
    (* check that we can do this *)
    If not FActive then
    exit;

    (* update disk prefs file *)
    FPrefsFile:=IncludeTrailingPathDelimiter(FDataPath) + 'prefs.dat';
    try
      Prefs.SaveToFile(FPrefsFile);
    except
      on exception do;
    end;
  end;

  Procedure TAppData.CloseDataStore;
  var
    x:  Integer;
    FTables:  Array[0..5] of TVolgaTable;
  Begin
    If FActive then
    Begin
      (* notify main app *)
      If assigned(FOnbefore) then
      FOnBefore(self,FDataPath);

      try
        (* build list of tables *)
        FTables[0]:=Leverandorer;
        FTables[1]:=Produkter;
        FTables[2]:=Kunder;
        FTables[3]:=FakturaData;
        FTables[4]:=Faktura;
        FTables[5]:=KundeGrupper;

        (* close any active tables *)
        x:=0;
        While x<6 do
        Begin
          FTables[x].Active:=False;
          inc(x);
        end;

        dbase.DataBasePath:='';

        (* Set to non-active *)
        FActive:=False;
        FDataPath:='';
      finally
        (* notify main app *)
        If assigned(FOnClose) then
        FOnClose(self);
      end;
    end;
  end;

  //##########################################################################
  // Standard error dialogs
  //##########################################################################

  Procedure TAppData.FilterFakturaDataById(Value:Integer);
  Begin
    (* Check if component can be used *)
    if not (csDestroying in ComponentState) then
    Begin
      (* Check datastore state *)
      If DataStoreActive then
      Begin
        (* Check if table is active and ready for use *)
        If DataSetReady(FakturaData,false) then
        Begin

          (* remove current filtering *)
          If FakturaData.Filtered then
          Begin
            Fakturadata.filtered:=False;
            fakturadata.filter:='';
          end;

          { Filter the fakturadata table to Active record }
          try
            FakturaData.Filter:=Format('FakturaId = %d',[Value]);
            FakturaData.Filtered:=True;
          except
            on exception do
            Begin
              Fakturadata.filtered:=False;
              fakturadata.filter:='';
              Raise;
            end;
          end;

        end else
        Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,
        [FakturaData.TableName]);
      end;
      //end else
      //Raise Exception.Create(TEXT_DATASTORENOTACTIVE);
    end;
  end;

  Function TAppData.GotoRecord(Table:TVolgaTable;Id:Integer;
           out OldRecNo:Integer):Boolean;
  var
    FField: TField;
  Begin
    (* default to negative *)
    result:=False;
    OldRecNo:=-1;

    (* Check if component can be used *)
    if not (csDestroying in ComponentState) then
    Begin
      (* Check table param *)
      If Table<>NIL then
      Begin
        (* Check datastore state *)
        If DataStoreActive then
        Begin
          (* Check if table is active and ready for use *)
          If DataSetReady(Table) then
          Begin

            (* Remember current position *)
            OldRecNo:=Table.RecNo;

            (* field already selected? *)
            FField:=Table.FindField('id');
            If FField<>NIl then
            Begin
              If FField.AsInteger=Id then
              Begin
                result:=True;
                exit;
              end;
            end;

            (* disable GUI interaction *)
            Table.DisableControls;
            try
              (* Attempt to find record by ID *)
              Result:=Table.Find('id',[Id],True);
              If not result then
              Begin
                If (OldRecNo<>-1)
                and (Table.RecordCount>0) then
                Table.RecNo:=OldRecNo;
              end;
            finally
              (* Enable GUI interaction again *)
              Table.EnableControls;
            end;
          end else
          Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,[Table.TableName]);
        end else
        Raise Exception.Create(TEXT_DATASTORENOTACTIVE);
      end else
      Raise Exception.Create('Goto record failed, table param is NIL');
    end;
  end;
  
  Procedure TAppData.KrediterFaktura;
  var
    FIndex: Integer;
    FId:    Integer;
    FMVA:   Currency;
    FPris:  Currency;
    FTemp:  Currency;
  begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Faktura) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);

    If (fakturastatus.value in [FAKTURA_IKKEFAKTURERT,FAKTURA_KREDITNOTA]) then
    Begin
      If fakturastatus.value=FAKTURA_IKKEFAKTURERT then
      ShowMessage(TEXT_FakturaIkkeFakturert) else
      If fakturastatus.value=FAKTURA_KREDITNOTA then
      ShowMessage(TEXT_FakturaErKreditert);
      exit;
    end;

    { Get ID for current invoice }
    FId:=fakturaid.value;

    { finnes det allerede en kredittnota med dette
      id nummeret? }
    faktura.DisableControls;
    FIndex:=faktura.RecNo;
    try
      If faktura.find('fakturaRef',[FId],True) then
      Begin
        Application.MessageBox
        (
        PChar(TEXT_KREDITTNOTAREGISTRERT),
        PChar(TEXT_KREDITTNOTA),
        MB_OK
        );
        exit;
      end;
    finally
      faktura.recNo:=FIndex;
      faktura.EnableControls;
    end;

    { spørre bruker om de vil utføre handlingen }
    If Application.MessageBox
      (
      PChar(TEXT_QUERYKREDITTNOTA),
      PChar(TEXT_KREDITTNOTA),
      MB_YESNO or MB_ICONQUESTION
      )=IDNO then
    exit;

    (* calculate MVA og pris i kroner og øre *)
    FMva:=FakturaPris.Value - FakturaData.GetSum('eksmva');
    FPris:=FakturaTotal.Value;

    { sette status til betalt på kilde faktura }
    try
      faktura.Edit;
      FakturaStatus.AsInteger:=FAKTURA_BETALT;
      faktura.post;
      faktura.ApplyUpdates;
      faktura.CommitUpdates;
    except
      on e: exception do
      ErrorDialog(ClassName,'KrediterFaktura()',e.message);
    end;

    { copy Faktura & Faktura data }
    try
      CopyFaktura(True);
    except
      on e: exception do
      begin
        ErrorDialog(ClassName,'KrediterFaktura()',e.message);
        exit;
      End;
    end;

    { Switch to edit mode and set ref and kreditnota status }
    try
      Faktura.Edit;
      FakturaStatus.AsInteger:=FAKTURA_KREDITNOTA;
      FakturaFakturaRef.AsInteger:=FId;
      FakturaTekst.AsString:=Prefs.ReadString(PREFS_KREDITTERETEXT);
      Faktura.Post;
      Faktura.ApplyUpdates;
      Faktura.CommitUpdates;
    except
      on exception do
      raise Exception.CreateFmt(TEXT_DataError,['KrediterFaktura()']);
    end;

    (* update omsetting *)
    FTemp:=Prefs.ReadCurrency(PREFS_LASTOMSETTING) - FPris;
    Prefs.WriteCurrency(PREFS_LASTOMSETTING,FTemp);

    (* update mva *)
    FTemp:=Prefs.ReadCurrency(PREFS_LASTMVA) - FMva;
    Prefs.WriteCurrency(PREFS_LASTMVA,FTemp);

    UpdatePrefs;

    { switch on filtering again }
    FilterFakturaDataById(FakturaId.Value);

    (* present message *)
    DataStoreMessage('Faktura #' + IntToStr(FId) + ' er kredittert.');
  End;

  Procedure TAppData.PurrFaktura;
  var
    FText:  String;
    FTemp:  Currency;
  Begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Faktura) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);

    If (fakturastatus.value in [FAKTURA_IKKEFAKTURERT,FAKTURA_KREDITNOTA]) then
    Begin
      If fakturastatus.value=FAKTURA_IKKEFAKTURERT then
      ShowMessage(TEXT_FakturaIkkeFakturert) else
      If fakturastatus.value=FAKTURA_KREDITNOTA then
      ShowMessage(TEXT_FakturaErKreditert);
      exit;
    end;

    { Er ikke fakturaen forfallt? }
    if fakturaforfallt.value=False then
    Begin
      ShowMessage(TEXT_FakturaIkkeForfallt);
      exit;
    End;

    { Presentere spørsmåls dialog }
    FText:=Format(TEXT_QUERYPURRING,[FakturaPurringer.value + 1]);
    If Application.MessageBox
      (
      PChar(FText),
      PChar(Text_Purring),
      MB_YESNO or MB_ICONQUESTION
      )=IDNO then
    exit;

    (* ta bort tidligere renter fra omsettingen *)
    If GetPurringer>0 then
    Begin
      FTemp:=Prefs.ReadCurrency(PREFS_LASTOMSETTING) - GetRenterValue;
      Prefs.WriteCurrency(PREFS_LASTOMSETTING,FTemp);
    end;

    (* sette purring *)
    try
      Faktura.Edit;
      FakturaPurreDato.AsDateTime:=Now;
      FakturaPurringer.AsInteger:=FakturaPurringer.AsInteger + 1;
      FakturaTekst.AsString:=Prefs.ReadString(PREFS_PURRETEXT);
      Faktura.Post;
      Faktura.ApplyUpdates;
      Faktura.CommitUpdates;
    except
      on exception do
      raise Exception.CreateFmt(TEXT_DataError,['PurrFaktura()']);
    end;

    (* Legge til purregebyr, samt ny rente *)
    FTemp:=Prefs.ReadCurrency(PREFS_LASTOMSETTING) + Prefs.ReadInteger(PREFS_PURREGEBYR);
    FTemp:=FTemp + GetRenterValue;
    Prefs.WriteCurrency(PREFS_LASTOMSETTING,FTemp);
    UpdatePrefs;
  End;

  Procedure TAppData.BetalFaktura;
  var
    FOldTotal:  Currency;
    FTemp:      Currency;
    FIndex:     Integer;
    FText:      String;
    FPayForm:   TfrmBetale;
  Begin
    (* Check datastore *)
    If DataStoreActive then
    Begin
      (* Check ready state on dataset *)
      If DataSetReady(Faktura) then
      Begin

        (* check for status in our invcoice *)
        If (fakturastatus.value in [FAKTURA_IKKEFAKTURERT,
        FAKTURA_BETALT,FAKTURA_KREDITNOTA]) then
        Begin
          Case fakturastatus.value of
          FAKTURA_IKKEFAKTURERT:  FText:=TEXT_FakturaIkkeFakturert;
          FAKTURA_BETALT:         FText:=TEXT_FakturaErBetalt;
          FAKTURA_KREDITNOTA:     FText:=TEXT_FakturaErKreditert;
          end;
          ShowMessage(FText);
          exit;
        end;

        { Kan ikke betale hvis det finnes en kreditnota
          registrert på denne fakturaen. }
        Faktura.DisableControls;
        FIndex:=faktura.RecNo;
        try
          If faktura.find('fakturaRef',[FakturaId.Value],True) then
          Begin
            Application.MessageBox(PChar(TEXT_KANIKKEBETALE),
            PChar(TEXT_BETALING),MB_OK);
            exit;
          end;
        finally
          faktura.recNo:=FIndex;
          faktura.EnableControls;
        end;

        (* get current sub-total *)
        FOldTotal:=FakturaTotal.Value;

        (* display payment dialog *)
        FPayForm:=TfrmBetale.Create(self);
        try
          If FPayform.ShowModal=mrCancel then
          exit;
        finally
          FreeAndNIL(FPayForm);
        end;

        (* pay the invoice *)
        try
          Faktura.Edit;
          FakturaStatus.AsInteger:=FAKTURA_BETALT;
          FakturaForfallt.AsBoolean:=False;
          Faktura.post;
          Faktura.ApplyUpdates;
          Faktura.CommitUpdates;
        finally
          FTemp:=Prefs.ReadCurrency(PREFS_LASTOMSETTING) - FOldTotal;
          FTemp:=FTemp + FakturaTotal.Value;
          Prefs.WriteCurrency(PREFS_LASTOMSETTING,FTemp);
          UpdatePrefs;
        end;

      end else
      Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);
    end else
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE)
  end;

  Procedure TAppData.VarsleFaktura;
  var
    FText:  String;
    FTemp:  Currency;
  Begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Faktura) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);

    If (fakturastatus.value in [FAKTURA_IKKEFAKTURERT,FAKTURA_KREDITNOTA]) then
    Begin
      If fakturastatus.value=FAKTURA_IKKEFAKTURERT then
      ShowMessage(TEXT_FakturaIkkeFakturert) else
      If fakturastatus.value=FAKTURA_KREDITNOTA then
      ShowMessage(TEXT_FakturaErKreditert);
      exit;
    end;

    { Er ikke fakturaen forfallt? }
    if fakturaforfallt.value=False then
    Begin
      ShowMessage(TEXT_FakturaIkkeForfallt);
      exit;
    End;

    { Presentere spørsmåls dialog }
    FText:=Format(TEXT_QUERYINKASSO,[FakturaVarsel.Value + 1]);
    If Application.MessageBox
      (
      PChar(FText),
      PChar(TEXT_VARSEL),
      MB_YESNO or MB_ICONQUESTION
      )=IDNO then
    exit;

    (* ta bort tidligere renter fra omsettingen *)
    If GetPurringer>0 then
    Begin
      FTemp:=Prefs.ReadCurrency(PREFS_LASTOMSETTING) - GetRenterValue;
      Prefs.WriteCurrency(PREFS_LASTOMSETTING,FTemp);
    end;

    (* sette purring *)
    try
      Faktura.Edit;
      FakturaPurreDato.AsDateTime:=Now;
      FakturaVarsel.AsInteger:=FakturaVarsel.AsInteger + 1;
      FakturaTekst.AsString:=Prefs.ReadString(PREFS_PURRETEXT);
      Faktura.Post;
      Faktura.ApplyUpdates;
      Faktura.CommitUpdates;
    except
      on exception do
      raise Exception.CreateFmt(TEXT_DataError,['PurrFaktura()']);
    end;

    (* Legge til purregebyr, samt ny rente *)
    FTemp:=Prefs.ReadCurrency(PREFS_LASTOMSETTING) + Prefs.ReadInteger(PREFS_PURREGEBYR);
    FTemp:=FTemp + GetRenterValue;
    Prefs.WriteCurrency(PREFS_LASTOMSETTING,FTemp);
    UpdatePrefs;
  End;

  //############################################################
  // Bussiness Rules for leverandør data
  //############################################################

  procedure TAppData.LeverandorerNewRecord(DataSet: TDataSet);
  begin
    { Sette ny ID på ny leverandør }
    LeverandorerId.AsInteger:=Prefs.ReadInteger(PREFS_LEVERANDORID);
    LeverandorerFirma.AsString:='Ny leverandør';
  end;

  procedure TAppData.LeverandorerBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    (* Check that this is a new record *)
    If leverandorer.State=dsInsert then
    Begin
      (* update ID number *)
      FValue:=Prefs.ReadInteger(PREFS_LEVERANDORID) + 1;
      Prefs.WriteInteger(PREFS_LEVERANDORID,FValue);

      (* update prefs on disk *)
      UpdatePrefs;
    end;
  end;

  Procedure TAppData.CopyLeverandor;
  var
    FValue: Integer;
  Begin
    If DataStoreActive then
    Begin
      if DataSetReady(Leverandorer) then
      Begin

        (* get current ID *)
        FValue:=Prefs.ReadInteger(PREFS_LEVERANDORID);

        try
          try
            Leverandorer.CopyRecord;
            LeverandorerId.AsInteger:=FValue;
            Leverandorer.Post;
            Leverandorer.ApplyUpdates;
            Leverandorer.CommitUpdates;
          except
            on exception do
            raise Exception.CreateFmt(TEXT_DataError,['CopyLeverandor()']);
          end;
        finally
          inc(FValue);
          Prefs.WriteInteger(PREFS_LEVERANDORID,FValue);
        end;
      end else
      Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Leverandør']);
    end else
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE)
  End;

  Procedure TAppData.DeleteLeverandor;
  begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Leverandorer) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Leverandør']);

    { Any products assigned to this leverandør? }
    If Produkter.find('LeverandorId',[LeverandorerId.Value],True) then
    Begin
      Application.MessageBox
        (
        PChar(TEXT_QUERYDELETELEVERANDOR),
        PChar(TEXT_SLETTELEVERANDOR),
        MB_OK or MB_ICONEXCLAMATION
        );
      exit;
    End;

    { Attempt to delete the leverandør }
    try
      Leverandorer.Delete;
      Leverandorer.ApplyUpdates;
      Leverandorer.CommitUpdates;
    except
      on exception do
      raise Exception.CreateFmt(TEXT_DataError,['DeleteLeverandor()']);
    end;
  End;

  //############################################################
  // Bussiness Rules for produkt data
  //############################################################

  procedure TAppData.ProdukterNewRecord(DataSet: TDataSet);
  begin
    ProdukterId.AsInteger:=Prefs.ReadInteger(PREFS_PRODUKTID);
    ProdukterTittel.AsString:='Nytt produkt';
  end;

  procedure TAppData.ProdukterBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    { oppdatere produkt-id for neste produkt }
    If produkter.State=dsInsert then
    begin
      FValue:=Prefs.ReadInteger(PREFS_PRODUKTID) + 1;
      Prefs.WriteInteger(PREFS_PRODUKTID,FValue);
      UpdatePrefs;
    end;
  end;

  Procedure TAppData.CopyProdukt;
  var
    FValue: Integer;
  begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Produkter) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Produkt']);

    FValue:=Prefs.ReadInteger(PREFS_PRODUKTID);

    try
      try
        Produkter.CopyRecord;
        ProdukterId.AsInteger:=FValue;
        Produkter.Post;
        Produkter.ApplyUpdates;
        Produkter.CommitUpdates;
      except
        on exception do
        raise Exception.CreateFmt(TEXT_DataError,['CopyProdukt()']);
      end;
    finally
      inc(FValue);
      Prefs.WriteInteger(PREFS_PRODUKTID,FValue);
    end;
  End;

  Procedure TAppData.DeleteProdukt;
  Begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Produkter) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Produkt']);

    try
      Produkter.Delete;
      Produkter.ApplyUpdates;
      Produkter.CommitUpdates;
    except
      on exception do
      raise Exception.CreateFmt(TEXT_DataError,['DeleteProdukt()']);
    end;
  End;

  //############################################################
  // Bussiness Rules for faktura
  //############################################################

  procedure TAppData.FakturaNewRecord(DataSet: TDataSet);
  begin
    { Sette ny ID på ny faktura }
    FakturaId.AsInteger:=Prefs.ReadInteger(PREFS_FAKTURAID);
    FakturaDato.AsDateTime:=Now;
    FakturaBetalingsfrist.AsInteger:=30;
    FakturaRenteSats.AsFloat:=Prefs.ReadInteger(PREFS_RENTESATS);//  globalvalues.GetProsentSats;
    FakturaGebyr.AsCurrency:=Prefs.ReadInteger(PREFS_PURREGEBYR);//GlobalValues.GetPurreGebyr;
    FakturaDinRef.AsString:=Prefs.ReadString(PREFS_REFERANSE_NAVN);//GlobalValues.GetReferanseText;
    FakturaTekst.AsString:=Prefs.ReadString(PREFS_FAKTURATEXT);//GlobalValues.GetFakturaText;
  end;

  procedure TAppData.FakturaBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    { oppdatere register faktura id for neste faktura }
    If faktura.State=dsInsert then
    Begin
      FValue:=Prefs.ReadInteger(PREFS_FAKTURAID) + 1;
      Prefs.WriteInteger(PREFS_FAKTURAID,FValue);
      UpdatePrefs;
    end;
  end;

  procedure TAppData.FakturaAfterScroll(DataSet: TDataSet);
  begin
    { filtrer fakturadata kun til å vise info rellatert
      til aktive faktura }
    FilterFakturaDataById(FakturaId.Value);
  end;

  Function TAppData.DataSetReady(Dataset:TVolgaTable;
            Const MustHaveRecord:Boolean=True):Boolean;
  Begin
    result:=FActive
    and (Dataset<>NIL)
    and (Dataset.Active);
    if result and MustHaveRecord then
    result:=Dataset.RecordCount>0;
  end;

  Procedure TAppData.CopyFaktura(KeepHistory:Boolean);

  Type
    TFakturaDataRecord = Record
      Produkt:    String[128];
      Antall:     Double;
      Pris:       Currency;
      Mva:        Integer;
      Rabatt:     Integer;
      EksMva:     Currency;
      InkMva:     Currency;
    End;

  var
    x:  Integer;
    FItems: Array of TFakturaDataRecord;
  begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Faktura) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']) else
    if not DataSetReady(FakturaData) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Fakturadata']);

    (* query user to proceed *)
    If application.MessageBox('Kopiere faktura?','Raptor Faktura',
    MB_YESNO	or MB_ICONQUESTION)<>ID_YES then
    exit;

    (* Get all fakturadata items *)
    SetLength(FItems,Fakturadata.RecordCount);
    x:=0;
    FakturaData.First;
    While not FakturaData.EOF do
    begin
      With FItems[x] do
      Begin
        Produkt:=FakturaDataProdukt.Value;
        Antall:=FakturaDataAntall.value;
        Pris:=FakturaDataPris.Value;
        Mva:=FakturaDataMva.Value;
        Rabatt:=FakturaDataRabatt.Value;
        EksMva:=FakturaDataEksMva.Value;
        InkMva:=FakturaDataInkMva.Value;
      end;
      inc(x);
      FakturaData.Next;
    end;

    { copy the invoice }
    DataStoreMessage('Kopierer faktura..');
    try
      Faktura.CopyRecord;
      FakturaStatus.AsInteger:=FAKTURA_IKKEFAKTURERT;
      If not KeepHistory then
      Begin
      end;

      faktura.Edit;
      FakturaVarsel.AsInteger:=0;
      FakturaPurringer.AsInteger:=0;
      FakturaFakturaRef.AsInteger:=0;
      FakturaPurredato.AsDateTime:=0;
      FakturaForfall.AsDateTime:=0;
      FakturaForfallt.AsBoolean:=False;
      FakturaDato.AsDateTime:=Now;
      FakturaId.AsInteger:=Prefs.ReadInteger(PREFS_FAKTURAID);
      Faktura.Post;
      Faktura.ApplyUpdates;
      Faktura.CommitUpdates;
    except
      on exception do
      Begin
        raise Exception.CreateFmt(TEXT_DataError,['CopyFaktura()']);
        exit;
      end;
    end;
    
    (* remove filtering for a moment *)
    FakturaData.Filtered:=False;
    FakturaData.Filter:='';

    (* store the fakturadata items under the new faktura *)
    try
      try
        for x:=Low(FItems) to High(FItems) do
        Begin
          FakturaData.Append;
          FakturaDataFakturaId.AsInteger:=FakturaId.AsInteger;
          FakturaDataProdukt.AsString:=FItems[x].Produkt;
          FakturaDataAntall.AsFloat:=FItems[x].Antall;
          FakturaDataPris.AsCurrency:=FItems[x].Pris;
          FakturaDataMva.AsInteger:=FItems[x].Mva;
          FakturaDataRabatt.AsInteger:=FItems[x].Rabatt;
          FakturaDataEksMva.AsCurrency:=FItems[x].EksMva;
          FakturaDataInkMva.AsCurrency:=FItems[x].InkMva;
          FakturaData.Post;
        end;
        FakturaData.ApplyUpdates;
        FakturaData.CommitUpdates;
      except
        on exception do
        raise Exception.CreateFmt(TEXT_DataError,['CopyFaktura()']);
      end;
    finally
      (* activate filtering again *)
      FilterFakturaDataById(FakturaId.Value);
    end;

    DataStoreMessage('Faktura kopiert.');
  End;

  //############################################################
  // Bussiness Rules for Kunder
  //############################################################

  procedure TAppData.KunderNewRecord(DataSet: TDataSet);
  begin
    { Sette ny ID på ny kunde }
    KunderId.AsInteger:=Prefs.ReadInteger(PREFS_KUNDEID);//GetKundeId;
    KunderGruppe.AsInteger:=1;
    KunderFirma.AsString:='Ny kunde';
  end;

  procedure TAppData.KunderBeforePost(DataSet: TDataSet);
  var
    FValue: Integer;
  begin
    If kunder.state=dsInsert then
    Begin
      FValue:=Prefs.ReadInteger(PREFS_KUNDEID) + 1;
      Prefs.WriteInteger(PREFS_KUNDEID,FValue);
      UpdatePrefs;
    end;
  end;

  Procedure TAppData.CopyKundeGruppe;
  Begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(KundeGrupper) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Kundegruppe']);

    try
      Kundegrupper.CopyRecord;
      Kundegrupper.Post;
      Kundegrupper.ApplyUpdates;
      Kundegrupper.CommitUpdates;
    except
      on e: exception do
      setLastError('data','CopyKundeGruppe()',e.message);
    end;
  end;

  Procedure TAppData.CopyKunde;
  var
    FValue: Integer;
  Begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Kunder) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Kunde']);

    (* get current customer id *)
    FValue:=Prefs.ReadInteger(PREFS_KUNDEID);

    try
      try
        Kunder.CopyRecord;
        KunderId.AsInteger:=FValue;
        Kunder.Post;
        Kunder.ApplyUpdates;
        Kunder.CommitUpdates;
      except
        on e: exception do
        SetLastError('data','CopyKunde()',e.Message);
      end;
    finally
      inc(FValue);
      Prefs.WriteInteger(PREFS_KUNDEID,FValue);
    end;
  End;

  Procedure TAppData.DeleteKunde;
  Begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Kunder) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Kunde']);

    try
      Kunder.Delete;
      Kunder.ApplyUpdates;
      Kunder.CommitUpdates;
    except
      on e: exception do
      SetLastError('data','DeleteKunde()',e.message);
    end;
  End;

  Procedure TAppData.DeleteKundeGruppe;
  Begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(KundeGrupper) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['KundeGruppe']);

    If KundeGrupperId.Value=1 then
    Begin
      ShowMessage(CNT_DATASTORE_ERROR_NOTDELETECUSTOMERGROUP);
      exit;
    end;

    try
      Kundegrupper.Delete;
      Kundegrupper.ApplyUpdates;
      Kundegrupper.CommitUpdates;
    except
      on e: exception do
      SetLastError('data','DeleteKundeGruppe',e.message);
    end;
  end;

  //############################################################
  // Bussiness Rules for Produkter
  //############################################################

  procedure TAppData.ProdukterCalcFields(DataSet: TDataSet);
  begin
    (* kalkulere avanse *)
    if (ProdukterAvanse.AsInteger in [0..3]) then
    Begin
      ProdukterUtPris.AsCurrency:=
      (ProdukterInnPris.AsCurrency * FAvanser[ProdukterAvanse.AsInteger]);
    end;
  end;

  procedure TAppData.ProdukterAvanseChange(Sender: TField);
  begin
    if (ProdukterAvanse.AsInteger in [0..3]) then
    Begin
      ProdukterUtPris.AsCurrency:=
      (ProdukterInnPris.AsCurrency * FAvanser[ProdukterAvanse.AsInteger]);
    end;
  end;

  procedure TAppData.ProdukterLeverandorIdGetText(Sender: TField;
            var Text: String; DisplayText: Boolean);
  begin
    If Leverandorer.Active
    and (Leverandorer.RecordCount>0) then
    Begin
      If Leverandorer.find('Id',[Sender.asInteger],True) then
      Text:=LeverandorerFirma.Value;
    end;
  end;

  procedure TAppData.FakturaStatusGetText(Sender: TField; var Text: String;DisplayText: Boolean);
  begin
    If  Faktura.Active
    and (Faktura.RecordCount>0) then
    Text:=StatusToStr(Sender.asInteger);
  end;

  procedure TAppData.FakturaForfalltGetText(Sender: TField; var Text: String;DisplayText: Boolean);
  begin
    If  Faktura.Active
    and (Faktura.RecordCount>0) then
    Begin
      Text:='Nei';
      If FakturaStatus.Value<>FAKTURA_BETALT then
      Begin
        If sender.asBoolean then
        Text:='Ja';
      end;
    end;
  end;

  procedure TAppData.FakturaForfallGetText(Sender: TField; var Text: String;DisplayText: Boolean);
  begin
    If  Faktura.Active
    and (Faktura.RecordCount>0) then
    Text:=DateToStr(FakturaDato.Value + FakturaBetalingsfrist.Value);
  end;

  procedure TAppData.FakturaDatoGetText(Sender: TField; var Text:String;
            DisplayText: Boolean);
  begin
    If  Faktura.Active
    and (Faktura.RecordCount>0) then
    Text:=DateToStr(FakturaDato.Value);
  end;

  procedure TAppData.KunderGruppeGetText(Sender: TField; var Text:String;
            DisplayText: Boolean);
  var
    FOldRec:  Integer;
  begin
    If KundeGrupper.Active then
    Begin
      FOldRec:=Kundegrupper.RecNo;
      KundeGrupper.DisableControls;
      try
        If KundeGrupper.find('id',[sender.asInteger],True) then
        Text:=KundeGrupperTittel.Value;
      finally
        Kundegrupper.RecNo:=FOldRec;
        KundeGrupper.EnableControls;
      end;
    end;
  end;

  procedure TAppData.KundeGrupperRabattGetText(Sender: TField; var Text:String;
            DisplayText: Boolean);
  begin
    If KundeGrupper.Active then
    Text:=(Sender.asString + '%');
  end;

  procedure TAppData.KundeGrupperAktivGetText(Sender: TField;var Text:String;
            DisplayText: Boolean);
  begin
    If KundeGrupper.Active then
    If Sender.asBoolean then
    Text:='Ja' else
    Text:='Nei';
  end;

  procedure TAppData.KundeGrupperNewRecord(DataSet: TDataSet);
  begin
    KundeGrupperAktiv.AsBoolean:=True;
    KundeGrupperTittel.AsString:='Ny kundegruppe';
  end;

  procedure TAppData.FakturaCalcFields(DataSet: TDataSet);
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

  Procedure TAppData.PrintActiveInvoice(Copies:Integer=1);
  var
    FForm:  TfrmFakturaReport;
  Begin
    (* check that we can do this *)
    if Copies>0 then
    Begin
      If DataStoreActive then
      Begin
        if DataSetReady(Faktura)
        and DataSetReady(Fakturadata) then
        Begin
          FForm:=TfrmFakturaReport.Create(self);
          try
            FForm.Fakturareport.PrinterSetup.Copies:=Copies;
            FForm.FakturaReport.ShowPrintDialog:=False;
            FForm.Reportviewer.Report:=FForm.FakturaReport;
            FForm.ReportViewer.RegenerateReport;
            FForm.ReportViewer.Print;
          finally
            FreeAndNIL(FForm);
          end;
        end else
        Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);
      end else
      Raise Exception.Create(TEXT_DATASTORENOTACTIVE)
    end;
  end;
  
  Procedure TAppData.Fakturere(Dato:TDateTime;Pages:Integer);
  var
    FTotal:   Currency;
    FMva:     Currency;
    FTemp:    Currency;
    FNavn:    String;
  begin
    If DataStoreActive then
    Begin
      If DataSetReady(Faktura) then
      Begin

        { Get total price and klient name }
        FTotal:=FakturaPris.Value;
        FMva:=FTotal-FakturaData.GetSum('eksmva');
        FNavn:=FakturaKunde.Value;

        try
          Faktura.Edit;
          FakturaStatus.AsInteger:=FAKTURA_FAKTURERT;
          FakturaDato.AsDateTime:=Dato;
          Faktura.Post;
          Faktura.ApplyUpdates;
          Faktura.CommitUpdates;
        except
          on e: exception do
          ErrorDialog(ClassName,'Fakturer()',e.message);
        end;

        (* oppdatere kundesalg *)
        try
          If Kunder.find('firma',[FNavn],true) then
          Begin
            Kunder.Edit;
            KunderSalg.AsCurrency:=KunderSalg.AsCurrency + FTotal;
            Kunder.Post;
            Kunder.Applyupdates;
            kunder.CommitUpdates;
          end;
        except
          on e: exception do
          ErrorDialog(ClassName,'DoFakturerExecute()',e.message);
        end;

        { Utskrift? }
        if Pages>0 then
        PrintActiveInvoice(Pages);

        (* oppdatere omsettings tall *)
        FTemp:=Prefs.ReadCurrency(PREFS_LASTOMSETTING);
        FTemp:=FTemp + FTotal;
        Prefs.WriteCurrency(PREFS_LASTOMSETTING,FTemp);

        (* oppdatere MVA tall *)
        FTemp:=Prefs.ReadCurrency(PREFS_LASTMVA);
        FTemp:=FTemp + FMva;
        Prefs.WriteCurrency(PREFS_LASTMVA,FTemp);

      end else
      Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);
    end else
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE);
  End;

  procedure TAppData.Fakturer;
  var
    FDato:  TDateTime;
  begin
    (* check that we can do this *)
    If (DataStoreActive=False) then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE) else
    if not DataSetReady(Faktura) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);

    With TfrmFakturer.Create(self) do
    Begin
      FDato:=FakturaDato.Value;
      try
        If ShowModal=mrOK then
        Begin
          If nSetDato.Checked then
          FDato:=nDato.Date;
          If nUtskrift.Checked then
          Fakturere(FDato,nEksemplarer.value) else
          Fakturere(FDato,0);
          DataStoreUpdate;
        end;
      finally
        Free;
      end;
    End;
  end;

  Procedure TAppData.FakturerAlle;
  var
    x:        Integer;
    FIndex:   Integer;
    FDato:    TDateTime;
    FPages:   Integer;
  begin
    (* Check datastore status *)
    If DataStoreActive=False then
    Raise Exception.Create(TEXT_DATASTORENOTACTIVE);

    (* Check dataset ready *)
    if not DataSetReady(Faktura) then
    Raise Exception.CreateFmt(TEXT_DATATABLENOTREADY,['Faktura']);

    (* save current invoice date *)
    FDato:=FakturaDato.Value;

    { fakturere alle vindue vises }
    With TfrmFakturerAlle.Create(self) do
    Begin
      try
        If ShowModal=mrOK then
        Begin
          If nSetDato.Checked then
          FDato:=nDato.Date;
          if nUtskrift.Checked then
          FPages:=nEksemplarer.Value else
          FPages:=0;
        end else
        exit;
      finally
        free;
      end;
    End;

    x:=0;
    FIndex:=Faktura.RecNo;
    Faktura.DisableControls;
    Faktura.First;

    DataStoreProcessBegins(Faktura.RecordCount);
    DataStoreMessage(CNT_DATASTORE_MESSAGE_ANALYZINGDB);

    try
      While not Faktura.Eof do
      Begin
        DataStoreProcessUpdate(Faktura.RecNo,Faktura.RecordCount);

        If FakturaStatus.Value<>FAKTURA_IKKEFAKTURERT then
        Begin
          Faktura.next;
          Continue;
        End;

        try
          Fakturere(FDato,FPages);
          inc(x);
        except
          on e: exception do
          SetLastError('data','FakturerAlle()',e.message);
        end;
        Faktura.Next;
      End;

    finally
      If (x<1) then
      DataStoreMessage(CNT_DATASTORE_MESSAGE_NOINVOICETOPROCESS) else
      DataStoreMessage(Format(CNT_DATASTORE_MESSAGE_NRINVOICEDPROCESSED,[x]));
      DataStoreProcessDone;
      Faktura.RecNo:=FIndex;
      Faktura.EnableControls;
    end;
  end;

end.
