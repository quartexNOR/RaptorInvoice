  unit hexreg;

  interface

  uses sysutils, classes, DsgnIntf,
  hexbase,
  hextext,
  hexencrypt,
  hexmime,
  hexcab,
  {$IFDEF WIN32}hexfrmdesigner,{$ENDIF}
  {$IFDEF WIN32}hexdll,{$ENDIF}
  hexmoniker,
  {$IFDEF WIN32}hexdownloadmgr,{$ENDIF}
  hexmdicom,
  hexpropbag,
  hexproxy,
  hexgfxfileproxy,
  hexfolderproxy;

  procedure Register;

  implementation

  procedure Register;
  Begin
    RegisterComponents('HexLib',
    [THexTextDivider,
    THexEncryption,
    THexMime,
    THexUrlMoniker,
    {$IFDEF WIN32}THexFormDesigner,{$ENDIF}
    THexCabinet,
    {$IFDEF WIN32}THexDllExamine,{$ENDIF}
    {$IFDEF WIN32}THexDownloadManager,{$ENDIF}
    THexMdiHost,
    THexMdiClient,
    THexPropertyBag,
    THexFolderProxy,
    THexImageFormatProxy]);

    RegisterPropertyEditor(TypeInfo(String),
    THexCustomComponent, 'About', THexAboutProperty);
  End;

  end.
