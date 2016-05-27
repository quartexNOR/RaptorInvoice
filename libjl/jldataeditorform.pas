  unit jldataeditorform;

  interface

  uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, Buttons, ImgList, ExtCtrls;

  type

  TfrmJLDataEditor = class(TForm)
    Panel1: TPanel;
    ImageList1: TImageList;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    ActionList1: TActionList;
    DoOK: TAction;
    DoCancel: TAction;
    Panel2: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    GroupBox1: TGroupBox;
    DoImport: TAction;
    DoExport: TAction;
    DoReset: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Image1: TImage;
    procedure DoOKExecute(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  implementation

  {$R *.dfm}

  procedure TfrmJLDataEditor.DoOKExecute(Sender: TObject);
  begin
    modalresult:=mrOK;
  end;

  procedure TfrmJLDataEditor.DoCancelExecute(Sender: TObject);
  begin
    modalresult:=mrCancel;
  end;

  procedure TfrmJLDataEditor.FormKeyPress(Sender: TObject; var Key: Char);
  begin
    If Key=#27 then
    DoCancel.Execute;
  end;

end.
