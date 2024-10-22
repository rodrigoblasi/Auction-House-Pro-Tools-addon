-- DEFAULT HEADER, dont DELETE!
-- FILE PATH: handlers/<FILE>.lua
-- SNIPPET SHORT DESCRIPTION: This handler serves as template for bootstrap code
-- HANDLER METADATA
local componentName = "GenericTemplateHandlerName"
local componentExternalName = "Generic Template Handler Name"
local componentVersion = "0.0.1"
local componentType = "handler"
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