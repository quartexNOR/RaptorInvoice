  unit jlrc4enc;

  interface

  uses sysutils, classes;

  type

  TJLRC4EncodingTable = Packed Record
    etShr: Packed Array[0..255] of Byte;
    etMod: Packed Array[0..255] of Byte;
  End;

  TJLRC4Encoder = Class(TObject)
  Private
    FTable:   TJLRC4EncodingTable;
    FReady:   Boolean;
  Public
    Procedure ResetRCTable;
    Function  BuildRCTable(Const Key;Const KeyLen:Integer):Boolean;overload;
    Function  BuildRCTable(Stream:TStream):Boolean;overload;
    Function  BuildRCTable(aKey:AnsiString):Boolean;overload;
    Function  BuildRCTable(aKey:WideString):Boolean;overload;

    Function  EncStream(Source,Target:TStream):Boolean;
    Function  EncBuffer(Const Source;Const Target;
              aLen:Integer):Boolean;
  Public
    Property  Ready:Boolean read FReady;
  End;

  implementation

  type
  TRCByteArray = Packed Array[0..4095] of Byte;
  PRCByteArray = ^TRCByteArray;

  Procedure TJLRC4Encoder.ResetRCTable;
  Begin
    FReady:=False;
    Fillchar(FTable,SizeOf(FTable),#0);
  end;

  Function TJLRC4Encoder.BuildRCTable(Stream:TStream):Boolean;
  var
    FLen:   Integer;
    FData:  Pointer;
  Begin
    result:=(Stream<>NIL) and (Stream.size>=256);
    If result then
    Begin
      Stream.Position:=0;
      FData:=AllocMem(256);
      try
        fillchar(FData^,256,#0);
        FLen:=Stream.Read(FData^,256);
        result:=FLen>0;
        If result then
        result:=BuildRCTable(FData^,FLen);
      finally
        FreeMem(FData);
      end;
    end;

    if not result then
    Begin
      (* reset key data *)
      FReady:=False;
      Fillchar(FTable,SizeOf(FTable),#0);
    end;

  end;
  
  Function TJLRC4Encoder.BuildRCTable(Const Key;
           Const KeyLen:Integer):Boolean;
  var
    i,j:    Integer;
    temp:   Byte;
    FData:  PRCByteArray;
  Begin
    (* reset key data *)
    FReady:=False;
    Fillchar(FTable,SizeOf(FTable),#0);

    FData:=@Key;

    result:=(FData<>NIL) and (KeyLen>0);
    If result then
    Begin
      J:=0;

      { Generate internal shift table based on key }
      {.$R-}
      for I:=0 to 255 do
      begin
        FTable.etShr[i]:=i;
        If J=KeyLen then
        j:=1 else inc(J);
        FTable.etMod[i]:=FData[j-1];
      end;
      {.$R+}

      { Modulate shift table }
      J:=0;
      For i:=0 to 255 do
      begin
        j:=(j+FTable.etShr[i] + FTable.etMod[i]) mod 256;
        temp:=FTable.etShr[i];
        FTable.etShr[i]:=FTable.etShr[j];
        FTable.etShr[j]:=Temp;
      end;

      FReady:=True;
    end;
  end;

  Function TJLRC4Encoder.BuildRCTable(aKey:WideString):Boolean;
  var
    FLen: Integer;
  Begin
    aKey:=trim(aKey);
    FLen:=Length(aKey);
    Result:=FLen>0;
    If result then
    result:=BuildRCTable(aKey[1],FLen);
  end;
  
  Function TJLRC4Encoder.BuildRCTable(aKey:AnsiString):Boolean;
  var
    FLen: Integer;
  Begin
    aKey:=trim(aKey);
    FLen:=Length(aKey);
    Result:=FLen>0;
    If result then
    result:=BuildRCTable(aKey[1],FLen);
  end;

  Function TJLRC4Encoder.EncBuffer(Const Source;Const Target;
           aLen:Integer):Boolean;
  var
    i,j,t:  Integer;
    Temp,y:   Byte;
    FSpare:   TJLRC4EncodingTable;
    FSource:  PByte;
    FTarget:  PByte;
  Begin
    FSource:=@Source;
    FTarget:=@Target;
    Result:=FReady
    and (FSource<>NIL)
    and (FTarget<>NIL)
    and (aLen>0);

    If result then
    Begin
      (* duplicate table *)
      FSpare:=FTable;

      try

        i:=0; j:=0;
        while 1>0 do
        Begin
          i:=(i+1) mod 256;
          j:=(j+FSpare.etShr[i]) mod 256;
          temp:=FSpare.etShr[i];
          FSpare.etShr[i]:=FSpare.etShr[j];
          FSpare.etShr[j]:=temp;
          t:=(FSpare.etShr[i] + (FSpare.etShr[j] mod 256)) mod 256;
          y:=FSpare.etShr[t];

          FTarget^:=Byte( FSource^ xor y );
          inc(FTarget);
          inc(FSource);
        end;
      except
        on exception do
        Result:=False;
      end;
    end;
  end;

  Function TJLRC4Encoder.EncStream(Source,Target:TStream):Boolean;
  var
    i,j,t:  Integer;
    Temp,y:   Byte;
    FSpare:   TJLRC4EncodingTable;
    FDat:     Byte;
  Begin
    result:=(Source<>NIL)
    and (Source.size>0)
    and (Target<>NIL)
    and FReady;

    If result then
    Begin

      FSpare:=FTable;

      try
        Source.Position:=0;
        i:=0; j:=0;
        while 1>0 do
        Begin
          i:=(i+1) mod 256;
          j:=(j+FSpare.etShr[i]) mod 256;
          temp:=FSpare.etShr[i];
          FSpare.etShr[i]:=FSpare.etShr[j];
          FSpare.etShr[j]:=temp;
          t:=(FSpare.etShr[i] + (FSpare.etShr[j] mod 256)) mod 256;
          y:=FSpare.etShr[t];

          if source.Read(FDat,1)=1 then
          Begin
            FDat:=FDat xor y;
            if Target.Write(FDat,1)<1 then
            Begin
              result:=False;
              Break;
            end;
          end else
          Break;
        end;
      except
        on exception do
        Result:=False;
      end;
    end;
  end;


  end.
