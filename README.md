# CartSys
Projeto de avaliação para a empresa CartSys

Documentação para Execução do Sistema CartSys ERP
Aviso Importante sobre Tecnologia Utilizada
O presente sistema foi desenvolvido originalmente com a intenção de utilizar
componentes visuais DevExpress (VCL) para a construção das interfaces gráficas.
Entretanto, verificou-se que a edição Delphi 12 Community não oferece suporte à
instalação e uso dos pacotes DevExpress, uma vez que essa suíte de componentes
exige licenciamento e integração compatível apenas com edições pagas do Delphi
(Professional, Enterprise ou Architect).
Diante dessa limitação técnica, optou-se pela reconstrução de toda a camada de
apresentação utilizando exclusivamente componentes nativos da VCL (Visual
Component Library), acompanhados do FireDAC para acesso a dados e do
ReportBuilder para geração de relatórios, ambos plenamente compatíveis com a
edição Community. Essa decisão não compromete a entrega dos requisitos
funcionais especificados no teste técnico, apenas ajusta a camada visual para
tecnologias livres de custo adicional de licenciamento.
Requisitos para Execução
Ambiente e Versões Utilizadas
Para a execução correta do sistema, o avaliador deve dispor do seguinte ambiente:
Sistema gerenciador de banco de dados Firebird, versão 3.0.
IDE Delphi 12, edição Community (caso deseje recompilar o código-fonte).
ReportBuilder, versão Demo Copy 23.02 Build 294, utilizado para a geração do
relatório de confirmação de pedido em formato PDF.
Banco de Dados
O arquivo de banco de dados Firebird (extensão .fdb) será entregue já estruturado e
populado com o usuário administrador inicial, dispensando a necessidade de
execução de scripts de criação ou seed por parte do avaliador. Basta posicionar o
arquivo .fdb em um diretório acessível pela máquina onde os executáveis serão
rodados, e o Firebird 3.0 deve estar instalado e em execução como serviço nessa
mesma máquina (ou em um servidor acessível na rede, caso o teste seja feito de
forma distribuída).
Arquivo de Configuração (CartSys.ini)
Cada um dos dois executáveis do sistema (ERP Vendas e ERP Financeiro)
depende de um arquivo de configuração chamado CartSys.ini, que deve ser
posicionado na mesma pasta do respectivo executável. Esse arquivo não é
entregue pré-configurado, sendo de responsabilidade do avaliador ajustá-lo
manualmente antes da primeira execução, contemplando:
Os dados de conexão FireDAC com o banco de dados Firebird (caminho do arquivo
.fdb, usuário e senha do banco).
Os dados do servidor SMTP utilizado para o envio do e-mail de confirmação de
quitação de vendas (host, porta, usuário e senha de autenticação, e uso de
SSL/TLS).
Dependências de Bibliotecas Externas (Indy/OpenSSL)
O módulo ERP Financeiro utiliza a biblioteca Indy para o envio de e-mails via
protocolo SMTP com criptografia SSL/TLS. Para que essa funcionalidade opere
corretamente, é necessário manter as bibliotecas dinâmicas (DLLs) das quais o Indy
depende no mesmo diretório do executável do ERP Financeiro. Essas DLLs
correspondem à implementação OpenSSL compatível com a versão utilizada
internamente pelo Indy (série 1.0.2), sendo especificamente os arquivos libeay32.dll
e ssleay32.dll. A ausência desses arquivos na pasta do executável resulta em erro
de carregamento da biblioteca SSL no momento do envio do e-mail, impedindo o
disparo da mensagem de confirmação, ainda que as demais funcionalidades do
sistema permaneçam operacionais normalmente.
Usuário para Testes
Para viabilizar a execução dos testes de login, autenticação e navegação pelo
sistema, foi cadastrado previamente no banco de dados um usuário administrador
com as seguintes credenciais:
Login: admin
Senha: 1234
O sistema utiliza autenticação em dois fatores baseada no padrão TOTP
(Time-based One-Time Password, RFC 6238), exigindo, além de login e senha, um
código numérico de seis dígitos gerado por aplicativo autenticador (como Google
Authenticator ou Microsoft Authenticator). Para configurar esse usuário em um
aplicativo autenticador, o avaliador deve adicionar uma conta manualmente,
informando a seguinte chave secreta:
Chave secreta: CB2HEIX75CNEBMOTF7P5O6R4LLNLDGBT
Após inserida a chave, o aplicativo autenticador passará a gerar automaticamente o
código de seis dígitos renovado a cada trinta segundos, que deve ser informado no
campo correspondente da tela de login no momento da autenticação.
Fluxo Geral do Sistema
O sistema é composto por dois executáveis independentes, que compartilham a
mesma base de dados e a mesma lógica de autenticação, porém operam como
processos desacoplados: ERP Vendas e ERP Financeiro.
ERP Vendas
Ao ser iniciado, o executável apresenta a tela de login, exigindo usuário, senha e
código TOTP. Após autenticação bem-sucedida, o usuário é direcionado à tela
principal, a partir da qual pode acessar os cadastros de clientes e produtos, realizar
o lançamento de novas vendas (com múltiplos itens, cálculo automático de total e
baixa de estoque correspondente) e, caso possua permissão administrativa,
desbloquear usuários que tenham excedido o limite de tentativas de login inválidas.
Ao finalizar uma venda, o sistema disponibiliza a impressão do comprovante de
pedido em PDF através do ReportBuilder.
ERP Financeiro
Também protegido pela mesma tela de login e mesmas credenciais de autenticação,
o ERP Financeiro apresenta ao usuário autenticado uma listagem das vendas
pendentes de quitação. A partir dessa tela, é possível quitar uma venda, ação que
atualiza seu status no banco de dados, dispara automaticamente um e-mail de
confirmação ao endereço eletrônico cadastrado do cliente (com o comprovante em
PDF anexado), ou cancelar uma venda, ação que reverte o status e estorna as
quantidades de estoque previamente baixadas pelos itens vendidos.
O ERP Financeiro conta ainda com uma tela de dashboard, acessível a partir da tela
principal, que apresenta indicadores consolidados de desempenho comercial:
quantidade de ordens de venda finalizadas, quantidade de ordens de venda
pendentes, valor projetado a ser recebido (soma das vendas pendentes), valor
efetivamente vendido (soma das vendas quitadas), além de gráficos com os cinco
produtos mais vendidos e os cinco clientes que mais compraram, considerados em
quantidade e valor, respectivamente.
Recursos e Tecnologias Utilizadas
FireDAC
Utilizado como camada de acesso a dados em toda a aplicação, através de
componentes TFDConnection e TFDQuery, responsáveis pela comunicação com o
banco de dados Firebird, incluindo execução de consultas parametrizadas,
transações explícitas (commit e rollback) nas operações críticas de cancelamento
de venda com estorno de estoque, e leitura de metadados de campos para o
mapeamento genérico via reflexão.
Threads
A autenticação do usuário (validação de login, senha e código TOTP contra o banco
de dados) é executada em uma thread secundária, evitando o congelamento da
interface gráfica durante a consulta ao banco de dados. A comunicação de resultado
entre a thread e a interface principal é realizada através de eventos sincronizados,
garantindo atualização segura dos componentes visuais a partir da thread principal
da aplicação.
Generics
A camada de acesso a dados compartilhada entre os dois módulos do sistema
implementa um repositório genérico, capaz de operar sobre qualquer entidade do
domínio (cliente, produto, venda, usuário) através de um único conjunto de métodos
parametrizados por tipo, eliminando a duplicação de código que seria necessária
para implementar operações de CRUD individualmente para cada entidade.
RTTI (Reflexão)
O repositório genérico utiliza informações de tipo em tempo de execução (Run-Time
Type Information) para mapear automaticamente os campos retornados pelas
consultas ao banco de dados para as propriedades correspondentes das classes de
entidade, dispensando a escrita manual de código de conversão campo a campo
para cada nova entidade criada no sistema.
Procedural Types e Manipulação de Eventos
O sistema faz uso extensivo de tipos procedurais para a definição de eventos
customizados, como os disparados pela thread de autenticação ao concluir o
processo de login (sucesso, erro ou bloqueio de usuário), permitindo que a interface
reaja de forma desacoplada ao resultado da autenticação sem necessidade de
acoplamento direto entre a lógica de negócio e a camada visual.
Métodos de Classe
Diversas operações que não dependem de estado de instância, como a geração do
arquivo PDF do relatório de confirmação de pedido, são implementadas como
métodos de classe, permitindo sua invocação direta sem a necessidade de criação
prévia de uma instância do formulário ou controlador correspondente.
Interfaces
A camada de acesso a dados compartilhada define contratos através de interfaces,
desacoplando a lógica de negócio da implementação concreta de persistência, o
que permite a substituição ou extensão futura da camada de dados sem impacto
nas camadas superiores da aplicação.
Gerenciamento de Memória
Todas as instâncias criadas dinamicamente ao longo do sistema (formulários,
queries auxiliares, objetos de entidade) são devidamente liberadas através de
blocos try/finally, garantindo a ausência de vazamentos de memória mesmo em
cenários de exceção durante a execução das rotinas.
Tratamento de Exceções
As operações críticas do sistema, como transações financeiras e envio de e-mail,
são protegidas por blocos de tratamento de exceção, assegurando que falhas
pontuais (como indisponibilidade do servidor SMTP) não comprometam a
integridade das operações principais já efetivadas no banco de dados, sendo o
usuário informado de forma clara sobre eventuais falhas secundárias sem
interrupção do fluxo principal.
Envio de E-mail (Indy)
O disparo automático de e-mail de confirmação ao cliente, no momento da quitação
de uma venda, é realizado através dos componentes da biblioteca Indy, com
autenticação SMTP sobre conexão criptografada TLS, incluindo o comprovante em
PDF da venda como anexo à mensagem.
Geração de Relatórios (ReportBuilder)
O comprovante de confirmação de pedido é gerado através do ReportBuilder,
exportado em formato PDF, sendo anexado automaticamente ao e-mail de
confirmação enviado ao cliente no momento da quitação da venda.
