object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'CartSys'
  ClientHeight = 227
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poMainFormCenter
  TextHeight = 15
  object MainMenu1: TMainMenu
    Left = 72
    Top = 56
    object mnuCadastros: TMenuItem
      Caption = 'Cadastros'
      object mnuClientes: TMenuItem
        Caption = 'Clientes'
        OnClick = mnuClientesClick
      end
      object mnuProdutos: TMenuItem
        Caption = 'Produtos'
        OnClick = mnuProdutosClick
      end
    end
    object mnuVendas: TMenuItem
      Caption = 'Vendas'
      OnClick = mnuVendasClick
    end
    object mnuAdministracao: TMenuItem
      Caption = 'Administracao'
      object mnuDesbloquearUsuario: TMenuItem
        Caption = 'Desbloquear Usu'#225'rio'
        OnClick = mnuDesbloquearUsuarioClick
      end
    end
  end
end
