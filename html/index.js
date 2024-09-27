let isMenuVisible = false;

// Show the note UI
RegisterCommand('shownoteui', () => {
    isMenuVisible = !isMenuVisible;
    toggleNoteUI(isMenuVisible);
}, false);

// Function to toggle the display of the note-taking menu
function toggleNoteUI(show) {
    const noteMenu = document.getElementById('noteMenu');
    if (show) {
        noteMenu.style.display = 'block'; // Show the menu
    } else {
        noteMenu.style.display = 'none'; // Hide the menu
    }
}

// Event listener to send the note and player coords to the server
document.getElementById('submitBtn').addEventListener('click', () => {
    const note = document.getElementById('noteInput').value.trim();
    
    if (note.length > 5) {
        // Get player coordinates
        const playerPed = PlayerPedId();
        const playerCoords = GetEntityCoords(playerPed);
        
        // Send note and coordinates to the server
        emitNet('saveNoteWithCoords', note, playerCoords);
        toggleNoteUI(false); // Hide the UI after submission
    } else {
        alert('Please enter a note longer than 5 characters.');
    }
});

// Event listener to close the menu with ESC
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && isMenuVisible) {
        toggleNoteUI(false); // Close the menu on Esc
        isMenuVisible = false;
    }
});
