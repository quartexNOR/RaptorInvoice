  unit produktValgForm;

  interface

  uses
  Data,Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, Grids, 
  RzLabel, RzBckgnd, RzCmboBx, dxTL, dxDBCtrl, dxDBGrid, dxCntner, RzEdit,
  RzDBEdit, RzPanel, dxExEdtr, ActnList, RzButton;

  Type TfrmVelgProdukt = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    RzGroupBox1: TRzGroupBox;
    Grid: TdxDBGrid;
    GridColumn1: TdxDBGridColumn;
    GridColumn2: TdxDBGridColumn;
    GridColumn4: TdxDBGridColumn;
    RzGroupBox2: TRzGroupBox;
    lbProdukt: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzSeparator1: TRzSeparator;
    RzLabel3: TRzLabel;
    ARabatt: TRzDBNumericEdit;
    RzLabel4: TRzLabel;
    nMva: TRzComboBox;
    AAntall: TRzDBNumericEdit;
    APris: TRzDBNumericEdit;
    ANavn: TRzDBEdit;
    Panel2: TPanel;
    RzButton1: TRzButton;
    RzButton2: TRzButton;
    ActionList1: TActionList;
    DoAdd: TAction;
    DoClose: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoAddExecute(Sender: TObject);
    procedure DoCloseExecute(Sender: TObject);
  private
    FRabatt:  Integer;
  public
    Property  RabattProsent:Integer read FRabatt write FRabatt;
  end;

  implementation

  {$R *.DFM}

  uses globalvalues, jlcommon;

  procedure TfrmVelgProdukt.FormCreate(Sender: TObject);
  var
    x:  Integer;
    FMVAList: TIntArray;
  begin
    inherited;
    (* Setup MVA options *)
    nMVA.items.BeginUpdate;
    Try
      appdata.GetMVAList(FMVAList);
      nMVA.Items.Clear;
      for x:=Low(FMVAList) to high(FMVAList) do
      nMVA.Items.Add(IntToStr(FMVAList[x]) + '%');
    finally
      nMVA.items.endupdate;
    end;
  end;

  procedure TfrmVelgProdukt.FormShow(Sender: TObject);
  begin
    AppData.FakturaData.Append;
    AppData.FakturaDataAntall.AsFloat:=1;
    AppData.FakturaDataRabatt.AsInteger:=FRabatt;
    nMVA.ItemIndex:=0;

    (* sorter varer etter tittel *)
    Appdata.produkter.IndexFieldNames:='tittel;';
    Appdata.Produkter.SortRecords(true);
  end;

  procedure TfrmVelgProdukt.FormClose(Sender: TObject;var Action: TCloseAction);
  begin
    Action:=caFree;
    AppData.FakturaData.Cancel;
    AppData.FakturaData.CommitUpdates;
    Appdata.produkter.IndexFieldNames:='';
  end;

  procedure TfrmVelgProdukt.GridClick(Sender: TObject);
  var
    FTitle: String;
    FIndex: Integer;
  begin
    { check that we can do this }
    If (AppData.Produkter.Active=False)
    or (AppData.Produkter.Recordcount=0) then
    exit;

    FIndex:=nMVA.Items.IndexOf(AppData.ProdukterMva.AsString + '%');
    If FIndex>=0 then
    nMVA.ItemIndex:=FIndex;

    AppData.FakturaDataMva.AsInteger:=AppData.ProdukterMva.AsInteger;

    FTitle:=AppData.ProdukterTittel.Value;
    If (AppData.ProdukterType.IsNull=False)
    and (AppData.ProdukterType.Value<>'') then
    FTitle:=FTitle + ' / ' + AppData.ProdukterType.AsString;

    AppData.FakturaDataProdukt.AsString:=FTitle;
    AppData.FakturaDataPris.AsCurrency:=AppData.ProdukterUtPris.AsCurrency;
    AppData.FakturaDataRabatt.AsInteger:=FRabatt;
  end;

  procedure TfrmVelgProdukt.DoAddExecute(Sender: TObject);

    Procedure CauseFakturaProdukterError;
    var
      FText:  String;
    Begin
      FText:='En faktura kan kun inneholde 10 produktlinjer!'#13;
      Application.MessageBox(PChar(FText),
      'Faktura produktgrense',MB_ICONINFORMATION);
    End;

  var
    FText:  String;
    FValue: Integer;

  begin
    lbProdukt.Blinking:=False;

    If Appdata.FakturaData.RecordCount>9 then
    Begin
      CauseFakturaProdukterError;
      exit;
    End;

    { Validate produkt navn }
    FText:=trim(AppData.FakturaDataProdukt.Value);
    If Length(FText)=0 then
    Begin
      Beep;
      lbProdukt.Blinking:=True;
      ANavn.SetFocus;
      exit;
    End;

    FText:=trim(StringReplace(nMVA.Text,'%','',[rfReplaceAll]));
    If sysutils.TryStrToInt(FText,FValue) then
    appdata.FakturaDataMva.AsInteger:=FValue;

    AppData.FakturaDataFakturaId.AsInteger:=AppData.FakturaId.Value;
    AppData.FakturaData.Post;
    AppData.FakturaData.ApplyUpdates;
    AppData.FakturaData.CommitUpdates;

    AppData.FakturaData.Append;
    Appdata.FakturaDataAntall.AsFloat:=1;
    AppData.FakturaDataRabatt.AsInteger:=FRabatt;
    ANavn.SetFocus;
  end;

  procedure TfrmVelgProdukt.DoCloseExecute(Sender: TObject);
  begin
    Modalresult:=mrOK;
  end;

end.
