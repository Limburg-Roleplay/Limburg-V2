var ML = {};

window.addEventListener('message', function(event) {
    if (event.data.type == 'openPlaceholder') {
        ML.openPlaceholder(event.data.text);
    } else if (event.data.type == 'closePlaceholder') {
        ML.closePlaceholder();
    }
});

ML.openPlaceholder = function(text) {
    $('.placeholder').html(text);
    $('.placeholder').fadeIn(250);
}

ML.closePlaceholder = function() {
    $('.placeholder').fadeOut(250, function() {
        $('.placeholder').html('Klik op X om los te laten');
    })
}