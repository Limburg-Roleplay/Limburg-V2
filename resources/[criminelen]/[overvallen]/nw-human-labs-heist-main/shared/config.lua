Config = {}

Config.Debugger = false

Config.Webhook = {
    hacker_log = "https://discord.com/api/webhooks/1291781122639794289/xMHpg8HMgdPe4tpvBvkpLgzZBlYJ3IrkUH2-tETmTvnqX4YUDvnSq1vtuc8ZIMxxefMm",
    item_log = "https://discord.com/api/webhooks/1291781122639794289/xMHpg8HMgdPe4tpvBvkpLgzZBlYJ3IrkUH2-tETmTvnqX4YUDvnSq1vtuc8ZIMxxefMm",
}

Config.HeistNPC = {
    {
        -- location = vec4(1620.4526, -2283.8933, 106.2856, 179.1451), Coords to use
        location = vec4(132.3132, -762.5416, 45.7521, 162.7738),
        model = 's_m_y_robber_01',
    },
}

Config.GeneralTargetDistance = 1.5

Config.Notifies = {
    timer = 7500,
    position = "center-right"
}

Config.HeistInformation = {
    ['Elevator_fadeout_timer'] = 2000,
    ['HeistCooldownTimer'] = 30, -- Minuten
    ['PoliceNumberRequired'] = 0
}

Config.HeistItems = {
    ["PrepPhaseItems"] = {
        key_card = {item_name = "key_card", amount = 1},
        blueprint = {item_name = "blueprint", amount = 1}
    },

    ['FinaleItems'] = {
        sample = {item_name = 'sample', amount = 1}
    }
}

Config.RequiredWeapons = {
    'weapon_snspistol',
    'weapon_pistol50',
    'weapon_pistol',
    'weapon_pistol_mk2',
    'weapon_glock17',
    'weapon_sig',
    'weapon_glock19x',
    'weapon_combatpistol',
    'weapon_sawnoffshotgun',
    'weapon_benellim4',
    'weapon_doublebarrelfm',
    'weapon_hkump',
    'weapon_agc',
    'weapon_miniuzi',
    'weapon_ak74_1',
    'weapon_nvrifle',
    'weapon_mcxrattler',
    'weapon_fm1_hk416',
    'weapon_fm2_hk416',
    'weapon_mb47',
    'weapon_mp5',
    'weapon_aks74u',
    'weapon_fm1_m9a3',
    'weapon_remington',
    'weapon_minismg'
}

Config.Translations = {
    ["HeistStart"] = {
        heist_title = "Human Labs Heist",
        heist_occupied = {
            label = "Er is al iemand bezig met de human labs overval, kom later terug om het nog een keer te proberen!",
            timer = 15000
        },

        heist_recently_done = {
            label = "Iemand heeft te recentelijk al een heist gedaan. Wacht nog %s seconden!", -- %s erin laten, deze formateerd het aantal seconden dat iemand moet wachten voor een nieuwe heist
            timer = 15000
        },
        
        not_enough_police = {
            label = "Er is niet genoeg politie in dienst, er moet minimaal %s politie in dienst zijn.", -- %s erin laten, deze formateerd het aantal seconden dat iemand moet wachten voor een nieuwe heist
            timer = 15000
        },

        not_a_threat = {
            label = "Je vormt geen bedreiging om deze heist te kunnen starten.",
            timer = 15000
        },
    },

    ["Phases"] = {
        heist_boss_title = "Heist Baas",
        progressbar_timer = 5000,
        -- progress_label = "Overleggen...",
        ["FirstPreparationPhase"] = {
            fib_building_message = {
                label = "Ga naar het FIB gebouw, gebruik de keycard die ik je heb gegeven en ga dan met de lift omhoog.",
                timer = 15000,
            },

            fib_swipe_card_done = {
                label = "Stap in de lift en ga omhoog door op de knop te drukken.",
                timer = 15000,
            },

            fib_top_building_message = {
                label = "Oke, ga nu op zoek naar de blueprint, ik weet niet waar die ligt maar je moet er goed naar zoeken!",
                timer = 15000,
            }
        },

        ["SecondPreparationPhase"] = {
            electric_box_target_label = "Hacken",

            blueprint_picked = {
                label = "Keer snel terug naar de lift!",
                timer = 7500,
            },

            go_to_human_labs = {
                label = "Goed werk, ik heb je een GPS route toegestuurd, ga daarheen en hack de elektriciteits kast!",
                timer = 10000,
            },
            
            doors_opened_notify = {
                message = "Nu komt de blueprint heel goed van pas! Ga via de garage deuren naar binnen en zoek het serum doormiddel van de blueprint.",
                timer = 10000,
            }
        },

        ["Finale"] = {
            serum_label = "Pak Serum",
            found_serum = {
                message = "Goed werk, je hebt het serum gevonden, ga nu zo snel mogelijk naar buiten.",
                timer = 10000,
            }
        }
    },

    ["Police"] = {
        message_title = "Overval Humane Labs",
        message = "Het alarm bij Humane Labs is afgegaan. Ga zo snel mogelijk naar de locatie toe, pas op want ze kunnen bewapend zijn!",
        timer = 12000
    },
}