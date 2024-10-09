MC = {}
MC.Progressbar = {}
MC.Progressbar.animTimeout = null;

MC.Progressbar.Progress = function(data) { 
    if (data.label) {
        $("#text").show().html('<p>'+data.label+'</p>');
    } else {
        $("#text").hide();
    }

    $(".container").fadeIn(150);
    MC.Progressbar.UpdateCircle("progress-circle-circle", 0);

    const interval = parseInt(data.duration) / 100;
    let percentage = 0;
    let countDown = parseInt(data.duration) / 1000;
    let minAmt = interval / 1000;

    MC.Progressbar.animTimeout = setInterval(() => {
        percentage += 1;
        MC.Progressbar.UpdateCircle("progress-circle-circle", percentage);
        countDown = countDown - minAmt;
        $("#countdown").html(countDown.toFixed(1));
        if (percentage > 100) {
          clearInterval(MC.Progressbar.animTimeout);
          $("#countdown").html("0.0");
          $.post(`https://${GetParentResourceName()}/FinishAction`);
          $(".container").fadeOut(150, () => {
          $("#countdown").html("0.0");
            MC.Progressbar.UpdateCircle("progress-circle-circle", 0);
          });
        }
      }, interval)
};

MC.Progressbar.ProgressCancel = function() {
    clearInterval(MC.Progressbar.animTimeout);
    $("#text").html("<p>Canceled</p>");
    setTimeout(function () {
        $(".container").fadeOut('fast', function() {
            $("#countdown").html("0.0");
            MC.Progressbar.UpdateCircle("progress-circle-circle", 0);
            $.post(`https://${GetParentResourceName()}/CancelAction`, JSON.stringify({
                })
            );
        });
    }, 1000);
};


MC.Progressbar.UpdateCircle = function(foundClass, foundPercentage) {
    let circumference = 35 * 2 * Math.PI;
    let percent = foundPercentage * 100 / 360;
    const offset = circumference - ((-percent * 360) / 100) / 100 * circumference;
  
    $(`.${foundClass}`).attr('stroke-dasharray', `${`${circumference} ${circumference}`}`);
    $(`.${foundClass}`).attr('stroke-dashoffset', `${`${Math.round(-offset)}`}`);
};

$('document').ready(function() {
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'start':
                MC.Progressbar.Progress(event.data);
                break;
            case 'cancel':
                MC.Progressbar.ProgressCancel();
                break;
        }
    });
});