-- DEFAULT HEADER, dont DELETE!
-- FILE PATH: Modules/core/core_init.lua
-- MODULE SHORT DESCRIPTION: Adjusted component check logic for different component types
-- MODULE METADATA
local componentName = "core"
local componentExternalName = "Core"
local componentVersion = "0.0.1"
local componentType = "module"
-- Addon METADATA
--local addonVersion = "0.dsadssa"
--local addonBranch = "devessdadpment"
--local latestDeploy = "sss"
--
-- addon metadata global vars
_G["addonName"] = "AuctionHouseProTools"
_G["addonExternalName"] = "Auction House Pro Tools"
_G["addonVersion"] = "0.0.1"
_G["addonBranch"] = "development"
_G["latestDeploy"] = "22.10.2024 - 13:45:44"
-- dont delete this addon identification too!!
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

-- Função para listar todos os componentes registrados
-- essa função deve virar um novo snippet em breve
local function ListAllComponents()
    -- Listar módulos
    _G["addonComponents"]["Log"].functions.message(componentExternalName, "INFO", "-- MODULOS --")
    for key, value in pairs(_G["addonComponents"]) do
        if value.Metadata and value.Metadata.componentType == "module" then
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "INFO", "Módulo: " .. value.Metadata.componentExternalName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentName: " .. value.Metadata.componentName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentExternalName: " .. value.Metadata.componentExternalName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentVersion: " .. value.Metadata.componentVersion)
            if value.functions and next(value.functions) then
                _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "Funções disponíveis:")
                for functionName, _ in pairs(value.functions) do
                    _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "  - " .. functionName)
                end
            end
        end
    end

    -- Listar snippets
    _G["addonComponents"]["Log"].functions.message(componentExternalName, "INFO", "-- SNIPPETS --")
    for key, value in pairs(_G["addonComponents"]) do
        if value.Metadata and value.Metadata.componentType == "snippet" then
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "INFO", "Snippet: " .. value.Metadata.componentExternalName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentName: " .. value.Metadata.componentName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentExternalName: " .. value.Metadata.componentExternalName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentVersion: " .. value.Metadata.componentVersion)
            if value.functions and next(value.functions) then
                _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "Funções disponíveis:")
                for functionName, _ in pairs(value.functions) do
                    _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "  - " .. functionName)
                end
            end
        end
    end

    -- Listar handlers
    _G["addonComponents"]["Log"].functions.message(componentExternalName, "INFO", "-- HANDLERS --")
    for key, value in pairs(_G["addonComponents"]) do
        if value.Metadata and value.Metadata.componentType == "handler" then
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "INFO", "Handler: " .. value.Metadata.componentExternalName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentName: " .. value.Metadata.componentName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentExternalName: " .. value.Metadata.componentExternalName)
            _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "componentVersion: " .. value.Metadata.componentVersion)
            if value.functions and next(value.functions) then
                _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "Funções disponíveis:")
                for functionName, _ in pairs(value.functions) do
                    _G["addonComponents"]["Log"].functions.message(componentExternalName, "DEBUG", "  - " .. functionName)
                end
            end
        end
    end
end

-- Evento ADDON_LOADED para iniciar a checagem dos componentes
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, loadedAddonName)
    if (loadedAddonName == addonName or loadedAddonName == "AuctionHouseProTools") then
        -- a verificação da função global de log deve ocorrer aqui, de forma "silenciosa" e caso ela não esteja disponivel devemos ter uma mensagem de erro usando a console do jogo, em vermelho e a execução do addon deve parar.
        if not _G["addonComponents"]["Log"] or not _G["addonComponents"]["Log"].functions or not _G["addonComponents"]["Log"].functions.message then
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[CRITICAL ERROR]: Função de log 'Log.message' não encontrada. Parando a execução do addon.|r")
            return -- Parar a execução do addon
        end
        
        -- Listar todos os componentes disponíveis do addon
        ListAllComponents()
        _G["addonComponents"]["hello_world"].functions.hello_world(componentExternalName, componentVersion)
    end
end)
