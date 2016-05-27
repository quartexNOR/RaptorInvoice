  unit globalvalues;

  interface

  uses Forms, Windows, sysutils, Classes, contnrs, dateutils,
  comobj, shellapi, ShlObj, FileCtrl, db, jlcommon;

  Const

  Application_Firm        = 'Fuerza Development';
  Application_Name        = Application_Firm + ' - Torro';
  Application_Title       = Application_Name + ' Faktura';

  GROUP_ALLE              = 0;
  GROUP_LEVERANDORER      = 1;
  GROUP_PRODUKTER         = 2;
  GROUP_KUNDER            = 3;
  GROUP_FAKTURA           = 4;

  FAKTURA_IKKEFAKTURERT   = 0;
  FAKTURA_FAKTURERT       = 1;
  FAKTURA_KREDITNOTA      = 2;
  FAKTURA_BETALT          = 3;

  PREFS_FAKTURAID         = 'fakturaid';
  PREFS_KUNDEID           = 'kundeid';
  PREFS_LEVERANDORID      = 'leverandorid';
  PREFS_PRODUKTID         = 'produktid';
  PREFS_FIRMA             = 'firmanavn';
  PREFS_ADRESSE_A         = 'firma_adresse_a';
  PREFS_ADRESSE_B         = 'firma_adresse_b';
  PREFS_POSTNR            = 'firma_postnummer';
  PREFS_STED              = 'firma_sted';
  PREFS_TELEFON           = 'firma_telefon';
  PREFS_FAX               = 'firma_fax';
  PREFS_EMAIL             = 'firma_email';
  PREFS_WWW               = 'firma_web';
  PREFS_ORGID             = 'firma_orgid';
  PREFS_KONTIE            = 'firma_kontie';
  PREFS_FAKTURATEXT       = 'firma_faktura_text';
  PREFS_PURRETEXT         = 'firma_purring_text';
  PREFS_INKASSOTEXT       = 'firma_inkasso_text';
  PREFS_KREDITTERETEXT    = 'firma_kredittere_text';
  PREFS_PURREGEBYR        = 'firma_purregebyr';
  PREFS_RENTESATS         = 'firma_rentesats';
  PREFS_REFERANSE_NAVN    = 'firma_referanse_navn';
  PREFS_AVANSE            = 'app_avanse_option';
  PREFS_MVA               = 'app_mva_option';
  PREFS_LASTRUN           = 'app_run_last';
  PREFS_ROWSELECT         = 'app_rowselect_option';
  PREFS_LASTOMSETTING     = 'firma_omsetting';
  PREFS_LASTMVA           = 'firma_mva';
  PREFS_LASTRABATT        = 'firma_rabatt';

  DEFAULT_FAKTURA_NUMBER    = 1001;
  DEFAULT_KUNDE_NUMBER      = 1001;
  DEFAULT_LEVERANDOR_NUMBER = 1001;
  DEFAULT_PRODUKT_NUMBER    = 1001;


  Const
  ERR_HEX_FailedReadProperty  = 'Failed to read property: %s';
  ERR_HEX_FailedWriteProperty = 'Failed to write property: %s';

  type

  TJLPropertyBag = Class(TObject)
  Private
    FData:      TStringlist;
    Function    EncodeValue(Value:String):String;
    Function    DecodeValue(Value:String):String;
    Function    GetEmpty:Boolean;
    Function    GetCount:Integer;
    Function    GetValue(index:Integer):String;
    Function    BinStreamToString(Stream:TStream):String;
    Function    BinStringToStream(Value:String):TStream;
    Function    ConvertToBinString(Value:String):String;
    Function    ConvertFromBinString(Value:String):String;
  Public
    Property    Empty:Boolean read GetEmpty;
    Property    Count:Integer read GetCount;
    Property    Properties[index:Integer]:String read GetValue;

    Procedure   WriteCurrency(AName:String;Value:Currency);
    Function    ReadCurrency(AName:String):Currency;

    Procedure   WriteBoolean(AName:String;Value:Boolean);
    Procedure   WriteInteger(AName:String;Value:Integer);
    Procedure   WriteString(AName:String;Value:String);
    Procedure   WriteDate(AName:String;Value:TDateTime);
    Procedure   WriteStream(AName:String;Value:TStream);

    Function    ReadStream(AName:String):TStream;
    Function    ReadDate(AName:String):TDateTime;
    Function    ReadInteger(AName:String):Integer;
    Function    ReadBoolean(AName:String):Boolean;
    Function    ReadString(AName:String):String;

    Function    ToString:String;
    Procedure   SaveToStream(Stream:TStream);
    Procedure   SaveToFile(Const Filename:String);
    Procedure   LoadFromFile(Const Filename:String);
    Procedure   LoadFromStream(Stream:TStream);
    //Procedure   SaveToRegistry(Key:HKey;Path,KeyName:String);
    //Procedure   LoadFromRegistry(Key:HKey;Path,KeyName:String);
    Procedure   AssignTo(Target:TJLPropertyBag);
    Procedure   Clear;
    Constructor Create;Virtual;
    Destructor  Destroy;Override;
  End;

  TJLInvoice      = Class;
  TJLInvoiceItems = Class;

  TJLInvoiceItem = Class(TObject)
  private
    FProduct:   String;
    FItems:     Double;
    FPrice:     Currency;
    FVat:       Integer;
    FDiscount:  Integer;
    FExVat:     Currency;
    FIncVat:    Currency;
    FUpdating:  Integer;
    FParent:    TJLInvoiceItems;
  Protected
    Function    GetUpdating:Boolean;
    Procedure   SetCount(Value:Double);
    Procedure   SetPrice(Value:Currency);
    Procedure   SetVat(Value:Integer);
    Procedure   SetDiscount(Value:Integer);
    Procedure   SetProduct(Value:String);
    Function    GetVatOnly:Currency;
  Public
    Property    Parent:TJLInvoiceItems read FParent;
    Property    Product:String read FProduct write SetProduct;
    Property    Count:Double read FItems write SetCount;
    Property    ItemPrice:Currency read FPrice write SetPrice;
    property    Vat:Integer read FVat write SetVat;
    Property    Discount:Integer read FDiscount write SetDiscount;
    Property    SumExVat:Currency read FExVat write FExVat;
    Property    SumIncVat:Currency read FIncVat write FIncVat;
    Property    SumVatOnly:Currency read GetVatOnly;
    Procedure   BeginUpdate;
    Procedure   EndUpdate;
    Procedure   UpdateFinalFigures;
    Function    toString:String;
    Constructor Create(AOwner:TJLInvoiceItems);virtual;
  End;

  TJLInvoiceItems = Class(TObject)
  Private
    FParent:    TJLInvoice;
    FObjects:   TObjectList;
    Function    GetCount:Integer;
    Function    GetItem(index:Integer):TJLInvoiceItem;
  Public
    Property    Items[index:Integer]:TJLInvoiceItem read GetItem;default;
    Property    Count:Integer read GetCount;
    Procedure   Clear;
    Function    Add(out Value:TJLInvoiceItem):Boolean;
    Function    toString:String;

    Function    CalcVatOnly:Currency;
    Function    CalcSubTotal(IncVat:Boolean=False):Currency;

    Constructor Create(AOwner:TJLInvoice);virtual;
    Destructor  Destroy;Override;
  End;

  TJLInvoiceAdresse = Class(TObject)
  Private
    FNavn:      String;
    FAddr1:     String;
    FAddr2:     String;
    FSted:      String;
    FStedsNavn: String;
  Public
    Property  Kunde:String read FNavn write FNavn;
    property  Adresse1:String read FAddr1 write FAddr1;
    Property  Adresse2:String read FAddr2 write FAddr2;
    Property  Sted:String read FSted write FSted;
    Property  Stedsnavn:String read FStedsnavn write FStedsnavn;
    Procedure Clear;
    Function  Validate:Boolean;
    Function  toString(aHeader:String=''):String;
  end;

  TJLInvoiceState = (isNotIssued=0,isIssued,isCredited,isPayed);

  TJLInvoice = Class(TObject)
  Private
    FAltered:   Integer;
    FUpdating:  Integer;
    FItems:     TJLInvoiceItems;
    FFaktAddr:  TJLInvoiceAdresse;
    FMotAddr:   TJLInvoiceAdresse;
    Fid:        Integer;
    FFaktDato:  TDateTime;
    FForfdager: Integer;
    FForfallt:  Boolean;
    FState:     TJLInvoiceState;
    FReminders: Integer;
    FWarnings:  Integer;
    FDaysOverDue: Integer;
    FOnChanged: TNotifyEvent;
    FRenteSats: Double;
    FGebyr:     Currency;
    Function    GetDueDate:TDateTime;
  Protected
    Function    GetAltered:Boolean;
    Function    GetUpdating:Boolean;
    Procedure   SetId(Value:Integer);
    Procedure   SetDate(Value:TDateTime);
    Procedure   SetForfallsdager(Value:integer);
    Procedure   SetForfallt(Value:Boolean);
    Procedure   SetState(Value:TJLInvoiceState);
    Procedure   SetReminders(Value:Integer);
    Procedure   SetWarnings(Value:Integer);
    Procedure   SetRentesats(Value:Double);
    procedure   SetGebyr(Value:Currency);
  Protected
    Procedure   SignalInvoiceAltered;virtual;
  Public
    Property    Altered:Boolean read GetAltered;
    Property    Updating:Boolean read GetUpdating;
    Property    Reminders:Integer read FReminders write SetReminders;
    Property    Warnings:Integer read FWarnings write SetWarnings;
    Property    Id:Integer read FId write SetId;
    Property    FakturaDato:TDateTime read FFaktDato write SetDate;
    Property    Forfallsdager:Integer read FForfdager write SetForfallsdager;
    Property    Forfallt:Boolean read FForfallt write SetForfallt;
    Property    State:TJLInvoiceState read FState write SetState;
    Property    Items:TJLInvoiceItems read FItems;
    Property    FakturaAdresse:TJLInvoiceAdresse read FFaktAddr;
    Property    MotakerAdresse:TJLInvoiceAdresse read FMotAddr;

    Property    RenteSats:Double read FRenteSats write SetRenteSats;
    Property    Gebyr:Currency read FGebyr write SetGebyr;

    Property    DaysOverdue:Integer read FDaysOverDue;
    Property    DueDate:TDateTime read GetDueDate;

    Function    Validate:Boolean;
    Function    toString:String;virtual;

    Procedure   BeginUpdate;
    Procedure   EndUpdate;

    Procedure   Update;

    Procedure   Clear;
    Constructor Create;virtual;
    Destructor  Destroy;Override;
  Published
    Property    OnAltered:TNotifyEvent
                read FOnChanged write FOnChanged;
  End;

  Const
  CHARSET_NUMERIC = '0123456789'+#8;

  ResourceString
  TEXT_DATASTORENOTACTIVE         = 'Et register må være åpnet for at denne handlingen skal utføres.';
  TEXT_DATATABLENOTREADY          = 'Kan ikke utføre funksjonen. %s tabellen er ikke klar.';
  //TEXT_PIRACY                     = 'Kjære kunde.'#13#13'Det er funnet et program som brukes til å knekke'#13'koden på lisenser ulovelig aktiv i systemet.'#13#13'Programmet vil nå avsluttes.';
  //TEXT_LICENSEEXPIRED             = 'Kjære kunde.'#13#13'Lisensen for denne utgaven av programmet er'#13'desverre ikke lenger gyldig.'#13#13'Som kunde hos JuraSoft skal du motta regelmessige'#13'oppdateringer i henhold til din lisensavtale.'#13#13'Du vil nå kun ha muligheten til å lese data.';
  //TEXT_WARNING                    = 'Kjære kunde.'#13#13'Det er nå under en måned igjen av tiden hvor'#13'du ikke behøver den obligatoriske serviceavtalen.'#13#13'Hvis du ikke registrerer din serviceavtale'#13'innen %s dager, vil deler av programmet'#13'slutte å fungere.';
  TEXT_FakturaIkkeFakturert       = 'Fakturaen er ikke fakturert';
  TEXT_FakturaErBetalt            = 'Fakturaen er betalt';
  TEXT_FakturaForandreStatus      = 'Er du sikker du vil forandre status på denne fakturaen?'#13#13'Forandre fra %s til %s?';
  TEXT_FakturaErKreditert         = 'Faktura er kreditert';
  TEXT_FakturaIkkeForfallt        = 'Fakturaen er ikke forfallt';
  TEXT_DataError                  = 'En feil oppstod i datamodulen, funksjon %s';
  TEXT_FAKTURASTATE               = 'Kan ikke forandre faktura status:'#13;
  TEXT_PURREFEIL                  = 'Kan ikke utføre purring:'#13;
  TEXT_QUERYPURRING               = 'Er du sikker på at du vil generere purringen?'#13#13'Dette er purring %d.';
  TEXT_QUERYINKASSO               = 'Er du sikker på at du vil generere inkasso varsel?'#13#13'Dette er varsel %d.';
  TEXT_QUERYDELETELEVERANDOR      = 'Du kan ikke slette en leverandør hvor det er'#13'et eller flere produkter registrert!';
  TEXT_SLETTELEVERANDOR           = 'Slette leverandør?';
  TEXT_FAKTURA                    = 'Faktura';
  TEXT_PURRING                    = 'Purring';
  TEXT_VARSEL                     = 'Varsel';
  TEXT_BETALING                   = 'Betale faktura';
  TEXT_KANIKKEBETALE              = 'Det eksisterer en kreditnota for denne fakturaen!'#13'Kan ikke sette status til betalt.';
  //TEXT_RAPTOR                     = 'Raptor faktura';
  TEXT_KREDITTNOTA                = 'Kredittnota';
  TEXT_QUERYKREDITTNOTA           = 'Er du sikker du vil kredittere denne fakturaen?';
  TEXT_KREDITTNOTAREGISTRERT      = 'Det eksisterer allerede en kredittnota for denne fakturaen!';

  DIALOG_KanIkkeOpenDbMappe       = 'Det oppstod problemer med å åpne database mappe:'+#13+'%s';

  DIALOG_FANTIKKEFAKTURATITTEL    = 'Ingen faktura funnet';
  DIALOG_FANTIKKEFAKTURA          = 'Fant ingen faktura i systemet som'#13'har et slikt Id nummer.'#13#10'Husk at du også kan bruke søke funksjonen.';
  DIALOG_FANTIKKEKUNDETITTEL      = 'Ingen kunde funnet';
  DIALOG_FANTIKKEKUNDE            = 'Fant ingen kunde i systemet som'#13'har et slikt Id nummer.'#13#10'Husk at du også kan bruke søke funksjonen.';
  DIALOG_FANTIKKEPRODUKTTITTEL    = 'Ingen produkter funnet';
  DIALOG_FANTIKKEPRODUKT          = 'Fant ingen produkter i systemet som'#13'har et slikt Id nummer.'#13#10'Husk at du også kan bruke søke funksjonen.';
  DIALOG_FANTIKKELEVERANDORTITTEL = 'Ingen leverandør funnet';
  DIALOG_FANTIKKELEVERANDOR       = 'Fant ingen leverandør i systemet som'#13'har et slikt Id nummer.'#13#10'Husk at du også kan bruke søke funksjonen.';

  DIALOG_LEVERANDOR_TOPIC         = 'leverandør';
  DIALOG_LEVERANDOR_TITLEAppend   = 'Ny leverandør';
  DIALOG_LEVERANDOR_TITLEEdit     = 'Redigere leverandør';

  DIALOG_PRODUKT_TOPIC            = 'produkt';
  DIALOG_PRODUKT_TITLEAppend      = 'Nytt produkt';
  DIALOG_PRODUKT_TITLEEdit        = 'Redigere produkt';

  DIALOG_KUNDE_TOPIC              = 'kunde';
  DIALOG_KUNDE_TITLEAppend        = 'Ny kunde';
  DIALOG_KUNDE_TITLEEdit          = 'Redigere kunde';

  DIALOG_FAKTURA_TOPIC            = 'faktura';
  DIALOG_FAKTURA_TITLEAppend      = 'Ny faktura';
  DIALOG_FAKTURA_TITLEEdit        = 'Redigere faktura';

  DIALOG_KUNDEGRUPPE_TOPIC        = 'kunde gruppe';
  DIALOG_KUNDEGRUPPE_TITLEAppend  = 'Ny kunde gruppe';
  DIALOG_KUNDEGRUPPE_TITLEEdit    = 'Redigere kunde gruppe';

  CNT_DATASTORE_MESSAGE_ANALYZINGDB
  = 'Analyserer database..';

  CNT_DATASTORE_MESSAGE_NOINVOICETOPROCESS
  ='Ingen faktura å behandle';

  CNT_DATASTORE_MESSAGE_NRINVOICEDPROCESSED
  ='%d faktura behandlet';

  CNT_DATASTORE_ERROR_NOTDELETECUSTOMERGROUP
  ='Denne kundegruppen kan ikke slettes';


  Type
  //TAppState = Set of (stApplication);
  TAppRecordMode  = (arAppend,arEdit);

  { function  IsLeapYear( nYear: Integer ): Boolean;
  function  MonthDays( nMonth, nYear: Integer ): Integer;
  function  WeekOfYear( dDate: TDateTime ): Integer; }
  //function DaysBetween(const ANow, AThen: TDateTime): Integer;

  Function  StatusToStr(Status:Integer):String;

  function  StatusToPrintStr(Status:Integer):String;
  Procedure ErrorDialog(AForm,AName,ACause:String);

  function GetMyDocumentsPath: string;
  function GetAppDataPath: string;
  Function GetPathForSystem:String;

  Function GetPathForDatabases:String;



    type
    TPercent = 1..100;

  Function PercentOf(PCent:TPercent;Value:Double):Double;


  var
  FFindGroup:   Integer;
  FFindId:      Integer;
  FAvanser:     Array[0..3] of Currency;
  FHeaders:     Array[GROUP_ALLE..GROUP_FAKTURA] of String;
  FHeaderNames: Array[GROUP_LEVERANDORER..GROUP_FAKTURA] of String;

  { Const
  MVA_VALUES: Array[0..3] of Integer = (25,14,8,0);  }

  implementation

  uses data;

  var
  _SeekCharset: String;


  Function PercentOf(PCent:TPercent;Value:Double):Double;
  Begin
    result:=( (Value * PCent) / 100 );
  end;


  //###############################################################
  // TJLInvoice
  //###############################################################

  Constructor TJLInvoice.Create;
  Begin
    inherited Create;
    FItems:=TJLInvoiceItems.Create(self);
    FFaktAddr:=TJLInvoiceAdresse.Create;
    FMotAddr:=TJLInvoiceAdresse.Create;
  end;

  Destructor  TJLInvoice.Destroy;
  Begin
    FreeAndNIL(FItems);
    FreeAndNIL(FFaktAddr);
    FreeAndNIL(FMotAddr);
    inherited;
  end;

  Function TJLInvoice.GetDueDate:TDateTime;
  Begin
    result:=dateutils.IncDay(FFaktDato,FForfdager);
  end;

  Procedure TJLInvoice.Update;
  var
    FDueDate: TDateTime;
  Begin
    FDaysOverDue:=0;
    FForfallt:=False;

    (* Check if this invoice is overdue for payment *)
    if not dateutils.WithinPastDays(Now,FFaktDato,FForfdager) then
    Begin
      (* Mark as forclosed *)
      FForfallt:=True;

      (* Calculate last day of credit *)
      FDueDate:=dateutils.IncDay(FFaktDato,FForfdager);

      (* Calculate days overdue *)
      FDaysOverDue:=dateutils.DaysBetween(Now,FDueDate);

      (* Calculate interest rates for overdue time *)
      If FRenteSats>0 then
      Begin
        FGebyr:=PercentOf(TPercent(trunc(FRenteSats)),Items.CalcSubTotal());
      end;
    end;
  end;
  
  Function TJLInvoice.toString:String;
  Begin
    result:=
    'ID:' + IntToStr(self.FId)
    + #13 + #13 + FFaktAddr.toString('Fakturert til:')
    + #13 + #13 + self.FMotAddr.toString('Sendt til:')
    + #13 + #13 + FItems.toString
    + #13 + #13 + CurrToStr(FItems.CalcSubTotal());
  end;
  
  Function TJLInvoice.GetAltered:Boolean;
  Begin
    result:=FAltered>0;
  end;

  Function TJLInvoice.GetUpdating:Boolean;
  Begin
    result:=FUpdating>0;
  end;

  Procedure TJLInvoice.BeginUpdate;
  Begin
    inc(FUpdating);
  end;

  Procedure TJLInvoice.EndUpdate;
  Begin
    if FUpdating>0 then
    Begin
      dec(FUpdating);
      If FUpdating=0 then
      Begin
        Update;
        SignalInvoiceAltered;
      end;
    end;
  end;
  
  Procedure TJLInvoice.Clear;
  Begin
    FAltered:=0;
    FUpdating:=0;
    FFaktAddr.Clear;
    FMotAddr.Clear;
    FItems.clear;
  end;

  Function TJLInvoice.Validate:Boolean;
  Begin
    result:=FFaktAddr.Validate
    and FMotAddr.Validate
    and (FItems.Count>0);
  end;

  Procedure TJLInvoice.SignalInvoiceAltered;
  Begin
    If (FAltered>0)
    and assigned(FOnChanged) then
    FOnChanged(self);
  end;

  Procedure TJLInvoice.SetReminders(Value:Integer);
  Begin
    if Value<>FReminders then
    Begin
      FReminders:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;

  Procedure TJLInvoice.SetWarnings(Value:Integer);
  Begin
    if Value<>FWarnings then
    Begin
      FWarnings:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;
  
  Procedure TJLInvoice.SetState(Value:TJLInvoiceState);
  Begin
    if Value<>FState then
    begin
      FState:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;
  
  Procedure TJLInvoice.SetId(Value:Integer);
  Begin
    if Value<>Fid then
    Begin
      FId:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;

  Procedure TJLInvoice.SetDate(Value:TDateTime);
  Begin
    if Value<>FFaktDato then
    Begin
      FFaktDato:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;

  Procedure TJLInvoice.SetForfallsdager(Value:integer);
  Begin
    if Value<>FForfdager then
    Begin
      FForfdager:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;

  Procedure TJLInvoice.SetForfallt(Value:Boolean);
  Begin
    if Value<>FForfallt then
    Begin
      FForfallt:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;

  Procedure TJLInvoice.SetRentesats(Value:Double);
  Begin
    if Value<>FRenteSats then
    Begin
      FRentesats:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;

  procedure TJLInvoice.SetGebyr(Value:Currency);
  Begin
    if Value<>FGebyr then
    Begin
      FGebyr:=Value;
      if not GetUpdating then
      inc(FAltered);
    end;
  end;
  
  //###############################################################
  // TJLInvoiceAdresse
  //###############################################################

  Procedure TJLInvoiceAdresse.Clear;
  Begin
    FNavn:='';
    FAddr1:='';
    FAddr2:='';
    FSted:='';
    FStedsNavn:='';
  end;

  Function TJLInvoiceAdresse.Validate:Boolean;
  Begin
    result:=(length(trim(FNavn))>0)
    and (length(trim(FAddr1))>0)
    and (length(trim(FAddr2))>0)
    and (length(trim(FSted))>0)
    and (length(trim(FStedsnavn))>0);
  end;

  Function TJLInvoiceAdresse.toString(aHeader:String=''):String;
  Begin
    If Length(aHeader)>0 then
    Result:=AHeader + #13 else
    result:='';
    Result:=Result + FNavn + #13;

    If (length(FAddr1)>0)
    and (FAddr1<>'-') then
    Result:=Result + FAddr1 + #13;

    If (length(FAddr2)>0)
    and (FAddr2<>'-') then
    Result:=Result + FAddr2 + #13;

    result:=result + FSted + ' ' + FStedsnavn;
  end;

  //###############################################################
  // TJLInvoiceItems
  //###############################################################

  Constructor TJLInvoiceItems.Create(AOwner:TJLInvoice);
  Begin
    inherited Create;
    FParent:=AOwner;
    FObjects:=TObjectlist.Create(True);
  end;

  Destructor TJLInvoiceItems.Destroy;
  Begin
    FObjects.free;
    inherited;
  end;

  Procedure TJLInvoiceItems.Clear;
  Begin
    FObjects.Clear;
  end;
  
  Function TJLInvoiceItems.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  end;

  Function TJLInvoiceItems.toString:String;
  var
    x:  Integer;
  Begin
    result:='';
    for x:=1 to FObjects.Count do
    result:=Result + Items[x-1].toString;
  end;

  Function TJLInvoiceItems.CalcVatOnly:Currency;
  var
    x:  Integer;
    FItem:  TJLInvoiceItem;
  Begin
    result:=0;
    for x:=1 to FObjects.Count do
    Begin
      FItem:=Items[x-1];
      result:=result + FItem.GetVatOnly
    end;
  end;

  Function TJLInvoiceItems.CalcSubTotal(IncVat:Boolean=False):Currency;
  var
    x:  Integer;
    FItem:  TJLInvoiceItem;
  Begin
    result:=0;
    for x:=1 to FObjects.Count do
    Begin
      FItem:=Items[x-1];
      FItem.UpdateFinalFigures;
      if IncVat then
      Result:=Result + FItem.SumIncVat else
      Result:=Result + FItem.SumExVat;
    end;
  end;

  Function TJLInvoiceItems.GetItem(index:Integer):TJLInvoiceItem;
  Begin
    result:=TJLInvoiceItem(FObjects[index]);
  end;

  Function TJLInvoiceItems.Add(out Value:TJLInvoiceItem):Boolean;
  Begin
    try
      Value:=TJLInvoiceItem.Create(self);
    except
      on e: exception do
      Begin
        result:=False;
        exit;
      end;
    end;

    try
      FObjects.Add(Value);
    except
      on e: exception do
      Begin
        FreeAndNIL(Value);
        result:=False;
        exit;
      end;
    end;

    result:=True;
  end;

  //###############################################################
  // TJLInvoiceItem
  //###############################################################

  Constructor TJLInvoiceItem.Create(AOwner:TJLInvoiceItems);
  Begin
    inherited Create;
    if AOwner<>NIL then
    FParent:=AOwner else
    Raise Exception.Create('Invoiceitem parent cannot be NIL error');
  end;

  Function TJLInvoiceItem.GetUpdating:Boolean;
  Begin
    result:=FUpdating>0;
  end;

  Function TJLInvoiceItem.toString:String;
  Begin
    UpdateFinalFigures;
    result:='[' + FProduct + ']'
    + ' x ' + FloatToStr(FItems) + ' @ '
    + CurrToStr(FPrice) + ' (' + IntToStr(Vat) + '%) '
    + ' = ' + CurrToStr(FIncVat) + ' (' + CurrToStr(FExVat) + ')' + #13;
  end;

  Procedure TJLInvoiceItem.BeginUpdate;
  Begin
    inc(FUpdating);
  end;

  Procedure TJLInvoiceItem.EndUpdate;
  Begin
    if FUpdating>0 then
    Begin
      dec(FUpdating);
      If FUpdating=0 then
      UpdateFinalFigures;
    end;
  end;

  Procedure TJLInvoiceItem.SetCount(Value:Double);
  Begin
    if Value<>FItems then
    Begin
      FItems:=Value;
      if not GetUpdating then
      UpdateFinalFigures;
    end;
  end;

  Procedure TJLInvoiceItem.SetPrice(Value:Currency);
  Begin
    if Value<>FPrice then
    Begin
      FPrice:=Value;
      if not GetUpdating then
      UpdateFinalFigures;
    end;
  end;

  Procedure TJLInvoiceItem.SetVat(Value:Integer);
  Begin
    if Value<>FVat then
    Begin
      FVat:=Value;
      if not GetUpdating then
      UpdateFinalFigures;
    end;
  end;

  Procedure TJLInvoiceItem.SetDiscount(Value:Integer);
  Begin
    If Value<>FDiscount then
    Begin
      FDiscount:=Value;
      if not GetUpdating then
      UpdateFinalFigures;
    end;
  end;

  Procedure TJLInvoiceItem.SetProduct(Value:String);
  Begin
    if Value<>FProduct then
    Begin
      FProduct:=Value;
      if not GetUpdating then
      UpdateFinalFigures;
    end;
  end;

  Function TJLInvoiceItem.GetVatOnly:Currency;
  Begin
    result:=FIncVat - FExVat;
  end;

  Procedure TJLInvoiceItem.UpdateFinalFigures;

    Procedure FlushTotals;
    begin
      FExVat:=0;
      FIncVat:=0;
    end;

  var
    FTemp: Currency;
    FWork:  Currency;

  Begin
    If FItems>0 then
    Begin
      If FPrice>0 then
      Begin
        (* Calc total *)
        FTemp:=FPrice * Count;

        (* Subtract any discounts involved *)
        If FDiscount>0 then
        Begin
          FWork:=PercentOf(FDiscount,FTemp);
          FTemp:=FTemp - FWork;
        end;

        (* Set Price EX vat *)
        FExVat:=FTemp;

        (* Add Vat to the price *)
        If FVat>0 then
        Begin
          FWork:=PercentOf(FVat,FTemp);
          FTemp:=FTemp + FWork;
        end;

        (* Set Price INC vat *)
        FIncVat:=FTemp;
        
      end else
      FlushTotals;
    end else
    FlushTotals;
  end;

  //###############################################################
  // Helper Functions
  //###############################################################

  Function ExceptFormat(Instance:TObject;Source,Cause:AnsiString):String;
  Begin
    result:=#13 + 'Class [' + Instance.ClassName + '] threw exception:'#13;
    result:=Result + 'Source: ' + source + #13;
    result:=result + 'Cause: ' + cause + #13 + #13;
  End;


  //###########################################################################
  // TJLPropertyBag
  //###########################################################################

  Constructor TJLPropertyBag.Create;
  begin
    inherited;
    FData:=TStringList.Create;
  end;

  Destructor TJLPropertyBag.Destroy;
  begin
    FData.free;
    inherited;
  end;

  Function TJLPropertyBag.ConvertToBinString(Value:String):String;
  var
    x:  Integer;
  Begin
    result:='';
    for x:=1 to length(Value) do
    result:=result + IntToHex(Byte(Value[x]),2);
  end;

  Function TJLPropertyBag.ConvertFromBinString(Value:String):String;
  var
    x:    Integer;
    FSeg: String;
  Begin
    result:='';
    x:=1;
    while x<length(value) do
    begin
      FSeg:=Copy(Value,x,2);
      inc(x,2);
      result:=result + chr(StrToInt('$' + FSeg));
    end;
  end;

  Function TJLPropertyBag.BinStreamToString(Stream:TStream):String;
  var
    x:      Integer;
    FData:  Char;
  Begin
    Stream.seek(0,0);
    for x:=1 to Stream.Size do
    Begin
      Stream.Read(PChar(@FData)^,1);
      result:=result + IntToHex(byte(FData),2);
    end;
  end;

  Function TJLPropertyBag.BinStringToStream(Value:String):TStream;
  var
    x:      Integer;
    FData:  Char;
  Begin
    result:=TMemoryStream.Create;
    x:=1;
    while x<Length(Value) do
    Begin
      FData:=chr(StrToInt('$' + copy(value,x,2)));
      result.write(pointer(@FData)^,1);
      inc(x,2);
    end;
    result.seek(0,0);
  end;

  Procedure TJLPropertyBag.WriteDate(AName:String;Value:TDateTime);
  Begin
    try
      FData.Values[AName]:=EncodeValue(DateToStr(Value));
    except
      on  e: exception do
      raise Exception.CreateFmt('Failed to encode data [%s]',[Value]);
    end;
  end;

  Procedure TJLPropertyBag.WriteStream(AName:String;Value:TStream);
  Begin
    try
      FData.Values[AName]:=BinStreamToString(Value);
    except
      on  e: exception do
      Raise Exception.CreateFmt('Failed to encode data [%s]',[value]);
    end;
  end;

  Function TJLPropertyBag.ReadStream(AName:String):TStream;
  Begin
    try
      result:=BinStringToStream(FData.Values[AName]);
    except
      on  e: exception do
      Raise Exception.CreateFmt('Failed to decode data [%s]',[AName]);
    end;
  end;

  Function TJLPropertyBag.ReadDate(AName:String):TDateTime;
  Begin
    try
      result:=StrToDate(DecodeValue(FData.Values[AName]));
    except
      on  e: exception do
      Raise Exception.CreateFmt('Failed to decode data [%s]',[AName]);
    end;
  end;

  Procedure TJLPropertyBag.LoadFromFile(Const Filename:String);
  Begin
    FData.LoadFromFile(filename);
  end;

  Procedure TJLPropertyBag.LoadFromStream(Stream:TStream);
  Begin
    FData.LoadFromStream(stream);
  end;

  {Procedure TJLPropertyBag.SaveToRegistry(Key:HKey;Path,KeyName:String);
  var
    FReg:   TRegistry;
    FText:  String;
  Begin
    FReg:=TRegistry.Create;
    try
      FReg.RootKey:=Key;
      if FReg.OpenKey(path,true) then
      Begin
        try
          FText:=FData.Text;
          FReg.WriteBinaryData(keyname,pointer(@FText[1])^,length(FText));
        finally
          FReg.CloseKey;
        end;
      end;
    finally
      FReg.free;
    end;
  end;       }

  {
  Procedure TJLPropertyBag.LoadFromRegistry(Key:HKey;Path,KeyName:String);
  var
    FReg:   TRegistry;
    FText:  String;
    FInfo:  TRegDataInfo;
  Begin
    FReg:=TRegistry.Create;
    try
      FReg.RootKey:=Key;
      if FReg.OpenKey(path,false) then
      Begin
        try
          if FReg.GetDataInfo(keyname,FInfo) then
          Begin
            setlength(FText,FInfo.DataSize);
            FReg.ReadBinaryData(KeyName,pointer(@FText[1])^,FInfo.DataSize);
            FData.Text:=FText;
          end;
        finally
          FReg.CloseKey;
        end;
      end;
    finally
      FReg.free;
    end;
  end;
  }

  Function TJLPropertyBag.GetEmpty:Boolean;
  Begin
    result:=Length(FData.Text)=0;
  end;

  Procedure TJLPropertyBag.Clear;
  Begin
    FData.Clear;
  end;

  Function TJLPropertyBag.ToString:String;
  Begin
    result:=FData.Text;
  end;

  Procedure TJLPropertyBag.SaveToStream(Stream:TStream);
  Begin
    FData.SaveToStream(Stream);
  end;

  Procedure TJLPropertyBag.SaveToFile(Const Filename:String);
  Begin
    FData.SaveToFile(filename);
  end;

  Function TJLPropertyBag.GetCount:Integer;
  Begin
    result:=FData.Count;
  end;

  Function TJLPropertyBag.GetValue(index:Integer):String;
  Begin
    result:=FData.Names[index];
  end;

  Function TJLPropertyBag.EncodeValue(Value:String):String;
  var
    x:  Integer;
  begin
    result:='';
    
    { url encode it }
    for x:=1 to length(value) do
    begin
      case char(value[x]) of
      #00:  result:=result + '%00';
      #32:  result:=result + '%32';
      '/':  result:=result + '%2f';
      '?':  result:=result + '%3F';
      '!':  result:=result + '%21';
      '@':  result:=result + '%40';
      '\':  result:=result + '%5C';
      '#':  result:=result + '%23';
      '$':  result:=result + '%24';
      '^':  result:=result + '%5E';
      '&':  result:=result + '%26';
      '%':  result:=result + '%25';
      '*':  result:=result + '%2A';
      '(':  result:=result + '%28';
      ')':  result:=result + '%29';
      '}':  result:=result + '%7D';
      ':':  result:=result + '%3A';
      ',':  result:=result + '%2C';
      '{':  result:=result + '%7B';
      '+':  result:=result + '%2B';
      '.':  result:=result + '%2E';
      '-':  result:=result + '%2D';
      '~':  result:=result + '%7E';
      '[':  result:=result + '%5B';
      '_':  result:=result + '%5F';
      ']':  result:=result + '%5D';
      '`':  result:=result + '%60';
      '=':  result:=result + '%3D';
      '"':  result:=result + '%27';
      else
        result:=result + value[x];
      end;
    end;

    result:=ConvertToBinString(Result);
  end;

  Function TJLPropertyBag.DecodeValue(Value:String):String;
  var
    x:    Integer;
    FSeg: String;
  begin
    Value:=ConvertFromBinString(Value);

    x:=0;
    while x<length(Value) do
    begin
      inc(x);

      If value[x]='%' then
      Begin
        FSeg:=Copy(Value,x,3);
        inc(x,2);

        if fseg='%00' then result:=result + #00 else
        if FSeg='%2f' then result:=result + '/' else
        if FSeg='%3F' then result:=result + '?' else
        if FSeg='%21' then result:=result + '!' else
        if FSeg='%40' then result:=result + '@' else
        if FSeg='%5C' then result:=result + '\' else
        if FSeg='%23' then result:=result + '#' else
        if FSeg='%24' then result:=result + '$' else
        if fseg='%5E' then result:=result + '^' else
        if fseg='%26' then result:=result + '&' else
        if fseg='%25' then result:=result + '%' else
        if fseg='%2A' then result:=result + '*' else
        if fseg='%28' then result:=result + '(' else
        if fseg='%29' then result:=result + ')' else
        if fseg='%7D' then result:=result + '}' else
        if fseg='%3A' then result:=result + ':' else
        if fseg='%2C' then result:=result + ',' else
        if fseg='%7B' then result:=result + '{' else
        if fseg='%2B' then result:=result + '+' else
        if fseg='%2E' then result:=result + '.' else
        if fseg='%2D' then result:=result + '-' else
        if fseg='%7E' then result:=result + '~' else
        if fseg='%5B' then result:=result + '[' else
        if fseg='%5F' then result:=result + '_' else
        if fseg='%5D' then result:=result + ']' else
        if fseg='%60' then result:=result + '`' else
        if fseg='%3D' then result:=result + '=' else
        if fseg='%32' then result:=result + ' ' else
        if fseg='%27' then result:=result + '"';
      end else
      result:=result + value[x];
    end;
  end;

  Procedure TJLPropertyBag.AssignTo(Target:TJLPropertyBag);
  var
    FData:  TStringStream;
  Begin
    if target<>NIL then
    Begin
      FData:=TStringStream.Create(self.ToString);
      try
        FData.Seek(0,0);
        Target.LoadFromStream(FData);
      finally
        FData.free;
      end;
    end;
  end;

  Procedure TJLPropertyBag.WriteBoolean(AName:String;Value:Boolean);
  Begin
    try
      If value then
      FData.Values[AName]:='True' else
      FData.Values[AName]:='False';
    except
      on  e: exception do
      raise;
    end;
  end;

  Procedure TJLPropertyBag.WriteInteger(AName:String;Value:Integer);
  Begin
    try
      FData.Values[AName]:=EncodeValue(IntToStr(Value));
    except
      on  e: exception do
      raise;
    end;
  end;

  Procedure TJLPropertyBag.WriteString(AName:String;Value:String);
  Begin
    try
      FData.Values[AName]:=EncodeValue(Value);
    except
      on  e: exception do
      Raise;
    end;
  end;

  Function TJLPropertyBag.ReadInteger(AName:String):Integer;
  Begin
    try
      result:=StrToInt(DecodeValue(FData.Values[Aname]));
    except
      on  e: exception do
      Raise;
    end;
  end;

  Procedure TJLPropertyBag.WriteCurrency(AName:String;Value:Currency);
  Begin
    try
      FData.Values[AName]:=EncodeValue(CurrToStr(Value));
    except
      on  e: exception do
      Raise;
    end;
  end;

  Function TJLPropertyBag.ReadCurrency(AName:String):Currency;
  Begin
    try
      result:=StrToCurr(DecodeValue(FData.Values[Aname]));
    except
      on  e: exception do
      Raise;
    end;
  end;

  Function TJLPropertyBag.ReadBoolean(AName:String):Boolean;
  Begin
    try
      result:=(FData.Values[AName]='True');
    except
      on  e: exception do
      Raise;
    end;
  end;

  Function TJLPropertyBag.ReadString(AName:String):String;
  Begin
    try
      result:=DecodeValue(FData.Values[AName]);
    except
      on  e: exception do
      Raise;
    end;
  end;


  //###########################################################################
  //
  //###########################################################################

  Function GetPathForDatabases:String;
  Begin
    result:=IncludeTrailingPathDelimiter(GetAppDataPath);
    try
      result:=result + Application_Firm;
      if not DirectoryExists(result) then
      mkDir(result);

      result:=IncludeTrailingPathDelimiter(result) + Application_Name;
      //result:=result + '\Raptor Faktura';
      if not DirectoryExists(result) then
      mkDir(result);
    except
      on exception do
      Raise Exception.Create
      ('Det oppstod problemer med å lokalisere mappen hvor data skal lagres');
    end;
  end;

  Function GetPathForSystem:String;
  var
    FPath:  Array [0..Max_Path] of Char;
  Begin
    SetString
      (
      Result,
      FPath,
      GetSystemDirectory(FPath, MAX_PATH)
      );
  End;

  function GetMyDocumentsPath: string;
  var
    Res: Bool;
    Path: array[0..Max_Path] of Char;
  begin
    Res := ShGetSpecialFolderPath(0, Path, csidl_Personal, False);
    If Res then
    Result := Path;
  end;

  function GetAppDataPath: string;
  var
    Res: Bool;
    Path: array[0..Max_Path] of Char;
  begin
    Res := ShGetSpecialFolderPath(0, Path, csidl_AppData, False);
    If Res then
    Result := Path;
  end;

  Procedure ErrorDialog(AForm,AName,ACause:String);
  var
    FText:  String;
  Begin
    FText:='Følgende feil oppstod i systemet:'#13#13;
    FText:=FText + 'Modul: %s'#13;
    FText:=FText + 'Funksjon: %s'#13;
    FText:=FText + 'Kilde: %s'#13#13;
    FText:=FText + 'Kontakt leverandøren hvis problemet fortsetter.';
    FText:=Format(FText,[AForm,Aname,ACause]);
    Application.MessageBox(pChar(FText),'Feilmelding',MB_OK or MB_ICONERROR);
  End;

  function StatusToPrintStr(Status:Integer):String;
  Begin
    Case status of
    FAKTURA_IKKEFAKTURERT:  result:='Faktura';
    FAKTURA_FAKTURERT:      result:='Faktura';
    FAKTURA_KREDITNOTA:     result:='Kredittnota';
    FAKTURA_BETALT:         result:='Betalt';
    else
      result:='Ukjent';
    end;
  End;

  Function StatusToStr(Status:Integer):String;
  Begin
    Case status of
    FAKTURA_IKKEFAKTURERT:  result:='Ikke fakturert';
    FAKTURA_FAKTURERT:      result:='Fakturert';
    FAKTURA_KREDITNOTA:     result:='Kredittert';
    FAKTURA_BETALT:         result:='Betalt';
    else
      result:='Ukjent';
    end;
  End;

  {
  function IsLeapYear( nYear: Integer ): Boolean;
  begin
    Result := (nYear mod 4 = 0)
    and ((nYear mod 100 <> 0)
    or (nYear mod 400 = 0));
  end;

  function MonthDays( nMonth, nYear: Integer ): Integer;
  const
    DaysPerMonth: array[1..12] of Integer
    = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  begin
    Result := DaysPerMonth[nMonth];
    if (nMonth = 2) and IsLeapYear(nYear) then Inc(Result);
  end;

  function WeekOfYear( dDate: TDateTime ): Integer;
  var
    X, nDayCount: Integer;
    nMonth, nDay, nYear: Word;
  begin
    nDayCount := 0;
    deCodeDate(dDate, nYear, nMonth, nDay);
    For X := 1 to ( nMonth - 1 ) do
    nDayCount := nDayCount + MonthDays( X, nYear );
    nDayCount := nDayCount + nDay;
    Result := ( ( nDayCount div 7 ) + 1 );
  end;

  function SpanOfNowAndThen(const ANow, AThen: TDateTime): TDateTime;
  begin
    if ANow < AThen then
    Result := AThen - ANow else
    Result := ANow - AThen;
  end;

  function DaySpan(const ANow, AThen: TDateTime): Double;
  begin
    Result := SpanOfNowAndThen(ANow, AThen);
  end;

  function DaysBetween(const ANow, AThen: TDateTime): Integer;
  begin
    Result := Trunc(DaySpan(ANow, AThen));
  end;
  }

  Initialization
  begin
    { Define charset used when parsing }
    _SeekCharset:='abcdefghijklmnopqrstuvwxyzæøå';
    _SeekCharset:=_SeekCharset+Uppercase(_SeekCharset);
    _SeekCharset:=_SeekCharset+':.,;-_^~*1234567890!§"#¤%&()=?\|/{}[]<>€$£@`´';

    FAvanser[0]:=1.5;
    FAvanser[1]:=2.0;
    FAvanser[2]:=2.5;
    FAvanser[3]:=3.0;

    FHeaders[GROUP_ALLE]:='Informasjon';
    Fheaders[GROUP_LEVERANDORER]:='leverandør register';
    FHeaders[GROUP_PRODUKTER]:='produkt register';
    Fheaders[GROUP_KUNDER]:='kunde register';
    FHeaders[GROUP_FAKTURA]:='faktura register';

    FHeaderNames[GROUP_LEVERANDORER]:='Leverandør';
    FHeaderNames[GROUP_PRODUKTER]:='Produkt';
    FHeaderNames[GROUP_KUNDER]:='Kunde';
    FHeaderNames[GROUP_FAKTURA]:='Faktura';

  End;


  end.
