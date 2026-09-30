object FrmProdutos: TFrmProdutos
  Left = 0
  Top = 0
  Caption = 'Produtos'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object btnNovo: TButton
    Left = 8
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 0
    OnClick = btnNovoClick
  end
  object btnEditar: TButton
    Left = 104
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 1
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 200
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 2
    OnClick = btnExcluirClick
  end
  object btnAtualizar: TButton
    Left = 294
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Atualizar'
    TabOrder = 3
    OnClick = btnAtualizarClick
  end
  object grdProdutos: TDBGrid
    Left = 8
    Top = 112
    Width = 601
    Height = 233
    DataSource = dsProdutos
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object qryProdutos: TFDQuery
    Left = 40
    Top = 40
  end
  object dsProdutos: TDataSource
    DataSet = qryProdutos
    Left = 112
    Top = 48
  end
end
