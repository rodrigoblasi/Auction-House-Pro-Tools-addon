-- init.lua (arquivo principal do addon)

    local addonName = "Auction House Pro Tools"
local addonBranch = "development"
local latestDeploy = "03.10.2024 - 12:13:57"
    
    -- Função para determinar a cor da branch
    local function getBranchColor(branch)
        if branch == "development" then
            return "|cff00ff00"  -- Verde
        elseif branch == "beta" then
            return "|cffffff00"  -- Amarelo
        elseif branch == "release" then
            return "|cffff0000"  -- Vermelho
        else
            return "|cffffffff"  -- Branco, cor padrão
        end
    end
    
    -- Exibir a mensagem de carregamento
    local branchColor = getBranchColor(addonBranch)
    print(addonName)
    print(branchColor .. "Branch: " .. addonBranch .. "|r")
    print("Latest deploy: " .. latestDeploy)    
    print("------------")