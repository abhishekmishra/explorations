let CANVAS_WIDTH = 640;
let CANVAS_HEIGHT = 480;

function setup() {
  let cnv = createCanvas(
    CANVAS_WIDTH,
    CANVAS_HEIGHT,
    document.getElementById("exp-canvas"),
  );
  background(0);
}

function draw() {
  noFill();
  strokeWeight(random(3, 8));
  stroke(random(0, 255), random(0, 255), random(0, 255));
  for (let i = 0; i < random(1, 3); i++) {
    drawRandLine();
  }
  if (frameCount % 5) {
    filter(BLUR, 5);
  }
}

// Save a 5-second gif when the user presses the 's' key.
// Wait 1 second after the key press before recording.
function keyPressed() {
  if (key === "s") {
    saveGif("sketch", 5, { delay: 1 });
  }
}

function drawRandLine() {
  let sx = random(0, CANVAS_WIDTH);
  let sy = random(0, CANVAS_HEIGHT);
  let ex = random(0, CANVAS_WIDTH);
  let ey = random(0, CANVAS_HEIGHT);
  line(sx, sy, ex, ey);
}
