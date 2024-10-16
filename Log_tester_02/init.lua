-- Default header for all modules - don't exclude!
-- LogTester02 module Informations
local moduleName = "LogTester02"
local moduleVersion = "0.1.0"

--[[ 
    1. Variáveis de estado do módulo 
--]]
_G["LogTester02"] = {} -- Certifique-se de que o nome aqui corresponde ao que o Core espera
LogTester02.isStarted = false
LogTester02.isDebug = false
LogTester02.moduleVersion = moduleVersion  -- Atribuindo a versão ao módulo
local ticker -- Referência ao C_Timer.NewTicker

--[[ 
    2. Função para iniciar o módulo (started) 
--]]
function LogTester02.StartModule()
    if LogTester02.isStarted then
        return -- Se já estiver iniciado, não faz nada
    end

    LogTester02.isStarted = true
    AuctionHouseProTools_Log(moduleName, "INFO", "Starting module: " .. moduleName)

    -- Iniciar o Ticker para gerar logs a cada 3 segundos
    ticker = C_Timer.NewTicker(3, function()
        AuctionHouseProTools_Log(moduleName, "INFO", "This is an INFO log message.")
        if LogTester02.isDebug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "This is a DEBUG log message.")
        end
        AuctionHouseProTools_Log(moduleName, "ERROR", "This is an ERROR log message.")
    end)

    -- Log confirmando que o módulo foi iniciado com sucesso
    AuctionHouseProTools_Log(moduleName, "INFO", "Module " .. moduleName .. " started successfully.")
end

--[[ 
    3. Função para parar o módulo (stop) 
--]]
function LogTester02.StopModule()
    if not LogTester02.isStarted then
        return -- O módulo já está parado
    end

    LogTester02.isStarted = false
    AuctionHouseProTools_Log(moduleName, "INFO", "Stopping module: " .. moduleName)

    -- Cancelar o Ticker se ele estiver ativo
    if ticker then
        ticker:Cancel()
        ticker = nil
    end

    AuctionHouseProTools_Log(moduleName, "INFO", "Module " .. moduleName .. " stopped.")
end

--[[ 
    4. Função para habilitar/desabilitar o modo DEBUG 
--]]
function LogTester02.ToggleDebug(state)
    LogTester02.isDebug = state
    if state then
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode enabled.")
    else
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode disabled.")
    end
end

--[[ 
    5. Função de inicialização do módulo (Initialize) 
--]]
function LogTester02.Initialize()
    -- Log de recebimento do sinal do Core
    AuctionHouseProTools_Log(moduleName, "DEBUG", moduleName .. " received initialization signal from Core.")

    -- Restaurar os estados salvos das `SavedVariables`
    if AuctionHouseProToolsSettings["LogTester02_started"] then
        LogTester02.StartModule()
    else
        LogTester02.StopModule()
    end

    LogTester02.ToggleDebug(AuctionHouseProToolsSettings["LogTester02_debug"] or false)

    -- Log de confirmação enviado ao Core
    AuctionHouseProTools_Log(moduleName, "DEBUG", "Sending confirmation to Core: " .. moduleName .. " is loaded.")
end