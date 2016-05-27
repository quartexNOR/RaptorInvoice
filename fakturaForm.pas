  unit fakturaForm;

  interface

  uses Forms, Windows, sysutils, ImgList, Controls, StdCtrls,
  Classes, ActnList, Graphics, ExtCtrls, Mask, db, RzStatus, RzDBEdit, RzTabs,
  RzButton, RzGroupBar, RzEdit, RzPanel, RzLabel,  RzBckgnd, RzDBNav, ComCtrls,
  ToolWin, RzSndMsg, RzDBGrid, Grids, DBGrids, DBCtrls,
  clientform, data, globalvalues, RzDlgBtn, RzRadChk;

  Type

  TfrmFaktura = class(TfrmClient)
    DoRegisterKunde: TAction;
    DoAddProduct: TAction;
    DoRemoveProduct: TAction;
    DoSelectKunde: TAction;
    RzGroupBox1: TRzGroupBox;
    nDato: TRzDBDateTimeEdit;
    nFrist: TRzDBNumericEdit;
    Label7: TLabel;
    nMerk: TRzDBEdit;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet3: TRzTabSheet;
    Panel5: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    nBeskrivelse: TRzDBMemo;
    lbFakturaDato: TRzLabel;
    lbBetalingsfrist: TRzLabel;
    lbMerknader: TRzLabel;
    DoUpdateSum: TAction;
    Large: TImageList;
    RzGroupBox2: TRzGroupBox;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    RzGroupBox3: TRzGroupBox;
    RzLabel1: TRzLabel;
    nMinRef: TRzDBEdit;
    RzLabel2: TRzLabel;
    nDinRef: TRzDBEdit;
    RzGroupBox4: TRzGroupBox;
    RzBitBtn3: TRzBitBtn;
    RzBitBtn4: TRzBitBtn;
    Panel1: TPanel;
    RzGroupBox5: TRzGroupBox;
    eksmva: TRzStatusPane;
    inkmva: TRzStatusPane;
    Label1: TLabel;
    Label2: TLabel;
    RzDBGrid1: TRzDBGrid;
    Label3: TLabel;
    mva: TRzStatusPane;
    Label4: TLabel;
    lbRabatter: TRzStatusPane;
    MottakerPages: TRzPageControl;
    TabSheet2: TRzTabSheet;
    lbKunde: TRzLabel;
    nFirma: TRzDBEdit;
    nAdresse: TRzDBEdit;
    lbAdresse: TRzLabel;
    lbAdresse2: TRzLabel;
    nAdresse2: TRzDBEdit;
    nPostNr: TRzDBEdit;
    lbPostNr: TRzLabel;
    lbSted: TRzLabel;
    nSted: TRzDBEdit;
    Panel6: TPanel;
    Image3: TImage;
    RzSeparator2: TRzSeparator;
    TabLevering: TRzTabSheet;
    cbLevere: TRzCheckBox;
    lbLkunde: TRzLabel;
    edLKunde: TRzDBEdit;
    lbLAdresse1: TRzLabel;
    edLAdresse1: TRzDBEdit;
    edLAdresse2: TRzDBEdit;
    lbLAdresse2: TRzLabel;
    lbLPostNr: TRzLabel;
    edLPostNnr: TRzDBEdit;
    edLSted: TRzDBEdit;
    lbLSted: TRzLabel;
    Panel2: TPanel;
    Image4: TImage;
    procedure DoRegisterKundeExecute(Sender: TObject);
    procedure DoAddProductExecute(Sender: TObject);
    procedure DoRemoveProductExecute(Sender: TObject);
    procedure DoSelectKundeExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoOKExecute(Sender: TObject);
    procedure nPostNrExit(Sender: TObject);
    procedure DoCancelExecute(Sender: TObject);
    procedure DoUpdateSumExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edLPostNnrExit(Sender: TObject);
    procedure cbLevereClick(Sender: TObject);
  private
    { private declarations }
    Procedure FakturaAddrToLeveringAddr;
    Procedure HandleLeveringsadresseChanged(Sender:TObject;var Key:Char);
  public
    { Public declarations }
  end;

  implementation

  {$R *.DFM}

  uses kundeForm, kundeValgForm, produktValgform;

  procedure TfrmFaktura.FormCreate(Sender: TObject);
  begin
    inherited;
    HideNavigator;
    edLKunde.OnKeyPress:=HandleLeveringsadresseChanged;
    edLAdresse1.OnKeyPress:=HandleLeveringsadresseChanged;
    edLAdresse2.OnKeyPress:=HandleLeveringsadresseChanged;
    edLPostNnr.OnKeyPress:=HandleLeveringsadresseChanged;
    edLSted.OnKeyPress:=HandleLeveringsadresseChanged;
  end;

  procedure TfrmFaktura.FormShow(Sender: TObject);
  begin
    inherited;
    lbHelp1.Caption:=Format(lbHelp1.Caption,[DIALOG_FAKTURA_TOPIC]);

    If RecordMode=arAppend then
    begin
      lbTitle.Caption:=DIALOG_FAKTURA_TITLEAPPEND;
      If not Appdata.Faktura.Readonly then
      AppData.Faktura.Append;
      DoUpdateSum.Execute;
    end else
    Begin
      lbTitle.Caption:=DIALOG_FAKTURA_TITLEEDIT;
      If not Appdata.Faktura.Readonly then
      Begin
        AppData.Faktura.Edit;
        if (appdata.FakturaLev_kunde.AsString<>'')
        or (appdata.FakturaLev_addr1.AsString<>'')
        or (appdata.FakturaLev_addr2.AsString<>'')
        or (appdata.FakturaLev_postnr.AsString<>'')
        or (appdata.FakturaLev_sted.AsString<>'') then
        cbLevere.Checked:=false;
      end;
      DoUpdateSum.Execute;
    End;

    DoAddProduct.Enabled:=not AppData.Faktura.ReadOnly;
    DoRemoveProduct.Enabled:=not AppData.Faktura.ReadOnly;
    DoSelectKunde.Enabled:=not AppData.Faktura.ReadOnly;
    DoRegisterKunde.Enabled:=not AppData.Faktura.ReadOnly;
    nLocked.Visible:=AppData.Faktura.ReadOnly;
  end;

  procedure TfrmFaktura.DoRegisterKundeExecute(Sender: TObject);
  begin
    inherited;
    With TfrmKunde.Create(self) do
    Begin
      try
        Showmodal;
      finally
        Free;
      end;
    End;
  end;

  procedure TfrmFaktura.DoAddProductExecute(Sender: TObject);

    Function LokaliserGruppeRabatt:Integer;
    begin
      result:=0;
      If Appdata.Kunder.find('firma',[Appdata.FakturaKunde.Value],True) then
      Begin
        If Appdata.kunderGruppe.Value>0 then
        Begin
          If Appdata.KundeGrupper.find('id',
          [Appdata.kunderGruppe.Value],True)=True then
          Begin
            If Appdata.KundeGrupperAktiv.value=True then
            Begin
              If Appdata.KundeGrupperRabatt.Value>0 then
              result:=Appdata.KundeGrupperRabatt.Value;
            end;
          end;
        end;
      end;
    end;

  begin
    With TfrmVelgProdukt.Create(self) do
    begin
      try
        RabattProsent:=LokaliserGruppeRabatt;
        ShowModal;
      finally
        Free;
      end;
    End;
    DoUpdateSum.Execute;
  end;

  procedure TfrmFaktura.DoRemoveProductExecute(Sender: TObject);
  begin
    { check that we can do this }
    If (AppData.FakturaData.Active=False)
    or (AppData.FakturaData.RecordCount=0) then
    exit;

    try
      AppData.FakturaData.Delete;
      AppData.FakturaData.ApplyUpdates;
      AppData.FakturaData.CommitUpdates;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoRemoveProductExecute()',e.message);
    end;

    DoUpdateSum.Execute;
  end;

  Procedure TfrmFaktura.FakturaAddrToLeveringAddr;
  Begin
    appdata.FakturaLev_kunde.AsString:=AppData.FakturaKunde.AsString;
    appdata.FakturaLev_addr1.AsString:=AppData.FakturaAdresse.AsString;
    appdata.FakturaLev_addr2.asString:=AppData.FakturaAdresse2.AsString;
    appdata.FakturaLev_postnr.AsString:=AppData.FakturaPostNr.AsString;
    appdata.FakturaLev_sted.AsString:=AppData.FakturaSted.AsString;
  end;

  procedure TfrmFaktura.DoSelectKundeExecute(Sender: TObject);
  begin
    Inherited;
    With TfrmKundeValg.Create(self) do
    Begin
      try
        If ShowModal=mrOK then
        begin
          try
            AppData.FakturaKunde.AsString:=AppData.KunderFirma.AsString;
            AppData.FakturaAdresse.AsString:=AppData.KunderAdresse.AsString;
            AppData.FakturaAdresse2.AsString:=AppData.KunderAdresse2.AsString;
            AppData.FakturaPostNr.AsString:=AppData.KunderPostNr.AsString;
            AppData.FakturaSted.AsString:=AppData.KunderSted.AsString;

            (* Samme leveringsadresse? *)
            if cbLevere.Checked then
            FakturaAddrToLeveringAddr;

            DoUpdateSum.Execute;
          except
            on e: exception do
            ErrorDialog(ClassName,'DoSelectKundeExecute()',e.message);
          end;
        End;
      finally
        Free;
      end;
    End;
  end;

  procedure TfrmFaktura.DoOKExecute(Sender: TObject);
  var
    FText:  String;
    FText2: String;
  begin
    (* turn off blinking labels *)
    lbBetalingsfrist.Blinking:=False;
    lbPostNr.Blinking:=False;
    lbSted.Blinking:=False;
    lbAdresse.Blinking:=False;
    lbAdresse2.Blinking:=False;
    lbkunde.Blinking:=False;

    lbLkunde.Blinking:=False;
    lbLAdresse1.Blinking:=False;
    lbLAdresse2.Blinking:=False;
    lbLPostNr.Blinking:=False;
    lbLSted.Blinking:=False;

    If AppData.FakturaData.RecordCount=0 then
    begin
      FText:='Faktura inneholder ingen produkter eller tjenester.'#13#13;
      FText:=FText + 'Kan ikke registrere data uten tjenester.';
      Application.MessageBox(PChar(FText),'Ugyldig faktura innhold',
      MB_OK	or MB_ICONINFORMATION);
      exit;
    End;

    { Sjekk kunde felt }
    FText:=trim(AppData.FakturaKunde.AsString);
    If Length(FText)=0 then
    Begin
      CauseFieldError('kunde');
      lbkunde.Blinking:=True;
      nFirma.SetFocus;
      exit;
    End;

    { Check Adresse1 field }
    FText:=trim(AppData.FakturaAdresse.AsString);
    FText2:=trim(AppData.FakturaAdresse2.AsString);

    if (length(FText)<1)
    or (length(FText2)<1) then
    Begin
      (* Adresse 2 is OK, but not the first.
         Or, both are empty *)
      if ( (length(FText)<1) and (length(FText2)<1) )
      or ( (Length(FText)<1) and (length(FText2)>0) ) then
      Begin
        CauseAdresseError;
        lbAdresse.Blinking:=True;
        nAdresse.SetFocus;
        modalresult:=mrNone;
        exit;
      end else

      if (length(FText2)<1)
      and (length(FText)>0) then
      Begin
        CauseAdresseError;
        lbAdresse.Blinking:=True;
        lbAdresse2.Blinking:=True;
        nAdresse.SetFocus;
        modalresult:=mrNone;
        exit;
      end;
    end;

    { Sjekk stedsnavn felt }
    FText:=trim(AppData.FakturaSted.AsString);
    If Length(FText)=0 then
    Begin
      CauseFieldError('sted');
      lbSted.Blinking:=True;
      nSted.SetFocus;
      modalresult:=mrNone;
      exit;
    End;

    { Sjekk postnummer felt }
    FText:=trim(AppData.FakturaPostNr.AsString);
    If Length(FText)=0 then
    Begin
      CauseFieldError('postnummer');
      lbPostNr.Blinking:=True;
      nPostNr.SetFocus;
      modalresult:=mrNone;
      exit;
    End;

    { Sjekk betalingsfrist felt }
    FText:=trim(AppData.FakturaBetalingsFrist.AsString);
    If Length(FText)=0 then
    Begin
      CauseFieldError('betalingsfrist');
      lbBetalingsfrist.Blinking:=True;
      nFrist.SetFocus;
      modalresult:=mrNone;
      exit;
    End;

    //################### PAGE 2 ####################

    { Sjekk Mottaker:Kundenavn }
    FText:=trim(AppData.FakturaLev_kunde.AsString);
    If Length(FText)=0 then
    Begin
      CauseFieldError('Leveringsadresse/kundenavn');
      if MottakerPages.ActivePage<>TabLevering then
      MottakerPages.ActivePage:=TabLevering;
      lbLkunde.Blinking:=True;
      edLKunde.SetFocus;
      modalresult:=mrNone;
      exit;
    End;

    { Check Adresse1 field }
    FText:=trim(AppData.FakturaLev_addr1.AsString);
    FText2:=trim(AppData.FakturaLev_addr2.AsString);
    if (length(FText)<1)
    or (length(FText2)<1) then
    Begin
      (* Adresse 2 is OK, but not the first.
         Or, both are empty *)
      if ( (length(FText)<1) and (length(FText2)<1) )
      or ( (Length(FText)<1) and (length(FText2)>0) ) then
      Begin
        CauseFieldError('Leveringsadresse/Adresse 1');
        if MottakerPages.ActivePage<>TabLevering then
        MottakerPages.ActivePage:=TabLevering;
        lbLAdresse1.Blinking:=True;
        edLAdresse1.SetFocus;
        modalresult:=mrNone;
        exit;
      end else

      if (length(FText2)<1)
      and (length(FText)>0) then
      Begin
        CauseFieldError('Leveringsadresse/Adresse 2');
        if MottakerPages.ActivePage<>TabLevering then
        MottakerPages.ActivePage:=TabLevering;
        lbLAdresse2.Blinking:=True;
        edLAdresse2.SetFocus;
        modalresult:=mrNone;
        exit;
      end;
    end;



    try
      { oppdater informasjon mot faktura }
      FText:=inkmva.Caption;
      System.Delete(FText,1,4);
      FText:=trim(FText);

      try
        AppData.FakturaPris.AsCurrency:=StrToCurr(FText);
        AppData.Faktura.Post;
        AppData.Faktura.ApplyUpdates;
        AppData.Faktura.CommitUpdates;
      finally
        { oppdater linket fakturadata informasjon }
        AppData.FakturaData.ApplyUpdates;
        AppData.FakturaData.CommitUpdates;
      end;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoOKExecute()',e.message);
    end;

    inherited;
  end;

  procedure TfrmFaktura.nPostNrExit(Sender: TObject);
  begin
    If AppData.DatasetReady(Appdata.Faktura)=false then
    Begin
      If length(nSted.Text)=0 then
      If AppData.PostSteder.Find('PostNr',[nPostNr.Text],True) then
      AppData.FakturaSted.AsString:=AppData.PostStederSted.AsString;
    end;
  end;

  procedure TfrmFaktura.DoCancelExecute(Sender: TObject);
  begin
    (* check that we can do this *)
    If (Appdata.Faktura=NIL)
    or (Appdata.Faktura.Active=False)
    or (Appdata.Faktura.readOnly) then
    Begin
      inherited;
      exit;
    end;

    { Are we in append mode? }
    If RecordMode=arAppend then
    Begin
      { Delete all added products }
      try
        AppData.FakturaData.First;
        While not appdata.fakturadata.EOF do
        AppData.FakturaData.Delete;
        AppData.FakturaData.ApplyUpdates;
        AppData.FakturaData.CommitUpdates;
      except
        on e: exception do
        ErrorDialog(ClassName,'DoCancelExecute()',e.message);
      end;
    end;

    try
      AppData.Faktura.Cancel;
      Appdata.Faktura.ApplyUpdates;
      AppData.faktura.CommitUpdates;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoCancelExecute()',e.message);
    end;

    inherited;
  end;

  procedure TfrmFaktura.DoUpdateSumExecute(Sender: TObject);
  var
    DataIndex:Integer;
    TotalEks: Currency;
    TotalInk: Currency;
    TotalRabatt: Currency;
    APris:    Currency;
    ARabatt:  Currency;
    BPris:    Currency;
    CPris:    Currency;
  Begin
    { Get id of current faktura }
    DataIndex:=AppData.FakturaData.RecNo;
    TotalEks:=0;
    TotalInk:=0;
    TotalRabatt:=0;

    Appdata.FakturaData.DisableControls;
    try

      try
        AppData.FakturaData.First;
        While not AppData.FakturaData.Eof do
        Begin
          if not Appdata.FakturaData.ReadOnly then
          AppData.FakturaData.Edit;

          With AppData do
          Begin
            { Hent pris }
            APris:=Appdata.FakturaDataPris.Value;

            { kalkuler rabatt }
            ARabatt:=(APris / 100) * Appdata.FakturaDataRabatt.AsCurrency;

            TotalRabatt:=TotalRabatt + (ARabatt * FakturaDataAntall.Value);

            { Ny pris = gammel minus rabatt }
            BPris:=(APris - ARabatt);

            { Gang med antall }
            BPris:=BPris * AppData.FakturaDataAntall.Value;

            { Set eks mva }
            if not FakturaData.ReadOnly then
            FakturaDataEksMva.AsCurrency:=BPris;

            { Kalkuler mva }
            CPris:=(Bpris / 100) * Appdata.FakturaDataMVA.AsInteger;

            { set ink mva }
            if not FakturaData.ReadOnly then
            Appdata.FakturaDataInkMva.AsCurrency:=(BPris + CPris);

            TotalEks:=TotalEks + BPris;
            TotalInk:=TotalInk + (BPris + CPris);

            if not FakturaData.ReadOnly then
            Begin
              AppData.FakturaData.post;
              AppData.FakturaData.ApplyUpdates;
            end;
          End;
          AppData.FakturaData.Next;
        End;

        eksmva.Caption:='Kr. ' + CurrToStrF(TotalEks,ffFixed,2);
        mva.Caption:='Kr. ' + CurrToStrF(TotalInk-TotalEks,ffFixed,2);
        InkMva.Caption:='Kr. ' + CurrToStrF(TotalInk,ffFixed,2);
        lbRabatter.Caption:='Kr. ' + CurrToStrF(TotalRabatt,ffFixed,2);
      finally
        AppData.FakturaData.EnableControls;
        Appdata.FakturaData.RecNo:=DataIndex;
      end;
    except
      on e: exception do
      ErrorDialog(ClassName,'DoUpdateSumExecute()',e.message);
    end;
  end;

  procedure TfrmFaktura.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    inherited;
    (* user closed the window rather than pressing Cancel button? *)
    if (Appdata.Faktura.State=dsEdit)
    or (Appdata.Faktura.State=dsInsert) then
    DoCancel.Execute;
  end;

  procedure TfrmFaktura.edLPostNnrExit(Sender: TObject);
  begin
    inherited;
    If AppData.DatasetReady(Appdata.Faktura)=false then
    Begin
      If length(edLSted.Text)=0 then
      If AppData.PostSteder.Find('PostNr',[edLPostNnr.Text],True) then
      appdata.FakturaLev_sted.AsString:=AppData.PostStederSted.AsString;
    end;
  end;

  Procedure TfrmFaktura.HandleLeveringsadresseChanged
            (Sender:TObject;var Key:Char);
  Begin
    cbLevere.Checked:=False;
  end;

  procedure TfrmFaktura.cbLevereClick(Sender: TObject);
  begin
    inherited;
    if cbLevere.Checked then
    FakturaAddrToLeveringAddr;
  end;

end.

