unit Shared.DAL.Repository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Shared.Interfaces.Repository,
  Shared.Utils.RTTIHelper,
  Shared.Exceptions;

type
  /// <summary>
  /// Repositório genérico base. Cada repositório concreto (ex: TClienteRepository)
  /// deve herdar desta classe e informar o nome da tabela e a query de SELECT.
  /// </summary>
  TRepositoryBase<T: class, constructor> = class(TInterfacedObject, IRepository<T>)
  protected
    FConnection: TFDConnection;
    FNomeTabela: string;

    function MontarSqlSelectPorId: string; virtual; abstract;
    function MontarSqlSelectTodos: string; virtual; abstract;
    procedure PreencherParametrosInsert(const AQuery: TFDQuery; const AEntidade: T); virtual; abstract;
    procedure PreencherParametrosUpdate(const AQuery: TFDQuery; const AEntidade: T); virtual; abstract;
    function MontarSqlInsert: string; virtual; abstract;
    function MontarSqlUpdate: string; virtual; abstract;
  public
    constructor Create(const AConnection: TFDConnection; const ANomeTabela: string);

    function GetById(const AId: Integer): T; virtual;
    function GetAll: TObjectList<T>; virtual;
    function Add(const AEntidade: T): Integer; virtual;
    procedure Update(const AEntidade: T); virtual;
    procedure Delete(const AId: Integer); virtual;
  end;

implementation

{ TRepositoryBase<T> }

constructor TRepositoryBase<T>.Create(const AConnection: TFDConnection; const ANomeTabela: string);
begin
  inherited Create;
  FConnection := AConnection;
  FNomeTabela := ANomeTabela;
end;

function TRepositoryBase<T>.GetById(const AId: Integer): T;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TFDQuery.Create(nil);
  try
    try
      LQuery.Connection := FConnection;
      LQuery.SQL.Text := MontarSqlSelectPorId;
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.Open;

      if LQuery.IsEmpty then
        raise ERegistroNaoEncontradoException.Create(FNomeTabela, AId);

      Result := T.Create;
      TRTTIMapper.PreencherObjeto(Result, LQuery);
    except
      on E: ERegistroNaoEncontradoException do
        raise;
      on E: Exception do
        raise ECartSysException.CreateFmt(
          'Erro ao buscar registro em "%s" (ID %d): %s', [FNomeTabela, AId, E.Message]);
    end;
  finally
    LQuery.Free;
  end;
end;

function TRepositoryBase<T>.GetAll: TObjectList<T>;
var
  LQuery: TFDQuery;
  LItem: T;
begin
  Result := TObjectList<T>.Create(True);
  try
    LQuery := TFDQuery.Create(nil);
    try
      try
        LQuery.Connection := FConnection;
        LQuery.SQL.Text := MontarSqlSelectTodos;
        LQuery.Open;

        while not LQuery.Eof do
        begin
          LItem := T.Create;
          TRTTIMapper.PreencherObjeto(LItem, LQuery);
          Result.Add(LItem);
          LQuery.Next;
        end;
      except
        on E: Exception do
          raise ECartSysException.CreateFmt(
            'Erro ao listar registros de "%s": %s', [FNomeTabela, E.Message]);
      end;
    finally
      LQuery.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TRepositoryBase<T>.Add(const AEntidade: T): Integer;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    try
      LQuery.Connection := FConnection;
      LQuery.SQL.Text := MontarSqlInsert;
      PreencherParametrosInsert(LQuery, AEntidade);
      LQuery.ExecSQL;

      LQuery.SQL.Text := Format('SELECT GEN_ID(SEQ_%s, 0) AS NOVO_ID FROM RDB$DATABASE', [FNomeTabela]);
      LQuery.Open;
      Result := LQuery.FieldByName('NOVO_ID').AsInteger;
    except
      on E: Exception do
        raise ECartSysException.CreateFmt(
          'Erro ao inserir registro em "%s": %s', [FNomeTabela, E.Message]);
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TRepositoryBase<T>.Update(const AEntidade: T);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    try
      LQuery.Connection := FConnection;
      LQuery.SQL.Text := MontarSqlUpdate;
      PreencherParametrosUpdate(LQuery, AEntidade);
      LQuery.ExecSQL;
    except
      on E: Exception do
        raise ECartSysException.CreateFmt(
          'Erro ao atualizar registro em "%s": %s', [FNomeTabela, E.Message]);
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TRepositoryBase<T>.Delete(const AId: Integer);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    try
      LQuery.Connection := FConnection;
      LQuery.SQL.Text := Format('DELETE FROM %s WHERE ID = :ID', [FNomeTabela]);
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
    except
      on E: Exception do
        raise ECartSysException.CreateFmt(
          'Erro ao excluir registro em "%s" (ID %d): %s', [FNomeTabela, AId, E.Message]);
    end;
  finally
    LQuery.Free;
  end;
end;

end.
