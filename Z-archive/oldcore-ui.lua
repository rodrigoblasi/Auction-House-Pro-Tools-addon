-- core/ui.lua

-- Função para criar o painel de controle
local function CreateControlPanel()
    local controlPanel = CreateFrame("Frame", "AHPT_ControlPanel", UIParent, "BasicFrameTemplateWithInset")
    controlPanel:SetSize(500, 400)
    controlPanel:SetPoint("CENTER")
    controlPanel:SetMovable(true)
    controlPanel:EnableMouse(true)
    controlPanel:RegisterForDrag("LeftButton")
    controlPanel:SetScript("OnDragStart", controlPanel.StartMoving)
    controlPanel:SetScript("OnDragStop", controlPanel.StopMovingOrSizing)
    controlPanel:Hide()  -- Começa escondido

    -- Título do painel
    controlPanel.title = controlPanel:CreateFontString(nil, "OVERLAY")
    controlPanel.title:SetFontObject("GameFontHighlight")
    controlPanel.title:SetPoint("CENTER", controlPanel.TitleBg, "CENTER", 0, 0)
    controlPanel.title:SetText("Auction House Pro Tools - Control Panel")

    -- Botão de fechar
    local closeButton = CreateFrame("Button", nil, controlPanel, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", controlPanel, "TOPRIGHT")
    closeButton:SetScript("OnClick", function() controlPanel:Hide() end)

    -- Função auxiliar para criar checkboxes
    local function CreateCheckbox(parent, label, configKey, offsetX, offsetY)
        local checkbox = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
        checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", offsetX, offsetY)
        checkbox.Text:SetText(label)
        checkbox:SetChecked(GetConfigValue(configKey.moduleName, configKey.variableName))
        checkbox:SetScript("OnClick", function(self)
            local isChecked = self:GetChecked()
            if _G["UpdateModuleStatus"] then
                _G["UpdateModuleStatus"](configKey.moduleName, configKey.variableName, isChecked)
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000Erro: Função UpdateModuleStatus não disponível.|r")
            end
        end)
        return checkbox
    end

    -- Criar frames para cada módulo
    local offsetY = -30
    for _, module in ipairs({
        { name = "Core", variables = { { label = "Debug", variableName = "Debug" } } },
        { name = "UndercutWarsHelper", variables = { { label = "Enabled", variableName = "Enabled" }, { label = "Debug", variableName = "Debug" } } },
        { name = "SalesSummaryExtended", variables = { { label = "Enabled", variableName = "Enabled" }, { label = "Debug", variableName = "Debug" } } }
    }) do
        local moduleFrame = CreateFrame("Frame", nil, controlPanel, "BackdropTemplate")
        moduleFrame:SetSize(460, 80)
        moduleFrame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 10, insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        moduleFrame:SetPoint("TOPLEFT", controlPanel, "TOPLEFT", 10, offsetY)
        offsetY = offsetY - moduleFrame:GetHeight() - 10

        local moduleTitle = moduleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        moduleTitle:SetPoint("TOPLEFT", 10, -10)
        moduleTitle:SetText(module.name)

        local offsetX = 10
        for _, variable in ipairs(module.variables) do
            local configKey = { moduleName = module.name, variableName = variable.variableName }
            CreateCheckbox(moduleFrame, variable.label, configKey, offsetX, -30)
            offsetX = offsetX + 250
        end
    end

    SLASH_AHPT1 = "/ahpt"
    SlashCmdList["AHPT"] = function()
        if controlPanel:IsShown() then
            controlPanel:Hide()
        else
            controlPanel:Show()
        end
    end
end

-- Criar o painel de controle ao carregar o addon
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == "Auction-House-Pro-Tools" then
        CreateControlPanel()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
