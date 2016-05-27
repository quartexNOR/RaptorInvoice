inherited frmRegister: TfrmRegister
  Left = 373
  Top = 143
  Caption = 'frmRegister'
  ClientWidth = 508
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  inherited RzSeparator1: TRzSeparator
    Width = 508
  end
  object lbKilde: TRzLabel [1]
    Left = 18
    Top = 180
    Width = 223
    Height = 23
    AutoSize = False
    Caption = 'Velg kilde register '
    Enabled = False
    Layout = tlCenter
    BlinkColor = clRed
    BorderOuter = fsFlatRounded
    BorderSides = [sdRight, sdBottom]
    TextStyle = tsRaised
  end
  inherited RzPanel1: TRzPanel
    Width = 508
    inherited lbTitle: TRzLabel
      Width = 95
      Caption = 'Nytt register'
    end
    inherited lbHelp1: TRzLabel
      Width = 293
      Caption = 'Du kan velge '#229' lage et nytt register, eller kopiere et eldre.'
    end
    inherited lbHelp2: TRzLabel
      Width = 289
      Caption = 'Nedenfor kan du ogs'#229' velge hvilke data som skal beholdes.'
    end
    inherited Image1: TImage
      Left = 402
    end
  end
  inherited RzDialogButtons1: TRzDialogButtons
    Width = 508
    CaptionOk = 'Lag register'
    EnableHelp = False
    object lbStatus: TRzLabel [0]
      Left = 225
      Top = 0
      Width = 103
      Height = 36
      Align = alLeft
      AutoSize = False
      Caption = 'Status'
      Layout = tlCenter
      BlinkColor = clRed
      BorderSides = [sdRight, sdBottom]
      BorderWidth = 2
    end
    inherited NavigatorPanel: TPanel
      inherited nLocked: TImage
        Left = 199
      end
      inherited dbxPanel: TRzPanel
        Left = 2
        Visible = False
      end
    end
  end
  object nValg: TRzRadioGroup [4]
    Left = 18
    Top = 84
    Width = 223
    Height = 85
    Caption = 'Jeg '#248'nsker '#229
    ItemFrameColor = 8409372
    ItemHotTrack = True
    ItemHighlightColor = 2203937
    ItemHotTrackColor = 3983359
    ItemIndex = 0
    Items.Strings = (
      'Lage et nytt register'
      'Kopiere et eksisterende register')
    TabOrder = 2
    OnChanging = nValgChanging
  end
  object nTabeller: TRzCheckGroup [5]
    Left = 258
    Top = 84
    Width = 235
    Height = 151
    Caption = 'Velg hvilke tabeller du '#248'nsker '#229' kopiere'
    Enabled = False
    ItemFrameColor = 8409372
    ItemHighlightColor = 2203937
    ItemHotTrack = True
    ItemHotTrackColor = 3983359
    Items.Strings = (
      'Leverand'#248'rer'
      'Produkter'
      'Kunder'
      'Kundegrupper'
      'Generelle instillinger')
    TabOrder = 3
    CheckStates = (
      1
      1
      1
      1
      0)
  end
  object nKilde: TRzComboBox [6]
    Left = 18
    Top = 210
    Width = 223
    Height = 24
    Style = csDropDownList
    Ctl3D = False
    Enabled = False
    FrameController = AppData.FrameController
    ItemHeight = 16
    ParentCtl3D = False
    TabOrder = 4
  end
  object RzGroupBox1: TRzGroupBox [7]
    Left = 18
    Top = 246
    Width = 475
    Caption = 'Informasjon'
    TabOrder = 5
    object lbNavn: TRzLabel
      Left = 12
      Top = 24
      Width = 103
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Navn p'#229' register '
      Enabled = False
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsFlatRounded
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object nNavn: TRzEdit
      Left = 120
      Top = 24
      Width = 277
      Height = 24
      FrameController = AppData.FrameController
      TabOrder = 0
    end
    object nFakturaId: TRzCheckBox
      Left = 120
      Top = 60
      Width = 277
      Height = 17
      Caption = 'Jeg '#248'nsker '#229' beholde faktura nummer'
      Checked = True
      Enabled = False
      FrameColor = 8409372
      HighlightColor = 2203937
      HotTrack = True
      HotTrackColor = 3983359
      State = cbChecked
      TabOrder = 1
    end
  end
  inherited ActionList1: TActionList
    inherited DoOK: TAction
      Caption = 'Lag register'
    end
  end
end
