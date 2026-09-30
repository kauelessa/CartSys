unit ERPVendas.View.ProdutoEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  Shared.Model.Entities;

type
  TFrmProdutoEdit = class(TForm)
    edDescricao: TEdit;
    edCodigoBarras: TEdit;
    edPrecoVenda: TEdit;
    edEstoque: TEdit;
    chkAtivo: TCheckBox;
    btnSalvar: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FProduto: TProduto;
    procedure CarregarCampos;
    function GravarCampos: Boolean;
  public
    class function Editar(const AProduto: TProduto): Boolean;
  end;

implementation

{$R *.dfm}

class function TFrmProdutoEdit.Editar(const AProduto: TProduto): Boolean;
var
  LForm: TFrmProdutoEdit;
begin
  LForm := TFrmProdutoEdit.Create(nil);
  try
    LForm.FProduto := AProduto;
    LForm.CarregarCampos;
    Result := LForm.ShowModal = mrOk;
  finally
    LForm.Free;
  end;
end;

procedure TFrmProdutoEdit.CarregarCampos;
begin
  edDescricao.Text := FProduto.Descricao;
  edCodigoBarras.Text := FProduto.CodigoBarras;
  edPrecoVenda.Text := FormatFloat('0.00', FProduto.PrecoVenda);
  edEstoque.Text := IntToStr(FProduto.Estoque);
  chkAtivo.Checked := FProduto.Ativo;
end;

function TFrmProdutoEdit.GravarCampos: Boolean;
var
  LPreco: Currency;
  LEstoque: Integer;
begin
  Result := False;

  if Trim(edDescricao.Text) = '' then
  begin
    ShowMessage('Informe a descrição do produto.');
    edDescricao.SetFocus;
    Exit;
  end;

  if not TryStrToCurr(edPrecoVenda.Text, LPreco) then
  begin
    ShowMessage('Preço de venda inválido.');
    edPrecoVenda.SetFocus;
    Exit;
  end;

  if not TryStrToInt(edEstoque.Text, LEstoque) then
  begin
    ShowMessage('Estoque inválido.');
    edEstoque.SetFocus;
    Exit;
  end;

  FProduto.Descricao := Trim(edDescricao.Text);
  FProduto.CodigoBarras := Trim(edCodigoBarras.Text);
  FProduto.PrecoVenda := LPreco;
  FProduto.Estoque := LEstoque;
  FProduto.Ativo := chkAtivo.Checked;

  Result := True;
end;

procedure TFrmProdutoEdit.btnSalvarClick(Sender: TObject);
begin
  if GravarCampos then
    ModalResult := mrOk;
end;

procedure TFrmProdutoEdit.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
