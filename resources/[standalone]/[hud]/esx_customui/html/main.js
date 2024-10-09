var started = false;
var rgbStart = [139,195,74]
var rgbEnd = [183,28,28]
var usingDupe = false
var usingDupe2 = false

const formatter = new Intl.NumberFormat('nl-NL', {
	style: 'currency',
	currency: 'EUR',
	maximumFractionDigits: 0, 
	minimumFractionDigits: 0,
});

$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue"){
			if (event.data.key == "job2"){
				if (event.data.icon.includes("unemployed2")){
					hideJob2()
				}else{
					showJob2()
				}
			}
			setValue(event.data.key, event.data.value, event.data.icon)

		}else if (event.data.action == "updateStatus"){
			updateStatus(event.data.status);
		}else if (event.data.action == "setTalking"){
			setTalking(event.data.value)
		}else if (event.data.action == "setProximity"){
			setProximity(event.data.value)
		}else if (event.data.action == "toggle"){
			if (event.data.show){
				$('#ui').fadeIn();
			} else{
				$('#ui').fadeOut();
			}
		} else if (event.data.action == "toggleCar"){
			if (event.data.show){
				//$('.carStats').show();
			} else{
				//$('.carStats').hide();
			}
		}else if (event.data.action == "updateCarStatus"){
			updateCarStatus(event.data.status)
		/*}else if (event.data.action == "updateWeight"){
			updateWeight(event.data.weight)*/
		}
		else if (event.data.action == "startUI") {
			if (started === false) {
				setTimeout(() => {
					$('#ui').fadeIn();
					started = true;
				}, 1000);
			}
		}
	});

});

function updateWeight(weight){


	var bgcolor = colourGradient(weight/100, rgbEnd, rgbStart)
	$('#weight .bg').css('height', weight+'%')
	$('#weight .bg').css('background-color', 'rgb(' + bgcolor[0] +','+ bgcolor[1] +','+ bgcolor[2] +')')
}

function updateCarStatus(status){
	var gas = status[0]
	$('#gas .bg').css('height', gas.percent+'%')
	var bgcolor = colourGradient(gas.percent/100, rgbStart, rgbEnd)
	//var bgcolor = colourGradient(0.1, rgbStart, rgbEnd)
	//$('#gas .bg').css('height', '10%')
	$('#gas .bg').css('background-color', 'rgb(' + bgcolor[0] +','+ bgcolor[1] +','+ bgcolor[2] +')')
}

async function setValue(key, value, jobName){
	if (key === "money" || key === "bankmoney" || key === "dirtymoney") {
		$('#'+key+' span').html(formatter.format(value))
		return
	}

	if (key == "job2" && value.includes("Werkloos")) {
		await new Promise(r => setTimeout(r, 1000));
	}

	if (started) {
		if (key == "job" || key == "job2") {
			await doJobSlide(key, jobName)
		}
	} else {
		if (key == "job") {
			if (jobName) {
				setJobIcon(jobName)
			}
		} else {
			if (jobName) {
				setJob2Icon(jobName)
			}
		}
	}


	if (key == "job" || key == "job2") {
		setTimeout(() => {
			$('#'+key+' .duplicate-job').html(value)
			$('#'+key+' .normal-job').html(value)
		}, 200);
	} else {
		$('#'+key+' span').html(value)
	}
}

async function doJobSlide(key, jobName) {
	let check = null

	if (key == "job") {
		check = usingDupe
	} else {
		check = usingDupe2
	}
		

	if (!check) {
		$(`#${key} .normal-job`).animate({top: '50%'},{ duration: 450})
	} else {
		$(`#${key} .duplicate-job`).animate({top: '50%'},{ duration: 450})
	}
	
	await new Promise(r => setTimeout(r, 400));

	if (!check) {
		$(`#${key} .normal-job`).hide()
		$(`#${key} .normal-job`).css("top", "-100%")

		$(`#${key} .duplicate-job`).show()
		$(`#${key} .duplicate-job`).css("top", "-100%")
		$(`#${key} .duplicate-job`).animate({top: '-30%'},{ duration: 450})
	} else {
		$(`#${key} .duplicate-job`).hide()
		$(`#${key} .duplicate-job`).css("top", "-100%")

		$(`#${key} .normal-job`).show()
		$(`#${key} .normal-job`).css("top", "-100%")
		$(`#${key} .normal-job`).animate({top: '-30%'},{ duration: 450})
	}

	if (key == "job") {
		setJobIcon(jobName)
		usingDupe = !usingDupe
	} else {
		setJob2Icon(jobName)
		usingDupe2 = !usingDupe2
	}
}

function setValueSociety(key, value){
	var element = $('#'+key+' span');
	if (element.style.display === "none") {
		element.style.display = "block";
	  }
	  element.html(value);

}

function setJobIcon(value){
	$('#job img').attr('src', 'img/jobs/'+value+'.png')
}

function setJob2Icon(value){
	$('#job2 img').attr('src', 'img/jobs/'+value+'.png')
}

function showJob2(){
	$('#job2').fadeIn(750)
	$('#logo').fadeIn(750)
}

function hideJob2(){
	$('#job2').fadeOut(750)
	$('#logo').fadeOut(750)
}

function updateStatus(status){
	var hunger = status[1] || 0;
	var thirst = status[2] || 0;
	var drunk = status[0] || 0;
	status.forEach(element => {
		if(element.name === "drunk") {
			drunk = element;
		}
		else if (element.name === "thirst") {
			thirst = element;
		} else if (element.name === "hunger") {
			hunger = element;
		}
	});
	$('#hunger .bg').css('height', hunger.percent+'%')
	$('#water .bg').css('height', thirst.percent+'%')
	$('#drunk .bg').css('height', drunk.percent+'%');
	if (drunk.percent > 5){
		$('#drunk').show();
	}else{
		$('#drunk').hide();
	}

}

function setProximity(value){
	var color;
	var speaker;
	if (value == "whisper"){
		color = "#FFEB3B";
		speaker = 1;
	}else if (value == "normal"){
		color = "#039BE5";
		speaker = 2;
    }else if (value == "loud") {
        color = "#81C784";
		speaker = 3;
    }
    else if (value == "shout"){
		color = "#e53935";
		speaker = 3;
	}
	$('#voice .bg').css('background-color', color);
	$('#voice img').attr('src', 'img/speaker'+speaker+'.png');
}	

function setTalking(value){
	if (value){
		//#64B5F6
		$('#voice').css('border', '3px solid #03A9F4')
	}else{
		//#81C784
		$('#voice').css('border', 'none')
	}
}

//API Shit
function colourGradient(p, rgb_beginning, rgb_end){
    var w = p * 2 - 1;

    var w1 = (w + 1) / 2.0;
    var w2 = 1 - w1;

    var rgb = [parseInt(rgb_beginning[0] * w1 + rgb_end[0] * w2),
        parseInt(rgb_beginning[1] * w1 + rgb_end[1] * w2),
            parseInt(rgb_beginning[2] * w1 + rgb_end[2] * w2)];
    return rgb;
};