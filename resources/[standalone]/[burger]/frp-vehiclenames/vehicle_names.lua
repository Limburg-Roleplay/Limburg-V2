function AddTextEntry(key, value)
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
    -- Audi
    AddTextEntry("rs322sedanc", "Audi RS3 Sedan")
    AddTextEntry("rs6", "Audi RS6")
    AddTextEntry("rmodrs6r", "Audi RS6 ABT")
    AddTextEntry("rcwagon", "Audi RS2 Coupe Prior")
    AddTextEntry("gsthoonitr", "Audi Etron RS Hoonitron")
    -- BMW
    AddTextEntry("rmodm3touri", "BMW M3 Touring")
    AddTextEntry("audi a3 pol", "BMW M135i")
    AddTextEntry("e30s", "BMW E30 Drift")
    -- Subaru
    AddTextEntry("subwrxtdb", "Subaru WRX STI")
    -- Dodge
    AddTextEntry("ram2500lift", "Dodge Ram 2500")
    -- Lexus
    AddTextEntry("is300", "Lexus IS300")
    -- Cadillac
    AddTextEntry("escaladespo", "Cadillac Escalade Sport")
    -- Chevrolet
    AddTextEntry("monte", "Chevrolet Monte Carlo")
    -- Volkswagen
    AddTextEntry("remus8r", "Volkswagen Golf 8R")
    AddTextEntry("golf91widep", "Volkswagen Golf Widebody")
    -- Ferrari
    AddTextEntry("gcmaaaad", "Ferrari Purosangue")
    -- Ford
    AddTextEntry("gsthoonit1", "Ford F150 Hoonitruck")
    AddTextEntry("lowvic", "Ford Crown Vicoria")
    AddTextEntry("ford", "Ford Bronco Sport 2021")
    AddTextEntry("mustang", "Ford Mustang")
    AddTextEntry("hn65x3", "Ford Mustang 65 Hoonigan")
    -- Lamborghini
    AddTextEntry("lhuracant", "Lamborghini Huracan")
    AddTextEntry("amrevu23mg", "Lamborghini Revuelto Gitani")
    AddTextEntry("rmodsvj", "Lamborghini Aventador SVJ")
    -- Mazda
    AddTextEntry("fd3s", "Mazda RX7")
    AddTextEntry("na6", "Mazda Miata NA6")
    -- Mercedes
    AddTextEntry("amghr", "Mercedes AMG GTR HR")
    AddTextEntry("s63amg18", "Mercedes 190E Evo II")
    AddTextEntry("glemansory", "Mercedes GLE Mansory")
    -- Infinity
    AddTextEntry("q60pbs", "Infinity Q60")
    -- Mitsubishi
    AddTextEntry("evo", "Mitsubishi Lancer Evo X")
    -- Nissan
    AddTextEntry("180sx", "Nissan 180SX")
    AddTextEntry("gtrx3", "Nissan GTR R35 Widebody")
    AddTextEntry("nissan", "Nissan Silvia S15")
    AddTextEntry("godzr36conc", "Nissan GTR R36 Concept")
    AddTextEntry("gst400zv3", "Nissan 400Z Hoonigan")
    AddTextEntry("r33ptnc", "Nissan Skyline R33")
    -- Porsche
    AddTextEntry("930t", "Porsche 930 Turbo")
    AddTextEntry("crossikx3", "Porsche Taycan Crossturismo")
    -- Honda
    AddTextEntry("dc5", "Honda Intregra TypeR")
    -- Toyota
    AddTextEntry("a70", "Toyota Supra A70")
    AddTextEntry("chaser", "Toyota Chaser JZX100")
    AddTextEntry("rrsupramk3", "Toyota Supra A70 Widebody")
    --McLaren
    AddTextEntry("720nlargo", "Mclaren 720 Nlargo")
    --RollsRoyce
    AddTextEntry("cullinan", "Rolls Royce Cullinan")
end)