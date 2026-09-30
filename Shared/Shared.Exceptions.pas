unit Shared.Exceptions;

interface

uses
  System.SysUtils;

type
  ECartSysException = class(Exception);

  ERegistroNaoEncontradoException = class(ECartSysException)
  public
    constructor Create(const AEntidade: string; const AId: Integer);
  end;

  EValidacaoException = class(ECartSysException);

  ECredenciaisInvalidasException = class(ECartSysException);

  EUsuarioBloqueadoException = class(ECartSysException)
  public
    constructor Create(const ALogin: string);
  end;

  EConexaoBancoException = class(ECartSysException)
  public
    constructor Create(const AMensagemOriginal: string);
  end;

implementation

{ ERegistroNaoEncontradoException }

constructor ERegistroNaoEncontradoException.Create(const AEntidade: string; const AId: Integer);
begin
  inherited CreateFmt('Registro de "%s" com ID %d não foi encontrado.', [AEntidade, AId]);
end;

{ EUsuarioBloqueadoException }

constructor EUsuarioBloqueadoException.Create(const ALogin: string);
begin
  inherited CreateFmt('O usuário "%s" está bloqueado devido a tentativas de acesso inválidas.', [ALogin]);
end;

{ EConexaoBancoException }

constructor EConexaoBancoException.Create(const AMensagemOriginal: string);
begin
  inherited CreateFmt('Falha ao conectar ao banco de dados: %s', [AMensagemOriginal]);
end;

end.
