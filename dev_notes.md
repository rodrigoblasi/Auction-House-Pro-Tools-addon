# Apresentação do Addon - Auction House Pro Tools
O Auction House Pro Tools é um addon para World of Warcraft focado em prover ferramentas avançadas para usuários que desejam otimizar o uso da casa de leilões (Auction House). O objetivo principal do addon é fornecer módulos utilitários que ajudem a monitorar vendas, gerenciar leilões e tomar decisões informadas com base em dados em tempo real. Além disso, ele oferece configurações detalhadas para cada módulo, permitindo que o jogador tenha controle total sobre quais funcionalidades deseja ativar e como deseja receber feedback, como logs e alertas.

## Estrutura de Arquivos
O addon é dividido em diversos módulos, cada um com sua função específica. A estrutura é organizada da seguinte forma:

* Core: O núcleo do addon, onde são gerenciadas as funcionalidades globais, como logging e o arquivo de configurações persistentes (SavedVariables).
* Modulos Funcionais: Módulos independentes que realizam funções específicas, como monitoramento de vendas, auxílio em undercutting e etc.
* Painel de Configurações: Um painel global que facilita o gerenciamento de cada módulo, permitindo que o usuário habilite/desabilite módulos e defina parâmetros como o nível de logging.
* Header padrão: cada arquivo de modulo tem um header padrão com informações relevantes sobre o modulo e seu versionamento. o header é fundamental e precisa existir em todos os arquivos
* deploy.py: o deploy é o ato de identificar o versionamento e branch do addon (develooment, beta e release) e também copiar os arquivos para a pasta do addon do jogo, excluindo os arquivos anteriores na pasta deixando somente arquivos atualizados. afim de usar no jogo.
Cada módulo possui seu próprio arquivo init.lua, onde sua lógica é definida. Além disso, o SavedVariables armazena as configurações de cada módulo de forma persistente.

## Versionamento Individual de Módulos
Cada módulo no Auction House Pro Tools possui seu próprio versionamento, facilitando a manutenção e o desenvolvimento contínuo. Isso significa que, além de o addon como um todo ter uma versão, cada funcionalidade também é tratada de forma modular, com seu próprio controle de versão para atualizações independentes.

## Estrutura Geral do Addon
O Auction House Pro Tools foi desenhado para ser altamente modular e flexível. Abaixo estão os componentes principais:

### Módulos
O addon é composto por vários módulos independentes, cada um com sua funcionalidade específica. Esses módulos são gerenciados pelo Core, que centraliza as funções globais e o gerenciamento de logs. O usuário pode ativar ou desativar cada módulo individualmente de acordo com suas preferências.

#### Core
O módulo Core é o coração do addon. Ele gerencia as seguintes funcionalidades globais:

1. Gerenciamento de Logging: Todas as mensagens de log (INFO, ERROR, DEBUG) são enviadas ao Core, que decide se a mensagem será exibida com base nas configurações do módulo requisitante.

2. Gerenciamento de Configurações Persistentes (SavedVariables): O Core também é responsável por garantir que todas as configurações dos módulos sejam persistentes entre sessões. Se um arquivo de SavedVariables não existir, o Core cria um novo com valores padrão para as configurações dos módulos.

3. Gerenciamento de habilitação dos modulos, o core é responsavel por dar sinal aos modulos que eles podem ficar "enabled", organizando a ordem ao qual os modulos ficam disponiveis no addon. O estado de enabled é diferente do estado de started, onde um modulo pode estar enabled=true e started=false.

#### Painel de Configurações
O addon também oferece um painel global, onde o jogador pode gerenciar cada módulo, ativar/desativar funcionalidades e ajustar configurações de log (por exemplo, habilitar ou desabilitar o modo DEBUG de um módulo). O painel fornece uma interface simples e intuitiva para o controle centralizado de todas as ferramentas.

#### Arquivo SavedVariables
As configurações de cada módulo são salvas no arquivo AuctionHouseProTools.lua, localizado na pasta de SavedVariables. O Core gerencia a leitura e escrita dessas configurações para garantir que qualquer alteração feita nas configurações do jogo seja mantida entre sessões.

Exemplo de SavedVariables:
``` lua
AuctionHouseProTools = {
    ["LogTester01_enabled"] = true,
    ["LogTester01_debug"] = true,
    ["LogTester02_enabled"] = true,
    ["LogTester02_debug"] = false,
    -- Configurações de outros módulos...
}
```
Esse arquivo é atualizado automaticamente sempre que o jogador altera as configurações de qualquer módulo durante o jogo.

## Módulos
### Estados dos modulos

um modulo (com excessão do core) pode ter 3 estados.

* enabled = true/false -- indica se o modulo está habilitado no addon, mas não necessariamente executando suas funções. este estado indica se o addon está disponivel para iniciar suas funções. este é o estado ao qual o modulo deve confirmar ao core.

* started = true/false -- indica se o modulo está, de fato executando sua função principal, pois hipoteticamente um modulo pode estar enabled=true mas started=false

* debug = true/false -- auto explicativo, os logs deste modulo estão habilitados pra mostrar mensagens em modo DEBUG além de INFO e ERROR usando o modulo padrão de mensagens do addon, este estado serve pra facilitar na identificação de erros e desenvolvimento

#### Modulo: Core
O Core é o módulo central responsável por várias funções globais, incluindo:

* *Gerenciamento do SavedVariables:* O Core é responsável por carregar as configurações do SavedVariables no momento do carregamento do addon. Se um módulo não tiver configurações salvas, o Core cria valores padrão para ele.

* *Função de Logging:* O Core recebe as requisições de log dos módulos e decide o que deve ser exibido. Mensagens de DEBUG são filtradas com base nas configurações de cada módulo.

* Gerenciamento de habilitação dos modulos, o core é responsavel por dar sinal aos modulos que eles podem ficar "enabled", organizando a ordem ao qual os modulos ficam disponiveis no addon. O estado de enabled é diferente do estado de started, onde um modulo pode estar enabled=true e started=false.

---
#### Módulos de Teste
Estamos atualmente desenvolvendo e testando funcionalidades de gerenciamento dos estados de módulos e controle de mensagens de log com dois módulos de teste: LogTester01 e LogTester02.

* LogTester01 e LogTester02:

Estes módulos geram logs a cada 3 segundos.
servem pra testes dos mais variados no addon


*A ideia é testar a independência entre módulos e garantir que a mudança de estado de um módulo não afete o comportamento do outro.
Esses módulos de teste são essenciais para validar as funcionalidades basicas do addon, os resultados obtidos com estes modulos serão aplicados como base para os proximos modulos*

