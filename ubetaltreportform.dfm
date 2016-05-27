inherited frmFordringJournal: TfrmFordringJournal
  Left = 132
  Top = 221
  Caption = 'Raptor fordrings journal'
  PixelsPerInch = 96
  TextHeight = 16
  inherited RzPanel1: TRzPanel
    inherited lbTitle: TRzLabel
      Width = 124
      Caption = 'Fordring journal'
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
  inherited RzDialogButtons1: TRzDialogButtons
    inherited NavigatorPanel: TPanel
      inherited dbxPanel: TRzPanel
        Visible = False
      end
    end
  end
  object FakturaJournalPipe: TppDBPipeline
    DataSource = LiveDataDS
    OpenDataSource = False
    UserName = 'FakturaJournalPipe'
    Left = 69
    Top = 168
    object FakturaJournalPipeppField1: TppField
      FieldAlias = 'ID'
      FieldName = 'ID'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 0
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField2: TppField
      FieldAlias = 'Kunde'
      FieldName = 'Kunde'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 1
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField3: TppField
      FieldAlias = 'Adresse'
      FieldName = 'Adresse'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 2
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField4: TppField
      FieldAlias = 'Adresse2'
      FieldName = 'Adresse2'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 3
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField5: TppField
      FieldAlias = 'PostNr'
      FieldName = 'PostNr'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 4
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField6: TppField
      FieldAlias = 'Sted'
      FieldName = 'Sted'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 5
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField7: TppField
      FieldAlias = 'Dato'
      FieldName = 'Dato'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 6
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField8: TppField
      FieldAlias = 'Betalingsfrist'
      FieldName = 'Betalingsfrist'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 7
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField9: TppField
      FieldAlias = 'Rabatt'
      FieldName = 'Rabatt'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 8
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField10: TppField
      FieldAlias = 'Status'
      FieldName = 'Status'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 9
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField11: TppField
      FieldAlias = 'Pris'
      FieldName = 'Pris'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 10
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField12: TppField
      FieldAlias = 'Merk'
      FieldName = 'Merk'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 11
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField13: TppField
      FieldAlias = 'Tekst'
      FieldName = 'Tekst'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 12
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField14: TppField
      FieldAlias = 'FakturaRef'
      FieldName = 'FakturaRef'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 13
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField15: TppField
      FieldAlias = 'Purringer'
      FieldName = 'Purringer'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 14
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField16: TppField
      FieldAlias = 'Varsel'
      FieldName = 'Varsel'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 15
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField17: TppField
      FieldAlias = 'Forfallt'
      FieldName = 'Forfallt'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 16
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField18: TppField
      FieldAlias = 'DinRef'
      FieldName = 'DinRef'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 17
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField19: TppField
      FieldAlias = 'MinRef'
      FieldName = 'MinRef'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 18
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField20: TppField
      FieldAlias = 'Rentesats'
      FieldName = 'Rentesats'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 19
      Searchable = False
      Sortable = False
    end
    object FakturaJournalPipeppField21: TppField
      FieldAlias = 'Gebyr'
      FieldName = 'Gebyr'
      FieldLength = 0
      DataType = dtNotKnown
      DisplayWidth = 0
      Position = 20
      Searchable = False
      Sortable = False
    end
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
    Left = 68
    Top = 199
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
        Caption = 'Fordring Journal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 24
        Font.Style = []
        Transparent = True
        mmHeight = 9737
        mmLeft = 1058
        mmTop = 1058
        mmWidth = 61807
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
        mmLeft = 80433
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
        mmLeft = 106892
        mmTop = 35983
        mmWidth = 16404
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
        mmLeft = 139171
        mmTop = 35983
        mmWidth = 6085
        BandType = 0
      end
      object ppLabel7: TppLabel
        UserName = 'Label7'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Forfall'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 162984
        mmTop = 35983
        mmWidth = 10054
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
        mmWidth = 60854
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
        mmLeft = 80433
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
        Transparent = True
        mmHeight = 4233
        mmLeft = 107156
        mmTop = 794
        mmWidth = 17198
        BandType = 4
      end
      object nBetalt: TppLabel
        UserName = 'nBetalt'
        OnGetText = nBetaltGetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'nBetalt'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4233
        mmLeft = 168275
        mmTop = 0
        mmWidth = 11113
        BandType = 4
      end
      object ppLabel9: TppLabel
        UserName = 'Label9'
        OnGetText = ppLabel9GetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Label9'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 139436
        mmTop = 529
        mmWidth = 10848
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 13758
      mmPrintPosition = 0
      object ppLine1: TppLine
        UserName = 'Line1'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Weight = 0.750000000000000000
        mmHeight = 1852
        mmLeft = 1058
        mmTop = 0
        mmWidth = 197115
        BandType = 8
      end
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
        mmLeft = 1588
        mmTop = 2646
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
        mmLeft = 34396
        mmTop = 2646
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
        Caption = 'Totalt utest'#229'ende:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4233
        mmLeft = 118004
        mmTop = 2646
        mmWidth = 47625
        BandType = 8
      end
      object ppLabel1: TppLabel
        UserName = 'Label1'
        OnGetText = ppLabel1GetText
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Border.Weight = 1.000000000000000000
        Caption = 'Label1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 4233
        mmLeft = 166423
        mmTop = 2646
        mmWidth = 10848
        BandType = 8
      end
      object ppLabel2: TppLabel
        UserName = 'Label2'
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
        mmLeft = 52123
        mmTop = 2646
        mmWidth = 32015
        BandType = 8
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
        mmLeft = 84931
        mmTop = 2646
        mmWidth = 10848
        BandType = 8
      end
    end
  end
  object RzFormState1: TRzFormState
    RegIniFile = RzRegIniFile1
    Left = 254
    Top = 121
  end
  object RzRegIniFile1: TRzRegIniFile
    Path = 'software\jurasoft\raptor'
    PathType = ptRegistry
    Left = 284
    Top = 121
  end
  object LiveDataDS: TDataSource
    AutoEdit = False
    DataSet = LiveQuery
    Left = 486
    Top = 137
  end
  object LiveQuery: TVolgaQuery
    Database = AppData.dbase
    IndexFieldNames = 'dato'
    ReadOnly = True
    SortOptions = [vsoCaseInsensitive, vsoDescendSort]
    Version = 'VolgaDB Engine v5.10'
    SQL.Strings = (
      'select * from faktura where status=1')
    QueryDatasets = <>
    Left = 486
    Top = 109
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
end
