-- DEFAULT HEADER, dont DELETE!
-- FILE PATH: Modules/SalesSummaryExtended/init.lua
-- MODULE SHORT DESCRIPTION: 
-- Module METADATA
local componentName = "SalesSummaryExtended"
local componentExternalName = "Sales Summary Extended"
local componentVersion = "0.0.1"
local componentType = "module"
-- Função para registrar os metadados globalmente
if not _G[componentName .. "_Metadata"] then
    _G[componentName .. "_Metadata"] = {
        componentExternalName = componentExternalName,
        componentVersion = componentVersion,
        componentType = componentType
    }
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WARNING]: Metadados do componente '" .. componentExternalName .. "' já estavam registrados. Substituição não necessária.|r")
end
--
-- END OF DEFAULT HEADER, dont DELETE THE CODE ABOVE!
-- START HERE THIS COMPONENT SPECIFIC DEVELOPMENT, don't delete the code above.