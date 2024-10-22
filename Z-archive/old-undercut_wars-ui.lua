-- Modules/UndercutWarsHelper/ui.lua

-- Interface do módulo Undercut Wars Helper

-- Frame principal
local frame = CreateFrame("Frame", "UndercutWarsHelperFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(1040, 440)

-- EditBox para Item IDs
local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
editBox:SetSize(430, 30)
editBox:SetPoint("TOP", 0, -25)
editBox:SetAutoFocus(false)
editBox:SetJustifyH("CENTER")
editBox:SetScript("OnEnterPressed", function()
    Log("UndercutWarsHelper", "INFO", "ENTER pressed @editbox. Not functional yet.")
end)

frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
frame:Hide()  -- Começa escondido

-- Botão SCAN
local scanButton = CreateFrame("Button", "ScanButton", frame, "UIPanelButtonTemplate")
scanButton:SetSize(100, 30)
scanButton:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", 0, 0)
scanButton:SetText("SCAN")
scanButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "SCAN button clicked. Not functional yet.")
  end)

-- Botão POST
local postButton = CreateFrame("Button", "PostButton", frame, "UIPanelButtonTemplate")
postButton:SetSize(100, 30)
postButton:SetPoint("LEFT", scanButton, "RIGHT", 10, 0)
postButton:SetText("POST")
postButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "Post button clicked. Not functional yet.")
  end)

-- Botão CANCEL
local cancelButton = CreateFrame("Button", "CancelButton", frame, "UIPanelButtonTemplate")
cancelButton:SetSize(100, 30)
cancelButton:SetPoint("LEFT", postButton, "RIGHT", 10, 0)
cancelButton:SetText("CANCEL")
cancelButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "Cancel button clicked. Not functional yet.")
  end)

-- Botão SKIP
local skipButton = CreateFrame("Button", "SkipButton", frame, "UIPanelButtonTemplate")
skipButton:SetSize(100, 30)
skipButton:SetPoint("LEFT", cancelButton, "RIGHT", 10, 0)
skipButton:SetText("SKIP")
skipButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "SKIP button clicked. Not functional yet.")
  end)

-- Botão DECISION MAKER
local decisionMakerButton = CreateFrame("Button", "DecisionMakerButton", frame, "UIPanelButtonTemplate")
decisionMakerButton:SetSize(430, 40)
decisionMakerButton:SetPoint("TOPLEFT", scanButton, "BOTTOMLEFT", 0, 0)
decisionMakerButton:SetText("DECISION MAKER")
decisionMakerButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "Decision Maker button clicked. Not functional yet.")
  end)

-- Tabela central
local tableFrame = CreateFrame("Frame", "UndercutWarsHelperTableFrame", frame, "BackdropTemplate")
tableFrame:SetSize(1025, 235)
tableFrame:SetPoint("TOP", decisionMakerButton, "BOTTOM", 0, 0)
tableFrame:SetBackdrop({
  bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
tableFrame:SetBackdropColor(0.8, 0.4, 0, 0.5)

-- Cabeçalhos da tabela
local headerFrame = CreateFrame("Frame", "UndercutWarsHelperHeaderFrame", tableFrame, "BackdropTemplate")
headerFrame:SetSize(1025, 30)
headerFrame:SetPoint("TOP", tableFrame, "TOP", 0, 0)
headerFrame:SetBackdrop({
  bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
headerFrame:SetBackdropColor(0.2, 0.2, 0.6, 0.7)

local columnNames = { "Item", "Buyout", "Qty", "Posted", "Sold", "Bag", "Suggestion" }
local columnWidths = { 400, 95, 95, 95, 95, 95, 95 }
local xOffset = 10
for _, name in ipairs(columnNames) do
  local header = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  header:SetJustifyH("CENTER")
  header:SetPoint("TOPLEFT", headerFrame, "TOPLEFT", xOffset, -10)
  header:SetText(name)
  xOffset = xOffset + columnWidths[_] + 10
end

-- Área de debug
local debugFrame = CreateFrame("Frame", "UndercutWarsHelperDebugFrame", frame, "BackdropTemplate")
debugFrame:SetSize(1025, 70)
debugFrame:SetPoint("TOP", tableFrame, "BOTTOM", 0, -3)
debugFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
debugFrame:SetBackdropColor(0.8, 0, 0, 0.5)

local debugTitle = debugFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
debugTitle:SetPoint("TOP", 0, -10)
debugTitle:SetText("DEBUG AREA")

-- Botão Refresh Owned Auctions
local refreshButton = CreateFrame("Button", "RefreshButton", debugFrame, "UIPanelButtonTemplate")
refreshButton:SetSize(75, 45)  -- Aumentada a altura para suportar a quebra de linha
refreshButton:SetPoint("LEFT", debugFrame, "LEFT", 5, -5)
refreshButton:SetText("Refresh\nOwned Auctions")
refreshButton:GetFontString():SetWidth(refreshButton:GetWidth() - 10)
refreshButton:GetFontString():SetWordWrap(true)
refreshButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "Refresh Owned Auctions button clicked. Not functional yet.")
  end)

-- Botão Dump Bag Items
local dumpBagButton = CreateFrame("Button", "DumpBagButton", debugFrame, "UIPanelButtonTemplate")
dumpBagButton:SetSize(75, 45)  -- Aumentada a altura para suportar a quebra de linha
dumpBagButton:SetPoint("LEFT", refreshButton, "RIGHT", 5, 0)
dumpBagButton:SetText("Dump\nBag Items")
dumpBagButton:GetFontString():SetWidth(dumpBagButton:GetWidth() - 10)
dumpBagButton:GetFontString():SetWordWrap(true)
dumpBagButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "Dump Bag Items button clicked. Not functional yet.")
  end)

