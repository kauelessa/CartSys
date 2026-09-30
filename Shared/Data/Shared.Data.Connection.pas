unit Shared.Data.Connection;

interface

uses
  System.SysUtils,
  System.IniFiles,
  FireDAC.Comp.Client,
  FireDAC.Stan.Intf,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Shared.Exceptions;

type
  TConnectionManager = class
  private
    class var FConnection: TFDConnection;
    class function CaminhoArquivoConfig: string; static;
  public
    class function GetConnection: TFDConnection; static;
    class procedure Finalizar; static;
  end;

implementation

const
  CONFIG_FILE_NAME = 'CartSys.ini';

class function TConnectionManager.CaminhoArquivoConfig: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + CONFIG_FILE_NAME;
end;

class function TConnectionManager.GetConnection: TFDConnection;
var
  LIni: TIniFile;
  LServidor, LBanco, LUsuario, LSenha: string;
begin
  if not Assigned(FConnection) then
  begin
    if not FileExists(CaminhoArquivoConfig) then
      raise EConexaoBancoException.Create(
        Format('Arquivo de configuração "%s" não encontrado.', [CONFIG_FILE_NAME]));

    LIni := TIniFile.Create(CaminhoArquivoConfig);
    try
      LServidor := LIni.ReadString('Database', 'Server', 'localhost');
      LBanco    := LIni.ReadString('Database', 'Database', '');
      LUsuario  := LIni.ReadString('Database', 'User', 'SYSDBA');
      LSenha    := LIni.ReadString('Database', 'Password', 'masterkey');
    finally
      LIni.Free;
    end;

    FConnection := TFDConnection.Create(nil);
    try
      FConnection.Params.Clear;
      FConnection.Params.DriverID := 'FB';
      FConnection.Params.Database := LBanco;
      FConnection.Params.UserName := LUsuario;
      FConnection.Params.Password := LSenha;
      FConnection.Params.Add('Server=' + LServidor);
      FConnection.Params.Add('Protocol=TCPIP');
      FConnection.Params.Add('CharacterSet=UTF8');
      FConnection.LoginPrompt := False;

      FConnection.Connected := True;
    except
      on E: Exception do
      begin
        FreeAndNil(FConnection);
        raise EConexaoBancoException.Create(E.Message);
      end;
    end;
  end;

  Result := FConnection;
end;

class procedure TConnectionManager.Finalizar;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Connected := False;
    FreeAndNil(FConnection);
  end;
end;

end.
