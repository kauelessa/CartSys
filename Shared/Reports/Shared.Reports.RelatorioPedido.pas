unit Shared.Reports.RelatorioPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, ppDB, ppDBPipe,
  ppComm, ppRelatv, ppProd, ppClass, ppReport, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ppPrnabl, ppCtrls, ppBands, ppCache, ppDesignLayer,
  ppParameter, ppDrwCmd, System.IOUtils,
  Shared.Data.Connection;

type
  TFrmRelatorioPedido = class(TForm)
    qryVendaCabecalho: TFDQuery;
    qryVendaItens: TFDQuery;
    rptPedido: TppReport;
    pipeCabecalho: TppDBPipeline;
    pipeItens: TppDBPipeline;
    dsVendaCabecalho: TDataSource;
    dsVendaItens: TDataSource;
    ppParameterList1: TppParameterList;
    ppTitleBand1: TppTitleBand;
    ppLabel1: TppLabel;
    ppHeaderBand1: TppHeaderBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppLabel8: TppLabel;
    ppLine1: TppLine;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    ppLabel11: TppLabel;
    ppLabel12: TppLabel;
    ppDetailBand1: TppDetailBand;
    ppDBText10: TppDBText;
    ppDBText11: TppDBText;
    ppDBText12: TppDBText;
    ppDBText13: TppDBText;
    ppFooterBand1: TppFooterBand;
    ppDBText14: TppDBText;
    ppLabel13: TppLabel;
    ppLabel14: TppLabel;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    procedure FormCreate(Sender: TObject);
  private
    FIdVenda: Integer;
    procedure CarregarDados(const AIdVenda: Integer);
  public
    class procedure Imprimir(const AIdVenda: Integer);
    class procedure Visualizar(const AIdVenda: Integer);
    class function GerarPDF(const AIdVenda: Integer): string;
  end;

implementation

{$R *.dfm}

class function TFrmRelatorioPedido.GerarPDF(const AIdVenda: Integer): string;
var
  LForm: TFrmRelatorioPedido;
  LCaminho: string;
begin
  LCaminho := TPath.Combine(ExtractFilePath(ParamStr(0)), Format('Pedido_%d.pdf', [AIdVenda]));

  LForm := TFrmRelatorioPedido.Create(nil);
  try
    LForm.CarregarDados(AIdVenda);

    LForm.rptPedido.AllowPrintToFile := True;
    LForm.rptPedido.DeviceType := 'PDF';
    LForm.rptPedido.TextFileName := LCaminho;
    LForm.rptPedido.ShowPrintDialog := False;
    LForm.rptPedido.ShowCancelDialog := False;
    LForm.rptPedido.Print;

    Result := LCaminho;
  finally
    LForm.Free;
  end;
end;

procedure TFrmRelatorioPedido.FormCreate(Sender: TObject);
begin
  qryVendaCabecalho.Connection := TConnectionManager.GetConnection;
  qryVendaItens.Connection := TConnectionManager.GetConnection;
end;

procedure TFrmRelatorioPedido.CarregarDados(const AIdVenda: Integer);
begin
  FIdVenda := AIdVenda;

  qryVendaCabecalho.Close;
  qryVendaCabecalho.SQL.Text :=
    'SELECT V.ID, V.DATA_VENDA, V.VALOR_TOTAL, V.STATUS, V.OBSERVACAO, ' +
    'C.NOME AS NOME_CLIENTE, C.DOCUMENTO, C.EMAIL, C.TELEFONE, C.ENDERECO, C.CIDADE, C.UF, ' +
    'U.NOME AS NOME_VENDEDOR ' +
    'FROM VENDAS V ' +
    'JOIN CLIENTES C ON C.ID = V.ID_CLIENTE ' +
    'JOIN USUARIOS U ON U.ID = V.ID_USUARIO ' +
    'WHERE V.ID = :ID_VENDA';
  qryVendaCabecalho.ParamByName('ID_VENDA').AsInteger := AIdVenda;
  qryVendaCabecalho.Open;

  qryVendaItens.Close;
  qryVendaItens.SQL.Text :=
    'SELECT IV.ID_VENDA, IV.QUANTIDADE, IV.PRECO_UNITARIO, IV.SUBTOTAL, P.DESCRICAO, P.CODIGO_BARRAS ' +
    'FROM ITENS_VENDA IV ' +
    'JOIN PRODUTOS P ON P.ID = IV.ID_PRODUTO ' +
    'WHERE IV.ID_VENDA = :ID_VENDA';
  qryVendaItens.ParamByName('ID_VENDA').AsInteger := AIdVenda;
  qryVendaItens.Open;
end;

class procedure TFrmRelatorioPedido.Visualizar(const AIdVenda: Integer);
var
  LForm: TFrmRelatorioPedido;
begin
  LForm := TFrmRelatorioPedido.Create(nil);
  try
    LForm.CarregarDados(AIdVenda);
    LForm.rptPedido.DeviceType := 'Screen';
    LForm.rptPedido.Print;
  finally
    LForm.Free;
  end;
end;

class procedure TFrmRelatorioPedido.Imprimir(const AIdVenda: Integer);
var
  LForm: TFrmRelatorioPedido;
begin
  LForm := TFrmRelatorioPedido.Create(nil);
  try
    LForm.CarregarDados(AIdVenda);
    LForm.rptPedido.DeviceType := 'Printer';
    LForm.rptPedido.Print;
  finally
    LForm.Free;
  end;
end;

end.
