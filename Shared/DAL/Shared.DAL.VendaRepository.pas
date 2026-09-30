unit Shared.DAL.VendaRepository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Shared.Model.Entities,
  Shared.Interfaces.Repository,
  Shared.DAL.Repository,
  Shared.Utils.RTTIHelper,
  Shared.Exceptions;

type
  TVendaRepository = class(TRepositoryBase<TVenda>, IRepository<TVenda>)
  protected
    function MontarSqlSelectPorId: string; override;
    function MontarSqlSelectTodos: string; override;
    function MontarSqlInsert: string; override;
    function MontarSqlUpdate: string; override;
    procedure PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TVenda); override;
    procedure PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TVenda); override;
  public
    constructor Create(const AConnection: TFDConnection);

    function GetById(const AId: Integer): TVenda; override;
    function Add(const AEntidade: TVenda): Integer; override;
    function GetPendentes: TObjectList<TVenda>;
  end;

implementation

{ TVendaRepository }

constructor TVendaRepository.Create(const AConnection: TFDConnection);
begin
  inherited Create(AConnection, 'VENDAS');
end;

function TVendaRepository.MontarSqlSelectPorId: string;
begin
  Result := 'SELECT * FROM VENDAS WHERE ID = :ID';
end;

function TVendaRepository.MontarSqlSelectTodos: string;
begin
  Result := 'SELECT * FROM VENDAS ORDER BY DATA_VENDA DESC';
end;

function TVendaRepository.MontarSqlInsert: string;
begin
  Result :=
    'INSERT INTO VENDAS (ID_CLIENTE, ID_USUARIO, VALOR_TOTAL, STATUS, OBSERVACAO) ' +
    'VALUES (:ID_CLIENTE, :ID_USUARIO, :VALOR_TOTAL, :STATUS, :OBSERVACAO)';
end;

function TVendaRepository.MontarSqlUpdate: string;
begin
  Result :=
    'UPDATE VENDAS SET ID_CLIENTE = :ID_CLIENTE, VALOR_TOTAL = :VALOR_TOTAL, ' +
    'STATUS = :STATUS, OBSERVACAO = :OBSERVACAO WHERE ID = :ID';
end;

procedure TVendaRepository.PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: TVenda);
begin
  AQuery.ParamByName('ID_CLIENTE').AsInteger := AEntidade.IdCliente;
  AQuery.ParamByName('ID_USUARIO').AsInteger := AEntidade.IdUsuario;
  AQuery.ParamByName('VALOR_TOTAL').AsCurrency := AEntidade.ValorTotal;
  AQuery.ParamByName('STATUS').AsInteger := Ord(AEntidade.Status);
  AQuery.ParamByName('OBSERVACAO').AsString := AEntidade.Observacao;
end;

procedure TVendaRepository.PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: TVenda);
begin
  AQuery.ParamByName('ID').AsInteger := AEntidade.Id;
  AQuery.ParamByName('ID_CLIENTE').AsInteger := AEntidade.IdCliente;
  AQuery.ParamByName('VALOR_TOTAL').AsCurrency := AEntidade.ValorTotal;
  AQuery.ParamByName('STATUS').AsInteger := Ord(AEntidade.Status);
  AQuery.ParamByName('OBSERVACAO').AsString := AEntidade.Observacao;
end;

function TVendaRepository.GetById(const AId: Integer): TVenda;
var
  LQueryItens: TFDQuery;
  LItem: TItemVenda;
begin
  Result := inherited GetById(AId);

  LQueryItens := TFDQuery.Create(nil);
  try
    try
      LQueryItens.Connection := FConnection;
      LQueryItens.SQL.Text := 'SELECT * FROM ITENS_VENDA WHERE ID_VENDA = :ID_VENDA';
      LQueryItens.ParamByName('ID_VENDA').AsInteger := AId;
      LQueryItens.Open;

      while not LQueryItens.Eof do
      begin
        LItem := TItemVenda.Create;
        TRTTIMapper.PreencherObjeto(LItem, LQueryItens);
        Result.Itens.Add(LItem);
        LQueryItens.Next;
      end;
    except
      on E: Exception do
        raise ECartSysException.CreateFmt('Erro ao carregar itens da venda %d: %s', [AId, E.Message]);
    end;
  finally
    LQueryItens.Free;
  end;
end;

function TVendaRepository.Add(const AEntidade: TVenda): Integer;
var
  LQuery: TFDQuery;
  LItem: TItemVenda;
begin
  FConnection.StartTransaction;
  try
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FConnection;

      // Cabeçalho da venda
      LQuery.SQL.Text := MontarSqlInsert;
      PreencherParametrosInsert(LQuery, AEntidade);
      LQuery.ExecSQL;

      LQuery.SQL.Text := 'SELECT GEN_ID(SEQ_VENDAS, 0) AS NOVO_ID FROM RDB$DATABASE';
      LQuery.Open;
      Result := LQuery.FieldByName('NOVO_ID').AsInteger;
      LQuery.Close;

      // Itens da venda
      for LItem in AEntidade.Itens do
      begin
        LQuery.SQL.Text :=
          'INSERT INTO ITENS_VENDA (ID_VENDA, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO, SUBTOTAL) ' +
          'VALUES (:ID_VENDA, :ID_PRODUTO, :QUANTIDADE, :PRECO_UNITARIO, :SUBTOTAL)';
        LQuery.ParamByName('ID_VENDA').AsInteger := Result;
        LQuery.ParamByName('ID_PRODUTO').AsInteger := LItem.IdProduto;
        LQuery.ParamByName('QUANTIDADE').AsInteger := LItem.Quantidade;
        LQuery.ParamByName('PRECO_UNITARIO').AsCurrency := LItem.PrecoUnitario;
        LQuery.ParamByName('SUBTOTAL').AsCurrency := LItem.Subtotal;
        LQuery.ExecSQL;

        // Baixa de estoque
        LQuery.SQL.Text := 'UPDATE PRODUTOS SET ESTOQUE = ESTOQUE - :QTD WHERE ID = :ID_PRODUTO';
        LQuery.ParamByName('QTD').AsInteger := LItem.Quantidade;
        LQuery.ParamByName('ID_PRODUTO').AsInteger := LItem.IdProduto;
        LQuery.ExecSQL;
      end;
    finally
      LQuery.Free;
    end;

    FConnection.Commit;
  except
    on E: Exception do
    begin
      FConnection.Rollback;
      raise ECartSysException.CreateFmt('Erro ao gravar venda: %s', [E.Message]);
    end;
  end;
end;

function TVendaRepository.GetPendentes: TObjectList<TVenda>;
var
  LQuery: TFDQuery;
  LVenda: TVenda;
begin
  Result := TObjectList<TVenda>.Create(True);
  try
    LQuery := TFDQuery.Create(nil);
    try
      try
        LQuery.Connection := FConnection;
        LQuery.SQL.Text :=
          'SELECT V.*, C.NOME AS NOME_CLIENTE FROM VENDAS V ' +
          'JOIN CLIENTES C ON C.ID = V.ID_CLIENTE ' +
          'WHERE V.STATUS = 0 ORDER BY V.DATA_VENDA';
        LQuery.Open;

        while not LQuery.Eof do
        begin
          LVenda := TVenda.Create;
          TRTTIMapper.PreencherObjeto(LVenda, LQuery);
          Result.Add(LVenda);
          LQuery.Next;
        end;
      except
        on E: Exception do
          raise ECartSysException.CreateFmt('Erro ao listar vendas pendentes: %s', [E.Message]);
      end;
    finally
      LQuery.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
