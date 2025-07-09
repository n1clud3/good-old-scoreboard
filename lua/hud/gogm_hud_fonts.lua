if (system.IsLinux()) then
    surface.CreateFont("GOGmScoreboardTitle", {
        font = "inter_variable.ttf",
        extended = true,
        weight = 900,
        size = 32
    })

    surface.CreateFont("GOGmScoreboardPlayerName", {
        font = "inter_variable.ttf",
        extended = true,
        weight = 600,
        size = 22
    })

    surface.CreateFont("GOGmScoreboardRegular", {
        font = "inter_variable.ttf",
        extended = true,
        weight = 400,
        size = 24
    })

    surface.CreateFont("GOGmScoreboardNumbers", {
        font = "fira_mono_bold.ttf",
        weight = 600,
        size = 20
    })

    return
end

surface.CreateFont("GOGmScoreboardTitle", {
    font = "Inter Variable",
    extended = true,
    weight = 900,
    size = 32
})

surface.CreateFont("GOGmScoreboardPlayerName", {
    font = "Inter Variable",
    extended = true,
    weight = 600,
    size = 22
})

surface.CreateFont("GOGmScoreboardRegular", {
    font = "Inter Variable",
    extended = true,
    weight = 400,
    size = 24
})

surface.CreateFont("GOGmScoreboardNumbers", {
    font = "Fira Mono",
    weight = 600,
    size = 20
})