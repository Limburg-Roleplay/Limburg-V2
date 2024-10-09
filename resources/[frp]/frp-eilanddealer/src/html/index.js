Exios = {}
Exios.Vehicles = {}
Exios.CurrentPage = 1
Exios.PageRow = {
    1: "home",
    2: "brand",
    3: "vehicle",
}
$('.home-page-container').html(' ');
$(`.home-page`).css({"display":"block"});
Exios.choosenColor = 'black'
Exios.CurrentData = {'vehicleId': false, 'currentClass': false}

$(document).ready(function(e){
    window.addEventListener('message', function(event){
        var action = event.data.action;
        switch(action) {
            case "openDealer":


                // Reset containers
                $('.home-page-container').html(' ');
                $(`.home-page`).css({"display":"block"});
                if(Exios.PageRow[Exios.CurrentPage] !== "home"){$(`.${Exios.PageRow[Exios.CurrentPage]}-page`).css({"display":"none"});}

                // Default parameters
                Exios.CurrentPage = 1
                Exios.choosenColor = 'black'
                Exios.Vehicles = event.data.vehicles

                Exios.openDealer(event.data);
                break;
            case "closeDealer":
                Exios.Close(true);
                break;

            // Testdrive
            case "testdriveTimer":
                if(event.data.event){
                    $('.testdrive').css({'display':'block'});
                    $('.testdrive').animate({'right':'-2vh'});
                } else {
                    $('.testdrive').animate({'right':'-15vh'});
                    setTimeout(function(){
                        $('.testdrive').css({'display':'none'});
                        $('.testdrive').find('.minutes').html('2');
                        $('.testdrive').find('.seconds').html('00');
                    }, 750)
                }
                break;
            case "testdriveTick":
                let minutes = $('.testdrive').find('.minutes').text();
                let seconds = $('.testdrive').find('.seconds').text();
                if(minutes !== 0 && seconds !== 0){
                    newSeconds = seconds - 1;
                    if(newSeconds !== -1){
                        if (newSeconds <= "9") {
                            $('.testdrive').find('.seconds').text("0" + newSeconds);
                        } else {
                            $('.testdrive').find('.seconds').text(newSeconds);
                        }
                    } else {
                        newMinutes = minutes - 1;
                        $('.testdrive').find('.minutes').text(newMinutes);
                        $('.testdrive').find('.seconds').text('59');
                    }
                } else {
                    $('.testdrive').css({'display':'none'});
                }
                break;
        }
    });
});

Exios.openDealer = function(data){
    let vehicles = data.vehicles;
    $.each(vehicles, function(k, v){
        let brandLower = k.toLowerCase().replace(/ /g,"_");
        $('.home-page-container').append(`<div class="home-page-container-option" data-brand="${k}"><img src="merken/${brandLower}.png" class="home-page-container-option-logo"><div class="home-page-container-option-label">${k}</div></div>`)
    });

    $('.cardealer').css({"display":"block"})
    $('.cardealer').animate({'top':'0'})
}

// Change color
$(document).on('click', '.vehicle-page-defaultColors-color', function(event){
    let newColor = $(this).data('color')
    
    if(Exios.choosenColor !== newColor){
        $(`[data-color="${Exios.choosenColor}"]`).removeClass('vehicle-page-defaultColors-color-active')
        $(`[data-color="${newColor}"]`).addClass('vehicle-page-defaultColors-color-active')

        let main = $(`[data-image="main"]`).attr('src')
        let side = $(`[data-image="side"]`).attr('src')
        let back = $(`[data-image="back"]`).attr('src')
        let front = $(`[data-image="front"]`).attr('src')

        $(`[data-image="main"]`).attr('src', main.replace(Exios.choosenColor, newColor));
        $(`[data-image="side"]`).attr('src', side.replace(Exios.choosenColor, newColor));
        $(`[data-image="back"]`).attr('src', back.replace(Exios.choosenColor, newColor));
        $(`[data-image="front"]`).attr('src', front.replace(Exios.choosenColor, newColor));

        Exios.choosenColor = newColor
    }
});

// Open brandpage
$(document).on('click', '.home-page-container-option', function(data){
    $('.brand-page-container').html(' ');
    let brand = $(this).data('brand')
    let brandLower = null
    if (brand === 'Range Rover') {
        brandLower = 'Range'
    } else if (brand === 'Alfa Romeo') {
        brandLower = 'Alfa'
    } else {
        brandLower = brand.toLowerCase().replace(/ /g,"_");
    }
    // Setup banner
    $('.brand-page-banner').css({'background': 'url("banners/'+ brandLower +'.png")', 'background-position': 'center', 'background-size': '100%'})
    // Setup vehicles
    $.each(Exios.Vehicles[brand], function(k, v){
        let button = false;
        if(v.voorraad !== 0){
            button = `<div class="brand-page-option-readmore" data-brand="${brand}" data-vehicle="${k}">Meer informatie <i class="fas fa-arrow-right"></i></div>`
        } else {
            button = `<div class="brand-page-option-readmoreDisabled"">Geen voorraad</div>`
        }
        $('.brand-page-container').append(`
            <div class="brand-page-option">
                <img src="voertuigen/${brand}_${v.model}_1_black.png" class="brand-page-option-img">
                <div class="brand-page-option-label">${v.label}</div>
                <div class="brand-page-option-price">€${v.price}</div>
                <div class="brand-page-option-stock">Voorraad: <b>${v.voorraad}</b></div>
                <div class="brand-page-option-message">Direct leverbaar. Prijs incl. BTW.</div>
                <div class="brand-page-option-message">Prijs incl. BTW.</div>
                ${button}
            </div>
        `)
    })

    // Technical switch, not visual
    $(`.${Exios.PageRow[Exios.CurrentPage]}-page`).css({'display':"none"})
    $(`.${Exios.PageRow[(Exios.CurrentPage + 1)]}-page`).css({'display':"block"})
    Exios.CurrentPage = Exios.CurrentPage + 1; 
});

