inherited frmFaktura: TfrmFaktura
  Left = 276
  Top = 110
  Caption = 'Faktura'
  ClientHeight = 603
  ClientWidth = 703
  Constraints.MaxWidth = 0
  OldCreateOrder = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  inherited RzSeparator1: TRzSeparator
    Width = 703
  end
  object RzGroupBox1: TRzGroupBox [1]
    Left = 0
    Top = 73
    Width = 703
    Height = 258
    Align = alTop
    Caption = 'Kunde informasjon'
    TabOrder = 1
    DesignSize = (
      703
      258)
    object Label7: TLabel
      Left = 344
      Top = 200
      Width = 30
      Height = 14
      Alignment = taCenter
      Caption = 'Dager'
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentColor = False
      ParentFont = False
      Transparent = True
      Layout = tlCenter
    end
    object lbFakturaDato: TRzLabel
      Left = 6
      Top = 196
      Width = 91
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Faktura dato '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object lbBetalingsfrist: TRzLabel
      Left = 212
      Top = 196
      Width = 69
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Betalt innen '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object lbMerknader: TRzLabel
      Left = 6
      Top = 228
      Width = 91
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Merknader '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object RzSeparator2: TRzSeparator
      Left = 12
      Top = 186
      Width = 379
      ShowGradient = True
      Color = clBtnFace
    end
    object nDato: TRzDBDateTimeEdit
      Left = 102
      Top = 196
      Width = 107
      Height = 24
      DataSource = AppData.FakturaDs
      DataField = 'Dato'
      FrameController = AppData.FrameController
      TabOrder = 0
      EditType = etDate
    end
    object nFrist: TRzDBNumericEdit
      Left = 286
      Top = 196
      Width = 53
      Height = 22
      DataSource = AppData.FakturaDs
      DataField = 'Betalingsfrist'
      Alignment = taLeftJustify
      AutoSize = False
      FrameController = AppData.FrameController
      MaxLength = 2
      TabOrder = 1
      Max = 90.000000000000000000
      DisplayFormat = ';'
    end
    object nMerk: TRzDBEdit
      Left = 102
      Top = 228
      Width = 289
      Height = 22
      DataSource = AppData.FakturaDs
      DataField = 'Merk'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      FrameController = AppData.FrameController
      ParentFont = False
      TabOrder = 2
    end
    object RzGroupBox2: TRzGroupBox
      Left = 400
      Top = 36
      Width = 295
      Height = 63
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Kunde funksjoner'
      TabOrder = 3
      object RzBitBtn1: TRzBitBtn
        Left = 6
        Top = 19
        Width = 130
        Height = 33
        Action = DoSelectKunde
        Caption = 'Velg kunde fra register'
        Color = 15791348
        HighlightColor = 16026986
        HotTrack = True
        HotTrackColor = 3983359
        TabOrder = 0
        ImageIndex = 2
      end
      object RzBitBtn2: TRzBitBtn
        Left = 156
        Top = 19
        Width = 130
        Height = 33
        Action = DoRegisterKunde
        Caption = 'Registrer ny kunde'
        Color = 15791348
        HighlightColor = 16026986
        HotTrack = True
        HotTrackColor = 3983359
        TabOrder = 1
        ImageIndex = 3
      end
    end
    object RzGroupBox3: TRzGroupBox
      Left = 400
      Top = 106
      Width = 295
      Height = 71
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Referanser'
      TabOrder = 4
      object RzLabel1: TRzLabel
        Left = 8
        Top = 41
        Width = 89
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'V'#229'r referanse '
        Layout = tlCenter
        BlinkColor = clRed
        BorderOuter = fsFlatRounded
        BorderSides = [sdRight, sdBottom]
        TextStyle = tsRaised
      end
      object RzLabel2: TRzLabel
        Left = 8
        Top = 14
        Width = 89
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Deres referanse '
        Layout = tlCenter
        BlinkColor = clRed
        BorderOuter = fsFlatRounded
        BorderSides = [sdRight, sdBottom]
        TextStyle = tsRaised
      end
      object nMinRef: TRzDBEdit
        Left = 102
        Top = 41
        Width = 185
        Height = 22
        DataSource = AppData.FakturaDs
        DataField = 'DinRef'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        FrameController = AppData.FrameController
        ParentFont = False
        TabOrder = 1
      end
      object nDinRef: TRzDBEdit
        Left = 102
        Top = 15
        Width = 185
        Height = 22
        DataSource = AppData.FakturaDs
        DataField = 'MinRef'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        FrameController = AppData.FrameController
        ParentFont = False
        TabOrder = 0
      end
    end
    object RzGroupBox4: TRzGroupBox
      Left = 400
      Top = 190
      Width = 295
      Height = 61
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Produkt funksjoner'
      TabOrder = 5
      object RzBitBtn3: TRzBitBtn
        Left = 6
        Top = 19
        Width = 130
        Height = 33
        Action = DoAddProduct
        Caption = 'Legg til produkt'
        Color = 15791348
        HighlightColor = 16026986
        HotTrack = True
        HotTrackColor = 3983359
        TabOrder = 0
        ImageIndex = 0
        Images = Large
      end
      object RzBitBtn4: TRzBitBtn
        Left = 156
        Top = 19
        Width = 130
        Height = 33
        Action = DoRemoveProduct
        Caption = 'Ta bort produkt'
        Color = 15791348
        HighlightColor = 16026986
        HotTrack = True
        HotTrackColor = 3983359
        TabOrder = 1
        ImageIndex = 1
        Images = Large
      end
    end
    object MottakerPages: TRzPageControl
      Left = 6
      Top = 18
      Width = 385
      Height = 163
      ActivePage = TabSheet2
      Color = 16119543
      FlatColor = 10263441
      ParentColor = False
      ShowFocusRect = False
      TabColors.HighlightBar = 1350640
      TabIndex = 0
      TabOrder = 6
      FixedDimension = 22
      object TabSheet2: TRzTabSheet
        Color = 16119543
        Caption = 'Faktura adresse'
        object lbKunde: TRzLabel
          Left = 9
          Top = 6
          Width = 89
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kunde '
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbAdresse: TRzLabel
          Left = 8
          Top = 32
          Width = 89
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Adresse  1 '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbAdresse2: TRzLabel
          Left = 8
          Top = 58
          Width = 89
          Height = 24
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Adresse  2 '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbPostNr: TRzLabel
          Left = 8
          Top = 84
          Width = 89
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Post nummer '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbSted: TRzLabel
          Left = 6
          Top = 110
          Width = 91
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sted '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object nFirma: TRzDBEdit
          Left = 102
          Top = 5
          Width = 259
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Kunde'
          FrameController = AppData.FrameController
          TabOrder = 0
        end
        object nAdresse: TRzDBEdit
          Left = 102
          Top = 31
          Width = 259
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Adresse'
          FrameController = AppData.FrameController
          TabOrder = 1
        end
        object nAdresse2: TRzDBEdit
          Left = 102
          Top = 57
          Width = 259
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Adresse2'
          FrameController = AppData.FrameController
          TabOrder = 2
        end
        object nPostNr: TRzDBEdit
          Left = 102
          Top = 83
          Width = 105
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'PostNr'
          FrameController = AppData.FrameController
          TabOrder = 3
          OnExit = nPostNrExit
        end
        object nSted: TRzDBEdit
          Left = 102
          Top = 109
          Width = 105
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Sted'
          FrameController = AppData.FrameController
          TabOrder = 4
        end
        object Panel6: TPanel
          Left = 210
          Top = 113
          Width = 115
          Height = 18
          Alignment = taRightJustify
          BevelOuter = bvNone
          Caption = 'Auto fullf'#248'r er aktiv'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Trebuchet MS'
          Font.Style = []
          ParentColor = True
          ParentFont = False
          TabOrder = 5
          object Image3: TImage
            Left = 0
            Top = 0
            Width = 16
            Height = 18
            Hint = 'Autofullf'#248'r'
            Align = alLeft
            AutoSize = True
            Center = True
            Constraints.MinHeight = 16
            Constraints.MinWidth = 16
            ParentShowHint = False
            Picture.Data = {
              07544269746D617086010000424D860100000000000036000000280000000700
              00000E000000010018000000000050010000120B0000120B0000000000000000
              0000FF00FF9495952E2F2F262626282828707171FF00FF000000AEAFB07A7A7A
              BBBBBBABABAB9A9A9A6C6C6C777979000000434444E4E4E48D8D8D393A3A7575
              75A2A2A22C2C2C000000505151EEEEEE3C3D3D9CA7A9343434B2B2B22A2A2A00
              00005B5B5BEFEFEF3D3D3D3535352C2C2CBBBBBB2B2B2B000000909090EBEBEB
              494949FF00FF333333BABABA616161000000C4C4C4777777454545FF00FF2D2D
              2D4B4B4B8B8C8C000000C5C5C58B8B8B4B4B4BFF00FF2D2D2D7171718C8D8D00
              0000848585ECECEC535353FF00FF363636C1C1C1474747000000696A6AF0F0F0
              515151414242303030CBCBCB2D2D2D000000717171F1F1F1676767A6B2B43C3D
              3DD5D5D53031310000007F7F7FF2F2F2A8A8A86B6B6B868686E6E6E661626200
              0000BCBEBE9E9E9EF3F3F3F3F3F3F0F0F0A6A6A6989999000000FF00FFC2C3C3
              8E8F8F8282827E7E7EACADADFF00FF000000}
            ShowHint = True
            Transparent = True
          end
        end
        object cbLevere: TRzCheckBox
          Left = 212
          Top = 87
          Width = 149
          Height = 17
          Caption = 'Levere til samme adresse'
          Checked = True
          FrameColor = 8409372
          HighlightColor = 2203937
          HotTrack = True
          State = cbChecked
          TabOrder = 6
          Transparent = True
          OnClick = cbLevereClick
        end
      end
      object TabLevering: TRzTabSheet
        Color = 16119543
        Caption = 'Leveringsadresse'
        object lbLkunde: TRzLabel
          Left = 9
          Top = 6
          Width = 89
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kunde '
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbLAdresse1: TRzLabel
          Left = 8
          Top = 32
          Width = 89
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Adresse  1 '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbLAdresse2: TRzLabel
          Left = 8
          Top = 58
          Width = 89
          Height = 24
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Adresse  2 '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbLPostNr: TRzLabel
          Left = 8
          Top = 84
          Width = 89
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Post nummer '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object lbLSted: TRzLabel
          Left = 6
          Top = 110
          Width = 91
          Height = 23
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sted '
          Layout = tlCenter
          BlinkColor = clRed
          BorderOuter = fsFlatRounded
          BorderSides = [sdRight, sdBottom]
          TextStyle = tsRaised
        end
        object edLKunde: TRzDBEdit
          Left = 102
          Top = 5
          Width = 259
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Lev_kunde'
          FrameController = AppData.FrameController
          TabOrder = 0
        end
        object edLAdresse1: TRzDBEdit
          Left = 102
          Top = 31
          Width = 259
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Lev_addr1'
          FrameController = AppData.FrameController
          TabOrder = 1
        end
        object edLAdresse2: TRzDBEdit
          Left = 102
          Top = 57
          Width = 259
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Lev_addr2'
          FrameController = AppData.FrameController
          TabOrder = 2
        end
        object edLPostNnr: TRzDBEdit
          Left = 102
          Top = 83
          Width = 105
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Lev_postnr'
          FrameController = AppData.FrameController
          TabOrder = 3
          OnExit = edLPostNnrExit
        end
        object edLSted: TRzDBEdit
          Left = 102
          Top = 109
          Width = 105
          Height = 24
          DataSource = AppData.FakturaDs
          DataField = 'Lev_sted'
          FrameController = AppData.FrameController
          TabOrder = 4
        end
        object Panel2: TPanel
          Left = 210
          Top = 113
          Width = 115
          Height = 18
          Alignment = taRightJustify
          BevelOuter = bvNone
          Caption = 'Auto fullf'#248'r er aktiv'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Trebuchet MS'
          Font.Style = []
          ParentColor = True
          ParentFont = False
          TabOrder = 5
          object Image4: TImage
            Left = 0
            Top = 0
            Width = 16
            Height = 18
            Hint = 'Autofullf'#248'r'
            Align = alLeft
            AutoSize = True
            Center = True
            Constraints.MinHeight = 16
            Constraints.MinWidth = 16
            ParentShowHint = False
            Picture.Data = {
              07544269746D617086010000424D860100000000000036000000280000000700
              00000E000000010018000000000050010000120B0000120B0000000000000000
              0000FF00FF9495952E2F2F262626282828707171FF00FF000000AEAFB07A7A7A
              BBBBBBABABAB9A9A9A6C6C6C777979000000434444E4E4E48D8D8D393A3A7575
              75A2A2A22C2C2C000000505151EEEEEE3C3D3D9CA7A9343434B2B2B22A2A2A00
              00005B5B5BEFEFEF3D3D3D3535352C2C2CBBBBBB2B2B2B000000909090EBEBEB
              494949FF00FF333333BABABA616161000000C4C4C4777777454545FF00FF2D2D
              2D4B4B4B8B8C8C000000C5C5C58B8B8B4B4B4BFF00FF2D2D2D7171718C8D8D00
              0000848585ECECEC535353FF00FF363636C1C1C1474747000000696A6AF0F0F0
              515151414242303030CBCBCB2D2D2D000000717171F1F1F1676767A6B2B43C3D
              3DD5D5D53031310000007F7F7FF2F2F2A8A8A86B6B6B868686E6E6E661626200
              0000BCBEBE9E9E9EF3F3F3F3F3F3F0F0F0A6A6A6989999000000FF00FFC2C3C3
              8E8F8F8282827E7E7EACADADFF00FF000000}
            ShowHint = True
            Transparent = True
          end
        end
      end
    end
  end
  object RzPageControl1: TRzPageControl [2]
    Left = 0
    Top = 335
    Width = 703
    Height = 232
    ActivePage = TabSheet1
    Align = alClient
    Color = 16119543
    FlatColor = 10263441
    HotTrackColor = 3983359
    ParentColor = False
    TabColors.HighlightBar = 3983359
    TabIndex = 0
    TabOrder = 0
    FixedDimension = 22
    object TabSheet1: TRzTabSheet
      Color = 16119543
      ImageIndex = 1
      Caption = 'Bestilling'
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 699
        Height = 206
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        ParentColor = True
        TabOrder = 0
        object Panel1: TPanel
          Left = 520
          Top = 4
          Width = 9
          Height = 198
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
        end
        object RzGroupBox5: TRzGroupBox
          Left = 529
          Top = 4
          Width = 166
          Height = 198
          Align = alRight
          Caption = 'Sammenregning'
          TabOrder = 1
          Transparent = True
          object eksmva: TRzStatusPane
            Left = 7
            Top = 74
            Width = 153
          end
          object inkmva: TRzStatusPane
            Left = 7
            Top = 114
            Width = 153
          end
          object Label1: TLabel
            Left = 9
            Top = 58
            Width = 48
            Height = 16
            Caption = 'Eks. mva:'
            Transparent = True
          end
          object Label2: TLabel
            Left = 9
            Top = 98
            Width = 47
            Height = 16
            Caption = 'Ink. mva:'
            Transparent = True
          end
          object Label3: TLabel
            Left = 9
            Top = 18
            Width = 52
            Height = 16
            Caption = 'Total mva:'
            Transparent = True
          end
          object mva: TRzStatusPane
            Left = 7
            Top = 34
            Width = 153
          end
          object Label4: TLabel
            Left = 9
            Top = 140
            Width = 49
            Height = 16
            Caption = 'Rabatter:'
            Transparent = True
          end
          object lbRabatter: TRzStatusPane
            Left = 7
            Top = 156
            Width = 153
          end
        end
        object RzDBGrid1: TRzDBGrid
          Left = 4
          Top = 4
          Width = 516
          Height = 198
          Align = alClient
          DataSource = AppData.FaturaDataDs
          DefaultDrawing = True
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 2
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Trebuchet MS'
          TitleFont.Style = []
          FrameController = AppData.FrameController
          FixedLineColor = 12164479
          LineColor = clInactiveCaption
          QuickCompare.FieldValue = 1
          AltRowShading = False
          AltRowShadingFixed = False
          Columns = <
            item
              Expanded = False
              FieldName = 'Produkt'
              Width = 130
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Pris'
              Title.Caption = 'Stk. pris'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Antall'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'EksMva'
              Title.Caption = 'Eks. mva'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'InkMva'
              Title.Caption = 'Ink. mva'
              Width = 80
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'Rabatt'
              Width = 40
              Visible = True
            end>
        end
      end
    end
    object TabSheet3: TRzTabSheet
      Color = 16119543
      ImageIndex = 1
      Caption = 'Notater'
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 699
        Height = 206
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        ParentColor = True
        TabOrder = 0
        object nBeskrivelse: TRzDBMemo
          Left = 4
          Top = 4
          Width = 691
          Height = 198
          Align = alClient
          DataField = 'Tekst'
          DataSource = AppData.FakturaDs
          ScrollBars = ssVertical
          TabOrder = 0
          FrameController = AppData.FrameController
        end
      end
    end
  end
  object Panel3: TPanel [3]
    Left = 0
    Top = 331
    Width = 703
    Height = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
  end
  inherited RzPanel1: TRzPanel
    Width = 703
    TabOrder = 3
    inherited Image2: TImage
      Picture.Data = {
        07544269746D617036300000424D363000000000000036000000280000004000
        000040000000010018000000000000300000120B0000120B0000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFEF0
        DFF8FFFFFFFEFFFEFEFFFFFAFDFBFBF6F9FEF7FDF8F7FDF8F7FDF8F7FDF8F7FD
        F8F7FDF8F8FEF9F8FEF9FEFDF9FEFDF9FEFCFBFEFCFBFEFCFBFEFCFCFEFCFCFE
        FCFCFFFEF9FFFEFAFFFEFAFFFEFAFFFDFCFFFDFCFFFCFDFFFCFDFEFCFBFEFCFB
        FEFCFBFEFCFCFEFCFCFEFBFDFDFAFCFDFAFCFFFDF8F6FBFFF1F7FFFFFCFBFFFF
        FCF9F9FFF7F7FDFFFFFBFFFEF4F0FAFFF3F8FFFFFFF2FBFFFCFFFEFFFFFEFEF4
        FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDF6FFFFF1
        EDFBFFF9E7D0DBD0C2D2CBC2CBCBCBCAD1DADDCFC9DDCFC9DDCFC9DDCFC9DDCF
        C9DDCFC9DED0CADED0CAD4CFC6D4CFC6D4CEC7D4CEC7D4CEC9D3CDC8D3CDC8D3
        CCC9D6CFC6D6CFC6D6CFC6D6CEC7D6CEC7D5CCC8D5CCC8D5CCC8D4CEC9D4CEC9
        D4CEC9D4CEC9D4CDCAD3CCC9D3CBCBD3CBCBD8D0BFCCCDC9CACBC9D9D0C3DCD1
        C3CDC9C4D2CCC5E2D1BEF9E2C8F8FAFFFAFEFFFFFFF3F9FFFDFBFDFEFFFFFCF8
        FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7F5FFFFFFF7
        E8DFD1E49A3ACE811AD17C0ECE7600D17A06D07306D07306D07306D07306D073
        06D07306D07306D07306C77204C67103C67103C67104C57003C56F05C46E04C4
        6E04C66F01C66F01C66E02C56D01C56D01C46C02C46C02C46C02C16900C16900
        C06800C06700C06700BF6500BF6500BF6500C66007B95C0DB55809C25B04C35C
        06B7570BC7610ECE5900C0915EE3DBD4FBFEFFFFFEF6FAFFFFFAFFFFFFFFFBFD
        FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFEFFFFFFF8
        DCCAABDC830AEA9E34FCB95CF8B455F3B45AE7AF60E7AF60E7AF60E7AF60E7AF
        60E6AE5FE6AE5FE6AE5FEAAF60EAAF60E9AE5FE9AD61E8AC60E8AB61E8AB61E7
        AA60E6AA5EE6AA5EE5A95DE5A85EE4A75DE4A65FE3A55EE3A55EE6A65FE6A65F
        E6A560E5A45FE5A460E4A35FE4A35FE4A261E7A358E2A261E2A15DE9A258E6A1
        5BDD9E61EEA45CD87E1FA35911D8C7B4F8FDFCFFFDFAFAFDFFF6FFFFFFFEF6FF
        FAFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFEFEFDF3
        CFBD9ED48314F5D19BFFFFF7FCFFFBF4FFFFFBFFFEFBFFFEFBFFFEFBFFFEFAFF
        FDFAFFFDFAFFFDFAFFFDFFFFFEFFFFFEFFFFFEFFFFFFFFFFFFFFFEFFFEFDFFFE
        FDFFFDFFFFFDFFFFFDFEFFFDFEFFFCFCFFFCFCFFFCFCFFFCFBFFFBFDFFFBFDFF
        FBFDFFFBFCFFFBFCFFFBFBFFFAFAFFFAFAFFFEFDF9FBFFFFFDFFFFFFFFFBFDFF
        FFF6FCFFFFFBF4CBAF8DB35601E2CCB0F8FDFEFFFBFCFBFDFFF1FDFDFEFFF5FF
        FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFEFAFFFE
        D4C0A1D77F09F7D6A5FBFFFFF6F3EBF5F3EBFFF3DFFFF3DFFFF2DEFFF2DEFFF1
        DDFFF1DDFFF0DCFFF0DCFFF3DDFFF3DDFFF3DDFFF2DFFFF2DFFFF1E0FFF1E0FF
        F1E0FFF5E5FFF5E5FFF6E6FFF6E8FFF6E8FFF5E9FFF5E9FFF5E9FFF5EBFFF5EB
        FFF4ECFFF4ECFFF3EDFFF3EDFFF3EDFFF3EDFEF5ECFFF8F4FFF6F0FFF4EBFBF3
        F4FAF7FFFFFDEECD9F70C05800E3CEB3F0FBFFFFF9FFFFFCFFF0FFFBFDFFF7FF
        FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEF7F8FCFF
        D8C2A6D47906ECD1AFEAF7FFEEE8E1F2E7D9FEE6D4FEE6D4FDE5D3FCE4D2FCE4
        D2FBE3D1FBE3D1FAE2D0F2E4CEF2E4CEF2E3D0F3E4D1F4E4D3F4E4D3F5E5D4F5
        E5D5F2E7D9F2E7D9F3E8DAF3E7DBF4E8DCF5E9DFF5E9DFF5E9DFEEEBE3EFECE4
        EFECE4EFEBE6F0ECE7F1ECE9F1ECE9F1ECE9EFF4E5EBF2E5EEF0DDEFF0DCE4EE
        E8E7F5F4FFFFEDD1AC6EBE5400DDCDB6EDFDFFFFFCFFFFFCFFEFFFF7F9FFF6FF
        F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F8FDFF
        DCC4A8DB7800F9D5AFFFFEFFFFF3D1FFEEBDFDEBCCFDEBCCFDEBCCFCEACBFBE9
        CAFAE8C9FAE8C9FAE8C9FFE8C8FFE8C8FFE8CAFFE9CBFFEACEFFEBCFFFEBCFFF
        EBD1FBEAD0FBE9D2FCEAD3FDEBD4FDEAD5FEEBD6FFEBD9FFEBD9F2EBD8F2EBD8
        F3EBDAF4ECDBF5ECDEF6EDDFF6EDDFF7EEE1F3EEEFEFEAECF5ECE9FDF1EFEBEB
        F7E7EBFDFFFFF5D7A676BA4E00D8CDB9E9FDFFFFFAFFFFFCFFF3FFF8F8FFF5FF
        FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFDFFFF
        D7BE9ED77A05F2D2A9FBFEFFF8EBDBF9E8D3F4E7D1F9ECD2F8EDCDF8ECC8FCEE
        CAFCECC8FCEAC5FFEFCAFFE9C7FFE9C9FFE8CAFDE7CBFDE8CDFBE7CEFAE8D1FA
        E8D1FDE8D2FDE8D2FBE9D2FCE9D4FCE9D4FBEAD7FBEAD7FCEBD8F9EADAF8EBDB
        F8EBDDF9ECDEF7EBDFF8ECE0F6EDE0F6ECE2F6EDE3EBF1DEF8EBE9F5EBEBF8EE
        E4F3F3F3FAFFFBE1A178B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFDFFFF
        DAC1A1D87B06F2D2A9FBFEFFFAEDDDFFEED9FDEEDBFCEED8F9E9D2F8E7CCFCE9
        CEFEE9CEFCE7CCFDE5CDFFE9C9FFE9C9FFE7C9FDE7CBFCE7CCFBE7CEFCE8CFFA
        E8D1FDE8D2FDE8D2FDE8D2FCE9D4FCE9D4FBEAD7FBEAD7FBEAD7F9EADAFAEBDB
        F8EBDDF8EBDDF7EBDFF7EBDFF8ECE0F6EDE0F7EDE3EDF1DEF8EBE9F4EAEAF8EF
        E2F3F3F3FAFFFBE1A276B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFCFDFFFF
        DBC2A2D87B06F0D0A7F9FCFFFBEEDEFFF0DBFAEAD3F9E8D5FBE7D6FDE6D6FFE7
        D5FFE7D3FFE6D5FFE4D6FFE8CAFFE8CAFFE7C9FDE7CBFCE7CCFCE7CCFBE7CEFB
        E7CEFEE8CFFCE7D1FDE8D2FDE8D2FCE9D4FCE9D4FBEAD7FBEAD7F9EADAF9EADA
        F9EADAF8EBDDF9ECDEF7EBDFF7EBDFF8ECE0F6EDE0EDF2DDFAEBE9F4EAEAF8EF
        E2F2F2F2FAFFFBE0A175B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFBFCFEFF
        D8BF9FD67904F0D0A7FAFDFFFAEDDDFFEED9FFF6D4FFEED4FEE9DAFFE9DAFFE9
        D5FFEBD3FFE9D5FFE2D4FFE9CDFEE8CCFDE7CBFDE7CBFDE7CBFCE7CCFCE7CCFD
        E8CDFEE8CFFEE8CFFCE8CFFDE8D2FDE8D2FCE9D4FCE9D4FCE9D4F9E9D8F9EBD9
        F9EADAFAEBDBF8EBDDF9ECDEF7EBDFF7EBDFF6EDE0ECF1DCF9EAE7F3EAE7F9ED
        E1F4F2F1FBFFF9E2A175B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFCFEFF
        D6BD9DD67904F3D3AAFBFEFFFBEEDEFDECD7FDF7CAFBEDD0F8E5D6FBE6D7FFEC
        D1FFEFCCFFECCDFDE5CFFEE9CEFEE9CEFDE8CDFDE7CBFDE7CBFDE7CBFDE7CBFD
        E7CBFDE8CDFDE7CEFEE8CFFCE8CFFDE8D2FDE8D2FCE9D4FCE9D4F9E9D8F9E9D8
        F9E9D8F9EADAF9EADAF8EBDDF8EBDDF9ECDEF7ECDEEEF1DBFBEAE7F5E9E7F9EE
        E0F3F1F0FAFFF8E1A073B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFFFF
        D8BF9FD77A05F3D3AAFBFEFFFCEFDFFFEED9F1EDC4FDF0DAFFEDEAFFECE5FFF1
        D7FCEFC9FBEBC7FFECD3FDE9D0FDE9D0FEE9CEFDE8CDFDE7CBFFE7C9FFE7C9FF
        E8CAFEE7CDFEE7CDFDE8CDFEE8CFFCE8CFFDE8D2FDE8D2FBE9D2FAE9D6F9E9D8
        F9E9D8F9E9D8F9EADAFAEBDBF8EBDDF8EBDDF7ECDEEDF0DAFAEAE4F4E9E5FAED
        DFF5F2EEFCFFF7E3A073B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFFFF
        D8BF9FD47702ECCCA3F6F9FDF9ECDCFFF0DBF9F4DBF6E9E7E8D2E4E5CFDBF6E6
        D9FBF0D0F6EBCDFEEDD8FCEAD3FEEAD1FDE9D0FEE9CEFEE8CCFFE8CAFFE9C9FF
        E9C9FDE6CCFDE6CCFEE7CDFDE7CEFEE8CFFCE7D1FDE8D2FDE8D2FAE9D6FAE9D6
        F9E9D8F9E9D8F9EBD9F9EADAF9EADAF8EBDBF8EBDDEEF0DAFCE9E4F5E9E5FAED
        DDF4F1EDFBFFF6E2A070B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFAF9FDFFFF
        D7BE9ECF7200E3C39AEDF0F4F5E8D8FFF1DCF3EDE2CEBDCB977FA299829ED5C6
        C4FBF1D9F9EDD5F6E6D9FDEBD4FCEAD3FDE9D0FEE9CEFFE9CDFFE8CAFFE9C9FF
        E9C7FDE7CBFDE6CCFEE7CDFDE8CDFEE8CFFEE8CFFDE8D2FDE8D2FAE9D6FAE9D6
        FAE9D6F9E9D8F9E9D8F9EADAF9EADAFAEBDBF8EBDDEEF1D8FCE9E4F5E9E5FAED
        DDF4F1EDFBFFF6E2A070B75001DAC7B8FFFAFFFFFFF8F8FDFCFFFBFFF8FFFCFF
        FFFEFCFBFFFBF7FFFBFFE6F2FBF8F6FEFFF6FFF5FBF6FFFAFFEDFBFFFBFFF6FA
        D8C0AC514D585949BE9E98CFDDDFB1FBEBBCD9E4CA3E2CFB0F17FF2020EEA5B0
        9CFFDECFFFEED8F8F9BBF8D8D2F8E8BAF1EAD1DEE6CFEFF8BFFFE0D7FFECB9F3
        E2C7FFE8C9FFE8CAFFE8CAFDE6CCFDE7CEFBE6D0FAE7D2FAE7D2FDE8D2FDE8D2
        FBE9D2FCE9D4FCE9D4FBEAD7FBEAD7FCEBD8FBEBDBEFEED4FCEADFF8ECE2F8ED
        D9F2F1EDFAFFFBDD9C75B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDFDFFF8FDFFF4FCFFEFFDFCFFFFFDFFFCF7F9FFF8FFFFFFF2F7FFFFFFFFEF
        BFBAB9362BCF2734FF1C1FF3626BB4C6CBCA736DDA2E38FF4490FF1024ED6F61
        BFEDDDB2F9EDD1ADAACA756FBCA298A8E2E1AFF4E7D9FCE8D6FFE2D2FFF2CBFF
        E4E5FFE8CAFFE8CAFFE7CBFDE6CCFCE6CDFBE6D0FCE7D1FAE7D2FDE8D2FDE8D2
        FDE8D2FCE9D4FCE9D4FBEAD7FBEAD7FBEAD7FDEADBEFEED4FCEADFF8ECE2F8ED
        D9F2F1EDFAFFFBDD9C75B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDFAFAFFFDFDFFFFFAFFFFFDFFFFFAFFFFF8FCFFFFEEFCFFE9F6FDF6FFFFF5
        A8AAB4273FDF43C0EC1463FF193DD7454DBE1E23F0317CFF4DD5FF1255FF3C42
        D18A8EA16A5DD7251EF50010FF3822DFC3BBA4FFE9C9FFEBD1FFEFBBFFEDC9F9
        DBDAFFE8CAFFE8CCFFE7CBFDE6CCFCE7CCFCE6CDFBE6D0FBE6D0FEE8CFFCE7D1
        FDE8D2FDE8D2FCE9D4FCE9D4FBEAD7FBEAD7FDEBDAF0ECD3FEEADFF7EBE1F7EC
        D8F1F0ECFBFFFBDD9C75B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDFDFDFFFDF2FFFFFCFFFFFEF6FFF3FFFFFDFFD9EDE8AAC2E0D1D9EAFEFBE6
        9894B71C28FF52EFF930C2FF1F71FF0C17FF155EEE38D3FA1DD5FD179CFF001B
        E6131DE60D32F81579FD0368FF1E1DF5C3BBAAFFE9C8FFE2E0FFEFD0FBE5DAF8
        EDD2FFE8CEFEE7CDFDE6CCFDE6CCFDE6CCFCE7CCFCE6CDFDE7CEFEE8CFFEE8CF
        FCE8CFFDE8D2FDE8D2FCE9D4FCE9D4FCE9D4FCEAD9F0EDD1FDEADDF9EBDFF9EC
        D6F3F0EBFAFFF8DE9C73B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDFAFFEDFAF7FFFDFFEDFFFFFCFFFBFFD6E4F74E5FCD1F48C73151B46571B1
        4A4DAF1632FF46E2FF27DCFC2DC8F92392FE25BAEC1FD9FF00CFF917DEF80053
        F30869FF21B3FF2CFDF90E7EF6241CF5D9C4C6FFEED2FFE6E3FFF5CBF5E6C5FC
        F0C6FEE8CFFEE8CFFDE8CDFDE6CCFDE6CCFDE6CCFDE6CCFDE6CCFDE8CDFDE7CE
        FEE8CFFCE8CFFDE8D2FDE8D2FCE9D4FCE9D4FDE9D8F0ECD0FFE9DDF8EADEF8EB
        D5F2EFEAFCFFF8DE9C73B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDFFFEFFFDFFFEFBFFEEFCF4FFFDFFF1BCD7E12037E13376FF1677FF1548FC
        0A38E30062EC1ED0FF08C3FF1BD7FF1ADBFD1DD7FF04CAFE02D6FF0ADBFF0DC7
        FF22EEE91EE7FF10ECFE1E73E72F2FD5BBB9AFD5CDB0CFC7C0DAD8AFEFE4ABFF
        E6D3FDE8D2FDE8D2FEE8CFFDE8CDFDE6CCFFE7CBFFE7CBFFE8CAFEE7CDFEE7CD
        FDE8CDFEE8CFFCE8CFFDE8D2FDE8D2FBE9D2FDE9D7F0ECCFFEE9DAFAEADDF9EB
        D4F3F0E8FBFFF6DF9A72B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDF9F5FFFBFBFFFDFFFFFFF9FFFFFFF0D0E5E7395FD5408EFF3FFFFF2BCDFF
        1EB9F808B6FF08DAFE03CFFF08D9FB01D1FF05CFFF0BE0EE10DFF900C1FF10D8
        FF0CE4F712D4FF26E8FA0D44FF0409EE3433CF3136C73834D95543C0B8AFA5F8
        E0C8FCE9D4FEE9D3FDE8D2FEE8CFFEE7CDFFE8CCFFE8CAFFE8CAFDE6CCFDE6CC
        FEE7CDFDE7CEFEE8CFFCE7D1FDE8D2FDE8D2FFE9D7EFEBCEFFE9DAF9E9DCF8EA
        D3F2EFE7FDFFF6DF9B70B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDFFFFE7FBF9FFFFFCFEFFFFEBFFF9FFF6F7FF5F8FC91756F41BFBF019DBFF
        1CEEFF01E1FE00EAE311D9FF13DDF40BDEF800CEFF17E3FF17D4FA1BEEEB0AE3
        F60BDAFF2EECF942D7FF2A95FF2064FF2261FF1C69FB1846FF1404F58D8AC1DD
        D8C9FDEAD5FCE9D4FDE8D2FEE8CFFFE8CEFFE8CAFFE8CAFFE8C9FDE7CBFDE6CC
        FEE7CDFDE8CDFEE8CFFEE8CFFDE8D2FDE8D2FEE8D6F1EBCEFFE9DAF9E9DCF8EA
        D3F2EFE7FDFFF6DF9B70B34A01DCC8BDFEF8FFFFFFF9FAFFFEFFFBFFFAFFFEFF
        FEFDEEF8FFFFF7FFFFF0FFFFFDF3FFFEF0FBFAF09FAAC82F27F632C0F547EAFF
        28E4FF15DBF819DDFB15D8FA15DEFF0EDFFF10DCFF12DDFE16DDFE1ADDFF22DF
        FF27E0FF2CE1FF2FE2FF3DE7FF4CFFF84DF0FF63F7FF2B6EF9271BEFB1B2CEF5
        E0E2F8E7D2FBEBD4FBE9D2FFECD3FFEACFFBE5C9FFECCDFFEACCFFE8C9FFE8CA
        FFE8CAFDE6CCFDE7CEFBE6D0FAE7D2FAE7D2FEE6D2F7EECDFFE7D3FEE8D6FEEB
        D0F4EEE7FBFFFCD89875B33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFF4FFF9FFFFFBFFFDFFC7DFD76E8AB33A4ABB2345D80027F61AB0DF30D8FF
        24DEFF1FE2FE27E7FF23E0FF1CE0FF0FD9FF17DEFE19DEFE1DDEFF22DFFE28DF
        FF2EE1FF33E3FF34E4FF40E3FF36DCF95AFFF440A2FF1127EA7786B7FAFEBCFF
        EAD4FDECD7F9E8D3F8E6CFFFECD3FFEBD0FDE7CBFFECD0FEE6C8FFE8CAFFE8CA
        FFE7CBFDE6CCFCE6CDFBE6D0FCE7D1FAE7D2FEE6D2F7EECDFFE6D2FEE8D6FEEB
        D0F4EEE7FBFFFCD79774B33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFFBFFFFFFFFFBDDF8DE4A5DCC243BFF3D80FF2995FB2FC4FF38D7FD3EE8FF
        2DE3FF28E4FD2CE3FD2ADEFB2CE3FF24E1FF27E2FE27E2FE2BE1FE2FE2FD35E4
        FF3AE4FF3DE6FF40E7FF40EDF552F3FF57DEFE0B37FF262BDAB4CAB1FCE7CBFF
        E7D1FEEFDCFBEAD5F6E5D0FEECD5FEEAD1FEE9CEFFEDD1FCE6CAFFE8CAFFE8CC
        FFE7CBFDE6CCFCE7CCFCE6CDFBE6D0FBE6D0FFE6D2F6EDCCFFE5D2FEE9D4FDEB
        CEF4EFE6FBFFFBD79774B33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFFFF5FFFAFEF3DFE8FF443DFC3F69FE88FDFF72FFFF50EEFE45EAFF42ECFF
        3AE5FD3BE7FD3BE6FC3AE2FA40E8FF3AE3FE3CE6FE3CE6FE40E6FD43E7FE47E8
        FE4AE8FF4FEAFF50EBFF47E1FE67FFFA3FABF9000AFA161DD87181AFA6A1B0DE
        D3BDEFDFCEFDEEDBFCEBD8FBE8D3FFEAD4FFE9D0FFECD1FFE9CFFFE8CEFEE7CD
        FDE6CCFDE6CCFDE6CCFCE7CCFCE6CDFDE7CEFEE6D0F7EDCBFFE5D0FFE7D3FFEA
        CEF5EEE5FDFFFBD89771B33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFFFFCFFFFF7FFF6FFF0A6C3C04D51E54261FC8BF1FD8DFFF94EEFFE4EEBFB
        51E8FC5AEFFF59EEFF56EBFF58EEFF55E9FA55EAFE55EAFE58EBFF59EBFD5EEB
        FE61EDFE64EEFF64EEFF6DFFEE6BFAEB79F2FF6CC7FF365FF7120BF62B25D65E
        72B9CFC0B0FAEAD9FFEFDEF8E7D4FFECD7FFEAD4FEE8CFFFEBD2FEE8CFFEE8CF
        FDE8CDFDE6CCFDE6CCFDE6CCFDE6CCFDE6CCFFE5D0F6ECCAFFE5D0FFE8D2FEE9
        CDF5EEE5FDFFF9D89771B33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFFFFFE7FFFFF2FFFFF8FFF9FFC3C8E73E4BCD4458FF8FDAFA69FBFF6CF4FF
        72EFFE76EFFF6FEFFF6CEFFD6EF0FD72F1FA70EFFE70EFFE72EFFE72EFFD75F0
        FE77F1FF78F2FE7BF3FF7CF2FE7AEDFF87F5FF87F6FE92FFF77DC1FF2C37FF02
        00F6C0B0A3F2E3D3FEEEDEF9E7D6FFEDDBFFEBD6FBE6D0FFE8D2FDE8D2FDE8D2
        FEE8CFFDE8CDFDE6CCFFE7CBFFE7CBFFE8CAFFE5CDF8ECC8FFE4CFFFE7D1FFEA
        CBF6EDE3FFFFF9D9966FB33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFFFFEFFF8FAFFF8F5FEFFF7FFF8FFF75F86CA0A2EF04E98FF72F4F47EF2F9
        8CEEFE8DEFFF87F1FF7DF0FD7CF0F785F3F785F2FF86F1FF86F2FE87F3FF89F3
        FE8AF4FF8CF5FF8DF6FF90F0FF90FDFF8CFCF48DFBEF96EEFF5A78FF1708F334
        2EDFDACABDF6E6D9FCECDCFBE9D8FFECDAFFECD7FFEBD6FEE7D1FCE9D4FEE9D3
        FDE8D2FEE8CFFEE7CDFFE8CCFFE8CAFFE8CAFFE5CDF7EBC7FFE4CDFFE7D1FEE9
        CAF6EDE3FFFFF8D9966FB33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFEFEEFFECFFEDF7F9FFFFFDE8887ACC1623F53AA4FC66F1FF87FEFD99FDFF
        A4F7FF9DF1FF95F4FF8BF5FF8AF5F997FCFE92F4FF92F4FF92F4FF93F4FE94F5
        FF95F7FF96F8FF96F8FF94FBF897FEFB8DE6FF5E9CFA191EF52506FF8484E2C5
        E1C3FEF0E4FFF1E4FCEBDEFBEBDBFAE8D7FEEAD8FFF1DCFDE8D3FDEAD5FCE9D4
        FDE8D2FEE8CFFFE8CEFFE8CAFFE8CAFFE8C9FFE5CDF7EBC7FFE4CDFEE6CEFEE9
        CAF6EDE3FFFFF8D9966FB33F04E0C9BAFEFAFFFBFFFBF8FFFFFFFEFFF7FFF8FF
        FCFFF6FFF3FFFAFFF1FFF86A82CE3243E67EACFFA8FAFF96FFF8B0E8FFA8FBFC
        9BFFF29AFFF4A1FBFBA2EBFFA8EFFFA1FDF2ABF0FFA8F6FFA0F5FFA6F9FFA4FA
        FF9EF9FEB0FDFFC1FAFBACFFFC99FAFF69C4FF0008FF2A23D2BAD49FF2E3E1FF
        EFF1FBEEDEFBEEDEFAEDDDFCEEDCFBEDDBFBECD9FAEBD8FAEBD8FDEAD5FDEAD5
        FEE9D3FDE8D2FEE8CFFEE8CFFDE7CEFEE7CDFFE4CFF9EBC7FFE4CAFFE7C9FFE9
        C5F9ECDEFFFFF6DD936FC43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFFFFBFFFFFFF4E2EFFD505BD55967F6BAD4FFD2F1FFD6F7FFC4F8FFC4FFF8
        A9F1FFA9EDFFBDFDFFC1FFF2BFF9FFB7F4FFB5FAF0B1FCFEA8F7FFA9F5FBADFA
        F3B2FFF6B7FFFFBAFBFFCEFFFAB1FAF89FFEFF417EFF1420E27686B4F1F5C1FF
        E8D1FCEFDFFBEEDEFBEEDEFCEEDCFBEDDBFAECDAFBECD9FAEBD8FDEAD5FDEAD5
        FCEAD3FEE9D3FDE9D0FEE8CFFDE7CEFDE7CEFFE5D0F9EBC7FFE5CAFFE7CBFFE9
        C5F9ECDEFFFFF6DD936FC43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFFFF6F9FFFEFCF1FBFF7A9CD14559E6372EFF3940EE4870E792A6F3C1FFEE
        B8FFF5B9F7FFC2ECFFC6F9F2C4F4FFC2FDF9C7FFFAC3FFFFC1FFFFC1FFFEC6FB
        F8CAFCFCBDFDFFACFDFFC0FFFBBEFFFAC3FFFF9EE3F24A54FF2D17E19EA6ADF2
        DDE0FAEFE1FAEFE1FBEEDEFAEDDDFCEEDCFBEDDBFAECDAFBECD9FEEBD6FEEBD6
        FDEAD5FEE9D3FDE8D2FFE9D0FEE8CFFEE8CFFFE5D0F8ECC8FFE5CCFFE8CCFFE9
        C5F7ECDEFFFFF7DD9371C43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFF6FFEDFAF4FFFFF2FFFAFFFEF4FCFBCDD4D79CB1CD2B2BDD7081F6B5F1FD
        BBFFFFBFFFF5C8FBFFD0FFF6CBFCFFC0FFFDD3F8FFC7F3FAC5FBF4CAFDF9D8F8
        FFDDF7FFC3F7FFA3FEFBA1F8FFB4F3FFC5F6FFCCFFF193B8FF2813FC6768ACDD
        DEC4FBF0E2FBF0E2FAEFE1FBEEDEFAEDDDFCEEDCFBEDDBFBEDDBFDECD9FCEBD8
        FEEBD6FDEAD5FEE9D3FDE8D2FDE9D0FFE9D0FFE6D2F9EDCBFFE5CCFFE8CCFFE9
        C6F7EBDFFFFFF7DA9270C43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFF2FDFFFFFFFBFFFFF8FFFFE5FFFFFBFFFBFFCAD4FC2F2BF697B7FFC1FCFF
        C0FFFFC0FFEDCBFEF7CEFAF3CEF7FFC8FFFAD6FDFFDBFAFFDCFFFFD2FFFFD3FB
        FAE2FCFCD6FFFFB3FFFF68A5FF2F39FB3328FF2E2AFF151BFC1400FF8C78E3FB
        EBC1FAF1E4F9F0E3FBF0E2FAEFE1FBEEDEFAEDDDFCEEDCFCEEDCFDECD9FDECD9
        FDECD9FEEBD6FDEAD5FEE9D3FEE9D3FDE8D2FFE7D3F9EDCBFFE5CEFEE7CDFFE9
        C6F5ECDFFFFEF9DA9171C43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFFFE9FFFFFFE9FBFFEAE7F5FFEFFFFFECFFF0749FBA2D54F3C9F7FECEFFFF
        C6F2FFC8E8FFE3FFFFDFF6FFD9F9FFD3FFF4CCFFEFE7FFFFE3FBFFC9FFFFC4FF
        F7E0FFF8E1FFFCBEFAF454A4FD030FDF5769C8868FE9859DD99EB3E0E1E8EBFF
        F2E4FBF2E5FAF1E4FAF1E4FBF0E2FAEFE1FBEEDEFBEEDEFAEDDDFCECDBFCEDDA
        FDECD9FDECD9FEEBD6FDEAD5FCEAD3FEE9D3FFE6D5F8EDCDFFE5CEFFE8CEFDE9
        C6F5EBE1FFFFF9D99271C43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFFFFFFFFEF3FFFFFEFFFDFFF9FFFFF5FFF2FF7362C36E79FFB0DDFF8DAAFF
        6878F35C56F1C0DBF0DEFDFADDFFF9D2FEFFC6FFFDECFFFDE4FBF7BEFFFFA5EF
        FFC1E3FFE8F8FFDBFAFD6EC6FF1713EE96A6B7F4ECEDFFFFF0FCFFE3EFF5EAEA
        E4FDFBF2E5FBF2E5FAF1E4F9F0E3FBF0E2FAEFE1FBEEDEFBEEDEFDEDDCFDEDDC
        FCEDDAFDECD9FCEBD8FEEBD6FDEAD5FDEAD5FFE7D6F8EDCDFFE6D1FEE8CFFDE8
        C8F5EBE1FFFEFAD99271C43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFF3FFF8FBF5FFFFFFEDFFFFF4FFF3FFFDFCFF4D6ACD083BFF2B36F22738E7
        223BCD1D15E4AAC4FFD6F8FFCAFFEFABECEDA1D1FFEAFCFBEDFFEDB0F9FF4C91
        F84553E1B2A9FFF3FFFFB0E3FF3209FE9794C2EFE0E8FFFAE7FFECEEFDEBECFF
        FCDBFAF1E7FBF2E5FBF2E5FAF1E4FBF0E2FAEFE1FCEFDFFBEEDEFDEDDCFDEDDC
        FCECDBFEEDDAFDECD9FEEBD6FDEAD5FDEAD5FFE7D6F9EECEFFE6D1FEE8CFFDE8
        C8F4EBE1FFFEFAD99173C43502D1C9BCF6FCFFFFFFFCF9FEFFFFFEFFFDFFF9FB
        FEFFFBFBFBFFFFFFFFFEFFFBFAFCFFFEFFFEFDFFDFDEE2B8B7BBCEB9EAFFFFE9
        B1BA9F352BB4898CFFE3FFFF7AE6FF364DFD2224F4D4CAFFE8FFFB9AEFF1294F
        F11816F22116FF2E37F2758AFF3124EA7572CEE0E8DDFDEAFFFDEFF1F9FFD2F0
        EDEFF9F2E9F8F1E8FAF1E7F9F0E6F9F0E3F8EFE2F8EFE2FAEFE1FBEDE1FEF0E4
        F7EDDCF8EEDCFCF3DFF7F0D7F4EDD2F5EFD2F3EADDF3E5CFFFF0D0FFE7CDFFDE
        CFEEF4E3FFFFEED08A79B42B0BDAC5B6F5FBFFF6FEFFFDFEFFFFFAFFFFFDFEFF
        FFF5FDFDFDFFFFFFFFFFFFFEFDFFFFFEFFFFFEFFFFFEFFF5F4F8FAF6FFFFFFF8
        C7C2A3351AAA6F94FFADE4F32847FF4339E74249DC5643F8E1FFFFA4DAFF051A
        EE85AAD0BAC3E96C77FF2A1BE8391AF3A196F7F4FFEBFFFBF2FFF6ECF8F8E0F4
        E6FFF9F2E9F9F2E9FAF1E7F9F0E6FAF1E4F9F0E3F8EFE2F8EFE2F6EADEF7ECDE
        F7EADAF6E9D9FAECD9F8EBD5F8EBD5FBEDD6FDE9DEFFE6D5FFEACEF2ECCFF6E8
        D6E5F1DFFFFEEBE88C7FBE300DE4C8B7FBFEFFF8FFFFF7FBFCFFF9FFFFFEFFFF
        FEF3FFFFFEFFFFFFFFFFFFFFFFFFFCFBFDFBFAFCFEFDFFFFFEFFF4FFF8FFFFE4
        D7BE96613E7E2430FF2635F0424AF1CED2DDB0D0F43F21FF7F79FF636FFF272B
        E1CCDDD9FFFCFCE2FDF4C1E0DDC9D7F3E7F3F9EFFBE5F4F0EFFDF5F5F9F8E4FA
        F5ECFAF3EAF9F2E9F9F2E9FAF1E7F9F0E6F9F0E3F9F0E3F8EFE2F8EFE1FBF0E2
        FEF1E1FDEDDDFCE8D7FDE6D6FFE6D6FFE6D5FFDDD3FFE4D5EFE4C6E0EACCFFE5
        D7F7EEE1FFFCE7D48271C6300BE5C3ACFFFBFAFAFFFFF6FFFCFFFCFFFBFEFFFF
        FFFBFFFFFEFDFEFCFDFDFDFFFFFFFFFFFFFFFEFFFEFDFFFFFEFFF1FFF5FFFEFF
        E1ABAA93671A4246D45F62FFCAD8F4FFFFEBE3FBFFACA0FA2F1EE41408F48275
        E3F7E9EDFFF1FFFFFFE6F2FFEBF2FFEFF4FDF3EEF6ECF5F8EFFBF7F6F6EFECFF
        F8EFF8F2EBF8F2EBFAF3EAF9F2E9FAF1E7F9F0E6FAF1E4F9F0E3F8F1E2FAEFE1
        FEEFDFF5E0D1EDD0C1F0CDBFEFC8B9F0C5B6F3C7BAFDCEB9CDCEAED7CDB5FFB6
        B0EECAC0F1F4DBC68A72C5320CE7C5ADFFFAF7FBFFFCF4FFFCFFFDFFF8FEFFFF
        FFFEFFFFFEFFFFFEFDFEFCFDFDFDFFFFFFFFFFFFFFFEFFFFFEFFFAFCFFFBF6FF
        EAADB1B86800BEB7A6F8FFFBFFFBFFF1FAF0F3F2FFFDFFF1929DE1848EFAE5E2
        FCFFFEF6FFFFF7FEEEFFFFEBFFF8F0FFF7F3FEF3F2FBF1F6EDF2F2ECF2EAF1FC
        F1F9F9F3ECF9F3ECF8F2EBFAF3EAF9F2E9FAF1E7F9F0E6F9F0E6FBF5E8F9F0E2
        F7E7D7E2C8B8D4B09ED9AB99D7A28EDAA08DD19F8BC8A185B1A785CDA892E395
        8ED2B8AAE8E2C5DD8066A72704E2C9B5FFFFFEFFFFFCF6FFFBFFFEFFF3FBFFFF
        FFFFFCFDF9FFFFFCFFFFFEFBFCFAFBFBFBFEFEFEFEFEFEFAF9FBFAF9FFF8F7F9
        E3B6A1D16101F5C5A3FFFFF4FFEFF3F1FFF2FFFEE7F0F9FDF8FFFBFBFFF9F3FF
        F7F1EBFCF9EEE6F8FFF5FBFFE2F7FFDAF6F9EAF5F0FFF6F1FFF8F9F7F7F7F1F3
        F1E9F8F4EFFAF4EDF9F3ECF8F2EBFAF3EAF9F2E9FAF1E7FAF1E7F2EEE3F6EDE0
        F5E2D3E1C3B0E4BAA3F8C3A8FFC1A3FFCAABFFD3B5FFD9B7FFDCB9FFDDC2FFEA
        D7FFFDE6FACBACD8492D9F3E24DCD6C9FFFEFFFFFDFCF7FFF8FFFDFFF8FEFFFF
        FEFFF9FAF6FEFFFBFFFFFCFFFFFEFFFFFEFFFFFFFFFFFFFFFFFFFAFFFCFFFFF9
        D4AEAEC55F00EFBF8FFFF4FFFFFFEDE9E9FFFFFFF4E7EBFDFFFFF4FFEBFAECF5
        F9F4FAFFFBF9F1F6FDF0F5F3F9FBFDF7FFFFF6FAF6FCF4EDFAF6F7EEF8FDEEF8
        F4FFF9F5F0F8F4EFFAF4EDF9F3ECF8F2EBF9F2E9F9F2E9F8F1E8F8F5EDFEF5EB
        F7E4D5DBBBA4E0B293F2B692EFAB80FFB486F7C09BFFCFA5FFD4ACF6D7B6FAEB
        D1F4BDA8C4593DA22C03DF9F8DE8F7F3F6FCFFFFFEFFFCFDF9FFFAFFFAFDFFFF
        FBFCFFFFFCFFFFFCFEFFFBFFFFFEFFFFFEFFFFFEFFFFFFFFFFFFF1FFF5FFFFF4
        CDB1B0B95C0DE9C89AEDE9FFFBFFE9FFFFF8E9FEF5FFF5FFFFFFF7FFF9F9FFFF
        EDE5EFF9EBFFF3FFEEFFF3F3FFF5F8FDF3F8E9F7F4EFFAF2FDF7FAEBF5FCE7F2
        EDFFF9F5F0F9F5F0F8F4EFF9F3ECF8F2EBFAF3EAF9F2E9F9F2E9EEEAE5FBF2E9
        F9E6D7E2C0A8EFBF9DFFC498FAB381FFBD88FBC69BFCD2A3FFDDB0F6E1BBF1CE
        B4D75548B21F05DBAB71FFF9EEE4FFFFE6F0FFFFFCFFFFFFFCFFF9FFFDFDFFFF
        FEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFAFFF9
        D0B8A2C25902E9BF9AFCFDFBFFFBF8E3A574EDC3A4FCFAF9FCFAF9EDC3A4DF95
        5BE4A473DB8543ECC3A4E4A473FDF9F8DD8D4FF8E9DFDF945BE4A373EEC9AEDF
        945BE4A372DB8543EDC1A0DB8543FCF4EDFBF3ECE09459E4A270DD8C4EE5B087
        EEE7DEDEC3B5EEBCA6FFC5A3FABE90FDC994FFCDA5E9D4B8F4E6CFFFD7B2C85B
        25B32900EA968AE5F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFAFFF9
        D2BAA4C45B04E9BF9AFBFCFAFFFAF7E3A574EDC4A6FCFCFCFCFCFCE6AC80EABC
        99FBFBFBDB8543ECC4A5DD8D4FE6AC80E9BB97FAF8F8DB8543F9F7F7F8F6F6DB
        8543FAF6F5E3A372ECC1A0DB8543FAF4EFF9F3EEDB8543FAF2EBE5A472E7BC9B
        F0E7DED7BCAEE8B8A6FFD4B7FECAA1FED5A4F9D9B6FFE8C0FFDEB2C05C39B52A
        10CE8E76EDF4E5FFFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFFFBFFF9
        D3BBA5C55C05E9BF9AFAFBF9FFFAF7E4A574E5AD81ECC4A6F6ECE4F6ECE4E3A4
        74E3A474DB8543EBC4A6DB8543DB8543F7F9FAF6F8F9DB8543F5F7F8F5F7F8DB
        8543F8F6F6E3A373EAC1A2DB8543F7F3F2F7F4F0EABF9FE19B65DB8543E8BC9A
        FCEFE7D5B8AFE3B8A9FFDCC4F1CBA9F8DAB1FBEAC9FFE3B2D26C37B02B0AC270
        6BF4EEF3EDFFFFFBFFF5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFFFBFFF9
        D5BAA5C55B04E9BD98FBF9F8FFFBF8E4A675DF955CE3A475F0DBCCF3EAE5E4AC
        81E6B48EE2A475E9C3A6E3A475E7B38DE7B38DF0D9CBDB8543E9C2A5F6F7FBDB
        8543F5F7F8E2A373E9C1A2DB8543E4AA7EEFD6C4E7B189EAC0A0DD8D4EF2E1D0
        F7E7E0D4B9AFE2BFB2FFE0CCF5D3B6FFE6C3FFDFB9D56C41BF2C04C4775CF7FC
        FBFFF4FFFFF3FFDDFFF5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFFFDFFF9
        D3B8A3C35902E7BB96FBF9F8FFFCF9E5A675ECC5A7FBFDFEFBFDFEFAFCFDF2DC
        CBEECCB3FAFCFDECC4A6E3A474F9FBFCECCBB1F0DBCADB8543EAC3A5F6F8F9EB
        CAB0F5F7F7EED9C7F3E8DFEBC9AEF0D8C6ECC9AEF9F6F2EBC1A0F7EAD9FAF3EA
        FAE8E1D8BFB5D8BBADFFE2CEFFE6CBFFE1C0DC7C54B21D03CB6E57F5FEEAEFFB
        FBFFF8FFFFF4FFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFFFDFFF9
        D4B7A2C35600E8BB96FCF8F7FFFAF7E9B68EDB8543DB8543DB8543FFFDFCFEFC
        FBFEFCFBFEFCFBEEC4A5E4A474FBF9F8FBF9F8FBF9F8ECC2A3FAF8F7F9F7F6F9
        F7F6F9F7F6F8F6F5F8F7F3FAF7F3FAF7F2F9F6F1FAF6F1FAF7EFF5F2EAFFF5EE
        FCECE5D3BFB4DCC2B1FFF9E0FFD8BACB7C5BBA1F05BC705AECEAE0FAFFFFFFFE
        FFFBF8F4FFFEFFFFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFFFDFFF9
        D4B7A2C45701E9BC97FCF8F7FFF7F4FBF9F8FFF9F2FFF9F2FFF9F2FEF8F1FEF8
        F1FEF8F1FEF8F1FEF8F1FCF9F1FCF9F1FBF8F0FBF8F0FAF7EFFAF7EFF9F6EEF9
        F6EEF8F5F0F8F6EEF9F6EEF9F6EEFBF6EDFBF6EDFDF7ECFDF7ECFBF7F2FCF1ED
        F3E3DCD5C5B5F5DDC7FFE9CBDB87639E2C07C15A4BEDF0E0E8FFFFFFF8FFFFFD
        FFFBFFFBFDFAF5FFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFF9
        D5B8A3C65903EBBE99FCF8F7FFF3F1F5F3F2FAF3EAFAF3EAFAF3EAFAF3EAF9F2
        E9F9F2E9F9F2E9F9F2E9FBF6EDFBF6EDFBF6EDFAF5ECFAF5ECF9F4EBF9F4EBF9
        F4EBF9F4EBF9F4EBF9F4EBFBF5EAFBF5EAFBF5E8FDF5E8FDF5E8FBF6F3FDF2EE
        FEF1E9F0E1D1F9E2C8CA9471922D06DE5830DEF1E2F9F6F1FAFFFFF4FFFFFFF8
        FCFFFDFEF6FFF9E5FFF5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FAFFFFFEF9
        ECBD9E9E541CD27D35F4A251E09949D89B4BD79455D79455D69354D59253D592
        53D49152D39051D39051DB8E55DA8D54DA8D54D98C53D88B52D88B52D78A51D7
        8A51DB8757DB8757DA8656DA8656D98555D88454D88454D78353D8874AD88A48
        DB8543F4864AEA6938A92E0CAF5B42FFE1CCFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8FFFEFFFFF7
        FFEACDC48053B3511BB4460CB94B11BC4F17C14E0BC14E0BC14E0BC04D0ABF4C
        09BF4C09BE4B08BE4B08C24709C24709C24709C14608C04507C04507BF4406BF
        4406BF3E0DBF3E0DBE3D0CBD3C0BBD3C0BBC3B0ABC3B0ABB3A09D0351EB62B10
        B13513AA320F9F2A0FBF6854F5D0C2FFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3FAFFF6F6FF
        FFFBFFFFEBEAF5E0D8F2E2D5F2EBDCE3E3D3EAE1DEEAE1DEE9E0DDE9E0DDE8DF
        DCE8DFDCE7DEDBE7DEDBECDFE1ECDFE1ECDFE1EBDEE0EBDEE0EADDDFEADDDFEA
        DDDFEDE1DBEDE1DBECE0DAECE0DAEBDFD9EBDFD9EADED8EADED8E6DCD2E1E1D1
        E7ECD7EAE5D0EDDBCAFFF4EBFAFFFEDFFEFDFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6FFFFF3FBFA
        FBFFFFF8FAFAFFFFFFFDFFFEF8FFFAF3FEF6FFFFF9FFFFF9FFFFF9FFFFF9FFFF
        F9FEFFF8FEFFF8FEFFF8FDFFFBFDFFFBFDFFFBFCFFFAFCFFFAFCFFFAFBFFF9FB
        FFF9FDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFCFEFFFCFEFFFDFCFFF6FFFF
        F2FDFBFDFEFCFFFDFEFFFBFFFFF7FFFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFF7FDFFF9
        FFFFFCFFFDFFFFFCFFFFF7FFFFFBFFFFFAFFFFFEFFFFFEFFFFFEFFFFFEFFFFFE
        FFFFFEFFFFFEFFFFFEFFFFFEFFFFFEFFFFFEFFFFFEFFFFFEFFFFFEFFFFFEFFFF
        FEFFFEFFF6FEFFF6FEFFF6FDFFF5FDFFF5FDFFF5FDFFF5FDFFF5FFF9FFFFF6FF
        FDFEFFFBFFFFFEFCFCFDFBFBFBFFFFF4FEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFFF8FB
        FFFDFFF8FDFFF3FDFFEFFDFFECFEFFE4F7FFF9FEFDF9FEFDF9FEFDF9FEFDF9FE
        FDF9FEFDF9FEFDF9FEFDFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFB
        FFFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFFFFAFFFFFDFF
        FFFEFFFFFFFFFFFEFDFFFFFCFFFFFBFFFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
    end
    inherited Image1: TImage
      Left = 597
    end
  end
  inherited RzDialogButtons1: TRzDialogButtons
    Top = 567
    Width = 703
    CaptionCancel = 'Lukk'
    TabOrder = 4
  end
  inherited ActionList1: TActionList
    Images = Large
    Left = 259
    Top = 102
    inherited DoCancel: TAction
      Caption = 'Lukk'
    end
    object DoRegisterKunde: TAction [3]
      Caption = 'Registrer ny kunde'
      ImageIndex = 3
      OnExecute = DoRegisterKundeExecute
    end
    object DoAddProduct: TAction [4]
      Caption = 'Legg til produkt'
      Hint = 'Legg til produkt i faktura'
      ImageIndex = 0
      OnExecute = DoAddProductExecute
    end
    object DoRemoveProduct: TAction [5]
      Caption = 'Ta bort produkt'
      Hint = 'Fjern produkt fra faktura'
      ImageIndex = 1
      OnExecute = DoRemoveProductExecute
    end
    object DoSelectKunde: TAction [6]
      Caption = 'Velg kunde fra register'
      ImageIndex = 2
      OnExecute = DoSelectKundeExecute
    end
    object DoUpdateSum: TAction [7]
      Caption = 'DoUpdateSum'
      OnExecute = DoUpdateSumExecute
    end
  end
  inherited Mailer: TRzSendMessage
    Left = 178
    Top = 426
  end
  object Large: TImageList
    Height = 24
    ShareImages = True
    Width = 24
    Left = 217
    Top = 96
    Bitmap = {
      494C010102000400040018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000001800000001002000000000000024
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000097711000977
      1100097711000977110000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000006770C00FFFFFF000EA4
      1B000EA51C000EA51C0009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000006770C00FFFFFF000EA4
      1B000EA51C000EA51C0009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000006770C00FFFFFF000EA4
      1B000EA51C000EA51C0009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000006770D00FFFFFF000EA4
      1B000EA51C000EA51C0009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008780E00FFFFFF0010A6
      1F000EA51B000EA51B0009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008780E00FFFFFF0017AB
      290011A8210011A8210009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000977
      1100097711000977110009771100097711000977110008780E00FFFFFF001DB1
      320018AD2A0018AD2A0008780E00097711000977110009771100097711000977
      1100097711000000000000000000000000000000000000000000000000000000
      00000104A2000104A2000104A2000104A2000104A2000104A2000104A2000104
      A2000104A2000104A2000104A2000104A2000104A2000104A2000104A2000104
      A200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000009771100FFFF
      FF0052DD7E004CD8750046D46D0041CF66003CCC5F0036C6550029BA430024B5
      3B001FB1330019AC2B001BB02F0017AC280012A821000EA51C000EA51B000EA5
      1B000EA51B000977110000000000000000000000000000000000000000000104
      A200AFBEFA000337FF000337FF000337FF000337FB000437F6000436F1000436
      EC000536E7000536E1000535DD000635D8000635D2000635CE000734C8000734
      C8000104A2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000009771100FFFF
      FF0052DD7E004CD8750046D46D0041CF66003CCC5F0036C6550030BE4C002BBA
      440026B63D0020B236001BB02F0017AC280012A821000EA51C000EA51B000EA5
      1C000EA51C000977110000000000000000000000000000000000000000000104
      A200FFFFFF000337FF000337FE000337FE000337FB000437F6000436F1000436
      EC000536E7000536E1000535DD000635D8000635D2000635CE000734C8000736
      C5000104A2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000009771100FFFF
      FF0056E0850051DA7C004CD6750046D26D0042CE66003CC95E0037C5560031C0
      4F002CBC480027B7400022B438001EB0320019AC2B0013A823000FA41D000EA3
      1B000EA41B000977110000000000000000000000000000000000000000000104
      A200FFFFFF000335FC000335FB000335FB000335FB000435F6000435F1000434
      EC000534E8000534E2000534DE000633D9000633D3000633CF000733CA000734
      C6000104A2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000009771100FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0038C5
      580033C151002EBE4A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000977110000000000000000000000000000000000000000000104
      A200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00D1D9FA00D1D9FA00AFBEFA00AFBEFA00AFBE
      FA000104A2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000977
      1100097711000977110009771100097711000977110008780E00FFFFFF003FCC
      63003BC95C003BC95C0008780E00097711000977110009771100097711000977
      1100097711000000000000000000000000000000000000000000000000000000
      00000104A2000104A2000104A2000104A2000104A2000104A2000104A2000104
      A2000104A2000104A2000104A2000104A2000104A2000104A2000104A2000104
      A200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009771100FFFFFF0046D3
      6E0042D0680042D0680009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009771100FFFFFF004DD8
      770049D5710049D5710009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009771100FFFFFF0054DD
      810050DB7B0050DB7B0009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009771100FFFFFF0059E2
      890057E185005EE8900009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009771100FFFFFF005AE3
      8A005CE58C005EE8900009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009771100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0009771100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000097711000977
      1100097711000977110000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000060000000180000000100010000000000200100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF000000000000FFFFFFFF
      FFFF000000000000FFC3FFFFFFFF000000000000FF81FFFFFFFF000000000000
      FF81FFFFFFFF000000000000FF81FFFFFFFF000000000000FF81FFFFFFFF0000
      00000000FF81FFFFFFFF000000000000FF81FFFFFFFF000000000000E00007F0
      000F000000000000C00003E00007000000000000C00003E00007000000000000
      C00003E00007000000000000C00003E00007000000000000E00007F0000F0000
      00000000FF81FFFFFFFF000000000000FF81FFFFFFFF000000000000FF81FFFF
      FFFF000000000000FF81FFFFFFFF000000000000FF81FFFFFFFF000000000000
      FF81FFFFFFFF000000000000FFC3FFFFFFFF000000000000FFFFFFFFFFFF0000
      00000000FFFFFFFFFFFF00000000000000000000000000000000000000000000
      000000000000}
  end
end
