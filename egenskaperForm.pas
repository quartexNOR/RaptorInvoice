  unit egenskaperForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, RzPanel, ExtCtrls, RzDlgBtn, RzDBLbl, StdCtrls,
  RzLabel, data, globalvalues;

  Type TfrmEgenskaper = class(TForm)
    RzDialogButtons1: TRzDialogButtons;
    RzGroupBox1: TRzGroupBox;
    lbType: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    lbPurringer: TRzDBLabel;
    RzDBLabel1: TRzDBLabel;
    RzDBLabel2: TRzDBLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
  frmEgenskaper: TfrmEgenskaper;

  implementation

  {$R *.DFM}

  end.
