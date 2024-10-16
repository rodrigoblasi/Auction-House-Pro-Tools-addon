-- Default header for all modules - don't exclude!
-- [ModuleName] Module Information
local moduleName = "[ModuleName]"  -- Placeholder for the module name
local moduleVersion = "0.1.0"      -- Placeholder for the module version

--[[ 
    1. Module state variables 
    These variables define the state of the module, including whether it's enabled, 
    started, in debug mode, and its version information.
    
    1. enabled: The core grants permission to this module to be enabled or not.
    2. started: Indicates whether the module is actively running its main function.
    3. debug: Controls the level of logging output (if true, debug logs are shown).
--]]
_G[moduleName] = {}
[moduleName].isEnabled = false  -- Permission from core to activate the module
[moduleName].isStarted = false  -- Indicates if the module is running
[moduleName].isDebug = false    -- Debug mode for logging
[moduleName].moduleVersion = moduleVersion  -- Module version

--[[ 
    2. Function to start the module 
    Initializes the module and sets up its main functionality.
--]]
function [moduleName].StartModule()
    if [moduleName].isStarted then
        return -- Do nothing if already started
    end

    [moduleName].isStarted = true
    AuctionHouseProTools_Log(moduleName, "INFO", "Starting module: " .. moduleName)

    -- Register events or setup actions specific to this module
end

--[[ 
    3. Function to stop the module 
    Cleans up resources and stops any active functionality.
--]]
function [moduleName].StopModule()
    if not [moduleName].isStarted then
        return -- Do nothing if already stopped
    end

    [moduleName].isStarted = false
    AuctionHouseProTools_Log(moduleName, "INFO", "Stopping module: " .. moduleName)

    -- Unregister events or stop actions specific to this module
end

--[[ 
    4. Function to toggle debug mode 
    Enables or disables debug mode for this module.
--]]
function [moduleName].ToggleDebug(state)
    [moduleName].isDebug = state
    if state then
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode enabled for " .. moduleName)
    else
        AuctionHouseProTools_Log(moduleName, "INFO", "DEBUG mode disabled for " .. moduleName)
    end
end

--[[ 
    5. Function to initialize the module 
    Called when the addon is loaded to restore any necessary state and initialize the module.
--]]
function [moduleName].Initialize()
    AuctionHouseProTools_Log(moduleName, "DEBUG", moduleName .. " received initialization signal from Core.")

    -- Restore the enabled state from SavedVariables
    [moduleName].isEnabled = AuctionHouseProToolsSettings[moduleName .. "_enabled"] or false

    -- Restore the started state from SavedVariables
    if AuctionHouseProToolsSettings[moduleName .. "_started"] then
        [moduleName].StartModule()
    else
        [moduleName].StopModule()
    end

    -- Restore the debug state from SavedVariables
    [moduleName].ToggleDebug(AuctionHouseProToolsSettings[moduleName .. "_debug"] or false)

    AuctionHouseProTools_Log(moduleName, "DEBUG", "Sending confirmation to Core: " .. moduleName .. " is loaded.")
end

--[[ 
    6. Placeholder for module-specific updates 
    Add specific functionality related to the module, such as event handlers or periodic updates.
--]]
local function UpdateModule()
    if not [moduleName].isStarted then
        return -- Do nothing if the module is not started
    end

    -- Module-specific update logic
end

--[[ 
    7. Function to enable the module 
    Called by the core to grant permission for the module to run.
--]]
function [moduleName].EnableModule()
    [moduleName].isEnabled = true
    AuctionHouseProTools_Log(moduleName, "INFO", "Module enabled: " .. moduleName)

    -- Automatically start the module if enabled
    [moduleName].StartModule()
end

--[[ 
    8. Function to disable the module 
    Called by the core to revoke permission for the module to run.
--]]
function [moduleName].DisableModule()
    [moduleName].isEnabled = false
    AuctionHouseProTools_Log(moduleName, "INFO", "Module disabled: " .. moduleName)

    -- Automatically stop the module when disabled
    [moduleName].StopModule()
end
