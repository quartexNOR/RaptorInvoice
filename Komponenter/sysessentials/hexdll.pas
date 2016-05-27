  unit hexdll;

  interface

  uses Forms, Windows, sysutils, classes, ImageHlp,
  hexbase;

  Type

  THexDllExamine = Class(THexCustomComponent)
  Private
    Flist:      TStringList;
  Public
    Property    Items: TStringList read Flist;
    Procedure   Examine(Const Filename:String);
    Constructor Create(AOwner:TComponent);Override;
    Destructor  Destroy;Override;
  End;

  implementation

  Constructor THexDllExamine.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    Flist:=TStringList.Create;
  End;

  Destructor THexDllExamine.Destroy;
  Begin
    FList.free;
    inherited;
  End;

  Procedure THexDllExamine.Examine(Const Filename:String);
  type
    TDWordArray = array [0..$FFFFF] of DWORD;
  var
    imageinfo: LoadedImage;
    pExportDirectory: PImageExportDirectory;
    dirsize: Cardinal;
    pDummy: PImageSectionHeader;
    i: Cardinal;
    pNameRVAs: ^TDWordArray;
    Name: string;
  begin
    FList.Clear;
    if MapAndLoad(PChar(FileName), nil, @imageinfo, True, True) then
    begin
      try
        pExportDirectory:=ImageDirectoryEntryToData
          (
          imageinfo.MappedAddress,
          False,
          IMAGE_DIRECTORY_ENTRY_EXPORT,
          dirsize
          );

        if (pExportDirectory <> nil) then
        begin
          pNameRVAs := ImageRvaToVa
          (
          imageinfo.FileHeader,
          imageinfo.MappedAddress,
          DWORD(pExportDirectory^.AddressOfNames),
          pDummy
          );

          for i := 0 to pExportDirectory^.NumberOfNames - 1 do
          begin
            Name := PChar(ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress,pNameRVAs^[i], pDummy));
            FList.Add(Name);
          end;
        end;
      finally
        UnMapAndLoad(@imageinfo);
      end;
    end;
  End;


  end.
