Config = {}

Config.Blips = {
    {
        ['coords'] = vec3(-1539.5935, -417.6594, 35.6234),
        ['drawText'] = 'Sportschool',
        ['scale'] = 0.7,
        ['sprite'] = 311,
        ['colour'] = 49
    }
}

Config.Locations = {
    -- Stamina trainen
    {
        ['coords'] = vec3(-1542.1350, -426.8536, 35.7765),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Hardlopen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(-1542.1350, -426.8536, 35.7765, 228.1977),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    {
        ['coords'] = vec3(-1541.1555, -425.9551, 35.7805),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Hardlopen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(-1541.1555, -425.9551, 35.7805, 227.3474),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    {
        ['coords'] = vec3(238.31, -256.67, 60.20),
        ['size'] = vec3(1.5, 1.5, 1.5),
        ['drawText'] = 'Stamina trainen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(239.14, -257.45, 60.07, 42.25),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    {
        ['coords'] = vec3(239.90, -255.45, 60.20),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Stamina trainen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(240.36, -256.17, 60.07, 30.31),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    {
        ['coords'] = vec3(241.96, -254.70, 60.20),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Stamina trainen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(242.13, -255.54, 60.07, 9.39),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    {
        ['coords'] = vec3(244.11, -254.01, 60.20),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Stamina trainen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(244.25, -255.11, 60.07, 7.35),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    {
        ['coords'] = vec3(246.47, -254.38, 60.20),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Stamina trainen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(246.36, -255.20, 60.07, 353.10),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    {
        ['coords'] = vec3(249.17, -255.20, 60.20),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Stamina trainen',
        ['icon'] = 'fa-solid fa-person-running',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'stamina', ['type'] = 'stamina', ['label'] = 'Stamina' },
        ['activityCoords'] = vec4(248.91, -255.95, 60.06, 334.84),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    -- Chins trainen
    {
        ['coords'] = vec3(-1544.0389, -418.9267, 35.6354),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Chins trainen',
        ['icon'] = 'fa-solid fa-child-reaching',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'chins', ['type'] = 'strength', ['label'] = 'Kracht' },
        ['activityCoords'] = vec4(-1544.0389, -418.9267, 35.6354, 136.7809),
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    -- Boksbal trainen
    {
        ['coords'] = vec3(-1545.9281, -426.5872, 35.6234),
        ['size'] = vec3(1.5, 1.5, 1.5),
        ['drawText'] = 'Boksbal',
        ['icon'] = 'fa-solid fa-hand-fist',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'boksbal', ['type'] = 'strength', ['label'] = 'Kracht' },
        ['isBusy'] = false,
        ['isSubscription'] = true
    },
    -- Gewichten
    {
        ['coords'] = vec3(-1541.5972, -413.9522, 35.6372),
        ['size'] = vec3(3, 3, 3),
        ['drawText'] = 'Gewicht heffen',
        ['icon'] = 'fa-solid fa-hand-fist',
        ['event'] = 'frp-gym:client:train',
        ['distance'] = 1.75,
        ['args'] = { ['animType'] = 'weights', ['type'] = 'strength', ['label'] = 'Gewichten' },
        ['activityCoords'] = vec4(-1541.5972, -413.9522, 35.6372, 139.0041),
        ['isBusy'] = false,
        ['isSubscription'] = true
    }
}

Config.Animations = {
    ['stamina'] = {
        ['idleDict'] = 'move_m@jogger',
        ['idleAnim'] = 'idle',
        ['actionDict'] = 'move_m@jogger',
        ['actionAnim'] = 'run',
        ['actionTime'] = 2500,
        ['enterDict'] = 'move_m@jogger',
        ['enterAnim'] = 'idle',
        ['enterTime'] = 2500,
        ['exitDict'] = 'move_m@jogger',
        ['exitAnim'] = 'rstop_l',
        ['exitTime'] = 2000,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 20,
        ['freeze'] = true
    },
    ['chins'] = {
        ['idleDict'] = 'amb@prop_human_muscle_chin_ups@male@idle_a',
        ['idleAnim'] = 'idle_a',
        ['actionDict'] = 'amb@prop_human_muscle_chin_ups@male@base',
        ['actionAnim'] = 'base',
        ['actionTime'] = 3000,
        ['enterDict'] = 'amb@prop_human_muscle_chin_ups@male@enter',
        ['enterAnim'] = 'enter',
        ['enterTime'] = 1600,
        ['exitDict'] = 'amb@prop_human_muscle_chin_ups@male@exit',
        ['exitAnim'] = 'exit',
        ['exitTime'] = 3700,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 25,
        ['freeze'] = true
    },
    ['boksbal'] = {
        ['idleDict'] = 'move_m@jogger',
        ['idleAnim'] = 'idle',
        ['actionDict'] = 'anim@mp_player_intcelebrationmale@shadow_boxing',
        ['actionAnim'] = 'shadow_boxing',
        ['actionTime'] = 2850,
        ['enterDict'] = 'anim@mp_player_intuppershadow_boxing',
        ['enterAnim'] = 'exit',
        ['enterTime'] = 1100,
        ['exitDict'] = 'move_m@_idles@out_of_breath',
        ['exitAnim'] = 'idle_a',
        ['exitTime'] = 3300,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 21,
        ['freeze'] = true,
    },
    ['weights'] = {
        ['idleDict'] = '',
        ['idleAnim'] = '',
        ['actionDict'] = '',
        ['actionAnim'] = '',
        ['actionTime'] = 2850,
        ['enterDict'] = '',
        ['enterAnim'] = '',
        ['enterTime'] = 1100,
        ['exitDict'] = '',
        ['exitAnim'] = '',
        ['exitTime'] = 3300,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 21,
        ['freeze'] = true,
    },
}