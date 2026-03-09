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

  let tx = (sin(frameCount * 0.1) + 1) / 2;
  drawSquare(20, 20, 80, tx);
  drawCircle(180, 60, 80, tx);
}

function drawSquare(x, y, w, tx) {
  push();
  //location of shadow
  let sx = x + 20;
  let sy = y + 20;
  let sw = w * 0.9;

  let dx = tx * w * 0.2;
  let dy = tx * w * 0.2;
  let dw = tx * w * 0.1;

  noStroke();
  fill(COLOR_DARK);
  square(sx + dx / 2, sy + dy / 2, sw + dw);

  fill(COLOR_DARKEST);
  square(x + dx, y + dy, w);

  pop();
}

function drawCircle(x, y, r, tx) {
  push();
  //location of shadow
  let sx = x + 20;
  let sy = y + 20;
  let sw = r * 0.9;

  let dx = tx * r * 0.2;
  let dy = tx * r * 0.2;
  let dw = tx * r * 0.1;

  noStroke();
  fill(COLOR_DARK);
  circle(sx + dx / 2, sy + dy / 2, sw + dw);

  fill(COLOR_DARKEST);
  circle(x + dx, y + dy, r);

  pop();
}
