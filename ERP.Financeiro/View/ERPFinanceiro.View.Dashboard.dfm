object FrmDashboard: TFrmDashboard
  Left = 0
  Top = 0
  Caption = 'Dashboard - Financeiro'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 110
    Align = alTop
    TabOrder = 0
    object lblTituloFinalizadas: TLabel
      Left = 24
      Top = 12
      Width = 98
      Height = 15
      Caption = 'Ordens Finalizadas'
    end
    object lblQtdFinalizadas: TLabel
      Left = 24
      Top = 32
      Width = 11
      Height = 25
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTituloPendentes: TLabel
      Left = 224
      Top = 12
      Width = 96
      Height = 15
      Caption = 'Ordens Pendentes'
    end
    object lblQtdPendentes: TLabel
      Left = 224
      Top = 32
      Width = 11
      Height = 25
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTituloProjetado: TLabel
      Left = 424
      Top = 12
      Width = 141
      Height = 15
      Caption = 'Valor Projetado (Pendente)'
    end
    object lblValorProjetado: TLabel
      Left = 424
      Top = 32
      Width = 66
      Height = 25
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTituloVendido: TLabel
      Left = 664
      Top = 12
      Width = 131
      Height = 15
      Caption = 'Valor Realmente Vendido'
    end
    object lblValorVendido: TLabel
      Left = 664
      Top = 32
      Width = 66
      Height = 25
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnAtualizar: TButton
      Left = 780
      Top = 70
      Width = 100
      Height = 28
      Caption = 'Atualizar'
      TabOrder = 0
      OnClick = btnAtualizarClick
    end
  end
  object chartTopProdutos: TChart
    Left = 0
    Top = 110
    Width = 450
    Height = 490
    Title.Text.Strings = (
      'Top 5 Produtos Mais Vendidos')
    Align = alLeft
    TabOrder = 1
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object serieProdutos: TBarSeries
      HoverElement = []
      SeriesColor = clSkyBlue
      Title = 'Quantidade Vendida'
      XValues.Name = 'X'
      XValues.Order = loNone
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object chartTopClientes: TChart
    Left = 450
    Top = 110
    Width = 450
    Height = 490
    Title.Text.Strings = (
      'Top 5 Clientes')
    Align = alClient
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object serieClientes: TBarSeries
      HoverElement = []
      SeriesColor = clMoneyGreen
      Title = 'Total Comprado (R$)'
      XValues.Name = 'X'
      XValues.Order = loNone
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object qryIndicadores: TFDQuery
    Left = 40
    Top = 200
  end
  object qryTopProdutos: TFDQuery
    Left = 96
    Top = 200
  end
  object qryTopClientes: TFDQuery
    Left = 152
    Top = 200
  end
end
