unit Shared.Model.Entities;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  Shared.Utils.RTTIHelper;

type
  TStatusVenda = (svPendente, svQuitada, svCancelada);

  TUsuario = class
  private
    FId: Integer;
    FLogin: string;
    FNome: string;
    FSenhaHash: string;
    FSenhaSalt: string;
    FTotpSecret: string;
    FEAdmin: Boolean;
    FTentativasFalhas: Integer;
    FBloqueado: Boolean;
    FAtivo: Boolean;
  published
    [Column('ID')]
    property Id: Integer read FId write FId;
    [Column('LOGIN')]
    property Login: string read FLogin write FLogin;
    [Column('NOME')]
    property Nome: string read FNome write FNome;
    [Column('SENHA_HASH')]
    property SenhaHash: string read FSenhaHash write FSenhaHash;
    [Column('SENHA_SALT')]
    property SenhaSalt: string read FSenhaSalt write FSenhaSalt;
    [Column('TOTP_SECRET')]
    property TotpSecret: string read FTotpSecret write FTotpSecret;
    [Column('E_ADMIN')]
    property EAdmin: Boolean read FEAdmin write FEAdmin;
    [Column('TENTATIVAS_FALHAS')]
    property TentativasFalhas: Integer read FTentativasFalhas write FTentativasFalhas;
    [Column('BLOQUEADO')]
    property Bloqueado: Boolean read FBloqueado write FBloqueado;
    [Column('ATIVO')]
    property Ativo: Boolean read FAtivo write FAtivo;
  end;

  TCliente = class
  private
    FId: Integer;
    FNome: string;
    FDocumento: string;
    FEmail: string;
    FTelefone: string;
    FEndereco: string;
    FCidade: string;
    FUf: string;
    FAtivo: Boolean;
  published
    [Column('ID')]
    property Id: Integer read FId write FId;
    [Column('NOME')]
    property Nome: string read FNome write FNome;
    [Column('DOCUMENTO')]
    property Documento: string read FDocumento write FDocumento;
    [Column('EMAIL')]
    property Email: string read FEmail write FEmail;
    [Column('TELEFONE')]
    property Telefone: string read FTelefone write FTelefone;
    [Column('ENDERECO')]
    property Endereco: string read FEndereco write FEndereco;
    [Column('CIDADE')]
    property Cidade: string read FCidade write FCidade;
    [Column('UF')]
    property Uf: string read FUf write FUf;
    [Column('ATIVO')]
    property Ativo: Boolean read FAtivo write FAtivo;
  end;

  TProduto = class
  private
    FId: Integer;
    FDescricao: string;
    FCodigoBarras: string;
    FPrecoVenda: Currency;
    FEstoque: Integer;
    FAtivo: Boolean;
  published
    [Column('ID')]
    property Id: Integer read FId write FId;
    [Column('DESCRICAO')]
    property Descricao: string read FDescricao write FDescricao;
    [Column('CODIGO_BARRAS')]
    property CodigoBarras: string read FCodigoBarras write FCodigoBarras;
    [Column('PRECO_VENDA')]
    property PrecoVenda: Currency read FPrecoVenda write FPrecoVenda;
    [Column('ESTOQUE')]
    property Estoque: Integer read FEstoque write FEstoque;
    [Column('ATIVO')]
    property Ativo: Boolean read FAtivo write FAtivo;
  end;

  TItemVenda = class
  private
    FId: Integer;
    FIdVenda: Integer;
    FIdProduto: Integer;
    FQuantidade: Integer;
    FPrecoUnitario: Currency;
    FSubtotal: Currency;
  published
    [Column('ID')]
    property Id: Integer read FId write FId;
    [Column('ID_VENDA')]
    property IdVenda: Integer read FIdVenda write FIdVenda;
    [Column('ID_PRODUTO')]
    property IdProduto: Integer read FIdProduto write FIdProduto;
    [Column('QUANTIDADE')]
    property Quantidade: Integer read FQuantidade write FQuantidade;
    [Column('PRECO_UNITARIO')]
    property PrecoUnitario: Currency read FPrecoUnitario write FPrecoUnitario;
    [Column('SUBTOTAL')]
    property Subtotal: Currency read FSubtotal write FSubtotal;
  end;

  TVenda = class
  private
    FId: Integer;
    FIdCliente: Integer;
    FIdUsuario: Integer;
    FDataVenda: TDateTime;
    FValorTotal: Currency;
    FStatus: TStatusVenda;
    FObservacao: string;
    FRelatorioEnviado: Boolean;
    FItens: TObjectList<TItemVenda>;
  public
    constructor Create;
    destructor Destroy; override;
    property Itens: TObjectList<TItemVenda> read FItens;
  published
    [Column('ID')]
    property Id: Integer read FId write FId;
    [Column('ID_CLIENTE')]
    property IdCliente: Integer read FIdCliente write FIdCliente;
    [Column('ID_USUARIO')]
    property IdUsuario: Integer read FIdUsuario write FIdUsuario;
    [Column('DATA_VENDA')]
    property DataVenda: TDateTime read FDataVenda write FDataVenda;
    [Column('VALOR_TOTAL')]
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    [Column('STATUS')]
    property Status: TStatusVenda read FStatus write FStatus;
    [Column('OBSERVACAO')]
    property Observacao: string read FObservacao write FObservacao;
    [Column('RELATORIO_ENVIADO')]
    property RelatorioEnviado: Boolean read FRelatorioEnviado write FRelatorioEnviado;
  end;

implementation

{ TVenda }

constructor TVenda.Create;
begin
  inherited Create;
  FItens := TObjectList<TItemVenda>.Create(True);
  FStatus := svPendente;
end;

destructor TVenda.Destroy;
begin
  FItens.Free;
  inherited Destroy;
end;

end.
