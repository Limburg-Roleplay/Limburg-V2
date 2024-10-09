var FRP = {['opened']: false};

var questionNumber = 1;
var userAnswer = [];
var goodAnswer = [];
var questionUsed = [];
var backendQuestion = 0;

var config = {
    timeConfig: 23
}

var questions = [
    {
        question: 'Hoe hard mag je rijden binnen de bebouwde kom?',
        propositionA: '30 km per uur.',
        propositionB: '80 km per uur.',
        propositionC: 'Onbeperkt, je mag zo hard rijden als je wilt.',
        answer: 'A'
    },
    {
        question: 'Een voetganger bij een voetgangersoversteekplaats/zebrapad:',
        propositionA: 'Moet je altijd voor laten gaan en voortgang verlenen.',
        propositionB: 'Kijken of ze doorlopen en anders kun je gewoon doorrijden.',
        answer: 'A'
    },
    {
        question: 'Je voert op de privé-auto optische- en geluidssignalen, je bent:',
        propositionA: 'Hiermee een voorrangsvoertuig geworden.',
        propositionB: 'Uiterst strafbaar, is streng verboden.',
        propositionC: 'Als je het goed gebruikt is het prima. ',
        answer: 'C'
    },
    {
        question: 'Bij nadering van een stopbord moet je:',
        propositionA: 'Rustig oprijden tot de stopstreep voordat je doorrijdt.',
        propositionB: 'De auto volledig stoppen voordat je doorrijdt.',
        propositionC: 'Als er geen auto is, mag je gewoon doorrijden.',
        answer: 'B'
    },
    {
        question: 'Als een verkeerslicht op oranje springt moet je:',
        propositionA: 'Even wat sneller gaan rijden om zodoende de doorstroming te bevorderen.',
        propositionB: 'De maximaal toegestane snelheid aanhouden en doorrijden met kans door rood licht te rijden.',
        propositionC: 'Uit veiligheid afremmen om ervoor te zorgen dat je niet door rood rijdt en de maximale toegestaande snelheid overtreedt.',
        answer: 'C'
    },
    {
        question: 'Je moet nodig een belangrijk telefoontje afhandelen:',
        propositionA: 'Je rijdt naar een parkeerplaats toe.',
        propositionB: 'Je stopt even op de vluchtstrook met gebruik van de alarmerende knipperlichten.',
        propositionC: 'Je rijdt door met de telefoon aan je oor, want het is immers belangrijk.',
        answer: 'A'
    },
    {
        question: 'De linker buitenspiegel ontbreekt:',
        propositionA: 'Je mag nu niet gaan rijden.',
        propositionB: 'Je mag rijden, want je hebt nog een binnen- en rechter buitenspiegel.',
        answer: 'A'
    },
    {
        question: 'Na het drinken van te veel alcohol wordt je een rijverbod opgelegd, je mag nu een motor besturen:',
        propositionA: 'Ja',
        propositionB: 'Nee',
        answer: 'B'
    },
    {
        question: 'Een "invoeger" op de autosnelweg heeft te weinig ruimte. Wat doe je:',
        propositionA: 'Je geeft wat gas bij zodat die niet meer kan invoegen.',
        propositionB: 'Je remt.',
        propositionC: 'Je gaat van het gas.',
        answer: 'C'
    },
    {
        question: 'Je hebt een rood lampje met je voertuig, wat doe je?',
        propositionA: 'Je rijdt gewoon door, want de auto rijdt toch gewoon nog?',
        propositionB: 'Je gaat zo snel mogelijk naar de ANWB om het te maken',
        answer: 'B'
    },
    {
        question: 'Mag je na twee biertjes nog auto rijden?',
        propositionA: 'Ja',
        propositionB: 'Nee',
        answer: 'B'
    },
    {
        question: 'De politie komt met zwaailichten achter je rijden, wat doe je?',
        propositionA: 'Je laat het gas los, kijkt of het voor jou is en als dat zo is zet je de auto aan de kant.',
        propositionB: 'Je geeft extra gas bij, want ze mogen je niet pakken.',
        propositionC: 'Niks, ze toeteren vanzelf wel.',
        answer: 'A'
    },
]

setInterval(function() {
    if (FRP.opened) {
        config.timeConfig -= 1
        $('.header .left .text').html('RESTERENDE TIJD <b>' + config.timeConfig + '</b> MINUTEN')
        if (config.timeConfig == 0) {
            $('.container').css('display', 'none');
        }
    }
}, 1000 * 60)

