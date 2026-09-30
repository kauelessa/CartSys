object FrmClientes: TFrmClientes
  Left = 0
  Top = 0
  Caption = 'Clientes'
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
  object grdClientes: TDBGrid
    Left = 8
    Top = 128
    Width = 601
    Height = 225
    DataSource = dsClientes
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object btnNovo: TButton
    Left = 8
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 1
    OnClick = btnNovoClick
  end
  object btnEditar: TButton
    Left = 104
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 2
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 200
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
    OnClick = btnExcluirClick
  end
  object btnAtualizar: TButton
    Left = 294
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Atualizar'
    TabOrder = 4
    OnClick = btnAtualizarClick
  end
  object qryClientes: TFDQuery
    Left = 40
    Top = 32
  end
  object dsClientes: TDataSource
    DataSet = qryClientes
    Left = 120
    Top = 32
  end
end
