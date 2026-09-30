unit Shared.Auth.Login;

interface

uses
  System.Classes,
  System.SysUtils,
  Shared.Model.Entities,
  Shared.Interfaces.Auth,
  Shared.Auth.AuthService,
  Shared.DAL.UsuarioRepository,
  Shared.Data.Connection,
  Shared.Exceptions;

type
  TOnAutenticacaoSucessoEvent = procedure(Sender: TObject; const AUsuario: TUsuario) of object;
  TOnAutenticacaoErroEvent = procedure(Sender: TObject; const AMensagem: string) of object;
  TOnAutenticacaoBloqueadoEvent = procedure(Sender: TObject; const AUsuario: TUsuario) of object;

  TLoginController = class
  private
    FAuthService: IAuthService;
    FUsuarioRepository: IUsuarioRepository;

    FOnAutenticacaoSucesso: TOnAutenticacaoSucessoEvent;
    FOnAutenticacaoErro: TOnAutenticacaoErroEvent;
    FOnAutenticacaoBloqueado: TOnAutenticacaoBloqueadoEvent;

    procedure HandleLoginFalhou(Sender: TObject; const ALogin, AMotivo: string);
    procedure HandleUsuarioBloqueado(Sender: TObject; const AUsuario: TUsuario);
    procedure HandleLoginSucesso(Sender: TObject; const AUsuario: TUsuario);
  public
    constructor Create;

    procedure AutenticarAsync(const ALogin, ASenha, ACodigoTotp: string);
    procedure DesbloquearUsuario(const AIdUsuario: Integer);

    property OnAutenticacaoSucesso: TOnAutenticacaoSucessoEvent
      read FOnAutenticacaoSucesso write FOnAutenticacaoSucesso;
    property OnAutenticacaoErro: TOnAutenticacaoErroEvent
      read FOnAutenticacaoErro write FOnAutenticacaoErro;
    property OnAutenticacaoBloqueado: TOnAutenticacaoBloqueadoEvent
      read FOnAutenticacaoBloqueado write FOnAutenticacaoBloqueado;
  end;

implementation

type
  /// <summary>
  /// Thread responsável por executar o login sem travar a UI.
  /// Recebe os dados como parâmetros do construtor e devolve o
  /// resultado (sucesso ou erro) via Synchronize.
  /// </summary>
  TLoginThread = class(TThread)
  private
    FAuthService: IAuthService;
    FLogin, FSenha, FCodigoTotp: string;
    FUsuarioResultado: TUsuario;
    FErroCapturado: Exception;
    FControllerRef: TLoginController;

    procedure NotificarSucesso;
    procedure NotificarErro;
  protected
    procedure Execute; override;
  public
    constructor Create(const AAuthService: IAuthService; const AController: TLoginController;
      const ALogin, ASenha, ACodigoTotp: string);
    destructor Destroy; override;
  end;

{ TLoginThread }

constructor TLoginThread.Create(const AAuthService: IAuthService; const AController: TLoginController;
  const ALogin, ASenha, ACodigoTotp: string);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FAuthService := AAuthService;
  FControllerRef := AController;
  FLogin := ALogin;
  FSenha := ASenha;
  FCodigoTotp := ACodigoTotp;
  FUsuarioResultado := nil;
  FErroCapturado := nil;
end;

destructor TLoginThread.Destroy;
begin
  FUsuarioResultado.Free;
  FErroCapturado.Free;
  inherited Destroy;
end;

procedure TLoginThread.Execute;
begin
  try
    FUsuarioResultado := FAuthService.Login(FLogin, FSenha, FCodigoTotp);
    Synchronize(NotificarSucesso);
  except
    on E: Exception do
    begin
      FErroCapturado := Exception(AcquireExceptionObject);
      Synchronize(NotificarErro);
    end;
  end;
end;

procedure TLoginThread.NotificarSucesso;
begin
  if Assigned(FControllerRef.FOnAutenticacaoSucesso) then
    FControllerRef.FOnAutenticacaoSucesso(FControllerRef, FUsuarioResultado);

    FUsuarioResultado := nil;
end;

procedure TLoginThread.NotificarErro;
begin
  if FErroCapturado is EUsuarioBloqueadoException then
  begin
    if Assigned(FControllerRef.FOnAutenticacaoBloqueado) then
      FControllerRef.FOnAutenticacaoBloqueado(FControllerRef, nil);
  end;

  if Assigned(FControllerRef.FOnAutenticacaoErro) then
    FControllerRef.FOnAutenticacaoErro(FControllerRef, FErroCapturado.Message);
end;

{ TLoginController }

constructor TLoginController.Create;
begin
  inherited Create;
  FUsuarioRepository := TUsuarioRepository.Create(TConnectionManager.GetConnection);
  FAuthService := TAuthService.Create(FUsuarioRepository);

  FAuthService.SetOnLoginFalhou(HandleLoginFalhou);
  FAuthService.SetOnUsuarioBloqueado(HandleUsuarioBloqueado);
  FAuthService.SetOnLoginSucesso(HandleLoginSucesso);
end;

procedure TLoginController.HandleLoginFalhou(Sender: TObject; const ALogin, AMotivo: string);
begin
  // Aqui poderíamos gravar em LOG_ACESSO futuramente
end;

procedure TLoginController.HandleUsuarioBloqueado(Sender: TObject; const AUsuario: TUsuario);
begin
  // Notificação já é repassada pela própria thread (NotificarErro)
end;

procedure TLoginController.HandleLoginSucesso(Sender: TObject; const AUsuario: TUsuario);
begin
  // Notificação já é repassada pela própria thread (NotificarSucesso)
end;

procedure TLoginController.AutenticarAsync(const ALogin, ASenha, ACodigoTotp: string);
begin
  TLoginThread.Create(FAuthService, Self, ALogin, ASenha, ACodigoTotp).Start;
end;

procedure TLoginController.DesbloquearUsuario(const AIdUsuario: Integer);
begin
  FAuthService.DesbloquearUsuario(AIdUsuario);
end;

end.
