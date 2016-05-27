  unit hexmime;

  Interface

  Uses sysutils, classes, hexbase;

  Type

  THEXMime = Class(THEXCustomWorkComponent)
  private
    FText:      String;
    Procedure   MimeEncodeNoCRLF (const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    Procedure   MimeEncodeFullLines (const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    Procedure   MimeEncode (const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    Function    MimeEncodedSize (const i: Cardinal): Cardinal;
    Function    MimeEncodeString (const s: AnsiString): AnsiString;
    function    MimeDecodePartial (const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer; var ByteBuffer: Cardinal; var ByteBufferSpace: Cardinal): Cardinal;
    function    MimeDecodePartialEnd (out OutputBuffer; const ByteBuffer: Cardinal; const ByteBufferSpace: Cardinal): Cardinal;
    Function    MimeDecodeString (const s: AnsiString): AnsiString;
    Procedure   SetText(Value:String);
  Public
    Property    Text:String read FText Write SetText;
    Procedure   Encode;overload;
    Procedure   Encode(Text:String);Overload;
    Procedure   Decode;overload;
    Procedure   Decode(Text:String);Overload;
    Procedure   Clear;
  Published
    Property    EventFlags;
    Property    OnWorkBegins;
    Property    OnWorkComplete;
    Property    OnWorkProgress;
    Property    OnEventFlagsChanged;
    Property    OnDataCleared;
  End;

  implementation

  Const
  MIME_ENCODED_LINE_BREAK = 76;
  MIME_DECODED_LINE_BREAK = MIME_ENCODED_LINE_BREAK div 4 * 3;
  BUFFER_SIZE             = MIME_DECODED_LINE_BREAK * 3 * 4 * 16;
  MIME_PAD_CHAR           = Byte ('=');

  MIME_ENCODE_TABLE  : array[0..63] of Byte = (
  065, 066, 067, 068, 069, 070, 071, 072, // 00 - 07
  073, 074, 075, 076, 077, 078, 079, 080, // 08 - 15
  081, 082, 083, 084, 085, 086, 087, 088, // 16 - 23
  089, 090, 097, 098, 099, 100, 101, 102, // 24 - 31
  103, 104, 105, 106, 107, 108, 109, 110, // 32 - 39
  111, 112, 113, 114, 115, 116, 117, 118, // 40 - 47
  119, 120, 121, 122, 048, 049, 050, 051, // 48 - 55
  052, 053, 054, 055, 056, 057, 043, 047); // 56 - 63

  MIME_DECODE_TABLE  : array[Byte] of Cardinal = (
  255, 255, 255, 255, 255, 255, 255, 255, //  00 -  07
  255, 255, 255, 255, 255, 255, 255, 255, //  08 -  15
  255, 255, 255, 255, 255, 255, 255, 255, //  16 -  23
  255, 255, 255, 255, 255, 255, 255, 255, //  24 -  31
  255, 255, 255, 255, 255, 255, 255, 255, //  32 -  39
  255, 255, 255, 062, 255, 255, 255, 063, //  40 -  47
  052, 053, 054, 055, 056, 057, 058, 059, //  48 -  55
  060, 061, 255, 255, 255, 255, 255, 255, //  56 -  63
  255, 000, 001, 002, 003, 004, 005, 006, //  64 -  71
  007, 008, 009, 010, 011, 012, 013, 014, //  72 -  79
  015, 016, 017, 018, 019, 020, 021, 022, //  80 -  87
  023, 024, 025, 255, 255, 255, 255, 255, //  88 -  95
  255, 026, 027, 028, 029, 030, 031, 032, //  96 - 103
  033, 034, 035, 036, 037, 038, 039, 040, // 104 - 111
  041, 042, 043, 044, 045, 046, 047, 048, // 112 - 119
  049, 050, 051, 255, 255, 255, 255, 255, // 120 - 127
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255,
  255, 255, 255, 255, 255, 255, 255, 255);

  Type

  PByte4 = ^TByte4;
  TByte4 = packed record
    b1: Byte;
    b2: Byte;
    b3: Byte;
    b4: Byte;
  end;

  type
  PByte3 = ^TByte3;
  TByte3 = packed record
    b1: Byte;
    b2: Byte;
    b3: Byte;
  end;

  Procedure THexMime.SetText(Value:String);
  Begin
    If Value<>FText then
    Begin
      try
        Encode(Value);
      except
        on exception do
        Raise;
      end;
    end;
  End;

  Procedure THexMime.Clear;
  Begin
    FText:='';
    DataCleared;
  End;

  Procedure THexMime.Encode(Text:String);
  Begin
    FText:=Text;
    try
      Encode;
    except
      On exception do
      Raise;
    end;
  End;

  Procedure THexMime.Decode(Text:String);
  Begin
    FText:=Text;
    try
      Decode;
    except
      on exception do
      raise;
    end;
  End;

  Procedure THexMime.Encode;
  Begin
    WorkBegins(Length(FText));

    try
      FText:=MimeEncodeString(FText);
    except
      on e: exception do
      Begin
        Raise EHexInternalError.CreateFmt(ERR_Hex_InternalError,[e.message]);
        exit;
      end;
    end;

    WorkComplete;
  End;

  Procedure THexMime.Decode;
  Begin
    WorkBegins(Length(FText));

    try
      FText:=MimeDecodeString(FText);
    except
      on e: exception do
      Begin
        Raise EHexInternalError.CreateFmt(ERR_Hex_InternalError,[e.message]);
        exit;
      end;
    end;

    WorkComplete;
  End;

  Procedure THexMime.MimeEncodeNoCRLF (const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
  var
    b, OuterLimit      : Cardinal;
    InPtr, InnerLimit  : ^Byte;
    OutPtr             : PByte4;
  begin
    if InputByteCount = 0 then Exit;
    InPtr := @InputBuffer;
    OutPtr := @OutputBuffer;

    OuterLimit := InputByteCount div 3 * 3;

    InnerLimit := @InputBuffer;
    Inc (Cardinal (InnerLimit), OuterLimit);

    { Last line loop. }
    while InPtr <> InnerLimit do
    begin
      { Read 3 bytes from InputBuffer. }
      b := InPtr^;
      b := b shl 8;
      Inc (InPtr);
      b := b or InPtr^;
      b := b shl 8;
      Inc (InPtr);
      b := b or InPtr^;
      Inc (InPtr);

      { Write 4 bytes to OutputBuffer (in reverse order). }
      OutPtr^.b4 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b3 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b2 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b1 := MIME_ENCODE_TABLE[b];
      Inc (OutPtr);
    end;

    { End of data & padding. }
    case InputByteCount - OuterLimit of
    1:
      begin
        b := InPtr^;
        b := b shl 4;
        OutPtr.b2 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr.b1 := MIME_ENCODE_TABLE[b];
        OutPtr.b3 := MIME_PAD_CHAR;         { Pad remaining 2 bytes. }
        OutPtr.b4 := MIME_PAD_CHAR;
      end;
    2:
      begin
        b := InPtr^;
        Inc (InPtr);
        b := b shl 8;
        b := b or InPtr^;
        b := b shl 2;
        OutPtr.b3 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr.b2 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr.b1 := MIME_ENCODE_TABLE[b];
        OutPtr.b4 := MIME_PAD_CHAR;         { Pad remaining byte. }
      end;
    end;
  end;

  Procedure THexMime.MimeEncodeFullLines (const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
  var
    b, OuterLimit      : Cardinal;
    InPtr, InnerLimit  : ^Byte;
    OutPtr             : PByte4;
  begin
    if InputByteCount = 0 then Exit;
    InPtr := @InputBuffer;
    OutPtr := @OutputBuffer;

    InnerLimit := InPtr;
    Inc (Cardinal (InnerLimit), MIME_DECODED_LINE_BREAK);

    OuterLimit := Cardinal (InPtr);
    Inc (OuterLimit, InputByteCount);

    { Multiple line loop. }
    while Cardinal (InnerLimit) <= OuterLimit do
    begin

      while InPtr <> InnerLimit do
      begin
        { Read 3 bytes from InputBuffer. }
        b := InPtr^;
        b := b shl 8;
        Inc (InPtr);
        b := b or InPtr^;
        b := b shl 8;
        Inc (InPtr);
        b := b or InPtr^;
        Inc (InPtr);
        { Write 4 bytes to OutputBuffer (in reverse order). }
        OutPtr^.b4 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr^.b3 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr^.b2 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr^.b1 := MIME_ENCODE_TABLE[b];
        Inc (OutPtr);
      end;

      { Write line break (CRLF). }
      OutPtr^.b1 := 13;
      OutPtr^.b2 := 10;
      Inc (Cardinal (OutPtr), 2);
      Inc (InnerLimit, MIME_DECODED_LINE_BREAK);
    end;
  end;

  Procedure THexMime.MimeEncode (const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
  var
    IDelta, ODelta     : Cardinal;
  begin
    MimeEncodeFullLines (InputBuffer, InputByteCount, OutputBuffer);
    IDelta := InputByteCount div MIME_DECODED_LINE_BREAK; // Number of lines processed so far.
    ODelta := IDelta * (MIME_ENCODED_LINE_BREAK + 2);
    IDelta := IDelta * MIME_DECODED_LINE_BREAK;
    MimeEncodeNoCRLF (Pointer (Cardinal (@InputBuffer) + IDelta)^, InputByteCount - IDelta, Pointer (Cardinal (@OutputBuffer) + ODelta)^);
  end;

  Function THexMime.MimeEncodedSize (const i: Cardinal): Cardinal;
  begin
    Result := (i + 2) div 3 * 4 + (i - 1) div MIME_DECODED_LINE_BREAK * 2;
  end;

  Function THexMime.MimeEncodeString (const s: AnsiString): AnsiString;
  var
    l: Cardinal;
  begin
    if Pointer (s) <> nil then
    begin
      l := Cardinal (Pointer (Cardinal (s) - 4)^);
      SetLength (Result, MimeEncodedSize (l));
      MimeEncode (Pointer (s)^, l, Pointer (Result)^);
    end else
    Result := '';
  end;

  function THexMime.MimeDecodePartial (const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer; var ByteBuffer: Cardinal; var ByteBufferSpace: Cardinal): Cardinal;
  var
    lByteBuffer, lByteBufferSpace, c: Cardinal;
    InPtr, OuterLimit  : ^Byte;
    OutPtr             : PByte3;
  begin
    if InputBytesCount > 0 then
    begin
      InPtr := @InputBuffer;
      Cardinal (OuterLimit) := Cardinal (InPtr) + InputBytesCount;
      OutPtr := @OutputBuffer;
      lByteBuffer := ByteBuffer;
      lByteBufferSpace := ByteBufferSpace;
      while InPtr <> OuterLimit do
      begin
        { Read from InputBuffer. }
        c := MIME_DECODE_TABLE[InPtr^];
        Inc (InPtr);
        if c = $FF then Continue;
        lByteBuffer := lByteBuffer shl 6;
        lByteBuffer := lByteBuffer or c;
        Dec (lByteBufferSpace);
        { Have we read 4 bytes from InputBuffer? }
        if lByteBufferSpace <> 0 then
        Continue;

        { Write 3 bytes to OutputBuffer (in reverse order). }
        OutPtr^.b3 := Byte (lByteBuffer);
        lByteBuffer := lByteBuffer shr 8;
        OutPtr^.b2 := Byte (lByteBuffer);
        lByteBuffer := lByteBuffer shr 8;
        OutPtr^.b1 := Byte (lByteBuffer);
        lByteBuffer := 0;
        Inc (OutPtr);
        lByteBufferSpace := 4;
      end;
      ByteBuffer := lByteBuffer;
      ByteBufferSpace := lByteBufferSpace;
      Result := Cardinal (OutPtr) - Cardinal (@OutputBuffer);
    end else
    Result := 0;
  end;

  function THexMime.MimeDecodePartialEnd (out OutputBuffer; const ByteBuffer: Cardinal; const ByteBufferSpace: Cardinal): Cardinal;
  var
    lByteBuffer        : Cardinal;
  begin
    case ByteBufferSpace of
    1:
    begin
      lByteBuffer := ByteBuffer shr 2;
      PByte3 (@OutputBuffer)^.b2 := Byte (lByteBuffer);
      lByteBuffer := lByteBuffer shr 8;
      PByte3 (@OutputBuffer)^.b1 := Byte (lByteBuffer);
      Result := 2;
    end;
  2:
    begin
      lByteBuffer := ByteBuffer shr 4;
      PByte3 (@OutputBuffer)^.b1 := Byte (lByteBuffer);
      Result := 1;
    end;
    else
      Result := 0;
    end;
  end;

  function THexMime.MimeDecodeString (const s: AnsiString): AnsiString;
  var
    ByteBuffer, ByteBufferSpace: Cardinal;
    l: Cardinal;
  begin
    if Pointer (s) <> nil then
    begin
      l := Cardinal (Pointer (Cardinal (s) - 4)^);
      SetLength (Result, (l + 3) div 4 * 3);
      ByteBuffer := 0;
      ByteBufferSpace := 4;
      l := MimeDecodePartial (Pointer (s)^, l, Pointer (Result)^, ByteBuffer, ByteBufferSpace);
      Inc (l, MimeDecodePartialEnd (Pointer (Cardinal (Result) + l)^, ByteBuffer, ByteBufferSpace));
      SetLength (Result, l);
    end else
    Result := '';
  end;

  end.
