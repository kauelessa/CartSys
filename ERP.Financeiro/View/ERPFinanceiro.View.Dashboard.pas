unit ERPFinanceiro.View.Dashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart,
  Shared.Data.Connection, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TFrmDashboard = class(TForm)
    qryIndicadores: TFDQuery;
    qryTopProdutos: TFDQuery;
    qryTopClientes: TFDQuery;
    pnlTopo: TPanel;
    lblTituloFinalizadas: TLabel;
    lblQtdFinalizadas: TLabel;
    lblTituloPendentes: TLabel;
    lblQtdPendentes: TLabel;
    lblTituloProjetado: TLabel;
    lblValorProjetado: TLabel;
    lblTituloVendido: TLabel;
    lblValorVendido: TLabel;
    chartTopProdutos: TChart;
    chartTopClientes: TChart;
    btnAtualizar: TButton;
    serieProdutos: TBarSeries;
    serieClientes: TBarSeries;
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    procedure CarregarIndicadores;
    procedure CarregarTopProdutos;
    procedure CarregarTopClientes;
    procedure CarregarTudo;
  end;

var
  FrmDashboard: TFrmDashboard;

implementation

{$R *.dfm}

procedure TFrmDashboard.FormCreate(Sender: TObject);
begin
  qryIndicadores.Connection := TConnectionManager.GetConnection;
  qryTopProdutos.Connection := TConnectionManager.GetConnection;
  qryTopClientes.Connection := TConnectionManager.GetConnection;

  CarregarTudo;
end;

procedure TFrmDashboard.CarregarTudo;
begin
  CarregarIndicadores;
  CarregarTopProdutos;
  CarregarTopClientes;
end;

procedure TFrmDashboard.btnAtualizarClick(Sender: TObject);
begin
  CarregarTudo;
end;

procedure TFrmDashboard.CarregarIndicadores;
begin
  qryIndicadores.Close;
  qryIndicadores.SQL.Text :=
    'SELECT ' +
    '  (SELECT COUNT(*) FROM VENDAS WHERE STATUS = 1) AS QTD_FINALIZADAS, ' +
    '  (SELECT COUNT(*) FROM VENDAS WHERE STATUS = 0) AS QTD_PENDENTES, ' +
    '  (SELECT COALESCE(SUM(VALOR_TOTAL), 0) FROM VENDAS WHERE STATUS = 0) AS VALOR_PROJETADO, ' +
    '  (SELECT COALESCE(SUM(VALOR_TOTAL), 0) FROM VENDAS WHERE STATUS = 1) AS VALOR_VENDIDO ' +
    'FROM RDB$DATABASE';
  qryIndicadores.Open;

  lblQtdFinalizadas.Caption := qryIndicadores.FieldByName('QTD_FINALIZADAS').AsString;
  lblQtdPendentes.Caption := qryIndicadores.FieldByName('QTD_PENDENTES').AsString;
  lblValorProjetado.Caption := FormatFloat('R$ #,##0.00', qryIndicadores.FieldByName('VALOR_PROJETADO').AsFloat);
  lblValorVendido.Caption := FormatFloat('R$ #,##0.00', qryIndicadores.FieldByName('VALOR_VENDIDO').AsFloat);

  qryIndicadores.Close;
end;

procedure TFrmDashboard.CarregarTopProdutos;
begin
  qryTopProdutos.Close;
  qryTopProdutos.SQL.Text :=
    'SELECT FIRST 5 P.DESCRICAO, SUM(I.QUANTIDADE) AS TOTAL_VENDIDO ' +
    'FROM ITENS_VENDA I ' +
    'JOIN PRODUTOS P ON P.ID = I.ID_PRODUTO ' +
    'JOIN VENDAS V ON V.ID = I.ID_VENDA ' +
    'WHERE V.STATUS IN (0, 1) ' +
    'GROUP BY P.DESCRICAO ' +
    'ORDER BY TOTAL_VENDIDO DESC';
  qryTopProdutos.Open;

  serieProdutos.Clear;
  qryTopProdutos.First;
  while not qryTopProdutos.Eof do
  begin
    serieProdutos.Add(
      qryTopProdutos.FieldByName('TOTAL_VENDIDO').AsFloat,
      qryTopProdutos.FieldByName('DESCRICAO').AsString
    );
    qryTopProdutos.Next;
  end;

  qryTopProdutos.Close;
end;

procedure TFrmDashboard.CarregarTopClientes;
begin
  qryTopClientes.Close;
  qryTopClientes.SQL.Text :=
    'SELECT FIRST 5 C.NOME, SUM(V.VALOR_TOTAL) AS TOTAL_COMPRADO ' +
    'FROM VENDAS V ' +
    'JOIN CLIENTES C ON C.ID = V.ID_CLIENTE ' +
    'WHERE V.STATUS IN (0, 1) ' +
    'GROUP BY C.NOME ' +
    'ORDER BY TOTAL_COMPRADO DESC';
  qryTopClientes.Open;

  serieClientes.Clear;
  qryTopClientes.First;
  while not qryTopClientes.Eof do
  begin
    serieClientes.Add(
      qryTopClientes.FieldByName('TOTAL_COMPRADO').AsFloat,
      qryTopClientes.FieldByName('NOME').AsString
    );
    qryTopClientes.Next;
  end;

  qryTopClientes.Close;
end;

end.