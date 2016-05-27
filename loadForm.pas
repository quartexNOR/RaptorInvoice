  unit loadForm;

  Interface

  uses

  data,
  jlcommon,

  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Db, VolgaTbl,
  FileCtrl,ActnList, ImgList,ComCtrls,

  RzBckgnd,RzStatus,RzDlgBtn, RzTabs,RzListVw,
  RzButton, RzLstBox, RzForms, RzLabel,RzPanel, Menus;

  Type

  TfrmLoader = class(TForm)
    Label2: TLabel;
    Panel1: TPanel;
    RzDialogButtons1: TRzDialogButtons;
    lbTitle: TRzLabel;
    lbHelp1: TRzLabel;
    Image1: TImage;
    RzSeparator1: TRzSeparator;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    RzBitBtn3: TRzBitBtn;
    ActionList1: TActionList;
    DoNewRegister: TAction;
    DoOpenRegister: TAction;
    DoDeleteRegister: TAction;
    ImageList1: TImageList;
    nDB: TRzListView;
    DoRefreshList: TAction;
    PopupMenu1: TPopupMenu;
    Nyttregister1: TMenuItem;
    pneregister1: TMenuItem;
    Slettregister1: TMenuItem;
    N1: TMenuItem;
    DoRefreshList1: TMenuItem;
    procedure DoNewRegisterExecute(Sender: TObject);
    procedure DoDeleteRegisterExecute(Sender: TObject);
    procedure DoOpenRegisterExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RegListDblClick(Sender: TObject);
    procedure DoRefreshListExecute(Sender: TObject);
    procedure DoOpenRegisterUpdate(Sender: TObject);
    procedure DoDeleteRegisterUpdate(Sender: TObject);
    procedure nDBKeyPress(Sender: TObject; var Key: Char);
  private
    Function OpenStore(aStoreName:String):Boolean;
  public
    //
  end;

  implementation

  {$R *.DFM}

  uses globalvalues, registerform;

  procedure TfrmLoader.FormShow(Sender: TObject);
  begin
    DoRefreshList.Execute;
  end;

  procedure TfrmLoader.DoNewRegisterExecute(Sender: TObject);
  var
    x:  Integer;
  begin
    With TfrmRegister.Create(self) do
    Begin
      try
        if nDB.Items.Count>0 then
        Begin
          for x:=1 to nDB.Items.Count do
          nKilde.Items.Add(nDb.Items[x-1].Caption);
          nKilde.ItemIndex:=0;
        end;
        If ShowModal=mrOK then
        DoRefreshList.Execute;
      finally
        Free;
      end;
    end;
  end;

  procedure TfrmLoader.DoDeleteRegisterExecute(Sender: TObject);
  var
    FItem:  TListItem;
    FPath:  String;
  begin
    If nDB.Items.Count>0 then
    Begin
      FItem:=nDB.Selected;
      If FItem<>NIL then
      Begin
        FPath:=IncludeTrailingPathDelimiter(GetPathForDatabases);
        FPath:=FPath + FItem.Caption;
        If DirectoryExists(FPath) then
        Begin
          try
            jlcommon.JL_DeleteFolder(FPath);
          finally
            DoRefreshList.Execute;
          end;
        end;
      end;
    end;
  end;

  procedure TfrmLoader.DoOpenRegisterExecute(Sender: TObject);
  var
    FItem:  TListItem;
  begin
    If nDB.Items.Count>0 then
    Begin
      FItem:=nDB.Selected;
      If FItem<>NIL then
      Begin
        If OpenStore(FItem.Caption) then
        Close else
        Beep;
      end;
    end;
  end;

  procedure TfrmLoader.DoRefreshListExecute(Sender: TObject);
  var
    FItems: TStrArray;
    FCount: Integer;
    x:      Integer;
  begin
    (* enumerate sub folders *)
    nDb.Items.BeginUpdate;
    nDb.Items.clear;
    try
      if JL_FolderExamineDirectories(GetPathForDatabases,FItems,FCount) then
      Begin
        for x:=low(FItems) to High(FItems) do
        Begin
          With nDb.Items.Add do
          Caption:=FItems[x];
        end;
      end;
    finally
      SetLength(FItems,0);
      nDB.Items.EndUpdate;
    end;
  end;

  Function TfrmLoader.OpenStore(aStoreName:String):Boolean;
  var
    FPath:  String;
  Begin
    result:=False;
    aStoreName:=trim(aStoreName);
    If length(aStoreName)>0 then
    Begin
      (* Check target directory *)
      FPath:=IncludeTrailingPathDelimiter(GetPathForDatabases) + aStoreName;
      If DirectoryExists(FPath) then
      Begin

        (* attempt to open data store *)
        try
          AppData.OpenDataStore(FPath);
        except
          on e: exception do
          Begin
            ShowMessage(e.message);
            exit;
          end;
        end;

        Result:=True;
      end;
    end;
  end;

  procedure TfrmLoader.RegListDblClick(Sender: TObject);
  var
    FItem:  TListItem;
  begin
    If nDB.Items.Count>0 then
    Begin
      FItem:=nDB.Selected;
      If FItem<>NIL then
      Begin
        If OpenStore(FItem.Caption) then
        Close else
        Beep;
      end;
    end;
  end;

  procedure TfrmLoader.DoOpenRegisterUpdate(Sender: TObject);
  begin
    DoOpenRegister.Enabled:=(ndb.Items.Count>0)
    and (nDB.Selected<>NIL);
  end;

  procedure TfrmLoader.DoDeleteRegisterUpdate(Sender: TObject);
  begin
    DoDeleteRegister.Enabled:=(ndb.Items.Count>0)
    and (nDB.Selected<>NIL);
  end;

  procedure TfrmLoader.nDBKeyPress(Sender: TObject; var Key: Char);
  begin
    If Key=#13 then
    DoOpenRegister.Execute;
  end;

end.
