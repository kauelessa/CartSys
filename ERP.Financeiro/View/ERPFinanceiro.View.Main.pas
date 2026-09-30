unit ERPFinanceiro.View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Comp.Client, ERPFinanceiro.View.Dashboard,
  Shared.Data.Connection, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Comp.DataSet,
  Shared.Utils.EmailSender, Shared.Reports.RelatorioPedido;

type
  TFrmFinanceiroMain = class(TForm)
    qryPendentes: TFDQuery;
    dsPendentes: TDataSource;
    grdPendentes: TDBGrid;
    btnQuitar: TButton;
    btnCancelar: TButton;
    btnAtualizar: TButton;
    lblTitulo: TLabel;
    btnDashboard: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnQuitarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnDashboardClick(Sender: TObject);
  private
    procedure CarregarPendentes;
  end;

var
  FrmFinanceiroMain: TFrmFinanceiroMain;

implementation

{$R *.dfm}

procedure TFrmFinanceiroMain.FormCreate(Sender: TObject);
begin
  qryPendentes.Connection := TConnectionManager.GetConnection;
  CarregarPendentes;
end;

procedure TFrmFinanceiroMain.CarregarPendentes;
begin
  qryPendentes.Close;
  qryPendentes.SQL.Text :=
    'SELECT V.ID, V.DATA_VENDA, V.VALOR_TOTAL, C.NOME AS NOME_CLIENTE ' +
    'FROM VENDAS V ' +
    'JOIN CLIENTES C ON C.ID = V.ID_CLIENTE ' +
    'WHERE V.STATUS = 0 ' +
    'ORDER BY V.DATA_VENDA';
  qryPendentes.Open;
end;

procedure TFrmFinanceiroMain.btnAtualizarClick(Sender: TObject);
begin
  CarregarPendentes;
end;

procedure TFrmFinanceiroMain.btnQuitarClick(Sender: TObject);
var
  LId: Integer;
  LQuery: TFDQuery;
  LEmailCliente, LNomeCliente: string;
  LValorTotal: Currency;
  LCaminhoPDF: string;
begin
  if qryPendentes.IsEmpty then
    Exit;

  if MessageDlg('Confirma a quitação da venda selecionada?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  LId := qryPendentes.FieldByName('ID').AsInteger;
  LNomeCliente := qryPendentes.FieldByName('NOME_CLIENTE').AsString;
  LValorTotal := qryPendentes.FieldByName('VALOR_TOTAL').AsCurrency;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := TConnectionManager.GetConnection;

    // Atualiza status para quitada
    LQuery.SQL.Text := 'UPDATE VENDAS SET STATUS = 1 WHERE ID = :ID';
    LQuery.ParamByName('ID').AsInteger := LId;
    LQuery.ExecSQL;

    // Busca e-mail do cliente vinculado à venda
    LQuery.SQL.Text :=
      'SELECT C.EMAIL FROM VENDAS V ' +
      'JOIN CLIENTES C ON C.ID = V.ID_CLIENTE ' +
      'WHERE V.ID = :ID';
    LQuery.ParamByName('ID').AsInteger := LId;
    LQuery.Open;
    LEmailCliente := LQuery.FieldByName('EMAIL').AsString;
    LQuery.Close;

    ShowMessage('Venda quitada com sucesso!');
    CarregarPendentes;

    // Gera PDF e envia e-mail (não bloqueia a quitação se falhar)
    try
      LCaminhoPDF := TFrmRelatorioPedido.GerarPDF(LId);
      TEmailSender.EnviarConfirmacaoQuitacao(LEmailCliente, LNomeCliente, LId, LValorTotal, LCaminhoPDF);
      ShowMessage('E-mail de confirmação enviado para: ' + LEmailCliente);
    except
      on E: Exception do
        ShowMessage('Venda quitada, mas houve falha ao enviar e-mail: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TFrmFinanceiroMain.btnCancelarClick(Sender: TObject);
var
  LId: Integer;
  LQuery: TFDQuery;
begin
  if qryPendentes.IsEmpty then
    Exit;

  if MessageDlg('Confirma o cancelamento da venda selecionada? O estoque será estornado.',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  LId := qryPendentes.FieldByName('ID').AsInteger;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := TConnectionManager.GetConnection;

    LQuery.Connection.StartTransaction;
    try
      // Estorna estoque de cada item da venda cancelada
      LQuery.SQL.Text :=
        'UPDATE PRODUTOS SET ESTOQUE = ESTOQUE + (SELECT QUANTIDADE FROM ITENS_VENDA ' +
        'WHERE ITENS_VENDA.ID_PRODUTO = PRODUTOS.ID AND ITENS_VENDA.ID_VENDA = :ID) ' +
        'WHERE ID IN (SELECT ID_PRODUTO FROM ITENS_VENDA WHERE ID_VENDA = :ID)';
      LQuery.ParamByName('ID').AsInteger := LId;
      LQuery.ExecSQL;

      LQuery.SQL.Text := 'UPDATE VENDAS SET STATUS = 2 WHERE ID = :ID';
      LQuery.ParamByName('ID').AsInteger := LId;
      LQuery.ExecSQL;

      LQuery.Connection.Commit;
    except
      LQuery.Connection.Rollback;
      raise;
    end;

    ShowMessage('Venda cancelada e estoque estornado com sucesso!');
    CarregarPendentes;
  finally
    LQuery.Free;
  end;
end;

procedure TFrmFinanceiroMain.btnDashboardClick(Sender: TObject);
var
  LForm: TFrmDashboard;
begin
  LForm := TFrmDashboard.Create(nil);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.