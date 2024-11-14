--MARK: Skill System
--@param gangname string
--@return context menu

function ShowSkills(gangname)

    local options = {}
    local skills = lib.callback.await('th-bandesystem:GetGangSkills', false, gangname)

    for _,v in pairs(skills) do

        table.insert(options, {
            title = 'Røveri - Max level',
            icon = 'fa-solid fa-people-robbery',
            iconColor = Config.ColorScheme,
            colorScheme = Config.ColorScheme,
            progress = 100,
        })

        if v.robbery_level < Config.MaxSkillLevel then
            options[#options].title = 'Røveri level: ' .. v.robbery_level .. ''
            options[#options].progress = v.robbery_xp
            options[#options].metadata = {
                {label = 'Antal xp', value = v.robbery_xp},
            }
        end

        table.insert(options, {
            title = 'Hus røveri - Max level',
            icon = 'fa-solid fa-house',
            iconColor = Config.ColorScheme,
            colorScheme = Config.ColorScheme,
            progress = 100,

        })

        if v.house_level < Config.MaxSkillLevel then
            options[#options].title = 'Hus røveri level: ' .. v.house_level .. ''
            options[#options].progress = v.house_xp
            options[#options].metadata = {
                {label = 'Antal xp', value = v.house_xp},
            }
        end

    end

    lib.registerContext({
        id = 'Skill_main',
        title = gangname .. ' - Skills',
        options = options,
        menu = 'th_bandesystem_boss_menu'
    })

    return lib.showContext('Skill_main')
end



--MARK: Add skill xp export
--@param skill string
--@param amount int
--@return notify

exports('AddExp', function(skill, amount)
    local gangId = GetGangId()

    if not gangId then return end

    local add_exp = lib.callback.await('th-bandesystem:AddSkillExp', false, skill, amount)

    if add_exp == "max_level" then
        return lib.notify({ title = 'Max level', description = 'Du har opnået max level i ' .. skill, type = 'info' })
    end


    local level_up = CheckForLevelUp(skill, amount)

    if level_up ~= false then
        return lib.notify({ title = 'Succes', description = 'Du har fået ' .. amount .. ' xp i ' .. skill .. ' og har nu level ' .. level_up .. ' i ' .. skill, type = 'success' })
    end 	

    if add_exp then
        return lib.notify({ title = 'Succes', description = 'Du har fået ' .. amount .. ' xp i ' .. skill, type = 'success' })
    else
        return lib.notify({ title = 'Fejl', description = 'Der skete en fejl', type = 'error' })
    end
end)


--MARK: Get level export
--@param skill string
--@param lvl int
--@return bool


exports('CheckLevel', function(skill, lvl)

    if not skill or not lvl then return end

    local level = lib.callback.await('th-bandesystem:CheckLevel', false, skill, lvl)

    return level

end)



--MARK: Check for level up
--@param skill string
--@param exp int
--@return bool | lvl

function CheckForLevelUp(skill, exp)

    local level_up = lib.callback.await('th-bandesystem:CheckForLevelUp', false, skill, exp)

    if level_up == "max_level" then 
        return lib.notify({ title = 'Max level', description = 'Du har opnået max level i ' .. skill, type = 'info' })
    end


    if level_up then
        return level_up
    else
        return false
    end
end