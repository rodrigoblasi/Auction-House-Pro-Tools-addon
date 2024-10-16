-- Default header for all modules - don't exclude!
-- Control Panel module Informations
local moduleName = "ControlPanel"
local moduleVersion = "0.1.0"

--[[ 
    1. Variáveis de estado do módulo 
--]]
_G["ControlPanel"] = {}
ControlPanel.isEnabled = false
ControlPanel.isStarted = false
ControlPanel.isDebug = false
local panelFrame -- Referência ao frame visual do painel de controle
local coreDebugCheckbox, controlPanelDebugCheckbox, startedSalesSummaryCheckbox, debugSalesSummaryCheckbox, startedUndercutWarsHelperCheckbox, debugUndercutWarsHelperCheckbox -- Variáveis para as checkboxes do painel

--[[ 
    2. Função para receber o sinal de habilitação (enabled) do Core 
--]]
function ControlPanel.SetEnabled(state)
    ControlPanel.isEnabled = state

    if state then
        AuctionHouseProTools_Log(moduleName, "INFO", moduleName .. " is enabled by Core.")
        ControlPanel.StartModule() -- O painel deve sempre estar iniciado quando habilitado
    else
        ControlPanel.StopModule() -- Caso desabilitado, o painel deve ser parado
    end
end

--[[ 
    3. Função para iniciar o painel (started) 
--]]
function ControlPanel.StartModule()
    if not ControlPanel.isEnabled then
        return -- O painel só pode ser iniciado se estiver habilitado
    end

    if ControlPanel.isStarted then
        return -- Se já estiver iniciado, não faz nada
    end

    ControlPanel.isStarted = true
    AuctionHouseProTools_Log(moduleName, "INFO", "Starting module: " .. moduleName)

    -- Criar a interface do painel de controle
    ControlPanel.CreatePanel()

    -- Log confirmando que o painel foi iniciado com sucesso
    AuctionHouseProTools_Log(moduleName, "INFO", "Module " .. moduleName .. " (Control Panel) started successfully.")
end

--[[ 
    4. Função para parar o painel 
--]]
function ControlPanel.StopModule()
    if not ControlPanel.isStarted then
        return -- O painel já está parado
    end

    ControlPanel.isStarted = false
    AuctionHouseProTools_Log(moduleName, "INFO", "Stopping module: " .. moduleName)

    -- Esconder a interface do painel de controle
    if panelFrame then
        panelFrame:Hide()
    end

    AuctionHouseProTools_Log(moduleName, "INFO", "Module " .. moduleName .. " (Control Panel) stopped.")
end

--[[ 
    5. Função para alternar o estado de debug do painel de controle 
--]]
function ControlPanel.ToggleDebug(state)
    ControlPanel.isDebug = state
    AuctionHouseProToolsSettings["ControlPanel_debug"] = state

    if state then
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode enabled for Control Panel.")
    else
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode disabled for Control Panel.")
    end
end

