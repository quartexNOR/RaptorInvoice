  unit libjl_d7_designtime;

  interface

  uses sysutils, classes;

  Procedure Register;

  implementation

  uses libjl_d7_designeditors, designintf, designeditors
  ,jlcommon, jldatabuffer, jldisplay,
  jlgraphics, jlraster,jlmsghandler, jlnavigator,
  jlscrollctrl, jlitemviewer, jlrastereditor, jltempfile;

  Procedure Register;
  Begin
    RegisterComponents('LibJL',
    [TJLItemViewer,TJLBufferMemory,TJLBufferDisk,
    TJLUNISurface,TJLDIBSurface,
    TJLRasterViewer,TJLRasterEdit,
    TJLMsgServer,TJLMsgClient,TJLItemNavigator,
    TJLTempFile]);

    RegisterComponentEditor(TJLBufferCustom,TJLDataBufferEditor);
    RegisterComponentEditor(TJLDIBSurface,TJLRasterEditor);
    RegisterComponentEditor(TJLUNISurface,TJLRasterEditor);
  end;


  end.
