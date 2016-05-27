  unit hexbase;

  interface

  Uses sysutils, classes, controls, dialogs, dsgnintf,
  hexaboutform;

  { Common exception messages constants }
  Const
  ERR_HEX_InternalError         = 'Internal error: %s';
  ERR_HEX_FailedCreateElement   = 'Failed to create element error: %s';
  ERR_HEX_FailedAddElement      = 'Failed to add element to collection error: %s';
  ERR_HEX_FailedDeleteElement   = 'Failed to delete element from collection error: %s';
  ERR_HEX_FailedLoadData        = 'Failed to load data from file: %s';
  ERR_HEX_FailedSaveData        = 'Failed to save data to file: %s';
  ERR_HEX_StreamParamIsNIL      = 'Stream parameter cannot be NIL error';
  ERR_HEX_ParameterIsNIL        = 'Parameter cannot be NIL error: %s';
  ERR_HEX_FailedLoadDataStream  = 'Failed to load data from stream error: %s';
  ERR_HEX_FailedSaveDataStream  = 'Failed to save data to stream error: %s';
  ERR_HEX_FolderNotFound        = 'Folder not found error: %s';
  ERR_HEX_FileNotFound          = 'File not found error: %s';
  ERR_HEX_NotImplemented        = 'Feature not implemented error: %s';
  ERR_HEX_InvalidCanvas         = 'Invalid canvas, %s';
  ERR_HEX_InvalidGraphic        = 'Invalid graphic, %s';
  ERR_Hex_IOError               = 'An I/O error occured';

  Type

  { Common exceptions throughout the framework }
  EHEXException                 = Class(Exception);
  EHEXFailedCreateElement       = Class(EHEXException);
  EHEXFailedAddElement          = Class(EHEXException);
  EHEXFailedDeleteElement       = Class(EHEXException);
  EHEXInternalError             = Class(EHEXException);
  EHEXFailedLoadData            = Class(EHEXException);
  EHEXFailedSaveData            = Class(EHEXException);
  EHEXStreamParamIsNIL          = Class(EHEXException);
  EHEXParameterIsNIL            = Class(EHEXException);
  EHEXFailedLoadDataStream      = Class(EHEXException);
  EHEXFailedSaveDataStream      = Class(EHEXException);
  EHEXFolderNotFound            = Class(EHEXException);
  EHEXFileNotFound              = Class(EHEXException);
  EHEXInvalidCanvas             = Class(EHEXException);
  EHEXInvalidGraphic            = Class(EHEXException);
  EHEXNotImplemented            = Class(EHEXException);
  EHexIOError                   = Class(EHEXException);

  { Events for THEXCustomWorkComponent }
  THEXWorkBeginsEvent           = Procedure (Sender:TObject;MaxElements:Integer) of Object;
  THEXWorkProgressEvent         = Procedure (Sender:TObject;MaxElements,Position:Integer) of Object;
  THEXWorkCompleteEvent         = Procedure (Sender:TObject) of Object;
  THEXFlagsChangedEvent         = Procedure (Sender:TObject) of Object;
  THEXDataClearEvent            = Procedure (Sender:TObject) of Object;

  { Notification Flags for THEXCustomWorkComponent }
  THexNotificationFlags         = Set of (ntfWorkBegins,ntfWorkProgress,ntfWorkComplete,ntfDataClear);

  THexAboutProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  THexCustomComponent = Class(TComponent)
  Private
    FAbout:   String;
  Protected
    Function  ExceptFormat(Source,Cause:String):String;
  Published
    property  About: String read FAbout write FAbout;
  End;

  THEXCustomWorkComponent = Class(THexCustomComponent)
  Private
    FFlags:           THEXNotificationFlags;
    FOnWorkBegins:    THEXWorkBeginsEvent;
    FOnWorkEnds:      THEXWorkCompleteEvent;
    FOnWorkProgress:  THEXWorkProgressEvent;
    FOnFlagsChanged:  THEXFlagsChangedEvent;
    FOnDataClear:     THEXDataClearEvent;
    Procedure         SetFlags(Value:THEXNotificationFlags);
  Protected
    Procedure         WorkBegins(Elements:Integer);
    Procedure         WorkProgress(Elements,Position:Integer);
    Procedure         WorkComplete;
    Procedure         DataCleared;
  Public
    Property          EventFlags: THEXNotificationFlags read FFlags write SetFlags;
    Property          OnWorkBegins:THEXWorkBeginsEvent read FOnWorkBegins write FOnWorkBegins;
    Property          OnWorkComplete:THEXWorkCompleteEvent read FOnWorkEnds write FOnWorkEnds;
    Property          OnWorkProgress:THEXWorkProgressEvent read FOnWorkProgress write FOnWorkProgress;
    Property          OnEventFlagsChanged:THEXFlagsChangedEvent read FOnFlagsChanged write FOnFlagsChanged;
    Property          OnDataCleared:THEXDataClearEvent read FOnDataClear write FOnDataClear;
    Constructor       Create(AOwner:TComponent);Override;
  End;

  implementation

  //###################################################################
  // THexAboutProperty
  //###################################################################

  procedure THexAboutProperty.Edit;
  begin
    With TfrmHexAboutDialog.Create(NIL) do
    begin
      try
        Showmodal;
      finally
        Free;
      end;
    end;
  end;

  function THexAboutProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paMultiSelect, paDialog, paReadOnly];
  end;

  function THexAboutProperty.GetValue: string;
  begin
    Result := 'HexLib';
  end;

  //###################################################################
  // THexCustomComponent
  //###################################################################

  Function THexCustomComponent.ExceptFormat(Source,Cause:String):String;
  Begin
    result:=#13 + 'Class [' + ClassName + '] threw exception:'#13;
    result:=Result + 'Source: ' + source + #13;
    result:=result + 'Cause: ' + cause+ #13 + #13;
  End;

  //###################################################################
  // THEXCustomWorkComponent
  //###################################################################

  Constructor THEXCustomWorkComponent.Create(AOwner:TComponent);
  Begin
    Inherited Create(AOwner);
    FFlags:=
      [
      ntfWorkBegins,
      ntfWorkProgress,
      ntfWorkComplete,
      ntfDataClear
      ];
  end;

  Procedure THEXCustomWorkComponent.SetFlags(Value:THEXNotificationFlags);
  Begin
    If (Value<>FFlags) then
    Begin
      FFlags:=Value;
      try
        If assigned(FOnFlagsChanged) then
        FOnFlagsChanged(Self);
      except
        on exception do;
      end;
    End;
  End;

  Procedure THEXCustomWorkComponent.WorkBegins(Elements:Integer);
  Begin
    If  assigned(FOnWorkBegins)
    and (ntfWorkBegins in FFlags) then
    Begin
      try
        FOnWorkBegins(self,Elements);
      except
        on exception do;
      end;
    end;
  End;

  Procedure THEXCustomWorkComponent.WorkProgress(Elements,Position:Integer);
  Begin
    If  assigned(FOnWorkProgress)
    and (ntfWorkProgress in FFlags) then
    Begin
      try
        FOnWorkProgress(self,Elements,Position);
      except
        on exception do;
      end;
    end;
  End;

  Procedure THEXCustomWorkComponent.WorkComplete;
  Begin
    If  assigned(FOnWorkEnds)
    and (ntfWorkComplete in FFlags) then
    Begin
      try
        FOnWorkEnds(self);
      except
        on exception do;
      end;
    end;
  End;

  Procedure THEXCustomWorkComponent.DataCleared;
  Begin
    If assigned(FOnDataClear)
    and (ntfDataClear in FFlags) then
    Begin
      try
        FOnDataClear(Self);
      except
        on exception do;
      end;
    end;
  End;

  end.
