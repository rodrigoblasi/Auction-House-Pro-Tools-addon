-- DEFAULT HEADER, dont DELETE!
-- FILE PATH: snippets/<FILE>.lua
-- SNIPPET SHORT DESCRIPTION: This snippet serves as template for bootstrap code
-- SNIPPET METADATA
local componentName = "GenericTemplateSnippetName"
local componentExternalName = "Generic Template Snippet Name"
local componentVersion = "0.0.1"
local componentType = "snippet"
-- Registro dos metadados deste componente globalmente em addonComponents
_G["addonComponents"] = _G["addonComponents"] or {}

if not _G["addonComponents"][componentName] then
    _G["addonComponents"][componentName] = {
        Metadata = {
            componentName = componentName,
            componentExternalName = componentExternalName,
            componentVersion = componentVersion,
            componentType = componentType
        },
        function = {}
    }
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WARNING]: Metadados do componente '" .. componentExternalName .. "' já estavam registrados. Substituição não necessária.|r")
end
--
-- END OF DEFAULT HEADER, dont DELETE THE CODE ABOVE!
-- START HERE THIS COMPONENT SPECIFIC DEVELOPMENT, don't delete the code above.