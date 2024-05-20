local QBCore = exports['qb-core']:GetCoreObject()

local WearOffStart = false
local CoolDown = false

if Config.UseMetadata == true then

if Config.UseItem == true then
if Config.Inventory == "qb" then
QBCore.Functions.CreateUseableItem(Config.ItemName, function(source)
    local src = source
       TriggerEvent('c-breathalyzer:server:bac', src)
end) end
end

if Config.UseCommand == true then
QBCore.Commands.Add(Config.CommandName, Config.Lang["command_text_1"], {}, true, function(source)
    local src = source
       TriggerEvent('c-breathalyzer:server:bac', src)
end) end

RegisterServerEvent('c-breathalyzer:server:bac', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
  if CoolDown == false then
  if Player.PlayerData.job.name == Config.PoliceJob then
  if Player.PlayerData.job.grade.level >= Config.BACTestRank then
    local GetNearestPlayer = lib.callback.await('c-breathalyzer:client:closeplayercheck', src)
  if not GetNearestPlayer == false then
    local CanTest = lib.callback.await('c-breathalyzer:client:requestpermission', GetNearestPlayer)
    local NearestPlayer = QBCore.Functions.GetPlayer(GetNearestPlayer)
    local BACAmount = NearestPlayer.PlayerData.metadata['baclevel']
  if CanTest == "confirm" then
       CoolDown = true
       TriggerClientEvent('c-breathalyzer:client:testplayer', src, BACAmount)
       Wait(8000)
       CoolDown = false
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..src..". Has started testing player with with ID:"..GetNearestPlayer..".")
  else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["refuse"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_close_text"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["rank_not_high"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_police"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["too_fast"], 'error')
    end
end)

RegisterServerEvent('c-breathalyzer:server:add_bac_level', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CurrentBACAmount = Player.PlayerData.metadata['baclevel']
    local NewAmount = CurrentBACAmount + amount
       Player.Functions.SetMetaData('baclevel', (NewAmount))
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..src.." BACLevel has been updated by using an item. Old amount:"..CurrentBACAmount..". New amount:"..NewAmount)
  if Config.UseWearOff == true then
       WearOffStart = true TriggerEvent('c-breathalyzer:server:startwearoff', src, amount)
    end
end)

RegisterServerEvent('c-breathalyzer:server:remove_bac_level', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CurrentBACAmount = Player.PlayerData.metadata['baclevel']
    local RemoveAmount = CurrentBACAmount - amount
       Player.Functions.SetMetaData('baclevel', (RemoveAmount))
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..src.." BACLevel has been updated by using an item. Old amount:"..CurrentBACAmount..". New amount:"..RemoveAmount)
       NotifyServerAlert(src, {Config.Lang["header_1"]}, Config.Lang["wearoffed"], 'inform')
end)

RegisterServerEvent('c-breathalyzer:server:startwearoff', function(source, amount)
    local src = source
CreateThread(function()
   while true do
       Wait(Config.WearOff.Time)
    local Player = QBCore.Functions.GetPlayer(src)
    local CurrentBACAmount = Player.PlayerData.metadata['baclevel']
  if WearOffStart == true then
  if Config.WearOff.Same == true then
  if CurrentBACAmount >= 1 then
    local WearOffAmount = CurrentBACAmount - amount
       Player.Functions.SetMetaData('baclevel', (WearOffAmount))
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..src.." BACLevel has been updated by wearing off. Old amount:"..CurrentBACAmount..". New amount:"..WearOffAmount)
   else
       NotifyServerAlert(src, {Config.Lang["header_1"]}, Config.Lang["wearoffed"], 'inform')
       WearOffStart = false
    end
  elseif Config.WearOff.Same == false then
  if CurrentBACAmount >= 1 then
    local WearOffAmount = CurrentBACAmount - Config.WearOff.Amount
       Player.Functions.SetMetaData('baclevel', (WearOffAmount))
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..src.." BACLevel has been updated by wearing off. Old amount:"..CurrentBACAmount..". New amount:"..WearOffAmount)
   else
       NotifyServerAlert(src, {Config.Lang["header_1"]}, Config.Lang["wearoffed"], 'inform')
       WearOffStart = false
                 end
              end
           end
        end
    end)
end)

if Config.UseAdminCommands == true then
QBCore.Commands.Add(Config.AdminCommands.GiveBAC, "Admin command to give bac to people", {  { name = 'id', help = "Id of player you want to give bac to"}, { name = 'amount', help = "How much bac do you want to give?"} }, true, function(source, args)
    local src = source
    local ChosenPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local CurrentBACAmount = ChosenPlayer.PlayerData.metadata['baclevel']
    local NewAmount = CurrentBACAmount + args[2]
       ChosenPlayer.Functions.SetMetaData('baclevel', (NewAmount))
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..args[1].." BACLevel has been updated by server admin with ID:"..src..". Old amount:"..CurrentBACAmount..". New amount:"..NewAmount)
end, 'admin')

QBCore.Commands.Add(Config.AdminCommands.RemoveBAC, "Admin command to remove bac from people", {  { name = 'id', help = "Id of player you want to remove bac from"}, { name = 'amount', help = "How much bac do you want to remove?"} }, true, function(source, args)
    local src = source
    local ChosenPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local CurrentBACAmount = ChosenPlayer.PlayerData.metadata['baclevel']
    local RemoveAmount = CurrentBACAmount - args[2]
       ChosenPlayer.Functions.SetMetaData('baclevel', (RemoveAmount))
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..args[1].." BACLevel has been updated by server admin with ID:"..src..". Old amount:"..CurrentBACAmount..". New amount:"..RemoveAmount)
end, 'admin') end

elseif Config.UseMetadata == false then

if Config.UseItem == true then
if Config.Inventory == "qb" then
QBCore.Functions.CreateUseableItem("breathalyzer", function(source)
    local src = source
       TriggerEvent('c-breathalyzer:server:bac', src)
end) end
end

if Config.UseCommand == true then
QBCore.Commands.Add(Config.CommandName, Config.Lang["command_text_3"], {}, true, function(source)
    local src = source
       TriggerEvent('c-breathalyzer:server:bac', src)
end) end

RegisterServerEvent('c-breathalyzer:server:bac', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
  if CoolDown == false then
  if Player.PlayerData.job.name == Config.PoliceJob then
  if Player.PlayerData.job.grade.level >= Config.BACTestRank then
    local NearestPlayer = lib.callback.await('c-breathalyzer:client:closeplayercheck', src)
  if not NearestPlayer == false then
    local InputResult = lib.callback.await('c-breathalyzer:client:openinput', NearestPlayer)
  if InputResult >= Config.Max then
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["refuse"], 'inform')
  elseif InputResult >= Config.Min and InputResult <= Config.Max then
       CoolDown = true
       TriggerClientEvent('c-breathalyzer:client:testplayercustom', src, InputResult)
       DiscordWebHookAlert("Breathalyzer Webhook", "Player with ID:"..src..". Has started testing player with with ID:"..NearestPlayer..".")
       Wait(8000)
       CoolDown = false
  elseif "refused" then
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["refuse"], 'inform')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_close_text"], 'inform')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["rank_not_high"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_police"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["too_fast"], 'error')
    end
end) end

function DiscordWebHookAlert(title, description)
  if Config.UseWebHook == true then
    local Data = {{ ["color"] = 16753920, ["title"] = "**".. title .."**", ["description"] = description }}
       PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = Data}), {['Content-Type'] = 'application/json'})
   end
end