  unit jlstreams;

  interface

  uses windows, sysutils, classes;

  type

  {
  TMappedStream = Class(TCustomMemoryStream)
  private
  protected
    Ffilename,
    FobjectName:string;
    FfileHandle:Thandle;
    FmapObject : thandle;
    function OpenFile:Thandle;
    function CreateMapping(reqsize:longword):Thandle;
    function MakeView : pointer;
    procedure unmap;
    procedure SetSize(NewSize: Longint);override;
    procedure SetMapStart(const Value: longword);
  public
    Procedure FlushChanges(Amount:longword=0);
    Constructor Create(AFilename:string;ObjectName:string='');virtual;
    Destructor Destroy;override;
    function write(const Buf;count:longint):longint;override;
    Procedure Insert(Data:pointer;datasize:integer;InsertPos:longword=$FFFFFFFF);
    procedure Replace(OrgStart,OrgSize:longword;newData:pointer;newSize:longword);
    procedure Delete(DeleteSize:longword;DeleteStart:longword=$FFFFFFFF);
    property Filename:string read FFilename;
    property Handle : thandle read Ffilehandle;
  end;
  }

  TJLMemoryMappedFileStream = class(TStream)
  private
   FFileHandle: THandle;
   FMapHandle:  THandle;
   FFileName:   string;
   FMemory:     pointer;
   FCapacity:   longint;
   FSize:       longint;
   FPosition:   longint;
   FLastErr:    Integer;

   //File access attrib
   FAccess: Longint;

   //file sharing attributes
   FShare:longint;

   //mapping object page protection attributes
   FPageProtect:longint;

   //protection of the mapped memory
   FMemProtect:longint;

   //Name of the file mapping object
   FMapName:string;

   //file size increment
   FMemoryDelta:longint;

   procedure SetCapacity(NewCapacity:longint);
   procedure SetAttributes(Mode:word);
   procedure CloseHandles;
  public
   property   Memory:pointer read FMemory;
   property   FileName:string read FFileName;
   property   MapName:string read FMapName;
   property   MemoryDelta:longint read FMemoryDelta write FMemoryDelta;

   function   Read(var Buffer;Count:longint):longint;override;
   function   Write(const Buffer;Count:longint):longint;override;
   procedure  SetSize(NewSize:longint);override;
   function   Seek(Offset:longint;Origin:word):longint;override;
   procedure  Flush;virtual;

   constructor Create(const FileName,MapName:string;Mode:Word);
   constructor Open(const MapName:string; Mode:word);
   destructor   Destroy;override;
 end;

  implementation


{ TMappedFile }


