# C-Breathalsyer
[Discord](https://discord.gg/YvThXdz59G)

# Feature
- Breathalsyer system
- Lots of config options
- Drag and drop
- Open Source

# Installation
1. Download From [github](https://github.com/SirCyirx/C-Breathalsyer)
2. Rename The Folder From c-breathalsyer-main to c-breathalsyer.
3. Put The Folder In Your Resources Folder.
4. Add the below events to when you use a achool item and when drinking water/getting sober
Do this to add bac level to someone
```lua
TriggerServerEvent('c-breathalsyer:server:addbaclevel', source, newamount)
```

Do this to remove bac level from someone
```lua
TriggerServerEvent('c-breathalsyer:server:revmovebaclevel', source, removeamount)
```
5. Add this to the following path [qb]/qb-core/server/player.lua
```lua
PlayerData.metadata['baclevel'] = PlayerData.metadata['baclevel'] or 0
```
6. Restart Your Server.

# Dependencies
1. [qb-core](https://github.com/qbcore-framework/qb-core)
2. [ox_lib](https://github.com/overextended/ox_lib/releases) 

Put this into your cfg in this in order
```
ensure ox_lib
ensure qb-core
ensure c-breathalsyer
```

# Commands
- /bac -- police can use this command and then they can start to test nearest player

# Usage
This example is for [qb-smallresources](https://github.com/qbcore-framework/qb-smallresources)
- qb-smallresources/server/consumables.lua. line 190
**Add**
```lua
RegisterNetEvent('consumables:client:DrinkAlcohol', function(itemName)
    QBCore.Functions.Progressbar('drink_alcohol', Lang:t('consumables.liqour_progress'), math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true
    }, {
        animDict = 'mp_player_intdrink',
        anim = 'loop_bottle',
        flags = 49
    }, {
        model = 'prop_cs_beer_bot_40oz',
        bone = 60309,
        coords = vec3(0.0, 0.0, -0.05),
        rotation = vec3(0.0, 0.0, -40),
    }, {}, function() -- Done
        TriggerServerEvent('c-breathalsyer:server:addbaclevel', source, 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'remove')
        TriggerServerEvent('consumables:server:drinkAlcohol', itemName)
        TriggerServerEvent('consumables:server:addThirst', QBCore.Functions.GetPlayerData().metadata.thirst + Config.Consumables.alcohol[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
        alcoholCount += 1
        AlcoholLoop()
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent('evidence:client:SetStatus', 'alcohol', 200)
        elseif alcoholCount >= 4 then
            TriggerEvent('evidence:client:SetStatus', 'heavyalcohol', 200)
        end
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t('consumables.canceled'), 'error')
    end)
end)
```