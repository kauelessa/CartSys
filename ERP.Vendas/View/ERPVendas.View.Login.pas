unit ERPVendas.View.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  Shared.Auth.Login,
  Shared.Model.Entities;

type
  TFrmLogin = class(TForm)
    edLogin: TEdit;
    edSenha: TEdit;
    edCodigoTotp: TEdit;
    btnEntrar: TButton;
    lblStatus: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
  private
    FController: TLoginController;
    FUsuarioAutenticado: TUsuario;
    procedure HandleAutenticacaoSucesso(Sender: TObject; const AUsuario: TUsuario);
    procedure HandleAutenticacaoErro(Sender: TObject; const AMensagem: string);
    procedure HandleAutenticacaoBloqueado(Sender: TObject; const AUsuario: TUsuario);
    procedure HabilitarFormulario(const AHabilitar: Boolean);
  public
    property UsuarioAutenticado: TUsuario read FUsuarioAutenticado;
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  FController := TLoginController.Create;
  FController.OnAutenticacaoSucesso := HandleAutenticacaoSucesso;
  FController.OnAutenticacaoErro := HandleAutenticacaoErro;
  FController.OnAutenticacaoBloqueado := HandleAutenticacaoBloqueado;

  lblStatus.Caption := '';
end;

procedure TFrmLogin.FormDestroy(Sender: TObject);
begin
  FController.Free;
  // Só libera aqui se ninguém "pegou" o usuário (ex: usuário fechou a tela sem logar)
  if ModalResult <> mrOk then
    FUsuarioAutenticado.Free;
end;

procedure TFrmLogin.HabilitarFormulario(const AHabilitar: Boolean);
begin
  edLogin.Enabled := AHabilitar;
  edSenha.Enabled := AHabilitar;
  edCodigoTotp.Enabled := AHabilitar;
  btnEntrar.Enabled := AHabilitar;
end;

procedure TFrmLogin.btnEntrarClick(Sender: TObject);
begin
  if Trim(edLogin.Text) = '' then
  begin
    lblStatus.Caption := 'Informe o login.';
    Exit;
  end;

  if Trim(edSenha.Text) = '' then
  begin
    lblStatus.Caption := 'Informe a senha.';
    Exit;
  end;

  if Trim(edCodigoTotp.Text) = '' then
  begin
    lblStatus.Caption := 'Informe o código do autenticador.';
    Exit;
  end;

  HabilitarFormulario(False);
  lblStatus.Caption := 'Autenticando...';

  FController.AutenticarAsync(Trim(edLogin.Text), edSenha.Text, Trim(edCodigoTotp.Text));
end;

procedure TFrmLogin.HandleAutenticacaoSucesso(Sender: TObject; const AUsuario: TUsuario);
begin
  HabilitarFormulario(True);
  lblStatus.Caption := 'Login realizado com sucesso!';
  FUsuarioAutenticado := AUsuario;
  ModalResult := mrOk;
end;

procedure TFrmLogin.HandleAutenticacaoErro(Sender: TObject; const AMensagem: string);
begin
  HabilitarFormulario(True);
  lblStatus.Caption := AMensagem;
  edSenha.SetFocus;
end;

procedure TFrmLogin.HandleAutenticacaoBloqueado(Sender: TObject; const AUsuario: TUsuario);
begin
  HabilitarFormulario(True);
  lblStatus.Caption := 'Usuário bloqueado. Procure o administrador do sistema.';
end;

end.
