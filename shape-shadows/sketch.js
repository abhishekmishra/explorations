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
  push();
  translate(20, 50);
  drawSquare(0, 0, 80, tx);
  drawCircle(140, 40, 80, tx);
  drawEllipse(250, 40, 90, 60, tx);
  drawRectangle(330, 10, 100, 60, tx);
  drawTriangle(460, 10, 110, 60, tx);
  pop();

  push();
  translate(20, 180);
  drawRectangle(0, 10, 120, 50, tx);
  drawTriangle(160, 10, 180, 60, tx);
  // drawSquare(0, 0, 80, tx);
  // drawCircle(140, 40, 80, tx);
  drawEllipse(450, 40, 190, 60, tx);
  // drawTriangle(460, 10, 110, 60, tx);
  pop();

  push();
  translate(20, 310);
  drawSquare(0, 0, 80, tx);
  drawCircle(140, 40, 80, tx);
  drawSquare(200, 0, 80, tx);
  drawCircle(340, 40, 80, tx);
  drawSquare(400, 0, 80, tx);
  drawCircle(540, 40, 80, tx);
  pop();
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

function drawEllipse(x, y, w, h, tx) {
  push();
  //location of shadow
  let sx = x + 20;
  let sy = y + 20;
  let sw = w * 0.9;
  let sh = h * 0.9;

  let dx = tx * w * 0.2;
  let dy = tx * h * 0.2;
  let dw = tx * w * 0.1;
  let dh = tx * w * 0.1;

  noStroke();
  fill(COLOR_DARK);
  ellipse(sx + dx / 2, sy + dy / 2, sw + dw, sh + dh);

  fill(COLOR_DARKEST);
  ellipse(x + dx, y + dy, w, h);

  pop();
}

function drawRectangle(x, y, w, h, tx) {
  push();
  //location of shadow
  let sx = x + 20;
  let sy = y + 20;
  let sw = w * 0.9;
  let sh = h * 0.9;

  let dx = tx * w * 0.2;
  let dy = tx * h * 0.2;
  let dw = tx * w * 0.1;
  let dh = tx * w * 0.1;

  noStroke();
  fill(COLOR_DARK);
  rect(sx + dx / 2, sy + dy / 2, sw + dw, sh + dh);

  fill(COLOR_DARKEST);
  rect(x + dx, y + dy, w, h);

  pop();
}

function drawTriangle(x, y, w, h, tx) {
  push();
  //location of shadow
  let sx = x + 20;
  let sy = y + 20;
  let sw = w * 0.9;
  let sh = h * 0.9;

  let dx = tx * w * 0.2;
  let dy = tx * h * 0.2;
  let dw = tx * w * 0.2;
  let dh = tx * w * 0.1;

  noStroke();
  fill(COLOR_DARK);
  triangle(
    sx + dx / 2,
    sy + dy / 2,
    sx + dx / 2 + sw + dw,
    sy + dy / 2 + sh + dh,
    sx + dx / 2,
    sy + dy / 2 + sh + dh,
  );

  fill(COLOR_DARKEST);
  triangle(x + dx, y + dy, x + dx + w, y + dy + h, x + dx, y + dy + h);

  pop();
}
