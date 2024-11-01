
local jobList = {
    jansen = {
        [1] = "Member",
        [2] = "Boss",
    },
    ccf = {
        [1] = "Hangaround",
        [2] = "Cugine",
        [3] = "Mademan",
        [4] = "Bagman",
        [5] = "Armoryman",
        [6] = "Underboss",
        [7] = "Right hand",
        [8] = "Don",
    },
    laoscura = {
        [1] = "Hangaround",
        [2] = "Bewaker",
        [3] = "Soldier",
        [4] = "Sicario",
        [5] = "Companero",
        [6] = "SubJefe",
        [7] = "Jefe",
    },
    hsq = {
        [1] = "Associate",
        [2] = "Streetrunner",
        [3] = "Hitter",
        [4] = "Swiper",
        [5] = "Shotcaller",
        [6] = "Righthand",
        [7] = "Leader",
    },
    albanesemaffia = {
        [1] = "Asociado",
        [2] = "Soldado",
        [3] = "Sicario",
        [4] = "Comandante",
        [5] = "Subjefa",
        [6] = "Patron",
    },
    niquenta = {
        [1] = "Hankali",
        [2] = "Memba",
        [3] = "Cikakken memba",
        [4] = "Mai harbi",
        [5] = "Babban Mai harbi",
        [6] = "Hannun dama",
        [7] = "Shugaban kasa",
        [8] = "Shugaba",
    },
    vatoslocos = {
        [1] = "Cugine",
        [2] = "Associate",
        [3] = "MadeMan",
        [4] = "Armory",
        [5] = "Bag Man",
        [6] = "Caporegime",
    },
    angelsofdeath = {
        [1] = "Member",
        [2] = "Guard",
        [3] = "Shooter",
        [4] = "Hitman",
        [5] = "Linkerhand",
        [6] = "Rechterhand",
        [7] = "Underboss",
        [8] = "Boss",
    },
    carteldellago = {
        [1] = "Recruit",
        [2] = "Member",
        [3] = "Guard",
        [4] = "Hitman",
        [5] = "capo",
        [6] = "Rechterhand",
        [7] = "Underboss",
        [8] = "Boss",
    },
    cjng = {
        [1] = "asociado",
        [2] = "soldado",
        [3] = "sicario",
        [4] = "grupodeÉlite",
        [5] = "líderDelGrupoDeÉlite",
        [6] = "comandante",
        [7] = "patron",
    },
    saints = {
        [1] = "Affiliate ",
        [2] = "Crusador",
        [3] = "Inquisitor",
        [4] = "Lieutenant",
        [5] = "Affiliate",
        [6] = "Captain",
        [7] = "Vanguard",
    },
    sinaloa = {
        [1] = "Loopjongen",
        [2] = "Member",
        [3] = "Shooter",
        [4] = "Hitman",
        [5] = "Underboss",
        [6] = "Boss",
    },
}

function getJobGradeLabel(jobName, gradeNumber)
    if not jobList[jobName] then
        return nil, "Job not found"
    end
    local label = jobList[jobName][gradeNumber]
    if not label then
        return nil, "Grade not found"
    end
    return label, nil
end