unit Shared.Auth.PasswordHasher;

interface

uses
  System.SysUtils,
  System.Hash;

type
  TPasswordHasher = class
  public
    class function GerarSalt: string; static;
    class function GerarHash(const ASenha, ASalt: string): string; static;
    class function ValidarSenha(const ASenha, ASalt, AHashArmazenado: string): Boolean; static;
  end;

implementation

{ TPasswordHasher }

class function TPasswordHasher.GerarSalt: string;
var
  LGuid: TGUID;
begin
  CreateGUID(LGuid);
  Result := GUIDToString(LGuid).Replace('{', '').Replace('}', '').Replace('-', '');
end;

class function TPasswordHasher.GerarHash(const ASenha, ASalt: string): string;
begin
  Result := THashSHA2.GetHashString(ASenha + ASalt, THashSHA2.TSHA2Version.SHA256);
end;

class function TPasswordHasher.ValidarSenha(const ASenha, ASalt, AHashArmazenado: string): Boolean;
begin
  Result := SameText(GerarHash(ASenha, ASalt), AHashArmazenado);
end;

end.
