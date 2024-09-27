local isMenuVisible = false
local noteProps = {}

-- Command to show the note input UI
RegisterCommand('note', function()
    if not isMenuVisible then
        isMenuVisible = true
        SetNuiFocus(true, true) -- Set focus on NUI
        SendNUIMessage({
            action = 'showMenu' -- Show input menu
        })
    end
end, false)

-- Handle note submission from NUI
RegisterNUICallback('submitNote', function(data, cb)
    local note = data.note
    if note and string.len(note) > 0 then
        cb('ok')
        SetNuiFocus(false, false)
        isMenuVisible = false
        FreezeEntityPosition(PlayerPedId(), true)
        RequestAnimDict("missheistdockssetup1clipboard@base")
        while not HasAnimDictLoaded("missheistdockssetup1clipboard@base") do
            Citizen.Wait(100)
        end
    
        -- Play the notepad animation
        TaskPlayAnim(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
    
        -- Optionally, spawn a notepad prop in hand
        local prop = CreateObject(GetHashKey("prop_notepad_01"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.1, 0.02, 0.08, -80.0, 0.0, 0.0, true, true, false, true, 1, true)
        Wait(10000)
        FreezeEntityPosition(PlayerPedId(), false)
        DeleteEntity(prop)
        ClearPedTasks(PlayerPedId())
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Send note and coordinates to the server for saving
        TriggerServerEvent('WNotes_saveNoteWithCoords', note, playerCoords)
    else
        lib.notify({
            description = "Please put text in the text box you fucking dumbass"
        })
    end
end)

RegisterNetEvent("WNotes_spawnNote", function(note, playerCoords, name)
     -- Spawn the note prop at the player's location
     local prop = CreateObject(GetHashKey('prop_notepad_01'), playerCoords.x, playerCoords.y, playerCoords.z, false, true, true)
     FreezeEntityPosition(prop, true)
     -- Add the prop to the OX_Target system for interaction
     exports.ox_target:addLocalEntity(prop, {
         {
             name = 'read_note',
             label = 'Read Note',
             onSelect = function()
                 -- Show the read note UI when the player selects the note
                 SendNUIMessage({
                     action = 'showNote', -- Show read menu
                     note = note,
                     name = name
                 })
                 SetNuiFocus(true, true)
             end
         }
     })

     -- Store the prop so we can manage it later
     table.insert(noteProps, prop)
end)

-- Handle closing the menu with Esc
RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    isMenuVisible = false
    cb('ok')
end)

-- Handle closing the read note menu
RegisterNUICallback('closeNote', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent("ox:playerLoaded", function ()
    TriggerServerEvent("WNotes_playerjoined")
end)