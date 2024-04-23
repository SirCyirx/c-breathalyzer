local QBCore = exports['qb-core']:GetCoreObject()
local WearOffStart = false

if Config.Metadata == true then
QBCore.Commands.Add('bac', Config.Lang["command_text_1"], {}, true, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
  if Player.PlayerData.job.name == Config.PoliceJob then
  if Player.PlayerData.job.grade.level >= Config.BACTestRank then
    local NearestPlayer = lib.callback.await('c-breathalsyer:client:closeplayercheck', src)
  if not NearestPlayer == false then
    local CanTest = lib.callback.await('c-breathalsyer:client:requestpermission', NearestPlayer)
  if CanTest == "confirm" then
       TriggerEvent('c-breathalsyer:server:leveldata', src, NearestPlayer)
  elseif CanTest == "cancel" then
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["refuse"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_close_text"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["rank_not_high"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_police"], 'error')
    end
end)

RegisterServerEvent('c-breathalsyer:server:addbaclevel', function(source, newamount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CurrentBACAmount = Player.PlayerData.metadata['baclevel']
    local AddAmount = newamount
       Player.Functions.SetMetaData('baclevel', (CurrentBACAmount + AddAmount))
  if Config.UseWearOff == true then
       WearOffStart = true TriggerEvent('c-breathalsyer:server:startwearoff', src, AddAmount)
    end
end)

RegisterServerEvent('c-breathalsyer:server:revmovebaclevel', function(source, minusamount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CurrentBACAmount = Player.PlayerData.metadata['baclevel']
    local RemoveAmount = minusamount
       Player.Functions.SetMetaData('baclevel', (CurrentBACAmount - RemoveAmount))
       NotifyServerAlert(src, {Config.Lang["header_1"]}, Config.Lang["wearoffed"], 'inform')
end)

RegisterServerEvent('c-breathalsyer:server:startwearoff', function(source, gained)
if Config.WearOff.Same == true then
 CreateThread(function()
   while true do
       Wait(Config.WearOff.Time)
  if WearOffStart == true then
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CurrentBACAmount = Player.PlayerData.metadata['baclevel']
    local GainedAmount = gained
       Player.Functions.SetMetaData('baclevel', (CurrentBACAmount - GainedAmount))
       NotifyServerAlert(src, {Config.Lang["header_1"]}, Config.Lang["wearoffed"], 'inform')
       WearOffStart = false
       end
    end
end)
elseif Config.WearOff.Same == false then
 CreateThread(function()
   while true do
       Wait(Config.WearOff.Time)
  if WearOffStart == true then
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CurrentBACAmount = Player.PlayerData.metadata['baclevel']
    local RemoveAmount = Config.WearOff.Amount
  if CurrentBACAmount >= 1 then
       Player.Functions.SetMetaData('baclevel', (CurrentBACAmount - RemoveAmount))
       NotifyServerAlert(src, {Config.Lang["header_1"]}, Config.Lang["wearoffed"], 'inform')
  else WearOffStart = false end
   end end
       end)
    end
end)

RegisterServerEvent('c-breathalsyer:server:leveldata',function(source, NearestPlayer)
    local src = source
    local PlayerID = NearestPlayer
    local Player = QBCore.Functions.GetPlayer(PlayerID)
    local BACAmount = Player.PlayerData.metadata['baclevel']
    local legal = Config.LegalLimt
       TriggerClientEvent('c-breathalsyer:client:testplayer', src, BACAmount)
       Wait(2500)
  if BACAmount >= 10 then
       NotifyServerAlert(src, {Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0."..BACAmount.." The Legal BAC level is  "..legal, 'inform')
  elseif BACAmount >= 0 and BACAmount <= 9 then
       NotifyServerAlert(src, {Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0.0"..BACAmount.." The Legal BAC level is  "..legal, 'inform')
    end
end)

if Config.UseAdminCommands == true then
QBCore.Commands.Add('GiveBAC', "Admin command to give bac to people", {  { name = 'id', help = "Id of player you want to give bac to"}, { name = 'amount', help = "How much bac do you want to give?"} }, true, function(source, args)
    local src = source
    local ChosenPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local CurrentAmount = ChosenPlayer.PlayerData.metadata['baclevel']
    local NewAmount = args[2]
       ChosenPlayer.Functions.SetMetaData('baclevel', (CurrentAmount + NewAmount))
end, 'admin')

QBCore.Commands.Add('RemoveBAC', "Admin command to remove bac from people", {  { name = 'id', help = "Id of player you want to remove bac from"}, { name = 'amount', help = "How much bac do you want to remove?"} }, true, function(source, args)
    local src = source
    local ChosenPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local CurrentAmount = ChosenPlayer.PlayerData.metadata['baclevel']
    local RemoveAmount = args[2]
       ChosenPlayer.Functions.SetMetaData('baclevel', (CurrentAmount - RemoveAmount))
end, 'admin') end

elseif Config.Metadata == false then
QBCore.Commands.Add('bac', Config.Lang["command_text_3"], {}, true, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
  if Player.PlayerData.job.name == Config.PoliceJob then
  if Player.PlayerData.job.grade.level >= Config.BACTestRank then
    local NearestPlayer = lib.callback.await('c-breathalsyer:client:closeplayercheck', src)
  if not NearestPlayer == false then
    local InputResult = lib.callback.await('c-breathalsyer:client:openinput', NearestPlayer)
  if InputResult > "0" and InputResult < "100" then
        TriggerClientEvent('c-breathalsyer:client:testingplayer', src, InputResult)
  elseif "refused" then
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["refuse"], 'inform')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_close_text"], 'inform')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["rank_not_high"], 'error')
   end else
       NotifyServerAlert(src, {Config.Lang["header"]}, Config.Lang["not_police"], 'error')
    end
end) end