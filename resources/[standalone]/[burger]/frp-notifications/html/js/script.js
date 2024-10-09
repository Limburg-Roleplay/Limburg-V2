var ML = {};

ML.totalnotifications = 0;

window.addEventListener('message', function(event) {
    if (event.data.type == 'createNotification') {
        createNotification(event.data.information.text, event.data.information.type, event.data.information.time);
    }
});

createNotification = function(subMessage, type, time) {
    var notification = document.createElement("div");
    const notificationnumber = ML.totalnotifications + 1;
	
    notification.classList.add("notification");
    notification.classList.add(type);

    notification.id         = notificationnumber;
    ML.totalnotifications   = notificationnumber;

    var message = document.createElement("div");
    message.innerHTML = '<div class="notification-text-container"><div class="notification-text">'+ subMessage +'</div></div>';

    notification.append(message);

    var main = document.getElementById("container");
    main.append(notification);

    notification.style.left = '-100%';

    $("#"+notification.id+"").animate({'left':'0.5%'}, "slow", function(){
        setTimeout(function() {
            $("#"+notification.id+"").animate({'left': '-100%'}, function(){
                notification.parentElement.removeChild(notification)
            });
        }, time)
    });
}