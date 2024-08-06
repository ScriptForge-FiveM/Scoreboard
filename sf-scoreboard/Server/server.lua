ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('esx_scoreboard:getBusinessStatus')
AddEventHandler('esx_scoreboard:getBusinessStatus', function()
    MySQL.Async.fetchAll("SELECT * FROM business_status", {}, function(results)
        local businesses = {}
        for _, row in ipairs(results) do
            table.insert(businesses, {
                business = row.business,
                status = tonumber(row.status) or 0,
                job = row.job,
                grade = tonumber(row.grade) or 0,
                image = row.image,
                description = row.description,
                street = row.street,
                cap = row.cap
            })
        end


        TriggerClientEvent('esx_scoreboard:sendBusinessStatus', -1, businesses)
    end)
end)


RegisterServerEvent('esx_scoreboard:updateBusinessStatus')
AddEventHandler('esx_scoreboard:updateBusinessStatus', function(business, status)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("UPDATE business_status SET status = @status WHERE business = @business", {
        ['@status'] = status,
        ['@business'] = business
    }, function(affectedRows)
        if affectedRows > 0 then

            TriggerEvent('esx_scoreboard:getBusinessStatus')

            TriggerClientEvent('esx:showNotification', -1, ("Business %s is now %s"):format(business, status == 0 and 'Closed' or 'Open'))
        else
            print("Failed to update business status: No rows affected.")
        end
    end)
end)

RegisterServerEvent('esx_scoreboard:addBusiness')
AddEventHandler('esx_scoreboard:addBusiness', function(business, job, grade, image, description, street, cap)
    MySQL.Async.execute("INSERT INTO business_status (business, status, job, grade, image, description, street, cap) VALUES (@business, 0, @job, @grade, @image, @description, @street, @cap)", {
        ['@business'] = business,
        ['@job'] = job,
        ['@grade'] = grade,
        ['@image'] = image,
        ['@description'] = description,
        ['@street'] = street,
        ['@cap'] = cap
    }, function(affectedRows)
        if affectedRows > 0 then
            TriggerEvent('esx_scoreboard:getBusinessStatus')
        else
            print("Failed to add new business: No rows affected.")
        end
    end)
end)

local function GetPlayersByJob(jobName)
    local xPlayers = ESX.GetPlayers()
    local count = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == jobName then
            count = count + 1
        end
    end

    return count
end

RegisterServerEvent('esx_scoreboard:getConnectedPlayers')
AddEventHandler('esx_scoreboard:getConnectedPlayers', function()
    local xPlayers = ESX.GetPlayers()
    local players = {}

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(players, {
            id = xPlayer.source,
            name = xPlayer.getName(),
            surname = xPlayer.get('lastname')
        })
    end

    local jobCounts = {}

    for jobName, jobLabel in pairs(Config.jobs) do
        jobCounts[jobName] = GetPlayersByJob(jobLabel)
    end
    
    TriggerClientEvent('esx_scoreboard:updatePlayers', -1, {
        totalPlayers = #xPlayers,
        players = players,
        jobCounts = jobCounts
    })
end)

RegisterServerEvent('esx_scoreboard:getJobNames')
AddEventHandler('esx_scoreboard:getJobNames', function()
    local jobs = {} 
    MySQL.Async.fetchAll("SELECT DISTINCT name FROM jobs", {}, function(results)
        for _, row in ipairs(results) do
            table.insert(jobs, row.name)
        end
        TriggerClientEvent('esx_scoreboard:updateJobList', -1, { jobs = jobs })
    end)
end)

RegisterServerEvent('esx_scoreboard:getPlayerJob')
AddEventHandler('esx_scoreboard:getPlayerJob', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local playerId = xPlayer.identifier

        MySQL.Async.fetchAll("SELECT job, job_grade FROM users WHERE identifier = @identifier", {
            ['@identifier'] = playerId
        }, function(result)
            if result[1] then
                local job = result[1].job
                local job_grade = tonumber(result[1].job_grade) or 0

            else
                print("Player job not found for identifier:", playerId)
            end
        end)
    else
        print("Player not found for source:", source)
    end
end)

RegisterServerEvent('esx_scoreboard:checkPermissions')
AddEventHandler('esx_scoreboard:checkPermissions', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local playerId = xPlayer.identifier
        local hasPermission = false

        for _, identifier in ipairs(Config.allowedIdentifiers) do
            if playerId == identifier then
                hasPermission = true
                break
            end
        end
        TriggerClientEvent('esx_scoreboard:sendPermissions', source, hasPermission)
    end
end)

RegisterServerEvent('esx_scoreboard:editBusiness')
AddEventHandler('esx_scoreboard:editBusiness', function(business, newBusiness, job, grade, image, description, street, cap)
    MySQL.Async.execute("UPDATE business_status SET business = @newBusiness, job = @job, grade = @grade, image = @image, description = @description, street = @street, cap = @cap WHERE business = @business", {
        ['@newBusiness'] = newBusiness,
        ['@job'] = job,
        ['@grade'] = grade,
        ['@image'] = image,
        ['@description'] = description,
        ['@street'] = street,
        ['@cap'] = cap,
        ['@business'] = business
    }, function(affectedRows)
        if affectedRows > 0 then
            TriggerEvent('esx_scoreboard:getBusinessStatus')
        else
            print("Failed to edit business: No rows affected.")
        end
    end)
end)

RegisterServerEvent('esx_scoreboard:removeBusiness')
AddEventHandler('esx_scoreboard:removeBusiness', function(business)
    MySQL.Async.execute("DELETE FROM business_status WHERE business = @business", {
        ['@business'] = business
    }, function(affectedRows)
        if affectedRows > 0 then
            TriggerEvent('esx_scoreboard:getBusinessStatus')
        else
            print("Failed to remove business: No rows affected.")
        end
    end)
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        TriggerEvent('esx_scoreboard:getConnectedPlayers')
        TriggerEvent('esx_scoreboard:getJobNames')
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                TriggerClientEvent('esx_scoreboard:sendPlayerJob', playerId, {
                    job = xPlayer.job.name,
                    job_grade = xPlayer.job.grade
                })
            end
        end
    end
end)
