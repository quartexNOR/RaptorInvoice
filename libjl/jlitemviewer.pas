  unit jlitemviewer;

  {$I 'jldefs.inc'}

  interface

  uses jlcommon, jlraster, jlscrollctrl,
  sysutils, classes, math,
  windows, forms, graphics, controls, messages;

  type


  TJLItemViewerOptions = set of
    (boShowHeader,boShowItemFrame,boShowHeaderFrame,
    boMouseMultiselect,boKeyMultiSelect);

  TJLItemViewerPaintItemEvent = Procedure
    (Sender:TObject;Canvas:TCanvas;
    Index:Integer;ARect:TRect;Selected:Boolean) of Object;

  TJLItemViewerPaintHeaderEvent = Procedure (Sender:TObject;Canvas:TCanvas;
  ARect:TRect) of Object;

  TJLItemViewerPaintBackgroundEvent = Procedure
  (Sender:TObject;Canvas:TCanvas;ARect:TRect) of Object;

  TJLItemViewerEnableChangedEvent = Procedure
  (Sender:TObject;OldValue:Boolean;NewValue:Boolean) of Object;

  TJLItemViewerItemsSetEvent = Procedure
  (Sender:TObject;NewItemCount:Integer) of Object;

  TJLItemViewerItemsClearEvent = Procedure
  (Sender:TObject) of Object;

  TJLItemViewerItemEnterEvent = procedure
  (Sender:TObject;ItemIndex:Integer) of Object;

  TJLItemViewerItemLeaveEvent = procedure
  (Sender:TObject;ItemIndex:Integer) of Object;

  TJLCustomItemViewer = Class(TJLScrollbarControl)
  Private
    FItems:       Integer;
    FItemWidth:   Integer;
    FItemHeight:  Integer;
    FSelected:    TIntArray;
    FShowing:     TIntArray;
    FObjects:     TPtrArray;
    FSpacing:     Integer;

    FInside:      Boolean;
    FInsideId:    Integer;
    FHeadSize:    Integer;
    FItemIndex:   Integer;
    FOnEnter:     TJLItemViewerItemEnterEvent;
    FOnLeave:     TJLItemViewerItemLeaveEvent;
    FOnPaintItem: TJLItemViewerPaintItemEvent;
    FOnPaintBg:   TJLItemViewerPaintBackgroundEvent;
    FOnEnable:    TJLItemViewerEnableChangedEvent;
    FOnSetItems:  TJLItemViewerItemsSetEvent;
    FOnClear:     TJLItemViewerItemsClearEvent;

    FOnPaintHead: TJLItemViewerPaintHeaderEvent;
    FOptions:     TJLItemViewerOptions;
    FMsStart:     TPoint;
    FMsStop:      TPoint;
    FMsActive:    Boolean;

    Procedure     SetOptions(Const Value:TJLItemViewerOptions);
    Procedure     SetItemCount(Value:Integer);
    procedure     SetItemWidth(Const Value:Integer);
    Procedure     SetItemHeight(Const Value:Integer);
    Procedure     SetHeaderSize(Const Value:Integer);
    Procedure     SetSpacing(Const Value:Integer);
    Procedure     ReCalcDisplay;
    Function      GetHeaderSize:Integer;
    Function      GetSelCount:Integer;
    Function      GetSelItem(Const Index:Integer):Integer;
    Procedure     SetItemIndex(Const Value:Integer);

    Function      GetData(Const Index:Integer):Pointer;
    procedure     SetData(Const Index:Integer;Const Value:Pointer);

  Private
    procedure     CMEnabledChanged(var Message: TMessage);
                  message CM_ENABLEDCHANGED;
    procedure     CMMouseEnter(var msg: TMessage);
                  Message CM_MOUSEENTER;
    procedure     CMMouseLeave(var msg: TMessage);
                  message CM_MOUSELEAVE;
  Protected
    Procedure     UpdateScrollPosition;Override;
    Procedure     InternalReset;
    Procedure     SetEnabled(Value:Boolean);Override;
  Protected
    Procedure     RemoveFromSelection(Const Index:Integer);
    Procedure     AddToSelection(Const Index:Integer);
    Function      GetItemSelected(Const Index:Integer):Boolean;

    Function      GetTopRow:Integer;
    Function      GetRowCount:Integer;
    Function      GetColCount:Integer;
    Function      GetItemCol(Index:Integer):Integer;
    Function      GetItemRow(Index:Integer):Integer;
    Function      GetItemRect(Index:Integer):TRect;
    Function      GetRowStart(RowIndex:Integer):Integer;
    Procedure     PaintHeader(ARect:TRect);
    Procedure     PaintItem(Const Index:Integer;
                  ARect:TRect;Selected:Boolean);virtual;
    Function      GetItemVisible(Index:Integer):Boolean;
    Procedure     Paint;Override;
    Procedure     ReSize;Override;
    Procedure     MouseDown(Button:TMouseButton;
                  Shift:TShiftState;X,Y:Integer);Override;
    Procedure     MouseMove(Shift:TShiftState;X,Y:Integer);override;
    Procedure     MouseUp(Button:TMouseButton;
                  Shift:TShiftState;X,Y:Integer);Override;
  Public
    Procedure     Clear;
    Procedure     SelectAll;
    procedure     SelectNone;

    Property      SelectedCount:Integer read GetSelCount;
    Property      Selected[Const index:Integer]:Integer read GetSelItem;
    Function      IsItemSelected(Const Index:Integer):Boolean;

    Property      Data[Const Index:Integer]:Pointer
                  read GetData write SetData;

    Procedure     Loaded;override;
    Procedure     BeforeDestruction;Override;
    Constructor   Create(AOwner:TComponent);Override;
  Protected
    Property      ItemSpacing:Integer read FSpacing write SetSpacing;
    Property      ItemIndex:Integer read FItemIndex write SetItemIndex;

    Property      OnPaintHeader:TJLItemViewerPaintHeaderEvent
                  read FOnPaintHead Write FOnPaintHead;
    Property      OnItemEnter:TJLItemViewerItemEnterEvent
                  read FOnEnter write FOnEnter;
    Property      OnItemLeave:TJLItemViewerItemLeaveEvent
                  read FOnLeave write FOnLeave;

    Property      OnItemsSet:TJLItemViewerItemsSetEvent
                  read FOnSetItems write FOnSetItems;

    Property      OnItemsClear:TJLItemViewerItemsClearEvent
                  read FOnClear write FOnClear;

    Property      OnEnableChange:TJLItemViewerEnableChangedEvent
                  read FOnEnable write FOnEnable;
    Property      OnPaint:TJLItemViewerPaintBackgroundEvent
                  Read FOnPaintBg write FOnPaintBg;
    Property      OnPaintItem:TJLItemViewerPaintItemEvent
                  Read FOnPaintItem write FOnPaintItem;

    Property      ItemCount:Integer read FItems write SetItemCount;
    Property      ItemWidth:Integer read FItemWidth write SetItemWidth;
    Property      ItemHeight:Integer read FItemHeight write SetItemHeight;
    Property      HeaderSize:Integer read FHeadSize write SetHeaderSize;
    Property      Options:TJLItemViewerOptions
                  read FOptions write SetOptions;
  End;

  TJLItemViewer = Class(TJLCustomItemViewer)
  Public
    property  DockManager;
    Property  SelectedCount;
    Property  Selected;
  Published

    property  AutoScroll;
    Property  BorderStyle;
    Property  Increment;
    Property  Tracking;

    Property  ItemIndex;
    Property  ItemCount;
    Property  ItemWidth;
    Property  ItemHeight;
    Property  ItemSpacing;
    Property  HeaderSize;
    Property  Options;

    Property  OnPaintHeader;
    Property  OnItemEnter;
    Property  OnItemLeave;
    Property  OnEnableChange;
    Property  OnPaint;
    Property  OnPaintItem;

    Property  OnItemsSet;
    Property  OnItemsClear;

    property  Align;
    property  Anchors;
    //property  AutoSize;
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


  //###########################################################################
  // TJLCustomItemViewer
  //###########################################################################

  Constructor TJLCustomItemViewer.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    ControlStyle:=ControlStyle - [csAcceptsControls];

    ControlStyle:=ControlStyle + [csClickEvents,csCaptureMouse,
    csNeedsBorderPaint, csSetCaption, csDoubleClicks];

    FItems:=0;
    FItemWidth:=128 + 20;
    FItemHeight:=120 + 20;
    FInside:=False;
    FInsideId:=-1;
    FSpacing:=4;
    FOptions:=[boShowHeader,boShowItemFrame,
    boShowHeaderFrame,boMouseMultiselect,boKeyMultiSelect];
    FHeadSize:=64;
    DoubleBuffered:=true;
    TabStop:=True;
  end;

  Procedure TJLCustomItemViewer.BeforeDestruction;
  Begin
    inherited;
    Clear;
  end;

  Procedure TJLCustomItemViewer.Loaded;
  Begin
    inherited;

    If (FItems>0)
    and Assigned(FOnSetItems) then
    FOnSetItems(self,FItems);

    If HandleAllocated then
    invalidate;
  end;

  Procedure TJLCustomItemViewer.SetSpacing(Const Value:Integer);
  Begin
    if Value<>FSpacing then
    Begin
      FSpacing:=Math.EnsureRange(Value,4,1024);
      if not (csLoading in ComponentState)
      and HandleAllocated then
      Begin
        ReCalcDisplay;
        Invalidate;
      end;
    end;
  end;
  
  Procedure TJLCustomItemViewer.SetHeaderSize(Const Value:Integer);
  Begin
    If Value<>FHeadSize then
    Begin
      FHeadSize:=Math.EnsureRange(Value,0,1024);
      If  (boShowHeader in FOptions)
      and HandleAllocated then
      Begin
        ReCalcDisplay;
        Invalidate;
      end;
    end;
  end;

  Procedure TJLCustomItemViewer.SetOptions
            (Const Value:TJLItemViewerOptions);
  Begin
    If Value<>FOptions then
    Begin
      FOptions:=Value;
      ReCalcDisplay;
      Invalidate;
    end;
  end;

  Procedure TJLCustomItemViewer.SetItemIndex(Const Value:Integer);
  Begin
    If (FItems>0) and (Value<>FItemIndex) then
    Begin
      If (Value>=0) and (Value<FItems) then
      Begin
        FItemIndex:=Value;
        SetLength(FSelected,0);
        AddToSelection(FItemIndex);
        If HandleAllocated then
        invalidate;
      end;
    end;
  end;

  Procedure TJLCustomItemViewer.SetEnabled(Value:Boolean);
  var
    FOld: Boolean;
  Begin
    FOld:=GetEnabled;
    inherited SetEnabled(Value);
    If FOld<>Enabled then
    Begin

      If Enabled=False then
      DisableScrollbars else
      EnableScrollbars;

      If HandleAllocated and Visible then
      invalidate;

      If assigned(FOnEnable) then
      FOnEnable(self,FOld,Enabled);

    end;
  end;

  procedure TJLCustomItemViewer.CMEnabledChanged(var Message: TMessage);
  Begin
    inherited;
  end;

  Procedure TJLCustomItemViewer.InternalReset;
  Begin

    If not (csLoading in ComponentState) then
    Begin
      If assigned(FOnClear) then
      FOnClear(self);
    end;

    FItems:=0;
    SetLength(FSelected,0);
    setlength(FShowing,0);
    SetLength(FObjects,0);
    SetScrollBounds(0,0,0,0);
    FInside:=False;
    FInsideId:=-1;

    If not (csLoading in ComponentState) then
    Invalidate;
  end;

  Procedure TJLCustomItemViewer.Clear;
  Begin
    InternalReset;
  end;

  Procedure TJLCustomItemViewer.SelectAll;
  var
    x:  Integer;
  Begin
    if FItems>0 then
    Begin
      Setlength(FSelected,FItems);
      for x:=1 to FItems do
      FSelected[x-1]:=x-1;
      invalidate;
    end;
  end;

  procedure TJLCustomItemViewer.SelectNone;
  Begin
    If Length(FSelected)>0 then
    Begin
      SetLength(FSelected,0);
      invalidate;
    end;
  end;

  Function TJLCustomItemViewer.IsItemSelected(Const Index:Integer):Boolean;
  var
    z:  Integer;
  Begin
    If Length(FSelected)>0 then
    Begin
      result:=False;
      for z:=low(FSelected) to high(FSelected) do
      Begin
        result:=FSelected[z]=Index;
        If result then
        Break;
      end;
    end else
    result:=Index=ItemIndex;
  end;

  Function TJLCustomItemViewer.GetSelCount:Integer;
  Begin
    result:=Length(FSelected);
  end;

  Function TJLCustomItemViewer.GetSelItem(Const index:Integer):Integer;
  Begin
    result:=-1;
    If Length(FSelected)>0 then
    Begin
      If  (Index>=Low(FSelected))
      and (Index<=High(FSelected)) then
      Result:=FSelected[index];
    end;
  end;

  Function TJLCustomItemViewer.GetHeaderSize:Integer;
  Begin
    If (boShowHeader in FOptions) then
    result:=FHeadSize else
    result:=0;
  end;

  Procedure TJLCustomItemViewer.ReCalcDisplay;
  var
    FTemp:  Integer;
  Begin
    If FItems>0 then
    Begin
      FTemp:=GetRowCount * FItemHeight;
      inc(FTemp,GetHeaderSize);

      If (ScrollHeight<>FTemp) then
      SetScrollBounds(ScrollLeft,Scrolltop,40,FTemp);
    end else
    Begin
      If ScrollHeight>0 then
      SetScrollBounds(0,0,0,0);
    end;
  end;

  Procedure TJLCustomItemViewer.SetItemCount(Value:Integer);
  Begin
    If Value<>FItems then
    Begin
      If FItems>0 then
      InternalReset;

      FItems:=Math.EnsureRange(Value,0,10000);
      If FItems>0 then
      Begin
        SetLength(FObjects,FItems);

        If not (csLoading in ComponentState) then
        Begin
          if assigned(FOnSetItems) then
          FOnSetItems(self,FItems);
          ReCalcDisplay;
        end;

      end;
    end;
  end;

  Function TJLCustomItemViewer.GetData(Const Index:Integer):Pointer;
  Begin
    if  not (csLoading in ComponentState)
    and not (csDestroying in ComponentState)
    and (index>=Low(FObjects)) and (index<=high(FObjects)) then
    result:=FObjects[index] else
    Raise Exception.CreateFmt('Data index out of bounds error,'
    + 'expected %d..%d not %d',[low(FObjects),high(FObjects),Index]);
  end;

  procedure TJLCustomItemViewer.SetData(Const Index:Integer;Const Value:Pointer);
  Begin
    if  not (csLoading in ComponentState)
    and not (csDestroying in ComponentState)
    and (index>=Low(FObjects)) and (index<=high(FObjects)) then
    FObjects[index]:=Value else
    Raise Exception.CreateFmt('Data index out of bounds error,'
    + 'expected %d..%d not %d',[low(FObjects),high(FObjects),Index]);
  end;

  procedure TJLCustomItemViewer.SetItemWidth(Const Value:Integer);
  Begin
    If Value<>FItemWidth then
    Begin
      FItemWidth:=Math.EnsureRange(Value,10,512);
      Recalcdisplay;
    end;
  end;

  Procedure TJLCustomItemViewer.SetItemHeight(Const Value:Integer);
  Begin
    If Value<>FItemHeight then
    Begin
      FItemHeight:=Math.EnsureRange(Value,8,512);
      Recalcdisplay;
    end;
  end;

  Function TJLCustomItemViewer.GetRowCount:Integer;
  var
    FItemsPrRow:  Integer;
  Begin
    FItemsPrRow:=Math.EnsureRange(ClientWidth div FItemWidth,1,10000);
    result:=FItems div FItemsPrRow;
    If (result * FItemsPrRow)<FItems then
    inc(result);
  end;

  Function TJLCustomItemViewer.GetRowStart(RowIndex:Integer):Integer;
  Begin
    result:=0;
    If  (FItems>0)
    and (RowIndex>=0)
    and (RowIndex<GetRowCount) then
    Result:=(RowIndex * GetColCount) - GetHeaderSize;
  end;

  Function TJLCustomItemViewer.GetItemVisible(Index:Integer):Boolean;
  Begin
    result:=JL_RectWithin(ClientRect,GetItemRect(Index));
  end;

  Function TJLCustomItemViewer.GetColCount:Integer;
  Begin
    Result:=math.EnsureRange(ClientWidth div FItemWidth,1,10000);
  end;

  Function TJLCustomItemViewer.GetItemRow(Index:Integer):Integer;
  var
    FItemsPrRow:  Integer;
  Begin
    result:=0;
    If Index>0 then
    Begin
      If  (ClientWidth>0)
      and (FItemWidth>0) then
      Begin
        FItemsPrRow:=math.EnsureRange(ClientWidth div FItemWidth,1,10000);
        Result:=Index div FItemsPrRow;
      end;
    end;
  end;

  Function TJLCustomItemViewer.GetTopRow:Integer;
  var
    ypos: Integer;
  Begin
    result:=0;
    ypos:=ScrollTop;
    If (FItems>0) and (ypos>0) then
    Begin
      result:=ypos div FItemHeight;
      If (result * FItemHeight) > ScrollTop then
      if result>0 then
      dec(Result);
    end;
  end;

  Function TJLCustomItemViewer.GetItemCol(Index:Integer):Integer;
  var
    FItemsPrRow:  Integer;
  Begin
    result:=0;
    If  (Index>0)
    and (ClientWidth>0)
    and (FItemWidth>0) then
    Begin
      FItemsPrRow:=math.EnsureRange(ClientWidth div FItemWidth,1,10000);
      Result:=Index - (Index div FItemsPrRow) * FItemsPrRow;
    end;
  end;

  Function TJLCustomItemViewer.GetItemRect(Index:Integer):TRect;
  Begin
    If  (FItems>0)
    and (Index>=0)
    and (Index<FItems) then
    Begin
      Result.Left:=GetItemCol(Index) * FItemWidth;
      Result.top:=GetItemRow(index) * FItemHeight;
      Result.Right:=Result.Left + FItemWidth-1;
      Result.Bottom:=Result.top + FItemHeight-1;
      OffsetRect(Result,-ScrollLeft,-ScrollTop);

      If (boShowHeader in FOptions) then
      OffsetRect(Result,0,FHeadSize);

      InflateRect(Result,-FSpacing,-FSpacing);
    end else
    result:=Rect(0,0,0,0);
  end;

  procedure TJLCustomItemViewer.CMMouseEnter(var msg: TMessage);
  Begin
    If not (csDestroying in ComponentState)
    And not (csDesigning in ComponentState)
    and Enabled then
    Begin
    end;
  end;

  procedure TJLCustomItemViewer.CMMouseLeave(var msg: TMessage);
  Begin
    If not (csDestroying in ComponentState)
    And not (csDesigning in ComponentState)
    and Enabled then
    Begin
      If FInside then
      Begin
        If assigned(FOnleave) then
        FOnleave(self,FInsideId);
        FInside:=False;
        FInsideId:=-1;
      end;
    end;
  end;

  Procedure TJLCustomItemViewer.UpdateScrollPosition;
  Begin
  end;

  Procedure TJLCustomItemViewer.ReSize;
  Begin
    inherited;

    ReCalcDisplay;
    invalidate;
  end;

  Procedure TJLCustomItemViewer.PaintHeader(ARect:TRect);
  Begin
    canvas.Pen.color:=clbtnshadow;
    Canvas.Brush.Style:=bsSolid;
    Canvas.brush.color:=Color;

    If (boShowHeaderFrame in FOptions) then
    Begin
      Canvas.MoveTo(ARect.left,ARect.top);
      Canvas.LineTo(ARect.Right,ARect.top);
      Canvas.lineto(ARect.Right,ARect.bottom);
      Canvas.lineto(ARect.left,ARect.bottom);
      Canvas.lineTo(ARect.left,ARect.top);
    end;

    If assigned(FOnPaintHead) then
    FOnPaintHead(self,Canvas,ARect);
  end;

  Procedure TJLCustomItemViewer.PaintItem(Const Index:Integer;
            ARect:TRect;Selected:Boolean);
  Begin

    If not selected then
    Canvas.pen.color:=clBtnShadow else
    Canvas.Pen.Color:=clBtnShadow;

    If (boShowItemFrame in FOptions) then
    Begin
      Canvas.MoveTo(ARect.left,ARect.top);
      Canvas.LineTo(ARect.Right,ARect.top);
      Canvas.lineto(ARect.Right,ARect.bottom);
      Canvas.lineto(ARect.left,ARect.bottom);
      Canvas.lineTo(ARect.left,ARect.top);
    end;

    inc(ARect.left);
    inc(ARect.top);

    Canvas.Brush.Style:=bsClear;
    If Selected then
    Begin
      If Enabled=True then
      Canvas.brush.color:=clHighlight else
      Canvas.Brush.Color:=clbtnshadow;
      Canvas.FillRect(ARect);
    end;

    If assigned(FOnPaintItem) then
    FOnPaintItem(self,Canvas,Index,ARect,Selected);
  end;

  Procedure TJLCustomItemViewer.Paint;
  var
    x:        Integer;
    FRect:    TRect;
    FTopRow:  Integer;

    Function GetHeaderRect:TRect;
    Begin
      Result:=Rect(0,0,clientwidth,GetHeaderSize);
      InflateRect(Result,-FSpacing,-FSpacing);
      OffsetRect(Result,-Round(ScrollLeft),-Round(ScrollTop));
    end;

    Function IsHeaderVisible:Boolean;
    Begin
      result:=JL_RectExpose(GetHeaderRect,ClientRect)<>esNone;
    end;

  Begin
    inherited;

    (* flush background *)
    If Enabled then
    Canvas.Brush.Color:=Color else
    canvas.Brush.Color:=clbtnface;
    canvas.Brush.Style:=bsSolid;

    (* Allow user to paint background further *)
    If assigned(FOnPaintBg) then
    FOnPaintBG(self,Canvas,ClientRect) else
    Canvas.FillRect(ClientRect);

    SetLength(FShowing,0);
    if FItems>0 then
    Begin
      (* Set font if not set *)
      If (Canvas.Font.Name<>Font.Name)
      or (Canvas.Font.Size<>Font.Size)
      or (Canvas.Font.Color<>Font.Color)
      or (Canvas.Font.Style<>Font.Style) then
      Begin
        Canvas.Font.Name:=Font.Name;
        Canvas.Font.Size:=Font.Size;
        Canvas.Font.Color:=Font.Color;
        Canvas.Font.Style:=Font.Style;
      end;

      FTopRow:=GetTopRow;
      FTopRow:=GetRowStart(FTopRow);

      for x:=FTopRow+1 to FItems do
      Begin
        FRect:=GetItemRect(x-1);
        If JL_RectExpose(FRect,ClientRect) in [esPartly,esCompletely] then
        Begin
          jlcommon.JL_IntArrayAdd(FShowing,x-1);
          PaintItem(x-1,FRect,GetItemSelected(x-1));
        end;
        If FRect.top>ClientRect.Bottom then
        break;
      end;

      If FMsActive then
      Begin
        Canvas.pen.Color:=clInactiveCaption;
        Canvas.Brush.Color:=clHighlightText;
        Canvas.pen.Width:=4;
        Canvas.brush.Style:=bsBDiagonal;//bsFDiagonal;
        Canvas.Rectangle(FMsStart.x,FMsStart.y,FMsStop.x,FMsStop.y);
        Canvas.pen.Width:=1;
      end;

      If (boShowHeader in FOptions) then
      Begin
        If IsHeaderVisible then
        PaintHeader(GetHeaderRect);
      end;
    end;

    {If self.Focused then
    Canvas.DrawFocusRect(ClientRect);}
  end;

  Function TJLCustomItemViewer.GetItemSelected(Const Index:Integer):Boolean;
  Begin
    result:=JL_Locate(index,FSelected)>=0;
  end;

  Procedure TJLCustomItemViewer.AddToSelection(Const Index:Integer);
  Begin
    If not GetItemSelected(index) then
    JL_IntArrayAdd(FSelected,Index);
  end;

  Procedure TJLCustomItemViewer.RemoveFromSelection(Const Index:Integer);
  var
    FIndex: Integer;
  Begin
    FIndex:=JL_Locate(index,FSelected);
    If FIndex>=0 then
    JL_IntArrayDelete(FSelected,FIndex);
  end;

  Procedure TJLCustomItemViewer.MouseMove(Shift:TShiftState;X,Y:Integer);
  var
    z:      Integer;
    FRect:  TRect;
    FFound: Boolean;
    FIndex: Integer;
    ARect:  TRect;
    //fx,fy:  Integer;
  Begin
    inherited;
    If  not (csDestroying in ComponentState)
    and not (csLoading in ComponentState)
    and (FItems>0) then
    Begin

      If (boMouseMultiselect in FOptions)
      and FMsActive then
      Begin
        FMsStop.x:=x;
        FMsStop.y:=y;

        ARect:=Rect(FMsStart.x,FMsStart.y,FMsStop.x,FMsStop.y);
        JL_RectRealize(ARect);

        setlength(FSelected,0);
        for z:=Low(FShowing) to high(FShowing) do
        Begin
          FIndex:=FShowing[z];
          FRect:=GetItemRect(FIndex);
          If JL_RectExpose(FRect,ARect)<>esNone then
          AddToSelection(FIndex);
        end;

        //invalidateRect(Handle,@ARect,true);
        invalidate;
        exit;
      end;

      If length(FShowing)>0 then
      Begin
        FFound:=False;
        for z:=low(FShowing) to high(FShowing) do
        Begin
          FRect:=GetItemRect(FShowing[z]);
          If JL_PosInRect(FRect,x,y) then
          Begin
            (* already inside an item? *)
            If FInside then
            Begin
              If FInsideId<>FShowing[z] then
              Begin
                if assigned(FOnLeave) then
                FOnLeave(self,FInsideId);
                FInside:=False;
                FInsideId:=-1;
              end else
              Begin
                FFound:=True;
                Break;
              end;
            end;

            If FInsideId<>FShowing[z] then
            Begin
              FInside:=True;
              FInsideId:=FShowing[z];
              if assigned(FOnEnter) then
              FOnEnter(self,FInsideId);
              FFound:=True;
            end else
            FFound:=True;
            Break;
          end;
        end;

        If  (FFound=False)
        and (FInside=True) then
        Begin
          if assigned(FOnLeave) then
          FOnLeave(self,FInsideId);
          FInside:=False;
          FInsideId:=-1;
        end;
      end;
    end;
  end;

  Procedure TJLCustomItemViewer.MouseDown(Button:TMouseButton;
            Shift:TShiftState;X,Y:Integer);
  var
    FRect:  TRect;
    FIndex: Integer;
    z:      Integer;
    FFound: Boolean;

    FFirst: Integer;
    t:  Integer;
  Begin
    inherited;

    FMsActive:=False;

    if Button<>mbLeft then
    exit;

    { If  not (csDestroying in ComponentState)
    and not (csLoading in ComponentState)
    and not Focused
    and Enabled
    and Visible
    and TabStop
    and showing
    and HasParent
    and (Button=mbLeft)
    and HandleAllocated then
    SetFocus;   }

    if (Button=mbLeft) and (FItems>0)
    and (length(FShowing)>0) then
    Begin
      FFound:=False;
      for z:=Low(FShowing) to high(FShowing) do
      Begin
        FIndex:=FShowing[z];
        FRect:=GetItemRect(FIndex);
        If JL_PosInRect(FRect,x,y) then
        Begin

          If  (ssShift in Shift)
          and (boKeyMultiSelect in FOptions)
          and (Length(FSelected)>0) then
          Begin
            FFirst:=1000000;
            for t:=Low(FSelected) to high(FSelected) do
            Begin
              If FSelected[t]<FFirst then
              FFirst:=FSelected[t];
            end;

            If FFirst>FIndex then
            Begin
              FFound:=True;
              SetLength(FSelected,0);
              for t:=FIndex to FFirst do
              AddToSelection(t);
            end else

            If FIndex>FFirst then
            Begin
              FFound:=True;
              SetLength(FSelected,0);
              for t:=FFirst to FIndex do
              AddToSelection(t);
            end else

            If FIndex=FFirst then
            Begin
              FFound:=True;
              SetLength(FSelected,0);
              AddToSelection(FIndex);
            end;

            Break;
          end;

          If  (ssCtrl in Shift)
          and (boKeyMultiselect in FOptions) then
          Begin
            If GetItemSelected(FIndex) then
            RemoveFromSelection(FIndex) else
            AddToSelection(FIndex);
            FItemIndex:=FIndex;
            FFound:=True;
          end else
          Begin
            SetLength(FSelected,0);
            AddToSelection(FIndex);
            FItemIndex:=FIndex;
            FFound:=True;
            Break;
          end;
        end;
      end;

      If not FFound then
      Begin
        SetLength(FSelected,0);
        FItemIndex:=-1;
        FMsStart.x:=x;
        FMsStart.y:=y;
        FMsStop:=FMsStart;
        FMsActive:=True;
      end;

      Invalidate;
    end;
  end;

  Procedure TJLCustomItemViewer.MouseUp(Button:TMouseButton;
            Shift:TShiftState;X,Y:Integer);
  Begin
    inherited;
    if FMsActive then
    Begin
      FMsActive:=False;
      invalidate;
    end;
  end;



  end.
