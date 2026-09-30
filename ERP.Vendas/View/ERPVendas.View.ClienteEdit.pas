unit ERPVendas.View.ClienteEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  Shared.Model.Entities;

type
  TFrmClienteEdit = class(TForm)
    edNome: TEdit;
    edDocumento: TEdit;
    edEmail: TEdit;
    edTelefone: TEdit;
    edEndereco: TEdit;
    edCidade: TEdit;
    edUf: TEdit;
    chkAtivo: TCheckBox;
    btnSalvar: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FCliente: TCliente;
    procedure CarregarCampos;
    procedure GravarCampos;
  public
    class function Editar(const ACliente: TCliente): Boolean;
  end;

implementation

{$R *.dfm}

class function TFrmClienteEdit.Editar(const ACliente: TCliente): Boolean;
var
  LForm: TFrmClienteEdit;
begin
  LForm := TFrmClienteEdit.Create(nil);
  try
    LForm.FCliente := ACliente;
    LForm.CarregarCampos;
    Result := LForm.ShowModal = mrOk;
  finally
    LForm.Free;
  end;
end;

procedure TFrmClienteEdit.CarregarCampos;
begin
  edNome.Text := FCliente.Nome;
  edDocumento.Text := FCliente.Documento;
  edEmail.Text := FCliente.Email;
  edTelefone.Text := FCliente.Telefone;
  edEndereco.Text := FCliente.Endereco;
  edCidade.Text := FCliente.Cidade;
  edUf.Text := FCliente.Uf;
  chkAtivo.Checked := FCliente.Ativo;
end;

procedure TFrmClienteEdit.GravarCampos;
begin
  FCliente.Nome := Trim(edNome.Text);
  FCliente.Documento := Trim(edDocumento.Text);
  FCliente.Email := Trim(edEmail.Text);
  FCliente.Telefone := Trim(edTelefone.Text);
  FCliente.Endereco := Trim(edEndereco.Text);
  FCliente.Cidade := Trim(edCidade.Text);
  FCliente.Uf := Trim(edUf.Text);
  FCliente.Ativo := chkAtivo.Checked;
end;

procedure TFrmClienteEdit.btnSalvarClick(Sender: TObject);
begin
  if Trim(edNome.Text) = '' then
  begin
    ShowMessage('Informe o nome do cliente.');
    edNome.SetFocus;
    Exit;
  end;

  GravarCampos;
  ModalResult := mrOk;
end;

procedure TFrmClienteEdit.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
