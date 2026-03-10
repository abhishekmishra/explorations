let CANVAS_WIDTH = 640;
let CANVAS_HEIGHT = 480;

let CELL_UNIT = 10;
let CELL_COL_COUNT = CANVAS_WIDTH / CELL_UNIT;
let CELL_ROW_COUNT = CANVAS_HEIGHT / CELL_UNIT;

let grid = [];
let target = null;
let targetMoved = false;

function createGrid() {
  grid = [];
  for (let j = 0; j < CELL_ROW_COUNT; j++) {
    for (let i = 0; i < CELL_COL_COUNT; i++) {
      // let index = j * CELL_ROW_COUNT + i;
      grid.push(p5.Vector.fromAngle(random(0, TAU)));
    }
  }
}

function updateGrid() {
  if (target != null && targetMoved) {
    for (let j = 0; j < CELL_ROW_COUNT; j++) {
      for (let i = 0; i < CELL_COL_COUNT; i++) {
        let index = j * CELL_COL_COUNT + i;
        // let c = grid[index];
        let loc = createVector(i, j);
        let d = loc.sub(target);
        grid[index] = p5.Vector.fromAngle(d.angleBetween(target));
      }
    }
    targetMoved = false;
  }
}

function drawGrid() {
  strokeWeight(1);
  noFill();
  stroke(0);
  for (let j = 0; j < CELL_ROW_COUNT; j++) {
    for (let i = 0; i < CELL_COL_COUNT; i++) {
      let index = j * CELL_COL_COUNT + i;
      push();
      translate(i * CELL_UNIT, j * CELL_UNIT);
      stroke(200);
      if (target != null && target.x === i && target.y === j) {
        fill("red");
        square(0, 0, CELL_UNIT);
        noFill();
      } else {
        square(0, 0, CELL_UNIT);
      }
      let c = grid[index];
      translate(CELL_UNIT / 2, CELL_UNIT / 2);
      rotate(c.heading() - (3 * PI) / 4);
      // scale(CELL_UNIT);
      stroke(0);
      line(0, 0, CELL_UNIT, 0);
      pop();
    }
  }
}

function setup() {
  let cnv = createCanvas(
    CANVAS_WIDTH,
    CANVAS_HEIGHT,
    document.getElementById("exp-canvas"),
  );

  createGrid();
}

function draw() {
  background(220);
  updateGrid();
  drawGrid();
  // noLoop();
}

// Save a 5-second gif when the user presses the 's' key.
// Wait 1 second after the key press before recording.
function keyPressed() {
  if (key === "s") {
    saveGif("sketch", 5, { delay: 1 });
  }
}

function mouseMoved() {
  target = createVector(floor(mouseX / CELL_UNIT), floor(mouseY / CELL_UNIT));
  targetMoved = true;
}
