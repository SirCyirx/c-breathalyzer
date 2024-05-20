local QBCore = exports['qb-core']:GetCoreObject()

Config = Config or {}

Config.NotifyType = "qb" -- [qb] or [Okok] or [ox] or [mythic]
Config.Progressbar = "qb" -- [qb] or [ox]
Config.Inventory = "qb" -- [qb] or [ox]

Config.UseCommand = true -- If set true then you can use the command to trigger the event to start
Config.CommandName = "bac" -- Set this to what you want the command to be called. Default "bac". In game it will look like /bac
Config.UseItem = true -- If set true and If Config.Inventory = "qb" then you can use item to trigger the event to start. If set false item will do nothing. Note if using ox_inventory you must follow ox.md instructions for item to work/not work
Config.ItemName = "breathalyzer" -- Set this to the name of your item. Default "breathalyzer".
Config.UseMetadata = true -- If set true when police use /bac players will get tested based on the metadata they have.
-- If set false when police use /bac players will be promoted with an input that they can put in the amount they want.
Config.PlaySound = true -- If set to true then a sound will play when testing a player -- DOES NEED (interact-sound) to work.
Config.BACTestRank = 2 -- Set this to the police rank and above that can use the breathalyzer command /bac.
Config.LegalLimt = "0.05" -- Set this to what you want your legal limt to be. Recommended/default 0.05.
Config.PoliceJob = "police" -- Set this to your police job name. Default "police".
Config.ShowTime = 10000 -- Set to the amount of milliseconds you want the players bac level and legal level to show for. Recommended/default set at 10000 = to 10 seconds.
Config.UseAdminCommands = true -- If set true admins can use /GiveBAC /RemoveBAC to give and remove bac level from people.
Config.AdminCommands = {
    GiveBAC = 'GiveBAC',
    RemoveBAC = 'RemoveBAC'
}
Config.RequirePermission = true -- If set true when police use /bac the nearest player will have to allow to be tested. -- If set false it will just start testing them.
Config.UseWearOff = true -- If set true after c-breathalyzer:server:add_bac_level has been triggered then for every Config.WearOff.Time there is each time it ticks,
-- Example every 30 minutes it removes 1 bac level = to 0.01 bac level you can change this with Config.WearOff.Amount default set at 300000 which is 30 minutes.
Config.WearOff = {
    Time = 300000, -- Set to the amount of mill seconds you want to wait before the new bac amount wears off. Recommended/default set at 300000 = to 30 minutes.
    Amount = 1, -- Set to the amount you want it to wear off by do 1-40. Recommended/default set at 1
    Same = false -- If set true it will remove the amount gained when c-breathalyzer:server:add_bac_level is done and Config.UseWearOff = true.  --If set false it will remove Amount = Config.WearOff.Amount
}
Config.Min = "0" -- Only used if Config.UseMetadata = false
Config.Max = "0.40" -- Only used if Config.UseMetadata = false

Config.UseWebHook = true -- If set true then a meesage will be sent to the below webhook when a player is deleted
Config.Webhook = ""

Config.Lang = {
    ["header"] = "Police BAC Tester.",
    ["header_1"] = "Blood Achool Level.",
    ["rank_not_high"] = "You are not a high enough rank to do this action.",
    ["not_police"] = "You must be a police officer in order to do this action.",
    ["not_close_text"] = "No one nearby to BAC test. Please try again!",
    ["canceled"] = "Canceled.",
    ["wearoffed"] = "You start to feel less drunk!",
    ["refuse"] = "Subject refuesed.",
    ["progress_text"] = "Testing Closest Player...",
    ["alertDialog_text"] = "Do you consent to blowing into the tube?",
    ["show_bac_1"] = "BAC Level: 0.0",
    ["show_bac_2"] = "BAC Level: 0.",
    ["show_bac_3"] = "BAC Level: ",
    ["show_legal"] = "Legal Limit: ",
    ["input_1"] = "Put the what Blood Achool Level you would like the the police officerto see?",
    ["input_2"] = "Example put 0.06",
    ["command_text_1"] = "Blood Alcohol Level Test.",
    ["command_text_2"] = "Id of player you want to test",
    ["command_text_3"] = "Blood Alcohol Level Test. This will test the closest player",
    ["too_fast"] = "Your doing this too fast. Please try again!"
}

function NotifyClientAlert(titletext, msgtext, type)
    if Config.NotifyType == "qb" then
        if type == 'inform' then
            local info = 'primary'
        QBCore.Functions.Notify(msgtext, info, 5000)
        end
    elseif Config.NotifyType == "ox" then
        lib.notify({ title = titletext, description = msgtext, type = type })
    elseif Config.NotifyType == "okok" then
        if type == 'inform' then
            local info = 'info'
        exports['okokNotify']:Alert(titletext, msgtext, 5000, info)
        end
    elseif Config.NotifyType == "mythic" then
        exports['mythic_notify']:DoHudText(type, msgtext, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
    elseif Config.NotifyType == "custom" then
   end
end

function NotifyServerAlert(src, titletext, msgtext, type)
    if Config.NotifyType == "qb" then
        if type == 'inform' then
           local info = 'primary'
        TriggerClientEvent('QBCore:Notify', src, msgtext, info)
        end
    elseif Config.NotifyType == "ox" then
        TriggerClientEvent('ox_lib:notify', src, { title = titletext, description = msgtext, type = type })
    elseif Config.NotifyType == "okok" then
        if type == 'inform' then
            local info = 'info'
        TriggerClientEvent('okokNotify:Alert', src, titletext, msgtext, 5000, info)
        end
    elseif Config.NotifyType == "mythic" then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = type, text = msgtext, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
    elseif Config.NotifyType == "custom" then
   end
end