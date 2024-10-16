-- Default header for all modules - don't exclude!
-- Sales Summary Extended module Informations
local moduleName = "SalesSummaryExtended"
local moduleVersion = "1.0.0"

--[[ 
    1. Variáveis de estado do módulo 
--]]
_G["SalesSummaryExtended"] = {}
SalesSummaryExtended.isStarted = false
SalesSummaryExtended.isDebug = false
SalesSummaryExtended.moduleVersion = moduleVersion
local movableWindow
local windowText
local incomingText -- Variável para o texto de entrada

-- Variáveis para armazenar a posição do frame usando SavedVariables
AuctionHouseProTools = AuctionHouseProTools or {}
AuctionHouseProTools.sales_summary_position = AuctionHouseProTools.sales_summary_position or {}

-- Inicializando o frame para registrar eventos
local frame = CreateFrame("Frame", "SalesSummaryExtendedFrame")

--[[ 
    2. Função para salvar a posição do frame 
--]]
local function SaveFramePosition(movableWindow)
    local point, _, relativePoint, xOfs, yOfs = movableWindow:GetPoint()
    AuctionHouseProToolsSettings.sales_summary_position = {
        point = point,
        relativePoint = relativePoint,
        xOfs = xOfs,
        yOfs = yOfs
    }
    if SalesSummaryExtended.isDebug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Frame position saved.")
    end
end

--[[ 
    3. Função para restaurar a posição do frame 
--]]
local function RestoreFramePosition(movableWindow)
    local pos = AuctionHouseProToolsSettings.sales_summary_position
    if pos and pos.point then
        movableWindow:ClearAllPoints()
        movableWindow:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs)
        if SalesSummaryExtended.isDebug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Frame position restored.")
        end
    else
        movableWindow:SetPoint("CENTER")  -- Posição padrão caso não haja dados salvos
    end
end

--[[ 
    4. Função para iniciar o módulo (started) 
--]]
function SalesSummaryExtended.StartModule()
    if SalesSummaryExtended.isStarted then
        return -- Se já estiver iniciado, não faz nada
    end

    SalesSummaryExtended.isStarted = true
    AuctionHouseProTools_Log(moduleName, "INFO", "Starting module: " .. moduleName)

    -- Registrar eventos necessários
    frame:RegisterEvent("AUCTION_HOUSE_SHOW")
    frame:RegisterEvent("AUCTION_HOUSE_CLOSED")
    frame:RegisterEvent("OWNED_AUCTIONS_UPDATED")

    AuctionHouseProTools_Log(moduleName, "INFO", "Module " .. moduleName .. " started successfully.")
end

--[[ 
    5. Função para parar o módulo (stop) 
--]]
function SalesSummaryExtended.StopModule()
    if not SalesSummaryExtended.isStarted then
        return -- O módulo já está parado
    end

    SalesSummaryExtended.isStarted = false
    AuctionHouseProTools_Log(moduleName, "INFO", "Stopping module: " .. moduleName)

    -- Cancelar eventos
    frame:UnregisterAllEvents()

    if movableWindow then
        movableWindow:Hide()
    end

    AuctionHouseProTools_Log(moduleName, "INFO", "Module " .. moduleName .. " stopped.")
end

--[[ 
    6. Função para habilitar/desabilitar o modo DEBUG 
--]]
function SalesSummaryExtended.ToggleDebug(state)
    SalesSummaryExtended.isDebug = state
    if state then
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode enabled for " .. moduleName)
    else
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode disabled for " .. moduleName)
    end
end

--[[ 
    7. Função para criar a janela móvel 
--]]
local function CreateMovableWindow()
    if movableWindow then
        if SalesSummaryExtended.isDebug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Movable window already created.")
        end
        return
    end

    movableWindow = CreateFrame("Frame", "AuctionIncomingWindow", UIParent, "BackdropTemplate")
    
    movableWindow:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false, tileSize = 16, edgeSize = 12,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })

    movableWindow:SetMovable(true)
    movableWindow:EnableMouse(true)
    movableWindow:RegisterForDrag("LeftButton")
    movableWindow:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    movableWindow:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        SaveFramePosition(self)
    end)

    local windowTitle = movableWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    windowTitle:SetPoint("TOP", 0, -5)
    windowTitle:SetText("Sales Summary Extended")
    windowTitle:SetJustifyH("CENTER")

    windowText = movableWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    windowText:SetPoint("TOP", windowTitle, "BOTTOM", 0, -15)
    windowText:SetJustifyH("CENTER")
    windowText:SetText("No data yet.")

    -- Criar a label para a Auction House
    incomingText = AuctionHouseFrameAuctionsTab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    incomingText:SetPoint("TOPLEFT", AuctionHouseFrameAuctionsTab, "BOTTOMLEFT", 10, 50) -- Ajustar a posição abaixo da lista de leilões
    incomingText:SetText("No data yet.") -- Texto inicial
    incomingText:Hide() -- Escondido inicialmente

    movableWindow:Hide()
    RestoreFramePosition(movableWindow)

    if SalesSummaryExtended.isDebug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Movable window created successfully.")
    end
