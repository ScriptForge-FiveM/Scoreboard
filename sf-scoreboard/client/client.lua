local scoreboardVisible = false
local openKey = Config.open
local closeKey = 322
local hasPermission = false
local canManageBusiness = false

RegisterNetEvent('esx_scoreboard:updatePlayers')
AddEventHandler('esx_scoreboard:updatePlayers', function(data)
    SendNUIMessage({
        type = 'updateScoreboard',
        totalPlayers = data.totalPlayers,
        players = data.players,
        jobCounts = data.jobCounts
    })
end)

RegisterNetEvent('esx_scoreboard:sendBusinessStatus')
AddEventHandler('esx_scoreboard:sendBusinessStatus', function(businesses)
    SendNUIMessage({
        type = 'updateBusinessStatus',
        businesses = businesses
    })
end)

RegisterNetEvent('esx_scoreboard:addBusiness')
AddEventHandler('esx_scoreboard:addBusiness', function(business)
    SendNUIMessage({
        type = 'addBusiness',
        business = business
    })
end)

RegisterNetEvent('esx_scoreboard:sendBusinessPermissions')
AddEventHandler('esx_scoreboard:sendBusinessPermissions', function(permission)
    canManageBusiness = permission
    SendNUIMessage({
        type = 'updateBusinessPermissions',
        canManageBusiness = permission
    })
end)

RegisterNetEvent('esx_scoreboard:sendPermissions')
AddEventHandler('esx_scoreboard:sendPermissions', function(permission)
    hasPermission = permission
    SendNUIMessage({
        type = 'updatePermissions',
        hasPermission = permission
    })
end)

RegisterNetEvent('esx_scoreboard:updateJobList')
AddEventHandler('esx_scoreboard:updateJobList', function(data)
    SendNUIMessage({
        type = 'updateJobList',
        jobs = data.jobs
    })
end)

RegisterNetEvent('esx_scoreboard:sendPlayerJob')
AddEventHandler('esx_scoreboard:sendPlayerJob', function(data)
    SendNUIMessage({
        type = 'updateUserJob',
        job = data.job,
        job_grade = data.job_grade
    })
end)

RegisterNUICallback('updateBusinessStatus', function(data, cb)
    TriggerServerEvent('esx_scoreboard:updateBusinessStatus', data.business, data.status)
    cb('ok')
end)

RegisterNUICallback('addBusiness', function(data, cb)
    TriggerServerEvent('esx_scoreboard:addBusiness', data.business, data.job, data.grade, data.image, data.description, data.street, data.cap)
    cb('ok')
end)

RegisterNUICallback('editBusiness', function(data, cb)
    TriggerServerEvent('esx_scoreboard:editBusiness', data.business, data.newBusiness, data.job, data.grade, data.image, data.description, data.street, data.cap)
    cb('ok')
end)

RegisterNUICallback('removeBusiness', function(data, cb)
    TriggerServerEvent('esx_scoreboard:removeBusiness', data.business)
    cb('ok')
end)

RegisterNUICallback('closeScoreboard', function(_, cb)
    SetNuiFocus(false, false)
    scoreboardVisible = false
    cb('ok')
end)

RegisterNUICallback('updateKeyConfig', function(data, cb)
    openKey = GetKeyFromName(data.openKey)
    closeKey = GetKeyFromName(data.closeKey)
    cb('ok')
end)

RegisterNUICallback('getJobNames', function(_, cb)
    TriggerServerEvent('esx_scoreboard:getJobNames')
    cb('ok')
end)

function GetKeyFromName(keyName)
    local keyCode = {
        ["F9"] = 56,
        ["Escape"] = 322,
    }
    return keyCode[keyName] or 0
end

Citizen.CreateThread(function()
    SendNUIMessage({
        type = 'initKeys',
        openKey = 'F9',
        closeKey = 'Escape'
    })

    while true do
        Citizen.Wait(10)
        if IsControlJustReleased(0, openKey) then
            scoreboardVisible = not scoreboardVisible
            SendNUIMessage({
                type = 'toggleScoreboard',
                visible = scoreboardVisible
            })
            SetNuiFocus(scoreboardVisible, scoreboardVisible)
            if scoreboardVisible then
                TriggerServerEvent('esx_scoreboard:getConnectedPlayers')
                TriggerServerEvent('esx_scoreboard:getBusinessStatus')
                TriggerServerEvent('esx_scoreboard:getJobNames')
                TriggerServerEvent('esx_scoreboard:getPlayerJob')
                TriggerServerEvent('esx_scoreboard:checkPermissions')
                TriggerServerEvent('esx_scoreboard:checkBusinessPermissions')
            end
        elseif IsControlJustReleased(0, closeKey) then
            if scoreboardVisible then
                SendNUIMessage({
                    type = 'toggleScoreboard',
                    visible = false
                })
                SetNuiFocus(false, false)
                scoreboardVisible = false
            end
        end
    end
end)
