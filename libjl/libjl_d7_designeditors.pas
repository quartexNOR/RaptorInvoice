  unit libjl_d7_designeditors;

  interface

  uses forms, windows, controls, sysutils, classes,
  designintf, designeditors, dialogs;

  type

  TJLDataBufferEditor = Class(TComponentEditor)
  Public
    Procedure Edit;Override;
  End;

  TJLRasterEditor = Class(TComponentEditor)
  Public
    Procedure Edit;Override;
  End;

  implementation

  uses jlcommon, jldatabuffer, jlgraphics, jlraster,
  jldataeditorform,
  jlrastereditorform;

  //###########################################################################
  // TJLRasterEditor
  //###########################################################################

  {function TJLRasterEditor.GetAttributes:TPropertyAttributes;
  begin
    Result:=[paDialog,paReadOnly];
  end;   }

  Procedure TJLRasterEditor.Edit;
  var
    FEditor:  TfrmJLRasterEditor;
  begin
    If (GetComponent is TJLCustomRaster) then
    Begin
      FEditor:=TfrmJLRasterEditor.Create(NIL);
      try
        FEditor.Surface:=TJLCustomRaster(GetComponent);
        FEditor.ShowModal;
        Application.ProcessMessages;
      finally
        FEditor.free;
      end;
    end;
  end;

  //###########################################################################
  // TJLDataBufferEditor
  //###########################################################################

  Procedure TJLDataBufferEditor.Edit;
  var
    FData:  TJLBufferCustom;
    FEdit:  TfrmJLDataEditor;
  begin
    FData:=NIL;
    If (GetComponent is TJLBufferCustom) then
    Begin
      FData:=TJLBufferCustom(GetComponent);
      FEdit:=TfrmJLDataEditor.Create(NIL);
      try
        FEdit.ShowModal;
      finally
        FEdit.free;
      end;
    end;
  end;


  end.
