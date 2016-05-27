  unit hexfrmdesigner;

  interface

  uses forms, windows, sysutils, classes, controls, extctrls,
  messages, hexbase;

  const
  ResizeLeft        = $F001;
  ResizeRight       = $F002;
  ResizeTop         = $F003;
  ResizeTopLeft     = $F004;
  ResizeTopRight    = $F005;
  ResizeBottom      = $F006;
  ResizeBottomLeft  = $F007;
  ResizeBottomRight = $F008;
  MoveComponent     = $F012;

  Proximity = 8;

  Type

  THexFormDesigner = class(THexCustomComponent)
  private
    FActive:  Boolean;
    FAppMsg:  TMessageEvent;
    FPanel:   TCustomPanel;
    function  ActionToCursor(intAction: integer): TCursor;
    function  CoordinatesToAction(WinControl: TControl; X: integer; Y: integer): integer;
    procedure SetActive(const Value: boolean);
    Procedure SetPanel(Value:TCustomPanel);
  Protected
    procedure HandleAppMsg(var Msg: TMsg; var Handled: boolean);
  Public
    Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
  published
    Property  DesignPanel:  TCustomPanel read FPanel write SetPanel;
    property  Active: boolean read FActive write SetActive;
  end;

  implementation

  Type THexControlCracker = class(Controls.TControl);

  Procedure THexFormDesigner.Notification(AComponent:TComponent;Operation:TOperation);
  Begin
    inherited;
    If (AComponent is TCustomPanel) then
    Begin
      Case operation of
      opInsert: SetPanel(TCustomPanel(AComponent));
      opRemove: SetPanel(NIL);
      end;
    end;
  end;

  function THexFormDesigner.ActionToCursor(intAction: integer): TCursor;
  begin
    case intAction of
    ResizeLeft    , ResizeRight      : Result:=crSizeWE;
    ResizeTop     , ResizeBottom     : Result:=crSizeNS;
    ResizeTopLeft , ResizeBottomRight: Result:=crSizeNWSE;
    ResizeTopRight, ResizeBottomLeft : Result:=crSizeNESW;
    else
      Result:=crDefault;
    end;
  end;

  function THexFormDesigner.CoordinatesToAction(WinControl: TControl; X: integer; Y: integer): integer;
  begin
    if (X < Proximity) then
    begin
      if (Y < Proximity) then
      Result:=ResizeTopLeft else
      if (Y > (WinControl.Height - Proximity)) then
      Result:=ResizeBottomLeft else
      Result:=ResizeLeft;
    end else
    if (Y < Proximity) then
    begin
      if (X > (WinControl.Width - Proximity)) then
      Result:=ResizeTopRight else
      Result:=ResizeTop;
    end else
    if (X > (WinControl.Width - Proximity)) then
    begin
      if (Y > (WinControl.Height - Proximity)) then
      Result:=ResizeBottomRight else
      Result:=ResizeRight;
    end else
    if (Y > WinControl.Height - Proximity) then
    Result:=ResizeBottom else
    Result:=MoveComponent;

    { Take alignment into account, below procs }
    if (winControl.Align<>alNone) then
    begin
      if (result=MoveComponent) then
      Begin
        result:=0;
        exit;
      end;
    end;

    If (wincontrol.align=alTop) then
    Begin
      if (result<>reSizeBottom) then
      Begin
        result:=0;
        exit;
      end;
    end;

    if (wincontrol.align=alBottom) then
    Begin
      If (result<>ReSizeTop) then
      begin
        result:=0;
        exit;
      end;
    end;

    if (wincontrol.align=alLeft) then
    Begin
      If  (result<>ReSizeRight) then
      begin
        result:=0;
        exit;
      end;
    end;

    if (wincontrol.align=alRight) then
    Begin
      If  (result<>ReSizeLeft) then
      begin
        result:=0;
        exit;
      end;
    end;

  end;

  Procedure THexFormDesigner.SetPanel(Value:TCustomPanel);
  begin
    If (Value<>FPanel) then
    FPanel:=Value;
  End;

  procedure THexFormDesigner.SetActive(const Value: boolean);
  begin
    FActive := Value;
    if not (csDesigning in ComponentState) then
    begin
      if FActive then
      begin
        FAppMsg:=Application.OnMessage;
        Application.OnMessage:=HandleAppMsg;
      end else
      if Assigned(FAppMsg) then
      begin
        Application.OnMessage:=FAppMsg;
        FAppMsg:=nil;
      end;
    end;
  end;

  procedure THexFormDesigner.HandleAppMsg(var Msg: TMsg;var Handled: boolean);
  var
    WinControl: TControl;
    ControlPoint: TPoint;
  begin
    If msg.message = WM_KEYDOWN then
    Begin
      ReleaseCapture;
      Handled:=True;
      exit;
    end;

    WinControl:=FindDragTarget(Msg.pt, True);
    If not assigned(wincontrol)
    or not (wincontrol is TWinControl)
    or (wincontrol.parent<>FPanel)
    or (wincontrol=FPanel)
    or (wincontrol is TForm) then
    Begin
      If msg.message = WM_MOUSEMOVE then
      begin
        if assigned(wincontrol) then
        begin
          if (THexControlCracker(WinControl).DragMode = dmAutomatic) then
          WinControl.Cursor:=ActionToCursor(MoveComponent);
          Handled:=True;
        end;
      end;
      exit;
    end;

    Case msg.message of
    WM_LBUTTONDOWN:
      Begin
        ControlPoint:=WinControl.ScreenToClient(Msg.pt);
        PostMessage(Msg.hWnd, WM_SYSCOMMAND,
        CoordinatesToAction(WinControl, ControlPoint.X, ControlPoint.Y), 0);
        Handled:=True;
      end;
    WM_MOUSEMOVE:
      Begin
        ControlPoint:=WinControl.ScreenToClient(Msg.pt);
        WinControl.Cursor:=ActionToCursor
          (
          CoordinatesToAction(WinControl, ControlPoint.X, ControlPoint.Y)
          );
        Handled:=True;
      end;
    end;
  end;

  end.
