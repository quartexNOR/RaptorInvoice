  unit editpurringerform;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RzSpnEdt, RzDBSpin, StdCtrls, RzLabel, RzDlgBtn, ExtCtrls, RzPanel, data,
  ActnList, db, globalvalues;

  type TfrmEditPurringer = class(TForm)
    RzGroupBox1: TRzGroupBox;
    RzDialogButtons1: TRzDialogButtons;
    lbKunde: TRzLabel;
    RzLabel1: TRzLabel;
    RzDBSpinner1: TRzDBSpinner;
    RzDBSpinner2: TRzDBSpinner;
    ActionList1: TActionList;
    DoOK: TAction;
    DoCancel: TAction;
    Label1: TLabel;
    procedure DoOKExecute(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmEditPurringer.DoOKExecute(Sender: TObject);
  begin
    If (Appdata.faktura.readonly=false) then
    Begin
      if (Appdata.Faktura.State=dsEdit)
      or (Appdata.Faktura.State=dsInsert) then
      Begin
        try
          AppData.Faktura.Post;
          AppData.Faktura.ApplyUpdates;
          AppData.Faktura.CommitUpdates;
        except
          on e: exception do
          ErrorDialog(ClassName,'DoOKExecute()',e.message);
        end;
      end;
    end;
  end;

  procedure TfrmEditPurringer.DoCancelExecute(Sender: TObject);
  begin
    If (Appdata.faktura.readonly=false) then
    Begin
      if (Appdata.Faktura.State=dsEdit)
      or (Appdata.Faktura.State=dsInsert) then
      Begin
        try
          AppData.Faktura.Cancel;
          AppData.faktura.CommitUpdates;
          Appdata.Faktura.ApplyUpdates;
        except
          on e: exception do
          ErrorDialog(ClassName,'DoCancelExecute()',e.message);
        end;
      end;
    end;
  end;

  procedure TfrmEditPurringer.FormShow(Sender: TObject);
  begin
    If (Appdata.faktura.readonly=false) then
    If AppData.Faktura.state<>dsEdit then
    AppData.Faktura.Edit;
  end;

  procedure TfrmEditPurringer.FormClose(Sender: TObject;var Action: TCloseAction);
  begin
    (* user closed the window rather than pressing Cancel button? *)
    If (Appdata.faktura.readonly=false) then
    If (Appdata.Faktura.State=dsEdit)
    or (Appdata.Faktura.State=dsInsert) then
    DoCancel.Execute;
  end;

end.
