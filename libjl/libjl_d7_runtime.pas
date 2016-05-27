  unit libjl_d7_runtime;

  interface

  uses sysutils, classes;

  //Procedure Register;

  implementation

  uses jlcommon, jldatabuffer, jldisplay, jlgraphics,
  jlmsghandler, jlnavigator, jlscrollctrl, jlitemviewer,
  jlrastereditor, jltempfile;

  Procedure Register;
  Begin
    { RegisterComponents('LibJL',[TJLItemViewer,TJLMemoryBuffer,TJLDiskBuffer,
    TJLUNISurface,TJLDIBSurface,TJLRasterViewer,TJLRasterEdit,
    TJLMsgServer,TJLMsgClient,TJLItemNavigator,TJLTempFile]); }
  end;

  end.
