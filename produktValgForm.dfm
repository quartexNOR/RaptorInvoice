object frmVelgProdukt: TfrmVelgProdukt
  Left = 311
  Top = 152
  ActiveControl = ANavn
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Legg til produkt / tjeneste for faktura'
  ClientHeight = 429
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 393
    Width = 437
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      437
      36)
    object Label2: TLabel
      Left = 3
      Top = 13
      Width = 236
      Height = 14
      Caption = 'Velg et produkt fra listen, eller skriv tekst manuelt'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object RzButton1: TRzButton
      Left = 276
      Top = 6
      FrameColor = 7617536
      Action = DoAdd
      Anchors = [akTop, akRight]
      Color = 15791348
      HotTrack = True
      TabOrder = 0
    end
    object RzButton2: TRzButton
      Left = 360
      Top = 6
      FrameColor = 7617536
      Action = DoClose
      Anchors = [akTop, akRight]
      Color = 15791348
      HotTrack = True
      TabOrder = 1
    end
  end
  object RzGroupBox1: TRzGroupBox
    Left = 0
    Top = 133
    Width = 437
    Height = 260
    Align = alClient
    Caption = 'Produkt register'
    TabOrder = 1
    DesignSize = (
      437
      260)
    object Grid: TdxDBGrid
      Left = 8
      Top = 16
      Width = 421
      Height = 235
      Bands = <
        item
        end>
      DefaultLayout = True
      HeaderPanelRowCount = 1
      SummaryGroups = <>
      SummarySeparator = ', '
      Color = clWhite
      TabOrder = 0
      OnClick = GridClick
      DataSource = AppData.ProdukterDs
      Filter.Criteria = {00000000}
      LookAndFeel = lfFlat
      OptionsBehavior = [edgoAnsiSort, edgoAutoSearch, edgoAutoSort, edgoDragScroll, edgoEditing, edgoEnterShowEditor, edgoImmediateEditor, edgoTabThrough, edgoVertThrough]
      OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoConfirmDelete, edgoUseBookmarks]
      OptionsView = [edgoAutoWidth, edgoBandHeaderWidth, edgoRowSelect, edgoUseBitmap]
      Anchors = [akLeft, akTop, akRight, akBottom]
      object GridColumn1: TdxDBGridColumn
        Width = 147
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Tittel'
      end
      object GridColumn2: TdxDBGridColumn
        Width = 151
        BandIndex = 0
        RowIndex = 0
        FieldName = 'Type'
      end
      object GridColumn4: TdxDBGridColumn
        Caption = 'Ut pris'
        MinWidth = 60
        Width = 112
        BandIndex = 0
        RowIndex = 0
        FieldName = 'UtPris'
      end
    end
  end
  object RzGroupBox2: TRzGroupBox
    Left = 0
    Top = 0
    Width = 437
    Height = 129
    Align = alTop
    Caption = 'Tekst beskrivelse'
    TabOrder = 0
    object lbProdukt: TRzLabel
      Left = 8
      Top = 18
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = ' Produkt '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object RzLabel1: TRzLabel
      Left = 8
      Top = 48
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pris '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object RzLabel2: TRzLabel
      Left = 196
      Top = 48
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Antall '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object RzSeparator1: TRzSeparator
      Left = 102
      Top = 82
      Width = 277
      ShowGradient = True
      Color = clBtnFace
      ParentColor = False
    end
    object RzLabel3: TRzLabel
      Left = 8
      Top = 96
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Rabatt % '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object RzLabel4: TRzLabel
      Left = 196
      Top = 96
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'MVA '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object ARabatt: TRzDBNumericEdit
      Left = 100
      Top = 96
      Width = 90
      Height = 22
      DataSource = AppData.FaturaDataDs
      DataField = 'Rabatt'
      Alignment = taLeftJustify
      FrameController = AppData.FrameController
      MaxLength = 2
      TabOrder = 3
      AllowBlank = False
      Max = 50.000000000000000000
      DisplayFormat = ',0;(,0)'
    end
    object nMva: TRzComboBox
      Left = 289
      Top = 96
      Width = 89
      Height = 22
      Style = csDropDownList
      Ctl3D = False
      FrameController = AppData.FrameController
      ItemHeight = 14
      ParentCtl3D = False
      TabOrder = 4
      Items.Strings = (
        '25%'
        '14%'
        '08%'
        '0%')
    end
    object AAntall: TRzDBNumericEdit
      Left = 289
      Top = 48
      Width = 90
      Height = 22
      DataSource = AppData.FaturaDataDs
      DataField = 'Antall'
      Alignment = taLeftJustify
      FrameController = AppData.FrameController
      TabOrder = 2
      AllowBlank = False
      IntegersOnly = False
      DisplayFormat = ',0;(,0)'
    end
    object APris: TRzDBNumericEdit
      Left = 100
      Top = 48
      Width = 90
      Height = 22
      DataSource = AppData.FaturaDataDs
      DataField = 'Pris'
      Alignment = taLeftJustify
      FrameController = AppData.FrameController
      TabOrder = 1
      AllowBlank = False
      IntegersOnly = False
      DisplayFormat = ',0;(,0)'
    end
    object ANavn: TRzDBEdit
      Left = 100
      Top = 18
      Width = 281
      Height = 22
      DataSource = AppData.FaturaDataDs
      DataField = 'Produkt'
      FrameController = AppData.FrameController
      MaxLength = 64
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 129
    Width = 437
    Height = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
  end
  object ActionList1: TActionList
    Left = 288
    Top = 235
    object DoAdd: TAction
      Caption = 'Legg til'
      OnExecute = DoAddExecute
    end
    object DoClose: TAction
      Caption = 'Lukk'
      ShortCut = 27
      OnExecute = DoCloseExecute
    end
  end
end
