  {$DEFINE JL_USE_ASSEMBLER}
  {$DEFINE PLATFORM_DELPHI}

  {$DEFINE JL_ALLOW_VARIANTS}

  {$IFDEF PLATFORM_DELPHI}

    {$IFDEF VER180}
      {.$UNDEF JL_USE_WIDESTRINGS}
    {$ENDIF}

    {$IFDEF VER200}
      {.$DEFINE JL_USE_WIDESTRINGS}
    {$ENDIF}
  {$ENDIF}

  {.$M+}

  { Compiler switches for versions:
    Delphi 2009 - VER200
    Delphi 2006 - VER180     }

