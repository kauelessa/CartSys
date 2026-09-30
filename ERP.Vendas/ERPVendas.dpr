program ERPVendas;

uses
  Vcl.Forms,
  Vcl.Controls,
  Shared.Model.Entities,
  ERPVendas.View.Login in 'View\ERPVendas.View.Login.pas' {FrmLogin},
  ERPVendas.View.Main in 'View\ERPVendas.View.Main.pas' {FrmMain},
  ERPVendas.View.DesbloquearUsuario in 'View\ERPVendas.View.DesbloquearUsuario.pas' {FrmDesbloquearUsuario},
  ERPVendas.Controller.Cliente in 'Controller\ERPVendas.Controller.Cliente.pas',
  ERPVendas.Controller.Produto in 'Controller\ERPVendas.Controller.Produto.pas',
  ERPVendas.View.Clientes in 'View\ERPVendas.View.Clientes.pas' {FrmClientes},
  ERPVendas.View.ClienteEdit in 'View\ERPVendas.View.ClienteEdit.pas' {FrmClienteEdit},
  ERPVendas.View.ProdutoEdit in 'View\ERPVendas.View.ProdutoEdit.pas' {FrmProdutoEdit},
  ERPVendas.View.Produtos in 'View\ERPVendas.View.Produtos.pas' {FrmProdutos},
  ERPVendas.Controller.Venda in 'Controller\ERPVendas.Controller.Venda.pas',
  ERPVendas.View.Venda in 'View\ERPVendas.View.Venda.pas' {FrmVenda};

{$R *.res}

var
  LFrmLogin: TFrmLogin;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  LFrmLogin := TFrmLogin.Create(nil);
  try
    if LFrmLogin.ShowModal = mrOk then
    begin
      Application.CreateForm(TFrmMain, FrmMain);
      FrmMain.UsuarioLogado := LFrmLogin.UsuarioAutenticado;
      Application.Run;
    end;
  finally
    LFrmLogin.Free;
  end;
end.
