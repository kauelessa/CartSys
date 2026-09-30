unit Shared.DAL.ClienteRepository;

interface

uses
  FireDAC.Comp.Client,
  Shared.Model.Entities,
  Shared.Interfaces.Repository,
  Shared.DAL.Repository;

type
  TClienteRepository = class(TRepositoryBase<TCliente>, IRepository<TCliente>)
  protected
    function MontarSqlSelectPorId: string; override;
    function MontarSqlSelectTodos: string; override;
    function MontarSqlInsert: string; override;
    function MontarSqlUpdate: string; override;
    procedure PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TCliente); override;
    procedure PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TCliente); override;
  public
    constructor Create(const AConnection: TFDConnection);
  end;

implementation

constructor TClienteRepository.Create(const AConnection: TFDConnection);
begin
  inherited Create(AConnection, 'CLIENTES');
end;

function TClienteRepository.MontarSqlSelectPorId: string;
begin
  Result := 'SELECT * FROM CLIENTES WHERE ID = :ID';
end;

function TClienteRepository.MontarSqlSelectTodos: string;
begin
  Result := 'SELECT * FROM CLIENTES ORDER BY NOME';
end;

function TClienteRepository.MontarSqlInsert: string;
begin
  Result :=
    'INSERT INTO CLIENTES (NOME, DOCUMENTO, EMAIL, TELEFONE, ENDERECO, CIDADE, UF, ATIVO) ' +
    'VALUES (:NOME, :DOCUMENTO, :EMAIL, :TELEFONE, :ENDERECO, :CIDADE, :UF, :ATIVO)';
end;

function TClienteRepository.MontarSqlUpdate: string;
begin
  Result :=
    'UPDATE CLIENTES SET NOME = :NOME, DOCUMENTO = :DOCUMENTO, EMAIL = :EMAIL, ' +
    'TELEFONE = :TELEFONE, ENDERECO = :ENDERECO, CIDADE = :CIDADE, UF = :UF, ATIVO = :ATIVO ' +
    'WHERE ID = :ID';
end;

procedure TClienteRepository.PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TCliente);
begin
  AQuery.ParamByName('NOME').AsString := AEntidade.Nome;
  AQuery.ParamByName('DOCUMENTO').AsString := AEntidade.Documento;
  AQuery.ParamByName('EMAIL').AsString := AEntidade.Email;
  AQuery.ParamByName('TELEFONE').AsString := AEntidade.Telefone;
  AQuery.ParamByName('ENDERECO').AsString := AEntidade.Endereco;
  AQuery.ParamByName('CIDADE').AsString := AEntidade.Cidade;
  AQuery.ParamByName('UF').AsString := AEntidade.Uf;
  AQuery.ParamByName('ATIVO').AsInteger := Ord(AEntidade.Ativo);
end;

procedure TClienteRepository.PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TCliente);
begin
  AQuery.ParamByName('ID').AsInteger := AEntidade.Id;
  PreencherParametrosInsert(AQuery, AEntidade);
end;

end.
