const grid = document.getElementById("puzzleGrid");
const startButton = document.getElementById("startButton");
const moveCounter = document.getElementById("moveCounter");
const successMessage = document.getElementById("successMessage");
const imageUpload = document.getElementById("imageUpload");

let tiles = [];
let moves = 0;

function createPuzzleGrid(imageSrc) {
    grid.innerHTML = "";
    tiles = [];
    const gridSize = 3; // Default to 3x3 for now

    for (let i = 0; i < gridSize * gridSize; i++) {
        const tile = document.createElement("div");
        tile.classList.add("puzzle-piece");
        tile.style.backgroundImage = `url(${imageSrc})`;
        tile.style.backgroundSize = "300px 300px";
        tile.style.backgroundPosition = `-${(i % gridSize) * 100}px -${Math.floor(i / gridSize) * 100}px`;
        tile.setAttribute("data-index", i);
        grid.appendChild(tile);
        tiles.push(tile);
    }
    shuffleTiles();
}

function shuffleTiles() {
    tiles.sort(() => Math.random() - 0.5);
    tiles.forEach(tile => grid.appendChild(tile));
    moves = 0;
    moveCounter.textContent = moves;
    successMessage.classList.add("hidden");
}

function checkWinCondition() {
    const isWin = tiles.every((tile, index) => parseInt(tile.getAttribute("data-index")) === index);
    if (isWin) successMessage.classList.remove("hidden");
}

grid.addEventListener("click", (event) => {
    if (!event.target.classList.contains("puzzle-piece")) return;
    moves++;
    moveCounter.textContent = moves;
    checkWinCondition();
});

startButton.addEventListener("click", () => createPuzzleGrid("default-image.jpg"));
imageUpload.addEventListener("change", (event) => {
    const reader = new FileReader();
    reader.onload = (e) => createPuzzleGrid(e.target.result);
    reader.readAsDataURL(event.target.files[0]);
});
