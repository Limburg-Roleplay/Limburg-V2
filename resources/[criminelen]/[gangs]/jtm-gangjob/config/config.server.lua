ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local jobList = {
    jansen = {
        [1] = "Member",
        [2] = "Boss",
    },
    ccf = {
        [1] = "Cugine",
        [2] = "Associate",
        [3] = "MadeMan",
        [4] = "Armory",
        [5] = "BagMan",
        [6] = "Caporegime",
        [7] = "Consigliere",
        [8] = "Underboss",
        [9] = "Don",
    },
    camorra = {
        [1] = "Gregario",
        [2] = "Legionario",
        [3] = "Pistolero",
        [4] = "Cucinare",
        [5] = "Pacchi",
        [6] = "Consegnerà",
        [7] = "Capo il Tutti'",
        [8] = "Capo",
    },
    ms13 = {
        [1] = "Proeftijd",
        [2] = "Member",
        [3] = "Hitman",
        [4] = "Underboss",
        [5] = "Boss",
    },
    redeye = {
        [1] = "Spotter",
        [2] = "Runner",
        [3] = "Treasurer",
        [4] = "Big Guy",
        [5] = "That Guy",
        [6] = "CEO",
        [7] = "Owner",
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
    roemeensemafia = {
        [1] = "Sugaș",
        [2] = "Membru",
        [3] = "Asasinat",
        [4] = "Asasinat Cap",
        [5] = "Subșeful",
        [6] = "Șef",
    },
    calohwagoh = {
        [1] = "Hangaround",
        [2] = "Member",
        [3] = "Shooter",
        [4] = "Underboss",
        [5] = "Boss",
    },
    hells = {
        [1] = "Hangaround",
        [2] = "Prospect",
        [3] = "fullpatchmember",
        [4] = "roadcaptain",
        [5] = "sergeantatarms",
        [6] = "clubsecretary",
        [7] = "vicepresident",
        [8] = "president",
    },
    chipmunks = {
        [1] = "Eleanor",
        [2] = "Jeanette",
        [3] = "Brittany",
        [4] = "Theodore",
        [5] = "Simon",
        [6] = "Alvin",
    },
    reznikov = {
        [1] = "Meeloper",
        [2] = "Member",
        [3] = "Shooter",
        [4] = "Rechterhand",
        [5] = "Underboss",
        [6] = "Boss",
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
    rashkov = {
        [1] = "оппортунист",
        [2] = "член",
        [3] = "брат",
        [4] = "Топмен",
        [5] = "Лил Капо",
        [6] = "Капо",
        [7] = "под начальником",
        [8] = "начальник",
    },
    crips = {
        [1] = "Meeloper",
        [2] = "Member",
        [3] = "Hitman",
        [4] = "Hoofdhitman",
        [5] = "Underboss",
        [6] = "Boss",
    },
    pavlov = {
        [1] = "member",
        [2] = "fullmember",
        [3] = "hitman",
        [4] = "hoofdhitman",
        [5] = "rechterhand",
        [6] = "boss",
    },
    lfc = {
        [1] = "Rekruutinopleiding",
        [2] = "Rekruut",
        [3] = "Junior Colonel",
        [4] = "Colonel",
        [5] = "underboss",
        [6] = "Boss",
    },
    tijuana = {
        [1] = "recluta",
        [2] = "miembro",
        [3] = "capitán ",
        [4] = "sicario ",
        [5] = "sicarioprincipal",
        [6] = "subjefe",
        [7] = "jefe",
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
    karmellos = {
        [1] = "Conocido",
        [2] = "Nieto",
        [3] = "Sobrino",
        [4] = "Hermano",
        [5] = "Comandante",
        [6] = "Tío",
        [7] = "Padre",
        [8] = "Abuelo",
    },
    zone6 = {
        [1] = "Loopjongen",
        [2] = "Member",
        [3] = "Soldaat",
        [4] = "Shooter",
        [5] = "HeadShooter",
        [6] = "Hogeraad",
        [7] = "Underboss",
        [8] = "Leader",
    },
    akatsuki = {
        [1] = "Shinobi",
        [2] = "Genin",
        [3] = "Chunin",
        [4] = "Jonin",
        [5] = "AnbuSpecialOps",
        [6] = "Sannin",
        [7] = "Kage",
        [8] = "Sage",
    },
    saints = {
        [1] = "Soldier",
        [2] = "Hitman",
        [3] = "Head Hitman",
        [4] = "Captain",
        [5] = "Underboss",
        [6] = "Boss",
    },
    sons = {
        [1] = "Full Member",
        [2] = "Hitman",
        [3] = "Head Hitman",
        [4] = "Captain",
        [5] = "Advisor",
        [6] = "Boss",
    },
    soulz = {
        [1] = "Guardadeseguridad",
        [2] = "Membro",
        [3] = "Sicario",
        [4] = "Consejero",
        [5] = "Sub Jefe",
        [6] = "Jefe",
    },
    bratva = {
        [1] = "Loopjongen",
        [2] = "Member",
        [3] = "Shooter",
        [4] = "Hoge Raad",
        [5] = "Vice President",
        [6] = "President",
    },
    sinaloa = {
        [1] = "Loopjongen",
        [2] = "Member",
        [3] = "Shooter",
        [4] = "Hitman",
        [5] = "Underboss",
        [6] = "Boss",
    },
    tgg = {
        [1] = "Associate",
        [2] = "Gentleman",
        [3] = "Sr. Gentleman",
        [4] = "Advisor",
        [5] = "Don",
        [6] = "Account Manager",
    },
    hsq = {
        [1] = "Associate",
        [2] = "Street Runner",
        [3] = "Swiper",
        [4] = "Hitter",
        [5] = "Shotcaller",
        [6] = "Righthand",
        [7] = "Boss",
    },
    albanesemaffia = {
        [1] = "Recruit",
        [2] = "Guard",
        [3] = "Soldier",
        [4] = "Head Soldier",
        [5] = "Rechterhand",
        [6] = "Underboss",
        [7] = "El Capo",
    },
    netas = {
        [1] = "Accociate",
        [2] = "Sicario",
        [3] = "Consgiliere",
        [4] = "Righthand",
        [5] = "Patron",
    }
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