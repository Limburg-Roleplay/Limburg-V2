var ML = {};

window.addEventListener('message', function(event) {
    if (event.data.type == 'createInteraction') {
        createInteraction(event.data.information.text, event.data.information.type, event.data.information.id);
    } else if (event.data.type == 'closeInteraction') {
        closeInteraction(event.data.information.id)
    }
});

closeInteraction = function(id) {
    var main = document.getElementById(id);
    $("#"+id).animate({right: '1000px'}, 'slow', function(){
        main.remove();
    });
}

createInteraction = function(subMessage, type, id) {
    var main = document.getElementById("container");
    var interaction = document.createElement("div");

    if (type !== null && typeof (type) === 'object') {
        interaction.style.borderColor = 'rgb(' + type["r"] + ',' + type["g"] + ',' + type["b"] + ')';
        interaction.style.backgroundColor = 'rgb(' + type["r"] + ',' + type["g"] + ',' + type["b"] + ')';
    } else {
        interaction.classList.add(type);
    }

    interaction.classList.add("interaction");
    interaction.setAttribute('id', id);
    interaction.innerText = subMessage;
    interaction.style.right = '1000px';
    interaction.style.display = 'flex';

    main.append(interaction);

    $("#"+id).animate({right: '0px'}, 'slow');
}