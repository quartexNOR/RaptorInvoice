  unit registerForm;

  interface

  uses
  data,
  globalvalues,
  Db, VolgaTbl,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, clientform, RzButton, RzRadChk, StdCtrls, Mask, RzEdit, RzPanel,
  RzCmboBx, RzRadGrp, RzSndMsg, ActnList, RzDBNav, ExtCtrls, RzDlgBtn,
  RzLabel, RzBckgnd, ImgList;

  type

  TfrmRegister = class(TfrmClient)
    nValg: TRzRadioGroup;
    nTabeller: TRzCheckGroup;
    lbKilde: TRzLabel;
    nKilde: TRzComboBox;
    RzGroupBox1: TRzGroupBox;
    nNavn: TRzEdit;
    nFakturaId: TRzCheckBox;
    lbNavn: TRzLabel;
    lbStatus: TRzLabel;
    procedure FormShow(Sender: TObject);
    procedure nValgChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure DoOKExecute(Sender: TObject);
  private
    { Private declarations }
    Function  GetNewFolderName:String;
  public
    { Public declarations }
  end;

  var
  frmRegister: TfrmRegister;

  implementation

  {$R *.dfm}

  procedure TfrmRegister.FormShow(Sender: TObject);
  begin
    inherited;
    nNavn.Text:=GetNewFolderName;
  end;


  Function TfrmRegister.GetNewFolderName:String;
  var
    FTemp:  String;
    x:      Integer;
    FYear, FMonth, FDays: Word;
  Begin
    (* decode the current date *)
    DecodeDate(Now,FYear,FMonth,FDays);

    (* find a free filename *)
    x:=1;
    While x<10000 do
    Begin
      FTemp:=GetPathForDatabases + '\Firma database ' + IntToStr(FYear) + '-' +IntToStr(x);
      If not DirectoryExists(FTemp) then
      Break;
      inc(x);
    end;

    (* return name part *)
    Result:=ExtractFilename(FTemp);
  end;


  procedure TfrmRegister.nValgChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
  begin
    inherited;
    AllowChange:=True;
    Case NewIndex of
    0:
      Begin
        nTabeller.Enabled:=False;
        lbKilde.Enabled:=False;
        nKilde.Enabled:=False;
        nFakturaId.Enabled:=False;
      end;
    1:
      Begin
        nTabeller.Enabled:=True;
        lbKilde.Enabled:=True;
        nKilde.Enabled:=True;
        nFakturaId.Enabled:=True;
      end;
    end;
  end;

  procedure TfrmRegister.DoOKExecute(Sender: TObject);
  var
    FText:    String;
    FNewPath: String;
    FOld,FNew:  String;
    FSources: Array[0..5] of String;
    FTables:  Array[0..5] of TVolgaTable;
    x:        Integer;
  begin
    inherited;

    (* validate name length *)
    FText:=trim(nNavn.Text);
    If length(FText)=0 then
    Begin
      ShowMessage('Navnet på det nye registeret må fylles ut!');
      lbNavn.Blinking:=True;
      nNavn.SetFocus;
      Modalresult:=mrNone;
      exit;
    end;

    FNewPath:=IncludeTrailingPathDelimiter(GetPathForDatabases);
    FNewPath:=FNewPath + FText;
    If DirectoryExists(FNewPath) then
    Begin
      ShowMessage('Det eksisterer allerede et register med dette navnet!');
      lbNavn.Blinking:=True;
      nNavn.SetFocus;
      Modalresult:=mrNone;
      exit;
    end;

    If Appdata.DataStoreActive then
    Begin
      If application.MessageBox
      ('For å fullføre denne oppgaven må det aktive registeret lukkes.'
      + #13 + 'Lukke register og fortsette?','Raptor Faktura',
      MB_YESNO or MB_ICONQUESTION)=idNo then
      Begin
        Modalresult:=mrNone;
        exit;
      end;

      (* close current active datastore *)
      Appdata.CloseDataStore;
    end;

    self.Cursor:=crHourGlass;
    self.Enabled:=False;
    lbStatus.Caption:='Bygger database tabeller..';

    try
      (* build list of tables *)
      FTables[0]:=AppData.Leverandorer;
      FTables[1]:=AppData.Produkter;
      FTables[2]:=AppData.Kunder;
      FTables[3]:=AppData.KundeGrupper;
      FTables[4]:=AppData.FakturaData;
      FTables[5]:=AppData.Faktura;

      If nValg.ItemIndex=1 then
      Begin
        for x:=low(FSources) to high(FSources) do
        Begin
          FSources[x]:=IncludeTrailingPathDelimiter(GetPathForDatabases)
          + IncludeTrailingPathDelimiter(nKilde.Text)
          + FTables[x].TableName;
        end;
      end;


      (* construct the new register path *)
      try
        mkDir(FNewPath);
      except
        on e: exception do
        Begin
          FText:='Det oppstod problemer med å skape register mappen:'#13;
          FText:=FText + e.message;
          ShowMessage(FText);
          exit;
        end;
      end;

      (* set new database path *)
      appdata.dbase.databasepath:=FNewPath;

      (* construct new tables *)
      try
        for x:=Low(FTables) to high(FTables) do
        Begin

          If (nValg.ItemIndex=1)
          and (x>=0) and (x<=3) then
          Begin
            If nTabeller.ItemChecked[x] then
            Begin
              (* copy old table *)
              FOld:=FSources[x];
              FNew:=IncludeTrailingPathDelimiter(FNewPath) + FTables[x].TableName;
              copyfile(PChar(FOld),PChar(FNew),false);
              Continue;
            end;
          end;

          (* create & open the table *)
          If FTables[x].Active then
          FTables[x].Close;
          FTables[x].CreateTable;

          If FTables[x]=Appdata.KundeGrupper then
          Begin
            FTables[x].Open;
            try
              (* add default customer group *)
              Appdata.KundeGrupper.append;
              Appdata.KundeGrupperTittel.AsString:='Ny kunde';
              Appdata.KundeGrupper.Post;
              Appdata.KundeGrupper.ApplyUpdates;
              Appdata.KundeGrupper.CommitUpdates;
            finally
              (* close table again *)
              FTables[x].Close;
            end;
          end;

          If FTables[x].Active then
          FTables[x].Close;

        end;

      except
        on e: exception do
        Begin
          FText:='Det oppstod problemer med å skape register database tabell:'#13;
          FText:=FText + e.message;
          ShowMessage(FText);
          exit;
        end;
      end;

      (* construct generic prefs file *)
      try
        Appdata.ResetPrefs;
        Appdata.Prefs.SaveToFile
        (IncludeTrailingPathDelimiter(FNewPath) + 'prefs.dat');
        Appdata.prefs.Clear;
      except
        on e: exception do
        Begin
          FText:='Det oppstod problemer med å skape fil for instillinger:'#13;
          FText:=FText + e.message;
          ShowMessage(FText);
          exit;
        end;
      end;

    finally
      Self.Cursor:=crDefault;
      Self.Enabled:=True;
    end;
  end;

end.
