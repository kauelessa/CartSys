unit Shared.Utils.EmailSender;

interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils,
  IdSMTP, IdMessage, IdText, IdAttachmentFile,
  IdSSLOpenSSL, IdExplicitTLSClientServerBase;

type
  TEmailSender = class
  private
    class function GetIniPath: string;
  public
    class procedure EnviarConfirmacaoQuitacao(const ADestinatario, ANomeCliente: string;
      const AIdVenda: Integer; const AValorTotal: Currency; const ACaminhoPDF: string);
  end;

implementation

class function TEmailSender.GetIniPath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'CartSys.ini');
end;

class procedure TEmailSender.EnviarConfirmacaoQuitacao(const ADestinatario, ANomeCliente: string;
  const AIdVenda: Integer; const AValorTotal: Currency; const ACaminhoPDF: string);
var
  LIni: TIniFile;
  LSMTP: TIdSMTP;
  LMessage: TIdMessage;
  LSSL: TIdSSLIOHandlerSocketOpenSSL;
  LTextoCorpo: TIdText;
  LHost, LUser, LPassword: string;
  LPort: Integer;
  LUseSSL: Boolean;
begin
  if ADestinatario.Trim.IsEmpty then
    raise Exception.Create('Cliente não possui e-mail cadastrado. Envio cancelado.');

  LIni := TIniFile.Create(GetIniPath);
  try
    LHost := LIni.ReadString('SMTP', 'Host', 'smtp.gmail.com');
    LPort := LIni.ReadInteger('SMTP', 'Port', 587);
    LUser := LIni.ReadString('SMTP', 'User', '');
    LPassword := LIni.ReadString('SMTP', 'Password', '');
    LUseSSL := LIni.ReadBool('SMTP', 'UseSSL', True);
  finally
    LIni.Free;
  end;

  LSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  LSMTP := TIdSMTP.Create(nil);
  LMessage := TIdMessage.Create(nil);
  try
    LSSL.SSLOptions.Method := sslvTLSv1_2;
    LSSL.SSLOptions.Mode := sslmClient;

    LSMTP.IOHandler := LSSL;
    LSMTP.Host := LHost;
    LSMTP.Port := LPort;
    LSMTP.Username := LUser;
    LSMTP.Password := LPassword;

    if LUseSSL then
    begin
      LSMTP.UseTLS := utUseExplicitTLS;
    end
    else
      LSMTP.UseTLS := utNoTLSSupport;

    LMessage.From.Address := LUser;
    LMessage.From.Name := 'CartSys ERP';
    LMessage.Recipients.EMailAddresses := ADestinatario;
    LMessage.Subject := Format('Confirmação de Pagamento - Pedido #%d', [AIdVenda]);

    LTextoCorpo := TIdText.Create(LMessage.MessageParts);
    LTextoCorpo.ContentType := 'text/plain; charset=utf-8';
    LTextoCorpo.Body.Text :=
      Format('Olá, %s!' + sLineBreak + sLineBreak +
        'Confirmamos o recebimento do pagamento referente ao pedido #%d, no valor de R$ %.2f.' + sLineBreak + sLineBreak +
        'Segue em anexo o comprovante em PDF.' + sLineBreak + sLineBreak +
        'Atenciosamente,' + sLineBreak + 'CartSys ERP',
        [ANomeCliente, AIdVenda, AValorTotal]);

    if TFile.Exists(ACaminhoPDF) then
      TIdAttachmentFile.Create(LMessage.MessageParts, ACaminhoPDF);

    LSMTP.Connect;
    try
      LSMTP.Send(LMessage);
    finally
      LSMTP.Disconnect;
    end;
  finally
    LMessage.Free;
    LSMTP.Free;
    LSSL.Free;
  end;
end;

end.
