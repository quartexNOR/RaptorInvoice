inherited frmEditProduct: TfrmEditProduct
  Left = 215
  Top = 63
  ActiveControl = ANavn
  Caption = 'Produkt'
  ClientHeight = 443
  ClientWidth = 506
  Constraints.MaxWidth = 0
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  inherited Panel1: TPanel
    Width = 506
    inherited Label1: TLabel
      Width = 185
      Caption = 'Redigere produkt beskrivelse'
    end
    inherited Label2: TLabel
      Left = 57
      Width = 261
      Caption = 'Fyll ut feltene nedenfor med informasjon om produktet.'
    end
    object Label7: TLabel
      Left = 57
      Top = 42
      Width = 207
      Height = 14
      Caption = 'Når du er ferdig trykker du på OK knappen.'
    end
    object Label9: TLabel
      Left = 57
      Top = 57
      Width = 324
      Height = 14
      Caption = 
        'Ønsker du å avbryte trykker du på Avbryt knappen eller ESC taste' +
        'n'
    end
    object Image1: TImage
      Left = 6
      Top = 27
      Width = 49
      Height = 43
      Center = True
      Picture.Data = {
        07544269746D6170F6060000424DF60600000000000036000000280000001800
        0000180000000100180000000000C0060000120B0000120B0000000000000000
        0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE7C9BBE7C9BB
        E5C9BCE5C9BCE3C8BBE4C8BAE7C9BBFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE7CABCE8
        D1C7E3D7D3E0D9D8DBD5D5D3CFCFCEC7C7CAC2C2CBBEBAD1BDB6DCC3B7FF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE7C9
        BBE9D0C5EEE5E2EAEBECEAEBECE6E9EDE4E3E4DCD7D8D8D3D4D3D2D5CBCACDC2
        BDBEBDB4B3C8B6B0E1C5B8FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFE6C7B8EDD7CDF4F1F1F3F5F6F1F5F9EBE2DFDFBAA8D69574D08259D084
        5DD19576D2AA98CFC2BECAC7C8BDB6B6BFB2AFDCC3B7FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFE7C9BBECD8CFF8F7F8F8FBFCF4F3F3E1B39AD17748CB6229
        CF6D39E9BA9FE5AE91CD672FCD652DCE7344CFA08ACAC7C8C2BDBEBFB4B2DDC4
        B8FF00FFFF00FFFF00FFFF00FFFF00FFEAD1C5FAF8F7FBFEFFF8F7F6DA9774CB
        6027CC652ECA5F26E5AE91FFFFFFFFFFFFDC9671CA612ACD672FCD652DCF9070
        CEC7C7C5C0C1C6BAB7E4C7BAFF00FFFF00FFFF00FFE7C9BBF6EEE9FDFFFFFDFF
        FFE0A586CA6028CD6833CD6934CB622BDB926CFCF5F1F9EDE7D58155CB652ECD
        6934CD6833CD622AD09374D3CFCFCAC2C2D5C2BCE8C9BBFF00FFFF00FFEDD7CD
        FFFEFEFFFFFFEECFBDCC652ECC6732CD6934CD6934CD6934CD6833D58053D37B
        4CCC6731CD6934CD6934CD6934CD6833CC652ED4B09ED3D2D5CEC7C7E3C8BCFF
        00FFE7C9BBF6E9E3FFFFFFFEFBFADA8F64CF6B34CF6D39CD6A35CD6833CB632C
        E4AD90F3DCCFF3DACDD58053CC652ECD6934CD6934CD6934CD652DD07E54DBD5
        D5D4D1D3DDCAC2E7C9BBE8CBBDFBF6F4FFFFFFF5DFD3D47B45D37842D17440D0
        703BCE6C37CA6028EABFA4FFFFFFFFFFFFDB956FC95E26CD6934CD6934CD6934
        CD6833CD6833DCC0B3DDDEE1DDD1CDE7C9BBEACFC3FEFDFCFFFFFFECC4ABD57C
        44D6804AD47B46D37742D1733ECD672FE1A382FFFFFFFFFFFFF5DFD3D17646CA
        6028CD6934CD6934CD6934CB6229DAA990E6E9EDE0D9D8E7C9BBECD4C9FFFEFE
        FFFFFFEABFA4D8844BD98752D7834DD67F49D47B46D27540D27745F3DACDFFFF
        FFFFFFFFF5E5DDD88B62CB622BCD6934CD6934CB6229DAA082EBEDF1E4E3E4E7
        C9BBECD3C8FFFEFEFFFFFFEDC5A2DB8D53DC9059DA8B55D88751D7834DD67F4A
        D37740D47C49F0D1C0FFFFFFFFFFFFFDF9F7DB956FCB622BCD6934CB6027DCA2
        84EFF3F7EBE8E9E7C9BBE9CEC2FEFCFBFFFFFFF1D1B7DE955BDF9660DD915BDB
        8C56D9864FD88550D7834DD47A43D37842ECC4ABFFFEFFFFFFFFF7E9E1CF6F3C
        CC6731CB6027E1B39AF6FAFEEEE9E7E7C9BBE7CABCFBF5F2FFFFFFF8E9DBE3A2
        6AE19D67E19D67E29F6EE3A77CDC925DD98952D88550D57E48D3773FF0D1BFFF
        FFFFFFFFFFDC956ECB6229CC6732EBD2C6F6FAFEEEE5E2E7C9BBFF00FFF4E7E0
        FFFFFFFEFDFCEAB98CE29D61F2D3B9FEFAF8FEFDFCE9B794DA894FDB8C56D987
        52D4783DE9BA9FFFFFFFFFFFFFE1A382CC6228D7875DF7F5F5F8FAFBEDDAD1FF
        00FFFF00FFECD3C8FFFEFEFFFFFFF8E5D3E5A468F0CBA9FFFFFFFFFFFFFAEDE2
        E3A474DC8F57DA8B53DF9A6BF8EAE0FFFFFFFEFBFADA8F61D06E36EECFBDFDFF
        FFF7F3F2E8CDBFFF00FFFF00FFFF00FFF6EAE5FFFFFFFFFFFFF2D2B1E7AD74FA
        EDE2FFFFFFFFFFFFFCF6F2F4DBC8F4DBC7FCF6F2FFFFFFFFFFFFF2D5C1D4783D
        E6B395FDFFFFFDFFFFF0DFD8FF00FFFF00FFFF00FFFF00FFE9CDC1FDF8F5FFFF
        FFFFFEFEF0CBA4EAB680F8E8D6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFCF2
        D5C1DD915BE9B794FEFDFCFFFFFFF6F0ECE7CABCFF00FFFF00FFFF00FFFF00FF
        FF00FFECD4C9FDFBF9FFFFFFFFFEFEF5DCC1ECBD8BEFC79DF3D6B9F5DEC7F4DA
        C4EFCBADE8B185E2A16FF0CFB6FFFFFFFFFFFFFBF6F3E9CEC2FF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFECD4C9FBF6F4FFFFFFFFFFFFFDF8F5F7E2CB
        F1D0AEF0CBA4EDC5A2EFC9A7F4DBC7FDF8F5FFFFFFFFFFFFF9F2EFEACFC3FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE9CDC1F6EBE6FE
        FDFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFAFAF5E5DD
        E7CABCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFEBD2C6F1E0D7F6EBE6FAF4F1FBF7F6FBF7F6F9F2EFF5E9E3F0
        DDD5EACFC3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE6C7B8E7CABCE8CBBEE8CB
        BDE7C9BBE8CBBDFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF}
      Transparent = True
    end
  end
  inherited Panel2: TPanel
    Top = 405
    Width = 506
    inherited Button1: TButton
      Left = 425
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    inherited Button2: TButton
      Left = 344
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox [2]
    Left = 0
    Top = 82
    Width = 506
    Height = 186
    Align = alTop
    Caption = 'Produkt informasjon'
    TabOrder = 2
    object Label10: TLabel
      Left = 6
      Top = 18
      Width = 88
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Navn '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 6
      Top = 45
      Width = 88
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Type '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 6
      Top = 72
      Width = 88
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Leverandør '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 6
      Top = 99
      Width = 88
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'inn pris '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 6
      Top = 126
      Width = 88
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Leverandør Id '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label8: TLabel
      Left = 234
      Top = 99
      Width = 82
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Ut pris '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label11: TLabel
      Left = 234
      Top = 126
      Width = 82
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Avanse '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Label12: TLabel
      Left = 234
      Top = 153
      Width = 82
      Height = 22
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'MVA '
      Color = clBtnShadow
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object AType: TDBEdit
      Left = 99
      Top = 45
      Width = 352
      Height = 22
      Hint = 'Beskriv produkt eller tjeneste type'
      DataField = 'Type'
      DataSource = AppData.ProdukterDs
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ANavn: TDBEdit
      Left = 99
      Top = 18
      Width = 352
      Height = 22
      Hint = 'Beskriv produkt eller tjeneste'
      DataField = 'Tittel'
      DataSource = AppData.ProdukterDs
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object ALeverandor: TDBLookupComboBox
      Left = 99
      Top = 72
      Width = 352
      Height = 22
      Hint = 'Velg en leverandør fra listen'
      DataField = 'LeverandorId'
      DataSource = AppData.ProdukterDs
      KeyField = 'Id'
      ListField = 'Firma'
      ListSource = AppData.LeverandorerDs
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object APris: TDBEdit
      Left = 99
      Top = 99
      Width = 130
      Height = 22
      Hint = 'Produktets pris'
      DataField = 'InnPris'
      DataSource = AppData.ProdukterDs
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnChange = APrisChange
      OnKeyPress = APrisKeyPress
    end
    object AReferanse: TDBEdit
      Left = 99
      Top = 126
      Width = 130
      Height = 22
      Hint = 'Leverandørens produkt identifikasjon'
      DataField = 'LeverandorRef'
      DataSource = AppData.ProdukterDs
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object BPris: TDBEdit
      Left = 321
      Top = 99
      Width = 130
      Height = 22
      Hint = 'Produktets pris'
      DataField = 'UtPris'
      DataSource = AppData.ProdukterDs
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnKeyPress = BPrisKeyPress
    end
    object nAvanse: TComboBox
      Left = 321
      Top = 126
      Width = 130
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 6
      OnChange = nAvanseChange
      Items.Strings = (
        '1,5'
        '2,0'
        '2,5'
        '3,0'
        'Spesifisert')
    end
    object nMVA: TComboBox
      Left = 321
      Top = 153
      Width = 130
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 7
      OnChange = nMVAChange
      Items.Strings = (
        '24%'
        '12%'
        '09%')
    end
  end
  object PageControl1: TPageControl [3]
    Left = 0
    Top = 272
    Width = 506
    Height = 133
    Hint = 'Trykk på knappene for å skifte mellom kategoriene'
    ActivePage = TabSheet2
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    Style = tsButtons
    TabOrder = 3
    object TabSheet2: TTabSheet
      Caption = 'Detaljert beskrivelse'
      ImageIndex = 1
      object ABeskrivelse: TDBMemo
        Left = 0
        Top = 0
        Width = 498
        Height = 101
        Hint = 'Detaljert beskrivelse av produktet'
        Align = alClient
        DataField = 'Beskrivelse'
        DataSource = AppData.ProdukterDs
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
      end
    end
  end
  object Panel3: TPanel [4]
    Left = 0
    Top = 268
    Width = 506
    Height = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
  end
  inherited ActionList1: TActionList
    Left = 390
    Top = 303
    inherited DoOK: TAction
      Hint = 'Trykk her for å registrere produktet'
    end
    inherited DoCancel: TAction
      Hint = 'Trykk her for å avbryte registreringen'
    end
  end
end
