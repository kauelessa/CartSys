unit ERPVendas.Controller.Cliente;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Shared.Model.Entities,
  Shared.Interfaces.Repository,
  Shared.DAL.ClienteRepository,
  Shared.Data.Connection,
  Shared.Exceptions;

type
  TClienteController = class
  private
    FRepository: IRepository<TCliente>;
    procedure Validar(const ACliente: TCliente);
  public
    constructor Create;

    function ListarTodos: TObjectList<TCliente>;
    function BuscarPorId(const AId: Integer): TCliente;
    function Salvar(const ACliente: TCliente): Integer;
    procedure Excluir(const AId: Integer);
  end;

implementation

constructor TClienteController.Create;
begin
  inherited Create;
  FRepository := TClienteRepository.Create(TConnectionManager.GetConnection);
end;

procedure TClienteController.Validar(const ACliente: TCliente);
begin
  if Trim(ACliente.Nome) = '' then
    raise EValidacaoException.Create('O nome do cliente é obrigatório.');

  if (Trim(ACliente.Email) <> '') and (Pos('@', ACliente.Email) = 0) then
    raise EValidacaoException.Create('O e-mail informado é inválido.');
end;

function TClienteController.ListarTodos: TObjectList<TCliente>;
begin
  Result := FRepository.GetAll;
end;

function TClienteController.BuscarPorId(const AId: Integer): TCliente;
begin
  Result := FRepository.GetById(AId);
end;

function TClienteController.Salvar(const ACliente: TCliente): Integer;
begin
  Validar(ACliente);

  if ACliente.Id = 0 then
    Result := FRepository.Add(ACliente)
  else
  begin
    FRepository.Update(ACliente);
    Result := ACliente.Id;
  end;
end;

procedure TClienteController.Excluir(const AId: Integer);
begin
  FRepository.Delete(AId);
end;

end.