-- Botão Dump Owned Auctions
local dumpOwnedButton = CreateFrame("Button", "DumpOwnedButton", debugFrame, "UIPanelButtonTemplate")
dumpOwnedButton:SetSize(75, 45)  -- Aumentada a altura para suportar a quebra de linha
dumpOwnedButton:SetPoint("LEFT", dumpBagButton, "RIGHT", 5, 0)
dumpOwnedButton:SetText("Dump\nOwned Auctions")
dumpOwnedButton:GetFontString():SetWidth(dumpOwnedButton:GetWidth() - 10)
dumpOwnedButton:GetFontString():SetWordWrap(true)
dumpOwnedButton:SetScript("OnClick", function()
    Log("UndercutWarsHelper", "INFO", "Dump owned Auctions button clicked. Not functional yet.")
  end)

-- Função para mostrar ou esconder o frame
SLASH_UNDERCUTWARS1 = "/undercutwars"
SlashCmdList["UNDERCUTWARS"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

-- Registrar o frame globalmente
_G["UndercutWarsHelperFrame"] = frame

-- global vars:
_G["UndercutWarsHelperScanButton"] = scanButton
_G["UndercutWarsHelperPostButton"] = postButton
_G["UndercutWarsHelperCancelButton"] = cancelButton
_G["UndercutWarsHelperSkipButton"] = skipButton
_G["UndercutWarsHelperDecisionmakerButton"] = decisionMakerButton
_G["UndercutWarsHelperRefreshOwnedAuctionsButton"] = refreshButton
_G["UndercutWarsHelperDumpBagItensButton"] = dumpBagButton
_G["UndercutWarsHelperTableFrame"] = tableFrame
_G["UndercutWarsHelperEditBox"] = editBox

-- O que foi removido do ui.lua:
-- 1. Função LoadAndApplyFramePosition() - Responsável por carregar e aplicar a posição do frame a partir das SavedVariables. Essa é uma lógica que deve estar no init.lua.
-- 2. Função LoadAndApplyEditBoxValue() - Responsável por carregar e aplicar o valor do EditBox a partir das SavedVariables. Isso também é lógica que deve estar no init.lua.
-- 3. frame:SetScript("OnShow", ...) - Função para carregar a posição e o valor do EditBox quando o frame é mostrado. Essa é lógica funcional e deve ser movida para o init.lua.
-- 4. frame:SetScript("OnHide", ...) - Função para salvar o valor do EditBox quando o frame é escondido. Essa lógica deve ser movida para o init.lua.
-- 5. Título do Frame (local title = frame:CreateFontString(...)) - O título é mais relacionado à apresentação geral do frame e pode ser gerenciado pelo init.lua para manter consistência.
