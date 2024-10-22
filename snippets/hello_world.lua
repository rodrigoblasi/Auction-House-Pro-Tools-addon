-- DEFAULT HEADER, dont DELETE!
-- FILE PATH: snippets/hello_world.lua
-- SNIPPET SHORT DESCRIPTION: 
-- SNIPPET METADATA
local componentName = "hello_world"
local componentExternalName = "Hello World"
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
        functions = {}
    }
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WARNING]: Metadados do componente '" .. componentExternalName .. "' já estavam registrados. Substituição não necessária.|r")
end
--
-- END OF DEFAULT HEADER, dont DELETE THE CODE ABOVE!
-- START HERE THIS COMPONENT SPECIFIC DEVELOPMENT, don't delete the code above.
-- Função Hello World com cores do arco-íris
local function hello_world(componentExternalName, componentVersion)
    local rainbowColors = {
        "|cFFFF0000", -- Vermelho
        "|cFFFF7F00", -- Laranja
        "|cFFFFFF00", -- Amarelo
        "|cFF00FF00", -- Verde
        "|cFF0000FF", -- Azul
        "|cFF4B0082", -- Índigo
        "|cFF8B00FF"  -- Violeta
    }

    local helloWorldText = "Hello World"
    local coloredMessage = ""

    for i = 1, #helloWorldText do
        local colorIndex = (i - 1) % #rainbowColors + 1
        coloredMessage = coloredMessage .. rainbowColors[colorIndex] .. helloWorldText:sub(i, i)
    end

    coloredMessage = coloredMessage .. "|r - from " .. componentExternalName .. " version: " .. componentVersion
    DEFAULT_CHAT_FRAME:AddMessage(coloredMessage)
end

-- Registrar a função no namespace do snippet
_G["addonComponents"][componentName].functions["hello_world"] = hello_world
