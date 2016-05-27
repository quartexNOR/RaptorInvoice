inherited frmFakturaJournal: TfrmFakturaJournal
  Left = 428
  Top = 286
  Caption = 'Raptor faktura journal'
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  inherited RzPanel1: TRzPanel
    inherited lbTitle: TRzLabel
      Width = 117
      Caption = 'Faktura journal'
    end
    inherited lbHelp1: TRzLabel
      Width = 215
      Caption = 'Trykk p'#229' skriv ut for '#229' skrive ut journalen.'
    end
    inherited lbHelp2: TRzLabel
      Width = 294
      Caption = 'Trykk p'#229' Avbryt eller ESC tasten for '#229' lukke dette vinduet.'
    end
  end
  inherited ReportViewer: TppViewer
    Report = FakturaJournal
  end
  inherited ActionList1: TActionList
    Left = 202
    Top = 162
  end
  inherited Mailer: TRzSendMessage
    Top = 194
  end
  inherited PopupMenu1: TPopupMenu
    Top = 162
  end
  object FakturaJournal: TppReport
    AutoStop = False
    DataPipeline = FakturaJournalPipe
    PassSetting = psTwoPass
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'A4 210 x 297 mm'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 297000
    PrinterSetup.mmPaperWidth = 210000
    PrinterSetup.PaperSize = 9
    Template.FileName = 'G:\Delphi Prosjekter\Raptor\Reports\journal.rtm'
    DeviceType = 'Screen'
    OutlineSettings.CreateNode = True
    OutlineSettings.CreatePageNodes = True
    OutlineSettings.Enabled = False
    OutlineSettings.Visible = False
    TextSearchSettings.DefaultString = '<FindText>'
    TextSearchSettings.Enabled = False
    Left = 236
    Top = 194
    Version = '9.01'
    mmColumnWidth = 0
    DataPipelineName = 'FakturaJournalPipe'
    object ppHeaderBand4: TppHeaderBand
      mmBottomOffset = 0
      mmHeight = 40217
      mmPrintPosition = 0
      object ppShape1: TppShape
        UserName = 'Shape1'
        Brush.Color = clSilver
        mmHeight = 4233
        mmLeft = 529
        mmTop = 35983
        mmWidth = 196586
        BandType = 0
      end
      object ppLabel12: TppLabel
        UserName = 'Label12'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Faktura Journal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 24
        Font.Style = []
        Transparent = True
        mmHeight = 9737
        mmLeft = 1058
        mmTop = 1058
        mmWidth = 58914
        BandType = 0
      end
      object ppLabel22: TppLabel
        UserName = 'Label22'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Side'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 173567
        mmTop = 529
        mmWidth = 7144
        BandType = 0
      end
      object nFirmaNavn: TppLabel
        UserName = 'nFirmaNavn'
        OnGetText = nFirmaNavnGetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Firma navn'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4163
        mmLeft = 1058
        mmTop = 12171
        mmWidth = 17709
        BandType = 0
      end
      object nFirmaAdresse: TppLabel
        UserName = 'nFirmaAdresse'
        OnGetText = nFirmaAdresseGetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Firma adresse'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 1058
        mmTop = 17992
        mmWidth = 22754
        BandType = 0
      end
      object nPostNr: TppLabel
        UserName = 'nPostNr'
        OnGetText = nPostNrGetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'pNr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 1058
        mmTop = 29104
        mmWidth = 5821
        BandType = 0
      end
      object nSted: TppLabel
        UserName = 'nSted'
        OnGetText = nStedGetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Sted'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 9525
        mmTop = 29104
        mmWidth = 7144
        BandType = 0
      end
      object ppSystemVariable3: TppSystemVariable
        UserName = 'SystemVariable3'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 173567
        mmTop = 6350
        mmWidth = 17727
        BandType = 0
      end
      object ppLabel28: TppLabel
        UserName = 'Label28'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Den'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 166159
        mmTop = 6350
        mmWidth = 6615
        BandType = 0
      end
      object ppSystemVariable4: TppSystemVariable
        UserName = 'SystemVariable4'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        VarType = vtPageSet
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 182298
        mmTop = 529
        mmWidth = 8996
        BandType = 0
      end
      object ppLabel30: TppLabel
        UserName = 'Label30'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Faktura #'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 794
        mmTop = 35983
        mmWidth = 15081
        BandType = 0
      end
      object ppLabel31: TppLabel
        UserName = 'Label31'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Kunde'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 17727
        mmTop = 35983
        mmWidth = 10319
        BandType = 0
      end
      object ppLabel32: TppLabel
        UserName = 'Label32'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 86254
        mmTop = 35983
        mmWidth = 7938
        BandType = 0
      end
      object ppLabel33: TppLabel
        UserName = 'Label33'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Referanse'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 109538
        mmTop = 35983
        mmWidth = 16404
        BandType = 0
      end
      object ppLabel34: TppLabel
        UserName = 'Label34'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Produkter'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 132292
        mmTop = 35983
        mmWidth = 15346
        BandType = 0
      end
      object ppLabel4: TppLabel
        UserName = 'Label4'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Pris'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 155046
        mmTop = 35983
        mmWidth = 6085
        BandType = 0
      end
      object nFirmaAdresse2: TppLabel
        UserName = 'nFirmaAdresse2'
        OnGetText = nFirmaAdresse2GetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Firma adresse'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 1058
        mmTop = 23283
        mmWidth = 22754
        BandType = 0
      end
    end
    object ppDetailBand5: TppDetailBand
      PrintHeight = phDynamic
      mmBottomOffset = 0
      mmHeight = 5027
      mmPrintPosition = 0
      object ppDBText23: TppDBText
        UserName = 'DBText23'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        DataField = 'ID'
        DataPipeline = FakturaJournalPipe
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        ParentDataPipeline = False
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'FakturaJournalPipe'
        mmHeight = 4233
        mmLeft = 1058
        mmTop = 794
        mmWidth = 14288
        BandType = 4
      end
      object ppDBText24: TppDBText
        UserName = 'DBText201'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        DataField = 'Kunde'
        DataPipeline = FakturaJournalPipe
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        ParentDataPipeline = False
        Transparent = True
        DataPipelineName = 'FakturaJournalPipe'
        mmHeight = 4233
        mmLeft = 17727
        mmTop = 794
        mmWidth = 65881
        BandType = 4
      end
      object nFakturaStatus: TppDBText
        UserName = 'nFakturaStatus'
        OnGetText = nFakturaStatusGetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        DataField = 'Status'
        DataPipeline = FakturaJournalPipe
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        ParentDataPipeline = False
        Transparent = True
        DataPipelineName = 'FakturaJournalPipe'
        mmHeight = 4233
        mmLeft = 86254
        mmTop = 794
        mmWidth = 22754
        BandType = 4
      end
      object nReferanse: TppLabel
        UserName = 'xref1'
        OnGetText = nReferanseGetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'xRef'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4233
        mmLeft = 109802
        mmTop = 794
        mmWidth = 17198
        BandType = 4
      end
      object nProdukter: TppLabel
        UserName = 'xProdCount1'
        OnGetText = nProdukterGetText
        AutoSize = False
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'nProdukter'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 4233
        mmLeft = 132292
        mmTop = 794
        mmWidth = 14023
        BandType = 4
      end
      object ppLabel8: TppLabel
        UserName = 'Label8'
        OnGetText = ppLabel8GetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Label8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 155046
        mmTop = 0
        mmWidth = 10848
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 14817
      mmPrintPosition = 0
      object ppLabel3: TppLabel
        UserName = 'Label3'
        AutoSize = False
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Registrerte kunder:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4233
        mmLeft = 265
        mmTop = 1588
        mmWidth = 32015
        BandType = 8
      end
      object ppLabel5: TppLabel
        UserName = 'Label5'
        OnGetText = ppLabel5GetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Label5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 33073
        mmTop = 1588
        mmWidth = 10848
        BandType = 8
      end
      object ppLabel6: TppLabel
        UserName = 'Label6'
        AutoSize = False
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Total omsetning:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4233
        mmLeft = 116681
        mmTop = 1588
        mmWidth = 47625
        BandType = 8
      end
      object ppLabel7: TppLabel
        UserName = 'Label7'
        OnGetText = ppLabel7GetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Label7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 165100
        mmTop = 1588
        mmWidth = 10848
        BandType = 8
      end
      object ppLabel1: TppLabel
        UserName = 'Label1'
        AutoSize = False
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Registrerte faktura:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4233
        mmLeft = 50800
        mmTop = 1588
        mmWidth = 32015
        BandType = 8
      end
      object ppLabel2: TppLabel
        UserName = 'Label2'
        OnGetText = ppLabel2GetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Label2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4163
        mmLeft = 83608
        mmTop = 1588
        mmWidth = 10724
        BandType = 8
      end
      object ppLine1: TppLine
        UserName = 'Line1'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Weight = 0.750000000000000000
        mmHeight = 1588
        mmLeft = 0
        mmTop = 0
        mmWidth = 197115
        BandType = 8
      end
    end
  end
  object FakturaJournalPipe: TppDBPipeline
    DataSource = LiveData
    OpenDataSource = False
    UserName = 'FakturaJournalPipe'
    Left = 168
    Top = 194
  end
  object RzFormState1: TRzFormState
    RegIniFile = RzRegIniFile1
    Left = 236
    Top = 162
  end
  object RzRegIniFile1: TRzRegIniFile
    Path = 'software\jurasoft\raptor'
    PathType = ptRegistry
    Left = 268
    Top = 162
  end
  object LiveQuery: TVolgaQuery
    Database = AppData.dbase
    ReadOnly = True
    SortOptions = [vsoDescendSort]
    UniqueFieldNames = 'id'
    Version = 'VolgaDB Engine v5.10'
    AfterScroll = LiveQueryAfterScroll
    SQL.Strings = (
      'select * from faktura')
    QueryDatasets = <>
    Left = 444
    Top = 127
    object LiveQueryID: TIntegerField
      FieldName = 'ID'
    end
    object LiveQueryKunde: TStringField
      FieldName = 'Kunde'
      Size = 64
    end
    object LiveQueryAdresse: TStringField
      FieldName = 'Adresse'
      Size = 64
    end
    object LiveQueryAdresse2: TStringField
      FieldName = 'Adresse2'
      Size = 64
    end
    object LiveQueryPostNr: TStringField
      FieldName = 'PostNr'
      Size = 4
    end
    object LiveQuerySted: TStringField
      FieldName = 'Sted'
      Size = 64
    end
    object LiveQueryDato: TDateTimeField
      FieldName = 'Dato'
    end
    object LiveQueryBetalingsfrist: TIntegerField
      FieldName = 'Betalingsfrist'
    end
    object LiveQueryRabatt: TIntegerField
      FieldName = 'Rabatt'
    end
    object LiveQueryStatus: TIntegerField
      FieldName = 'Status'
    end
    object LiveQueryPris: TCurrencyField
      FieldName = 'Pris'
    end
    object LiveQueryMerk: TStringField
      FieldName = 'Merk'
      Size = 64
    end
    object LiveQueryTekst: TMemoField
      FieldName = 'Tekst'
      BlobType = ftMemo
    end
    object LiveQueryFakturaRef: TIntegerField
      FieldName = 'FakturaRef'
    end
    object LiveQueryPurringer: TIntegerField
      FieldName = 'Purringer'
    end
    object LiveQueryVarsel: TIntegerField
      FieldName = 'Varsel'
    end
    object LiveQueryForfallt: TBooleanField
      FieldName = 'Forfallt'
    end
    object LiveQueryDinRef: TStringField
      FieldName = 'DinRef'
      Size = 64
    end
    object LiveQueryMinRef: TStringField
      FieldName = 'MinRef'
      Size = 64
    end
    object LiveQueryRentesats: TFloatField
      FieldName = 'Rentesats'
      DisplayFormat = '0.######'
    end
    object LiveQueryGebyr: TCurrencyField
      FieldName = 'Gebyr'
    end
  end
  object LiveData: TDataSource
    AutoEdit = False
    DataSet = LiveQuery
    Left = 444
    Top = 159
  end
  object LiveItems: TVolgaQuery
    Database = AppData.dbase
    IndexFieldNames = 'fakturaid'
    MasterFields = 'id'
    MasterSource = LiveData
    ReadOnly = True
    SortOptions = [vsoDescendSort]
    UniqueFieldNames = 'id'
    Version = 'VolgaDB Engine v5.10'
    QueryDatasets = <>
    Left = 476
    Top = 127
  end
end
