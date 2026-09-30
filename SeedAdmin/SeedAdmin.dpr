program SeedAdmin;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Shared.Data.Connection in '..\Shared\Data\Shared.Data.Connection.pas',
  Shared.DAL.UsuarioRepository in '..\Shared\DAL\Shared.DAL.UsuarioRepository.pas',
  Shared.Model.Entities in '..\Shared\Model\Shared.Model.Entities.pas',
  Shared.Auth.PasswordHasher in '..\Shared\Auth\Shared.Auth.PasswordHasher.pas',
  Shared.Auth.TOTP in '..\Shared\Auth\Shared.Auth.TOTP.pas';

var
  LRepo: TUsuarioRepository;
  LUsuario: TUsuario;
  LLogin, LSenha, LSalt, LSecret: string;

begin
  try
    WriteLn('=== Configuração inicial do usuário ===');
    Write('Digite o usuario: ');
    ReadLn(LLogin);
    Write('Digite a senha para o usuário: ');
    ReadLn(LSenha);

    LRepo := TUsuarioRepository.Create(TConnectionManager.GetConnection);
    try
      LUsuario := LRepo.GetByLogin(LLogin);
      try
        if not Assigned(LUsuario) then
        begin
          WriteLn('Usuário não encontrado no banco. Verifique o script SQL.');
          Exit;
        end;

        LSalt := TPasswordHasher.GerarSalt;
        LSecret := TTOTPHelper.GerarSecret;

        LUsuario.SenhaSalt := LSalt;
        LUsuario.SenhaHash := TPasswordHasher.GerarHash(LSenha, LSalt);
        LUsuario.TotpSecret := LSecret;
        LUsuario.Bloqueado := False;
        LUsuario.TentativasFalhas := 0;

        LRepo.Update(LUsuario);

        WriteLn;
        WriteLn('Usuário atualizado com sucesso!');
        WriteLn('Secret TOTP (cadastre no Authenticator): ', LSecret);
      finally
        LUsuario.Free;
      end;
    finally
      LRepo.Free;
    end;

    WriteLn;
    WriteLn('Pressione ENTER para sair.');
    ReadLn;
  except
    on E: Exception do
    begin
      WriteLn('Erro: ', E.Message);
      ReadLn;
    end;
  end;
end.
