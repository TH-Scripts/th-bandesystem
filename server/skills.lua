--MARK: Get gang skills
--@param source int
--@return table

lib.callback.register('th-bandesystem:GetGangSkills', function(source, gangname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local gangId = GetGangId(xPlayer.identifier)

    if not xPlayer then return end


    local skills = MySQL.query.await('SELECT * FROM gang_skills WHERE gang_id = ?', {
        gangId
    })


    return skills
end)



--MARK: Add skill exp
--@param source int
--@param skill string
--@param amount int
--@return bool | string

lib.callback.register('th-bandesystem:AddSkillExp', function(source, skill, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local gangId = GetGangId(xPlayer.identifier)

    if not xPlayer or not gangId then return end


    local current_exp = MySQL.query.await('SELECT ' .. skill .. ' FROM gang_skills WHERE gang_id = ?', {
        gangId
    })

    if not current_exp then return end

    local check_max_level = CheckMaxLevel(source, skill)

    if check_max_level then return "max_level" end

    local update_exp = MySQL.update.await('UPDATE gang_skills SET ' .. skill .. ' = ? WHERE gang_id = ?', {
        amount + current_exp[1][skill],
        gangId
    })

    if update_exp then
        return true
    else
        return false
    end


end)

--MARK: Check for level up
--@param skill string
--@param exp int
--@return bool | lvl | string

lib.callback.register('th-bandesystem:CheckForLevelUp', function(source, skill, exp)
    local xPlayer = ESX.GetPlayerFromId(source)
    local gangId = GetGangId(xPlayer.identifier)

    if not xPlayer or not gangId then return end

    local current_exp = MySQL.query.await('SELECT ' .. skill .. ' FROM gang_skills WHERE gang_id = ?', {
        gangId
    })

    if not current_exp then return end

    local total_exp = current_exp[1][skill] + exp

    if total_exp < 100 then return end

    local check_max_level = CheckMaxLevel(source, skill)

    if check_max_level then return "max_level" end

    local level_up = LevelUpSkill(source, skill)

    if level_up then
        return level_up
    else
        return false
    end
end)


--MARK: Check max level
--@param source int
--@return bool

function CheckMaxLevel(source, skill)
    local xPlayer = ESX.GetPlayerFromId(source)
    local gangId = GetGangId(xPlayer.identifier)

    local level_skill = string.sub(skill, 1, -4) .. "_level" 

    local current_lvl = MySQL.query.await('SELECT ' .. level_skill .. ' FROM gang_skills WHERE gang_id = ?', {
        gangId
    })

    if not current_lvl then return end

    if Config.MaxSkillLevel <= current_lvl[1][level_skill] then
        return true
    else
        return false
    end
end


--MARK: Level up skill
--@param skill string
--@return bool | lvl

function LevelUpSkill(source, skill)
    local xPlayer = ESX.GetPlayerFromId(source)
    local gangId = GetGangId(xPlayer.identifier)

    if not xPlayer or not gangId then return end

    local level_skill = string.sub(skill, 1, -4) .. "_level" 

    local current_lvl = MySQL.query.await('SELECT ' .. level_skill .. ' FROM gang_skills WHERE gang_id = ?', {
        gangId
    })

    if not current_lvl then return end

    local level_up = MySQL.update.await('UPDATE gang_skills SET ' .. level_skill .. ' = ? WHERE gang_id = ?', {
        current_lvl[1][level_skill] + 1,
        gangId
    })

    local reset_exp = MySQL.update.await('UPDATE gang_skills SET ' .. skill .. ' = 0 WHERE gang_id = ?', {
        gangId
    })

    if level_up and reset_exp then
        return current_lvl[1][level_skill] + 1
    else
        return false
    end

end



function GetGangId(identifier)
    local gangId = MySQL.Sync.fetchAll('SELECT gang_id FROM gangs WHERE gang_owner = ?', { identifier })

    return gangId[1].gang_id
end
