var FRP = {};

FRP.openedStats = false;

window.addEventListener('message', function(event) {
     if (event.data.type == 'openPlaceholder') {
        FRP.openPlaceholder(event.data.text);
    } else if (event.data.type == 'closePlaceholder') {
        FRP.closePlaceholder();
    } else if (event.data.type == 'updatePlaceholder') {
        FRP.updatePlaceholder(event.data.text)
    }
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            FRP.closeGymSubscription()
            break;
    }
});

FRP.openPlaceholder = function(text) {
    $('.placeholder').html(text);
    $('.placeholder').fadeIn(250);
}

FRP.updatePlaceholder = function(text) {
    $('.placeholder').html(text);
}

FRP.closePlaceholder = function() {
    $('.placeholder').fadeOut(250, function() {
        $('.placeholder').html('Future Roleplay');
    })
}


var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

function round(value, precision) {
  if (Number.isInteger(precision)) {
    var shift = Math.pow(10, precision);
    return Math.round(value * shift) / shift;
  } else {
    return Math.round(value);
  }
}

$(function () {
  window.addEventListener('message', function (event) {
    if (event.data.type === "enableui") {
      document.body.style.display = event.data.enable ? "block" : "none";
    }
    if (event.data.type === "updateSkills" || event.data.type === "sendPlayerSkills") {
      console.log('Skill update event received with data:', event.data.skills); // Log the data received
      updateSkillBars(event.data.skills);
    }
  });

  function fetchPlayerSkills() {
    fetch(`https://${GetParentResourceName()}/requestPlayerSkills`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: JSON.stringify({})
    }).then(resp => resp.json()).then(resp => {
      console.log('Response received:', JSON.stringify(resp)); // Log the entire response
      if (resp.status === 'ok') {
        console.log('Player skills request successful');
      } else {
        console.error('Failed to request player skills', resp.error);
      }
    }).catch(error => {
      console.error('Error fetching player skills:', error);
    });
  }

  function updateSkillBars(skills) {
    var stamina_elem = document.getElementById("staminaBar");
    var stamina_elem_info = document.getElementById("staminaInfo");
    var strength_elem = document.getElementById("strengthBar");
    var strength_elem_info = document.getElementById("strengthInfo");
    var shooting_elem = document.getElementById("shootingBar");
    var shooting_elem_info = document.getElementById("shootingInfo");
    var driving_elem = document.getElementById("drivingBar");
    var driving_elem_info = document.getElementById("drivingInfo");
    var flying_elem = document.getElementById("flyingBar");
    var flying_elem_info = document.getElementById("flyingInfo");
    var drugs_elem = document.getElementById("drugsBar");
    var drugs_elem_info = document.getElementById("drugsInfo");

    console.log('Updating skill bars with:', skills); // Log the skills being used to update bars

    // Initialize progress bars with database values
    initializeProgressBar(stamina_elem, stamina_elem_info, skills.stamina);
    initializeProgressBar(strength_elem, strength_elem_info, skills.strength);
    initializeProgressBar(shooting_elem, shooting_elem_info, skills.shooting);
    initializeProgressBar(driving_elem, driving_elem_info, skills.driving);
    initializeProgressBar(flying_elem, flying_elem_info, skills.flying);
    initializeProgressBar(drugs_elem, drugs_elem_info, skills.drugs);

    // Update progress bars to target values
    updateProgressBar(stamina_elem, stamina_elem_info, skills.stamina);
    updateProgressBar(strength_elem, strength_elem_info, skills.strength);
    updateProgressBar(shooting_elem, shooting_elem_info, skills.shooting);
    updateProgressBar(driving_elem, driving_elem_info, skills.driving);
    updateProgressBar(flying_elem, flying_elem_info, skills.flying);
    updateProgressBar(drugs_elem, drugs_elem_info, skills.drugs);
  }

  function initializeProgressBar(elem, elem_info, initialValue) {
    elem.style.width = initialValue + '%';
    elem_info.innerHTML = round(initialValue, 2) + '%';
  }

  function updateProgressBar(elem, elem_info, targetValue) {
    var width = parseFloat(elem.style.width) || 0; // Get the current width
    function frame() {
      if (width >= targetValue) {
        elem_info.innerHTML = round(targetValue, 2) + '%';
      } else {
        width += 0.1; // Adjust the increment value for smoother animation
        elem.style.width = width + '%';
        elem_info.innerHTML = round(width, 2) + '%';
        requestAnimationFrame(frame);
      }
    }
    requestAnimationFrame(frame);
  }

  // Request player skills from the server when the script is loaded
  fetchPlayerSkills();
});
