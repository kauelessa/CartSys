unit Shared.Auth.TOTP;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.Hash,
  System.Math;

type
  /// <summary>
  /// Implementação de TOTP (Time-based One-Time Password) segundo RFC 6238,
  /// compatível com Google Authenticator, Microsoft Authenticator, etc.
  /// </summary>
  TTOTPHelper = class
  private
    class function HMACSHA1(const AKey, AMessage: TBytes): TBytes; static;
    class function Base32Decode(const AInput: string): TBytes; static;
    class function IntToBigEndianBytes(const AValue: Int64): TBytes; static;
  public
    class function GerarSecret: string; static;
    class function GerarCodigo(const ASecretBase32: string;
      const AUnixTime: Int64 = 0): string; static;
    class function ValidarCodigo(const ASecretBase32, ACodigo: string;
      const AToleranciaJanelas: Integer = 1): Boolean; static;
  end;

implementation

const
  BASE32_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  TOTP_STEP_SECONDS = 30;
  TOTP_DIGITS = 6;

{ TTOTPHelper }

class function TTOTPHelper.HMACSHA1(const AKey, AMessage: TBytes): TBytes;
const
  BLOCK_SIZE = 64;
var
  LKey, LKeyPadded, LIPad, LOPad, LInnerHash: TBytes;
  LHashInner, LHashOuter: THashSHA1;
  I: Integer;
begin
  LKey := AKey;

  if Length(LKey) > BLOCK_SIZE then
  begin
    LHashInner := THashSHA1.Create;
    LHashInner.Update(LKey);
    LKey := LHashInner.HashAsBytes;
  end;

  SetLength(LKeyPadded, BLOCK_SIZE);
  FillChar(LKeyPadded[0], BLOCK_SIZE, 0);
  if Length(LKey) > 0 then
    Move(LKey[0], LKeyPadded[0], Length(LKey));

  SetLength(LIPad, BLOCK_SIZE);
  SetLength(LOPad, BLOCK_SIZE);
  for I := 0 to BLOCK_SIZE - 1 do
  begin
    LIPad[I] := LKeyPadded[I] xor $36;
    LOPad[I] := LKeyPadded[I] xor $5C;
  end;

  LHashInner := THashSHA1.Create;
  LHashInner.Update(LIPad);
  LHashInner.Update(AMessage);
  LInnerHash := LHashInner.HashAsBytes;

  LHashOuter := THashSHA1.Create;
  LHashOuter.Update(LOPad);
  LHashOuter.Update(LInnerHash);
  Result := LHashOuter.HashAsBytes;
end;

class function TTOTPHelper.Base32Decode(const AInput: string): TBytes;
var
  LClean: string;
  LBitBuffer: UInt64;
  LBitsInBuffer: Integer;
  LOutput: TBytes;
  LOutputLen: Integer;
  C: Char;
  LValue: Integer;
begin
  LClean := UpperCase(AInput).Replace('=', '', [rfReplaceAll]).Replace(' ', '', [rfReplaceAll]);

  SetLength(LOutput, (Length(LClean) * 5) div 8 + 1);
  LOutputLen := 0;
  LBitBuffer := 0;
  LBitsInBuffer := 0;

  for C in LClean do
  begin
    LValue := Pos(C, BASE32_ALPHABET) - 1;
    if LValue < 0 then
      Continue;

    LBitBuffer := (LBitBuffer shl 5) or UInt64(LValue);
    Inc(LBitsInBuffer, 5);

    if LBitsInBuffer >= 8 then
    begin
      Dec(LBitsInBuffer, 8);
      LOutput[LOutputLen] := Byte((LBitBuffer shr LBitsInBuffer) and $FF);
      Inc(LOutputLen);
    end;
  end;

  SetLength(LOutput, LOutputLen);
  Result := LOutput;
end;

class function TTOTPHelper.IntToBigEndianBytes(const AValue: Int64): TBytes;
var
  I: Integer;
  LValue: UInt64;
begin
  SetLength(Result, 8);
  LValue := UInt64(AValue);
  for I := 7 downto 0 do
  begin
    Result[I] := Byte(LValue and $FF);
    LValue := LValue shr 8;
  end;
end;

class function TTOTPHelper.GerarSecret: string;
var
  LBytes: TBytes;
  I: Integer;
  LResult: string;
begin
  SetLength(LBytes, 20);
  for I := 0 to High(LBytes) do
    LBytes[I] := Random(256);

  LResult := '';
  for I := 0 to High(LBytes) do
    LResult := LResult + IntToHex(LBytes[I], 2);

  // Reaproveita os bytes para gerar uma string Base32 legível ao usuário
  Result := '';
  var LBitBuffer: UInt64 := 0;
  var LBitsInBuffer: Integer := 0;
  for I := 0 to High(LBytes) do
  begin
    LBitBuffer := (LBitBuffer shl 8) or LBytes[I];
    Inc(LBitsInBuffer, 8);
    while LBitsInBuffer >= 5 do
    begin
      Dec(LBitsInBuffer, 5);
      Result := Result + BASE32_ALPHABET[((LBitBuffer shr LBitsInBuffer) and $1F) + 1];
    end;
  end;

  if LBitsInBuffer > 0 then
    Result := Result + BASE32_ALPHABET[((LBitBuffer shl (5 - LBitsInBuffer)) and $1F) + 1];
end;

class function TTOTPHelper.GerarCodigo(const ASecretBase32: string;
  const AUnixTime: Int64): string;
var
  LKey, LMessage, LHash: TBytes;
  LCounter, LUnixTime: Int64;
  LOffset: Integer;
  LBinCode: Int64;
  LCodigo: Int64;
begin
  if AUnixTime = 0 then
    LUnixTime := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now))
  else
    LUnixTime := AUnixTime;

  LCounter := LUnixTime div TOTP_STEP_SECONDS;

  LKey := Base32Decode(ASecretBase32);
  LMessage := IntToBigEndianBytes(LCounter);
  LHash := HMACSHA1(LKey, LMessage);

  LOffset := LHash[High(LHash)] and $0F;

  LBinCode :=
    ((LHash[LOffset] and $7F) shl 24) or
    ((LHash[LOffset + 1] and $FF) shl 16) or
    ((LHash[LOffset + 2] and $FF) shl 8) or
    (LHash[LOffset + 3] and $FF);

  LCodigo := LBinCode mod Round(IntPower(10, TOTP_DIGITS));
  Result := Format('%.*d', [TOTP_DIGITS, LCodigo]);
end;

class function TTOTPHelper.ValidarCodigo(const ASecretBase32, ACodigo: string;
  const AToleranciaJanelas: Integer): Boolean;
var
  I: Integer;
  LUnixTimeBase: Int64;
  LCodigoEsperado: string;
begin
  Result := False;
  LUnixTimeBase := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

  for I := -AToleranciaJanelas to AToleranciaJanelas do
  begin
    LCodigoEsperado := GerarCodigo(ASecretBase32, LUnixTimeBase + (I * TOTP_STEP_SECONDS));
    if LCodigoEsperado = ACodigo then
      Exit(True);
  end;
end;

end.
