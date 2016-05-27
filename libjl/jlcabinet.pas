  unit jlcabinet;

  interface

  {$DEFINE CAB_COMRESS}

  uses sysutils, classes, contnrs,
  {$IFDEF CAB_COMRESS} zlib, {$ENDIF}
  jlcommon, jldatabuffer, jlstreams, IniFiles;

  type

  TJLCabFile    = Class;
  TJLCabFolder  = Class;
  TJLCabinet    = Class;


  TJLCabAccess  = (caNone=0,caCreate,caReadWrite,caRead);
  TJLCabContent = (ccUnknown=0,ccPublic,ccCorporate,ccPrivate,ccAdult);

  TJLCabHeader  = packed record
    chSize:       Integer;
    chFileTable:  Integer;
    chUnique:     Integer;
    chContent:    TJLCabContent;
    chCreated:    TDateTime;
    chAuthor:     String[64];
    chCopyright:  String[64];
  End;

  PJLCabEntryData = ^TJLCabEntryData;
  TJLCabEntryData = Packed Record
    edId:     Integer;
    edSize:   Int64;
    edOffset: Int64;
  End;

  TJLCabItem = Class(TJLCommonObject)
  Private
    FName:      AnsiString;
    FCreated:   TDateTime;
    FParent:    TJLCabItem;
    FCabinet:   TJLCabinet;
    FFullPath:  AnsiString;
    Procedure   SetParent(Value:TJLCabItem);
  Protected
    Procedure   SetCabinet(Value:TJLCabinet);
    Procedure   SetFileName(Value:String);
    Procedure   SetCreated(Value:TDateTime);
    Procedure   InternalReset;virtual;
  Protected
    Procedure   InternalUpdate;virtual;
    Function    ObjectHasData:Boolean;override;
    Procedure   ReadObject(Const Reader:TJLReader);override;
    Procedure   WriteObject(Const Writer:TJLWriter);override;
  Public
    Property    FullPath:String read FFullPath;
    Property    Cabinet:TJLCabinet read FCabinet;
    Property    Created:TDateTime read FCreated;
    Property    Filename:AnsiString read FName;
    //Function    FullPath:AnsiString;virtual;
    Procedure   AfterConstruction;Override;
  Published
    Property    Parent:TJLCabItem read FParent write SetParent;
  End;

  TJLCabFile = Class(TJLCabItem)
  Private
    FSize:      Int64;
    FOffset:    Int64;
    Function    GetParent:TJLCabFolder;
  Protected
    Procedure   SetSize(Value:Int64);
    Procedure   SetOffset(Value:Int64);
    Procedure   InternalReset;override;
    Procedure   ReadObject(Const Reader:TJLReader);override;
    Procedure   WriteObject(Const Writer:TJLWriter);override;
  Public
    Property    Parent:TJLCabFolder read GetParent;
    Property    Size:Int64 read FSize;
    Property    DataOffset:Int64 read FOffset;
  End;

  TJLCabFolder = Class(TJLCabItem)
  Private
    FObjects:   TObjectList;
    Function    GetItem(Index:Integer):TJLCabItem;
    Function    GetCount:Integer;
  Protected
    Procedure   InternalUpdate;override;
    Procedure   InternalReset;override;
    Procedure   ReadObject(Const Reader:TJLReader);override;
    Procedure   WriteObject(Const Writer:TJLWriter);override;
  Public
    Property    Items[index:Integer]:TJLCabItem
                read GetItem;default;
    Property    Count:Integer read GetCount;

    Function    FileExists(AName:String):Boolean;
    Function    FolderExists(AName:String):Boolean;

    Function    GetFolderObject(AName:String;
                out Value:TJLCabFolder):Boolean;
    Function    GetFileObject(AName:String;
                out Value:TJLCabFile):Boolean;

    Function    ReadFile(AName:String;out Value:TStream):Boolean;

    Function    AddFile(AName:String;out AFile:TJLCabFile;
                Const AData:TStream=NIL):Boolean;

    Function    AddFolder(AName:String;out AFolder:TJLCabFolder):Boolean;

    Constructor Create;virtual;
    Destructor  Destroy;Override;
  End;

  TJLCabinet = Class(TJLCabFolder)
  Private
    FAccess:    TJLCabAccess;
    FFileName:  String;
    FActive:    Boolean;
    FStream:    TStream;
    FLastError: String;

    FUsedList:  TList;
    FFreeList:  TList;
    FNameLut:   THashedStringList;
    FHeader:    TJLCabHeader;
    {$HINTS OFF}
    Property    Cabinet;
    {$HINTS ON}
  Private
    Function    GetAuthor:String;
    Function    GetCopyright:String;
    Procedure   SetContent(Value:TJLCabContent);
    Procedure   SetAuthor(Value:String);
    Procedure   SetCopyright(Value:String);
  Private
    Procedure   ClearLutTable;
    Function    MakeFileList(out Stream:TStream):Boolean;
    Function    ReadFileList(Const Stream:TStream):Boolean;
    Function    Writeheader:Boolean;
    Function    ReadHeader:Boolean;
    Function    AllocFileEntry(Const ASize:Int64;
                out AEntry:PJLCabEntryData;
                out EntryIndex:Integer):Boolean;
  Protected
    Procedure   WriteCabInfo(Const Writer:TJLWriter);Virtual;
    Procedure   ReadCabInfo(Const Reader:TJLReader);virtual;
    Function    AddItemStream(Const AFile:TJLCabFile;
                Const ItemData:TStream):Boolean;
    Function    DelItemStream(AFile:TJLCabFile):Boolean;
    Function    GetItemStream(AName:String;out Value:TStream):Boolean;
  Protected
    Procedure   InternalReset;override;
    Procedure   SetLastError(Value:String);
    Procedure   SetLastErrorFmt(Value:String;Const Info:Array of Const);
    Procedure   ResetLastError;
  Public
    Property    LastError:String read FLastError;
    Property    AccessMode:TJLCabAccess read FAccess;
    Property    Filename:String read FFileName;
    Property    CabStream:TStream read FStream;
    Property    Active:Boolean read FActive;

    Property    ContentType:TJLCabContent
                read Fheader.chContent write SetContent;
    Property    AuthorName:String
                read GetAuthor write SetAuthor;
    Property    Copyright:String
                read GetCopyright write SetCopyright;

    Function    Open(Filename:String;AMode:TJLCabAccess):Boolean;overload;
    Function    Open(Stream:TStream;AMode:TJLCabAccess):Boolean;overload;
    Procedure   Close;
    Procedure   BeforeDestruction;Override;
    Constructor Create;override;
    Destructor  Destroy;Override;
  End;

  implementation

  //###########################################################################
  // TJLCabinet
  //###########################################################################

  Constructor TJLCabinet.Create;
  Begin
    inherited;
    FUsedList:=TList.Create;
    FUsedList.Capacity:=100;

    FFreeList:=TList.Create;
    FFreeList.Capacity:=100;

    FNameLut:=THashedStringList.Create;
    FNameLut.CaseSensitive:=False;
    FNameLut.Capacity:=100;
    
    SetCabinet(self);
  end;

  Destructor TJLCabinet.Destroy;
  Begin
    FNameLut.free;
    FUsedList.free;
    FFreeList.free;
    inherited;
  end;

  Procedure TJLCabinet.BeforeDestruction;
  Begin
    If FActive then
    Close;
    inherited;
  end;

  Function TJLCabinet.GetAuthor:String;
  Begin
    result:=FHeader.chAuthor;
  end;

  Function TJLCabinet.GetCopyright:String;
  Begin
    result:=FHeader.chCopyright;
  end;
  
  Procedure TJLCabinet.SetContent(Value:TJLCabContent);
  Begin
    FHeader.chContent:=Value;
  end;

  Procedure TJLCabinet.SetAuthor(Value:String);
  Begin
    FHeader.chAuthor:=Value;
  end;

  Procedure TJLCabinet.SetCopyright(Value:String);
  Begin
    FHeader.chCopyright:=Value;
  end;
  
  Procedure TJLCabinet.InternalReset;
  Begin
    inherited;
    Fillchar(Fheader,SizeOf(Fheader),#0);
    Fheader.chSize:=SizeOf(FHeader);
    Fheader.chFileTable:=0;
    Fheader.chContent:=ccUnknown;
    FHeader.chCreated:=Now;
    FHeader.chAuthor:='None';
    Fheader.chCopyright:='None';
    SetLength(FLastError,0);
  end;

  Function TJLCabinet.AllocFileEntry(Const ASize:Int64;
           out AEntry:PJLCabEntryData;
           out EntryIndex:Integer):Boolean;
  var
    x:      Integer;
    FItem:  PJLCabEntryData;

    Function AllocEntryRec(Const RecSize,RecOffset:Int64):PJLCabEntryData;
    Begin
      inc(FHeader.chUnique);
      result:=AllocMem(SizeOf(TJLCabEntryData));
      Fillchar(Result^,SizeOf(TJLCabEntryData),#0);
      result^.edId:=FHeader.chUnique;
      result^.edSize:=RecSize;
      result^.edOffset:=RecOffset;
    end;

  Begin
    AEntry:=NIL;
    Result:=ASize>0;
    If Result then
    Begin
      (* Do we have a free entry? *)
      If FFreeList.Count>0 then
      Begin
        for x:=1 to FFreeList.Count do
        Begin
          FItem:=FFreeList[x-1];
          If (FItem^.edSize>=ASize) then
          Begin
            (* Complete match? Or slightly larger? *)
            If FItem^.edSize=ASize then
            AEntry:=FItem else
            Begin
              (* Allocate a new one *)
              AEntry:=AllocEntryRec(ASize,FItem^.edOffset);
              EntryIndex:=FUsedList.Add(AEntry);

              (* reduce old one *)
              FItem.edOffset:=FItem.edOffset + ASize;
              FItem.edSize:=FItem.edSize - ASize;
            end;
            Break;
          end;
        end;
      end;

      (* No free entry, then create new @ end of stream *)
      If AEntry=NIl then
      Begin
        AEntry:=AllocEntryRec(ASize,FStream.Size);
        EntryIndex:=FUsedList.Add(AEntry);
      end;

      result:=AEntry<>NIL;
    end else
    Cabinet.SetLastErrorFmt('Failed to allocate filechunk [%d bytes]',[ASize]);
  end;

  Function TJLCabinet.AddItemStream(Const AFile:TJLCabFile;
           Const ItemData:TStream):Boolean;
  var
    FIndex:   Integer;
    FItem:    PJLCabEntryData;
  Begin
    result:=(FAccess in [caCreate,caReadWrite]);
    If result then
    Begin
      result:=ItemData<>NIL;
      If result then
      Begin
        result:=ItemData.Size>0;
        If result then
        Begin

          result:=AllocFileEntry(ItemData.Size,FItem,FIndex);
          If result then
          Begin
            AFile.SetSize(ItemData.Size);
            AFile.SetOffset(FItem^.edOffset);
            FNameLut.Values[AFile.FullPath]:=IntToStr(FIndex);
            ItemData.Position:=0;
            FStream.Position:=FItem^.edOffset;
            FStream.CopyFrom(ItemData,ItemData.Size);
          end;

        end else
        SetLasterror('Invalid file stream error [No content]');
      end else
      SetLasterror('Invalid file stream error [NIL]');
    end else
    SetLastError('Can not add file to a read only cabinet');
  end;

  Function TJLCabinet.GetItemStream(AName:String;out Value:TStream):Boolean;
  var
    FIndex: Integer;
    FItem:  PJLCabEntryData;
  Begin
    FIndex:=FNameLut.IndexOfName(ANAme);
    Result:=FIndex>=0;
    If result then
    Begin
      FIndex:=StrToInt(FNameLut.ValueFromIndex[FIndex]);
      FItem:=FUsedList[FIndex];
      FStream.Position:=FItem^.edOffset;
      Value:=TMemoryStream.Create;
      Value.CopyFrom(FStream,FItem^.edSize);
      Value.Position:=0;
    end;
  end;

  Function TJLCabinet.DelItemStream(AFile:TJLCabFile):Boolean;
  Begin
  end;
  
  Procedure TJLCabinet.SetLastError(Value:String);
  Begin
    FLastError:=Value;
  end;

  Procedure TJLCabinet.SetLastErrorFmt(Value:String;Const Info:Array of Const);
  Begin
    FLastError:=Format(Value,Info);
  end;

  Procedure TJLCabinet.ResetLastError;
  Begin
    SetLength(FLastError,0);
  end;

  Function TJLCabinet.Open(Filename:String;AMode:TJLCabAccess):Boolean;
  Const
    Stream_modes: Array[caCreate..caRead] of word
                  = (fmCreate,fmOpenReadWrite,fmOpenRead);
  var
    FDict:  TMemoryStream;
  Begin
    SetLength(FLastError,0);
    If FActive then
    Close;
    Result:=AMode>caNone;
    If result then
    Begin

      (* Check if file exists *)
      If AMode>caCreate then
      Begin
        If sysutils.FileExists(Filename)=False then
        Begin
          result:=False;
          SetLastErrorFmt('File "%s" not found error',[Filename]);
          exit;
        end;
      end;

      (* Open file Stream *)
      try
        FStream:=TFileStream.Create(Filename,Stream_modes[AMode]);
        //FStream:=TJLMemoryMappedFileStream.Create(Filename,'',Stream_modes[AMode]);
      except
        on e: exception do
        Begin
          result:=False;
          SetLastErrorFmt('Failed to open cabinet file: %s',[e.message]);
          exit;
        end;
      end;

      If AMode=caCreate then
      Begin
        (* Reset stream *)
        FHeader.chSize:=SizeOf(Fheader);
        FHeader.chFileTable:=0;
        FHeader.chCreated:=Now;
        FHeader.chAuthor:='';
        FHeader.chCopyright:='None';
        Result:=WriteHeader;
        If not result then
        Begin
          FreeAndNil(FStream);
          exit;
        end;
      end else
      Begin
        Result:=ReadHeader;
        If not Result then
        Begin
          FreeAndNil(FStream);
          exit;
        end;

        (* read dictionary here *)
        FDict:=TMemoryStream.Create;
        try

          try
            FStream.Seek(-FHeader.chFileTable,soFromEnd);
            FDict.CopyFrom(FStream,FHeader.chFileTable);
          except
            On e: exception do
            Begin
              result:=False;
              FreeAndNil(FStream);
              SetLastErrorFmt('Failed to read filelist: %s',[e.message]);
            end;
          end;

          If not ReadFileList(FDict) then
          Begin
            result:=False;
            FreeAndNil(FStream);
            SetLastErrorFmt('Failed to read filelist: %s',[LastError]);
            exit;
          end;

          (* truncate filelist from cabinet *)
          If (AMode =caReadWrite) then
          Begin
            FStream.Size:=FStream.Size - FHeader.chFileTable;
            FHeader.chFileTable:=0;
          end;

        finally
          FDict.free;
        end;
      end;

      FAccess:=AMode;
      FFileName:=Filename;
      FActive:=True;

    end else
    SetLastError('Invalid cabinet access mode');
  end;

  Function TJLCabinet.Open(Stream:TStream;AMode:TJLCabAccess):Boolean;
  Begin
    ResetLastError;
    result:=Stream<>NIL;
    If result then
    Begin
      result:=AMode>caNone;
      If result then
      Begin

      FStream:=Stream;
      If AMode=caCreate then
      Begin
        (* Reset stream *)
        FStream.Size:=0;
        FHeader.chSize:=SizeOf(Fheader);
        FHeader.chFileTable:=0;
        Result:=WriteHeader;
        If not result then
        Begin
          FreeAndNil(FStream);
          exit;
        end;
      end else
      Begin
        Result:=ReadHeader;
        If not Result then
        Begin
          FreeAndNil(FStream);
          exit;
        end;

        (* read dictionary here *)
      end;

      end else
      SetLastError('Invalid cabinet access mode');
    end else
    SetLastError('Invalid cabinet stream [NIL]');
  end;

  Function TJLCabinet.ReadFileList(Const Stream:TStream):Boolean;
  var
    FReader:  TJLStreamReader;
    {$IFDEF CAB_COMRESS}
    FComp:    TDecompressionStream;
    {$ENDIF}
  Begin
    SetLength(FLastError,0);
    result:=True;
    try
      Stream.Position:=0;

      {$IFDEF CAB_COMRESS}
      FComp:=TDecompressionStream.Create(Stream);
      try
      {$ENDIF}
        FReader:=TJLStreamReader.Create
        ({$IFDEF CAB_COMRESS}FComp{$ELSE}Stream{$ENDIF});
        try
          (* Read cabinet info *)
          ReadCabInfo(FReader);

          (* read object data *)
          ReadObject(FReader);
        finally
          FReader.free;
        end;
      {$IFDEF CAB_COMRESS}
      finally
        FComp.free;
      end;
      {$ENDIF}
    except
      on e: exception do
      Begin
        Result:=False;
        SetLastError(e.message);
      end;
    end;
  end;

  Procedure TJLCabinet.WriteCabInfo(Const Writer:TJLWriter);
  var
    x:        Integer;
    FDump:    TMemoryStream;
  Begin
    (* Write name LUT *)
    FDump:=TMemoryStream.Create;
    try
      FNameLut.SaveToStream(FDump);
      FDump.Position:=0;
      Writer.WriteInt(FDump.Size);
      If FDump.Size>0 then
      Writer.CopyFrom(FDump,FDump.Size);
    finally
      FDump.free;
    end;

    (* write file LUT *)
    Writer.WriteInt(FUsedList.Count);
    for x:=1 to FUsedList.Count do
    Writer.Write(PJLCabEntryData(FUsedList[x-1])^,
    SizeOf(TJLCabEntryData));

    (* write free LUT *)
    Writer.WriteInt(FFreeList.Count);
    for x:=1 to FFreeList.Count do
    Writer.Write(PJLCabEntryData(FFreeList[x-1])^,
    SizeOf(TJLCabEntryData));
  end;

  Procedure TJLCabinet.ReadCabInfo(Const Reader:TJLReader);
  var
    FCount:   Integer;
    FItem:    PJLCabEntryData;
    FDump:    TMemoryStream;
  Begin
    (* Read name LUT *)
    FCount:=Reader.ReadInt;
    If FCount>0 then
    Begin
      FDump:=TMemoryStream.Create;
      try
        Reader.CopyTo(FDump,FCount);
        FDump.Position:=0;
        FNameLut.LoadFromStream(FDump);
      finally
        FDump.free;
      end;
    end;

    (* Read file LUT count*)
    FCount:=Reader.ReadInt;
    If FCount>0 then
    While FCount>0 do
    Begin
      FItem:=AllocMem(SizeOf(TJLCabEntryData));
      Reader.read(FItem^,SizeOf(TJLCabEntryData));
      FUsedList.add(FItem);
      dec(FCount);
    end;

    (* Read freelist LUT count*)
    FCount:=Reader.ReadInt;
    If FCount>0 then
    While FCount>0 do
    Begin
      FItem:=AllocMem(SizeOf(TJLCabEntryData));
      Reader.read(FItem^,SizeOf(TJLCabEntryData));
      FFreeList.add(FItem);
      dec(FCount);
    end;
  end;

  Function TJLCabinet.MakeFileList(out Stream:TStream):Boolean;
  var
    FWriter:  TJLStreamWriter;
    {$IFDEF CAB_COMRESS}
    FComp:    TCompressionStream;
    {$ENDIF}
  Begin
    SetLength(FLastError,0);
    result:=True;
    Stream:=TMemoryStream.Create;
    try
      {$IFDEF CAB_COMRESS}
      FComp:=TCompressionStream.Create(clDefault,Stream);
      {$ENDIF}
      try
        FWriter:=TJLStreamWriter.Create
        ({$IFDEF CAB_COMRESS}FComp{$ELSE}Stream{$ENDIF});
        try
          (* write cabinet info *)
          WriteCabInfo(FWriter);

          (* write object content *)
          WriteObject(FWriter);
        finally
          FWriter.free;
        end;
      finally
        {$IFDEF CAB_COMRESS}
        FComp.free;
        {$ENDIF}
        Stream.Position:=0;
      end;
    except
      on e: exception do
      Begin
        Result:=False;
        SetLastError(e.message);
      end;
    end;
  end;
  
  Function TJLCabinet.Writeheader:Boolean;
  Begin
    SetLength(FLastError,0);
    try
      If FStream.Position>0 then
      FStream.Position:=0;
      FStream.WriteBuffer(FHeader,SizeOf(FHeader));
      result:=True;
    except
      on e: exception do
      Begin
        result:=False;
        SetLastErrorFmt('Failed to write header:',[e.message]);
      end;
    end;
  end;

  Function TJLCabinet.ReadHeader:Boolean;
  var
    FTemp: TJLCabHeader;
  Begin
    SetLength(FLastError,0);
    result:=FStream.Size>0;
    If result then
    Begin
      If FStream.Position>0 then
      FStream.Position:=0;

      FStream.ReadBuffer(FTemp,Sizeof(FTemp));
      result:=FTemp.chSize=SizeOf(FTemp);
      If result then
      FHeader:=FTemp else
      SetLastErrorFmt('Unknown file header [%s], expected signature [%s]',
      [IntToHex(Fheader.chSize,8),IntToHex(SizeOf(FHeader),8)]);
    end else
    SetLastError('Failed to read header, stream is empty');
  end;

  Procedure TJLCabinet.ClearLutTable;
  var
    x:      Integer;
  Begin
    try
      for x:=1 to FUsedList.Count do
      FreeMem(PJLCabEntryData(FUsedList[x-1]));

      for x:=1 to FFreeList.Count do
      FreeMem(PJLCabEntryData(FFreeList[x-1]));

      FNameLut.Clear;
    finally
      FFreeList.Clear;
      FUsedList.Clear;
    end;
  end;
  
  Procedure TJLCabinet.Close;
  var
    FData:  TStream;
  Begin
    SetLength(FLastError,0);
    If FActive then
    Begin
      try

        try

          (* Compile file-list *)
          If MakeFileList(FData) then
          Begin
            try
              (* update cabinet header *)
              FHeader.chFileTable:=FData.Size;
              If WriteHeader then
              Begin
                (* write file-list *)
                FStream.Seek(0,soFromEnd);
                FStream.CopyFrom(FData,FData.Size);
              end else
              SetLastErrorFmt('Failed to update cabinet header: %s',[LastError]);
            finally
              FreeAndNil(FData);
            end;
          end else
          SetLastErrorFmt('Failed to build filelist: %s',[LastError]);

        except
          on e: exception do
          SetLastErrorFmt('Failed to close cabinet:',[e.message]);
        end;

      finally
        ClearLutTable;
        FreeAndNil(FStream);
        FFilename:='';
        FAccess:=caNone;
        FActive:=False;
        InternalReset;
      end;
    end else
    SetLastError('No cabinet open, close failed');
  end;

  //###########################################################################
  // TJLCabFolder
  //###########################################################################

  Constructor TJLCabFolder.Create;
  Begin
    inherited;
    FObjects:=TObjectList.Create(True);
  end;

  Destructor TJLCabFolder.Destroy;
  Begin
    FObjects.free;
    inherited;
  end;

  Procedure TJLCabFolder.InternalUpdate;
  var
    x:  Integer;
  Begin
    Inherited;
    for x:=1 to FObjects.Count do
    TJLCabItem(FObjects[x-1]).InternalUpdate;
  end;
  
  Procedure TJLCabFolder.InternalReset;
  Begin
    FObjects.Clear;
    Inherited;
  end;
  
  Function TJLCabFolder.GetItem(Index:Integer):TJLCabItem;
  Begin
    result:=TJLCabItem(FObjects[index]);
  end;

  Function TJLCabFolder.FileExists(AName:String):Boolean;
  var
    FTemp:  String;
  Begin
    AName:=trim(AName);
    result:=Length(AName)>0;
    If result then
    Begin
      FTemp:=IncludeTrailingPathDelimiter(FullPath) + AName;
      result:=Cabinet.FNameLut.IndexOfName(FTemp)>=0;
    end;
  end;

  Function TJLCabFolder.FolderExists(AName:String):Boolean;
  var
    FItem:  TJLCabFolder;
  Begin
    result:=GetFolderObject(AName,FItem);
  end;

  Function TJLCabFolder.GetFileObject(AName:String;
           out Value:TJLCabFile):Boolean;
  var
    x:      integer;
    FItem:  TJLCabItem;
  Begin
    result:=False;
    Value:=NIL;
    AName:=lowercase(trim(AName));
    If length(AName)>0 then
    Begin
      for x:=1 to FObjects.Count do
      Begin
        FItem:=TJLCabItem(FObjects[x-1]);
        result:=(lowercase(FItem.Filename)=Aname)
        and (FItem is TJLCabFile);
        If result then
        Begin
          Value:=TJLCabFile(FItem);
          Break;
        end;
      end;
    end;
  end;
  
  Function TJLCabFolder.GetFolderObject(AName:String;
           out Value:TJLCabFolder):Boolean;
  var
    x:      integer;
    FItem:  TJLCabItem;
  Begin
    result:=False;
    Value:=NIL;
    AName:=lowercase(trim(AName));
    If length(AName)>0 then
    Begin
      for x:=1 to FObjects.Count do
      Begin
        FItem:=TJLCabItem(FObjects[x-1]);
        result:=(FItem is TJLCabFolder)
        and (lowercase(FItem.Filename)=Aname);
        If result then
        Begin
          Value:=TJLCabFolder(FItem);
          Break;
        end;
      end;
    end;
  end;

  Function TJLCabFolder.AddFolder(AName:String;
           out AFolder:TJLCabFolder):Boolean;
  Begin
    result:=FolderExists(AName)=False;
    If result then
    Begin

      try
        AFolder:=TJLCabFolder.Create;
      except
        on e: exception do
        Begin
          AFolder:=NIL;
          result:=False;
          exit;
        end;
      end;

      AFolder.SetParent(self);
      AFolder.SetCabinet(Cabinet);
      AFolder.SetFileName(AName);
      AFolder.InternalUpdate;
      FObjects.Add(AFolder);
    end else
    Cabinet.SetLastErrorFmt('Folder [%s] already exists, ADD aborted',[AName]);
  end;

  Function TJLCabFolder.AddFile(AName:String;out AFile:TJLCabFile;
           Const AData:TStream=NIL):Boolean;
  Begin
    AFile:=NIL;
    Result:=False;
    if not FileExists(AName) then
    Begin

      try
        AFile:=TJLCabFile.Create;
      except
        on e: exception do
        Begin
          Cabinet.SetLastErrorFmt('Failed to add file: %s',[e.message]);
          exit;
        end;
      end;

      AFile.SetParent(self);
      AFile.SetCabinet(Cabinet);
      AFile.SetFileName(AName);
      AFile.InternalUpdate;

      if Cabinet.AddItemStream(AFile,AData) then
      Begin
        FObjects.Add(AFile);
        result:=True;
      end else
      FreeAndNil(AFile);
    end else
    Cabinet.SetLastErrorFmt('File already exists [%s], ADD aborted',[AName]);
  end;

  Function TJLCabFolder.ReadFile(AName:String;out Value:TStream):Boolean;
  var
    //x:      integer;
    //FItem:  TJLCabItem;
    FName:  String;
  Begin
    Value:=NIL;
    //result:=False;

    FName:=IncludeTrailingPathDelimiter(FullPath) + Aname;
    result:=Cabinet.GetItemStream(FName,Value);
    {
    AName:=lowercase(trim(AName));
    If length(AName)>0 then
    Begin
      for x:=1 to FObjects.Count do
      Begin
        FItem:=Items[x-1];
        result:=(lowercase(FItem.Filename)=Aname)
        and (FItem is TJLCabFile);
        If result then
        Begin
          result:=Cabinet.GetItemStream(FItem.FullPath,Value);
          Break;
        end;
      end;
    end;
    }
    if not result then
    Cabinet.SetLastErrorFmt('File not found [%s]',[AName]);
  end;

  Function TJLCabFolder.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  end;

  Procedure TJLCabFolder.ReadObject(Const Reader:TJLReader);
  var
    x:      Integer;
    FKind:  Word;
    FItem:  TJLCabItem;
  Begin
    inherited;
    x:=Reader.ReadInt;
    If x>0 then
    Begin
      While x>0 do
      Begin
        FKind:=Reader.ReadWord;
        If FKind=0 then
        FItem:=TJLCabFolder.Create else
        if FKind=1 then
        FItem:=TJLCabFile.Create else
        Raise Exception.CreateFmt('Unknown child object [%s]',[FKind]);

        FItem.SetParent(self);
        If not (self is TJLCabinet) then
        FItem.SetCabinet(Cabinet) else
        FItem.SetCabinet(TJLCabinet(self));
        FItem.ReadObject(Reader);
        FItem.InternalUpdate;
        
        FObjects.Add(FItem);

        { If (FItem is TJLCabFile) then
        FItem.Cabinet.RegisterFile(TJLCabFile(FItem));   }

        dec(x);
      end;
    end;
  end;

  Procedure TJLCabFolder.WriteObject(Const Writer:TJLWriter);
  var
    x:      Integer;
    FItem:  TJLCabItem;
  Begin
    inherited;
    Writer.WriteInt(FObjects.Count);
    If FObjects.Count>0 then
    Begin
      for x:=1 to FObjects.Count do
      Begin
        FItem:=Items[x-1];
        If (FItem is TJLCabFolder) then
        Writer.WriteWord(0) else
        Writer.WriteWord(1);
        FItem.WriteObject(Writer);
      end;
    end;
  end;
  
  //###########################################################################
  // TJLCabFile
  //###########################################################################

  Function TJLCabFile.GetParent:TJLCabFolder;
  Begin
    result:=TJLCabFolder(Inherited Parent);
  end;

  Procedure TJLCabFile.InternalReset;
  Begin
    inherited;
    FSize:=0;
    FOffset:=0;
  end;
  
  Procedure TJLCabFile.SetSize(Value:Int64);
  Begin
    FSize:=Value;
  end;

  Procedure TJLCabFile.SetOffset(Value:Int64);
  Begin
    FOffset:=Value;
  end;
  
  Procedure TJLCabFile.ReadObject(Const Reader:TJLReader);
  Begin
    inherited;
    FSize:=Reader.ReadInt64;
    FOffset:=Reader.ReadInt64;
  end;

  Procedure TJLCabFile.WriteObject(Const Writer:TJLWriter);
  Begin
    inherited;
    Writer.WriteInt64(FSize);
    Writer.WriteInt64(FOffset);
  end;

  //###########################################################################
  // TJLCabItem
  //###########################################################################

  Procedure TJLCabItem.AfterConstruction;
  Begin
    inherited;
    InternalReset;
  end;

  Procedure TJLCabItem.SetCabinet(Value:TJLCabinet);
  Begin
    FCabinet:=Value;
  end;

  Function TJLCabItem.ObjectHasData:Boolean;
  Begin
    result:=True;
  End;

  Procedure TJLCabItem.ReadObject(Const Reader:TJLReader);
  Begin
    inherited;
    FCreated:=Reader.ReadDateTime;
    FName:=Reader.ReadString;
  end;

  Procedure TJLCabItem.WriteObject(Const Writer:TJLWriter);
  Begin
    inherited;
    Writer.WriteDateTime(FCreated);
    Writer.WriteString(FName);
  end;

  Procedure TJLCabItem.InternalReset;
  Begin
    FName:='';
    FCreated:=Now;
  end;

  Procedure TJLCabItem.InternalUpdate;
  Begin
    If FParent<>NIl then
    FFullPath:=FParent.FullPath + '\' + FName else
    FFullPath:=FName;
  end;

  Procedure TJLCabItem.SetFileName(Value:String);
  Begin
    FName:=Value;
  end;

  Procedure TJLCabItem.SetCreated(Value:TDateTime);
  Begin
    FCreated:=Value;
  end;

  Procedure TJLCabItem.SetParent(Value:TJLCabItem);
  Begin
    FParent:=Value;
  end;

  end.
