unit ERPVendas.View.DesbloquearUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Comp.Client,
  Shared.Auth.Login,
  Shared.Data.Connection, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TFrmDesbloquearUsuario = class(TForm)
    qryBloqueados: TFDQuery;
    dsBloqueados: TDataSource;
    DBGrid1: TDBGrid;
    btnDesbloquear: TButton;
    btnFechar: TButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDesbloquearClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    FController: TLoginController;
    procedure CarregarBloqueados;
  public
    class procedure Exibir;
  end;

implementation

{$R *.dfm}

class procedure TFrmDesbloquearUsuario.Exibir;
var
  LForm: TFrmDesbloquearUsuario;
begin
  LForm := TFrmDesbloquearUsuario.Create(nil);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TFrmDesbloquearUsuario.FormCreate(Sender: TObject);
begin
  FController := TLoginController.Create;
  qryBloqueados.Connection := TConnectionManager.GetConnection;
  CarregarBloqueados;
end;

procedure TFrmDesbloquearUsuario.FormDestroy(Sender: TObject);
begin
  FController.Free;
end;

procedure TFrmDesbloquearUsuario.CarregarBloqueados;
begin
  qryBloqueados.Close;
  qryBloqueados.SQL.Text :=
    'SELECT ID, LOGIN, NOME, TENTATIVAS_FALHAS FROM USUARIOS WHERE BLOQUEADO = 1 ORDER BY NOME';
  qryBloqueados.Open;
end;

procedure TFrmDesbloquearUsuario.btnDesbloquearClick(Sender: TObject);
var
  LIdUsuario: Integer;
begin
  if qryBloqueados.IsEmpty then
    Exit;

  LIdUsuario := qryBloqueados.FieldByName('ID').AsInteger;

  try
    FController.DesbloquearUsuario(LIdUsuario);
    ShowMessage('Usuário desbloqueado com sucesso!');
    CarregarBloqueados;
  except
    on E: Exception do
      ShowMessage('Erro ao desbloquear usuário: ' + E.Message);
  end;
end;

procedure TFrmDesbloquearUsuario.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.
