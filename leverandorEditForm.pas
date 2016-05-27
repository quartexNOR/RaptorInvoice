  unit leverandorEditForm;

  interface

  uses data, Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, clientform, ActnList, StdCtrls,
  ExtCtrls, Mask, DBCtrls, ComCtrls, ttGlobal, ttSpellCheck, Buttons,
  ImgList, Menus, globalvalues;

  type TfrmEditLeverandor = class(TfrmClient)
    Image1: TImage;
    Label14: TLabel;
    Label15: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    nFirma: TDBEdit;
    nAdresse: TDBEdit;
    nPostNr: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    nKommentarer: TDBMemo;
    Label9: TLabel;
    DBEdit7: TDBEdit;
    Label10: TLabel;
    DBEdit8: TDBEdit;
    Label13: TLabel;
    DBEdit1: TDBEdit;
    Panel3: TPanel;
    Label12: TLabel;
    Label11: TLabel;
    DBEdit9: TDBEdit;
    Label6: TLabel;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure nPostNrKeyPress(Sender: TObject; var Key: Char);
    procedure DBEdit5KeyPress(Sender: TObject; var Key: Char);
    procedure DBEdit6KeyPress(Sender: TObject; var Key: Char);
    procedure nPostNrExit(Sender: TObject);
  private
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmEditLeverandor.FormShow(Sender: TObject);
  begin
    inherited;
    AppData.Leverandorer.Edit;
  end;

  procedure TfrmEditLeverandor.DoCancelExecute(Sender: TObject);
  begin
    With AppData.Leverandorer do
    Begin
      Cancel;
      CommitUpdates;
    end;
    inherited;
  end;

  procedure TfrmEditLeverandor.DoOKExecute(Sender: TObject);
  begin
    With AppData.Leverandorer do
    Begin
      Post;
      ApplyUpdates;
      CommitUpdates;
    end;
    inherited;
  end;

  procedure TfrmEditLeverandor.nPostNrKeyPress(Sender: TObject;var Key: Char);
  begin
    If pos(key,Application_Numeric)<1 then
    If Key<>#8 then
    Key:=#0;
  end;

  procedure TfrmEditLeverandor.DBEdit5KeyPress(Sender: TObject;var Key: Char);
  begin
    If pos(key,Application_Numeric)<1 then
    If Key<>#8 then
    Key:=#0;
  end;

  procedure TfrmEditLeverandor.DBEdit6KeyPress(Sender: TObject;var Key: Char);
  begin
    inherited;
    If pos(key,Application_Numeric)<1 then
    If Key<>#8 then
    Key:=#0;
  end;

  procedure TfrmEditLeverandor.nPostNrExit(Sender: TObject);
  begin
    { Finne stedsnavn fra postnr }
    try
      If AppData.PostSteder.find('postnr',[npostnr.text],True) then
      AppData.Leverandorer.FieldValues['sted']:=AppData.PostSteder.fieldvalues['poststed'];
    except
      on exception do;
    end;
  end;

end.
