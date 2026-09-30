unit Shared.DAL.UsuarioRepository;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  Shared.Model.Entities,
  Shared.Interfaces.Auth,
  Shared.DAL.Repository,
  Shared.Utils.RTTIHelper,
  Shared.Exceptions;

type
  TUsuarioRepository = class(TRepositoryBase<TUsuario>, IUsuarioRepository)
  protected
    function MontarSqlSelectPorId: string; override;
    function MontarSqlSelectTodos: string; override;
    function MontarSqlInsert: string; override;
    function MontarSqlUpdate: string; override;
    procedure PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TUsuario); override;
    procedure PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TUsuario); override;
  public
    constructor Create(const AConnection: TFDConnection);
    function GetByLogin(const ALogin: string): TUsuario;
  end;

implementation

{ TUsuarioRepository }

constructor TUsuarioRepository.Create(const AConnection: TFDConnection);
begin
  inherited Create(AConnection, 'USUARIOS');
end;

function TUsuarioRepository.MontarSqlSelectPorId: string;
begin
  Result := 'SELECT * FROM USUARIOS WHERE ID = :ID';
end;

function TUsuarioRepository.MontarSqlSelectTodos: string;
begin
  Result := 'SELECT * FROM USUARIOS ORDER BY NOME';
end;

function TUsuarioRepository.MontarSqlInsert: string;
begin
  Result :=
    'INSERT INTO USUARIOS (LOGIN, NOME, SENHA_HASH, SENHA_SALT, TOTP_SECRET, E_ADMIN, ATIVO) ' +
    'VALUES (:LOGIN, :NOME, :SENHA_HASH, :SENHA_SALT, :TOTP_SECRET, :E_ADMIN, :ATIVO)';
end;

function TUsuarioRepository.MontarSqlUpdate: string;
begin
  Result :=
    'UPDATE USUARIOS SET NOME = :NOME, SENHA_HASH = :SENHA_HASH, SENHA_SALT = :SENHA_SALT, ' +
    'TOTP_SECRET = :TOTP_SECRET, TENTATIVAS_FALHAS = :TENTATIVAS_FALHAS, ' +
    'BLOQUEADO = :BLOQUEADO, ATIVO = :ATIVO WHERE ID = :ID';
end;

procedure TUsuarioRepository.PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TUsuario);
begin
  AQuery.ParamByName('LOGIN').AsString := AEntidade.Login;
  AQuery.ParamByName('NOME').AsString := AEntidade.Nome;
  AQuery.ParamByName('SENHA_HASH').AsString := AEntidade.SenhaHash;
  AQuery.ParamByName('SENHA_SALT').AsString := AEntidade.SenhaSalt;
  AQuery.ParamByName('TOTP_SECRET').AsString := AEntidade.TotpSecret;
  AQuery.ParamByName('E_ADMIN').AsInteger := Ord(AEntidade.EAdmin);
  AQuery.ParamByName('ATIVO').AsInteger := Ord(AEntidade.Ativo);
end;

procedure TUsuarioRepository.PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TUsuario);
begin
  AQuery.ParamByName('ID').AsInteger := AEntidade.Id;
  AQuery.ParamByName('NOME').AsString := AEntidade.Nome;
  AQuery.ParamByName('SENHA_HASH').AsString := AEntidade.SenhaHash;
  AQuery.ParamByName('SENHA_SALT').AsString := AEntidade.SenhaSalt;
  AQuery.ParamByName('TOTP_SECRET').AsString := AEntidade.TotpSecret;
  AQuery.ParamByName('TENTATIVAS_FALHAS').AsInteger := AEntidade.TentativasFalhas;
  AQuery.ParamByName('BLOQUEADO').AsInteger := Ord(AEntidade.Bloqueado);
  AQuery.ParamByName('ATIVO').AsInteger := Ord(AEntidade.Ativo);
end;

function TUsuarioRepository.GetByLogin(const ALogin: string): TUsuario;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TFDQuery.Create(nil);
  try
    try
      LQuery.Connection := FConnection;
      LQuery.SQL.Text := 'SELECT * FROM USUARIOS WHERE LOGIN = :LOGIN';
      LQuery.ParamByName('LOGIN').AsString := ALogin;
      LQuery.Open;

      if LQuery.IsEmpty then
        Exit(nil);

      Result := TUsuario.Create;
      TRTTIMapper.PreencherObjeto(Result, LQuery);
    except
      on E: Exception do
        raise ECartSysException.CreateFmt('Erro ao buscar usuário "%s": %s', [ALogin, E.Message]);
    end;
  finally
    LQuery.Free;
  end;
end;

end.
