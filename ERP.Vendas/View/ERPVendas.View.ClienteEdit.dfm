object FrmClienteEdit: TFrmClienteEdit
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 67
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 24
    Top = 115
    Width = 63
    Height = 15
    Caption = 'Documento'
  end
  object Label3: TLabel
    Left = 24
    Top = 163
    Width = 29
    Height = 15
    Caption = 'Email'
  end
  object Label4: TLabel
    Left = 24
    Top = 216
    Width = 45
    Height = 15
    Caption = 'Telefone'
  end
  object Label5: TLabel
    Left = 24
    Top = 273
    Width = 49
    Height = 15
    Caption = 'Endere'#231'o'
  end
  object Label6: TLabel
    Left = 24
    Top = 331
    Width = 37
    Height = 15
    Caption = 'Cidade'
  end
  object Label7: TLabel
    Left = 24
    Top = 387
    Width = 14
    Height = 15
    Caption = 'UF'
  end
  object edNome: TEdit
    Left = 104
    Top = 64
    Width = 427
    Height = 23
    TabOrder = 0
  end
  object edDocumento: TEdit
    Left = 104
    Top = 112
    Width = 427
    Height = 23
    TabOrder = 1
  end
  object edEmail: TEdit
    Left = 104
    Top = 160
    Width = 427
    Height = 23
    TabOrder = 2
  end
  object edTelefone: TEdit
    Left = 104
    Top = 213
    Width = 427
    Height = 23
    TabOrder = 3
  end
  object edEndereco: TEdit
    Left = 104
    Top = 270
    Width = 427
    Height = 23
    TabOrder = 4
  end
  object edCidade: TEdit
    Left = 104
    Top = 328
    Width = 427
    Height = 23
    TabOrder = 5
  end
  object edUf: TEdit
    Left = 104
    Top = 384
    Width = 121
    Height = 23
    TabOrder = 6
  end
  object chkAtivo: TCheckBox
    Left = 24
    Top = 19
    Width = 97
    Height = 17
    Caption = 'Ativo'
    TabOrder = 7
  end
  object btnSalvar: TButton
    Left = 328
    Top = 383
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 8
    OnClick = btnSalvarClick
  end
  object btnCancelar: TButton
    Left = 456
    Top = 383
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 9
    OnClick = btnCancelarClick
  end
end
