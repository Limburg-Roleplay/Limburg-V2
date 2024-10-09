var WSK = {};

window.addEventListener('message', function(event) {
    if (event.data.type == 'newReport') {
        WSK.createReport(event.data.data.steamName, event.data.data.reportId, event.data.data.msg, event.data.data.playerId, event.data.data.time);
    } else if (event.data.type == 'claimReport') {
        WSK.claimReport(event.data.data.reportId, event.data.data.claimedReport);
    } else if (event.data.type == 'closeReport') {
        WSK.closeReport(event.data.data.reportId);
    } else if (event.data.type == 'seeReportList') {
        WSK.seeReports();
    } else if (event.data.type == 'closeReportList') {
        WSK.hideReports();
    }

    $(document).on('keydown', function(e) {
        switch(e.keyCode) {
            case 112:
                WSK.hideReports();
                break;
        }
        switch(e.key) {
            case "Escape":
            case "":
                WSK.hideReports();
                break;
        }
    });
});

WSK.seeReports = function() {
    $('.reports-westkust').fadeIn(500)
}

WSK.hideReports = function() {
    $.post('https://wsk-report/closeReports')
    $('.reports-westkust').fadeOut(500)
}

WSK.createReport = function(steamName, reportId, msg, playerId, time) {
    var report = document.createElement('div');
    $(report).addClass('report')
        .attr('id', reportId)
        .html(`<div class="name"><i class="fa-solid fa-tag"></i> Steam naam: ${steamName}</div>
        <div class="playerid"><i class="fa-solid fa-map-pin"></i> Speler ID: ${playerId}</div>
        <div class="time"><i class="fa-solid fa-hourglass"></i> Ingediend op: ${time}</div>
        <div class="context"><i class="fa-solid fa-clipboard-user"></i> Report: ${msg}</div>
        <div class="buttons" id="buttons-${reportId}">
            <div class="claimreport blue" onClick="WSK.trytoClaimReport('${reportId}')"><i class="fa-solid fa-user-xmark"></i> TP op deze report</div>
            <div class="claimreport green claimReport-${reportId}"><i class="fa-solid fa-circle-check"></i> Deze report is vrij!</div>
            <div class="claimreport black" onClick="WSK.sureCloseReport('${reportId}')"><i class="fa-solid fa-bomb"></i> Report afsluiten</div>
        </div>`)
        .appendTo($('.reports'))
}

WSK.trytoClaimReport = function(reportId) {
    $.post('https://wsk-report/claimReport', JSON.stringify({reportId: reportId}))
}

WSK.closeReportInstant = function(reportId) {
    $.post('https://wsk-report/closeReportInstant', JSON.stringify({reportId: reportId}))
}

WSK.claimReport = function(reportId, claimedReport) {
    $('.claimReport-' + reportId).removeClass('green')
    $('.claimReport-' + reportId).addClass('red')
    if (!claimedReport) {
        $('.claimReport-' + reportId).html(`<i class="fa-solid fa-circle-xmark"></i> Deze report is bezet!`)
    } else {
        $('.claimReport-' + reportId).attr('onClick', 'WSK.sureCloseReport("' + reportId + '")')
        $('.claimReport-' + reportId).html(`<i class="fa-solid fa-star"></i> Sluit report af.`)
    }
}

WSK.sureCloseReport = function(reportId) {
    $('.claimReport-' + reportId).removeClass('green')
    $('.claimReport-' + reportId).addClass('red')
    $('.claimReport-' + reportId).attr('onClick', 'WSK.closeReportStaff("' + reportId + '")')
    $('.claimReport-' + reportId).html(`<i class="fa-solid fa-question"></i> Weet je zeker dat je deze report wilt afsluiten?`)
}

WSK.closeReportStaff = function(reportId) {
    $.post('https://wsk-report/closeReport', JSON.stringify({reportId: reportId}))
}

WSK.closeReport = function(reportId) {
    $('#' + reportId).remove();
}