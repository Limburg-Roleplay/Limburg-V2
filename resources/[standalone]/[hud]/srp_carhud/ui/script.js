$(document).ready(function(){

  window.addEventListener("message", function(event){
    // Show HUD when player enter a vehicle
    if(event.data.showhud == true){
      $('.huds').fadeIn();
      setProgressSpeed(event.data.speed,'.progress-speed');
    }
    if(event.data.showhud == false){
      $('.huds').fadeOut();
    }

    // Fuel
    if(event.data.showfuel == true){
      setProgressFuel(event.data.fuel,'.progress-fuel');
      if( event.data.fuel > 10 && event.data.fuel <= 20){
        $('.fuellight').attr("id", "misha2")
      } else if (event.data.fuel <= 10){
        $('.fuellight').attr("id", "misha")
      } else if (document.getElementById("misha") || document.getElementById("misha2")) {
        $('.fuellight').attr("id", "")
      }
    }

    // Lights states
    if(event.data.seatbelt == true){
      $('.seatbelt').addClass('active');
      $('.seatbelt').removeClass('deactive');
    }
    if(event.data.seatbelt == false){
      $('.seatbelt').removeClass('active');
      $('.seatbelt').addClass('deactive');
    }
    if(event.data.cruise == true){
      $('.hud-cruisecontrol').fadeIn(500)
      $('.cruisecontrol-value').html(event.data.speed)
      $('.cruiseControl svg').css('fill', 'rgb(0, 255, 0)')
      $('.cruiseControl svg').css('opacity', '100%')
    }
    if(event.data.cruise == false){
      $('.hud-cruisecontrol').fadeOut(500)
      $('.cruiseControl svg').css('fill', 'rgb(255, 255, 255)')
      $('.cruiseControl svg').css('opacity', '50%')
    }
    if(event.data.limiter == true){
      $('.hud-cruisecontrol').fadeIn(500)
      $('.cruisecontrol-value').html(event.data.speed)
      $('.cruiseControl svg').css('fill', 'rgb(255, 255, 0)')
      $('.cruiseControl svg').css('opacity', '100%')
    }
    if(event.data.limiter == false){
      $('.hud-cruisecontrol').fadeOut(500)
      $('.cruiseControl svg').css('fill', 'rgb(255, 255, 255)')
      $('.cruiseControl svg').css('opacity', '50%')
    }
    if(event.data.feuPosition == true){
      $('.feu-position').addClass('active');
    }
    if(event.data.feuPosition == false){
      $('.feu-position').removeClass('active');
    }
    if(event.data.feuRoute == true){
      $('.feu-route').addClass('active');
    }
    if(event.data.feuRoute == false){
      $('.feu-route').removeClass('active');
    }
    if(event.data.clignotantGauche == true){
      $('.clignotant-gauche').addClass('active');
    }
    if(event.data.clignotantGauche == false){
      $('.clignotant-gauche').removeClass('active');
    }
    if(event.data.clignotantDroite == true){
      $('.clignotant-droite').addClass('active');
    }
    if(event.data.clignotantDroite == false){
      $('.clignotant-droite').removeClass('active');
    }
    // if(event.data.hazerds == true){
    //   $('.blinker-hazerds').removeClass('active');
    // }
    // if(event.data.hazerds == false){
    //   $('.blinker-hazerds').removeClass('active');
    // }
    if(event.data.seatbelt == true){
      $('.seatbelt').addClass('active');
    }
    if(event.data.seatbelt == false){
      $('.seatbelt').removeClass('active');
    }
    if(event.data.handbrake == true){
      $('.handbrake').addClass('active');
    }
    if(event.data.handbrake == false){
      $('.handbrake').removeClass('active');
    }
    if(event.data.lock == true){
      $('.lock').addClass('active');
    }
    if(event.data.lock == false){
      $('.lock').removeClass('active');
    }
    if(event.data.engineHealth > 800){
      $('.engineLight').removeClass('active');
      $('.engineLight').removeClass('full');
      $('.engineLight').removeClass('blinking');
    }
  if(event.data.engineHealth < 800 && event.data.engineHealth > 600){
      $('.engineLight').addClass('active');
  }
  if(event.data.engineHealth < 600 && event.data.engineHealth > 250){
      $('.engineLight').addClass('active');
      $('.engineLight').addClass('full');
  }
  if(event.data.engineHealth < 250){
      $('.engineLight').removeClass('active');
      $('.engineLight').removeClass('full');
      $('.engineLight').addClass('blinking');
  }

  if(event.engineHealth < 800 && event.engineHealth > 600){
    $('.engineLight').addClass('active');
}
if(event.engineHealth < 600 && event.engineHealth > 250){
    $('.engineLight').addClass('active');
    $('.engineLight').addClass('full');
}
if(event.engineHealth < 250){
    $('.engineLight').removeClass('active');
    $('.engineLight').removeClass('full');
    $('.engineLight').addClass('blinking');
}


  });

  // Functions
  // Fuel
  function setProgressFuel(percent, element){
    if (percent > 100) {
      percent = 100
    }
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(Math.round(percent));
  }

  // Speed
  function setProgressSpeed(value, element){
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');
    var percent = value*100/400;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(value);
  }

  // setProgress(input.value,element);
  // setProgressFuel(85,'.progress-fuel');
  // setProgressSpeed(124,'.progress-speed');

});
