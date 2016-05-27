  unit jlscrollctrl;

  {$I 'jldefs.inc'}

  interface

  uses
  jlcommon,
  //jlraster,
  forms, windows, sysutils, classes, controls,
  messages, graphics, flatsb, math, contnrs;

  type

  TJLScrollbarControl = class(TCustomControl)
  private
    FAutoScroll:    Boolean;
    FBorderStyle:   TBorderStyle;
    FScrollLeft:    Integer;
    FScrollTop:     Integer;
    FScrollWidth:   Integer;
    FScrollHeight:  Integer;
    FTracking:      boolean;
    FIncrement:     integer;
    FIsUpdating:    Boolean;
  Private
    procedure SetAutoScroll(const Value: Boolean);
    procedure ScrollMessage(const AMessage:TWMHScroll;ACode:word;
              var APos:Integer;ASize,AClient:Integer);
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;

    procedure WMMouseWheel(var Msg: TWMMouseWheel); message CM_MouseWheel;

    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;

    procedure SetBorderStyle(const Value: TBorderStyle);

  protected
    Function  GetDisplayRect:TRect;virtual;
    Function  DisplayWidth:Integer;
    Function  DisplayHeight:Integer;

    procedure CreateParams(var Params:TCreateParams); override;
    procedure RemoveScrollbars;
    procedure SetScrollBounds(ALeft,ATop,AWidth,AHeight:Integer);virtual;
    procedure UpdateScrollbars;
    procedure UpdateScrollPosition;virtual;
    property  AutoScroll: Boolean read FAutoScroll
              write SetAutoScroll default True;
    property  BorderStyle: TBorderStyle read FBorderStyle
              write SetBorderStyle default bsSingle;
    property  Increment: integer read FIncrement
              write FIncrement default 8;
    property  ScrollLeft: Integer read FScrollLeft;
    property  ScrollTop: Integer read FScrollTop;
    property  ScrollWidth: Integer read FScrollWidth;
    property  ScrollHeight: Integer read FScrollHeight;
    property  Tracking: boolean read FTracking
              write FTracking default True;
    Procedure DisableScrollbars;
    Procedure EnableScrollbars;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ScrollBy(var DeltaX, DeltaY: integer); virtual;
  end;


  implementation


  //###########################################################################
  // TJLScrollbarControl
  //###########################################################################

  constructor TJLScrollbarControl.Create(AOwner: TComponent);
  begin
    inherited;
    ControlStyle:=ControlStyle - [csAcceptsControls];

    ControlStyle:=ControlStyle + [csOpaque]; //No background refresh

    FAutoScroll:=True;
    FIncrement:=9;
    //FScrollScale:=1;
    FTracking:=True;
    Color:=clbtnface;
    Width:=150;
    Height:=250;
    TabStop:=True;
    FBorderStyle:=bsSingle;
  end;

  procedure TJLScrollbarControl.CreateParams(var Params: TCreateParams);
  begin
    inherited CreateParams(Params);
    with Params do
    begin
      if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      ExStyle := ExStyle or WS_EX_CLIENTEDGE else
      Style := Style or WS_BORDER;
      WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    end;
  end;

  Procedure TJLScrollbarControl.DisableScrollbars;
  Begin
    If  (FScrollWidth>0)
    or  (FScrollHeight>0)
    and HandleAllocated then
    FlatSB_EnableScrollBar(WindowHandle,sb_Both, ESB_DISABLE_BOTH);
  end;

  Procedure TJLScrollbarControl.EnableScrollbars;
  Begin
    If  (FScrollWidth>0)
    or  (FScrollHeight>0)
    and HandleAllocated then
    FlatSB_EnableScrollBar(WindowHandle,sb_Both,ESB_ENABLE_BOTH );
  end;

  procedure TJLScrollbarControl.RemoveScrollbars;
  var
    ScrollInfo: TScrollInfo;
  begin
    If HandleAllocated then
    Begin
      (* Horizontal scrollbar *)
      FillChar(ScrollInfo, SizeOf(ScrollInfo), 0);
      ScrollInfo.cbSize := SizeOf(ScrollInfo);
      ScrollInfo.fMask := SIF_ALL;
      FlatSB_SetScrollInfo(Handle, SB_HORZ, ScrollInfo, True);

      (* Vertical scrollbar *)
      FlatSB_SetScrollInfo(Handle, SB_VERT, ScrollInfo, True);
    end;
  end;

  (* Call this procedure to scroll the window and update
     the scrollbars, all in one command *)
  procedure TJLScrollbarControl.ScrollBy(var DeltaX, DeltaY: integer);
  var
    ANewX, ANewY: Integer;
    AIntPosX, AIntPosY: integer;
  begin
    // Calculate new position in X and Y
    ANewX:= Min(Max(0,FScrollLeft+DeltaX),Max(0,FSCrollWidth-DisplayWidth));
    DeltaX:=ANewX-FScrollLeft;

    If DeltaY<0 then
    Begin
      ANewY:=FScrollTop + DeltaY;
      If ANewY<1 then
      ANewY:=0;
      if ANewY>FScrollTop then
      DeltaY:=ANewY-FScrollTop else
      DeltaY:=FScrollTop-ANewY
    end else
    Begin
      ANewY:= Min(Max(0,FScrollTop+DeltaY),Max(0,FSCrollHeight-DisplayHeight));
      DeltaY:=ANewY-FScrollTop;
    end;

    If (DeltaX>0) OR (DeltaY>0) then //Should be And?
    Begin
      FScrollLeft := ANewX;
      FScrollTop  := AnewY;
      UpdateScrollPosition;

      // Scroll the window
      {$IFDEF ALLOW_SCROLL}
      ScrollWindow(Handle, -DeltaX, -DeltaY, NIL,  NIL);
      {$ELSE}
      postmessage(Handle,CM_INVALIDATE,0,0);
      //Invalidate;
      {$ENDIF}

      // Set scrollbar positions
      AIntPosX := ANewX;
      AIntPosY := ANewY;
      if FlatSB_GetScrollPos(Handle, SB_HORZ) <> AIntPosX then
      FlatSB_SetScrollPos(Handle, SB_HORZ, AIntPosX, True);
      if FlatSB_GetScrollPos(Handle, SB_VERT) <> AIntPosY then
      FlatSB_SetScrollPos(Handle, SB_VERT, AIntPosY, True);
    end;
  end;

  procedure TJLScrollbarControl.ScrollMessage(const AMessage:TWMHScroll;
            ACode:word; var APos:Integer;ASize,AClient:Integer);

    procedure SetPosition(NewPos: Integer);
    var
      ANewPos: Integer;
      ADelta: integer;
      AIntPos: integer;
    begin
      // Calculate new position
      ANewPos := Min(Max(0, NewPos), Max(0, ASize - AClient));
      ADelta := ANewPos - APos;
      //if ADelta = 0 then exit; // no changes
      If ADelta<>0 then
      Begin
        APos := ANewPos;
        UpdateScrollPosition;

        // Scroll the window
        {$IFDEF ALLOW_SCROLL}
        case ACode of
        SB_HORZ: ScrollWindow(Handle, -ADelta, 0, NIL, NIL);
        SB_VERT: ScrollWindow(Handle, 0, -ADelta, NIL, NIL);
        end;//case
        {$ELSE}
        Invalidate;
        {$ENDIF}

        // Set scrollbar position
        AIntPos := NewPos;
        if FlatSB_GetScrollPos(Handle, ACode) <> AIntPos then
        FlatSB_SetScrollPos(Handle, ACode, AIntPos, True);
      end;
    end;

  begin
    If AutoScroll then
    Begin
        case ACode of
        SB_HORZ:  AClient:=DisplayWidth;
        SB_VERT:  AClient:=DisplayHeight;
        end;

      with AMessage do begin
        case ScrollCode of
        SB_LINEUP:        SetPosition(APos-Increment);
        SB_LINEDOWN:      SetPosition(APos+Increment);
        SB_PAGEUP:        SetPosition(APos-AClient);
        SB_PAGEDOWN:      SetPosition(APos+AClient);
        SB_THUMBPOSITION: SetPosition(Pos);
        SB_THUMBTRACK:    if Tracking then
                          SetPosition(Pos);
        SB_TOP:           SetPosition(0);
        SB_BOTTOM:        SetPosition(ASize - AClient);
        SB_ENDSCROLL:     ;
        end;
      end;
    end;
  end;

  procedure TJLScrollbarControl.SetAutoScroll(const Value: Boolean);
  begin
    if FAutoScroll <> Value then
    begin
      FAutoScroll := Value;
      if Value then
      UpdateScrollBars else
      begin
        RemoveScrollbars;
        FScrollLeft := 0;
        FScrollTop  := 0;
      end;
    end;
  end;

  procedure TJLScrollbarControl.SetBorderStyle(const Value: TBorderStyle);
  begin
    if Value <> FBorderStyle then
    begin
      FBorderStyle := Value;
      RecreateWnd;
    end;
  end;

  procedure TJLScrollbarControl.SetScrollBounds(ALeft,ATop,AWidth,AHeight:Integer);
  begin
    if (FScrollLeft <> ALeft)
    or (FScrollTop <> ATop)
    or (FScrollWidth <> AWidth)
    or (FScrollHeight <> AHeight) then
    begin
      if (FScrollLeft <> ALeft)
      or (FScrollTop <> ATop) then
      begin
        FScrollLeft:=ALeft;
        FScrollTop:=ATop;
        UpdateScrollPosition;
      end;
      FScrollWidth  := AWidth;
      FScrollHeight := AHeight;
      UpdateScrollbars;
    end;
  end;

  Function TJLScrollbarControl.GetDisplayRect:TRect;
  Begin
    result:=ClientRect;
    AdjustClientRect(result);
  end;

  Function TJLScrollbarControl.DisplayWidth:Integer;
  var
    FRect:  TRect;
  Begin
    FRect:=GetDisplayRect;
    Result:=JL_RectWidth(FRect);
  end;

  Function TJLScrollbarControl.DisplayHeight:Integer;
  var
    FRect:  TRect;
  Begin
    FRect:=GetDisplayRect;
    Result:=JL_RectHeight(FRect);
  end;

  procedure TJLScrollbarControl.UpdateScrollbars;
  var
    ScrollInfo: TScrollInfo;
    AScrollLeft, AScrollTop: Integer;
  begin
    If not (csDestroying in ComponentState)
    and HandleAllocated
    and AutoScroll then
    Begin
      If not FIsUpdating then
      Begin
        FIsUpdating:=True;

        // Check limits on Pos
        AScrollLeft := Max(0, Min(FScrollLeft,FScrollWidth-DisplayWidth ));
        AScrollTop  := Max(0, Min(FScrollTop,FScrollHeight-DisplayHeight ));

        if (AScrollLeft <> FScrollLeft)
        or (AScrollTop <> FScrollTop) then
        begin
          FScrollLeft := AScrollLeft;
          FScrollTop  := AScrollTop;
          UpdateScrollPosition;
          //  We need an extra invalidate here, the standard
          //  WinControl seems to forget this case
          Invalidate;
        end;

        // Horizontal scrollbar
        ScrollInfo.cbSize := SizeOf(ScrollInfo);
        ScrollInfo.fMask := SIF_ALL;
        ScrollInfo.nMin  := 0;
        ScrollInfo.nMax  := FScrollWidth;
        ScrollInfo.nPage := DisplayWidth;
        ScrollInfo.nPos  := FScrollLeft;
        ScrollInfo.nTrackPos := ScrollInfo.nPos;
        FlatSB_SetScrollInfo(Handle, SB_HORZ, ScrollInfo, True);

        // Vertical scrollbar
        ScrollInfo.nMin  := 0;
        ScrollInfo.nMax  := FScrollHeight;
        ScrollInfo.nPage := DisplayHeight;
        ScrollInfo.nPos  := FScrollTop;
        ScrollInfo.nTrackPos := ScrollInfo.nPos;
        FlatSB_SetScrollInfo(Handle, SB_VERT, ScrollInfo, True);

        FIsUpdating:=False;
      end;
    end;
  end;

  procedure TJLScrollbarControl.UpdateScrollPosition;
  begin
    // Override in descendants to update the window etc
    // Default does nothing
  end;

  procedure TJLScrollbarControl.WMEraseBkgnd(var m: TWMEraseBkgnd);
  begin
    inherited;
    exit;
    // This message handler is called when windows is about to work on
    // the background of the window, and this procedure signals not to
    // "erase" (or fill) it, to avoid flicker.
    // No automatic erase of background
    m.Result := LRESULT(false);
  end;

  procedure TJLScrollbarControl.WMSetFocus(var Message: TWMSetFocus);
  Begin
    inherited;
    //Invalidate;
  end;

  procedure TJLScrollbarControl.WMKillFocus(var Message: TWMSetFocus);
  Begin
    inherited;
    //Invalidate;
  end;

  procedure TJLScrollbarControl.WMMouseWheel(var Msg: TWMMouseWheel);
  var
    Delta: integer;
    IsUp: boolean;
    //vHandled: boolean;
    dy: Integer;
    dx: Integer;
  begin
    //vHandled := false;
    Delta := Msg.WheelDelta div WHEEL_DELTA;
    IsUp := Delta > 0;

    dx:=0;
    if IsUp then
    begin
      If Round(FScrollTop)>0 then
      Begin
        dy:=-(DisplayHeight div 2);
        self.ScrollBy(dx,dy);
      end;
    end else
    Begin
      dy:=DisplayHeight div 2;
      Self.ScrollBy(dx,dy);
    end;

    Msg.Result := 1;
  end;

  procedure TJLScrollbarControl.WMHScroll(var Message: TWMHScroll);
  begin
    ScrollMessage(Message, SB_HORZ, FScrollLeft, FScrollWidth, DisplayWidth);
  end;

  procedure TJLScrollbarControl.WMSize(var Message: TWMSize);
  begin
    (* use the info to update the scrollbars *)
    UpdateScrollbars;

    (* and call inherited method *)
    inherited;
  end;

  procedure TJLScrollbarControl.WMVScroll(var Message: TWMVScroll);
  begin
    ScrollMessage(Message,SB_VERT,FScrollTop,FScrollHeight,DisplayHeight);
  end;


  end.
