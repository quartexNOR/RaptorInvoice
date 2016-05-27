  unit jlrastereditorform;

  interface

  uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, Buttons, ImgList, ExtCtrls,
  ComCtrls, ToolWin, jldisplay, jlgraphics, jlraster;

  type

  TfrmJLRasterEditor = class(TForm)
    Panel1: TPanel;
    ImageList1: TImageList;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    ActionList1: TActionList;
    DoOK: TAction;
    DoCancel: TAction;
    Panel2: TPanel;
    Bevel2: TBevel;
    DoImport: TAction;
    DoExport: TAction;
    DoReset: TAction;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Viewer: TJLRasterViewer;
    OpenDialog: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Picture:  TJLDIBSurface;
    procedure DoOKExecute(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DoImportExecute(Sender: TObject);
    procedure DoExportExecute(Sender: TObject);
    procedure DoResetExecute(Sender: TObject);
    procedure DoResetUpdate(Sender: TObject);
    procedure DoExportUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FSurface: TJLCustomRaster;
    Procedure SetSurface(value:TJLCustomRaster);
  public
    { Public declarations }
    Property  Surface:TJLCustomRaster read FSurface write SetSurface;
  end;

  implementation

  {$R *.dfm}

  Procedure TfrmJLRasterEditor.SetSurface(value:TJLCustomRaster);
  Begin
    If  (Value<>NIL)
    and (Value<>Picture) then
    Begin
      FSurface:=Value;
      if not Value.Empty then
      Picture.assign(Value) else
      Picture.Release;
    end;
  end;

  procedure TfrmJLRasterEditor.DoOKExecute(Sender: TObject);
  begin
    If FSurface<>NIL then
    Begin
      If Picture.Empty then
      FSurface.Release else
      FSurface.Assign(Picture);
    end;
    modalresult:=mrOK;
  end;

  procedure TfrmJLRasterEditor.DoCancelExecute(Sender: TObject);
  begin
    If not Picture.Empty then
    Picture.Release;
    modalresult:=mrCancel;
  end;

  procedure TfrmJLRasterEditor.FormKeyPress(Sender: TObject; var Key: Char);
  begin
    If Key=#27 then
    DoCancel.Execute;
  end;

  procedure TfrmJLRasterEditor.DoImportExecute(Sender: TObject);
  begin
    If OpenDialog.Execute then
    Begin
      If not Picture.LoadFromFile(OpenDialog.Filename) then
      ShowMessage('Failed to load image: ' + #13
      + Picture.GetLastError);
    end;
  end;

  procedure TfrmJLRasterEditor.DoExportExecute(Sender: TObject);
  begin
    //
  end;

  procedure TfrmJLRasterEditor.DoResetExecute(Sender: TObject);
  begin
    Picture.Release;
  end;

  procedure TfrmJLRasterEditor.DoResetUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    DoReset.Enabled:=Picture.Empty=False;
  end;

  procedure TfrmJLRasterEditor.DoExportUpdate(Sender: TObject);
  begin
    If not (csDestroying in ComponentState) then
    DoExport.Enabled:=Picture.Empty=False;
  end;

  procedure TfrmJLRasterEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
  begin
    application.ProcessMessages;
    Action:=caHide;
  end;

end.
