object FrmDesbloquearUsuario: TFrmDesbloquearUsuario
  Left = 0
  Top = 0
  Caption = 'FrmDesbloquearUsuario'
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
  object DBGrid1: TDBGrid
    Left = 152
    Top = 152
    Width = 320
    Height = 120
    DataSource = dsBloqueados
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object btnDesbloquear: TButton
    Left = 152
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Desbloquear'
    TabOrder = 1
    OnClick = btnDesbloquearClick
  end
  object btnFechar: TButton
    Left = 397
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 2
    OnClick = btnFecharClick
  end
  object qryBloqueados: TFDQuery
    Left = 48
    Top = 48
  end
  object dsBloqueados: TDataSource
    DataSet = qryBloqueados
    Left = 48
    Top = 112
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 152
    Top = 40
  end
end
