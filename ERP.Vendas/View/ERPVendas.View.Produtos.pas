unit ERPVendas.View.Produtos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Comp.Client,
  ERPVendas.Controller.Produto,
  Shared.Model.Entities,
  Shared.Data.Connection,
  Shared.Exceptions, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TFrmProdutos = class(TForm)
    qryProdutos: TFDQuery;
    dsProdutos: TDataSource;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnAtualizar: TButton;
    grdProdutos: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    FController: TProdutoController;
    procedure CarregarLista;
  public
    class procedure Exibir;
  end;

implementation

{$R *.dfm}

uses
  ERPVendas.View.ProdutoEdit;

class procedure TFrmProdutos.Exibir;
var
  LForm: TFrmProdutos;
begin
  LForm := TFrmProdutos.Create(nil);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TFrmProdutos.FormCreate(Sender: TObject);
begin
  FController := TProdutoController.Create;
  qryProdutos.Connection := TConnectionManager.GetConnection;
  CarregarLista;
end;

procedure TFrmProdutos.FormDestroy(Sender: TObject);
begin
  FController.Free;
end;

procedure TFrmProdutos.CarregarLista;
begin
  qryProdutos.Close;
  qryProdutos.SQL.Text := 'SELECT ID, DESCRICAO, CODIGO_BARRAS, PRECO_VENDA, ESTOQUE, ATIVO FROM PRODUTOS ORDER BY DESCRICAO';
  qryProdutos.Open;
end;

procedure TFrmProdutos.btnAtualizarClick(Sender: TObject);
begin
  CarregarLista;
end;

procedure TFrmProdutos.btnNovoClick(Sender: TObject);
var
  LProduto: TProduto;
begin
  LProduto := TProduto.Create;
  try
    LProduto.Ativo := True;
    if TFrmProdutoEdit.Editar(LProduto) then
    begin
      try
        FController.Salvar(LProduto);
        CarregarLista;
      except
        on E: ECartSysException do
          ShowMessage(E.Message);
      end;
    end;
  finally
    LProduto.Free;
  end;
end;

procedure TFrmProdutos.btnEditarClick(Sender: TObject);
var
  LProduto: TProduto;
  LId: Integer;
begin
  if qryProdutos.IsEmpty then
    Exit;

  LId := qryProdutos.FieldByName('ID').AsInteger;
  LProduto := FController.BuscarPorId(LId);
  try
    if TFrmProdutoEdit.Editar(LProduto) then
    begin
      try
        FController.Salvar(LProduto);
        CarregarLista;
      except
        on E: ECartSysException do
          ShowMessage(E.Message);
      end;
    end;
  finally
    LProduto.Free;
  end;
end;

procedure TFrmProdutos.btnExcluirClick(Sender: TObject);
var
  LId: Integer;
begin
  if qryProdutos.IsEmpty then
    Exit;

  if MessageDlg('Confirma a exclusão do produto selecionado?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  LId := qryProdutos.FieldByName('ID').AsInteger;

  try
    FController.Excluir(LId);
    CarregarLista;
  except
    on E: ECartSysException do
      ShowMessage(E.Message);
  end;
end;

end.
