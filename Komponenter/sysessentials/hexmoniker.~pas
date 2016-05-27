  unit hexmoniker;

  interface

  Uses sysutils, classes, hexbase;

  Type
  
  THexUniformResource = Packed record
    FProtocol:  String;
    FServer:    String;
    FPath:      String;
    FFile:      String;
    FParams:    String;
    FPort:      String;
  end;

  THexUrlMoniker=Class(THexCustomComponent)
  private
    FText:    String;
    FData:    THexUniformResource;
    Function  DecodeUrlSyntax(url:String):THexUniformResource;
    Function  EncodeUrlSyntax(Url: THexUniformResource):String;
    Procedure OptimizeUrlSyntax(var Url: THexUniformResource);
    Function  Instr(Var Buffer: String;Position:Integer;Clause:String):Integer;
  Public
    Property  Port:String read FData.Fport write FData.FPort;
    Property  Url:String read FText write FText;
    Property  Protocol: String read FData.FProtocol write FData.FProtocol;
    Property  Server: String read FData.FServer write FData.FServer;
    Property  Path:String read FData.FPath write FData.FPath;
    Property  Filename:String read FData.FFile write FData.FFile;
    Property  Parameters:String read FData.FParams write FData.FParams;
    Procedure Encode;
    Procedure Decode;overload;
    Procedure Decode(Text:String);Overload;
  End;

  implementation

  Procedure THexUrlMoniker.Encode;
  Begin
    try
      FText:=EncodeUrlSyntax(FData);
    except
      on exception do
      Raise;
    end;
  End;

  Procedure THexUrlMoniker.Decode;
  Begin
    try
      FData:=DecodeUrlSyntax(Ftext);
      OptimizeUrlSyntax(FData);
    except
      on exception do
      raise;
    end;
  end;

  Procedure THexUrlMoniker.Decode(Text:String);
  Begin
    try
      FText:=Text;
      Decode;
    except
      on exception do
      raise;
    end;
  End;

  Function THexUrlMoniker.DecodeUrlSyntax(Url:String):THexUniformResource;
  var
    x:    Integer;
    Xpos: Integer;
    deca: Integer;
    FExt: String;
  Begin
    url:=trim(url);
    if length(url)=0 then
    exit;

    { Get parameters right away so they dont confuse us later }
    xpos:=pos('?',url);
    if xpos>0 then
    begin
      result.FParams:=Copy(url,xpos,length(url));
      Delete(url,xpos,length(url));
    end;

    { Just folder & filename}
    if length(url)>0 then
    Begin
      if (url[1]='/') or (copy(url,1,2)='..') then
      begin
        for x:=length(url) downto 1 do
        begin
          if url[x]='/' then
          begin
            result.FPath:=copy(url,1,x-1);
            delete(url,1,x);
            break;
          end;
        end;
        exit;
      end;
    end;

    { Get Protocol }
    Xpos:=Instr(url,1,'//');
    if xpos>0 then
    begin
      Result.FProtocol:=Copy(url,1,xpos+2);
      Delete(url,1,xpos+2);
    end;

    { Get server name }
    xpos:=pos('/',url);
    if xpos>0 then
    begin
      result.FServer:=Copy(url,1,xpos-1);
      Delete(url,1,xpos);
    end else
    begin
      { No slashes found. grab extension to see what we have }
      for x:=length(url) downto 1 do
      begin
        if url[x]='.' then
        begin
          FExt:=Copy(url,x,length(url));
          break;
        end;
      end;

      { filter out the known factors }
      xpos:=0;
      if FExt='.com' then xpos:=1 else
      if FExt='.info' then Xpos:=1 else
      if FExt='.museum' then XPos:=1 else
      if FExt='.net' then xpos:=1 else
      if FExt='.org' then xpos:=1 else
      if FExt='.gov' then xpos:=1 else
      if FExt='.mil' then xpos:=1 else
      If FExt='.biz' then xpos:=1 else
      if FExt='.no' then xpos:=1 else
      if FExt='.nu' then xpos:=1 else
      if FExt='.se' then xpos:=1 else
      if FExt='.dk' then xpos:=1 else
      if FExt='.de' then xpos:=1 else
      if FExt='.jp' then xpos:=1 else
      if FExt='.nz' then xpos:=1 else
      if FExt='.au' then xpos:=1 else
      if FExt='.fr' then xpos:=1 else
      if FExt='.it' then xpos:=1 else
      if FExt='.fi' then xpos:=1 else
      if FExt='.ru' then xpos:=1 else
      if FExt='.ch' then xpos:=1 else
      if FExt='.tv' then xpos:=1 else
      if FExt='.tm' then xpos:=1;

      if xpos=1 then
      begin
        { it's a server name }
        result.FServer:=url;
        url:='';
      end else
      begin
        { Its a file }
        result.FFile:=Url;
        url:='';
      end;
    end;

    for x:=length(url) downto 1 do
    begin
      if url[x]='/' then
      begin
        result.FPath:=copy(url,1,x-1);
        delete(url,1,x);
        break;
      end;
    end;

    { Check if the server has a port assigned to it }
    If Length(result.FServer)>0 then
    begin
      xpos:=pos(':',Result.FServer);
      if xpos>0 then
      begin
        Result.FPort:=Copy(Result.FServer,xpos+1,length(result.FServer));
        Delete(result.FServer,xpos,length(result.FServer));
      end;
    end;

    { finally, we are left with the file }
    result.FFile:=trim(url)
  End;

  Function THexUrlMoniker.EncodeUrlSyntax(Url: THexUniformResource):String;
  Begin
    result:=url.FProtocol;

    if length(url.FServer)>0 then
    result:=result + url.fserver + '/';

    if length(url.FPath)>0 then
    result:=result + url.FPath +'/';

    result:=result + url.FFile + url.FParams;
  End;

  { Url optimizer
    =============
    The optimize routine will basicly take care of backwards
    path references like, ../../images/picture1.gif.
    Depending on the path itself (and server name), the optimized
    adresse will be a direct url, without the ../ references...
  }
  Procedure THexUrlMoniker.OptimizeUrlSyntax(var Url: THexUniformResource);
  Begin
    //
  End;

  Function THexUrlMoniker.Instr(Var Buffer: String;Position:Integer;Clause:String):Integer;
  var
    Xpos: Integer;
    SMax: Integer;
  Begin
    result:=0;
    SMax:=Length(Buffer);
    XPos:=Position;

    if (Xpos<1) then XPos:=1;
    if (xpos>SMax) then
    exit;

    if length(Clause)=0 then
    exit;

    while (Xpos<SMax) do
    begin
      if Buffer[xpos]=Clause[1] then
      begin
        If Copy(buffer,xpos,length(Clause))=Clause then
        begin
          result:=xpos;
          Break;
        end;
      end;
      inc(xpos);
    end;
  End;

  end.
