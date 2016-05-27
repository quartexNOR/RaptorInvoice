  unit hexencrypt;

  interface

  { Dependancies }
  Uses sysutils, classes, contnrs, hexbase;

  Type
  
  { THEXEncryption component }
  THEXEncryption = Class(THEXCustomWorkComponent)
  Private
    FKey:           String;
    S:              Array[0..255] of Byte;
    K:              Array[0..255] of byte;
    FActive:        Boolean;
    FOnKeyChanged:  TNotifyEvent;
    Procedure       SetKey(Value:String);
    Procedure       RebuildMatrix;
  Public
    Procedure       AfterConstruction;Override;
    Function        EncodeDecodeString(Var Source:String;key:String):String;
    Procedure       EncryptStream(Value:TStream);
    Procedure       DecryptStream(Value:TStream);
    Function        EncryptString(Value:String):String;
    Function        DecryptString(Value:String):String;
    Procedure       EncryptMemory(Value:Pointer;Length:Integer);
    Procedure       DecryptMemory(Value:Pointer;Length:Integer);
    Constructor     Create(AOwner:TComponent);Override;
  Published
    Property        Active:Boolean read FActive write FActive;
    Property        EncKey: String read FKey write SetKey;
    Property        EventFlags;
    Property        OnWorkBegins;
    Property        OnWorkComplete;
    Property        OnWorkProgress;
    Property        OnEventFlagsChanged;
    Property        OnKeyChanged:TNotifyEvent read FOnKeyChanged write FOnKeyChanged;
  End;

  Implementation

  Constructor THEXEncryption.Create(AOwner:TComponent);
  Begin
    inherited Create(AOwner);
    FKey:='priv8';
    FActive:=True;
    EventFlags:=
      [
      ntfWorkBegins,
      ntfWorkProgress,
      ntfWorkComplete
      ];
  End;

  Procedure THEXEncryption.AfterConstruction;
  Begin
    inherited;
    RebuildMatrix;
  End;

  Function THEXEncryption.EncodeDecodeString(Var Source:String;key:String):String;
  var
    S: Array[0..255] of Byte;
    K: Array[0..255] of byte;
    Temp,y:Byte;
    I,J,T,X:Integer;
    target:String;
  Begin
    for i:=0 to 255 do
    s[i]:=i;

    J:=1;
    for I:=0 to 255 do
    begin
      if j>length(key) then j:=1;
      k[i]:=byte(key[j]);
      inc(j);
    end;

    J:=0;
    For i:=0 to 255 do
    begin
      j:=(j+s[i] + k[i]) mod 256;
      temp:=s[i];
      s[i]:=s[j];
      s[j]:=Temp;
    end;

    i:=0;
    j:=0;
    for x:=1 to length(source) do
    begin
      i:=(i+1) mod 256;
      j:=(j+s[i]) mod 256;
      temp:=s[i];
      s[i]:=s[j];
      s[j]:=temp;
      t:=(s[i] + (s[j] mod 256)) mod 256;
      y:=s[t];
      target:=target + char(byte(source[x]) xor y);
    end;
    result:=Target;
  End;


  Procedure THEXEncryption.SetKey(Value:String);
  Begin
    { Check that we can do this }
    If Value<>FKey then
    Begin
      FKey:=Value;
      RebuildMatrix;
      If assigned(FOnKeyChanged) then
      FOnKeyChanged(self);
    end;
  End;

  Procedure THEXEncryption.RebuildMatrix;
  var
    x,xpos: Integer;
    FTemp:  Byte;
  Begin
    { build up initial rotation values }
    for x:=0 to 255 do
    s[x]:=x;

    { Build up second rotation values based on encoding key }
    xpos:=1;
    for x:=0 to 255 do
    Begin
      If xpos>Length(FKey) then
      xpos:=1;
      K[x]:=Byte(FKey[xpos]);
      inc(xpos);
    end;

    { Merge both tables }
    xpos:=0;
    for x:=0 to 255 do
    Begin
      xpos:=(xpos + s[x] + k[x]) mod 256;
      FTemp:=s[x];
      s[x]:=s[xpos];
      s[xpos]:=FTemp;
    end;
  End;

  Procedure THEXEncryption.EncryptStream(Value:TStream);
  var
    x:      Integer;
    FStep:  Integer;
    FCounter: Integer;

    I,J,T:Integer;
    Temp,Y:Byte;

  Begin
    { Not active? just exit }
    If not Active then
    exit;

    { Check if we can do this }
    If (Value=NIL) then
    Begin
      Raise EHEXStreamParamIsNIL.Create(ExceptFormat('EncryptStream()',ERR_HEX_StreamParamIsNIL));
      exit;
    end;

    { No data? Just exit }
    If Value.Size=0 then
    exit;

    { Notify work begins }
    WorkBegins(Value.Size);

    { Seek to beginning of data }
    If (Value.Position<>0) then
    Value.Seek(0,0);

    { Calculate blocks in data }
    FStep:=(Value.Size div 10);
    if FStep>100 then
    FStep:=(Value.Size div 20);

    FCounter:=0;

    i:=0;
    j:=0;
    for x:=0 to Value.Size-1 do
    begin

      inc(FCounter);
      if FCounter>FStep then
      begin
        { Notify Work progress }
        WorkProgress(Value.Size,x);
        FCounter:=0;
      end;

      { Figure out where in the table to work }
      i:=(i+1) mod 256;
      j:=(j+s[i]) mod 256;
      temp:=s[i];
      s[i]:=s[j];
      s[j]:=temp;
      t:=(s[i] + (s[j] mod 256)) mod 256;
      y:=s[t];

      { Modulate byte in stream }
      Value.Read(Temp,1);
      Value.Seek(Value.position-1,0);
      Temp:=(Temp xor y);
      Value.write(Temp,1);
    end;

    { Seek to beginning of data }
    Value.seek(0,0);

    { Notify work complete }
    workComplete;
  End;

  Procedure THEXEncryption.DecryptStream(Value:TStream);
  var
    x:      Integer;
    FStep:  Integer;
    FCounter: Integer;
    I,J,T:Integer;
    Temp,Y:Byte;
  Begin
    { Not active, just exit }
    If not Active then
    exit;

    { Check if we can do this }
    If (Value=NIL) then
    Begin
      Raise EHEXStreamParamIsNIL.Create(ExceptFormat('DecryptStream()',ERR_HEX_StreamParamIsNIL));
      exit;
    end;

    { No data? Just exit }
    If Value.Size=0 then
    exit;

    { Notify work begins }
    WorkBegins(Value.Size);

    { Seek to beginning of data }
    If Value.Position<>0 then
    Value.Seek(0,0);

    { Calculate blocks in data }
    FStep:=(Value.Size div 10);
    if FStep>100 then
    FStep:=(Value.Size div 20);

    FCounter:=0;

    i:=0;
    j:=0;
    for x:=0 to Value.Size-1 do
    begin

      inc(FCounter);
      if FCounter>FStep then
      begin
        { Notify Work progress }
        WorkProgress(Value.Size,x);
        FCounter:=0;
      end;

      { Figure out where in the table to work }
      i:=(i+1) mod 256;
      j:=(j+s[i]) mod 256;
      temp:=s[i];
      s[i]:=s[j];
      s[j]:=temp;
      t:=(s[i] + (s[j] mod 256)) mod 256;
      y:=s[t];

      { Modulate byte in stream }
      Value.Read(Temp,1);
      Value.Seek(Value.position-1,0);
      Temp:=(Temp xor y);
      Value.write(Temp,1);
    end;

    { Seek to beginning of data }
    Value.Seek(0,0);

    { Notify work complete }
    WorkComplete;
  End;

  Function THEXEncryption.EncryptString(Value:String):String;
  var
    Temp,y:Byte;
    I,J,T,X:Integer;
  Begin
    { Not active, just exit }
    If not Active then
    exit;

    { nothing to encode? }
    If length(Value)=0 then
    exit;

    i:=0;
    j:=0;
    for x:=1 to length(Value) do
    begin
      i:=(i+1) mod 256;
      j:=(j+s[i]) mod 256;
      temp:=s[i];
      s[i]:=s[j];
      s[j]:=temp;
      t:=(s[i] + (s[j] mod 256)) mod 256;
      y:=s[t];
      Result:=Result + char(byte(Value[x]) xor y);
    end;
  End;

  Function THEXEncryption.DecryptString(Value:String):String;
  var
    Temp,y:Byte;
    I,J,T,X:Integer;
  Begin
    { Not active, just exit }
    If not Active then
    exit;

    { nothing to decode? }
    if length(Value)=0 then
    exit;

    i:=0;
    j:=0;
    for x:=1 to length(Value) do
    begin
      i:=(i+1) mod 256;
      j:=(j+s[i]) mod 256;
      temp:=s[i];
      s[i]:=s[j];
      s[j]:=temp;
      t:=(s[i] + (s[j] mod 256)) mod 256;
      y:=s[t];
      Result:=Result + char(byte(Value[x]) xor y);
    end;
  End;

  Procedure THEXEncryption.EncryptMemory(Value:Pointer;Length:Integer);
  var
    FBuffer:  String;
    FTarget:  Pointer;
  Begin
    { Not active, just exit }
    If not Active then
    exit;
    
    { Check if we can do this }
    If (Value=NIL) then
    Begin
      raise EHexParameterIsNIL.Create(ERR_Hex_ParameterIsNIL);
      exit;
    end;

    { No data? just exit }
    if (Length<1) then
    exit;

    { Resize our string buffer }
    Setlength(FBuffer,Length);

    { Get a handle on our buffer }
    Ftarget:=@FBuffer[1];

    { Copy data from memory to our string }
    Move(Value^,FTarget^,Length);

    { Encode data }
    try
      FBuffer:=EncryptString(FBuffer);
    except
      on exception do
      Begin
        raise;
        exit;
      end;
    end;

    { Copy data back again }
    move(FTarget^,Value^,Length);
  End;

  Procedure THEXEncryption.DecryptMemory(Value:Pointer;Length:Integer);
  var
    FBuffer:  String;
    FTarget:  Pointer;
  Begin
    { Not active, just exit }
    If not Active then
    exit;
    
    { Check if we can do this }
    If (Value=NIL) then
    Begin
      raise EHexParameterIsNIL.Create(ERR_Hex_ParameterIsNIL);
      exit;
    end;

    { No data? just exit }
    if (Length<1) then
    exit;

    { Resize our string buffer }
    Setlength(FBuffer,Length);

    { Get a handle on our buffer }
    Ftarget:=@FBuffer[1];

    { Copy data from memory to our string }
    Move(Value^,FTarget^,Length);

    { Encode data }
    try
      FBuffer:=DecryptString(FBuffer);
    except
      on exception do
      Begin
        raise;
        exit;
      end;
    end;

    { Copy data back again }
    move(FTarget^,Value^,Length);
  End;

  end.
