-- Default header for all modules - dont exclude!
-- Undercut Wars Helper module Informations
local moduleName = "Undercut Wars Helper"
local moduleVersion = "0.1.0"

-- Função de carregamento do módulo
local function OnLoad()
    AuctionHouseProTools_Log(moduleName, "INFO", moduleName .. " loaded! Version: " .. moduleVersion)
end

-- End of default header
-- Start coding here

-- Declare the table for the module
undercut_wars_helper = {}

-- Função de habilitar o módulo
function undercut_wars_helper.EnableModule()
    AuctionHouseProTools_Log(moduleName, "INFO", "Enabling " .. moduleName)
    if AuctionHouseProTools.undercut_wars_helper_debug then
        AuctionHouseProTools_Log(moduleName, "DEBUG", "Undercut Wars Helper Debugging Enabled")
    end
end

-- Função de desabilitar o módulo
function undercut_wars_helper.DisableModule()
    AuctionHouseProTools_Log(moduleName, "INFO", "Disabling " .. moduleName)
end

-- Inicialização do módulo com base na configuração
if AuctionHouseProTools.undercut_wars_helper_enabled then
    undercut_wars_helper.EnableModule()
end