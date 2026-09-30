object FrmProdutoEdit: TFrmProdutoEdit
  Left = 0
  Top = 0
  Caption = 'FrmProdutoEdit'
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
    Left = 40
    Top = 91
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object Label2: TLabel
    Left = 40
    Top = 147
    Width = 90
    Height = 15
    Caption = 'C'#243'digo de Barras'
  end
  object Label3: TLabel
    Left = 40
    Top = 211
    Width = 81
    Height = 15
    Caption = 'Pre'#231'o de venda'
  end
  object Label4: TLabel
    Left = 40
    Top = 275
    Width = 42
    Height = 15
    Caption = 'Estoque'
  end
  object edDescricao: TEdit
    Left = 144
    Top = 88
    Width = 387
    Height = 23
    TabOrder = 0
  end
  object edCodigoBarras: TEdit
    Left = 144
    Top = 144
    Width = 387
    Height = 23
    TabOrder = 1
  end
  object edPrecoVenda: TEdit
    Left = 144
    Top = 208
    Width = 121
    Height = 23
    TabOrder = 2
  end
  object edEstoque: TEdit
    Left = 144
    Top = 272
    Width = 121
    Height = 23
    TabOrder = 3
  end
  object chkAtivo: TCheckBox
    Left = 144
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Ativo'
    TabOrder = 4
  end
  object btnSalvar: TButton
    Left = 80
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 5
    OnClick = btnSalvarClick
  end
  object btnCancelar: TButton
    Left = 456
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = btnCancelarClick
  end
end
