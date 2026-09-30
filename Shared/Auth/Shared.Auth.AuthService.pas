unit Shared.Auth.AuthService;

interface

uses
  System.SysUtils,
  Shared.Model.Entities,
  Shared.Interfaces.Auth,
  Shared.Auth.TOTP,
  Shared.Auth.PasswordHasher,
  Shared.Exceptions;

const
  MAX_TENTATIVAS_FALHAS = 3;

type
  TAuthService = class(TInterfacedObject, IAuthService)
  private
    FUsuarioRepository: IUsuarioRepository;
    FOnLoginFalhou: TOnLoginFalhouEvent;
    FOnUsuarioBloqueado: TOnUsuarioBloqueadoEvent;
    FOnLoginSucesso: TOnLoginSucessoEvent;

    procedure RegistrarTentativaFalha(const AUsuario: TUsuario; const AMotivo: string);
  public
    constructor Create(const AUsuarioRepository: IUsuarioRepository);

    function Login(const ALogin, ASenha, ACodigoTotp: string): TUsuario;
    procedure DesbloquearUsuario(const AIdUsuario: Integer);

    procedure SetOnLoginFalhou(const AEvent: TOnLoginFalhouEvent);
    procedure SetOnUsuarioBloqueado(const AEvent: TOnUsuarioBloqueadoEvent);
    procedure SetOnLoginSucesso(const AEvent: TOnLoginSucessoEvent);
  end;

implementation

{ TAuthService }

constructor TAuthService.Create(const AUsuarioRepository: IUsuarioRepository);
begin
  inherited Create;
  FUsuarioRepository := AUsuarioRepository;
end;

procedure TAuthService.SetOnLoginFalhou(const AEvent: TOnLoginFalhouEvent);
begin
  FOnLoginFalhou := AEvent;
end;

procedure TAuthService.SetOnUsuarioBloqueado(const AEvent: TOnUsuarioBloqueadoEvent);
begin
  FOnUsuarioBloqueado := AEvent;
end;

procedure TAuthService.SetOnLoginSucesso(const AEvent: TOnLoginSucessoEvent);
begin
  FOnLoginSucesso := AEvent;
end;

procedure TAuthService.RegistrarTentativaFalha(const AUsuario: TUsuario; const AMotivo: string);
begin
  AUsuario.TentativasFalhas := AUsuario.TentativasFalhas + 1;

  if AUsuario.TentativasFalhas >= MAX_TENTATIVAS_FALHAS then
  begin
    AUsuario.Bloqueado := True;
    FUsuarioRepository.Update(AUsuario);

    if Assigned(FOnUsuarioBloqueado) then
      FOnUsuarioBloqueado(Self, AUsuario);
  end
  else
    FUsuarioRepository.Update(AUsuario);

  if Assigned(FOnLoginFalhou) then
    FOnLoginFalhou(Self, AUsuario.Login, AMotivo);
end;

function TAuthService.Login(const ALogin, ASenha, ACodigoTotp: string): TUsuario;
var
  LUsuario: TUsuario;
begin
  LUsuario := FUsuarioRepository.GetByLogin(ALogin);
  try
    if not Assigned(LUsuario) then
    begin
      if Assigned(FOnLoginFalhou) then
        FOnLoginFalhou(Self, ALogin, 'Usuário não encontrado.');
      raise ECredenciaisInvalidasException.Create('Login ou senha inválidos.');
    end;

    if LUsuario.Bloqueado then
    begin
      if Assigned(FOnUsuarioBloqueado) then
        FOnUsuarioBloqueado(Self, LUsuario);
      raise EUsuarioBloqueadoException.Create(ALogin);
    end;

    if not TPasswordHasher.ValidarSenha(ASenha, LUsuario.SenhaSalt, LUsuario.SenhaHash) then
    begin
      RegistrarTentativaFalha(LUsuario, 'Senha incorreta.');
      raise ECredenciaisInvalidasException.Create('Login ou senha inválidos.');
    end;

    if not TTOTPHelper.ValidarCodigo(LUsuario.TotpSecret, ACodigoTotp) then
    begin
      RegistrarTentativaFalha(LUsuario, 'Contra senha (TOTP) incorreta.');
      raise ECredenciaisInvalidasException.Create('Código de verificação inválido.');
    end;

    LUsuario.TentativasFalhas := 0;
    FUsuarioRepository.Update(LUsuario);

    if Assigned(FOnLoginSucesso) then
      FOnLoginSucesso(Self, LUsuario);

    Result := LUsuario;
    LUsuario := nil; // repassa posse ao chamador, evita duplo Free
  finally
    LUsuario.Free;
  end;
end;

procedure TAuthService.DesbloquearUsuario(const AIdUsuario: Integer);
var
  LUsuario: TUsuario;
begin
  LUsuario := FUsuarioRepository.GetById(AIdUsuario);
  try
    LUsuario.Bloqueado := False;
    LUsuario.TentativasFalhas := 0;
    FUsuarioRepository.Update(LUsuario);
  finally
    LUsuario.Free;
  end;
end;

end.
