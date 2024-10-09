Strings = {}

Strings.Notify = {
    title = 'Supermarkt', -- The title for all notifications
    icon = 'store', -- The icon for all notifications
    position = 'top', -- The position of all notifications
    registerCooldown = 'De eigenaar is nog niet hersteld van de vorige schade! Kom op een ander moment terug.',
    notEnoughPolice = 'Er is niet genoeg politie om de overval te starten!',
    missingItem = 'Je mist nog een bepaalde tool om de overval te starten. Kleine tip Youtool heeft alles wat je nodig hebt!',
    lockpickBroke = 'Je lockpick is gebroken, verkrijg een nieuwe om de overval opnieuw te proberen!',
    robberyCancel = 'Je bent gestopt met het openbreken van de kassa.',
    failedHack = 'Je bent helaas te incapabel om deze computer te hacken!',
    wrongPin = 'Je hebt de verkeerde pincode ingevoerd! De kluis zal hierdoor gesloten blijven.',
    errorOccured = 'Er is iets mis gegaan. Probeer het later nog eens.',
    tooManyHackFails = 'Je hebt te vaak gefaald tijdens het hacken van de computer. Kom op een ander moment terug.',
    tooManySafeFails = 'Je hebt de pincode te vaak verkeerd ingevoerd. Kom op een ander moment terug.'
}

Strings.Target = {
    registerLabel = 'Kassa Overvallen',
    registerIcon = 'fas fa-lock',
    computerLabel = 'Inloggen',
    computerIcon = 'fas fa-computer',
    safeLabel = 'Kluis openbreken',
    safeIcon = 'fas fa-key'
}

Strings.AlertDialog = {
    registerHeader = 'Notitie gevonden',
    registerContent = 'Je hebt een interessant briefje gevonden waar de code van de kluis op staat: ',
    registerCancelButton = 'Afbreken',
    registerConfirmButton = 'Bevestigen',
    computerHeader = 'Code Gekraakt',
    computerContent = 'Je hebt de computer gehacked en de volgende code gevonden: ',
    computerConfirmButton = 'Bevestigen'
}

Strings.InputDialog = {
    questionsHeader = 'Beveiligings Vragen',
    questionOne = 'Vraag #1',
    questionTwo = 'Vraag #2',
    questionThree = 'Vraag #3',
    questionFour = 'Vraag #4',
    safeHeader = 'Winkel Kluis',
    safeLabel = 'Pincode Invoeren',
    safeDescription = 'Vul de pincode in om de kluis te kraken.',
    safePlaceholder = '6969',
    safeIcon = 'lock'
}

Strings.Logs = {
    colors = {
        green = 65280,
        red = 16711680,
        yellow = 16776960,
    },
    labels = {
        name = '**Player Name**: ',
        id = '\n **Player ID**: ',
        identifier = '\n **Identifier**: ',
        message = '\n **Message**: '
    },
    titles = {
        robbery = 'Winkel Overval',
        cooldownA = '🔒 Cooldown Active',
        cooldownI = '🔓 Cooldown Inactive'
    },
    messages = {
        minutes = 'minutes',
        robbery = ' Heeft de winkel overvallen en heeft: ',
        cooldownRA = 'Kassa is nu op cooldown voor:',
        cooldownRI = 'Kassa cooldown is afgelopen',
        cooldownSA = 'Kluis is nu op cooldown voor: ',
        cooldownSI = 'Kluis cooldown is afgelopen'
    }
}