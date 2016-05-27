object frmEditPurringer: TfrmEditPurringer
  Left = 192
  Top = 110
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Redigere purringer'
  ClientHeight = 191
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object RzGroupBox1: TRzGroupBox
    Left = 0
    Top = 0
    Width = 280
    Height = 155
    Align = alClient
    Caption = 'Instillinger'
    TabOrder = 0
    object lbKunde: TRzLabel
      Left = 26
      Top = 30
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Purringer '
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
    object RzLabel1: TRzLabel
      Left = 26
      Top = 61
      Width = 89
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Inkasso varsel '
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
    object Label1: TLabel
      Left = 28
      Top = 98
      Width = 216
      Height = 32
      Caption = 
        'OBS: Du må oppdatere nøkkeltallene for at'#13'forandringene skal ful' +
        'lføres mot omsetning.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      ParentFont = False
    end
    object RzDBSpinner1: TRzDBSpinner
      Left = 120
      Top = 30
      Width = 123
      Height = 23
      Max = 4
      ParentColor = False
      TabOrder = 0
      DataField = 'Purringer'
      DataSource = AppData.FakturaDs
    end
    object RzDBSpinner2: TRzDBSpinner
      Left = 120
      Top = 60
      Width = 123
      Height = 23
      Max = 4
      ParentColor = False
      TabOrder = 1
      DataField = 'Varsel'
      DataSource = AppData.FakturaDs
    end
  end
  object RzDialogButtons1: TRzDialogButtons
    Left = 0
    Top = 155
    Width = 280
    ActionOk = DoOK
    ActionCancel = DoCancel
    CaptionOk = 'OK'
    CaptionCancel = 'Avbryt'
    CaptionHelp = '&Help'
    TabOrder = 1
  end
  object ActionList1: TActionList
    Left = 98
    Top = 136
    object DoOK: TAction
      Caption = 'OK'
      OnExecute = DoOKExecute
    end
    object DoCancel: TAction
      Caption = 'Avbryt'
      OnExecute = DoCancelExecute
    end
  end
end
