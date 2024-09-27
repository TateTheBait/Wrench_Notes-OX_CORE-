local json = require('json')

-- Event to save the note and coordinates server-side
RegisterNetEvent('WNotes_saveNoteWithCoords')
AddEventHandler('WNotes_saveNoteWithCoords', function(note, coords)
    local filePath = 'resources/[WRENCH2]/WNotes/notes.json'
    local notesArray = {}

    -- Read the existing JSON file
    local file = io.open(filePath, 'r')
    if file then
        local fileContent = file:read('*a')
        if fileContent ~= '' then
            notesArray = json.decode(fileContent) or {}
        end
        file:close()
    end

    -- Append the new note with coordinates and timestamp
    table.insert(notesArray, {
        note = note,
        coords = { x = coords.x, y = coords.y, z = coords.z-1.12 },
        timestamp = os.date('%Y-%m-%d %H:%M:%S'),
        name = GetPlayerName(source)
    })
    local name = GetPlayerName(source)

    -- Write the updated notes back to the file
    local jsonContent = json.encode(notesArray, { indent = true })
    local file = io.open(filePath, 'w')
    if file then
        file:write(jsonContent)
        file:close()
        print('Note saved successfully')
    else
        print('Error: Unable to save the note.')
    end
    TriggerClientEvent("WNotes_spawnNote", -1, note, vector3(coords.x, coords.y, coords.z-1.12), name)
end)


RegisterNetEvent("WNotes_playerjoined", function ()
    local file = io.open('resources/[WRENCH2]/WNotes/notes.json', 'r')
if file then
    local notesArray
    local fileContent = file:read('*a')
    if fileContent ~= '' then
        notesArray = json.decode(fileContent) or {}
        for _, note in pairs(notesArray) do
            print(note.note, note.coords, note.name)
            TriggerClientEvent("WNotes_spawnNote", source, note.note, note.coords, note.name)
        end
    end
    file:close()
end

end)