--[[ 
    6. Função de criação do painel de controle (CreatePanel) 
--]]
function ControlPanel.CreatePanel()
    if panelFrame then return end -- Não recriar se já foi criado

    -- Criar o frame principal do painel com borda e título
    panelFrame = CreateFrame("Frame", "AuctionHouseProTools_ControlPanel", UIParent, "BasicFrameTemplateWithInset")
    panelFrame:SetPoint("CENTER")
    panelFrame:SetMovable(true)
    panelFrame:EnableMouse(true)
    panelFrame:RegisterForDrag("LeftButton")
    panelFrame:SetScript("OnDragStart", panelFrame.StartMoving)
    panelFrame:SetScript("OnDragStop", panelFrame.StopMovingOrSizing)

    -- Adicionar título ao painel
    local title = panelFrame:CreateFontString(nil, "OVERLAY")
    title:SetFontObject("GameFontHighlightLarge")
    title:SetPoint("TOP", 0, 0)
    title:SetText("Auction House Pro Tools")

    local checkboxHeight = 30
    local checkboxSpacing = 40
    local currentY = -50

    -- Reorganizando a ordem dos checkboxes conforme solicitado
    -- Checkbox para "debug" do Core
    coreDebugCheckbox = CreateFrame("CheckButton", nil, panelFrame, "UICheckButtonTemplate")
    coreDebugCheckbox:SetSize(30, 30)
    coreDebugCheckbox:SetPoint("TOPLEFT", 20, currentY)
    coreDebugCheckbox.text:SetText("Core Debug")
    coreDebugCheckbox:SetScript("OnClick", function()
        AuctionHouseProToolsSettings["Core_debug"] = coreDebugCheckbox:GetChecked()
        ControlPanel.SaveState()  -- Salvar estado no SavedVariables
    end)

    -- Checkbox para "debug" do ControlPanel
    currentY = currentY - checkboxSpacing
    controlPanelDebugCheckbox = CreateFrame("CheckButton", nil, panelFrame, "UICheckButtonTemplate")
    controlPanelDebugCheckbox:SetSize(30, 30)
    controlPanelDebugCheckbox:SetPoint("TOPLEFT", 20, currentY)
    controlPanelDebugCheckbox.text:SetText("Control Panel Debug")
    controlPanelDebugCheckbox:SetScript("OnClick", function()
        ControlPanel.ToggleDebug(controlPanelDebugCheckbox:GetChecked())
        ControlPanel.SaveState()  -- Salvar estado no SavedVariables
    end)

    -- Checkbox para "started" do SalesSummaryExtended
    currentY = currentY - checkboxSpacing
    startedSalesSummaryCheckbox = CreateFrame("CheckButton", nil, panelFrame, "UICheckButtonTemplate")
    startedSalesSummaryCheckbox:SetSize(30, 30)
    startedSalesSummaryCheckbox:SetPoint("TOPLEFT", 20, currentY)
    startedSalesSummaryCheckbox.text:SetText("Sales Summary Extended Started")
    startedSalesSummaryCheckbox:SetScript("OnClick", function()
        if startedSalesSummaryCheckbox:GetChecked() then
            SalesSummaryExtended.StartModule()
        else
            SalesSummaryExtended.StopModule()
        end
        ControlPanel.SaveState()  -- Salvar estado no SavedVariables
    end)

    -- Checkbox para "debug" do SalesSummaryExtended
    currentY = currentY - checkboxSpacing
    debugSalesSummaryCheckbox = CreateFrame("CheckButton", nil, panelFrame, "UICheckButtonTemplate")
    debugSalesSummaryCheckbox:SetSize(30, 30)
    debugSalesSummaryCheckbox:SetPoint("TOPLEFT", 20, currentY)
    debugSalesSummaryCheckbox.text:SetText("Sales Summary Extended Debug")
    debugSalesSummaryCheckbox:SetScript("OnClick", function()
        SalesSummaryExtended.ToggleDebug(debugSalesSummaryCheckbox:GetChecked())
        ControlPanel.SaveState()  -- Salvar estado no SavedVariables
    end)

    -- Checkbox para "started" do Undercut Wars Helper
    currentY = currentY - checkboxSpacing
    startedUndercutWarsHelperCheckbox = CreateFrame("CheckButton", nil, panelFrame, "UICheckButtonTemplate")
    startedUndercutWarsHelperCheckbox:SetSize(30, 30)
    startedUndercutWarsHelperCheckbox:SetPoint("TOPLEFT", 20, currentY)
    startedUndercutWarsHelperCheckbox.text:SetText("Undercut Wars Helper Started")
    startedUndercutWarsHelperCheckbox:SetScript("OnClick", function()
        if startedUndercutWarsHelperCheckbox:GetChecked() then
            UndercutWarsHelper.StartModule()
        else
            UndercutWarsHelper.StopModule()
        end
        ControlPanel.SaveState()  -- Salvar estado no SavedVariables
    end)

    -- Checkbox para "debug" do Undercut Wars Helper
    currentY = currentY - checkboxSpacing
    debugUndercutWarsHelperCheckbox = CreateFrame("CheckButton", nil, panelFrame, "UICheckButtonTemplate")
    debugUndercutWarsHelperCheckbox:SetSize(30, 30)
    debugUndercutWarsHelperCheckbox:SetPoint("TOPLEFT", 20, currentY)
    debugUndercutWarsHelperCheckbox.text:SetText("Undercut Wars Helper Debug")
    debugUndercutWarsHelperCheckbox:SetScript("OnClick", function()
        UndercutWarsHelper.ToggleDebug(debugUndercutWarsHelperCheckbox:GetChecked())
        ControlPanel.SaveState()  -- Salvar estado no SavedVariables
    end)

    -- Ajustar tamanho do frame conforme o conteúdo
    local totalHeight = math.abs(currentY) + checkboxHeight + 50
    panelFrame:SetSize(300, totalHeight)

    panelFrame:Hide() -- Iniciar oculto
