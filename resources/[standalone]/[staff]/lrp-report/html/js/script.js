var LRP = {};

window.addEventListener('message', function(event) {
    if (event.data.type == 'newReport') {
        LRP.createReport(event.data.data.steamName, event.data.data.reportId, event.data.data.msg, event.data.data.playerId, event.data.data.time);
    } else if (event.data.type == 'claimReport') {
        LRP.claimReport(event.data.data.reportId, event.data.data.claimedReport);
    } else if (event.data.type == 'closeReport') {
        LRP.closeReport(event.data.data.reportId);
    } else if (event.data.type == 'seeReportList') {
        LRP.seeReports();
    } else if (event.data.type == 'closeReportList') {
        LRP.hideReports();
    }

    $(document).on('keydown', function(e) {
        switch(e.keyCode) {
            case 112:
                LRP.hideReports();
                break;
        }
        switch(e.key) {
            case "Escape":
            case "":
                LRP.hideReports();
                break;
        }
    });
});

LRP.seeReports = function() {
    $('.reports-westkust').fadeIn(500)
}

LRP.hideReports = function() {
    $.post('https://lrp-report/closeReports')
    $('.reports-westkust').fadeOut(500)
}

LRP.createReport = function(steamName, reportId, msg, playerId, time) {
    var report = document.createElement('div');
    $(report).addClass('report')
        .attr('id', reportId)
        .html(`<div class="name"><i class="fa-solid fa-tag"></i> Steam naam: ${steamName}</div>
        <div class="playerid"><i class="fa-solid fa-map-pin"></i> Speler ID: ${playerId}</div>
        <div class="time"><i class="fa-solid fa-hourglass"></i> Ingediend op: ${time}</div>
        <div class="context"><i class="fa-solid fa-clipboard-user"></i> Report: ${msg}</div>
        <div class="buttons" id="buttons-${reportId}">
            <div class="claimreport blue" onClick="LRP.trytoClaimReport('${reportId}')"><i class="fa-solid fa-user-xmark"></i> TP op deze report</div>
            <div class="claimreport green claimReport-${reportId}"><i class="fa-solid fa-circle-check"></i> Deze report is vrij!</div>
            <div class="claimreport black" onClick="LRP.sureCloseReport('${reportId}')"><i class="fa-solid fa-bomb"></i> Report afsluiten</div>
        </div>`)
        .appendTo($('.reports'))
}

LRP.trytoClaimReport = function(reportId) {
    $.post('https://lrp-report/claimReport', JSON.stringify({reportId: reportId}))
}

LRP.closeReportInstant = function(reportId) {
    $.post('https://lrp-report/closeReportInstant', JSON.stringify({reportId: reportId}))
}

LRP.claimReport = function(reportId, claimedReport) {
    $('.claimReport-' + reportId).removeClass('green')
    $('.claimReport-' + reportId).addClass('red')
    if (!claimedReport) {
        $('.claimReport-' + reportId).html(`<i class="fa-solid fa-circle-xmark"></i> Deze report is bezet!`)
    } else {
        $('.claimReport-' + reportId).attr('onClick', 'LRP.sureCloseReport("' + reportId + '")')
        $('.claimReport-' + reportId).html(`<i class="fa-solid fa-star"></i> Sluit report af.`)
    }
}

LRP.sureCloseReport = function(reportId) {
    $('.claimReport-' + reportId).removeClass('green')
    $('.claimReport-' + reportId).addClass('red')
    $('.claimReport-' + reportId).attr('onClick', 'LRP.closeReportStaff("' + reportId + '")')
    $('.claimReport-' + reportId).html(`<i class="fa-solid fa-question"></i> Weet je zeker dat je deze report wilt afsluiten?`)
}

LRP.closeReportStaff = function(reportId) {
    $.post('https://lrp-report/closeReport', JSON.stringify({reportId: reportId}))
}

LRP.closeReport = function(reportId) {
    $('#' + reportId).remove();
}