-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************
-- ** Seek Excellence! Employ ME, not my Copycats. **
-- **************************************************

MyLittleBraven = {}

local function initModData()
    MyLittleBraven = ModData.get("MyLittleBraven")
    if MyLittleBraven then return end

    MyLittleBraven = ModData.create("MyLittleBraven")
    MyLittleBraven.FirstStart = true
end

Events.OnInitGlobalModData.Add(initModData)

local function addAndWearItem(inventory, character, itemType)
    local item = InventoryItemFactory.CreateItem("Base." .. itemType)
    if item then
        inventory:AddItem(item)
        character:setWornItem(item:getBodyLocation(), item)
        return item
    end

    return nil
end

local function spawnBraven()
    local playerObj = getPlayer()
    local playerSq = playerObj:getSquare()

    local braven_parameters = {
        isFemale = true,
        firstName = "Amandine",
        hairstyle = "OverEye",
        hairColor = { R = 0.720, G = 0.451, B = 0.230 },
        speechColor = { R = 0.88, G = 0.22, B = 0.94 },
        spawnSq = playerSq,
        ignoreBites = true,
        isTough = true,
        regenHealth = true,
        fasterHealing = true,
        noNeeds = true,
        isEssential = true,
        aimSpeedMultiplier = 0.5,
        dialogueStringPrefix = "IGUI_MyLittleBraven_",
    }

    MyLittleBraven.npc = BB_NPCFramework.CreateNPC(MyLittleBraven, braven_parameters)

    local modules = { true, true, true, SandboxVars.BB_MyLittleBraven.CloseDoors, true, true, true, true, true, true }
    local setupStatus = BB_NPCFramework.SubscribeNPCToModules(MyLittleBraven, modules)

    if setupStatus == "CUSTOMIZE" then
        local inventory = MyLittleBraven.npc:getInventory()
        local crowbar = InventoryItemFactory.CreateItem("Base.Crowbar")
        if crowbar then
            inventory:AddItem(crowbar)
            MyLittleBraven.npc:setPrimaryHandItem(crowbar)
            MyLittleBraven.npc:setSecondaryHandItem(crowbar)
            MyLittleBraven.weaponIsRanged = false
        end

        addAndWearItem(inventory, MyLittleBraven.npc, "Braven_Mask")
        addAndWearItem(inventory, MyLittleBraven.npc, "Braven_HoodieUP")
        addAndWearItem(inventory, MyLittleBraven.npc, "Braven_Gloves")
        addAndWearItem(inventory, MyLittleBraven.npc, "Braven_Trousers")
        addAndWearItem(inventory, MyLittleBraven.npc, "Braven_Shoes")

        local itemCount = inventory:getItems():size()
        for i = itemCount - 1, 0, -1 do
            local item = inventory:getItems():get(i)
            item:getModData().equippedByBravenNPC = true
        end
    end
end

local onGameStart = function()
    spawnBraven()
end

Events.OnGameStart.Add(onGameStart)

local function onCharacterDeath(character)
    if character ~= MyLittleBraven.npc then return end

    MyLittleUtils.DelayFunction(function()
        spawnBraven()
    end, 1800, true)
end

Events.OnCharacterDeath.Add(onCharacterDeath)