end

--[[ 
    8. Função para ajustar o tamanho da janela com base no texto 
--]]
local function AdjustWindowSize(text)
    local width = math.max(250, windowText:GetStringWidth() + 15)
    local height = math.max(60, windowText:GetStringHeight() + 15)
    movableWindow:SetSize(width, height)
end

--[[ 
    9. Função para atualizar as informações de leilões
--]]
local function UpdateIncomingText()
    if not SalesSummaryExtended.isStarted then
        incomingText:Hide() -- Ocultar se o módulo não estiver iniciado
        return
    end

    if SalesSummaryExtended.isDebug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Updating auctions.")
    end

    if not movableWindow then
        CreateMovableWindow()
    end

    local numAuctions = C_AuctionHouse.GetNumOwnedAuctions()
    local totalIncoming = 0
    local totalPosted = 0
    local soldCount = 0
    local postedCount = 0

    for i = 1, numAuctions do
        local auctionInfo = C_AuctionHouse.GetOwnedAuctionInfo(i)
        if auctionInfo then
            if auctionInfo.status == 1 then -- Vendas
                totalIncoming = totalIncoming + auctionInfo.buyoutAmount * 0.95
                soldCount = soldCount + 1
            else
                totalPosted = totalPosted + auctionInfo.buyoutAmount
                postedCount = postedCount + 1
            end
        end
    end

    local resultText = soldCount .. " Sold Auctions: " .. GetCoinTextureString(totalIncoming)
    resultText = resultText .. "    |    " .. postedCount .. " Posted Auctions: " .. GetCoinTextureString(totalPosted)

    -- Atualizar a label se a aba de leilões estiver visível
    if incomingText and AuctionHouseFrameAuctionsTab:IsVisible() then
        incomingText:SetText(resultText)
        incomingText:Show()
    else
        incomingText:Hide()
    end

    -- Mostrar o frame mesmo sem vendas se houver posted auctions
    if totalPosted > 0 then
        windowText:SetText(resultText)
        movableWindow:Show()
        AdjustWindowSize(resultText)
    elseif totalIncoming > 0 then
        local currentGold = GetMoney()
        local goldAfterSales = currentGold + totalIncoming
        windowText:SetText(resultText .. "\nGold after sales: " .. GetCoinTextureString(goldAfterSales))
        movableWindow:Show()
        AdjustWindowSize(resultText .. "\nGold after sales: " .. GetCoinTextureString(goldAfterSales))
    else
        movableWindow:Hide() -- Se não houver leilões, ocultar o frame
    end
end

--[[ 
    10. Função de inicialização do módulo (Initialize) 
--]]
function SalesSummaryExtended.Initialize()
    -- Log de recebimento do sinal do Core
    AuctionHouseProTools_Log(moduleName, "DEBUG", moduleName .. " received initialization signal from Core.")

    -- Restaurar os estados salvos das SavedVariables
    if AuctionHouseProToolsSettings["SalesSummaryExtended_started"] then
        SalesSummaryExtended.StartModule()
    else
        SalesSummaryExtended.StopModule()
    end

    SalesSummaryExtended.ToggleDebug(AuctionHouseProToolsSettings["SalesSummaryExtended_debug"] or false)

    -- Restaurar a posição da frame
    if movableWindow then
        RestoreFramePosition(movableWindow)
    end

    -- Log de confirmação enviado ao Core
    AuctionHouseProTools_Log(moduleName, "DEBUG", "Sending confirmation to Core: " .. moduleName .. " is loaded.")
end

--[[ 
    11. Evento de carregamento para capturar os eventos da Auction House
--]]
frame:SetScript("OnEvent", function(self, event)
    if event == "AUCTION_HOUSE_SHOW" then
        if SalesSummaryExtended.isDebug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Auction House opened.")
        end
        UpdateIncomingText()
    elseif event == "OWNED_AUCTIONS_UPDATED" then
        if SalesSummaryExtended.isDebug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Owned auctions updated.")
        end
        UpdateIncomingText()
    end
end)