{
constructor TMappedStream.Create;

begin

  inherited create;

  FFilename:=AFilename;

  FobjectName:=FobjectName;

  OpenFile;

  SetPointer(memory,GetFileSize(Ffilehandle,nil) );

  CreateMapping(size);

end;



function TMappedStream.OpenFile: Thandle;

begin

  result :=  CreateFile(pchar(FFilename),

             GENERIC_READ OR GENERIC_WRITE,

             0,

             nil,

             OPEN_ALWAYS,

             0,

             0 );

  FfileHandle:=result;

end;



function TMappedStream.CreateMapping(reqSize:longword): Thandle;

var P:Pchar;

begin

  if reqSize=0 then exit;



  if FObjectName='' then p:=nil

                    else P:=Pchar(FobjectName);



  result:= CreateFileMapping(FFileHandle,

                    nil,

                    PAGE_READWRITE,

                    0,

                    reqSize,

                    P );

  FMapObject:=result;

  if result=0 then raise

    Exception.Create('GetLastError() = '+inttostr(GetLastError));



  MakeView;

end;



procedure TMappedStream.unmap;

begin

  UnmapViewOfFile(Memory);

  CloseHandle(FmapObject);

end;



destructor TMappedStream.Destroy;

begin

  Unmap;

  CloseHandle(Ffilehandle);

  inherited;



end;



procedure TMappedStream.FlushChanges;

begin

  if not FlushViewOfFile(Memory,amount) then

      raise Exception.Create('GetLastError() = '+inttostr(GetLastError));

end;



function TMappedStream.MakeView: pointer;

begin

  result:= MapViewOfFile(FMapObject,

                FILE_MAP_ALL_ACCESS,

                0,

                0,

                0 );

  if result=nil then raise exception.create('MakeView failed');

  Setpointer(result,size);

end;











function TMappedStream.write(const Buf; count: Integer): longint;
var
  Pos: Longint;
begin

  if (Position >= 0) and (Count >= 0) then

  begin

    Pos := Position + Count;

    if Pos > 0 then

    begin

      if Pos > Size then

      begin

        SetSize( pos );

      end;

      System.Move(Buf, Pointer(Longint(Memory) + Position)^, Count);

      Position := Pos;

      Result := Count;

      Exit;

    end;

  end;

  Result := 0;

end;





procedure TMappedStream.SetSize(NewSize: Integer);

begin

  Unmap;



  if newsize<size then

    begin

      SetFilePointer(Ffilehandle,newsize,nil,FILE_BEGIN	);

      SetEndOfFile(Ffilehandle);

    end;



  SetPointer(memory,newsize);

  CreateMapping(NewSize);

end;



procedure TMappedStream.Insert;

var

  C:longword;

  Temp:pointer;

begin

  if InsertPos = $FFFFFFFF then InsertPos:=Position;



  C := size-InsertPos;             // Get size of existing data to be moved

  Size := Size + DataSize;    // Expand file to make room for new data



  GetMem(Temp,C);               // allocate temporary memory



  // copy all from right of the pos to temp.

  move(pointer(longword(memory)+InsertPos)^,

       temp^,

       C );



  // copy from temp over to new pos.

  move(temp^,

       pointer(longword(memory)+InsertPos+DataSize)^,

       C );



  // insert data at pos.

  Move(data^,

       pointer(longword(memory)+InsertPos)^,       //+0

       Datasize);                                   //10



  FreeMem(temp,C);

end;



procedure TMappedStream.Replace;

var

  Temp:pointer;

  diff:longword;

begin



  // IF THE NEW DATA IS GREATER THAN THE OLD

  if NewSize > OrgSize then  // something must be inserted

  begin

    diff := NewSize-OrgSize;



    // replace original with first part of the new data

    move(NewData^,

         pointer(longword(memory)+OrgStart)^,

         OrgSize );



    // insert the second part of the new data.

    insert(pointer(longword(newdata)+orgSize),

           diff,

           OrgStart+orgSize );



  end



  // IF THE NEW DATA IS LESS THAN THE OLD

  else if NewSize < OrgSize then // something must be deleted

    begin

      diff := OrgSize-NewSize;



      //replace first part of original with all of new data

      move(NewData^,

           Pointer(Longword(memory)+OrgStart )^,

           Newsize);



      delete(diff,

             OrgStart+NewSize );

    end



  // IF THE NEW DATA IS SAME SIZE AS THE OLD

  else

    begin

      move(NewData^,

           Pointer(Longword(memory)+OrgStart )^,

           Newsize);

    end;

end;



procedure TMappedStream.Delete;

var C:longword;

begin

  if DeleteStart=$FFFFFFFF then deleteStart:=position;



  C := size-deletesize-DeleteStart;



  Move(pointer( Longword(memory)+DeleteStart+DeleteSize)^,

       pointer( Longword(memory)+DeleteStart)^,

       C);



  Size := Size - deletesize;



end;



procedure TMappedStream.SetMapStart(const Value: longword);

begin

  CreateMapping(size);

  position:=0;

end;
       }


  Constructor TJLMemoryMappedFileStream.Create
              (const FileName,MapName:string;Mode:Word);
  begin
    FSize:=0;
    FMemoryDelta:=$FFFF;
    FFileName:=FileName;
    FMapName:=MapName;
    SetAttributes(Mode);

    if Mode = fmCreate then
    begin
      FFileHandle := CreateFile(PChar(FFileName),
      FAccess,FShare,nil,CREATE_ALWAYS,0,0);
      if FFileHandle<>0 then
      Begin
        FSize:=FMemoryDelta;
        FCapacity:=FMemoryDelta;
      end else
      raise EFCreateError.CreateFmt
      ('Error creating %s'#13#10'Code %d', [FFileName,GetLastError]);
    end else
    begin
      FFileHandle := CreateFile(PChar(FFileName),
      FAccess,FShare,nil,OPEN_EXISTING,0,0);
      FSize:=GetFileSize(FFileHandle,nil);
      FCapacity:=FSize;

      if (FFileHandle = 0)
      or (FSize=longint($FFFFFFFF)) then
      raise EFOpenError.CreateFmt
      ('Error opening %s'#13#10'Code %d', [FFileName,GetLastError]);
    end;

    FMapHandle:=CreateFileMapping(FFileHandle,nil,FPageProtect,0,FCapacity,PChar(FMapName));
    FLastErr:=GetLastError;
    if (FMapHandle = 0)
    or (FLastErr <> ERROR_SUCCESS) then
    raise EFOpenError.CreateFmt
    ('Error creating file mapping object %s'#13#10'Code %d', [FMapName,FLastErr]);

    FMemory:=MapViewOfFile(FmapHandle,FILE_MAP_WRITE,0,0,0);
    FLastErr:=GetLastError;
    if (FLastErr <> ERROR_SUCCESS) then
    raise EFOpenError.CreateFmt('Error mapping file %s'#13#10'Code %d', [FFileName,FLastErr]);
    FPosition:=0;
  end;

  destructor TJLMemoryMappedFileStream.Destroy;
  begin
    CloseHandles;
    inherited;
  end;

  constructor TJLMemoryMappedFileStream.Open(const MapName:string; Mode:word);
  begin
    FMemoryDelta:=$FFFF;
    FFileName:='';
    FMapName:=MapName;
    SetAttributes(Mode);

    if Mode = fmCreate then
    raise Exception.Create('Use "Create" constructor with fmCreate mode');

    FSize:=FMemoryDelta;
    FCapacity:=FMemoryDelta;
    FFileHandle := 0;

    FMapHandle:=OpenFileMapping(FMemProtect,FALSE,PChar(FMapName));
    FLastErr:=GetLastError;
    if (FMapHandle = 0) or (FLastErr <> ERROR_SUCCESS) then
    raise Exception.CreateFmt('Error opening file mapping object %s'#13#10'Code %d',
    [FMapName,FLastErr]);

    FMemory:=MapViewOfFile(FmapHandle,FILE_MAP_WRITE,0,0,0);
    FLastErr:=GetLastError;
    if FLastErr <> ERROR_SUCCESS then
    raise Exception.CreateFmt('Error mapping file %s'#13#10'Code %d', [FMapName,FLastErr]);
    FPosition:=0;
  end;

  procedure TJLMemoryMappedFileStream.SetAttributes(Mode:word);
  begin
    if (Mode and fmOpenReadWrite) = fmOpenReadWrite then
    begin
      FAccess :=GENERIC_WRITE OR GENERIC_READ;
      FPageProtect:=PAGE_READWRITE OR SEC_COMMIT;
      FMemProtect:=FILE_MAP_ALL_ACCESS;
    end else
    if (Mode and fmOpenWrite) = fmOpenWrite then
    begin
      FAccess :=GENERIC_WRITE OR GENERIC_READ;
      FPageProtect:=PAGE_READWRITE OR SEC_COMMIT;
      FMemProtect:=FILE_MAP_WRITE;
    end else
    begin
      FAccess :=GENERIC_READ;
      FPageProtect:=PAGE_READONLY OR SEC_COMMIT;
      FMemProtect:=FILE_MAP_READ;
    end;

    FShare:=0;
    if (Mode and fmShareDenyWrite) = fmShareDenyWrite then
    FShare:=FILE_SHARE_READ;

    if (Mode and fmShareDenyRead) = fmShareDenyRead then
    FShare:=FILE_SHARE_WRITE;

    if (Mode and fmShareExclusive) = fmShareExclusive then
    FShare:=0;
  end;

  procedure TJLMemoryMappedFileStream.CloseHandles;
  begin
    if FMemory <> nil then
    begin
      if not FlushViewOfFile(FMemory,0) then
      raise Exception.CreateFmt('Error flushing'#13#10'Code %d', [GetLastError]);

      if not UnmapViewOfFile(FMemory) then
      raise Exception.CreateFmt('Error unmapping view'#13#10'Code %d', [GetLastError]);
    end;

    if FMapHandle <> 0 then
    Begin
      if not CloseHandle(FMapHandle) then
      raise Exception.CreateFmt('Error closing map %s'#13#10'Code %d', [FMapName,GetLastError]);
    end;

    if FFileHandle <> 0 then
    Begin
      if not CloseHandle(FFileHandle) then
      raise Exception.CreateFmt('Error closing file %s'#13#10'Code %d', [FFileName,GetLastError]);
    end;
  end;

  function TJLMemoryMappedFileStream.Read(var Buffer;Count:longint):longint;
  var
    src: pByte;
  begin
    Result := 0;
    if (FPosition >= 0) and (Count > 0) then
    begin
      Result:=(FSize - FPosition);
      if Result > 0 then
      begin
        if Result > Count then
        Result := Count;
        src:=FMemory;
        Inc(src,FPosition);
        Move(src^, Buffer, Result);
        FPosition:=FPosition + Result;
      end;
    end;
  end;

  function TJLMemoryMappedFileStream.Write(const Buffer;Count:longint):longint;
  var
    FRange:  Int64;
    dst:  PByte;
  begin
    Result := 0;
    if  (FPosition >= 0)
    and (Count >= 0) then
    begin
      FRange:=FPosition + Count;
      if (FRange > 0) then
      begin
        if (FRange > FSize) then
        begin
          if (FRange > FCapacity) then
          Begin
            SetCapacity(FRange);
            FSize:=FRange;
          end;
        end;
        dst:=FMemory;
        inc(dst,FPosition);
        System.Move(Buffer, dst^, Count);
        FPosition := FRange;
        Result:=Count;
      end;
    end;
  end;

  procedure TJLMemoryMappedFileStream.SetSize(NewSize:longint);
  begin
    if NewSize < FSize then
    SetCapacity(NewSize) else
    if NewSize >= FSize then
    Begin
      //within range of capacity?
      if NewSize <= FCapacity then
      FSize:=NewSize else
      begin
        // grow capacity
        SetCapacity(NewSize);
        if NewSize <= FCapacity then
        FSize:=NewSize;
      end;
    end;
  end;

  procedure TJLMemoryMappedFileStream.SetCapacity(NewCapacity:longint);
  begin
    if NewCapacity=0 then
    begin
      Flush;
      FSize:=0;
      FCapacity:=0;
    end else
    begin
      CloseHandles;
      //Close MMF and try to recreate it with the new size
      //Is there a better way to change the size of an MMF?
      //FFileHandle=0 for the open (not created!)named mapping object
      if FFileHandle <> 0 then
      begin
        FFileHandle := CreateFile(PChar(FFileName),FAccess,FShare,nil,OPEN_EXISTING,0,0);
        FLastErr:=GetLastError;
        if (FFileHandle = 0)
        or (FSize=longint($FFFFFFFF))
        or (FLastErr <> ERROR_SUCCESS) then
        raise Exception.CreateFmt('Error opening %s'#13#10'Code %d', [FileName,FLastErr]);
      end else
      raise Exception.CreateFmt('Cannot change size of an open mapping object %s', [FMapName]);

      FCapacity:=NewCapacity+FMemoryDelta;
      FMapHandle:=CreateFileMapping(FFileHandle,nil,FPageProtect,0,FCapacity,PChar(FMapName));
      FLastErr:=GetLastError;
      if (FMapHandle = 0)
      or (FLastErr <> ERROR_SUCCESS) then
      raise Exception.CreateFmt
      ('Error creating file mapping object %s'#13#10'Code %d', [FMapName,FLastErr]);
      FMemory:=MapViewOfFile(FMapHandle,FILE_MAP_WRITE,0,0,0);

      FLastErr:=GetLastError;
      if FLastErr <> ERROR_SUCCESS then
      raise Exception.CreateFmt('Error mapping file %s'#13#10'Code %d', [FMapName,FLastErr]);
      FPosition:=0;
    end;
  end;

  function TJLMemoryMappedFileStream.Seek(Offset:longint;Origin:word):longint;
  begin
    case Origin of
    soFromBeginning : FPosition:=Offset;
    soFromCurrent   : FPosition:=FPosition + Offset;
    soFromEnd       : FPosition:=FSize+Offset;
    end;
    Result:=FPosition;
  end;

  procedure TJLMemoryMappedFileStream.Flush;
  begin
    FlushViewOfFile(FMemory,0);
  end;        


  end.
