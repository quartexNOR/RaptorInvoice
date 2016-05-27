  unit fakturereForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, clientform, ActnList, StdCtrls, ExtCtrls, Mask,
  DBCtrls, ComCtrls, ImgList,
  globalvalues,
  data,
  RzButton, RzBckgnd, RzLabel, RzStatus, RzPanel, RzDBNav,
  RzDTP, RzRadChk, RzSpnEdt, RzPopups, RzSndMsg, RzDlgBtn;

  Type TfrmFakturer = class(TfrmClient)
    Panel1: TPanel;
    RzGroupBox1: TRzGroupBox;
    nSetDato: TRzCheckBox;
    nDato: TRzCalendar;
    RzGroupBox2: TRzGroupBox;
    nUtskrift: TRzCheckBox;
    nEksemplarer: TRzSpinner;
    RzLabel1: TRzLabel;
    Label1: TLabel;
    procedure nSetDatoClick(Sender: TObject);
    procedure nUtskriftClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmFakturer.FormShow(Sender: TObject);
  begin
    inherited;
    nDato.Date:=Now;
    HideNavigator;
  end;

  procedure TfrmFakturer.nSetDatoClick(Sender: TObject);
  begin
    nDato.Enabled:=(nSetDato.Checked=True);
    If nDato.Enabled then
    nDato.Color:=clWindow else
    nDato.Color:=clBtnFace;
  end;

  procedure TfrmFakturer.nUtskriftClick(Sender: TObject);
  begin
    nEksemplarer.Enabled:=(nUtskrift.Checked=true);
  end;

end.
