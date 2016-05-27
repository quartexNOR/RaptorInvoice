unit kreditnotaForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fakturareportForm, RzCommon, RzForms, ppMemo, ppBands, ppCtrls, ppReport,
  ppStrtch, ppSubRpt, ppPrnabl, ppClass, ppCache, ppProd, ppDB, ppComm,
  ppRelatv, ppDBPipe, Menus, ImgList, ActnList, ppViewr, StdCtrls, RzLabel,
  ExtCtrls, RzPanel, DBCtrls, RzDBNav, RzButton, RzBckgnd;

type
  TfrmKreditnota = class(TfrmFakturaReport)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmKreditnota: TfrmKreditnota;

implementation

{$R *.DFM}

end.
