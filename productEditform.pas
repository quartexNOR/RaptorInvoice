  unit productEditform;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, clientform, ActnList, StdCtrls, ExtCtrls,
  DBCtrls, Mask, data, globalvalues, ComCtrls, db;

  type TfrmEditProduct = class(TfrmClient)
    GroupBox1: TGroupBox;
    AType: TDBEdit;
    ANavn: TDBEdit;
    Label7: TLabel;
    Label9: TLabel;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    ABeskrivelse: TDBMemo;
    Panel3: TPanel;
    ALeverandor: TDBLookupComboBox;
    APris: TDBEdit;
    AReferanse: TDBEdit;
    Label10: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    BPris: TDBEdit;
    Label11: TLabel;
    nAvanse: TComboBox;
    Label12: TLabel;
    nMVA: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure nAvanseChange(Sender: TObject);
    procedure APrisChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure APrisKeyPress(Sender: TObject; var Key: Char);
    procedure BPrisKeyPress(Sender: TObject; var Key: Char);
    procedure nMVAChange(Sender: TObject);
  private
    FAvanser: Array[0..3] of Currency;
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  procedure TfrmEditProduct.FormCreate(Sender: TObject);
  begin
    inherited;
    FAvanser[0]:=1.5;
    FAvanser[1]:=2.0;
    FAvanser[2]:=2.5;
    FAvanser[3]:=3.0;
  end;

  procedure TfrmEditProduct.FormShow(Sender: TObject);
  begin
    inherited;
    AppData.produkter.Edit;

    Case AppData.Produkter.FieldValues['MVA'] of
    24: nMVA.ItemIndex:=0;
    12: nMVA.ItemIndex:=1;
    06: nMVA.ItemIndex:=2;
    End;

    nAvanse.ItemIndex:=4;
  end;

  procedure TfrmEditProduct.DoCancelExecute(Sender: TObject);
  begin
    With AppData.Produkter do
    begin
      Cancel;
      CommitUpdates;
    end;
    inherited;
  end;

  procedure TfrmEditProduct.DoOKExecute(Sender: TObject);
  var
    FText:  String;
  begin
    { Validate name field }
    FText:=AppData.Produkter.FieldByName('Tittel').AsString;
    FText:=trim(FText);
    if Length(FText)=0 then
    begin
      CauseFieldError('Navn');
      ANavn.SetFocus;
      Exit;
    End;

    { Validate name field }
    FText:=ALeverandor.Text;
    FText:=trim(FText);
    if Length(FText)=0 then
    begin
      CauseFieldError('Leverandør');
      ALeverandor.SetFocus;
      Exit;
    End;

    { Null verdi? }
    If AppData.Produkter.FieldValues['InnPris']<0.0 then
    Begin
      CauseFieldError('InnPris');
      APris.SetFocus;
      Exit;
    End;

    { UtPris mindre enn innpris? }
    If AppData.Produkter.FieldValues['UtPris']<AppData.Produkter.FieldValues['InnPris'] then
    Begin
      CauseFieldError('UtPris');
      APris.SetFocus;
      Exit;
    End;

    With AppData.Produkter do
    Begin
      Post;
      ApplyUpdates;
      CommitUpdates;
    end;
    inherited;
  end;

  procedure TfrmEditProduct.nAvanseChange(Sender: TObject);
  var
    FIndex: Integer;
  begin
    inherited;
    If nAvanse.ItemIndex=4 then
    Begin
      If bPris.Enabled=False then
      Begin
        AppData.Produkter.FieldValues['Utpris']:=AppData.Produkter.FieldValues['InnPris'];
        bPris.Enabled:=True;
        bPris.SetFocus;
      end;
    end else
    Begin
      if bPris.Enabled then
      bPris.Enabled:=False;
      FIndex:=nAvanse.ItemIndex;
      AppData.Produkter.FieldValues['Utpris']:=AppData.Produkter.FieldValues['InnPris'] * FAvanser[FIndex];
    End;
  end;

  procedure TfrmEditProduct.APrisChange(Sender: TObject);
  begin
    inherited;
    If (AppData.produkter.State=dsEdit)
    or (AppData.produkter.state=dsInsert) then
    nAvanseChange(self);
  end;

  procedure TfrmEditProduct.APrisKeyPress(Sender: TObject; var Key: Char);
  begin
    { filtrere bort muligheten for minus verdier }
    If pos(key,Application_Numeric)<1 then
    Begin
      If  (Key<>#8)
      and (Key<>',') then
      Key:=#0;
    end;
  end;

  procedure TfrmEditProduct.BPrisKeyPress(Sender: TObject; var Key: Char);
  begin
    { filtrere bort muligheten for minus verdier }
    If pos(key,Application_Numeric)<1 then
    Begin
      If  (Key<>#8)
      and (Key<>',') then
      Key:=#0;
    end;
  end;

  procedure TfrmEditProduct.nMVAChange(Sender: TObject);
  begin
    inherited;
    Case nMVA.ItemIndex of
    0:  AppData.Produkter.FieldValues['MVA']:=24;
    1:  AppData.Produkter.FieldValues['MVA']:=12;
    2:  AppData.Produkter.FieldValues['MVA']:=6;
    End;
  end;

end.
