object FrmLogin: TFrmLogin
  Left = 0
  Top = 0
  Caption = 'Login - Financeiro'
  ClientHeight = 210
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblStatus: TLabel
    Left = 144
    Top = 175
    Width = 3
    Height = 15
  end
  object Label1: TLabel
    Left = 32
    Top = 43
    Width = 30
    Height = 15
    Caption = 'Login'
  end
  object Label2: TLabel
    Left = 32
    Top = 72
    Width = 32
    Height = 15
    Caption = 'Senha'
  end
  object Label3: TLabel
    Left = 32
    Top = 101
    Width = 39
    Height = 15
    Caption = 'C'#243'digo'
  end
  object edLogin: TEdit
    Left = 104
    Top = 40
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object edSenha: TEdit
    Left = 104
    Top = 69
    Width = 121
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object edCodigoTotp: TEdit
    Left = 104
    Top = 98
    Width = 121
    Height = 23
    MaxLength = 6
    NumbersOnly = True
    TabOrder = 2
  end
  object btnEntrar: TButton
    Left = 104
    Top = 144
    Width = 121
    Height = 25
    Caption = 'Entrar'
    TabOrder = 3
    OnClick = btnEntrarClick
  end
end
