  unit jldisplay;

  {$I 'jldefs.inc'}


  interface

  uses
  jlcommon, jlraster, jlscrollctrl,
  dialogs,
  forms, windows, sysutils, classes, controls,
  messages, graphics, flatsb, math, contnrs;

  Const
  DEFAULT_SCALE = 1;

  CNT_JL_SCALEVALUES:Array[1..7] of integer =
  (1,4,8,12,16,18,22);

  {.$DEFINE ALLOW_SCROLL}

  type

  IJLGraphicClient = Interface
    ['{8AD5EC17-1B79-4552-8E1D-4173A6A68DF1}']
    Procedure gcRasterReady(value:TJLDIBRaster);
    Procedure gcRasterLost;
    Procedure gcRasterUpdated;
  end;


  TJLImageViewMode = (ivDefault,ivFitToScreen);

  TJLCustomRasterViewer = Class(TJLScrollbarControl,IJLGraphicClient)
  Private
    FSurface:   TJLDIBRaster;
    FMode:      TJLImageViewMode;
    FScale:     Integer;
    FOnScaleChange: TNotifyEvent;

    FFirst:     Boolean;
    FMouse:     Tpoint;

    Procedure   SetMode(Const Value:TJLImageViewMode);
    Procedure   SetScale(Const Value:Integer);
  Protected
    Function    GetDisplayRect:TRect;override;
    Property    Surface:TJLDIBRaster read FSurface;
  Protected
    (* IJLGraphicClient implementation *)
    Procedure   gcRasterReady(value:TJLDIBRaster);virtual;
    Procedure   gcRasterLost;virtual;
    Procedure   gcRasterUpdated;virtual;
  Protected
    Procedure   ReSize;Override;
    Procedure   Paint;Override;
    Procedure   MouseMove(Shift:TShiftState;X,Y:Integer);Override;
  Public
    Property    OnScaleChanged:TNotifyEvent
                read FOnScaleChange write FOnScaleChange;
    Property    ViewMode:TJLImageViewMode read FMode write SetMode;
    Property    Scale:Integer read FScale write SetScale;

    Property    MousePos:TPoint read FMouse;

    Procedure   Loaded;Override;
    Constructor Create(AOwner:TComponent);Override;
  End;

  TJLRasterViewer = Class(TJLCustomRasterViewer)
  Public
    property  DockManager;
  Published
    Property  OnScaleChanged;
    Property  Scale;
    Property  ViewMode;

    property  AutoScroll;
    Property  BorderStyle;
    Property  Increment;
    Property  Tracking;

    property  Align;
    property  Anchors;
    Property  DoubleBuffered;
    property  BiDiMode;
    property  BorderWidth;
    property  Color;
    property  Constraints;
    property  Ctl3D;
    property  UseDockManager default True;
    property  DockSite;
    property  DragCursor;
    property  DragKind;
    property  DragMode;
    property  Enabled;
    property  Font;
    property  ParentBiDiMode;
    property  ParentColor;
    property  ParentCtl3D;
    property  ParentFont;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  TabStop;
    property  Visible;
    property  OnCanResize;
    property  OnClick;
    property  OnConstrainedResize;
    property  OnContextPopup;
    property  OnDockDrop;
    property  OnDockOver;
    property  OnDblClick;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDock;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnGetSiteInfo;
    property  OnMouseDown;
    property  OnMouseMove;
    property  OnMouseUp;
    property  OnResize;
    property  OnStartDock;
    property  OnStartDrag;
    property  OnUnDock;
  End;



  {
  TJLThumbnail = Class(TObject)
  Private
    FRaster:    TJLDIBGraphic;
    FFilename:  String;
    FWidth:     Integer;
    FHeight:    Integer;
  Public
    Property    Raster:TJLDIBGraphic read FRaster;
    Procedure   MakeThumb;
    Procedure   ReleaseThumb;
  End;

  TJLDiskBrowser = Class(TJLCustomItemViewer)
  Private
    FPath:      String;
    FThumbs:    Array[1..10] of TJLDIBGraphic;
    Procedure   SetPath(value:String);
  Public
    Property    DiskPath:String read FPath write SetPath;
  End;        }

  Procedure JL_FlushMessage(Const Handle:HWND;Const AMsgType:Integer);
  Procedure JL_DrawGrid(Const ACanvas:TCanvas;Const ARect:TRect;
            Const Spacing:Integer=12);

  implementation


  Procedure JL_FlushMessage(Const Handle:HWND;Const AMsgType:Integer);
  var
    FMessage: TMSG;
  Begin
    FillChar(FMessage,SizeOf(FMessage),0);
    While PeekMessage(FMessage,Handle,AMsgType,AMsgType,PM_REMOVE) do
    FillChar(FMessage,SizeOf(FMessage),0)
  end;

  Procedure JL_DrawGrid(Const ACanvas:TCanvas;Const ARect:TRect;
            Const Spacing:Integer=12);
  var
    z,x,wd,hd,
    ftimes:     Integer;
    dx,dy,
    dx2,dy2:    Integer;
    FPenW:      Integer;
  Begin
    If  (ACanvas<>NIL)
    and JL_RectValid(ARect)
    and (Spacing>0) then
    Begin
      ACanvas.Pen.Color:=clBtnShadow;

      (* adjust width & height bounds *)
      wd:=(ARect.right-ARect.left)+1;
      hd:=(ARect.bottom-ARect.top)+1;
      inc(wd);
      inc(hd);

      x:=Spacing;
      ftimes:=((wd + hd) div Spacing)-1;

      (* Check pen width & Store *)
      FPenW:=ACanvas.pen.width;
      If ACanvas.Pen.Width>1 then
      ACanvas.pen.Width:=1;

      for z:=1 to FTimes do
      Begin
        dx:=ARect.left;
        dy:=ARect.top+x;
        dx2:=ARect.left+x;
        dy2:=ARect.Top;
        If JL_LineClip(ARect,dx,dy,dx2,dy2) then
        Begin
          ACanvas.MoveTo(dx,dy);
          ACanvas.LineTo(dx2,dy2);
          inc(x,Spacing);
        end else
        Break;
      end;

      (* Restore pen width if altered *)
      if FPenW<>1 then
      ACanvas.pen.Width:=FPenW;
    end;
  end;

  //###########################################################################
  // TJLCustomRasterViewer
  //###########################################################################

  Constructor TJLCustomRasterViewer.Create(AOwner:TComponent);
  Begin
    inherited;
    DoubleBuffered:=True;
    SetScale(DEFAULT_SCALE);
  end;

  Procedure TJLCustomRasterViewer.Loaded;
  Begin
    inherited;
  end;

  Procedure TJLCustomRasterViewer.SetScale(Const Value:Integer);
  var
    cx,cy: Integer;
    FLeft,FTop: Integer;
  Begin
    If not (csDestroying in ComponentState)
    and not (csCreating in ControlState) then
    Begin
      If Value<>FScale then
      Begin
        FLeft:=ScrollLeft;
        FTop:=ScrollTop;

        if FLeft>0 then
        cx:=ScrollLeft div CNT_JL_SCALEVALUES[FScale] else
        cx:=0;

        if FTop>0 then
        cy:=ScrollTop  div CNT_JL_SCALEVALUES[FScale] else
        cy:=0;
        
        FScale:=math.EnsureRange(Value,1,length(CNT_JL_SCALEVALUES));

        If  not (csLoading in ComponentState)
        and (FSurface<>NIL)
        and not(FSurface.Empty) then
        Begin
          cx:=cx * CNT_JL_SCALEVALUES[FScale];
          cy:=cy * CNT_JL_SCALEVALUES[FScale];
          gcRasterReady(FSurface);

          if (self.parent<>NIL) then
          ScrollBy(cx,cy);
        end;
        If  not (csDestroying in ComponentState)
        and not (csDesigning in ComponentState)
        and Assigned(FOnScaleChange) then
        FOnScaleChange(self);

      end;
    end;
  end;

  Procedure TJLCustomRasterViewer.SetMode(Const Value:TJLImageViewMode);
  Begin
    If Value<>FMode then
    Begin
      FMode:=Value;
      If  (FSurface<>NIL)
      and not (csDestroying in FSurface.Componentstate)
      and not (FSurface.Empty) then
      gcRasterUpdated;
    end;
  end;

  Procedure TJLCustomRasterViewer.gcRasterReady(value:TJLDIBRaster);
  var
    wd,hd:  Integer;
  Begin
    FSurface:=Value;
    if  not (csLoading in ComponentState)
    and Visible then
    Begin
      If FMode=ivDefault then
      Begin
        wd:=FSurface.Width * CNT_JL_SCALEVALUES[FScale];
        hd:=FSurface.Height * CNT_JL_SCALEVALUES[FScale];
        SetScrollBounds(0,0,wd,hd);
      end else
      SetScrollBounds(0,0,20,20);
      invalidate;
    end;
  end;

  Procedure TJLCustomRasterViewer.gcRasterLost;
  Begin
    FSurface:=NIL;
    if not (csDestroying in ComponentState)
    and (( ScrollWidth>0) or (ScrollHeight>0) ) then
    Begin
      RemoveScrollbars;
      SetScale(DEFAULT_SCALE);
      SetScrollBounds(0,0,0,0);
      Invalidate;
    end;
  end;

  Procedure TJLCustomRasterViewer.gcRasterUpdated;
  Begin
    if not (csDestroying in ComponentState)
    and (( ScrollWidth>0) or (ScrollHeight>0) ) then
    Invalidate;
  end;

  Procedure TJLCustomRasterViewer.ReSize;
  Begin
    inherited;
    Invalidate;
  end;

  Function TJLCustomRasterViewer.GetDisplayRect:TRect;
  var
    wd,hd:  Integer;
  Begin
    result:=inherited GetDisplayRect;
    wd:=(JL_RectWidth(result) shr 4) shl 4;
    hd:=(JL_RectHeight(result) shr 4) shl 4;

    result.right:=result.left + wd;
    result.bottom:=result.top + hd;
  end;

  Procedure TJLCustomRasterViewer.MouseMove(Shift:TShiftState;X,Y:Integer);
  var
    FRect:  TRect;
  Begin
    inherited;
    FRect:=GetDisplayRect;
    FMouse.X:=( (x-FRect.Left) div CNT_JL_SCALEVALUES[FScale] );
    FMouse.Y:=( (y-FRect.top) div CNT_JL_SCALEVALUES[FScale] );
    inc(FMouse.X,ScrollLeft div CNT_JL_SCALEVALUES[FScale]);
    inc(FMouse.Y,ScrollTop div CNT_JL_SCALEVALUES[FScale]);
  end;

  Procedure TJLCustomRasterViewer.Paint;
  var
    rc:       TRect;
    srcrect:  TRect;
    FRect:    TRect;
    wd,hd:    Integer;
    x,y:      integer;
  Begin
    inherited;
    JL_FlushMessage(WindowHandle,WM_PAINT);

    FRect:=GetDisplayRect;
    JL_DrawGrid(Canvas,FRect,22);

    If  (FSurface<>NIL)
    and (FSurface.Empty=False) then
    Begin
      Case FMode of
      ivDefault:
        Begin
            wd:=JL_RectWidth(FRect);
            hd:=JL_RectHeight(FRect);
            wd:=(wd div CNT_JL_SCALEVALUES[FScale]) * CNT_JL_SCALEVALUES[FScale];
            hd:=(hd div CNT_JL_SCALEVALUES[FScale]) * CNT_JL_SCALEVALUES[FScale];

            srcrect.Left:=ScrollLeft div CNT_JL_SCALEVALUES[FScale];
            srcRect.Top:=ScrollTop div CNT_JL_SCALEVALUES[FScale];
            srcRect.right:=srcrect.Left + (wd div CNT_JL_SCALEVALUES[FScale]);
            srcRect.Bottom:=srcRect.Top + (hd div CNT_JL_SCALEVALUES[FScale]);

            StretchBlt(Canvas.Handle,
            FRect.left,FRect.top,
            wd,
            hd,
            FSurface.DC,
            srcRect.Left,
            srcRect.top,
            JL_RectWidth(srcRect),
            JL_RectHeight(srcRect),
            srccopy);

        end;
      ivFitToScreen:
        Begin
          JL_RectFit(FRect,FSurface.BoundsRect,rc);
          x:=jl_rectwidth(rc);
          y:=jl_rectheight(rc);

          if (x=1) or (y=1)
          and (FFirst=False) then
          Begin
            FFirst:=True;
            Showmessage(jl_RectToStr(rc,true));
            exit;
          end;

          If (FSurface is TJLDIBRaster) then
          Begin
            SetStretchBltMode(Canvas.Handle,STRETCH_HALFTONE); //HALFTONE
            Stretchblt(canvas.handle,rc.left,rc.top,x,y,
            FSurface.DC,0,0,
            FSurface.width,FSurface.height,SRCCOPY);
          end;

        end;
      end;
    end;
  end;

  end.
