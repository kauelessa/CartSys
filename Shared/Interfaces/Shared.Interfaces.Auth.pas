unit Shared.Interfaces.Auth;

interface

uses
  Shared.Model.Entities,
  Shared.Interfaces.Repository;

type
  IUsuarioRepository = interface(IRepository<TUsuario>)
    ['{A1B2C3D4-2222-4A2B-9C3D-000000000002}']
    function GetByLogin(const ALogin: string): TUsuario;
  end;

  TOnLoginFalhouEvent = procedure(Sender: TObject; const ALogin, AMotivo: string) of object;
  TOnUsuarioBloqueadoEvent = procedure(Sender: TObject; const AUsuario: TUsuario) of object;
  TOnLoginSucessoEvent = procedure(Sender: TObject; const AUsuario: TUsuario) of object;

  IAuthService = interface
    ['{A1B2C3D4-3333-4A2B-9C3D-000000000003}']
    function Login(const ALogin, ASenha, ACodigoTotp: string): TUsuario;
    procedure DesbloquearUsuario(const AIdUsuario: Integer);

    procedure SetOnLoginFalhou(const AEvent: TOnLoginFalhouEvent);
    procedure SetOnUsuarioBloqueado(const AEvent: TOnUsuarioBloqueadoEvent);
    procedure SetOnLoginSucesso(const AEvent: TOnLoginSucessoEvent);
  end;

implementation

end.
