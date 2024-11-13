--MARK: Skill System
--@param gangname string
--@return context menu

function ShowSkills(gangname)
    if not gangname then return end

    local skills = lib.callback.await('th-bandesystem:GetGangSkills', false, gangname)

    for _,v in pairs(skills) do 
        local options = {}

        table.insert(options, {
            {
                title = 'Hus røveri level: ' .. v.house_level .. '',
                progress = v.house_xp,
            },
            {
                title = 'Røveri level: ' .. v.robbery_level .. '',
                progress = v.robbery_xp
            }
        })

        lib.registerContext({
            id = 'Skill_main',
            title = gangname .. ' skills',
            options = options
        })
    end

    return lib.showContext('Skill_main')
end