window.addEventListener('message', function(event) {
    if (event.data.action === 'showJailTime') {
        const jailTimeText = document.getElementById('jail-time-text');
        const jailTimeBox = document.getElementById('jail-time-box');
        const jailTimeLabel = document.getElementById('jail-time-label');

        jailTimeText.textContent = `${event.data.jailTime}`;
        jailTimeBox.classList.remove('hidden');
        jailTimeLabel.classList.remove('hidden');
    }

    if (event.data.action === 'hideJailTime') {
        const jailTimeBox = document.getElementById('jail-time-box');
        const jailTimeLabel = document.getElementById('jail-time-label');
        jailTimeBox.classList.add('hidden');
        jailTimeLabel.classList.add('hidden');
    }
});
