  unit jlbitbuffer;

  interface

  uses sysutils, classes, math, jlcommon, jldatabuffer, jlnavigator;

  type

  EJlBitBuffer  = Class(EJLException);

  TJLBitBuffer = Class(TJLCommonObject)
  Private
    FData:      Pointer;
    FDataLng:   Integer;
    FDataLen:   Integer;
    FBitsMax:   Longword;
    FReadyByte: Longword;
    FAddr:      PByte;
    BitOfs:     0..255;
    FByte:      Byte;
    Function    GetByte(Const Index:Integer):Byte;
    Procedure   SetByte(Const Index:Integer;Const Value:Byte);
    Function    GetBit(Const Index:Longword):Boolean;
    Procedure   SetBit(Const Index:Longword;Const Value:Boolean);
  Protected
    Function    ObjectHasData:Boolean;override;
    Procedure   BeforeReadObject;Override;
    procedure   ReadObject(Const Reader:TJLReader);override;
    procedure   WriteObject(Const Writer:TJLWriter);override;
  Public
    Property    Data:Pointer read FData;
    Property    Size:Integer read FDataLen;
    Property    Count:Longword read FBitsMax;
    Property    Bytes[Const Index:Integer]:Byte
                Read GetByte write SetByte;
    Property    Bits[Const Index:Longword]:Boolean
                Read GetBit write SetBit;default;

    Procedure   Allocate(MaxBits:Integer);
    Procedure   Release;
    Function    Empty:Boolean;
    Procedure   Zero;
    Function    toString(Restriction:Integer=CNT_JL_MAXSTRING):AnsiString;
    Procedure   SetBitRange(First,Last:Longword;
                Const Bitvalue:Boolean);
    Procedure   SetBits(Const Value:TLongArray;
                Const BitValue:Boolean);
    Function    FindIdleBit(var Value:Longword;
                Const FromStart:Boolean=False):Boolean;
    Destructor  Destroy;Override;
  End;

  implementation

  ResourceString
  ERR_JLBitBuffer_InvalidBitIndex  =
  'Invalid bit index, expected 0..%d not %d';

  ERR_JLBitBuffer_InvalidByteIndex =
  'Invalid byte index, expected 0..%d not %d';

  ERR_JLBitBuffer_BitBufferEmpty =
  'Bitbuffer is empty error';

  //##########################################################################
  // TSRLBitBuffer
  //##########################################################################

  Destructor TJLBitBuffer.Destroy;
  Begin
    If not Empty then
    Release;
    inherited;
  end;

  Function TJLBitBuffer.toString
           (Restriction:Integer=CNT_JL_MAXSTRING):AnsiString;
  var
    x:        Integer;
    FTemp:    AnsiString;
    FElements:TJLItemNavigator;
    FOffset:  Integer;
    FCount:   Integer;
  Begin
    Result:='';
    FCount:=Count;
    If  (Restriction>0)
    and (FCount>0) then
    Begin
      Restriction:=math.EnsureRange(Restriction,1,FCount);
      FElements:=TJLItemNavigator.Create(NIL);
      try
        FElements.Total:=FCount;
        FElements.PageSize:=64;
        FElements.First;
        Repeat
          FTemp:='';
          FOffset:=FElements.GetIndexOfPage(FElements.CurrentPage);
          for x:=1 to FElements.PageSize do
          Begin
            If GetBit(FOffset) then
            FTemp:=FTemp + '1' else
            FTemp:=FTemp + '0';
            inc(FOffset);
          end;
          If not FElements.EOF then
          FTemp:=FTemp + CNT_JL_CRLF;
        until (JL_StrAdd(FTemp,Result,Restriction)=True)
        or    (FElements.Next=False);
      finally
        FElements.free;
      end;
    end;  
  end;

  Function TJLBitBuffer.ObjectHasData:Boolean;
  Begin
    result:=Empty=False;
  end;
  
  Procedure TJLBitBuffer.BeforeReadObject;
  Begin
    inherited;
    If FData<>NIL then
    Release;
  end;

  procedure TJLBitBuffer.ReadObject(Const Reader:TJLReader);
  Begin
    inherited;
    If Reader.ReadBool then
    Begin
      Allocate(Reader.ReadInt);
      Reader.Read(FData^,FDataLen);
    end;
  end;

  procedure TJLBitBuffer.WriteObject(Const Writer:TJLWriter);
  Begin
    inherited;
    Writer.WriteBool(Empty=False);
    If FData<>NIL then
    Begin
      Writer.WriteInt(FDataLen);
      Writer.Write(FData^,FDataLen);
    end;
  end;

  Function TJLBitBuffer.Empty:Boolean;
  Begin
    result:=FData=NIL;
  end;

  Function TJLBitBuffer.GetByte(Const Index:Integer):Byte;
  Begin
    If FData<>NIL then
    Begin
      If (index>=0) and (Index<FDataLen) then
      result:=PByte(PTR(FDataLng + index))^ else
      Raise EJlBitBuffer.CreateFmt
      (ERR_JLBitBuffer_InvalidByteIndex,[FDataLen-1,index]);
    end else
    Raise EJlBitBuffer.Create(ERR_JLBitBuffer_BitBufferEmpty);
  end;

  Procedure TJLBitBuffer.SetByte(Const Index:Integer;Const Value:Byte);
  Begin
    If FData<>NIL then
    Begin
      If (index>=0) and (Index<FDataLen) then
      PByte(PTR(FDataLng + index))^:=Value else
      Raise EJlBitBuffer.CreateFmt
      (ERR_JLBitBuffer_InvalidByteIndex,[FDataLen-1,index]);
    end else
    Raise EJlBitBuffer.Create(ERR_JLBitBuffer_BitBufferEmpty);
  end;

  Procedure TJLBitBuffer.SetBitRange(First,Last:Longword;
            Const Bitvalue:Boolean);
  var
    x:        Longword;
    FLongs:   Integer;
    FSingles: Integer;
    FCount:   Longword;
  Begin
    If FData<>NIL then
    Begin
      If  First<FBitsMax then
      Begin
        If Last<FBitsMax then
        Begin
          (* Conditional swap *)
          If First>Last then
          JL_Swap(First,Last);

          (* get totals, take ZERO into account *)
          FCount:=JL_Diff(First,Last,True);

          (* use refactoring & loop reduction *)
          FLongs:=Integer(FCount shr 3);

          x:=First;

          while FLongs>0 do
          Begin
            SetBit(x,Bitvalue);inc(x);
            SetBit(x,Bitvalue);inc(x);
            SetBit(x,Bitvalue);inc(x);
            SetBit(x,Bitvalue);inc(x);
            SetBit(x,Bitvalue);inc(x);
            SetBit(x,Bitvalue);inc(x);
            SetBit(x,Bitvalue);inc(x);
            SetBit(x,Bitvalue);inc(x);
            dec(FLongs);
          end;

          (* process singles *)
          FSingles:=Integer(FCount mod 8);
          while FSingles>0 do
          Begin
            SetBit(x,Bitvalue);inc(x);
            dec(FSingles);
          end;

        end else
        Begin
          If First=Last then
          SetBit(First,True) else
          Raise EJlBitBuffer.CreateFmt
          (ERR_JLBitBuffer_InvalidBitIndex,[FBitsMax,Last]);
        end;
      end else
      Raise EJlBitBuffer.CreateFmt(ERR_JLBitBuffer_InvalidBitIndex,
      [FBitsMax,First]);
    end else
    Raise EJlBitBuffer.Create(ERR_JLBitBuffer_BitBufferEmpty);
  end;

  Procedure TJLBitBuffer.SetBits(Const Value:TLongArray;
            Const BitValue:Boolean);
  var
    x:      Integer;
    FCount: Integer;
  Begin
    If FData<>NIL then
    Begin
      FCount:=length(Value);
      If FCount>0 then
      Begin
        for x:=low(Value) to High(Value) do
        SetBit(Value[x],BitValue);
      end;
    end else
    Raise EJlBitBuffer.Create(ERR_JLBitBuffer_BitBufferEmpty);
  end;

  Function  TJLBitBuffer.FindIdleBit(var Value:Longword;
            Const FromStart:Boolean=False):Boolean;
  var
    FOffset:  Longword;
    FBit:     Longword;
    FAddr:    PByte;
    x:        Integer;
  Begin
    result:=FData<>NIL;
    if result then
    Begin
      (* Initialize *)
      FAddr:=FData;
      FOffset:=0;

      If FromStart then
      FReadyByte:=0;

      If FReadyByte<1 then
      Begin
        (* find byte with idle bit *)
        While FOffset<Longword(FDataLen) do
        Begin
          If JL_BitsSetInByte(FAddr^)=8 then
          Begin
            inc(FOffset);
            inc(FAddr);
          end else
          break;
        end;
      end else
      inc(FOffset,FReadyByte);

      (* Last byte exhausted? *)
      result:=FOffset<Longword(FDataLen);
      If result then
      Begin
        (* convert to bit index *)
        FBit:=FOffset shl 3;

        (* scan byte with free bit in it *)
        for x:=1 to 8 do
        Begin
          If not GetBit(FBit) then
          Begin
            Value:=FBit;

            (* more than 1 bit available in byte? remember that *)
            FAddr:=FData;
            inc(FAddr,FOffset);
            If JL_BitsSetInByte(FAddr^)>7 then
            FReadyByte:=0 else
            FReadyByte:=FOffset;

            Break;
          end;
          inc(FBit);
        end;
      end;

    end;
  end;

  Function TJLBitBuffer.GetBit(Const Index:Longword):Boolean;
  begin
    If FData<>NIL then
    Begin
      If index<FBitsMax then
      Begin
        FAddr:=PTR(FDataLng + Integer(index shr 3));
        BitOfs:=Index mod 8;
        Result:=(FAddr^ and (1 shl (BitOfs mod 8))) <> 0;
      end else
      Raise EJlBitBuffer.CreateFmt
      (ERR_JLBitBuffer_InvalidBitIndex,[Count-1,index]);
    end else
    Raise EJlBitBuffer.Create(ERR_JLBitBuffer_BitBufferEmpty);
  end;

  Procedure TJLBitBuffer.SetBit(Const Index:longword;Const Value:Boolean);
  begin
    If FData<>NIL then
    Begin
      If index<=FBitsMax then
      Begin
        FByte:=PByte(FDataLng + Integer(index shr 3))^;
        BitOfs:=Index mod 8;

        If Value then
        Begin
          (* set bit if not already set *)
          If (FByte and (1 shl (BitOfs mod 8)))=0 then
          Begin
            FByte:=(FByte or (1 shl (BitOfs mod 8)));
            PByte(FDataLng + Integer(index shr 3))^:=FByte;

            (* if this was the "ready" byte, then
               reset it to zero *)
            If (Index shr 3=FReadyByte)
            and (FReadyByte>0) then
            Begin
              If JL_BitsSetInByte(FByte)>7 then
              FReadyByte:=0;
            end;

          end;
        end else
        Begin
          (* clear bit if not already clear *)
          If (FByte and (1 shl (BitOfs mod 8)))<>0 then
          Begin
            FByte:=(FByte and not (1 shl (BitOfs mod 8)));
            PByte(FDataLng + Integer(index shr 3))^:=FByte;

            (* remember this byte pos *)
            FReadyByte:=Index shr 3;
          end;
        end;

      end else
      Raise EJlBitBuffer.CreateFmt
      (ERR_JLBitBuffer_InvalidBitIndex,[Count-1,index]);
    end else
    Raise EJlBitBuffer.Create(ERR_JLBitBuffer_BitBufferEmpty);
  end;

  Procedure TJLBitBuffer.Allocate(MaxBits:Integer);
  Begin
    (* release buffer if not empty *)
    If FData<>NIL then
    Release;

    If Maxbits>0 then
    Begin
      (* Round off to nearest byte *)
      MaxBits:=JL_ToNearest(MaxBits,8);

      (* Allocate new buffer *)
      try
        FReadyByte:=0;
        FDataLen:=MaxBits shr 3;
        FData:=AllocMem(FDataLen);
        FDataLng:=longword(FData);
        FBitsMax:=longword(FDataLen shl 3);
      except
        on e: exception do
        Begin
          FData:=NIL;
          FDataLen:=0;
          FBitsMax:=0;
          FDataLng:=0;
          Raise;
        end;
      end;

    end;
  end;

  Procedure TJLBitBuffer.Release;
  Begin
    If FData<>NIL then
    Begin
      try
        FreeMem(FData);
      finally
        FReadyByte:=0;
        FData:=NIL;
        FDataLen:=0;
        FBitsMax:=0;
        FDataLng:=0;
      end;
    end;
  end;

  Procedure TJLBitBuffer.Zero;
  Begin
    If FData<>NIL then
    Fillchar(FData^,FDataLen,0) else
    Raise EJlBitBuffer.Create(ERR_JLBitBuffer_BitBufferEmpty);
  end;

  end.
