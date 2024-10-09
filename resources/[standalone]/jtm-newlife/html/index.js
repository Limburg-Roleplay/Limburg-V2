$(document).ready(function() {
    window.addEventListener('message', function(event) {
        switch(event.data.type) {
            // Testdrive
            case "testdriveTimer":
                if(event.data.event) {
                    $('.testdrive').css({'display':'block'});
                    $('.testdrive').animate({'right':'-2vh'});
                } else {
                    $('.testdrive').animate({'right':'-15vh'});
                    setTimeout(function(){
                        $('.testdrive').css({'display':'none'});
                        $('.testdrive').find('.minutes').html('2');
                        $('.testdrive').find('.seconds').html('00');
                    }, 750);
                }
                break;

            case "testdriveTick":
                let minutes = parseInt($('.testdrive').find('.minutes').text(), 10);
                let seconds = parseInt($('.testdrive').find('.seconds').text(), 10);

                if (minutes > 0 || seconds > 0) {
                    seconds--;

                    if (seconds < 0) {
                        minutes--;
                        seconds = 59;
                    }

                    if (minutes >= 0) {
                        $('.testdrive').find('.minutes').text(minutes);
                        $('.testdrive').find('.seconds').text(seconds < 10 ? "0" + seconds : seconds);
                    } else {
                        $('.testdrive').css({'display':'none'});
                    }
                } else {
                    $('.testdrive').css({'display':'none'});
                }
                break;
        }
    });
});
