  unit jlrastereditor;

  {$I 'jldefs.inc'}

  interface

  uses jlcommon, jlraster, jlscrollctrl, jldisplay,
  sysutils, classes, math, contnrs,
  windows, forms, graphics, controls, messages;

  type

  TJLBrushList    = Class;
  TJLCustomTool   = Class;
  TJLCustomBrush  = Class;
  TJLToolList     = Class;
  TJLCustomRasterEditor = Class;

  TJLRasterEditorPaintEvent = procedure
  (Sender:TObject;ACanvas:TCanvas;Area:TRect) of Object;

  TJLBrushInfo = Record
    biLeft:   Integer;
    biTop:    Integer;
    biColor:  TColor;
    biTarget: TJLDIBRaster;
    biUndo:   TJLDIBRaster;
  End;

  TJLToolInfo = Record
    tiStart:  TPoint;
    tiEnd:    TPoint;
    tiBrush:  TJLCustomBrush;
    tiTarget: TJLDIBRaster;
    tiUndo:   TJLDIBRaster;
  End;

  TJLCustomBrush = Class(TObject)
  Private
    FParent:    TJLBrushList;
  Protected
    Procedure   Draw(var Info:TJLBrushInfo);virtual;abstract;
  Public
    Property    Parent:TJLBrushList read FParent;
    Constructor Create(AOwner:TJLBrushList);
  End;

  TJLSquareBrush = Class(TJLCustomBrush)
  Private
    //FMask:      TJLUniRaster;
  Protected
    Procedure   Draw(var Info:TJLBrushInfo);override;
  End;

  TJLRoundBrush = Class(TJLCustomBrush)
  Private
    //FMask:      TJLUniRaster;
  Protected
    Procedure   Draw(var Info:TJLBrushInfo);override;
  End;

  TJLBrushList = Class(TObject)
  Private
    FObjects:   TObjectList;
    FIndex:     Integer;
    FBrush:     TJLCustomBrush;
    FSize:      Integer;
    FParent:    TJLCustomRasterEditor;
    Function    GetCount:Integer;
    Function    GetItem(Index:Integer):TJLCustomBrush;
    Procedure   SetIndex(Index:Integer);
    Procedure   SetSize(Value:Integer);
  Public
    Property    Count:Integer read GetCount;
    Property    Items[index:Integer]:TJLCustomBrush
                read GetItem;
    Property    Size:Integer read FSize write SetSize;
    Property    Itemindex:Integer read FIndex write SetIndex;
    Property    Selected:TJLCustomBrush read FBrush;
    Constructor Create(AOwner:TJLCustomRasterEditor);
    Destructor  Destroy;Override;
  End;

  TJLCustomTool = Class(TObject)
  Private
    FParent:    TJLToolList;
  Protected
    Procedure   BeginOperation(var Info:TJLToolInfo);virtual;abstract;
    Procedure   UpdateOperation(var Info:TJLToolInfo);virtual;abstract;
    Procedure   EndOperation(var Info:TJLToolInfo);virtual;abstract;
  Public
    Property    Parent:TJLToolList read FParent;
    Constructor Create(AOwner:TJLToolList);virtual;
  End;

  TJLPenTool = Class(TJLCustomTool)
  Protected
    Procedure BeginOperation(var Info:TJLToolInfo);override;
    Procedure UpdateOperation(var Info:TJLToolInfo);override;
    Procedure EndOperation(var Info:TJLToolInfo);override;
  End;

  TJLToolList = Class(TObject)
  Private
    FObjects:   TObjectList;
    FIndex:     Integer;
    FTool:      TJLCustomTool;
    FParent:    TJLCustomRasterEditor;
    Function    GetCount:Integer;
    Function    GetItem(Index:Integer):TJLCustomTool;
    Procedure   SetIndex(Index:Integer);
  Public
    Property    Count:Integer read GetCount;
    Property    Items[index:Integer]:TJLCustomTool
                read GetItem;
    Property    Itemindex:Integer read FIndex write SetIndex;
    Property    Selected:TJLCustomTool read FTool;
    Constructor Create(AOwner:TJLCustomRasterEditor);
    Destructor  Destroy;Override;
  End;

  TJLCustomRasterEditor = Class(TJLCustomRasterViewer)
  Private
    FBusy:      Boolean;
    FCutRect:   TRect;
    FUndo:      TJLDibRaster;
    FBrushes:   TJLBrushList;
    FTools:     TJLToolList;
    FToolInfo:  TJLToolInfo;
    FOnPaint:   TJLRasterEditorPaintEvent;
    {$HINTS OFF}
    Property    ViewMode;
    {$HINTS ON}
  Protected
    Function    GetDisplayRect:TRect;override;
    Procedure   PaintHRuler(Const ACanvas:TCanvas;ARect:TRect);
    Procedure   PaintVRuler(Const ACanvas:TCanvas;ARect:TRect);
    Procedure   Paint;Override;
    Procedure   MouseDown(Button:TMouseButton;
                Shift:TShiftState;X,Y:Integer);Override;
    Procedure   MouseMove(Shift:TShiftState;X,Y:Integer);Override;
    Procedure   MouseUp(Button:TMouseButton;
                Shift:TShiftState;X,Y:Integer);override;

    Property    OnPaintOverlay:TJLRasterEditorPaintEvent
                read FOnPaint write FOnPaint;

  Protected
    Procedure   gcRasterReady(value:TJLDIBRaster);override;
    Procedure   gcRasterLost;override;
  Public
    Property    BrushList:TJLBrushList read FBrushes;
    Property    ToolList:TJLToolList read FTools;
    Procedure   Loaded;Override;
    Constructor Create(AOwner:TComponent);Override;
    Destructor  Destroy;Override;
  End;


  TJLRasterEdit = Class(TJLCustomRasterEditor)
  Public
    property  DockManager;
  Published
    Property  OnPaintOverlay;
    Property  OnScaleChanged;
    Property  Scale;

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

  implementation

  Const
  DEFAULT_SCALE = 1;
  CNT_JL_SCALEVALUES:Array[1..7] of integer =
  (1,4,8,12,16,18,22);

  CNT_JL_RULERVALUES:Array[1..7] of integer =
  (50,25,15,10,5,5,5);

  CNT_JL_RULERSIZE  = 20;

  //###########################################################################
  // TJLSquareBrush
  //###########################################################################

  Procedure TJLSquareBrush.Draw(var Info:TJLBrushInfo);
  var
    FRect:  TRect;
    FSeg: Integer;
  Begin
    if Parent.Size>2 then
    Begin
      FSeg:=Parent.Size div 2;
      dec(FSeg);
      FRect:=Rect(Info.biLeft - FSeg,info.biTop-FSeg,
      Info.biLeft + FSeg, info.biTop + FSeg);
      Info.biTarget.Canvas.FillRect(FRect);
    end else
    info.biTarget.Canvas.SetPixel(Info.biLeft,Info.biTop);
  end;

  //###########################################################################
  // TJLRoundBrush
  //###########################################################################

  Procedure TJLRoundBrush.Draw(var Info:TJLBrushInfo);
  Begin
  end;


  //###########################################################################
  // TJLCustomBrush
  //###########################################################################

  Constructor TJLCustomBrush.Create(AOwner:TJLBrushList);
  Begin
    inherited Create;
    FParent:=AOwner;
  end;

  //###########################################################################
  // TJLBrushList
  //###########################################################################

  Constructor TJLBrushList.Create(AOwner:TJLCustomRasterEditor);
  Begin
    inherited Create;
    FParent:=AOwner;
    FObjects:=TObjectList.Create(True);
    FObjects.Add(TJLSquareBrush.Create(self));
    FObjects.Add(TJLRoundBrush.Create(self));
    SetIndex(0);
    SetSize(12);
  end;

  Destructor TJLBrushList.Destroy;
  Begin
    FObjects.free;
    inherited;
  end;

  Function TJLBrushList.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  end;

  Function TJLBrushList.GetItem(Index:Integer):TJLCustomBrush;
  Begin
    result:=TJLCustomBrush(FObjects[index]);
  end;

  Procedure TJLBrushList.SetSize(Value:Integer);
  Begin
    If Value<>FSize then
    FSize:=math.EnsureRange(Value,1,64)
  end;

  Procedure TJLBrushList.SetIndex(Index:Integer);
  Begin
    If  (index>=0)
    and (index<FObjects.Count) then
    Begin
      FIndex:=Index;
      FBrush:=TJLCustomBrush(FObjects[FIndex]);
    end;
  end;

  //###########################################################################
  // TJLCustomTool
  //###########################################################################

  Constructor TJLCustomTool.Create(AOwner:TJLToolList);
  Begin
    inherited Create;
    FParent:=AOwner;
  end;

  //###########################################################################
  // TJLPenTool
  //###########################################################################

  Procedure TJLPenTool.BeginOperation(var Info:TJLToolInfo);
  Begin
    Info.tiTarget.Canvas.Color:=clRed;
    UpdateOperation(Info);
  end;

  Procedure TJLPenTool.UpdateOperation(var Info:TJLToolInfo);
  var
    FBrush: TJLBrushInfo;
  Begin
    FBrush.biLeft:=info.tiEnd.x;
    FBrush.biTop:=info.tiEnd.y;
    FBrush.biTarget:=Info.tiTarget;
    FBrush.biUndo:=Info.tiUndo;
    Info.tiBrush.Draw(FBrush);

    { Info.tiTarget.Canvas.Line(Info.tiStart.x,info.tiStart.y,
    info.tiEnd.x,info.tiEnd.Y);
    Info.tiStart:=Info.tiEnd; }
  end;

  Procedure TJLPenTool.EndOperation(var Info:TJLToolInfo);
  Begin
    UpdateOperation(Info);
  end;

  //###########################################################################
  // TJLToolList
  //###########################################################################

  Constructor TJLToolList.Create(AOwner:TJLCustomRasterEditor);
  Begin
    inherited Create;
    FParent:=AOwner;
    FObjects:=TObjectList.Create(True);
    FObjects.Add(TJLPenTool.Create(self));
    SetIndex(0);
  end;

  Destructor TJLToolList.Destroy;
  Begin
    FObjects.free;
    inherited;
  end;

  Function TJLToolList.GetCount:Integer;
  Begin
    result:=FObjects.Count;
  end;

  Function TJLToolList.GetItem(Index:Integer):TJLCustomTool;
  Begin
    result:=TJLCustomTool(FObjects[index]);
  end;

  Procedure TJLToolList.SetIndex(Index:Integer);
  Begin
    If  (index>=0)
    and (index<FObjects.Count) then
    Begin
      FIndex:=Index;
      FTool:=TJLCustomTool(FObjects[FIndex]);
    end;
  end;


  //###########################################################################
  // TJLCustomRasterEditor
  //###########################################################################

  Constructor TJLCustomRasterEditor.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    DoubleBuffered:=False;
    FUndo:=TJLDibRaster.Create(NIL);
    FBrushes:=TJLBrushList.Create(self);
    FTools:=TJLToolList.Create(self);
  end;

  Destructor TJLCustomRasterEditor.Destroy;
  Begin
    FUndo.free;
    FBrushes.free;
    FTools.free;
    inherited;
  end;

  Procedure TJLCustomRasterEditor.Loaded;
  Begin
    inherited;
    If assigned(surface)
    and not (csLoading in Surface.ComponentState)
    and not (csReading in Surface.ComponentState) then
    FUndo.Assign(Surface);
  end;
  
  Function TJLCustomRasterEditor.GetDisplayRect:TRect;
  Begin
    result:=Inherited GetDisplayRect;
    inc(Result.top,CNT_JL_RULERSIZE + 1);
    inc(result.left,CNT_JL_RULERSIZE + 1);
  end;

  Procedure TJLCustomRasterEditor.PaintHRuler(Const ACanvas:TCanvas;
            ARect:TRect);
  var
    x:      Integer;
    dx:     Integer;
    Fourth: Integer;
    FSkip:  Integer;
    FText:  String;
    FOrigo: Integer;
  Begin
    FSkip:=1;
    Fourth:=(ARect.bottom-ARect.top) div 4;

    ACanvas.brush.Color:=clWhite;
    ACanvas.FillRect(ARect);

    ACanvas.pen.Color:=clBtnShadow;
    ACanvas.MoveTo(ARect.left,ARect.bottom);
    ACanvas.LineTo(ARect.right,ARect.bottom);

    ACanvas.pen.color:=clBtnShadow;

    x:=ARect.left - ( (ScrollLeft div CNT_JL_SCALEVALUES[Scale]) //FScale
    * CNT_JL_SCALEVALUES[Scale]); //FScale

    FOrigo:=x;

    while x<JL_RectWidth(ARect) do
    Begin
      FSkip:=1-FSkip;

      inc(x,CNT_JL_SCALEVALUES[Scale] * CNT_JL_RULERVALUES[Scale]);
      dx:=x + CNT_JL_SCALEVALUES[Scale] + 1;

      if (dx>ARect.left) and (dx<ARect.right) then
      Begin
        FText:=IntToStr( (x - FOrigo) div CNT_JL_SCALEVALUES[Scale]  );
        ACanvas.TextOut(dx,ARect.top,FText);

        If FSkip=1 then
        ACanvas.moveTo(dx,ARect.bottom-(Fourth * 2)) else
        ACanvas.moveTo(dx,ARect.bottom-Fourth);
        ACanvas.lineTo(dx,ARect.bottom);
      end;

    end;
  end;

  Procedure TJLCustomRasterEditor.gcRasterReady(value:TJLDIBRaster);
  Begin
    inherited;
    If not (csLoading in ComponentState)
    and not (csDestroying in ComponentState)
    and assigned(FUndo) then
    FUndo.Assign(Value);
  end;

  Procedure TJLCustomRasterEditor.gcRasterLost;
  Begin
    Inherited;
    FUndo.Release;
  end;

  Procedure TJLCustomRasterEditor.MouseDown(Button:TMouseButton;
            Shift:TShiftState;X,Y:Integer);
  var
    FRect:  TRect;
    //wd,hd:  Integer;
    //src:    TJLDIBRaster;
  Begin
    inherited;
    FBusy:=False;
    FCutRect:=JL_NULLRECT;

    If  (Surface<>NIL)
    and (Surface.Empty=False) then
    Begin
      FRect:=GetDisplayRect;
      FBusy:=jlcommon.JL_PosInRect(FRect,x,y);
      If FBusy then
      Begin
        {If not FUndo.Empty then
        FUndo.Release;     }

        move(Surface.PixelBuffer^,
        FUndo.PixelBuffer^,Surface.PixelBufferSize);

        FCutRect:=Rect(MousePos.x-1,MousePos.y-1,
        MousePos.x+1,MousePos.y+1);

        FToolInfo.tiStart:=Point(MousePos.x,MousePos.y);
        FToolInfo.tiEnd:=FToolInfo.tiStart;
        FToolInfo.tiTarget:=Surface;
        FToolInfo.tiUndo:=FUndo;
        FToolInfo.tiBrush:=FBrushes.Selected;
        FTools.Selected.BeginOperation(FToolInfo);

        Invalidate;
      end;
    end;
  end;

  Procedure TJLCustomRasterEditor.MouseMove(Shift:TShiftState;X,Y:Integer);
  var
    FOld:   TRect;
    FDisp:  TRect;
    //wd,hd:  Integer;
  Begin
    inherited;

    FDisp:=GetDisplayRect;

    If Surface<>NIL then
    Begin
      If Surface.Empty=False then
      Begin
        If jlcommon.JL_PosInRect(FDisp,x,y) then
        Begin
          If self.Cursor<>crCross then
          Cursor:=crCross;
        end else
        Begin
          if Cursor<>crDefault then
          cursor:=crDefault;
          exit;
        end;
      end else
      Begin
        if Cursor<>crDefault then
        cursor:=crDefault;
        exit;
      end;
    end else
    Begin
      if Cursor<>crDefault then
      cursor:=crDefault;
      exit;
    end;

    If FBusy then
    Begin

      if (mousepos.x=FToolInfo.tiEnd.X)
      and (mousepos.y=FToolInfo.tiEnd.y) then
      exit;

      If Mousepos.x<FCutRect.left then
      FCutRect.left:=Mousepos.x else
      if (Mousepos.x+1)>FCutRect.right then
      FCutRect.right:=Mousepos.x+1;

      if Mousepos.y<FCutRect.top then
      FCutRect.top:=Mousepos.y else
      if (Mousepos.y+1)>FCutRect.bottom then
      FCutRect.bottom:=Mousepos.y+1;

      FToolInfo.tiEnd:=Point(mousepos.x,mousepos.y);
      FToolInfo.tiTarget:=Surface;
      FToolInfo.tiUndo:=FUndo;
      FToolInfo.tiBrush:=FBrushes.Selected;
      FTools.Selected.UpdateOperation(FToolInfo);

      //FOld:=FCutRect;
      //If not (csCustomPaint in ControlState) then
      //windows.InvalidateRect(Handle,@FOld,False);

      {If not (csCustomPaint in ControlState) then
      postmessage(Handle,CM_INVALIDATE,0,0);   }


      FDisp:=GetDisplayRect;
      FOld:=FCutRect;

      dec(FOld.left,ScrollLeft div CNT_JL_SCALEVALUES[Scale]);
      dec(FOld.top,ScrollTop div CNT_JL_SCALEVALUES[Scale]);

      dec(FOld.right,ScrollLeft div CNT_JL_SCALEVALUES[Scale]);
      dec(FOld.bottom,ScrollTop div CNT_JL_SCALEVALUES[Scale]);

      FOld.left:=FOld.left * CNT_JL_Scalevalues[Scale];
      FOld.top:=FOld.top * CNT_JL_Scalevalues[Scale];
      FOld.right:=FOld.right * CNT_JL_Scalevalues[Scale];
      FOld.bottom:=FOld.bottom * CNT_JL_Scalevalues[Scale];

      inc(FOld.left,FDisp.left );
      inc(FOld.right,FDisp.left);
      inc(FOld.top,FDisp.top );
      inc(FOld.bottom,FDisp.top);

      If FOld.Bottom>FDisp.Bottom then
      FOld.Bottom:=FDisp.Bottom;

      If FOld.right>FDisp.Right then
      FOld.right:=FDisp.Right;

      windows.ValidateRect(handle,NIL);
      //windows.InvalidateRect(Handle,@FOld,false);
      postmessage(Handle,CM_INVALIDATE,0,0);

      exit;







      (* Take height for margins *)
      dec(x,FDisp.left);
      dec(y,FDisp.top);

      (* Scaled? Snap to nearest scaled pixel pos *)
      if Scale>1 then
      Begin
        x:=( (x * CNT_JL_SCALEVALUES[Scale]) div CNT_JL_SCALEVALUES[Scale]);
        y:=( (y * CNT_JL_SCALEVALUES[Scale]) div CNT_JL_SCALEVALUES[Scale]);

        x:=x div CNT_JL_SCALEVALUES[Scale];
        y:=y div CNT_JL_SCALEVALUES[scale];
      end;

      (* Add position in picture *)
      //inc(x,ScrollLeft div CNT_JL_SCALEVALUES[Scale]);
      //inc(y,ScrollTop div CNT_JL_SCALEVALUES[Scale]);

      If x<FCutRect.left then
      FCutRect.left:=x else
      if (x+1)>FCutRect.right then
      FCutRect.right:=x+1;

      if y<FCutRect.top then
      FCutRect.top:=y else
      if (y+1)>FCutRect.bottom then
      FCutRect.bottom:=y+1;

      if (x=FToolInfo.tiEnd.X)
      and (y=FToolInfo.tiEnd.y) then
      exit;

      Surface.AdjustToBoundsRect(FCutRect);

      FToolInfo.tiEnd:=Point(x,y);
      FToolInfo.tiTarget:=Surface;
      FToolInfo.tiUndo:=FUndo;
      FTools.Selected.UpdateOperation(FToolInfo);

      If not (csCustomPaint in ControlState) then
      Begin
        FOld:=FCutRect;

        FOld.left:=(FOld.Left + FDisp.left);
        FOld.top:=(FOld.top + FDisp.top);
        FOld.Bottom:=FOld.Bottom + FDisp.top;
        FOld.Right:=FOld.right + FDisp.left;

        FOld.left:=FOld.left * CNT_JL_Scalevalues[Scale];
        FOld.top:=FOld.top * CNT_JL_Scalevalues[Scale];
        FOld.right:=FOld.right * CNT_JL_Scalevalues[Scale];
        FOld.bottom:=FOld.bottom * CNT_JL_Scalevalues[Scale];

        { If not (csCustomPaint in ControlState) then
        windows.InvalidateRect(Handle,@FOld,False);     }
      end;

      If not (csCustomPaint in ControlState) then
      postmessage(Handle,CM_INVALIDATE,0,0);
    end;
  end;

  Procedure TJLCustomRasterEditor.MouseUp(Button:TMouseButton;
            Shift:TShiftState;X,Y:Integer);
  var
    FRect:  TRect;
    wd,hd:  Integer;
  Begin
    If FBusy then
    Begin
      FBusy:=False;

      FRect:=GetDisplayRect;

      dec(x,FRect.left);
      dec(y,FRect.top);

      x:=(x * CNT_JL_SCALEVALUES[Scale]) div CNT_JL_SCALEVALUES[Scale];
      y:=(y * CNT_JL_SCALEVALUES[Scale]) div CNT_JL_SCALEVALUES[Scale];

      x:=x div CNT_JL_SCALEVALUES[Scale];
      y:=y div CNT_JL_SCALEVALUES[scale];

      inc(x,ScrollLeft div CNT_JL_SCALEVALUES[Scale]);
      inc(y,ScrollTop div CNT_JL_SCALEVALUES[Scale]);

      FToolInfo.tiEnd:=Point(x,y);
      FToolInfo.tiTarget:=Surface;
      FToolInfo.tiUndo:=FUndo;
      FToolInfo.tiBrush:=FBrushes.Selected;
      FTools.Selected.EndOperation(FToolInfo);

      wd:=JL_RectWidth(FCutRect) + 1;
      hd:=JL_RectHeight(FCutRect)+ 1;
      bitblt(Surface.DC,FCutRect.left,FCutRect.top,wd,hd,
      FUndo.dc,FCutRect.left,FCutRect.top,srccopy);

      If not (csCustomPaint in ControlState) then
      postmessage(Handle,CM_INVALIDATE,0,0);
    end;
    inherited;
  end;
  
  Procedure TJLCustomRasterEditor.PaintVRuler(Const ACanvas:TCanvas;ARect:TRect);
  var
    y:      Integer;
    dy:     Integer;
    Fourth: Integer;
    FSkip:  Integer;
    FText:  String;
    FOrigo: Integer;
    yp:     Integer;
    z:      Integer;
    hd:     Integer;
  Begin
    FSkip:=1;
    Fourth:=(ARect.right-ARect.left) div 4;

    ACanvas.brush.Color:=clWhite;
    ACanvas.FillRect(ARect);

    ACanvas.pen.Color:=clBtnShadow;
    ACanvas.MoveTo(ARect.right,ARect.top);
    ACanvas.LineTo(ARect.right,ARect.bottom);

    ACanvas.pen.Color:=clBtnShadow;
    ACanvas.MoveTo(ARect.left,ARect.bottom);
    ACanvas.LineTo(ARect.right,ARect.bottom);

    ACanvas.pen.color:=clBtnShadow;

    y:=ARect.top - ( (Scrolltop div CNT_JL_SCALEVALUES[Scale])
    * CNT_JL_SCALEVALUES[Scale]);

    FOrigo:=y;

    while y<JL_RectHeight(ARect) do
    Begin
      FSkip:=1-FSkip;

      inc(y,CNT_JL_SCALEVALUES[Scale] * CNT_JL_RULERVALUES[Scale]);
      dy:=y + CNT_JL_SCALEVALUES[Scale] + 1;

      if (dy>ARect.top) and (dy<ARect.bottom) then
      Begin
        FText:=IntToStr( (y - FOrigo) div CNT_JL_SCALEVALUES[Scale]  );
        hd:=ACanvas.TextHeight(FText);
        If length(FText)>0 then
        Begin
          yp:=dy - (hd div 2);
          for z:=1 to length(FText) do
          Begin
            ACanvas.TextOut( (ARect.left + Fourth) - 2,yp,FText[z]);
            inc(yp,hd-1);
          end;
        end;

        if FSkip=1 then
        ACanvas.MoveTo(ARect.right - (Fourth * 2),dy) else
        ACanvas.MoveTo(ARect.right - Fourth,dy);
        ACanvas.LineTo(ARect.right,dy);
      end;
    end;
  end;

  Procedure TJLCustomRasterEditor.Paint;
  var
    FRect:  TRect;
    FTemp:  TRect;
    FClip:  TRect;
    x,y:    Integer;
  Begin
    inherited;

    if (Canvas.Font.Size<>6)
    or (Canvas.font.name<>'verdana') then
    Begin
      Canvas.font.name:='verdana';
      Canvas.font.size:=6;
    end;

    FTemp:=ClientRect;
    FRect:=FTemp;
    FRect.Bottom:=FRect.top + CNT_JL_RULERSIZE;
    inc(FRect.left,CNT_JL_RULERSIZE);
    FClip:=FRect;
    inc(FClip.Bottom);
    if JL_SetClipRect(Canvas.Handle,FClip) then
    Begin
      PaintHRuler(Canvas,FRect);
      JL_RemoveClipRect(Canvas.Handle);
    end;

    FRect:=FTemp;
    FRect.right:=FRect.left + CNT_JL_RULERSIZE;
    inc(FRect.top,CNT_JL_RULERSIZE);
    FClip:=FRect;
    inc(FClip.right);
    if JL_SetClipRect(Canvas.Handle,FClip) then
    Begin
      PaintVRuler(Canvas,FRect);
      JL_RemoveClipRect(Canvas.Handle);
    end;

    FRect:=FTemp;
    FRect.Right:=FRect.left + CNT_JL_RULERSIZE;
    FRect.bottom:=FRect.top + CNT_JL_RULERSIZE;
    Canvas.brush.color:=clWhite;
    Canvas.brush.style:=bsSolid;
    Canvas.fillrect(FRect);

    Canvas.pen.color:=RGB($AA,$AA,$AA);
    Canvas.MoveTo(FRect.right,FRect.top);
    Canvas.LineTo(FRect.right,FRect.Bottom);

    Canvas.MoveTo(FRect.left,FRect.bottom);
    Canvas.LineTo(Frect.right,FRect.bottom);


    If Scale>2 then
    Begin
      Canvas.pen.color:=clBlack;
      FRect:=GetDisplayRect;
      y:=FRect.top + CNT_JL_SCALEVALUES[Scale];
      while y<FRect.bottom do
      Begin
        Canvas.MoveTo(FRect.left,y);
        Canvas.LineTo(FRect.right,y);
        inc(y,CNT_JL_SCALEVALUES[Scale]);
      end;

      x:=FRect.left + CNT_JL_SCALEVALUES[Scale];
      while x<FRect.right do
      Begin
        canvas.moveTo(x,FRect.top);
        canvas.lineto(x,FRect.bottom);
        inc(x,CNT_JL_SCALEVALUES[Scale]);
      end;
    end;

    if FBusy then
    Begin
      FTemp:=GetDisplayRect;

      FRect:=FCutRect;

      dec(FRect.left,ScrollLeft div CNT_JL_SCALEVALUES[Scale]);
      dec(FRect.top,ScrollTop div CNT_JL_SCALEVALUES[Scale]);

      dec(FRect.right,ScrollLeft div CNT_JL_SCALEVALUES[Scale]);
      dec(FRect.bottom,ScrollTop div CNT_JL_SCALEVALUES[Scale]);

      FRect.left:=FRect.left * CNT_JL_Scalevalues[Scale];
      FRect.top:=FRect.top * CNT_JL_Scalevalues[Scale];
      FRect.right:=FRect.right * CNT_JL_Scalevalues[Scale];
      FRect.bottom:=FRect.bottom * CNT_JL_Scalevalues[Scale];

      inc(FRect.left,FTemp.left );
      inc(FRect.right,FTemp.left);
      inc(FRect.top,FTemp.top );
      inc(FRect.bottom,FTemp.top);

      If FRect.Bottom>FTemp.Bottom then
      FRect.Bottom:=FTemp.Bottom;

      If FRect.right>FTemp.Right then
      FRect.right:=FTemp.Right;

      canvas.brush.style:=bsClear;
      Canvas.Pen.Color:=clRed;
      Canvas.Rectangle(FRect);
    end;

    If assigned(FOnPaint) then
    Begin
      FRect:=ClientRect;
      inc(FRect.left,CNT_JL_RULERSIZE + 1);
      inc(FRect.top,CNT_JL_RULERSIZE + 1);
      FOnPaint(self,Canvas,FRect);
    end;

  end;


  end.
