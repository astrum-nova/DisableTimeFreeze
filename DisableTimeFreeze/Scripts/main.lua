--! USER SETTINGS
--* GENERAL SETTINGS
local DISABLE_TIME_FREEZE_GLOBALLY = true
local DEBUG = false
--* TIME FREEZE VALUES SETTINGS
--? SET THE TIME FREEZE TYPE TO 1 TO DISABLE IT ENTIRELY
--? ANYTHING BELOW 1 WILL MAKE THE GAME RUN SLOWER
--? ANYTHING ABOVE 1 WILL MAKE THE GAME FUN FASTER
--? SETTING IT TO nil WILL MAKE THE MOD IGNORE IT (EXAMPLE: local FREEZE_TYPE_TO_IGNORE = nil)
--* GAMEPLAY:
--? UHH OK SO, UPON FURTHER INSPECTION 🤓👆 IT LOOKS LIKE THESE ARE THE ONLY 4 UNIQUE VALUES USED IN GAMEPLAY FOR TIME FREEZE, THEYRE JUST REUSED EVERYWHERE
local PAWN_ATTACK = 1
local PARRY = 1
local TAKE_DAMAGE = 1
local BISHOP_RED_LINES = 1
--* OTHERS
local SCREEN_LOAD = 1
--! USER SETTINGS END

--? This is just a mapping of the documented raw time freezes for user friendliness, ignore it
local RAW_FREEZE_TO_TYPES = {
    [1.0] = nil,
    [0.10000000149012] = PAWN_ATTACK,
    [0.01999999955296] = PARRY,
    [0.01999999955297] = BISHOP_RED_LINES,
    [0.15000000596046] = TAKE_DAMAGE,
    [0.5] = SCREEN_LOAD,
}
local GameplayStatics = nil
RegisterHook("/Script/Engine.GameplayStatics:SetGlobalTimeDilation", function() end, function(Context, WorldContextObject, TimeDilation)
    if not pcall(function()
        local td = math.floor(TimeDilation:get() * (10 ^ 14) + 0.5) / (10 ^ 14)
        if DEBUG then print("[" .. td .. "] = TYPE,") end
        if RAW_FREEZE_TO_TYPES[td] == nil then return end
        if DEBUG then print("INTERCEPTED VALUE: " .. td) end
        if GameplayStatics == nil then GameplayStatics = StaticFindObject("/Script/Engine.Default__GameplayStatics") end
        if GameplayStatics:IsValid() then GameplayStatics:SetGlobalTimeDilation(WorldContextObject:get(), DISABLE_TIME_FREEZE_GLOBALLY and 1 or RAW_FREEZE_TO_TYPES[td]) end
    end) then print("ERROR TRYING TO DISABLE TIME FREEZE") end
end)