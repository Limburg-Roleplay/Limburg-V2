window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.action === "openUI") {
        document.getElementById('blackmarket').style.display = 'block';
        const weaponList = document.getElementById('weapon-list');
        weaponList.innerHTML = '';

        data.weapons.forEach(function (weapon) {
            const weaponDiv = document.createElement('div');
            weaponDiv.classList.add('weapon');

            weaponDiv.innerHTML = `
            <h3>${weapon.label}</h3>
            <img src="${weapon.image}" alt="${weapon.label}" class="weapon-img">
            <p class="price">Prijs: €${weapon.price}</p>
            <button class="buy-btn" data-weapon="${weapon.name}" data-price="${weapon.price}">Kopen</button>
        `;

            weaponList.appendChild(weaponDiv);
        });
    }

    if (data.action === "closeUI") {
        document.getElementById('blackmarket').style.display = 'none';
    }
});

document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            }
        });
    }
});

document.addEventListener('click', function (event) {
    if (event.target.classList.contains('buy-btn')) {
        const weapon = event.target.getAttribute('data-weapon');
        const price = event.target.getAttribute('data-price');

        fetch(`https://${GetParentResourceName()}/buyWeapon`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ weapon, price })
        });
    }
});
