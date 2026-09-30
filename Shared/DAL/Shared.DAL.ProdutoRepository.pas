unit Shared.DAL.ProdutoRepository;

interface

uses
  FireDAC.Comp.Client,
  Shared.Model.Entities,
  Shared.Interfaces.Repository,
  Shared.DAL.Repository;

type
  TProdutoRepository = class(TRepositoryBase<TProduto>, IRepository<TProduto>)
  protected
    function MontarSqlSelectPorId: string; override;
    function MontarSqlSelectTodos: string; override;
    function MontarSqlInsert: string; override;
    function MontarSqlUpdate: string; override;
    procedure PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TProduto); override;
    procedure PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TProduto); override;
  public
    constructor Create(const AConnection: TFDConnection);
  end;

implementation

constructor TProdutoRepository.Create(const AConnection: TFDConnection);
begin
  inherited Create(AConnection, 'PRODUTOS');
end;

function TProdutoRepository.MontarSqlSelectPorId: string;
begin
  Result := 'SELECT * FROM PRODUTOS WHERE ID = :ID';
end;

function TProdutoRepository.MontarSqlSelectTodos: string;
begin
  Result := 'SELECT * FROM PRODUTOS ORDER BY DESCRICAO';
end;

function TProdutoRepository.MontarSqlInsert: string;
begin
  Result :=
    'INSERT INTO PRODUTOS (DESCRICAO, CODIGO_BARRAS, PRECO_VENDA, ESTOQUE, ATIVO) ' +
    'VALUES (:DESCRICAO, :CODIGO_BARRAS, :PRECO_VENDA, :ESTOQUE, :ATIVO)';
end;

function TProdutoRepository.MontarSqlUpdate: string;
begin
  Result :=
    'UPDATE PRODUTOS SET DESCRICAO = :DESCRICAO, CODIGO_BARRAS = :CODIGO_BARRAS, ' +
    'PRECO_VENDA = :PRECO_VENDA, ESTOQUE = :ESTOQUE, ATIVO = :ATIVO WHERE ID = :ID';
end;

procedure TProdutoRepository.PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TProduto);
begin
  AQuery.ParamByName('DESCRICAO').AsString := AEntidade.Descricao;
  AQuery.ParamByName('CODIGO_BARRAS').AsString := AEntidade.CodigoBarras;
  AQuery.ParamByName('PRECO_VENDA').AsCurrency := AEntidade.PrecoVenda;
  AQuery.ParamByName('ESTOQUE').AsInteger := AEntidade.Estoque;
  AQuery.ParamByName('ATIVO').AsInteger := Ord(AEntidade.Ativo);
end;

procedure TProdutoRepository.PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TProduto);
begin
  AQuery.ParamByName('ID').AsInteger := AEntidade.Id;
  PreencherParametrosInsert(AQuery, AEntidade);
end;

end.
