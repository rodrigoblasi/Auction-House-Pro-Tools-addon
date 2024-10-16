-- Default header for all modules - don't exclude!
-- Undercut Wars Helper Module Information
local moduleName = "UndercutWarsHelper"
local moduleVersion = "0.1.0"

-- Module state variables
_G[moduleName] = {}
UndercutWarsHelper.isEnabled = false -- Controlado pelo Core
UndercutWarsHelper.isStarted = false -- Indica se o módulo está ativo
UndercutWarsHelper.isDebug = false -- Indica se o modo debug está ativado
UndercutWarsHelper.moduleVersion = moduleVersion

-- Função para buscar o preço do item
local function ScanItemPrice(itemID)
    if not itemID or itemID == "" then
        AuctionHouseProTools_Log(moduleName, "ERROR", "No item ID entered.")
        return
    end
    
    -- Criar a chave do item com base no ID
    local itemKey = C_AuctionHouse.MakeItemKey(tonumber(itemID)) -- Usando MakeItemKey para criar chave correta
    
    -- Debug da chave do item
    AuctionHouseProTools_Log(moduleName, "DEBUG", "ItemKey generated: " .. tostring(itemKey.itemID))

    -- Definir a ordem de pesquisa por preço (Buyout)
    local sorts = { { sortOrder = Enum.AuctionHouseSortOrder.Buyout, reverseSort = false } }

    -- Debug da ordenação
    AuctionHouseProTools_Log(moduleName, "DEBUG", "Sort order: Buyout, reverseSort: false")

    -- Verificar se a Auction House está aberta antes de continuar
    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
        AuctionHouseProTools_Log(moduleName, "ERROR", "Auction House must be open to scan.")
        return
    end
    
    -- Enviar a consulta de busca para a Auction House
    AuctionHouseProTools_Log(moduleName, "INFO", "Sending search query for item ID: " .. itemID)
    C_AuctionHouse.SendSearchQuery(itemKey, sorts, false)
end

-- Função para registrar eventos e receber resultados
local function RegisterAuctionHouseEvents()
    -- Criar frame para registrar eventos
    local eventFrame = CreateFrame("Frame")
    
    -- Função de evento para capturar resultados de busca de itens normais
    eventFrame:RegisterEvent("ITEM_SEARCH_RESULTS_ADDED")
    eventFrame:RegisterEvent("COMMODITY_SEARCH_RESULTS_UPDATED")
    
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "ITEM_SEARCH_RESULTS_ADDED" then
            local itemKey = ...
            local numResults = C_AuctionHouse.GetNumItemSearchResults(itemKey)
            AuctionHouseProTools_Log(moduleName, "INFO", "Item search results: " .. numResults)
            
            for i = 1, numResults do
                local result = C_AuctionHouse.GetItemSearchResultInfo(itemKey, i)
                if result then
                    AuctionHouseProTools_Log(moduleName, "INFO", "Result " .. i .. ": " .. tostring(result))
                end
            end
        elseif event == "COMMODITY_SEARCH_RESULTS_UPDATED" then
            local itemID = ...
            local numResults = C_AuctionHouse.GetNumCommoditySearchResults(itemID)
            AuctionHouseProTools_Log(moduleName, "INFO", "Commodity search results: " .. numResults)
            
            for i = 1, numResults do
                local result = C_AuctionHouse.GetCommoditySearchResultInfo(i)
                if result then
                    AuctionHouseProTools_Log(moduleName, "INFO", "Commodity Result " .. i .. ": " .. tostring(result))
                end
            end
        end
    end)
    
    AuctionHouseProTools_Log(moduleName, "DEBUG", "Auction House events registered.")
end

