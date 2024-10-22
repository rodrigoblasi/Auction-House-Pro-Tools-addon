-- DEFAULT HEADER, dont DELETE!
-- FILE PATH: snippets/log.lua
-- SNIPPET SHORT DESCRIPTION: Centralized logging system for AuctionHouseProTools
-- SNIPPET METADATA
local componentName = "Log"
local componentExternalName = "Log"
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

-- Função de log centralizada
local function Message(componentExternalName, level, message)
    -- Verifique se todos os parâmetros necessários estão presentes
    if not componentExternalName or not level or not message then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[ERROR]: Parâmetros ausentes na função de log: componentExternalName, level ou message.|r")
        return
    end

    -- Inicialmente defina a cor como nil
    local color = nil

    -- Definir a cor com base no nível
    if level == "ERROR" then
        color = "|cFFFF0000" -- Vermelho
    elseif level == "INFO" then
        color = "|cFFFFFFFF" -- Branco
    elseif level == "DEBUG" then
        -- FUTURO: Verificar se o DEBUG está ativado para o componente solicitante
        -- Placeholder: Checagem de debug ainda não implementada.
        color = "|cFF00FFFF" -- Azul Ciano (DEBUG)
    end

    -- Se a cor ainda não foi atribuída, defina uma cor padrão
    if not color or color == "" then
        color = "|cFFCCCCCC" -- Cinza Claro (cor padrão se não houver uma cor definida)
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[WARNING]: Nível de log desconhecido '" .. tostring(level) .. "'. Usando cor padrão.|r")
    end

    -- Formatar a mensagem de log (concatenação direta de color e componentExternalName para garantir formato correto)
    local formattedMessage = string.format("%s - %s%s [%s]: %s|r", _G["addonExternalName"], color, componentExternalName, level, message, color, componentExternalName, level, message)
    
    -- Exibir a mensagem no chat
    DEFAULT_CHAT_FRAME:AddMessage(formattedMessage)
end

-- Tornar a função de log disponível no namespace do componente
_G["addonComponents"][componentName].functions["message"] = Message

--_G["addonExternalName"] = "Auction House Pro Tools"