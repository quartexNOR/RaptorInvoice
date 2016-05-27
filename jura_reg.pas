  unit jura_reg;

  interface

  uses sysutils, classes;

  Procedure Register;

  implementation

  uses jura_language;

  Procedure Register;
  Begin
    RegisterComponents('JuraSoft',[TJLLanguageFile]);
  end;

  end.
