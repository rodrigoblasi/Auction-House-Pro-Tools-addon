-- Init.lua
local addonName, addonTable = ...

-- Define version and branch
local version = "0.1.0"  -- Você pode ajustar essa versão conforme necessário
local branch = "unknown"  -- Alterar automaticamente conforme a branch atual

-- Função para identificar o branch do branch.txt
local function GetBranch()
    local file = io.open("branch.txt", "r")
    if file then
        local branchName = file:read("*l") -- Lê a primeira linha do arquivo
        file:close()
        return branchName
    else
        return branch -- Retorna o valor padrão se o arquivo não for encontrado
    end
end

-- Exibir mensagem de carregamento
local function OnAddonLoaded()
    local branchName = GetBranch()
    print("|cff00ff00" .. addonName .. " loaded!|r")
    print("Version: " .. version .. " | Branch: " .. branchName)
end

-- Evento para verificar quando o addon for carregado
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        OnAddonLoaded()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)