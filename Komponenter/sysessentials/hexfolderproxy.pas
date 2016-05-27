  unit hexfolderproxy;

  Interface

  {$IFDEF LINUX}
  uses Forms, windows, sysutils, classes, FileCtrl, graphics,
  registry, hexbase, hexproxy;
  {$ENDIF}

  {$IFDEF WIN32}
  uses Forms, windows, sysutils, classes, FileCtrl, graphics,
  registry, hexbase, shellapi, ShlObj, MMSystem, hexproxy;
  {$ENDIF}

  {$IFDEF WIN32}
  Const
  ERR_HEX_FailedExtractIcon = 'Failed to extract icon for filetype: %s';
  {$ENDIF}

  Type

  {$IFDEF WIN32}
  EHexFailedExtractIcon = Class(EHexProxy);
  PHICON          = ^hIcon;
  {$ENDIF}

  THexFolderType  = (hftFolder,hftFile);

  IHexFolderProxy = Interface
    ['{524A1749-C3BC-4BE7-BCE5-F0D674260AE9}']
    Function  DoGetItemPath: String;
    Function  DoGetItemType: THexFolderType;
  End;

  THexProxyFolderItem = Class(THexCustomProxyItem)
  Protected
    Function  DoGetFileType:THexFolderType;
    Function  DoGetFileSize:Longint;
    Function  DoGetFileName:String;
    {$IFDEF WIN32}
    Procedure GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
    Function  GetPathForSystem:String;
    {$ENDIF}
  Public
    Property  FileName: String read DoGetFileName;
    Property  FileType: THexFolderType read DoGetFileType;
    Property  FileSize: Longint read DoGetFileSize;
    Function  ToString:String;override;
    {$IFDEF WIN32}
    Procedure DrawIcon(Canvas:TCanvas;Left,Top:Integer;Small:Boolean);
    {$ENDIF}
    Function  HasSubFolders: Boolean;
    Function  HasSubFiles: Boolean;
  End;

  THexFolderProxy = Class(THexCustomProxy,IHexFolderProxy)
  Private
    FItems:         TStringList;
    Ftypes:         TList;
    FData:          THexProxyFolderItem;
    FullPath:       String;
    Function        DoGetItemPath: String;
    Function        DoGetItemType: THexFolderType;
  Protected
    Function        DoGetCount:Integer;override;
    Function        DoGetItem:THexCustomProxyItem;override;
    Function        DoGetFolderItem:THexProxyFolderItem;
    Procedure       DoOpen(Value:String);override;
    Procedure       DoClose;override;
  Public
    Property        SelectedItem:THexProxyFolderItem read DoGetFolderItem;
    Function        ToString:String;Override;
    Function        HasSubFolders: Boolean;
    Function        HasSubFiles: Boolean;
    Constructor     Create(AOwner:TComponent);Override;
    Destructor      Destroy;Override;
  Published
    Property        OnOpen;
    Property        OnClose;
  End;

  implementation

  //##############################################################
  // THexProxyFolderItem
  //##############################################################

  Function THexProxyFolderItem.HasSubFolders: Boolean;
  var
    Attributes:	Integer;
    SearchRec:	TSearchRec;
    FPath:      String;
  Begin
    result:=False;

    { Make sure we can do this }
    If (FileType<>hftFolder) then
    exit;

    { Prepare folder setting }
		Attributes:=faDirectory;
    FPath:=IHexFolderProxy(THexFolderProxy(Owner)).DoGetItemPath;
    FPath:=FPath + '\*.*';

    { No files to traverse? Just exit }
    If not FindFirst(FPath,Attributes,SearchRec)=0 then
    exit;

    try
      if (searchrec.name<>'.') and (searchrec.name<>'..') then
      Begin
        If (searchrec.Attr and faDirectory)=faDirectory then
        Begin
          result:=True;
          exit;
        end;
      End;

      while FindNext(SearchRec)=0 do
      if (searchrec.name<>'.') and (searchrec.name<>'..') then
      Begin
        If (searchrec.Attr and faDirectory)=faDirectory then
        Begin
          result:=True;
          Break;
        end;
      end;
    finally
      FindClose(searchRec);
    end;
  end;

  Function THexProxyFolderItem.HasSubFiles: Boolean;
  var
    Attributes:	Integer;
    SearchRec:	TSearchRec;
    FPath:      String;
  Begin
    result:=False;

    { Make sure we can do this }
    If (FileType<>hftFolder) then
    exit;

    { Prepare folder setting }
		Attributes:=faDirectory;
    FPath:=IHexFolderProxy(THexFolderProxy(Owner)).DoGetItemPath;

    { No files to traverse? Just exit }
    If not FindFirst(FPath,Attributes,SearchRec)=0 then
    exit;

    try
      if (searchrec.name<>'.') and (searchrec.name<>'..') then
      Begin
        If (searchrec.Attr and faDirectory)<>faDirectory then
        Begin
          result:=True;
          exit;
        end;
      End;

      while FindNext(SearchRec)=0 do
      if (searchrec.name<>'.') and (searchrec.name<>'..') then
      Begin
        If (searchrec.Attr and faDirectory)<>faDirectory then
        Begin
          result:=True;
          Break;
        end;
      end;
    finally
      FindClose(searchRec);
    end;
  end;
  
  Function THexProxyFolderItem.ToString:String;
  Begin
    If DoGetFileType=hftFolder then
    Begin
      if HasSubFolders then
      result:='+' + '[' + DoGetFileName + ']' else
      result:='[' + DoGetFileName + ']';
    end else
    result:=DoGetFileName;
  end;

  Function THexProxyFolderItem.DoGetFileName:String;
  Begin
    result:=IHexFolderProxy(THexFolderProxy(Owner)).DoGetItemPath;
    result:=ExtractFileName(result);
  end;

  Function  THexProxyFolderItem.DoGetFileType:THexFolderType;
  Begin
    result:=IHexFolderProxy(THexFolderProxy(Owner)).DoGetItemType;
  end;

  Function THexProxyFolderItem.DoGetFileSize:Longint;
  var
    FFile:  TFileStream;
    FName:  String;
  Begin
    If DOGetFileType = hftFile then
    Begin
      FName:=IHexFolderProxy(THexFolderProxy(Owner)).DoGetItemPath;
      try
        FFile:=TFileStream.Create(FName,fmOpenRead);
        try
          result:=FFile.Size;
        finally
          FFile.free;
        end;
      except
        on exception do
        result:=0;
      end;
    end else
    result:=0;
  end;

  {$IFDEF WIN32}
  Function THexProxyFolderItem.GetPathForSystem:String;
  var
    FPath:  Array [0..Max_Path] of Char;
  Begin
    SetString
      (
      Result,
      FPath,
      GetSystemDirectory(FPath, MAX_PATH)
      );
  End;
  {$ENDIF}

  {$IFDEF WIN32}
  Procedure THexProxyFolderItem.DrawIcon(Canvas:TCanvas;Left,Top:Integer;Small:Boolean);
  var
    FIcon:  TIcon;
    FTemp:  HIcon;
    FPath:  String;
  Begin
    { Create Icon }
    try
      FIcon:=TIcon.Create;
    except
      on e: exception do
      Begin
        raise EHexFailedExtractIcon.CreateFmt(ERR_Hex_FailedExtractIcon,[e.message]);
        exit;
      end;
    end;

    { get path for our item }
    FPath:=IHexFolderProxy(THexFolderProxy(Owner)).DoGetItemPath;

    If Small then
    GetAssociatedIcon(FPath,NIL,@FTemp) else
    GetAssociatedIcon(FPath,@FTemp,NIL);
    FIcon.Handle:=FTemp;

    try
      Canvas.Draw(left,top,FIcon);
    finally
      FIcon.free;
    end;

    If FTemp=0 then
    FreeAndNIL(FIcon);
  end;
  {$ENDIF}

  {$IFDEF WIN32}
  Procedure THexProxyFolderItem.GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
  var
    IconIndex: Integer;  // Position of the icon in the file
    FileExt, FileType: string;
    Reg: TRegistry;
    p: integer;
    p1, p2: pchar;
  label
    noassoc;
  begin
    IconIndex := 0;

    // Get the extension of the file
    FileExt := UpperCase(ExtractFileExt(FileName));
    if ((FileExt <> '.EXE') and (FileExt <> '.ICO')) or not FileExists(FileName) then
    begin
    // If the file is an EXE or ICO and it exists, then
    // we will extract the icon from this file. Otherwise
    // here we will try to find the associated icon in the
    // Windows Registry...
    Reg := nil;
    try
      Reg := TRegistry.Create(KEY_QUERY_VALUE);
      Reg.RootKey := HKEY_CLASSES_ROOT;
      if FileExt = '.EXE' then FileExt := '.COM';
      if Reg.OpenKeyReadOnly(FileExt) then
        try
          FileType := Reg.ReadString('');
        finally
          Reg.CloseKey;
        end;
      if (FileType <> '') and Reg.OpenKeyReadOnly(
          FileType + '\DefaultIcon') then
        try
          FileName := Reg.ReadString('');
        finally
          Reg.CloseKey;
        end;
    finally
      Reg.Free;
    end;

    // If we couldn't find the association, we will
    // try to get the default icons
    if FileName = '' then goto noassoc;

    // Get the filename and icon index from the
    // association (of form '"filaname",index')
    p1 := PChar(FileName);
    p2 := StrRScan(p1, ',');
    if p2 <> nil then begin
      p := p2 - p1 + 1; // Position of the comma
      IconIndex := StrToInt(Copy(FileName, p + 1,
        Length(FileName) - p));
      SetLength(FileName, p - 1);
    end;
  end;
  // Attempt to get the icon
  if ExtractIconEx(pchar(FileName), IconIndex,
      PLargeIcon^, PSmallIcon^, 1) <> 1 then
  begin
  noassoc:
    // The operation failed or the file had no associated
    // icon. Try to get the default icons from SHELL32.DLL

    try // to get the location of SHELL32.DLL
      FileName := IncludeTrailingBackslash(GetPathForSystem)
        + 'SHELL32.DLL';
    except
      FileName := 'C:\WINDOWS\SYSTEM\SHELL32.DLL';
    end;
    // Determine the default icon for the file extension
    if      (FileExt = '.DOC') then IconIndex := 1
    else if (FileExt = '.EXE')
         or (FileExt = '.COM') then IconIndex := 2
    else if (FileExt = '')     then IconIndex :=3
    else if (FileExt = '.HLP') then IconIndex := 23
    else if (FileExt = '.INI')
         or (FileExt = '.INF') then IconIndex := 63
    else if (FileExt = '.TXT') then IconIndex := 64
    else if (FileExt = '.BAT') then IconIndex := 65
    else if (FileExt = '.DLL')
         or (FileExt = '.SYS')
         or (FileExt = '.VBX')
         or (FileExt = '.OCX')
         or (FileExt = '.VXD') then IconIndex := 66
    else if (FileExt = '.FON') then IconIndex := 67
    else if (FileExt = '.TTF') then IconIndex := 68
    else if (FileExt = '.FOT') then IconIndex := 69
    else IconIndex := 0;
    // Attempt to get the icon.
    if ExtractIconEx(pchar(FileName), IconIndex,
        PLargeIcon^, PSmallIcon^, 1) <> 1 then
    begin
      // Failed to get the icon. Just "return" zeroes.
      if PLargeIcon <> nil then PLargeIcon^ := 0;
      if PSmallIcon <> nil then PSmallIcon^ := 0;
    end;
  end;
  end;
  {$ENDIF}

  //##############################################################
  // THexFolderProxy
  //##############################################################

  Constructor THexFolderProxy.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FItems:=TStringList.Create;
    FTypes:=TList.Create;
    FData:=THexProxyFolderItem.Create(self);
  end;

  Destructor THexFolderProxy.Destroy;
  Begin
    FData.free;
    Ftypes.free;
    FItems.free;
    inherited;
  end;

  Function THexFolderProxy.HasSubFolders: Boolean;
  var
    x:  Integer;
  Begin
    result:=False;
    for x:=1 to FItems.Count do
    begin
      If THexFolderType(ord(integer(FTypes[x-1])))=hftFolder then
      begin
        result:=True;
        Break;
      end;
    end;
  end;

  Function THexFolderProxy.HasSubFiles: Boolean;
  var
    x:  Integer;
  Begin
    result:=False;
    for x:=1 to FItems.Count do
    begin
      If THexFolderType(ord(integer(FTypes[x-1])))=hftFile then
      begin
        result:=True;
        Break;
      end;
    end;
  end;

  Function THexFolderProxy.DoGetItemPath: String;
  Begin
    result:=IncludeTrailingBackSlash(FullPath) + FItems[ItemIndex];
  end;

  Function THexFolderProxy.DoGetItemType: THexFolderType;
  Begin
    result:=THexFolderType(ord(integer(FTypes[ItemIndex])));
  end;

  Function THexFolderProxy.DoGetCount:Integer;
  Begin
    if not Active then
    result:=Inherited DoGetCount else
    result:=FItems.Count
  end;

  Function THexFolderProxy.DoGetItem:THexCustomProxyItem;
  Begin
    { not active? }
    if not Active then
    Begin
      result:=NIL;
      exit;
    end else
    result:=FData;
  end;

  Function THexFolderProxy.DoGetFolderItem:THexProxyFolderItem;
  Begin
    result:=THexProxyFolderItem(inherited SelectedItem);
  end;

  Function THexFolderProxy.ToString:String;
  Begin
    result:=FullPath;
  end;

  Procedure THexFolderProxy.DoOpen(Value:String);
  var
    Attributes:	Integer;
    SearchRec:	TSearchRec;
    FFolder:    String;

    Procedure AddRecord;
    Begin
      If ((searchrec.Attr and faSysFile)=faSysFile)
      or ((searchrec.Attr and faHidden)=faHidden) then
      exit;

      FItems.Add(searchrec.name);
      if (searchrec.Attr and faDirectory)=faDirectory then
      FTypes.add(pointer(ord(hftFolder))) else
      Ftypes.add(pointer(ord(hftFile)));
    End;

  Begin
    { close proxy if active }
    If Active then
    Close;

    { Check that we can do this }
    if (length(Value)=0)
    or (Directoryexists(Value)=False) then
    Begin
      raise EHexFolderNotFound.CreateFmt(ERR_Hex_FolderNotFound,[Value]);
      exit;
    end;

    { Get root drive }
    FullPath:=ExtractFileDrive(Value);
    FullPath:=IncludeTrailingBackslash(FullPath);

    { Is this a root dir? }
    If (FullPath<>Value) then
    FullPath:=ExcludeTrailingBackslash(Value);

    { Prepare folder setting }
    Attributes:=faAnyFile;
    FFolder:=IncludeTrailingBackslash(FullPath) + '*.*';

    If FindFirst(FFolder,Attributes,SearchRec)=0 then
    Begin
      { traverse search record }
      try
        try
          if (searchrec.name<>'.') and (searchrec.name<>'..') then
          AddRecord;
          while FindNext(SearchRec)=0 do
          if (searchrec.name<>'.') and (searchrec.name<>'..') then
          AddRecord;
        except
          on e: exception do
          Begin
            FItems.Clear;
            FTypes.Clear;
            raise EHexProxyFailedOpen.CreateFmt(ERR_HEX_ProxyFailedOpen,[e.message]);
            exit;
          end;
        end;
      finally
        FindClose(searchRec);
      end;
    end;

    DoSetActive(True);
  end;

  Procedure THexFolderProxy.DoClose;
  Begin
    If Active then
    Begin
      FullPath:='';
      FItems.Clear;
      FTypes.Clear;
      DoSetActive(False);
    end;
  end;
  
  end.
