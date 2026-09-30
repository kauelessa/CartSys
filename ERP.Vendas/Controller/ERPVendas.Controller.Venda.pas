unit ERPVendas.Controller.Venda;

interface

uses
  System.Generics.Collections,
  Shared.Model.Entities,
  Shared.DAL.VendaRepository,
  Shared.DAL.ClienteRepository,
  Shared.DAL.ProdutoRepository,
  Shared.Data.Connection;

type
  TVendaController = class
  private
    FVendaRepository: TVendaRepository;
    FClienteRepository: TClienteRepository;
    FProdutoRepository: TProdutoRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function ListarClientes: TObjectList<TCliente>;
    function ListarProdutos: TObjectList<TProduto>;
    function ListarVendas: TObjectList<TVenda>;
    function ObterVenda(const AId: Integer): TVenda;
    function SalvarVenda(const AVenda: TVenda): Integer;
  end;

implementation

constructor TVendaController.Create;
begin
  inherited Create;
  FVendaRepository := TVendaRepository.Create(TConnectionManager.GetConnection);
  FClienteRepository := TClienteRepository.Create(TConnectionManager.GetConnection);
  FProdutoRepository := TProdutoRepository.Create(TConnectionManager.GetConnection);
end;

destructor TVendaController.Destroy;
begin
  FVendaRepository.Free;
  FClienteRepository.Free;
  FProdutoRepository.Free;
  inherited Destroy;
end;

function TVendaController.ListarClientes: TObjectList<TCliente>;
begin
  Result := FClienteRepository.GetAll;
end;

function TVendaController.ListarProdutos: TObjectList<TProduto>;
begin
  Result := FProdutoRepository.GetAll;
end;

function TVendaController.ListarVendas: TObjectList<TVenda>;
begin
  Result := FVendaRepository.GetAll;
end;

function TVendaController.ObterVenda(const AId: Integer): TVenda;
begin
  Result := FVendaRepository.GetById(AId);
end;

function TVendaController.SalvarVenda(const AVenda: TVenda): Integer;
begin
  Result := FVendaRepository.Add(AVenda);
end;

end.
