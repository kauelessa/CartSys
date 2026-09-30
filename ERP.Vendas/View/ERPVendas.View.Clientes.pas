unit ERPVendas.View.Clientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Comp.Client,
  ERPVendas.Controller.Cliente,
  Shared.Model.Entities,
  Shared.Data.Connection,
  Shared.Exceptions, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TFrmClientes = class(TForm)
    qryClientes: TFDQuery;
    dsClientes: TDataSource;
    grdClientes: TDBGrid;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnAtualizar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    FController: TClienteController;
    procedure CarregarLista;
  public
    class procedure Exibir;
  end;

implementation

{$R *.dfm}

uses
  ERPVendas.View.ClienteEdit;

class procedure TFrmClientes.Exibir;
var
  LForm: TFrmClientes;
begin
  LForm := TFrmClientes.Create(nil);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TFrmClientes.FormCreate(Sender: TObject);
begin
  FController := TClienteController.Create;
  qryClientes.Connection := TConnectionManager.GetConnection;
  CarregarLista;
end;

procedure TFrmClientes.FormDestroy(Sender: TObject);
begin
  FController.Free;
end;

procedure TFrmClientes.CarregarLista;
begin
  qryClientes.Close;
  qryClientes.SQL.Text := 'SELECT ID, NOME, DOCUMENTO, EMAIL, TELEFONE, CIDADE, UF, ATIVO FROM CLIENTES ORDER BY NOME';
  qryClientes.Open;
end;

procedure TFrmClientes.btnAtualizarClick(Sender: TObject);
begin
  CarregarLista;
end;

procedure TFrmClientes.btnNovoClick(Sender: TObject);
var
  LCliente: TCliente;
begin
  LCliente := TCliente.Create;
  try
    LCliente.Ativo := True;
    if TFrmClienteEdit.Editar(LCliente) then
    begin
      try
        FController.Salvar(LCliente);
        CarregarLista;
      except
        on E: ECartSysException do
          ShowMessage(E.Message);
      end;
    end;
  finally
    LCliente.Free;
  end;
end;

procedure TFrmClientes.btnEditarClick(Sender: TObject);
var
  LCliente: TCliente;
  LId: Integer;
begin
  if qryClientes.IsEmpty then
    Exit;

  LId := qryClientes.FieldByName('ID').AsInteger;
  LCliente := FController.BuscarPorId(LId);
  try
    if TFrmClienteEdit.Editar(LCliente) then
    begin
      try
        FController.Salvar(LCliente);
        CarregarLista;
      except
        on E: ECartSysException do
          ShowMessage(E.Message);
      end;
    end;
  finally
    LCliente.Free;
  end;
end;

procedure TFrmClientes.btnExcluirClick(Sender: TObject);
var
  LId: Integer;
begin
  if qryClientes.IsEmpty then
    Exit;

  if MessageDlg('Confirma a exclusão do cliente selecionado?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  LId := qryClientes.FieldByName('ID').AsInteger;

  try
    FController.Excluir(LId);
    CarregarLista;
  except
    on E: ECartSysException do
      ShowMessage(E.Message);
  end;
end;

end.
