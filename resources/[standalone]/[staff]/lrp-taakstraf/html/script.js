window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        document.getElementById('tasksLeft').innerText = event.data.tasksLeft;
        document.getElementById('tasksGiven').innerText = event.data.tasksGiven;
        document.getElementById('reason').innerText = event.data.reason;
        document.getElementById('staffMember').innerText = event.data.staffMember;
        document.getElementById('container').style.display = 'block';
        document.getElementById('taskInfo').style.display = 'block';
        document.getElementById('warning').style.display = 'none';
        document.getElementById('penalty').style.display = 'none';
    } else if (event.data.type === "updateTasks") {
        document.getElementById('tasksLeft').innerText = event.data.tasksLeft;
        document.getElementById('taskInfo').style.display = 'block';
        document.getElementById('warning').style.display = 'none';
        document.getElementById('penalty').style.display = 'none';
    } else if (event.data.type === "warning") {
        document.getElementById('warningMessage').innerText = event.data.message;
        document.getElementById('warning').style.display = 'block';
        document.getElementById('taskInfo').style.display = 'none';
        document.getElementById('penalty').style.display = 'none';
    } else if (event.data.type === "penalty") {
        document.getElementById('penaltyMessage').innerText = event.data.message;
        document.getElementById('penalty').style.display = 'block';
        document.getElementById('taskInfo').style.display = 'none';
        document.getElementById('warning').style.display = 'none';
    } else if (event.data.type === "hide") {
        document.getElementById('container').style.display = 'none';
    }
});
