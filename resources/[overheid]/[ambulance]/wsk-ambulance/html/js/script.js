var wsk = {};

wsk.startedConversation = false;
wsk.ped = null;

window.addEventListener('message', function(event) {
    if (event.data.type == 'showMed') {
        wsk.startConversation(event.data.playerid, event.data.heartbeat, event.data.bleed, event.data.area, event.data.bleeding, event.data.weapon)
    } else if (event.data.type == 'closeMed') {
        wsk.closeInteraction()
    }


    $(document).keyup(function(e) {
        if (e.key === "Escape" && wsk.startedConversation) {
            wsk.closeInteraction();
        }
    });
});

wsk.closeInteraction = function() {
    $('.conversation').animate({right: '-50vh'}, 'slow', function() {})
    wsk.startedConversation = false;
    $.post('https://wsk-daily/cancelDaily', JSON.stringify({ped: wsk.ped}))
}


wsk.startConversation = function(playerid, heartbeat, bleed, area, bleeding, weapon) {
    $('.conversation').show();
    $(".title").html('<i class="fa-solid fa-person-rays"></i> ID ' + playerid +':');
    $("#hartslag").html('Hartslag: ' + heartbeat + " BPM");
    $("#bloed").html('Bloed: ' + bleed + "%");
    $("#gebied").html('Geraakt gebied: ' + area);
    $("#bloeding").html('Bloeding: ' + bleeding);
    $("#wapen").html('Wapen: ' + weapon);
    $("div").animate({right: '1.25vh'}, 'slow');
    wsk.startedConversation = true;
}