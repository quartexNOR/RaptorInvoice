  unit betaleForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  clientform, RzSndMsg, ActnList, DBCtrls, RzDBNav, ExtCtrls, RzDlgBtn, db,
  StdCtrls, RzLabel, RzPanel, RzBckgnd, data, RzDBLbl, RzSpnEdt, RzDBSpin,
  ImgList, RzButton;

  type

  TfrmBetale = class(TfrmClient)
    RzGroupBox1: TRzGroupBox;
    lbKunde: TRzLabel;
    RzLabel2: TRzLabel;
    RzDBLabel1: TRzDBLabel;
    RzDBLabel2: TRzDBLabel;
    RzLabel1: TRzLabel;
    RzLabel3: TRzLabel;
    RzDBLabel3: TRzDBLabel;
    RzLabel4: TRzLabel;
    RzDBLabel4: TRzDBLabel;
    RzLabel5: TRzLabel;
    RzDBLabel5: TRzDBLabel;
    RzLabel6: TRzLabel;
    RzDBLabel6: TRzDBLabel;
    RzDBLabel7: TRzDBLabel;
    RzLabel7: TRzLabel;
    RzGroupBox2: TRzGroupBox;
    RzLabel10: TRzLabel;
    RzDBLabel8: TRzDBLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmBetale.FormShow(Sender: TObject);
  begin
    inherited;
    If Appdata.FakturaTotal.Value<>Appdata.FakturaPris.Value then
    Begin
      //
    end;
  end;

  end.
