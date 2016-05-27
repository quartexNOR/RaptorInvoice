object DataStore: TDataStore
  OldCreateOrder = False
  Left = 498
  Top = 206
  Height = 362
  Width = 518
  object Leverandorer: TVolgaTable
    Database = dbase
    SortOptions = [vsoCaseInsensitive, vsoDescendSort]
    UniqueFieldNames = 'Id'
    Version = 'VolgaDB Engine v5.10'
    BeforePost = LeverandorerBeforePost
    OnNewRecord = LeverandorerNewRecord
    TableName = 'leverandorer.d'
    LoadMode = lmFile
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'Firma'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Adresse'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Adresse2'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Sted'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Postnr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'Telefon'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'Fax'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'Email'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Internett'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Kontaktperson'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'OrganisasjonsId'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Kommentarer'
        DataType = ftMemo
      end>
    StoreDefs = True
    Left = 78
    Top = 12
    object LeverandorerId: TIntegerField
      FieldName = 'Id'
    end
    object LeverandorerFirma: TStringField
      FieldName = 'Firma'
      Size = 64
    end
    object LeverandorerAdresse: TStringField
      FieldName = 'Adresse'
      Size = 64
    end
    object LeverandorerAdresse2: TStringField
      FieldName = 'Adresse2'
      Size = 64
    end
    object LeverandorerSted: TStringField
      FieldName = 'Sted'
      Size = 64
    end
    object LeverandorerPostnr: TStringField
      FieldName = 'Postnr'
      Size = 4
    end
    object LeverandorerTelefon: TStringField
      FieldName = 'Telefon'
      Size = 8
    end
    object LeverandorerFax: TStringField
      FieldName = 'Fax'
      Size = 8
    end
    object LeverandorerEmail: TStringField
      FieldName = 'Email'
      Size = 64
    end
    object LeverandorerInternett: TStringField
      FieldName = 'Internett'
      Size = 64
    end
    object LeverandorerKontaktperson: TStringField
      FieldName = 'Kontaktperson'
      Size = 64
    end
    object LeverandorerOrganisasjonsId: TStringField
      FieldName = 'OrganisasjonsId'
      Size = 64
    end
    object LeverandorerKommentarer: TMemoField
      FieldName = 'Kommentarer'
      BlobType = ftMemo
    end
  end
  object Produkter: TVolgaTable
    Database = dbase
    SortOptions = [vsoCaseInsensitive]
    UniqueFieldNames = 'Id'
    Version = 'VolgaDB Engine v5.10'
    AutoCalcFields = False
    BeforePost = ProdukterBeforePost
    OnCalcFields = ProdukterCalcFields
    TableName = 'produkter.d'
    LoadMode = lmFile
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'LeverandorId'
        DataType = ftInteger
      end
      item
        Name = 'LeverandorRef'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Tittel'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Type'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'InnPris'
        DataType = ftCurrency
      end
      item
        Name = 'UtPris'
        DataType = ftCurrency
      end
      item
        Name = 'Mva'
        DataType = ftInteger
      end
      item
        Name = 'Beskrivelse'
        DataType = ftMemo
      end
      item
        Name = 'Avanse'
        DataType = ftInteger
      end>
    StoreDefs = True
    Left = 156
    Top = 12
    object ProdukterId: TIntegerField
      FieldName = 'Id'
    end
    object ProdukterLeverandorId: TIntegerField
      FieldName = 'LeverandorId'
    end
    object ProdukterLeverandorRef: TStringField
      FieldName = 'LeverandorRef'
      Size = 64
    end
    object ProdukterTittel: TStringField
      FieldName = 'Tittel'
      Size = 64
    end
    object ProdukterType: TStringField
      FieldName = 'Type'
      Size = 64
    end
    object ProdukterInnPris: TCurrencyField
      FieldName = 'InnPris'
    end
    object ProdukterUtPris: TCurrencyField
      FieldName = 'UtPris'
    end
    object ProdukterMva: TIntegerField
      FieldName = 'Mva'
    end
    object ProdukterBeskrivelse: TMemoField
      FieldName = 'Beskrivelse'
      BlobType = ftMemo
    end
    object ProdukterAvanse: TIntegerField
      FieldName = 'Avanse'
    end
  end
  object LeverandorerDs: TDataSource
    DataSet = Leverandorer
    Left = 78
    Top = 66
  end
  object ProdukterDs: TDataSource
    DataSet = Produkter
    Left = 156
    Top = 66
  end
  object Faktura: TVolgaTable
    Database = dbase
    SortOptions = [vsoCaseInsensitive]
    UniqueFieldNames = 'Id'
    Version = 'VolgaDB Engine v5.10'
    AfterScroll = FakturaAfterScroll
    BeforePost = FakturaBeforePost
    OnCalcFields = FakturaCalcFields
    OnNewRecord = FakturaNewRecord
    TableName = 'faktura.d'
    LoadMode = lmFile
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'Kunde'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Adresse'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Adresse2'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'PostNr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'Sted'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Dato'
        DataType = ftDateTime
      end
      item
        Name = 'Betalingsfrist'
        DataType = ftInteger
      end
      item
        Name = 'Rabatt'
        DataType = ftInteger
      end
      item
        Name = 'Status'
        DataType = ftInteger
      end
      item
        Name = 'Pris'
        DataType = ftCurrency
      end
      item
        Name = 'Merk'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Tekst'
        DataType = ftMemo
      end
      item
        Name = 'FakturaRef'
        DataType = ftInteger
      end
      item
        Name = 'Purringer'
        DataType = ftInteger
      end
      item
        Name = 'Varsel'
        DataType = ftInteger
      end
      item
        Name = 'Forfallt'
        DataType = ftBoolean
      end
      item
        Name = 'DinRef'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'MinRef'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Rentesats'
        DataType = ftFloat
      end
      item
        Name = 'Gebyr'
        DataType = ftCurrency
      end
      item
        Name = 'Purredato'
        DataType = ftDateTime
      end>
    StoreDefs = True
    Left = 372
    Top = 12
    object FakturaID: TIntegerField
      FieldName = 'ID'
    end
    object FakturaKunde: TStringField
      FieldName = 'Kunde'
      Size = 64
    end
    object FakturaAdresse: TStringField
      FieldName = 'Adresse'
      Size = 64
    end
    object FakturaAdresse2: TStringField
      FieldName = 'Adresse2'
      Size = 64
    end
    object FakturaPostNr: TStringField
      FieldName = 'PostNr'
      Size = 4
    end
    object FakturaSted: TStringField
      FieldName = 'Sted'
      Size = 64
    end
    object FakturaDato: TDateTimeField
      FieldName = 'Dato'
    end
    object FakturaBetalingsfrist: TIntegerField
      FieldName = 'Betalingsfrist'
    end
    object FakturaRabatt: TIntegerField
      FieldName = 'Rabatt'
    end
    object FakturaStatus: TIntegerField
      FieldName = 'Status'
    end
    object FakturaPris: TCurrencyField
      FieldName = 'Pris'
    end
    object FakturaMerk: TStringField
      FieldName = 'Merk'
      Size = 64
    end
    object FakturaTekst: TMemoField
      FieldName = 'Tekst'
      BlobType = ftMemo
    end
    object FakturaFakturaRef: TIntegerField
      FieldName = 'FakturaRef'
    end
    object FakturaPurringer: TIntegerField
      FieldName = 'Purringer'
    end
    object FakturaVarsel: TIntegerField
      FieldName = 'Varsel'
    end
    object FakturaForfallt: TBooleanField
      FieldName = 'Forfallt'
    end
    object FakturaForfall: TDateTimeField
      FieldKind = fkCalculated
      FieldName = 'Forfall'
      Calculated = True
    end
    object FakturaDinRef: TStringField
      FieldName = 'DinRef'
      Size = 64
    end
    object FakturaMinRef: TStringField
      FieldName = 'MinRef'
      Size = 64
    end
    object FakturaRentesats: TFloatField
      FieldName = 'Rentesats'
      DisplayFormat = '0.######'
    end
    object FakturaGebyr: TCurrencyField
      FieldName = 'Gebyr'
    end
    object FakturaTotal: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Total'
      Calculated = True
    end
    object FakturaPurredato: TDateTimeField
      FieldName = 'Purredato'
    end
  end
  object FakturaDs: TDataSource
    DataSet = Faktura
    Left = 372
    Top = 66
  end
  object FakturaData: TVolgaTable
    Database = dbase
    SortOptions = [vsoCaseInsensitive]
    UniqueFieldNames = 'Id'
    Version = 'VolgaDB Engine v5.10'
    TableName = 'fakturadata.d'
    LoadMode = lmFile
    FieldDefs = <
      item
        Name = 'FakturaId'
        DataType = ftInteger
      end
      item
        Name = 'Produkt'
        DataType = ftString
        Size = 128
      end
      item
        Name = 'Antall'
        DataType = ftFloat
      end
      item
        Name = 'Pris'
        DataType = ftCurrency
      end
      item
        Name = 'Mva'
        DataType = ftInteger
      end
      item
        Name = 'Rabatt'
        DataType = ftInteger
      end
      item
        Name = 'EksMva'
        DataType = ftCurrency
      end
      item
        Name = 'InkMva'
        DataType = ftCurrency
      end>
    StoreDefs = True
    Left = 450
    Top = 12
    object FakturaDataFakturaId: TIntegerField
      FieldName = 'FakturaId'
    end
    object FakturaDataProdukt: TStringField
      FieldName = 'Produkt'
      Size = 128
    end
    object FakturaDataAntall: TFloatField
      FieldName = 'Antall'
      DisplayFormat = '0.######'
    end
    object FakturaDataPris: TCurrencyField
      FieldName = 'Pris'
    end
    object FakturaDataMva: TIntegerField
      FieldName = 'Mva'
    end
    object FakturaDataRabatt: TIntegerField
      FieldName = 'Rabatt'
    end
    object FakturaDataEksMva: TCurrencyField
      FieldName = 'EksMva'
    end
    object FakturaDataInkMva: TCurrencyField
      FieldName = 'InkMva'
    end
  end
  object FaturaDataDs: TDataSource
    DataSet = FakturaData
    Left = 450
    Top = 66
  end
  object Kunder: TVolgaTable
    Database = dbase
    SortOptions = [vsoCaseInsensitive, vsoDescendSort]
    UniqueFieldNames = 'Id'
    Version = 'VolgaDB Engine v5.10'
    BeforePost = KunderBeforePost
    OnNewRecord = KunderNewRecord
    TableName = 'kunder.d'
    LoadMode = lmFile
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'Gruppe'
        DataType = ftInteger
      end
      item
        Name = 'Firma'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Adresse'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Adresse2'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Postnr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'Sted'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Telefon'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'Fax'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'Email'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Internett'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Kontaktperson'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'OrganisasjonsId'
        DataType = ftString
        Size = 12
      end
      item
        Name = 'Kommentarer'
        DataType = ftMemo
      end
      item
        Name = 'Salg'
        DataType = ftCurrency
      end>
    StoreDefs = True
    Left = 218
    Top = 13
    object KunderId: TIntegerField
      FieldName = 'Id'
    end
    object KunderGruppe: TIntegerField
      FieldName = 'Gruppe'
    end
    object KunderFirma: TStringField
      FieldName = 'Firma'
      Size = 64
    end
    object KunderAdresse: TStringField
      FieldName = 'Adresse'
      Size = 64
    end
    object KunderAdresse2: TStringField
      FieldName = 'Adresse2'
      Size = 64
    end
    object KunderPostnr: TStringField
      FieldName = 'Postnr'
      Size = 4
    end
    object KunderSted: TStringField
      FieldName = 'Sted'
      Size = 64
    end
    object KunderTelefon: TStringField
      FieldName = 'Telefon'
      Size = 8
    end
    object KunderFax: TStringField
      FieldName = 'Fax'
      Size = 8
    end
    object KunderEmail: TStringField
      FieldName = 'Email'
      Size = 64
    end
    object KunderInternett: TStringField
      FieldName = 'Internett'
      Size = 64
    end
    object KunderKontaktperson: TStringField
      FieldName = 'Kontaktperson'
      Size = 64
    end
    object KunderOrganisasjonsId: TStringField
      FieldName = 'OrganisasjonsId'
      Size = 12
    end
    object KunderKommentarer: TMemoField
      FieldName = 'Kommentarer'
      BlobType = ftMemo
    end
    object KunderSalg: TCurrencyField
      FieldName = 'Salg'
    end
  end
  object KunderDs: TDataSource
    DataSet = Kunder
    Left = 217
    Top = 67
  end
  object dbase: TVolgaDatabase
    DateFormat = 'mm/dd/yyyy'
    Left = 12
    Top = 12
  end
  object KundeGrupperDS: TDataSource
    DataSet = KundeGrupper
    Left = 294
    Top = 66
  end
  object KundeGrupper: TVolgaTable
    Database = dbase
    UniqueFieldNames = 'id'
    Version = 'VolgaDB Engine v5.10'
    OnNewRecord = KundeGrupperNewRecord
    TableName = 'kundegrupper.d'
    LoadMode = lmFile
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
      end
      item
        Name = 'Tittel'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'Rabatt'
        DataType = ftInteger
      end
      item
        Name = 'Notater'
        DataType = ftMemo
      end
      item
        Name = 'Aktiv'
        DataType = ftBoolean
      end
      item
        Name = 'Tag'
        DataType = ftString
        Size = 20
      end>
    StoreDefs = True
    Left = 294
    Top = 12
    object KundeGrupperId: TAutoIncField
      FieldName = 'Id'
    end
    object KundeGrupperTittel: TStringField
      FieldName = 'Tittel'
      Size = 64
    end
    object KundeGrupperRabatt: TIntegerField
      FieldName = 'Rabatt'
    end
    object KundeGrupperNotater: TMemoField
      FieldName = 'Notater'
      BlobType = ftMemo
    end
    object KundeGrupperAktiv: TBooleanField
      FieldName = 'Aktiv'
    end
    object KundeGrupperTag: TStringField
      FieldName = 'Tag'
    end
  end
end
