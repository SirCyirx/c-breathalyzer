Add this to ox_inventory/modules/items/client.lua
```lua
Item('breathalyzer', function(data, slot)
	ox_inventory:useItem(data, function(data)
	   TriggerServerEvent('c-breathalyzer:server:bac')
    end)
end)
```

Add this to ox_inventory/data/items.lua
```lua 
['breathalyzer'] = {
	label = 'Breathalyzer',
	weight = 1000,
	stack = false,
	description = 'Breathalyzer for police officers to use',
    client = {
        usetime = 700,
    }
},
```