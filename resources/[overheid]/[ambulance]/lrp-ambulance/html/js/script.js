var lrp = {};

lrp.startedConversation = false;
lrp.ped = null;

window.addEventListener('message', function(event) {
    if (event.data.type == 'showMed') {
        lrp.startConversation(event.data.playerid, event.data.heartbeat, event.data.bleed, event.data.area, event.data.bleeding, event.data.weapon)
    } else if (event.data.type == 'closeMed') {
        lrp.closeInteraction()
    }


    $(document).keyup(function(e) {
        if (e.key === "Escape" && lrp.startedConversation) {
            lrp.closeInteraction();
        }
    });
});

lrp.closeInteraction = function() {
    $('.conversation').animate({right: '-50vh'}, 'slow', function() {})
    lrp.startedConversation = false;
    $.post('https://lrp-daily/cancelDaily', JSON.stringify({ped: lrp.ped}))
}


lrp.startConversation = function(playerid, heartbeat, bleed, area, bleeding, weapon) {
    $('.conversation').show();
    $(".title").html('<i class="fa-solid fa-person-rays"></i> ID ' + playerid +':');
    $("#hartslag").html('Hartslag: ' + heartbeat + " BPM");
    $("#bloed").html('Bloed: ' + bleed + "%");
    $("#gebied").html('Geraakt gebied: ' + area);
    $("#bloeding").html('Bloeding: ' + bleeding);
    $("#wapen").html('Wapen: ' + weapon);
    $("div").animate({right: '1.25vh'}, 'slow');
    lrp.startedConversation = true;
}