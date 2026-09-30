object FrmFinanceiroMain: TFrmFinanceiroMain
  Left = 0
  Top = 0
  Caption = 'ERP Financeiro - Vendas Pendentes'
  ClientHeight = 450
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 16
    Top = 12
    Width = 235
    Height = 21
    Caption = 'Vendas Pendentes de Quita'#231#227'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grdPendentes: TDBGrid
    Left = 16
    Top = 44
    Width = 768
    Height = 340
    DataSource = dsPendentes
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object btnQuitar: TButton
    Left = 16
    Top = 400
    Width = 120
    Height = 32
    Caption = 'Quitar Venda'
    TabOrder = 1
    OnClick = btnQuitarClick
  end
  object btnCancelar: TButton
    Left = 152
    Top = 400
    Width = 120
    Height = 32
    Caption = 'Cancelar Venda'
    TabOrder = 2
    OnClick = btnCancelarClick
  end
  object btnAtualizar: TButton
    Left = 664
    Top = 400
    Width = 120
    Height = 32
    Caption = 'Atualizar Lista'
    TabOrder = 3
    OnClick = btnAtualizarClick
  end
  object btnDashboard: TButton
    Left = 538
    Top = 400
    Width = 120
    Height = 32
    Caption = 'Dashboard'
    TabOrder = 4
    OnClick = btnDashboardClick
  end
  object qryPendentes: TFDQuery
    Left = 400
    Top = 200
  end
  object dsPendentes: TDataSource
    DataSet = qryPendentes
    Left = 456
    Top = 200
  end
end
