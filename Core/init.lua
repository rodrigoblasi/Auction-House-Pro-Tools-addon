-- Default header for all modules - don't exclude!
-- Auction House Pro Tools Core module Informations
local moduleName = "Core"
local moduleVersion = "0.1.0"
local addonName = "Auction House Pro Tools"
local addonBranch = "development"
local latestDeploy = "07.10.2024 - 00:39:01"
-- end of default header

--[[ 
    1. Lista de módulos gerenciados pelo Core
    - Aqui está a lista de todos os módulos que o Core vai gerenciar e liberar para carregamento.
    - O Core vai liberar um por um os módulos listados aqui, garantindo que todos carreguem na ordem correta.
--]]
local modulesList = {"LogTester01", "LogTester02"}

--[[ 
    2. Função de log central
    - Essa função será responsável por registrar todas as mensagens de log geradas pelo addon.
    - Suporta múltiplos níveis de log: INFO, DEBUG e ERROR.
    - Verifica se o modo DEBUG está habilitado nas SavedVariables para exibir as mensagens de debug.
--]]
function AuctionHouseProTools_Log(module, level, message)
    local color
    if level == "ERROR" then
        color = "|cFFFF0000" -- Vermelho
    elseif level == "INFO" then
        color = "|cFFFFFFFF" -- Branco
    elseif level == "DEBUG" then
        -- Verifica se o debug do módulo está habilitado
        if not AuctionHouseProToolsSettings[module .. "_debug"] then
            return -- Se o debug do módulo estiver desabilitado, não exibe a mensagem
        end
        color = "|cFF00FFFF" -- Azul Ciano (DEBUG)
    end

    -- Formatar a mensagem de log
    local formattedMessage = string.format("%s - %s%s [%s]: %s|r", addonName, module, color, level, message)
    
    -- Exibir a mensagem no chat
    DEFAULT_CHAT_FRAME:AddMessage(formattedMessage)
end

--[[ 
    3. Função para carregar as configurações do SavedVariables
    - Esta função carrega ou inicializa os valores padrão nas SavedVariables.
    - Usa os valores padrão se as variáveis não estiverem salvas.
--]]
function InitializeConfig()
    -- Inicializando a tabela SavedVariables ou utilizando o valor existente
    AuctionHouseProToolsSettings = AuctionHouseProToolsSettings or {}

    -- Carregando ou configurando os valores padrão
    AuctionHouseProToolsSettings["Core_debug"] = AuctionHouseProToolsSettings["Core_debug"] or false
    AuctionHouseProToolsSettings["ControlPanel_debug"] = AuctionHouseProToolsSettings["ControlPanel_debug"] or false
    AuctionHouseProToolsSettings["LogTester01_started"] = AuctionHouseProToolsSettings["LogTester01_started"] or false
    AuctionHouseProToolsSettings["LogTester01_debug"] = AuctionHouseProToolsSettings["LogTester01_debug"] or false
    AuctionHouseProToolsSettings["LogTester02_started"] = AuctionHouseProToolsSettings["LogTester02_started"] or false
    AuctionHouseProToolsSettings["LogTester02_debug"] = AuctionHouseProToolsSettings["LogTester02_debug"] or false

    -- Log informando que as configurações foram carregadas ou inicializadas
    AuctionHouseProTools_Log(moduleName, "INFO", "SavedVariables loaded or initialized with default values.")
end

--[[ 
    4. Função de log do carregamento do Core
    - Essa função vai logar informações como branch, versão e latest deploy.
    - Inclui cores para diferenciar as branches (development, beta, release).
--]]
function LogCoreLoading()
    -- Definir a cor de acordo com a branch
    local branchColor = "|cFFFFFFFF" -- Branco padrão
    if addonBranch == "development" then
        branchColor = "|cFF00FF00" -- Verde para branch development
    elseif addonBranch == "beta" then
        branchColor = "|cFFFFA500" -- Laranja para branch beta
    elseif addonBranch == "release" then
        branchColor = "|cFF00FFFF" -- Ciano para branch release
    end

    -- Logs de branch e deploy
    AuctionHouseProTools_Log(moduleName, "INFO", branchColor .. "Branch: " .. addonBranch .. "|r")
    AuctionHouseProTools_Log(moduleName, "INFO", branchColor .. "Latest deploy: " .. latestDeploy .. "|r")
end

--[[ 
    5. Função de liberação de carregamento dos módulos 
    - O Core será responsável por liberar a inicialização de cada módulo, seguindo a ordem definida em `modulesList`. 
    - Cada módulo estará aguardando essa liberação e responderá ao Core sobre seu status. 
--]]
function LoadModulesSequentially()
    -- Log informando o início da sequência de carregamento dos módulos
    AuctionHouseProTools_Log("Core", "INFO", "Starting module load sequence.")
    -- Loop para carregar cada módulo listado em modulesList
    for _, moduleName in ipairs(modulesList) do
        -- Verifica se o módulo e sua função de inicialização existem
        if _G[moduleName] and _G[moduleName].Initialize then
            -- Log informando que o Core está iniciando a comunicação com o módulo
            AuctionHouseProTools_Log("Core", "DEBUG", "Sending initialization signal to module: " .. moduleName)
            -- O módulo inicializa e responde ao Core
            _G[moduleName].Initialize()
            -- Recuperar a versão do módulo para incluir no log
            local moduleVersion = _G[moduleName].moduleVersion or "Unknown"
            -- Log do módulo confirmando que foi iniciado com sucesso, incluindo a versão
            AuctionHouseProTools_Log(moduleName, "INFO", "|cFF00FF00Module " .. moduleName .. " v" .. moduleVersion .. " enabled successfully.|r")
            -- Log do módulo enviando uma mensagem de confirmação ao Core
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Sending confirmation to Core: " .. moduleName .. " is loaded.")
        else
            -- Se o módulo não puder ser inicializado
            AuctionHouseProTools_Log("Core", "ERROR", "Failed to load module: " .. moduleName)
        end       
        -- Log informando que o Core vai carregar o próximo módulo
        AuctionHouseProTools_Log("Core", "DEBUG", "Moving to the next module in sequence.")
    end
    -- Log informando que todos os módulos foram carregados com sucesso
    AuctionHouseProTools_Log("Core", "DEBUG", "All modules loaded successfully.")
end

--[[ 
    6. Evento de carregamento do addon (ADDON_LOADED)
    - O Core vai gerenciar o evento ADDON_LOADED para garantir que ele carregue primeiro e só depois libere os módulos.
    - Isso garante que as funções globais e configurações estejam disponíveis para todos os módulos.
--]]
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    -- Verifica se o addon carregado é o Auction House Pro Tools
    if arg1 == "Auction-House-Pro-Tools" then
        InitializeConfig() -- Carregar as configurações
        LogCoreLoading() -- Log de carregamento do Core
        LoadModulesSequentially() -- Liberar os módulos para carregar
        AuctionHouseProTools_Log(moduleName, "INFO", moduleName .. " fully loaded.")
        
        -- Remove o evento ADDON_LOADED, pois não é mais necessário
        self:UnregisterEvent("ADDON_LOADED")
    end
end)