program ERPFinanceiro;

uses
  Vcl.Forms,
  Vcl.Controls,
  ERPFinanceiro.View.Main in 'View\ERPFinanceiro.View.Main.pas' {FrmFinanceiroMain},
  ERPFinanceiro.View.Login in 'View\ERPFinanceiro.View.Login.pas' {FrmLogin},
  ERPFinanceiro.View.Dashboard in 'View\ERPFinanceiro.View.Dashboard.pas' {Form1};

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
      Application.CreateForm(TFrmFinanceiroMain, FrmFinanceiroMain);
      Application.Run;
    end;
  finally
    LFrmLogin.Free;
  end;
end.