window.addEventListener('message', function(event) {
    if (event.data.type == 'openCBR') {
        FRP.openCBR();
    } else if (event.data.type == 'closeCBR') {
        FRP.closeCBR();
    }

    document.onkeyup = function (data) {
        if (data.which == 27 ) {
            FRP.closeCBR();
        }
      };
});

FRP.openCBR = function() {
    FRP.opened = true;
    $('.footer .middle .text').html('VRAAG <b>' + questionNumber + '</b> VAN DE <b>'+ questions.length)
    $(".container").fadeIn(500);
}

FRP.closeCBR = function() {
    $(".container").fadeOut(500, function() {
        $('.checkifMaded').hide();
        $('.image').show();
        $('.footer').show();
        $('.questions').show();
    });
    questionNumber = 1;
    userAnswer = [];
    goodAnswer = [];
    questionUsed = [];
    backendQuestion = 0;
    FRP.opened = false;
    $.post('http://frp-rijschool/close', JSON.stringify({}));
}

function sendQuestion() {
    $('.questions .title').html('<b>' + questions[backendQuestion].question + '</b>');
    $('.answerA').html(questions[backendQuestion].propositionA);
    $('.answerB').html(questions[backendQuestion].propositionB);
    if (questions[backendQuestion].propositionC) {
        $('#answerC').show()
        $('.answerC').html(questions[backendQuestion].propositionC)
    } else { 
        $('#answerC').hide()
        $('.answerC').html('')
    }

    if (questions[backendQuestion].propositionD) {
        $('#answerD').show() 
        $('.answerD').html(questions[backendQuestion].propositionD)
    } else {
        $('#answerD').hide()
        $('.answerD').html('')
    }

    $('.footer .middle .text').html('VRAAG <b>' + questionNumber + '</b> VAN DE <b>' + questions.length)
}

function nextQuestion() {
    if (questions[backendQuestion+1]) {
        userAnswer.push($('input[name="question"]:checked:enabled', '#questionform').val());
        if (document.getElementById('answer'+questions[backendQuestion].answer).checked) {
            goodAnswer.push(questions[backendQuestion].answer)
        }
        $('input[type="radio" i]').attr('checked', false);
        backendQuestion++;
        questionNumber++;
        sendQuestion();
    } else {
        $.post('https://frp-rijschool/getResults', JSON.stringify(goodAnswer), function(bool) {
            if (bool) {
                $('.image').hide();
                $('.footer').hide();
                $('.questions').hide();
                $('.checkifMaded').html('Je bent <span style="color: green">geslaagd</span> voor je rijexamen, gefeliciteerd! Je kan gelijk beginnen met je praktijk examen, CBR wenst je daarmee veel succes!'); 
                $('.checkifMaded').show(); 
            } else {
                $('.image').hide();
                $('.footer').hide();
                $('.questions').hide();
                $('.checkifMaded').html('Je bent helaas <span style="color: red">gezakt</span> voor je rijexamen. De volgende keer ga je slagen! Probeer het gelijk opnieuw of probeer het later opnieuw. Je kan het CBR examen afsluiten dmv. rechtsboven het pijltje of door de ESC te drukken.'); 
                $('.checkifMaded').show(); 
            }
        })
    }
}

function lastQuestion() {
    if (questionNumber - 1 > 0) {
        questionNumber = questionNumber - 1;
        backendQuestion = backendQuestion - 1;

        $('.questions .title').html('<b>' + questions[backendQuestion].question + '</b>');
        $('.answerA').html(questions[backendQuestion].propositionA);
        $('.answerB').html(questions[backendQuestion].propositionB);
        if (questions[backendQuestion].propositionC) {
            $('#answerC').show()
            $('.answerC').html(questions[backendQuestion].propositionC)
        } else { 
            $('#answerC').hide()
            $('.answerC').html('')
        }
    
        if (questions[backendQuestion].propositionD) {
            $('#answerD').show() 
            $('.answerD').html(questions[backendQuestion].propositionD)
        } else {
            $('#answerD').hide()
            $('.answerD').html('')
        }

        goodAnswer.push(questions[backendQuestion].answer)
        $('.footer .middle .text').html('VRAAG <b>' + questionNumber + '</b> VAN DE <b>'+ questions.length)

        $('input[value="' + userAnswer[backendQuestion] + '"]').attr('checked', true);
    }
}

function closeAll() {
	$(".container").css("display", "none");
}

$(document).ready(function() {
    sendQuestion();
});