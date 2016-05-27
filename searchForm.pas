  unit searchForm;

  interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, clientform, ActnList, StdCtrls, ExtCtrls, Mask,
  ComCtrls, ImgList, db, DBCtrls,
  globalvalues, jlstrparse,
  data,
  RzButton, RzBckgnd, RzLabel, RzStatus, RzPanel, RzDBNav,
  RzDTP, RzRadChk, RzSpnEdt, RzPopups, RzDBEdit, RzTabs, RzEdit, RzCmboBx,
  RzDBCmbo, RzListVw, RzSndMsg, RzDlgBtn;

  Type

  TfrmSearch = class(TfrmClient)
    Panel3: TPanel;
    RzGroupBox1: TRzGroupBox;
    lbKunde: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    AText: TRzEdit;
    AType: TRzComboBox;
    Results: TRzListView;
    lbStatus: TRzMarqueeStatus;
    Small: TImageList;
    RzBitBtn1: TRzBitBtn;
    procedure DoOKExecute(Sender: TObject);
    procedure ResultsDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ATextKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FParser:  TJLTextParser;
    FBusy:    Boolean;
    Procedure SearchLeverandorer;
    Procedure SearchProdukter;
    Procedure SearchKunder;
    Procedure SearchFaktura;
  public
    Procedure StatusText(Value:String);
  end;

  implementation

  {$R *.DFM}


  procedure TfrmSearch.FormCreate(Sender: TObject);
  begin
    inherited;
    FParser:=TJLTextParser.Create;
    HideNavigator;
  end;

  procedure TfrmSearch.FormDestroy(Sender: TObject);
  begin
    inherited;
    FParser.free;
  end;

  Procedure TfrmSearch.StatusText(Value:String);
  Begin
    lbStatus.Caption:=Value;
    lbStatus.Update;
    Application.ProcessMessages;
  End;

  procedure TfrmSearch.DoOKExecute(Sender: TObject);
  var
    FText:  String;

    Procedure EditErrorFocus;
    Begin
      Beep;
      If AText.Enabled then
      Atext.SetFocus;
    end;

  begin
    modalresult:=mrNone;
    Screen.Cursor:=crHourGlass;
    FBusy:=True;
    try
      Results.Items.BeginUpdate;
      try
        Results.Items.Clear;
        FText:=trim(aText.Text);
        If length(FText)>0 then
        begin
          FParser.ParseText(lowercase(FText));
          If FParser.Elements.Count>0 then
          Begin
            DoOk.Enabled:=False;
            AText.Enabled:=False;
            AType.Enabled:=False;
            try
              Case (AType.ItemIndex) of
              GROUP_LEVERANDORER: SearchLeverandorer;
              GROUP_PRODUKTER:    SearchProdukter;
              GROUP_KUNDER:       SearchKunder;
              GROUP_FAKTURA:      SearchFaktura;
              GROUP_ALLE:
                Begin
                  SearchLeverandorer;
                  SearchProdukter;
                  SearchKunder;
                  SearchFaktura;
                End;
              end;
              StatusText('Søk er utført, '
              + IntToStr(results.items.count)
              + ' poster funnet');
            finally
              DoOk.Enabled:=True;
              AText.Enabled:=True;
              AType.Enabled:=True;
            end;
          end else
          EditErrorFocus;
        end else
        EditErrorFocus;
      finally
        Results.Items.EndUpdate;
      end;
    finally
      Screen.Cursor:=crDefault;
      FBusy:=False;
    end;

  end;

  Procedure TfrmSearch.SearchLeverandorer;
  var
    x:      Integer;
    FText:  String;
    FWord:  String;
    FOldRec:  Integer;
  Begin
    if assigned(appdata)
    and appdata.DataStoreActive
    and appdata.DataSetReady(AppData.Leverandorer) then
    Begin
      FOldRec:=appdata.Leverandorer.RecNo;
      AppData.Leverandorer.DisableControls;

      try

        (* Initialize *)
        AppData.Leverandorer.First;
        StatusText('Søker i leverandør register');

        While not AppData.Leverandorer.Eof do
        Begin
          (* Fetch company name *)
          if not Appdata.LeverandorerFirma.IsNull then
          Begin
            FText:=Appdata.LeverandorerFirma.Value;

            for x:=1 to FParser.Elements.Count do
            Begin
              FWord:=FParser.Elements[x-1].Value;
              if pos(FWord,lowercase(FText))>0 then
              Begin
                (* Insert into results *)
                With Results.Items.Add do
                begin
                  Caption:='Leverandør';
                  ImageIndex:=1;
                  Subitems.Add(FText);
                  Subitems.Add('');
                  Subitems.Add(AppData.LeverandorerId.AsString);
                End;
                Break;
              end;
            End;
          end;
          AppData.Leverandorer.Next;
        End;
      finally
        if FOldRec>=0 then
        appdata.Leverandorer.RecNo:=FOldRec;
        AppData.Leverandorer.EnableControls;
      end;
    end;
  End;

  Procedure TfrmSearch.SearchProdukter;
  var
    x:        Integer;
    FText:    String;
    FType:    String;
    FWord:    String;
    FOldRec:  Integer;
  Begin
    if assigned(appdata)
    and appdata.DataStoreActive
    and appdata.DataSetReady(AppData.Produkter) then
    Begin
      FOldRec:=appdata.Produkter.RecNo;
      AppData.Produkter.DisableControls;
      try
        (* Initialize *)
        AppData.Produkter.First;
        StatusText('Søker i produkt register');

        While not AppData.Produkter.Eof do
        Begin
          if not appdata.ProdukterType.IsNull then
          FType:=appdata.ProdukterType.Value else
          FType:='';

          if not Appdata.ProdukterTittel.IsNull then
          Ftext:=Appdata.ProdukterTittel.Value else
          Begin
            If Length(FType)>0 then
            Begin
              FText:=FType;
              FType:='';
            end else
            Begin
              AppData.Produkter.Next;
              Continue;
            end;
          end;

          { Keep this one? }
          for x:=1 to FParser.Elements.Count do
          Begin
            FWord:=lowercase(FParser.Elements[x-1].value);
            If  ( pos(FWord,lowercase(FText))>0 )
            or  ( pos(FWord,lowercase(FType))>0 ) then
            Begin
              With Results.Items.Add do
              begin
                ImageIndex:=2;
                Caption:='Produkt';
                Subitems.Add(FText + ',' + FType);
                Subitems.Add('');
                Subitems.Add(AppData.ProdukterId.AsString);
              End;
              Break;
            End;
          End;
          AppData.Produkter.Next;
        End;
      finally
        If FOldRec>=0 then
        appdata.Produkter.RecNo:=FOldRec;
        AppData.Produkter.EnableControls;
      end;
    end;
  End;

  Procedure TfrmSearch.SearchKunder;
  var
    x:      Integer;
    FText:  String;
    FWord:  String;
    FOldRec:  Integer;
  Begin
    if assigned(appdata)
    and appdata.DataStoreActive
    and appdata.DataSetReady(AppData.Kunder) then
    Begin
      FOldRec:=appdata.Kunder.RecNo;
      AppData.Kunder.DisableControls;
      try
        (* Initialize *)
        AppData.Kunder.First;
        StatusText('Søker i kunde register');

        While not AppData.Kunder.Eof do
        Begin
          { Get text }
          if not Appdata.kunderFirma.IsNull then
          Begin
            FText:=lowercase(AppData.KunderFirma.Value);

            { Keep this one? }
            for x:=1 to FParser.Elements.Count do
            Begin
              FWord:=FParser.Elements[x-1].value;
              If pos(FWord,lowercase(FText))>0 then
              Begin
                With Results.Items.Add do
                begin
                  ImageIndex:=4;
                  Caption:='Kunde';
                  Subitems.Add(FText);
                  Subitems.Add('');
                  Subitems.Add(AppData.KunderId.AsString);
                End;
                Break;
              End;
            End;
          end;
          AppData.Kunder.Next;
        End;
      finally
        if FOldRec>=0 then
        appdata.Kunder.RecNo:=FOldRec;
        AppData.Kunder.EnableControls;
      end;
    end;
  End;

  Procedure TfrmSearch.SearchFaktura;
  var
    x:      Integer;
    FText:  String;
    FWord:  String;
    FOldRec:  Integer;
  Begin
    if assigned(appdata)
    and appdata.DataStoreActive
    and appdata.DataSetReady(AppData.Faktura) then
    Begin
      FOldRec:=appdata.Faktura.RecNo;
      AppData.Faktura.DisableControls;
      try
        (* Initialize *)
        AppData.Faktura.First;
        StatusText('Søker i faktura register');

        While not AppData.Faktura.Eof do
        Begin
          If not Appdata.FakturaKunde.IsNull then
          Begin
            FText:=lowercase(AppData.FakturaKunde.Value);

            { Keep this one? }
            for x:=1 to FParser.Elements.Count do
            Begin
              FWord:=FParser.Elements[x-1].value;
              If pos(FWord,lowercase(FText))>0 then
              Begin
                With Results.Items.Add do
                begin
                  ImageIndex:=6;
                  Caption:='Faktura';
                  Subitems.Add(FText);
                  SubItems.Add(AppData.FakturaDato.AsString);
                  SubItems.Add(AppData.Fakturaid.AsString);
                End;
                Break;
              End;
            End;
          end;
          AppData.Faktura.Next;
        End;
      finally
        If FOldRec>=0 then
        appdata.faktura.RecNo:=FOldRec;
        AppData.faktura.EnableControls;
      end;
    end;
  End;

  procedure TfrmSearch.ResultsDblClick(Sender: TObject);
  var
    FText:  String;
  begin
    { Check that we can do this }
    If Results.Selected=NIL then
    Exit;

    FText:=lowercase(results.Selected.Caption);
    If FText='leverandør' then
    Begin
      FFindGroup:=GROUP_LEVERANDORER;
      FFindId:=StrToInt(Results.selected.SubItems[2]);
      Modalresult:=MrOK;
    End else
    if FText='faktura' then
    Begin
      FFindGroup:=GROUP_FAKTURA;
      FFindId:=StrToInt(Results.selected.SubItems[2]);
      Modalresult:=MrOK;
    End else
    If FText='kunde' then
    Begin
      FFindGroup:=GROUP_KUNDER;
      FFindId:=StrToInt(Results.selected.SubItems[2]);
      Modalresult:=MrOK;
    End else
    if FText='produkt' then
    Begin
      FFindGroup:=GROUP_PRODUKTER;
      FFindId:=StrToInt(Results.selected.SubItems[2]);
      Modalresult:=MrOK;
    End;
  end;

  procedure TfrmSearch.ATextKeyPress(Sender: TObject; var Key: Char);
  begin
    inherited;
    if Key=#13 then
    Begin
      Key:=#0;
      DoOK.Execute;
    end;
  end;

  procedure TfrmSearch.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    inherited;
    If FBusy then
    Action:=caNone else
    Action:=caFree;
  end;

end.
