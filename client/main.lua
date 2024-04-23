local QBCore = exports['qb-core']:GetCoreObject()
local Start = false
local GetBACLevel = nil

function DisplayLegalLimit(text)
   SetTextProportional(0)
   SetTextFont(4)
   SetTextScale(0.5, 0.5)
   SetTextEntry("STRING")
   AddTextComponentString(Config.Lang["show_legal"]..text)
   DrawText(0.8850, 0.8350)
   DrawRect(0.92, 0.80, 0.10, 0.15, 0, 0, 1, 245)
end

lib.callback.register('c-breathalsyer:client:closeplayercheck', function()
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
       DisplayLegalLimit(Config.LegalLimt)
       end
    end
end)

if Config.Metadata == true then
function DisplayBACLevel(text)
if text > 0 and text < 9 then
   SetTextProportional(0)
   SetTextFont(4)
   SetTextScale(0.6, 0.6)
   SetTextEntry("STRING")
   AddTextComponentString(Config.Lang["show_bac_1"]..text)
   DrawText(0.8800,0.7500)
else
   SetTextProportional(0)
   SetTextFont(4)
   SetTextScale(0.6, 0.6)
   SetTextEntry("STRING")
   AddTextComponentString(Config.Lang["show_bac_2"]..text)
   DrawText(0.8800,0.7500)
   end
end

lib.callback.register('c-breathalsyer:client:requestpermission', function()
    local alert = lib.alertDialog({ header = Config.Lang["header"], content = Config.Lang["alertDialog_text"], centered = true, cancel = true })
  if alert == "confirm" then
      return "confirm"
  elseif "cancel"then
      return "cancel"
   end
end)

RegisterNetEvent('c-breathalsyer:client:testplayer', function(BACLevel)
  if Config.Progressbar == "ox" then
  if lib.progressCircle({ duration = 2500, label = Config.Lang["progress_text"], position = 'bottom', useWhileDead = false, canCancel = true, }) then
       GetBACLevel = BACLevel
       Start = true
       Wait(Config.ShowTime)
       Start = false
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
       Start = true
       Wait(Config.ShowTime)
       Start = false
end, function()
    NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
end)
    end
end)

elseif Config.Metadata == false then

function DisplayBACLevel(text)
   SetTextProportional(0)
   SetTextFont(4)
   SetTextScale(0.6, 0.6)
   SetTextEntry("STRING")
   AddTextComponentString(Config.Lang["show_bac_3"]..tostring(text))
   DrawText(0.8800,0.7500)
end

lib.callback.register('c-breathalsyer:client:openinput', function()
    local input = lib.inputDialog(Config.Lang["header"], {{type = 'input', label = Config.Lang["input_1"], description = Config.Lang["input_2"]}})
  if not input then
       NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
    return "refused"
 end
    return input[1]
end)

RegisterNetEvent('c-breathalsyer:client:testingplayer', function(inputresult)
    local Input = inputresult
  if Config.Progressbar == "ox" then
  if lib.progressCircle({ duration = 2500, label = Config.Lang["progress_text"], position = 'bottom', useWhileDead = false, canCancel = true, }) then
       GetBACLevel = Input
       Start = true
       Wait(Config.ShowTime)
       Start = false
   else
       NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
    end
  elseif Config.Progressbar == "qb" then
QBCore.Functions.Progressbar('testing_bac', Config.Lang["progress_text"], 2500, false, true, {
      disableMovement = false,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = false,
}, {}, {}, {}, function()
       GetBACLevel = Input
       Start = true
       Wait(Config.ShowTime)
       Start = false
end, function()
       NotifyClientAlert({Config.Lang["header"]}, Config.Lang["canceled"], 'error')
end)
    end
end) end