-- Função para criar a interface do frame principal
function UndercutWarsHelper.CreateUI()
    AuctionHouseProTools_Log(moduleName, "DEBUG", "Creating UI")

    -- Criar o frame principal
    UndercutWarsHelper.frame = CreateFrame("Frame", "UndercutWarsHelperFrame", UIParent, "BasicFrameTemplateWithInset")
    UndercutWarsHelper.frame:SetSize(400, 100) -- Garantir que o tamanho seja visível
    UndercutWarsHelper.frame:SetPoint("CENTER") -- Garantir que o frame apareça no centro
    UndercutWarsHelper.frame:EnableMouse(true) -- Permitir interações com o mouse
    UndercutWarsHelper.frame:Show() -- Garantir que o frame seja exibido

    -- Título do frame
    local title = UndercutWarsHelper.frame:CreateFontString(nil, "OVERLAY")
    title:SetFontObject("GameFontHighlightLarge")
    title:SetPoint("TOP", 0, -2)
    title:SetText("Undercut Wars Helper")

    -- Campo de texto para entrada de IDs
    local itemInputBox = CreateFrame("EditBox", nil, UndercutWarsHelper.frame, "InputBoxTemplate")
    itemInputBox:SetPoint("TOP", UndercutWarsHelper.frame, "TOP", 0, -40)
    itemInputBox:SetSize(250, 30)
    itemInputBox:SetAutoFocus(false)
    itemInputBox:SetMaxLetters(100)
    itemInputBox:SetText("24297") -- Valor default para debug

    -- Botão Scan
    local scanButton = CreateFrame("Button", nil, UndercutWarsHelper.frame, "UIPanelButtonTemplate")
    scanButton:SetSize(70, 25)
    scanButton:SetPoint("LEFT", itemInputBox, "RIGHT", 10, 0)
    scanButton:SetText("Scan")
    scanButton:SetScript("OnClick", function()
        local itemID = itemInputBox:GetText()
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Scan button clicked with item ID: " .. (itemID or "nil"))
        ScanItemPrice(itemID)
    end)

    -- Exibir o frame ao criar a UI
    UndercutWarsHelper.frame:Show()
end

-- Função para iniciar o módulo
function UndercutWarsHelper.StartModule()
    AuctionHouseProTools_Log(moduleName, "DEBUG", "StartModule called")

    if not UndercutWarsHelper.isStarted then
        UndercutWarsHelper.isStarted = true
        AuctionHouseProTools_Log(moduleName, "INFO", "Starting module: " .. moduleName)
        UndercutWarsHelper.CreateUI()
        RegisterAuctionHouseEvents() -- Registrar eventos de busca da Auction House
    else
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Module already started")
    end
end

-- Função para parar o módulo
function UndercutWarsHelper.StopModule()
    AuctionHouseProTools_Log(moduleName, "DEBUG", "StopModule called")

    if not UndercutWarsHelper.isStarted then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Module is not started")
        return
    end
    UndercutWarsHelper.isStarted = false
    AuctionHouseProTools_Log(moduleName, "INFO", "Stopping module: " .. moduleName)
    if UndercutWarsHelper.frame then
        UndercutWarsHelper.frame:Hide()
    end
end

--[[ Funções para comunicação com o Core ]]
function UndercutWarsHelper.EnableModule()
    AuctionHouseProTools_Log(moduleName, "DEBUG", "EnableModule called")
    UndercutWarsHelper.isEnabled = true
    AuctionHouseProTools_Log(moduleName, "INFO", "Module enabled: " .. moduleName)
    UndercutWarsHelper.StartModule()
end

function UndercutWarsHelper.DisableModule()
    AuctionHouseProTools_Log(moduleName, "DEBUG", "DisableModule called")
    UndercutWarsHelper.isEnabled = false
    AuctionHouseProTools_Log(moduleName, "INFO", "Module disabled: " .. moduleName)
    UndercutWarsHelper.StopModule()
end

-- Função para inicializar o módulo e restaurar estados
function UndercutWarsHelper.Initialize()
    AuctionHouseProTools_Log(moduleName, "DEBUG", "Initialize called")
    
    -- Restaurar o estado de habilitação a partir de SavedVariables
    UndercutWarsHelper.isEnabled = AuctionHouseProToolsSettings[moduleName .. "_enabled"] or false

    -- Restaurar o estado iniciado a partir de SavedVariables
    if AuctionHouseProToolsSettings[moduleName .. "_started"] then
        UndercutWarsHelper.StartModule()
    else
        UndercutWarsHelper.StopModule()
    end

    -- Restaurar o estado de debug a partir de SavedVariables
    UndercutWarsHelper.ToggleDebug(AuctionHouseProToolsSettings[moduleName .. "_debug"] or false)

    AuctionHouseProTools_Log(moduleName, "DEBUG", "Sending confirmation to Core: " .. moduleName .. " is loaded.")
end

-- Função para alternar o estado de debug
function UndercutWarsHelper.ToggleDebug(state)
    AuctionHouseProTools_Log(moduleName, "DEBUG", "ToggleDebug called with state: " .. tostring(state))
    UndercutWarsHelper.isDebug = state
    if state then
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode enabled for " .. moduleName)
    else
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode disabled for " .. moduleName)
    end
end