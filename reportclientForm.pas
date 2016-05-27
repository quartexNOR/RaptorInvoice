  unit reportclientForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, clientform, ppViewr, ImgList, ActnList, StdCtrls,
  RzLabel, ExtCtrls, RzPanel, DBCtrls, RzDBNav, RzButton, RzBckgnd, Menus,
  RzSndMsg, RzDlgBtn, ppComm, ppRelatv, ppProd, ppClass, ppReport;

  Type

  TfrmReportClient = class(TfrmClient)
    DoPrint: TAction;
    ReportViewer: TppViewer;
    PopupMenu1: TPopupMenu;
    nDokumentSize: TMenuItem;
    nTilpass: TMenuItem;
    nScale: TMenuItem;
    nHeleDokumentet: TMenuItem;
    Panel1: TPanel;
    DoNextPage: TAction;
    DoPrevious: TAction;
    N1: TMenuItem;
    Forrigeside1: TMenuItem;
    Nesteside1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure DoPrintExecute(Sender: TObject);
    procedure nTilpassClick(Sender: TObject);
    procedure nDokumentSizeClick(Sender: TObject);
    procedure nScaleClick(Sender: TObject);
    procedure nHeleDokumentetClick(Sender: TObject);
    procedure DoNextPageExecute(Sender: TObject);
    procedure DoPreviousExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmReportClient.FormShow(Sender: TObject);
  begin
    inherited;
    HideNavigator;
    try
      ReportViewer.RegenerateReport;
    except
      on e: exception do
      ShowMessage('Klarte ikke å generere rapporten. Systemet ga følgende grunnlag:' + #13#13 + e.message);
    end;
  end;

  procedure TfrmReportClient.DoPrintExecute(Sender: TObject);
  begin
    inherited;
    reportviewer.print;
    //close;
  end;

  procedure TfrmReportClient.nTilpassClick(Sender: TObject);
  begin
    inherited;
    //reportviewer.ZoomSetting:=zs100Percent;
  end;

  procedure TfrmReportClient.nDokumentSizeClick(Sender: TObject);
  begin
    inherited;
    //reportviewer.ZoomSetting:=zsPageWidth;
  end;

  procedure TfrmReportClient.nScaleClick(Sender: TObject);
  begin
    inherited;
    //reportviewer.ZoomSetting:=zsPercentage;
  end;

  procedure TfrmReportClient.nHeleDokumentetClick(Sender: TObject);
  begin
    inherited;
    //reportviewer.ZoomSetting:=zsWholePage;
  end;

  procedure TfrmReportClient.DoNextPageExecute(Sender: TObject);
  begin
    try
      Reportviewer.NextPage;
    except
      on exception do;
    end;
  end;

  procedure TfrmReportClient.DoPreviousExecute(Sender: TObject);
  begin
    try
      If reportviewer.AbsolutePageNo>1 then
      reportviewer.PriorPage;
    except
      on exception do;
    end;
  end;

end.
