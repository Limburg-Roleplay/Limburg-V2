$(() => {
    window.addEventListener('message', function(event) {
        if (event.data.action == "open") {
            togglePayments(event.data.data)
        } 
    });


});

const toggleUI = bool => {
    return bool ? $(".container").fadeIn(200) : $(".container").fadeOut(200)
}


const togglePayments = data => {

    $('#title-price').html(`€${data.price}`)
    $('#title-reason').html(data.reason)

    $("#payments-cards-cash").html(data.cash >= data.price ? `Saldo: € ${data.cash}` : "Betaalmethode niet mogelijk")
    $("#payments-cards-pin").html(data.pin >= data.price ? `Saldo: € ${data.pin}` : "Betaalmethode niet mogelijk") 

    toggleUI(true)
}

const closeUI = () => {
    toggleUI(false)
    $.post('https://frp-payments/close')
}

$("#close").click(closeUI);
   

$(".payment-cards").click(function(){
    let paymentMethod = this.id
    toggleUI(false)
    $.post('https://frp-payments/finishPayment', JSON.stringify({paymentMethod}))
});
   

