  unit jlnavigator;

  interface

  uses sysutils, classes, math, jlcommon;

  type

  TJLCustomNavigator = Class(TComponent)
  Private
    FIndex:     Integer;
    FTotal:     Integer;
    FPageSize:  Integer;
    FOnMove:    TNotifyEvent;
    FOnDefine:  TNotifyEvent;
    FOnReset:   TNotifyEvent;
  Protected
    Procedure   DoSetPageSize(Value:Integer);
    Function    DoGetPageSize:Integer;
    Function    DoGetCurrentPage:Integer;
    Function    DoGetPageCount:Integer;
    Function    DoGetIndex:Integer;
    Function    DoGetTotal:Integer;
    Procedure   DoSetIndex(Value:Integer);
    Procedure   DoSetTotal(Value:Integer);
    Procedure   InternalNavigate(Value:Integer);virtual;
    Procedure   InternalSetIndex(Value:Integer);Virtual;
  Public
    Function    Empty:Boolean;
    Function    BOF:Boolean;
    Function    EOF:Boolean;
    Function    Next:Boolean;
    Function    Previous:Boolean;
    Function    First:Boolean;
    Function    Last:Boolean;
    Function    GetIndexOfPage(PageNr:Integer):Integer;
    Function    NextPage:Boolean;
    Function    PrevPage:Boolean;
    Function    LastPage:Boolean;
    Function    FirstPage:Boolean;
    Procedure   Scale(Value:Integer);
    Procedure   Reset;
  Public
    Property    OnNavigate:TNotifyEvent read FOnMove write FOnMove;
    Property    OnChange:TNotifyEvent read FOnDefine write FOnDefine;
    Property    OnReset:TNotifyEvent read FOnReset write FOnReset;
  End;

  TJLItemNavigator = Class(TJLCustomNavigator)
  Public
    Property    PageCount:Integer read DoGetPageCount;
    Property    CurrentPage:Integer read DoGetCurrentPage;
  Published
    Property    Total:Integer read DoGetTotal write DoSetTotal;
    Property    Current:Integer read DoGetIndex write DoSetIndex;
    Property    PageSize:Integer read DoGetPageSize write DoSetPageSize;
    Property    OnNavigate;
    Property    OnChange;
    Property    OnReset;
  End;

  implementation

  Procedure TJLCustomNavigator.Reset;
  Begin
    If not Empty then
    Begin
      FPageSize:=0;
      FTotal:=-1;
      FIndex:=0;
      if assigned(FOnReset) then
      FOnReset(self);
    end;
  end;

  Procedure TJLCustomNavigator.InternalSetIndex(Value:Integer);
  Begin
    If not Empty then
    Begin
      If Value < FIndex then
      InternalNavigate( -(FIndex-Value) ) else

      If Value > FIndex then
      InternalNavigate( (Value-FIndex) );
    end;
  end;

  Procedure TJLCustomNavigator.InternalNavigate(Value:Integer);
  var
    FNewIndex:  Integer;
  Begin
    If Value<0 then
    Begin
      FNewIndex:=FIndex - JL_IntPositive(Value);
      If FNewIndex<>FIndex then
      Begin
        FIndex:=FNewIndex;
        if assigned(FOnMove) then
        FOnMove(self);
      end;
    end else

    If Value>0 then
    Begin
      FNewIndex:= FIndex + Value;
      If FNewIndex<>FIndex then
      Begin
        FIndex:=FNewIndex;
        if assigned(FOnMove) then
        FOnMove(self);
      end;
    end;
  end;

  Procedure TJLCustomNavigator.DoSetIndex(Value:Integer);
  Begin
    If  (Empty=False)
    and (Value<>FIndex) then
    InternalSetIndex(EnsureRange(Value,0,FTotal-1));
  end;

  Function TJLCustomNavigator.DoGetIndex:Integer;
  Begin
    result:=FIndex;
  end;

  Function TJLCustomNavigator.DoGetTotal:Integer;
  Begin
    result:=FTotal;
  end;

  Procedure TJLCustomNavigator.DoSetTotal(Value:Integer);
  Begin
    (* reset current *)
    If not Empty then
    Reset;

    If Value>0 then
    Begin
      FTotal:=Value;
      if assigned(FOnDefine) then
      FOnDefine(self);
    end;
  end;

  Function TJLCustomNavigator.GetIndexOfPage(PageNr:Integer):Integer;
  Begin
    If (PageNr>=0) and (PageNr<DoGetPageCount) then
    Begin
      If PageNR>0 then
      result:=(FPageSize * PageNr) -1 else
      result:=0;
    end else
    Begin
      if not Empty then
      result:=0 else
      result:=-1;
    end;
  end;

  Function TJLCustomNavigator.NextPage:Boolean;
  Begin
    result:=(Empty=False) and (FPageSize>0);
    If result then
    DoSetIndex(GetIndexOfPage(DoGetCurrentPage+1));
  end;

  Function TJLCustomNavigator.PrevPage:Boolean;
  Begin
    result:=(Empty=False) and (FPageSize>0);
    If result then
    DoSetIndex(GetIndexOfPage(DoGetCurrentPage-1));
  end;

  Function TJLCustomNavigator.LastPage:Boolean;
  Begin
    result:=(Empty=False) and (FPageSize>0);
    If result then
    DoSetIndex(GetIndexOfPage(DoGetPageCount-1));
  end;

  Function TJLCustomNavigator.FirstPage:Boolean;
  Begin
    result:=(Empty=False) and (FPageSize>0);
    If result then
    DoSetIndex(0);
  end;
  
  Function TJLCustomNavigator.DoGetCurrentPage:Integer;
  Begin
    if  (FTotal>0)
    and (FPageSize>0)
    and (FIndex>0) then
    Result:=FIndex+1 div FPageSize else
    result:=0;
  end;

  Function TJLCustomNavigator.DoGetPageCount:Integer;
  Begin
    if  (FTotal>0)
    and (FPageSize>0) then
    result:=FTotal+1 div FPageSize else
    result:=0;
  end;
  
  Function TJLCustomNavigator.DoGetPageSize:Integer;
  Begin
    result:=FPageSize;
  end;
  
  Procedure TJLCustomNavigator.DoSetPageSize(Value:Integer);
  Begin
    FPageSize:=math.EnsureRange(Value,0,FTotal-1)
  end;

  Function TJLCustomNavigator.Empty:Boolean;
  Begin
    Result:=FTotal<1;
  end;

  Function TJLCustomNavigator.BOF:Boolean;
  Begin
    Result:=FIndex=0;
  end;

  Function TJLCustomNavigator.EOF:Boolean;
  Begin
    result:=FIndex>FTotal-1;
  end;

  Function TJLCustomNavigator.Next:Boolean;
  Begin
    Result:=(Empty=False) and (EOF=False);
    if result then
    InternalSetIndex(FIndex + 1);
  end;

  Function TJLCustomNavigator.Previous:Boolean;
  Begin
    Result:=(Empty=False) and (BOF=False);
    if result then
    InternalSetIndex(FIndex - 1);
  end;

  Function TJLCustomNavigator.First:Boolean;
  Begin
    result:=Empty=False;
    If result then
    InternalSetIndex(0);
  end;

  Function TJLCustomNavigator.Last:Boolean;
  Begin
    result:=not Empty;
    If result then
    InternalSetIndex(FTotal-1);
  end;

  Procedure TJLCustomNavigator.Scale(Value:Integer);
  Begin
    If not Empty then
    Begin
      If Value>0 then
      inc(FTotal,Value) else

      If Value<0 then
      Begin
        If ( FTotal-JL_IntPositive(Value) ) < 1 then
        Reset else
        Begin
          FTotal:=FTotal-JL_IntPositive(Value);

          If FTotal<FPageSize then
          FPageSize:=FTotal-1;

          If FIndex>FTotal-1 then
          Begin
            FIndex:=FTotal;
            InternalNavigate(-1);
          end;
        end;
      end;

    end else
    If Value>0 then
    DoSetTotal(Value);
  end;

  end.
