let CANVAS_WIDTH = 640;
let CANVAS_HEIGHT = 480;

function setup() {
  let cnv = createCanvas(
    CANVAS_WIDTH,
    CANVAS_HEIGHT,
    document.getElementById("exp-canvas"),
  );
}

let y1off = 0;
let y2off = 100;
function draw() {
  background(220);
  strokeWeight(2);
  let gap = 10;
  for (let i = 0; i < 5; i++) {
    let y = 100 + (i + 1) * gap;
    line(
      width / 2 - 50,
      y + map(noise(y1off + i), 0, 1, 0, gap),
      width / 2 + 50,
      y + map(noise(y2off + i), 0, 1, 0, gap),
    );
    y1off += 0.01;
    y2off += 0.01;
  }

  // noLoop();
}

// Save a 5-second gif when the user presses the 's' key.
// Wait 1 second after the key press before recording.
function keyPressed() {
  if (key === "s") {
    saveGif("sketch", 5, { delay: 1 });
  }
}
