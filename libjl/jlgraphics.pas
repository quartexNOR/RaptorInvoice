  unit jlgraphics;

  {$I 'jldefs.inc'}

  interface

  uses windows, sysutils, classes, math, graphics, 
  jlcommon, jlraster, jldisplay;

  type

  TJLDIBSurface = Class(TJLDIBRaster)
  Private
    FTarget:    TJLCustomRasterViewer;
    Procedure   SetTarget(Value:TJLCustomRasterViewer);
  Protected
    Procedure   SignalAfterAlloc;override;
    Procedure   SignalBeforeRelease;override;
    procedure   SignalUpdateEnds;override;
    Procedure   Notification(AComponent:TComponent;
                Operation:TOperation);override;
  Public
    Procedure   Loaded;Override;
  Published
    Property    Target:TJLCustomRasterViewer
                read FTarget write SetTarget;
    Property    TransparentColor;
    Property    Transparent;
  Published
    Property    OnBeforeAllocate;
    Property    OnAfterAlloc;
    Property    OnBeforeRelease;
    Property    OnAfterRelease;
    Property    OnPalColorChanged;
    Property    OnUpdateBegins;
    Property    OnUpdateEnds;
  End;

  TJLUNISurface = Class(TJLUNIRaster)
  Private
    FTarget:    TJLCustomRasterViewer;
    Procedure   SetTarget(Value:TJLCustomRasterViewer);
  Protected
    Procedure   SignalAfterAlloc;override;
    Procedure   SignalBeforeRelease;override;
    procedure   SignalUpdateEnds;override;
    Procedure   Notification(AComponent:TComponent;
                Operation:TOperation);override;
  Public
    Procedure   Loaded;Override;
  Published
    Property    Target:TJLCustomRasterViewer
                read FTarget write SetTarget;
  Published
    Property    TransparentColor;
    Property    Transparent;
  Published
    Property    OnBeforeAllocate;
    Property    OnAfterAlloc;
    Property    OnBeforeRelease;
    Property    OnAfterRelease;
    Property    OnPalColorChanged;
    Property    OnUpdateBegins;
    Property    OnUpdateEnds;
  End;


  implementation

  //###########################################################################
  // TJLUNISurface
  //###########################################################################

  Procedure TJLUNISurface.Loaded;
  Begin
    inherited;
    if assigned(FTarget) then
    SignalAfterAlloc;
  end;

  Procedure TJLUNISurface.Notification(AComponent:TComponent;
            Operation:TOperation);
  begin
    inherited;
    If (AComponent is TJLCustomRasterViewer) then
    Begin
      Case Operation of
      opInsert: SetTarget(TJLCustomRasterViewer(AComponent));
      opRemove: SetTarget(NIL);
      end;
    end;
  end;

  Procedure TJLUNISurface.SetTarget(Value:TJLCustomRasterViewer);
  Begin
    If Value<>FTarget then
    Begin
      If FTarget<>NIL then
      Begin
        FTarget.RemoveFreeNotification(self);
        FTarget:=NIL;
      end;

      If Value<>NIl then
      Begin
        FTarget:=Value;
        FTarget.FreeNotification(self);

        if not (csLoading in ComponentState)
        and not Empty then
        SignalAfterAlloc;
      end;
    end;
  end;

  Procedure TJLUNISurface.SignalAfterAlloc;
  Begin
    inherited;
  end;

  Procedure TJLUNISurface.SignalBeforeRelease;
  Begin
    inherited;
  end;

  procedure TJLUNISurface.SignalUpdateEnds;
  Begin
    inherited;
    { If not (csDestroying in ComponentState) then
    SignalClients(gcUpdate);       }
  end;

  //###########################################################################
  // TJLDIBSurface
  //###########################################################################

  Procedure TJLDIBSurface.Loaded;
  Begin
    inherited;
    if not Empty then
    Begin
      If self.PaletteAllocated then
      self.UpdatePalette;

      if assigned(FTarget) then
      SignalAfterAlloc;
    end;
  end;

  Procedure TJLDIBSurface.Notification(AComponent:TComponent;
            Operation:TOperation);
  begin
    inherited;
    If (AComponent is TJLCustomRasterViewer) then
    Begin
      Case Operation of
      opInsert: SetTarget(TJLCustomRasterViewer(AComponent));
      opRemove: SetTarget(NIL);
      end;
    end;
  end;

  Procedure TJLDIBSurface.SetTarget(Value:TJLCustomRasterViewer);
  Begin
    If Value<>FTarget then
    Begin
      If FTarget<>NIL then
      Begin
        if not (csDestroying in ComponentState) then
        SignalBeforeRelease;
        FTarget.RemoveFreeNotification(self);
        FTarget:=NIL;
      end;

      If Value<>NIl then
      Begin
        FTarget:=Value;
        FTarget.FreeNotification(self);
        if not (csLoading in ComponentState)
        and not Empty then
        SignalAfterAlloc;
      end;
    end;
  end;
  
  Procedure TJLDIBSurface.SignalAfterAlloc;
  Begin
    inherited;
    If not (csDestroying in ComponentState)
    and (FTarget<>NIL) then
    (FTarget as IJLGraphicClient).gcRasterReady(self);
  end;

  Procedure TJLDIBSurface.SignalBeforeRelease;
  Begin
    inherited;
    If not (csDestroying in ComponentState)
    and (FTarget<>NIL) then
    (FTarget as IJLGraphicClient).gcRasterLost;
  end;

  procedure TJLDIBSurface.SignalUpdateEnds;
  Begin
    inherited;
    If not (csDestroying in ComponentState)
    and (FTarget<>NIL) then
    (FTarget as IJLGraphicClient).gcRasterUpdated;
  end;



  end.
