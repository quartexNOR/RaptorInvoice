  unit raptorprint;

  interface

  uses forms, windows, sysutils, classes, printers,
  contnrs;

  Type

  TPrintSegment = Class(TObject)
  End;

  TRaptorPrint = Class(TObject)
  Private
    FObjects:   TObjectlist;
    Function    GetCount:Integer;
    Function    GetItem(Index:Integer):TPrintSegment;
  Public
    Property    Items[index:Integer]:TPrintSegment read GetItem;
    Property    Count:Integer read GetCount;
    Constructor Create;
    Destructor  Destroy;Override;
  End;

  implementation

  Constructor TRaptorPrint.Create;
  begin
    inherited;
    FObjects:=TObjectList.Create(True);
  End;

  Destructor TRaptorPrint.Destroy;
  begin
    FObjects.free;
    inherited;
  End;

  Function TRaptorPrint.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  End;

  Function TRaptorPrint.GetItem(Index:Integer):TPrintSegment;
  Begin
    result:=TPrintSegment(FObjects[index]);
  End;

  end.