// Creating productpage
$(document).on('click', '.brand-page-option-readmore', function(data){
    let merk = $(this).data('brand');
    let vehicle = $(this).data('vehicle');

    let vehicleVal = Exios.Vehicles[merk][vehicle]

    Exios.CurrentData.vehicleId = vehicle
    Exios.CurrentData.currentClass = merk

    // Vehicle header
    $('.vehicle-page-merk-img').attr('src', `merken/${merk.toLowerCase().replace(/ /g,"_")}.png`)
    $('.vehicle-page-title').html(vehicleVal.label)
    $('.vehicle-page-merk').html(merk)
    $('#vehicle-page-price').html(vehicleVal.price)

    console.log(merk);
    console.log(vehicleVal.model);
    console.log(Exios.choosenColor);

    // Default black images
    $(`[data-image="main"]`).attr('src', `voertuigen/${merk}_${vehicleVal.model}_1_${Exios.choosenColor}.png`)
    $(`[data-image="side"]`).attr('src', `voertuigen/${merk}_${vehicleVal.model}_2_${Exios.choosenColor}.png`)
    $(`[data-image="back"]`).attr('src', `voertuigen/${merk}_${vehicleVal.model}_3_${Exios.choosenColor}.png`)
    $(`[data-image="front"]`).attr('src', `voertuigen/${merk}_${vehicleVal.model}_4_${Exios.choosenColor}.png`)

    // Update voorraad
    if(vehicleVal.voorraad == 0){$('.vehicle-page-voorraad-information').html(`Momenteel <span style="color:red;">geen</span> voorraad!`);} else {$('.vehicle-page-voorraad-information').html(`Momenteel ${vehicleVal.voorraad} in voorraad.`);}

    // Vehicle Information
    $(`[data-setting="seats"]`).html(vehicleVal.vehicleConfig.seats)
    $(`[data-setting="pks"]`).html(vehicleVal.vehicleConfig.horsePower)
    $(`[data-setting="topspeed"]`).html(vehicleVal.vehicleConfig.maxSpeed)
    $(`[data-setting="trunkspace"]`).html(vehicleVal.vehicleConfig.trunkSpace)

    // Show new page
    $(`.${Exios.PageRow[Exios.CurrentPage]}-page`).css({'display':"none"})
    $(`.${Exios.PageRow[(Exios.CurrentPage + 1)]}-page`).css({'display':"block"})
    Exios.CurrentPage = Exios.CurrentPage + 1;
});

$(document).on('click', '.vehicle-page-actions-action', function(data){
    let action = $(this).data('action')
    if(action == "testrit"){
        $.post(`https://${GetParentResourceName()}/testDriveVehicle`, JSON.stringify({
            vehicleData: Exios.Vehicles[Exios.CurrentData.currentClass][Exios.CurrentData.vehicleId]
        }))
    } else {
        $.post(`https://${GetParentResourceName()}/buyVehicle`, JSON.stringify({
            colour: Exios.choosenColor,
            vehicleData: {
                class: Exios.CurrentData.currentClass,
                model: Exios.CurrentData.vehicleId
            }
        }))
    }
});

// Change image to big
$(document).on('click', '.vehicle-page-img-detail', function(data){
    let view = $(this).data('image');
    let detailImage = $(`[data-image="${view}"]`).attr('src')
    let bigImage = $(`[data-image="main"]`).attr('src')

    $(`[data-image="main"]`).attr('src', detailImage)
    $(`[data-image="${view}"]`).attr('src', bigImage)
});

// Close function runnen
$(document).on('click', '[data-action="close"]', function(data){
    Exios.Close();
});

// Close function himself
Exios.Close = function(fullClose){
    Exios.choosenColor = 'black';
    if(Exios.CurrentPage == 1 || fullClose){
        $('.cardealer').animate({'top':'-180vh'})
        setTimeout(function(){
            $('.cardealer').css({"display":"none"})
            $.post(`https://${GetParentResourceName()}/closeDealer`, JSON.stringify({}))
        }, 400)
    } else {
        $(`.${Exios.PageRow[Exios.CurrentPage]}-page`).css({'display':'none'})
        $(`.${Exios.PageRow[Exios.CurrentPage - 1]}-page`).css({'display':'block'})
        Exios.CurrentPage = Exios.CurrentPage - 1

        Exios.CurrentData.vehicleId = false
        Exios.CurrentData.currentClass = false
    }
}