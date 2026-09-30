object FrmVenda: TFrmVenda
  Left = 0
  Top = 0
  Caption = 'Vendas'
  ClientHeight = 568
  ClientWidth = 624
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
  object lblTotal: TLabel
    Left = 186
    Top = 212
    Width = 39
    Height = 15
    Caption = 'lblTotal'
  end
  object Label1: TLabel
    Left = 24
    Top = 19
    Width = 37
    Height = 15
    Caption = 'Cliente'
  end
  object Label2: TLabel
    Left = 24
    Top = 67
    Width = 43
    Height = 15
    Caption = 'Produto'
  end
  object Label3: TLabel
    Left = 24
    Top = 107
    Width = 62
    Height = 15
    Caption = 'Quantidade'
  end
  object Label4: TLabel
    Left = 24
    Top = 155
    Width = 62
    Height = 15
    Caption = 'Observa'#231#227'o'
  end
  object cbCliente: TComboBox
    Left = 104
    Top = 16
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 0
  end
  object cbProduto: TComboBox
    Left = 104
    Top = 64
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 1
  end
  object edObservacao: TEdit
    Left = 104
    Top = 152
    Width = 121
    Height = 23
    TabOrder = 2
  end
  object edQuantidade: TEdit
    Left = 104
    Top = 104
    Width = 121
    Height = 23
    NumbersOnly = True
    TabOrder = 3
  end
  object btnAdicionarItem: TButton
    Left = 24
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Adicionar'
    TabOrder = 4
    OnClick = btnAdicionarItemClick
  end
  object btnSalvar: TButton
    Left = 438
    Top = 512
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 5
    OnClick = btnSalvarClick
  end
  object btnCancelar: TButton
    Left = 526
    Top = 512
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = btnCancelarClick
  end
  object grdItens: TDBGrid
    Left = 24
    Top = 256
    Width = 577
    Height = 233
    DataSource = dsItens
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object tblItens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 456
    Top = 88
  end
  object dsItens: TDataSource
    DataSet = tblItens
    Left = 448
    Top = 160
  end
end
