function SendDiscord(title, message)
    local embed = {}
    embed = {
        {
            ["color"] = 65280,
            ["title"] = "**" .. title .. "**",
            ["description"] = "**" .. message .. "**",
            ["footer"] = {
                ["text"] = 'TH-scripts @ 2024'
            },
        }
    }
    PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = GetCurrentResourceName(), embeds = embed, content = ""}), { ['Content-Type'] = 'application/json' })
end