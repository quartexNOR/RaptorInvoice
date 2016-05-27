  unit kundeValgForm;

  interface

  uses data, Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  RzPanel, RzLabel, RzButton, dxTL, dxDBCtrl, dxDBGrid, dxCntner, dxExEdtr,
  ActnList;

  Type TfrmKundeValg = class(TForm)
    btnOK: TRzButton;
    btnCancel: TRzButton;
    grid: TdxDBGrid;
    gridColumn1: TdxDBGridColumn;
    ActionList1: TActionList;
    DoOK: TAction;
    DoCancel: TAction;
    procedure FormCreate(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure DoOKUpdate(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmKundeValg.FormCreate(Sender: TObject);
  begin
    if appdata.DataSetReady(AppData.Kunder) then
    Begin
      If AppData.Kunder.RecordCount=0 then
      grid.Enabled:=False else
      AppData.Kunder.First;
    end;
  end;

  procedure TfrmKundeValg.gridDblClick(Sender: TObject);
  begin
    if appdata.DataSetReady(AppData.Kunder) then
    Begin
      If AppData.Kunder.RecordCount=0 then
      Beep else
      DoOK.Execute;
    end;
  end;

  procedure TfrmKundeValg.DoOKExecute(Sender: TObject);
  begin
    modalresult:=mrOK;
  end;

  procedure TfrmKundeValg.DoOKUpdate(Sender: TObject);
  begin
    DoOK.Enabled:=appdata.DataSetReady(AppData.Kunder)
    and (AppData.Kunder.RecordCount>0)
    and (AppData.Kunder.RecNo>0)
    and (grid.enabled=True);
  end;

  procedure TfrmKundeValg.DoCancelExecute(Sender: TObject);
  begin
    modalresult:=mrCancel;
  end;

end.