end

--[[ 
    7. Função para atualizar o estado das checkboxes baseado nos estados atuais dos módulos 
--]]
function ControlPanel.UpdateCheckboxes()
    if startedSalesSummaryCheckbox and SalesSummaryExtended then
        startedSalesSummaryCheckbox:SetChecked(SalesSummaryExtended.isStarted) -- Refletir o estado started atual
    end
    if debugSalesSummaryCheckbox and SalesSummaryExtended then
        debugSalesSummaryCheckbox:SetChecked(SalesSummaryExtended.isDebug) -- Refletir o estado debug atual
    end

    if startedUndercutWarsHelperCheckbox and UndercutWarsHelper then
        startedUndercutWarsHelperCheckbox:SetChecked(UndercutWarsHelper.isStarted) -- Refletir o estado started atual
    end
    if debugUndercutWarsHelperCheckbox and UndercutWarsHelper then
        debugUndercutWarsHelperCheckbox:SetChecked(UndercutWarsHelper.isDebug) -- Refletir o estado debug atual
    end

    if coreDebugCheckbox then
        coreDebugCheckbox:SetChecked(AuctionHouseProToolsSettings["Core_debug"]) -- Refletir o estado atual de debug do Core
    end

    if controlPanelDebugCheckbox then
        controlPanelDebugCheckbox:SetChecked(AuctionHouseProToolsSettings["ControlPanel_debug"]) -- Refletir o estado atual de debug do ControlPanel
    end
end

--[[ 
    8. Função para salvar o estado no SavedVariables
--]]
function ControlPanel.SaveState()
    AuctionHouseProToolsSettings["SalesSummaryExtended_started"] = SalesSummaryExtended.isStarted
    AuctionHouseProToolsSettings["SalesSummaryExtended_debug"] = SalesSummaryExtended.isDebug
    AuctionHouseProToolsSettings["UndercutWarsHelper_started"] = UndercutWarsHelper.isStarted
    AuctionHouseProToolsSettings["UndercutWarsHelper_debug"] = UndercutWarsHelper.isDebug
    AuctionHouseProToolsSettings["Core_debug"] = AuctionHouseProToolsSettings["Core_debug"]
    AuctionHouseProToolsSettings["ControlPanel_debug"] = ControlPanel.isDebug
end

--[[ 
    9. Comando para abrir o painel 
--]]
SLASH_AHPT1 = "/ahpt"
SlashCmdList["AHPT"] = function()
    if not panelFrame then
        ControlPanel.CreatePanel() -- Criar o painel se não foi criado ainda
    end
    
    -- Atualizar checkboxes antes de mostrar o painel
    ControlPanel.UpdateCheckboxes()

    if panelFrame:IsShown() then
        panelFrame:Hide()
    else
        panelFrame:Show()
    end
end