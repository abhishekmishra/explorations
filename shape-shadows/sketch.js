// palette
// https://lospec.com/palette-list/velvet-cherry-gb
let COLOR_DARKEST = "#2d162c";
let COLOR_DARK = "#412752";
let COLOR_MID = "#683a68";
let COLOR_LIGHT = "#9775a6";

let CANVAS_WIDTH = 640;
let CANVAS_HEIGHT = 480;

function setup() {
  let cnv = createCanvas(
    CANVAS_WIDTH,
    CANVAS_HEIGHT,
    document.getElementById("exp-canvas"),
  );
}

function draw() {
  background(COLOR_LIGHT);

  drawSquare(100, 100, 100);
}

function drawSquare(x, y, w) {
  push();
  //location of shadow
  let sx = x * 1.3;
  let sy = y * 1.3;
  let sw = w * 0.85;

  let dx = (sin(frameCount * 0.1) + 1) * 10;
  let dy = (sin(frameCount * 0.1) + 1) * 10;
  let dw = (sin(frameCount * 0.1) + 1) * 10;

  fill(COLOR_DARK);
  square(sx + dx / 2, sy + dy / 2, sw + dw);

  fill(COLOR_DARKEST);
  square(x + dx, y + dy, w);

  pop();
}
