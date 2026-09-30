unit ERPVendas.View.Venda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  ERPVendas.Controller.Venda,
  Shared.Model.Entities, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Shared.Reports.RelatorioPedido;

type
  TFrmVenda = class(TForm)
    cbCliente: TComboBox;
    edObservacao: TEdit;
    cbProduto: TComboBox;
    edQuantidade: TEdit;
    btnAdicionarItem: TButton;
    tblItens: TFDMemTable;
    dsItens: TDataSource;
    grdItens: TDBGrid;
    lblTotal: TLabel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure tblItensCalcFields(DataSet: TDataSet);
  private
    FController: TVendaController;
    FClientes: TObjectList<TCliente>;
    FProdutos: TObjectList<TProduto>;
    FIdUsuarioLogado: Integer;

    procedure CarregarCombos;
    procedure ConfigurarTabelaItens;
    procedure AtualizarTotal;
  public
    property IdUsuarioLogado: Integer read FIdUsuarioLogado write FIdUsuarioLogado;
  end;

implementation

{$R *.dfm}

procedure TFrmVenda.FormCreate(Sender: TObject);
begin
  FController := TVendaController.Create;
  ConfigurarTabelaItens;
  CarregarCombos;
end;

procedure TFrmVenda.FormDestroy(Sender: TObject);
begin
  FClientes.Free;
  FProdutos.Free;
  FController.Free;
end;

procedure TFrmVenda.ConfigurarTabelaItens;
begin
  tblItens.FieldDefs.Clear;
  tblItens.FieldDefs.Add('ID_PRODUTO', ftInteger);
  tblItens.FieldDefs.Add('DESCRICAO', ftString, 150);
  tblItens.FieldDefs.Add('QUANTIDADE', ftInteger);
  tblItens.FieldDefs.Add('PRECO_UNITARIO', ftCurrency);
  tblItens.FieldDefs.Add('SUBTOTAL', ftCurrency);
  tblItens.CreateDataSet;
  tblItens.Open;
end;

procedure TFrmVenda.CarregarCombos;
var
  LCliente: TCliente;
  LProduto: TProduto;
begin
  FClientes := FController.ListarClientes;
  cbCliente.Items.Clear;
  for LCliente in FClientes do
    cbCliente.Items.AddObject(LCliente.Nome, LCliente);

  FProdutos := FController.ListarProdutos;
  cbProduto.Items.Clear;
  for LProduto in FProdutos do
    cbProduto.Items.AddObject(
      Format('%s (Estoque: %d)', [LProduto.Descricao, LProduto.Estoque]), LProduto);
end;

procedure TFrmVenda.btnAdicionarItemClick(Sender: TObject);
var
  LProduto: TProduto;
  LQuantidade: Integer;
begin
  if cbProduto.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um produto.');
    Exit;
  end;

  if not TryStrToInt(edQuantidade.Text, LQuantidade) or (LQuantidade <= 0) then
  begin
    ShowMessage('Informe uma quantidade válida.');
    Exit;
  end;

  LProduto := TProduto(cbProduto.Items.Objects[cbProduto.ItemIndex]);

  if LQuantidade > LProduto.Estoque then
  begin
    ShowMessage(Format('Estoque insuficiente. Disponível: %d', [LProduto.Estoque]));
    Exit;
  end;

  tblItens.Append;
  tblItens.FieldByName('ID_PRODUTO').AsInteger := LProduto.Id;
  tblItens.FieldByName('DESCRICAO').AsString := LProduto.Descricao;
  tblItens.FieldByName('QUANTIDADE').AsInteger := LQuantidade;
  tblItens.FieldByName('PRECO_UNITARIO').AsCurrency := LProduto.PrecoVenda;
  tblItens.FieldByName('SUBTOTAL').AsCurrency := LProduto.PrecoVenda * LQuantidade;
  tblItens.Post;

  edQuantidade.Text := '';
  AtualizarTotal;
end;

procedure TFrmVenda.tblItensCalcFields(DataSet: TDataSet);
begin
  // reservado para campos calculados futuros na grid, se necessário
end;

procedure TFrmVenda.AtualizarTotal;
var
  LTotal: Currency;
begin
  LTotal := 0;
  tblItens.DisableControls;
  try
    tblItens.First;
    while not tblItens.Eof do
    begin
      LTotal := LTotal + tblItens.FieldByName('SUBTOTAL').AsCurrency;
      tblItens.Next;
    end;
  finally
    tblItens.EnableControls;
  end;

  lblTotal.Caption := Format('Total: R$ %.2f', [LTotal]);
end;

procedure TFrmVenda.btnSalvarClick(Sender: TObject);
var
  LVenda: TVenda;
  LItem: TItemVenda;
  LIdVendaGerada: Integer;
begin
  if cbCliente.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um cliente.');
    Exit;
  end;

  if tblItens.RecordCount = 0 then
  begin
    ShowMessage('Adicione ao menos um item à venda.');
    Exit;
  end;

  LVenda := TVenda.Create;
  try
    LVenda.IdCliente := TCliente(cbCliente.Items.Objects[cbCliente.ItemIndex]).Id;
    LVenda.IdUsuario := FIdUsuarioLogado;
    LVenda.Observacao := edObservacao.Text;
    LVenda.Status := svPendente;

    tblItens.DisableControls;
    try
      tblItens.First;
      while not tblItens.Eof do
      begin
        LItem := TItemVenda.Create;
        LItem.IdProduto := tblItens.FieldByName('ID_PRODUTO').AsInteger;
        LItem.Quantidade := tblItens.FieldByName('QUANTIDADE').AsInteger;
        LItem.PrecoUnitario := tblItens.FieldByName('PRECO_UNITARIO').AsCurrency;
        LItem.Subtotal := tblItens.FieldByName('SUBTOTAL').AsCurrency;
        LVenda.Itens.Add(LItem);

        LVenda.ValorTotal := LVenda.ValorTotal + LItem.Subtotal;
        tblItens.Next;
      end;
    finally
      tblItens.EnableControls;
    end;

    try
      LIdVendaGerada := FController.SalvarVenda(LVenda);
      ShowMessage('Venda registrada com sucesso!');

      if MessageDlg('Deseja visualizar o relatório de confirmação do pedido?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        TFrmRelatorioPedido.Visualizar(LIdVendaGerada);

      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMessage('Erro ao salvar venda: ' + E.Message);
    end;
  finally
    LVenda.Free;
  end;
end;

procedure TFrmVenda.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
