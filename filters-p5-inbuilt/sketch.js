let CANVAS_WIDTH = 640;
let CANVAS_HEIGHT = 480;

function setup() {
  let cnv = createCanvas(
    CANVAS_WIDTH,
    CANVAS_HEIGHT,
    document.getElementById("exp-canvas"),
  );

  pg = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT);

  // Draw circles ONCE to the buffer
  pg.fill(255);
  pg.noStroke();
  randomSeed(1);
  for (let i = 0; i < 20; i++) {
    pg.circle(random(pg.width), random(pg.height), 10);
  }
}

function draw() {
  background(0); // Clear the main screen

  fill("#ff0000");
  noStroke();
  square(100, 100, 100);

  let blurRadius = ((sin(frameCount * 0.1) + 1) / 0.5) * 8;
  filter(BLUR, blurRadius);

  // Apply erosion to the buffer periodically
  let fc = frameCount % 20;
  if (fc < 1) {
    pg.filter(DILATE, false);
  } else if (fc > 18) {
    pg.filter(ERODE, false);
  }

  // Display the buffer on the main canvas
  image(pg, 0, 0);
}

// Save a 5-second gif when the user presses the 's' key.
// Wait 1 second after the key press before recording.
function keyPressed() {
  if (key === "s") {
    saveGif("sketch", 5, { delay: 1 });
  }
}
