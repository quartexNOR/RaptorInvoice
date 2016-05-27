object frmEgenskaper: TfrmEgenskaper
  Left = 335
  Top = 207
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Egenskaper for faktura'
  ClientHeight = 246
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object RzDialogButtons1: TRzDialogButtons
    Left = 0
    Top = 210
    Width = 306
    ButtonColor = 15791348
    CaptionOk = 'OK'
    CaptionCancel = 'Cancel'
    CaptionHelp = '&Help'
    HotTrack = True
    HighlightColor = 16026986
    HotTrackColor = 3983359
    HotTrackColorType = htctActual
    ShowCancelButton = False
    TabOrder = 0
  end
  object RzGroupBox1: TRzGroupBox
    Left = 0
    Top = 0
    Width = 306
    Height = 210
    Align = alClient
    Caption = 'Egenskaper'
    TabOrder = 1
    object lbType: TRzLabel
      Left = 8
      Top = 20
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Purringer utført '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsPopup
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object RzLabel1: TRzLabel
      Left = 8
      Top = 54
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Varsel utført '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsPopup
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object RzLabel2: TRzLabel
      Left = 8
      Top = 86
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Dato '
      Layout = tlCenter
      BlinkColor = clRed
      BorderOuter = fsPopup
      BorderSides = [sdRight, sdBottom]
      TextStyle = tsRaised
    end
    object lbPurringer: TRzDBLabel
      Left = 102
      Top = 26
      Width = 50
      Height = 13
      AutoSize = True
      DataField = 'Purringer'
      DataSource = AppData.FakturaDs
    end
    object RzDBLabel1: TRzDBLabel
      Left = 102
      Top = 60
      Width = 60
      Height = 13
      AutoSize = True
      DataField = 'Varsel'
      DataSource = AppData.FakturaDs
    end
    object RzDBLabel2: TRzDBLabel
      Left = 102
      Top = 90
      Width = 60
      Height = 13
      AutoSize = True
      DataField = 'Dato'
      DataSource = AppData.FakturaDs
    end
  end
end
