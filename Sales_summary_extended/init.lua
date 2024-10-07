-- Default header for all modules - don't exclude!
-- Sales Summary Extended module Informations
local moduleName = "Sales Summary Extended"
local moduleVersion = "0.1.0"

-- Função de carregamento do módulo
local function OnLoad()
    AuctionHouseProTools_Log(moduleName, "INFO", moduleName .. " loaded! Version: " .. moduleVersion)
end

-- End of default header
-- Start coding here

-- Declare the table for the module
sales_summary_extended = {}

-- Inicializando o frame global para registrar eventos
local frame = CreateFrame("Frame")

-- Variáveis para armazenar a posição do frame usando SavedVariables
AuctionHouseProTools = AuctionHouseProTools or {}
AuctionHouseProTools.sales_summary_position = AuctionHouseProTools.sales_summary_position or {}

-- Função para salvar a posição do frame
local function SaveFramePosition(frame)
    local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
    AuctionHouseProTools.sales_summary_position = {
        point = point, 
        relativePoint = relativePoint, 
        xOfs = xOfs, 
        yOfs = yOfs 
    }
    if AuctionHouseProTools.sales_summary_debug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Posição do frame salva.")
    end
end

-- Função para restaurar a posição do frame
local function RestoreFramePosition(frame)
    local pos = AuctionHouseProTools.sales_summary_position
    if pos.point then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.xOfs, pos.yOfs)
        if AuctionHouseProTools.sales_summary_debug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Posição do frame restaurada.")
        end
    else
        frame:SetPoint("CENTER")  -- Posição padrão
    end
end

-- Função de habilitar o módulo
function sales_summary_extended.EnableModule()
    AuctionHouseProTools_Log(moduleName, "INFO", "Habilitando Sales Summary Extended")
    frame:RegisterEvent("AUCTION_HOUSE_SHOW")
    frame:RegisterEvent("AUCTION_HOUSE_CLOSED")
    frame:RegisterEvent("OWNED_AUCTIONS_UPDATED")
end

-- Função de desabilitar o módulo
function sales_summary_extended.DisableModule()
    AuctionHouseProTools_Log(moduleName, "INFO", "Desabilitando Sales Summary Extended")
    frame:UnregisterAllEvents()
    if movableWindow then
        movableWindow:Hide()
    end
end

-- Função para criar a janela móvel
local function CreateMovableWindow()
    if AuctionHouseProTools.sales_summary_debug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Criando janela móvel")
    end

    if movableWindow then 
        if AuctionHouseProTools.sales_summary_debug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Janela móvel já criada")
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

    movableWindow:Hide()
    RestoreFramePosition(movableWindow)
    if AuctionHouseProTools.sales_summary_debug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Janela móvel criada com sucesso")
    end
end

-- Função para ajustar o tamanho da janela com base no texto
local function AdjustWindowSize(text)
    local width = math.max(250, windowText:GetStringWidth() + 15)  
    local height = math.max(60, windowText:GetStringHeight() + windowText:GetStringHeight() + 15)  
    movableWindow:SetSize(width, height)
end

-- Função para atualizar os leilões
local function UpdateIncomingText()
    if AuctionHouseProTools.sales_summary_debug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Atualizando leilões")
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
            if auctionInfo.status == 1 then  
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
    
    if incomingText and AuctionHouseFrameAuctionsTab:IsVisible() then
        incomingText:SetText(resultText)
    end

    if totalIncoming > 0 then
        local currentGold = GetMoney()
        local goldAfterSales = currentGold + totalIncoming
        windowText:SetText(resultText .. "\nGold after sales: " .. GetCoinTextureString(goldAfterSales))
        movableWindow:Show()
        AdjustWindowSize(resultText .. "\nGold after sales: " .. GetCoinTextureString(goldAfterSales))
    else
        movableWindow:Hide()
    end
end

-- Evento de carregamento
frame:SetScript("OnEvent", function(self, event)
    if event == "AUCTION_HOUSE_SHOW" then
        if AuctionHouseProTools.sales_summary_debug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Auction House aberta")
        end
        UpdateIncomingText()
    elseif event == "OWNED_AUCTIONS_UPDATED" then
        if AuctionHouseProTools.sales_summary_debug then
            AuctionHouseProTools_Log(moduleName, "DEBUG", "Leilões atualizados")
        end
        UpdateIncomingText()
    end
end)

-- Inicialização do módulo com base na configuração
if AuctionHouseProTools.sales_summary_enabled then
    sales_summary_extended.EnableModule()
end