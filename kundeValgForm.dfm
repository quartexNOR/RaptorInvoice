object frmKundeValg: TfrmKundeValg
  Left = 431
  Top = 168
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Velg kunde'
  ClientHeight = 396
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    407
    396)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TRzButton
    Left = 245
    Top = 366
    Default = True
    Action = DoOK
    Anchors = [akRight, akBottom]
    Color = 15791348
    HighlightColor = 16026986
    HotTrack = True
    HotTrackColor = 3983359
    TabOrder = 1
  end
  object btnCancel: TRzButton
    Left = 329
    Top = 366
    Cancel = True
    Action = DoCancel
    Anchors = [akRight, akBottom]
    Color = 15791348
    HighlightColor = 16026986
    HotTrack = True
    HotTrackColor = 3983359
    TabOrder = 2
  end
  object grid: TdxDBGrid
    Left = 0
    Top = 0
    Width = 407
    Height = 361
    Bands = <
      item
      end>
    DefaultLayout = True
    HeaderPanelRowCount = 1
    KeyField = 'Id'
    SummaryGroups = <>
    SummarySeparator = ', '
    Align = alTop
    TabOrder = 0
    OnDblClick = gridDblClick
    DataSource = AppData.KunderDs
    Filter.Criteria = {00000000}
    LookAndFeel = lfFlat
    OptionsBehavior = [edgoAnsiSort, edgoAutoSearch, edgoAutoSort, edgoCaseInsensitive, edgoDragScroll, edgoEnterShowEditor, edgoImmediateEditor, edgoTabThrough, edgoVertThrough]
    OptionsDB = [edgoCancelOnExit, edgoCanNavigation, edgoConfirmDelete, edgoUseBookmarks]
    OptionsView = [edgoAutoWidth, edgoBandHeaderWidth, edgoRowSelect, edgoUseBitmap]
    object gridColumn1: TdxDBGridColumn
      BandIndex = 0
      RowIndex = 0
      FieldName = 'Firma'
    end
  end
  object ActionList1: TActionList
    Left = 174
    Top = 252
    object DoOK: TAction
      Caption = 'Velg'
      OnExecute = DoOKExecute
      OnUpdate = DoOKUpdate
    end
    object DoCancel: TAction
      Caption = 'Avbryt'
      ShortCut = 27
      OnExecute = DoCancelExecute
    end
  end
end
