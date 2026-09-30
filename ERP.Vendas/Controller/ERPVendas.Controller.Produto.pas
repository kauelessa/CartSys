unit ERPVendas.Controller.Produto;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Shared.Model.Entities,
  Shared.Interfaces.Repository,
  Shared.DAL.ProdutoRepository,
  Shared.Data.Connection,
  Shared.Exceptions;

type
  TProdutoController = class
  private
    FRepository: IRepository<TProduto>;
    procedure Validar(const AProduto: TProduto);
  public
    constructor Create;

    function ListarTodos: TObjectList<TProduto>;
    function BuscarPorId(const AId: Integer): TProduto;
    function Salvar(const AProduto: TProduto): Integer;
    procedure Excluir(const AId: Integer);
  end;

implementation

constructor TProdutoController.Create;
begin
  inherited Create;
  FRepository := TProdutoRepository.Create(TConnectionManager.GetConnection);
end;

procedure TProdutoController.Validar(const AProduto: TProduto);
begin
  if Trim(AProduto.Descricao) = '' then
    raise EValidacaoException.Create('A descrição do produto é obrigatória.');

  if AProduto.PrecoVenda <= 0 then
    raise EValidacaoException.Create('O preço de venda deve ser maior que zero.');

  if AProduto.Estoque < 0 then
    raise EValidacaoException.Create('O estoque não pode ser negativo.');
end;

function TProdutoController.ListarTodos: TObjectList<TProduto>;
begin
  Result := FRepository.GetAll;
end;

function TProdutoController.BuscarPorId(const AId: Integer): TProduto;
begin
  Result := FRepository.GetById(AId);
end;

function TProdutoController.Salvar(const AProduto: TProduto): Integer;
begin
  Validar(AProduto);

  if AProduto.Id = 0 then
    Result := FRepository.Add(AProduto)
  else
  begin
    FRepository.Update(AProduto);
    Result := AProduto.Id;
  end;
end;

procedure TProdutoController.Excluir(const AId: Integer);
begin
  FRepository.Delete(AId);
end;

end.
