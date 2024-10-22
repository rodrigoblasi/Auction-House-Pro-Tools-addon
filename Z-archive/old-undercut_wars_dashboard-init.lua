-- Modules/<FOLDER>/<FILE>.lua

-- Start of MODULE default identification variables
local moduleExternalName = "Generic Template Module Name"
local moduleVersion = "0.0.1"
-- Global identification variables of this module

-- Snippet de inicialização
if _G["InitializeComponent"] then
    InitializeComponent(moduleExternalName, moduleName, moduleVersion, "Module")
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[Erro] Snippet de inicialização não encontrado para o módulo: " .. moduleName .. "|r")
end
-- END of MODULE default identification variables initialization
-- START HERE THIS MODULE SPECIFIC DEVELOPMENT, don't delete the code above.
