# Nomenclatura de arquivos

## 1. Nomes de Arquivos
* Convencional: Tudo minúsculo.
* Separação de Palavras: Usar underlines (_) para separar palavras quando necessário.
Exemplo: auctionhouse_actions.lua, log.lua.

## 2. Variáveis e Funções Locais
* Padrão: camelCase.
* Explicação: A primeira letra é minúscula, cada palavra subsequente começa com uma letra maiúscula. Isso é adequado para manter a legibilidade e clareza ao descrever variáveis e funções de uso local.
Exemplo: scanItem(), totalItems, postItem().

## 3. Variáveis e Funções Globais
* Padrão: PascalCase.
* Explicação: A primeira letra de cada palavra é maiúscula. Isso é especialmente útil para indicar que algo está no escopo global e agrupa funcionalidades.
Exemplo: AuctionHouseActions, GlobalHandler, ModuleManager.



# Ordem geral de inicialização do addon

 * Snippet de log inicializado = _G["Log] disponível globalmente
    - Como fazer pra que mensagens de log DEBUG sobre a inicialização correta deste snippet apareçam na inicialização do addon somente quando o core.debug=TRUE?
 
 * Snippet de module_settings inicializado = certeza que a tabela "ModuleSettings" tem as configurações necessárias de todos os modulos, se ela estiver vazia, os valores padrão serão inseridos.
    - Como fazer pra que mensagens de log DEBUG sobre a inicialização correta deste snippet apareçam na inicialização do addon somente quando o core.debug=TRUE?
 * Snippet de component_initializer iniciado = deixar os componentes globalmente disponiveis para que todos os componentes do addon possam consultar informações entre si.