inherited frmFakturaReport1: TfrmFakturaReport1
  Caption = 'frmFakturaReport1'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Panel2: TPanel
    inherited Navigator: TRzDBNavigator
      Hints.Strings = ()
    end
  end
  inherited FakturaReport: TppReport
    inherited ppHeaderBand1: TppHeaderBand
      inherited ppDBText5: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited ppDBText7: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited nKundeNavn: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited nKundeAdresse: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited nKundePostNr: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited nKundePostSted: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited ppDBText21: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited nMerk: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited nKundeAdresse2: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
    end
    inherited ppDetailBand1: TppDetailBand
      inherited ppSubReport1: TppSubReport
        DataPipelineName = 'FakturaDataPipe'
        inherited ppChildReport1: TppChildReport
          DataPipelineName = 'FakturaDataPipe'
          inherited ppDetailBand3: TppDetailBand
            inherited ppDBText12: TppDBText
              DataPipelineName = 'FakturaDataPipe'
            end
            inherited ppDBText13: TppDBText
              DataPipelineName = 'FakturaDataPipe'
            end
            inherited ppDBText14: TppDBText
              DataPipelineName = 'FakturaDataPipe'
            end
            inherited ppDBText15: TppDBText
              DataPipelineName = 'FakturaDataPipe'
            end
            inherited ppDBText16: TppDBText
              DataPipelineName = 'FakturaDataPipe'
            end
            inherited ppDBText17: TppDBText
              DataPipelineName = 'FakturaDataPipe'
            end
            inherited ppDBText8: TppDBText
              DataPipelineName = 'FakturaDataPipe'
            end
          end
        end
      end
    end
    inherited ppFooterBand1: TppFooterBand
      inherited ppDBText1: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited ppDBMemo1: TppDBMemo
        DataPipelineName = 'FakturaPipe'
      end
      inherited ppDBText2: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited ppDBText3: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited ppDBText4: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
      inherited ppDBText6: TppDBText
        DataPipelineName = 'FakturaPipe'
      end
    end
  end
end
