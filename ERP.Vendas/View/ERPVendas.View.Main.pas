unit ERPVendas.View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus,
  Shared.Model.Entities,
  ERPVendas.View.Clientes,
  ERPVendas.View.Produtos,
  ERPVendas.View.Venda;

type
  TFrmMain = class(TForm)
    MainMenu1: TMainMenu;
    mnuCadastros: TMenuItem;
    mnuClientes: TMenuItem;
    mnuProdutos: TMenuItem;
    mnuVendas: TMenuItem;
    mnuAdministracao: TMenuItem;
    mnuDesbloquearUsuario: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure mnuDesbloquearUsuarioClick(Sender: TObject);
    procedure mnuClientesClick(Sender: TObject);
    procedure mnuProdutosClick(Sender: TObject);
    procedure mnuVendasClick(Sender: TObject);
  private
    FUsuarioLogado: TUsuario;
    procedure SetUsuarioLogado(const AValue: TUsuario);
    procedure AtualizarPermissoes;
  public
    property UsuarioLogado: TUsuario read FUsuarioLogado write SetUsuarioLogado;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses
  ERPVendas.View.DesbloquearUsuario;

procedure TFrmMain.SetUsuarioLogado(const AValue: TUsuario);
begin
  FUsuarioLogado := AValue;
  Caption := Format('ERP Vendas - %s', [FUsuarioLogado.Nome]);
  AtualizarPermissoes;
end;

procedure TFrmMain.AtualizarPermissoes;
begin
  mnuAdministracao.Visible := Assigned(FUsuarioLogado) and FUsuarioLogado.EAdmin;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FUsuarioLogado.Free;
end;

procedure TFrmMain.mnuClientesClick(Sender: TObject);
begin
  TFrmClientes.Exibir;
end;

procedure TFrmMain.mnuDesbloquearUsuarioClick(Sender: TObject);
begin
  TFrmDesbloquearUsuario.Exibir;
end;

procedure TFrmMain.mnuProdutosClick(Sender: TObject);
begin
  TFrmProdutos.Exibir;
end;

procedure TFrmMain.mnuVendasClick(Sender: TObject);
var
  LForm: TFrmVenda;
begin
  LForm := TFrmVenda.Create(nil);
  try
    LForm.IdUsuarioLogado := FUsuarioLogado.Id;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.
