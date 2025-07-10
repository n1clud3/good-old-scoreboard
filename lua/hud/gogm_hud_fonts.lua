if (system.IsLinux()) then
    surface.CreateFont("GOGmScoreboardTitle", {
        font = "InterDisplay-Black.ttf",
        extended = true,
        weight = 900,
        size = 32
    })

    surface.CreateFont("GOGmScoreboardPlayerName", {
        font = "InterDisplay-SemiBold.ttf",
        extended = true,
        weight = 600,
        size = 22
    })

    surface.CreateFont("GOGmScoreboardRegular", {
        font = "InterDisplay-Regular.ttf",
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
    font = "Inter Display Black",
    extended = true,
    weight = 900,
    size = 32
})

surface.CreateFont("GOGmScoreboardPlayerName", {
    font = "Inter Display SemiBold",
    extended = true,
    weight = 600,
    size = 22
})

surface.CreateFont("GOGmScoreboardRegular", {
    font = "Inter Display",
    extended = true,
    weight = 400,
    size = 24
})

surface.CreateFont("GOGmScoreboardNumbers", {
    font = "Fira Mono",
    weight = 600,
    size = 20
})