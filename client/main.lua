local QBCore = exports['qb-core']:GetCoreObject()
local Start = false
local StartCustom = false
local GetBACLevel = nil
local LegalLimit = Config.LegalLimt

lib.callback.register('c-breathalyzer:client:closeplayercheck', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
  if player ~= -1 and distance < 2.5 then
    local playerId = GetPlayerServerId(player)
       return playerId
   else
       return false
    end
end)

CreateThread(function()
  while true do
       Wait(1)
  if Start == true then
       DisplayBACLevel(GetBACLevel)
       DisplayLegalLimit(LegalLimit)
       end
    end
end)
CreateThread(function()
  while true do
       Wait(1)
  if StartCustom == true then
       DisplayBACLevelCustom(GetBACLevel)
       DisplayLegalLimit(LegalLimit)
       end
    end
end)

function DisplayLegalLimit(text)
   SetTextProportional(0)
   SetTextFont(4)
   SetTextScale(0.5, 0.5)
   SetTextEntry("STRING")
   AddTextComponentString(Config.Lang["show_legal"]..text)
   DrawText(0.8850, 0.8350)
   DrawRect(0.92, 0.80, 0.10, 0.15, 0, 0, 1, 245)
end

function DisplayBACLevelCustom(text)
  if text > Config.Min and text < Config.Max then
    SetTextProportional(0)
    SetTextFont(4)
    SetTextScale(0.6, 0.6)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["show_bac_3"]..tostring(text))
    DrawText(0.8800,0.7500)
   end
end

function DisplayBACLevel(text)
  if text > 0 and text < 9 then
    SetTextProportional(0)
    SetTextFont(4)
    SetTextScale(0.6, 0.6)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["show_bac_1"]..text)
    DrawText(0.8800,0.7500)
  elseif text > 10 then
    SetTextProportional(0)
    SetTextFont(4)
    SetTextScale(0.6, 0.6)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["show_bac_2"]..text)
    DrawText(0.8800,0.7500)
  else
    SetTextProportional(0)
    SetTextFont(4)
    SetTextScale(0.6, 0.6)
    SetTextEntry("STRING")
    AddTextComponentString(Config.Lang["show_bac_1"]..text)
    DrawText(0.8800,0.7500)
   end
end

lib.callback.register('c-breathalyzer:client:requestpermission', function()
    local Alert = lib.alertDialog({ header = Config.Lang["header"], content = Config.Lang["alertDialog_text"], centered = true, cancel = true })
  if Alert == "confirm" then
      return "confirm"
  elseif "cancel"then
      return "cancel"
   end
end)

lib.callback.register('c-breathalyzer:client:openinput', function()
    local Input = lib.inputDialog(Config.Lang["header"], {{type = 'input', label = Config.Lang["input_1"], description = Config.Lang["input_2"]}})
  if not Input then
       NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
    return "refused"
 end
    return Input[1]
end)

RegisterNetEvent('c-breathalyzer:client:testplayer', function(baclevel)
    local BACLevel = baclevel
    local Player = PlayerPedId()
    local PedCoords = GetEntityCoords(Player)
  if Config.PlaySound == true then
       TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'breath', 1.0)
    end
       RequestAnimDict('anim@cellphone@in_car@ps')
       Phone = CreateObject(GetHashKey('prop_police_phone'), PedCoords.x, PedCoords.y, PedCoords.z, true, true, true)
       AttachEntityToEntity(Phone, Player, GetPedBoneIndex(Player, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, false, true)
       TaskPlayAnim(PlayerPedId(), 'anim@cellphone@in_car@ps', 'cellphone_text_read_base' , 8.0, 8.0, -1, 0, 0, false, false, false)
  if Config.Progressbar == "ox" then
  if lib.progressCircle({ duration = 2500, label = Config.Lang["progress_text"], position = 'bottom', useWhileDead = false, canCancel = true, }) then
       GetBACLevel = BACLevel
       Start = true
  if BACLevel >= 10 then
       NotifyClientAlert({Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0."..BACLevel.." The Legal BAC level is  "..LegalLimit, 'inform')
  elseif BACLevel >= 0 and BACLevel <= 9 then
       NotifyClientAlert({Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0.0"..BACLevel.." The Legal BAC level is  "..LegalLimit, 'inform')
    end
       Wait(Config.ShowTime)
       Start = false
  else
       NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
    end
  elseif Config.Progressbar == "qb" then
  if Config.PlaySound == true then
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'breath', 1.0)
   end
QBCore.Functions.Progressbar('testing_bac', Config.Lang["progress_text"], 2500, false, true, {
      disableMovement = true,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
}, {}, {}, {}, function()
       GetBACLevel = BACLevel
       Start = true
  if BACLevel >= 10 then
       NotifyClientAlert({Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0."..BACLevel.." The Legal BAC level is  "..LegalLimit, 'inform')
  elseif BACLevel >= 0 and BACLevel <= 9 then
       NotifyClientAlert({Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0.0"..BACLevel.." The Legal BAC level is  "..LegalLimit, 'inform')
    end
       Wait(Config.ShowTime)
       Start = false
end, function()
       NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
       end)
    end
       ClearPedTasks(PlayerPedId())
       DeleteEntity(Phone)
end)

RegisterNetEvent('c-breathalyzer:client:testplayercustom', function(baclevel)
   local BACLevel = baclevel
   local Player = PlayerPedId()
   local PedCoords = GetEntityCoords(Player)
      RequestAnimDict('anim@cellphone@in_car@ps')
 if Config.PlaySound == true then
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'breath', 1.0)
   end
      Phone = CreateObject(GetHashKey('prop_police_phone'), PedCoords.x, PedCoords.y, PedCoords.z, true, true, true)
      AttachEntityToEntity(Phone, Player, GetPedBoneIndex(Player, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, false, true)
      TaskPlayAnim(PlayerPedId(), 'anim@cellphone@in_car@ps', 'cellphone_text_read_base' , 8.0, 8.0, -1, 0, 0, false, false, false)
 if Config.Progressbar == "ox" then
 if lib.progressCircle({ duration = 2500, label = Config.Lang["progress_text"], position = 'bottom', useWhileDead = false, canCancel = true, }) then
      GetBACLevel = BACLevel
      StartCustom = true
 if BACLevel > "0" and BACLevel < "0.99" then
      NotifyClientAlert({Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of "..BACLevel.." The Legal BAC level is  "..LegalLimit, 'inform')
   end
      ClearPedTasks(PlayerPedId())
      DeleteEntity(Phone)
      Wait(Config.ShowTime)
      StartCustom = false
 else
      NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
   end
 elseif Config.Progressbar == "qb" then
QBCore.Functions.Progressbar('testing_bac', Config.Lang["progress_text"], 2500, false, true, {
     disableMovement = true,
     disableCarMovement = true,
     disableMouse = false,
     disableCombat = true,
}, {}, {}, {}, function()
      GetBACLevel = BACLevel
      StartCustom = true
 if BACLevel >= 10 then
      NotifyClientAlert({Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0."..BACLevel.." The Legal BAC level is  "..LegalLimit, 'inform')
 elseif BACLevel >= 0 and BACLevel <= 9 then
      NotifyClientAlert({Config.Lang["header"]}, "You have BAC tested the nearest player and they have a BAC level of 0.0"..BACLevel.." The Legal BAC level is  "..LegalLimit, 'inform')
   end
      ClearPedTasks(PlayerPedId())
      DeleteEntity(Phone)
      Wait(Config.ShowTime)
      StartCustom = false
end, function()
      NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
      end)
   end
      ClearPedTasks(PlayerPedId())
      DeleteEntity(Phone)
end)