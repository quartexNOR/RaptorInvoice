  unit grupperForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  clientform, RzSndMsg, ActnList, DBCtrls, RzDBNav, ExtCtrls, RzDlgBtn,
  StdCtrls, RzLabel, RzPanel, RzBckgnd, ComCtrls, RzListVw, data, RzTabs,
  ImgList, RzButton;

  type TfrmGrupper = class(TfrmClient)
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    nGroups: TRzListView;
    ImageList1: TImageList;
    btnNyGruppe: TRzBitBtn;
    btnSlettGruppe: TRzBitBtn;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnNyGruppeClick(Sender: TObject);
    procedure nGroupsDblClick(Sender: TObject);
  private
    Procedure LoadGroups;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  uses kundegruppeform, globalvalues;

  procedure TfrmGrupper.FormShow(Sender: TObject);
  begin
    inherited;

    (* read only mode? *)
    If Appdata.KundeGrupper.ReadOnly then
    Begin
      BtnNyGruppe.Enabled:=False;
      btnSlettGruppe.Enabled:=False;
    end;

    LoadGroups;
  end;

  procedure TfrmGrupper.LoadGroups;
  Begin
    nGroups.Items.Clear;
    ngroups.Enabled:=False;
    try
      Appdata.KundeGrupper.first;
      While not Appdata.kundegrupper.Eof do
      begin
        With nGroups.Items.Add do
        Begin
          Caption:=Appdata.KundeGrupperTittel.Value;
          ImageIndex:=0;
        end;
        Appdata.kundegrupper.next;
      end;
    finally
      if nGroups.Items.Count>0 then
      nGroups.Enabled:=True;
    end;
  end;

  procedure TfrmGrupper.btnNyGruppeClick(Sender: TObject);
  begin
    inherited;
    With TfrmKundeGruppe.Create(self) do
    Begin
      try
        RecordMode:=arAppend;
        if ShowModal=mrOK then
        LoadGroups;
      finally
        Free;
      end;
    end;
  end;

  procedure TfrmGrupper.nGroupsDblClick(Sender: TObject);
  begin
    inherited;

    If (nGroups.Enabled=False)
    or (nGroups.Items.Count=0)
    or (ngroups.Selected=NIL) then
    exit;

    If Appdata.KundeGrupper.find('tittel',[nGroups.Selected.Caption],True)=True then
    Begin
      If (Appdata.KundeGrupperId.Value=1)
      or (lowercase(Appdata.KundeGrupperTittel.Value)='ny kunde') then
      Begin
        ShowMessage('Denne gruppen kan ikke redigeres');
        exit;
      end;

      With TfrmKundeGruppe.Create(self) do
      Begin
        try
          RecordMode:=arEdit;
          If ShowModal=mrOK then
          LoadGroups;
        finally
          Free;
        end;
      end;
    end;
  end;

end.
