let CANVAS_WIDTH = 640;
let CANVAS_HEIGHT = 480;

let CELL_UNIT = 10;
let CELL_COL_COUNT = CANVAS_WIDTH / CELL_UNIT;
let CELL_ROW_COUNT = CANVAS_HEIGHT / CELL_UNIT;

let NUM_PARTICLES = 10;

let grid = [];
let particles = [];
let target = null;
let targetMoved = false;

class Particle {
  constructor(grid) {
    this.grid = grid;
    this.pos = createVector(random(CELL_COL_COUNT), random(CELL_ROW_COUNT));
    this.vel = createVector(0, 0);
    this.acc = createVector(0, 0);
  }

  update() {
    let index = floor(this.pos.y) * CELL_COL_COUNT + floor(this.pos.x);
    this.acc = this.grid[index];
    this.vel.add(this.acc);
    this.pos.add(this.vel.mult(deltaTime * 0.01));
    // console.log(this.pos.x);

    this.edges();
  }

  draw() {
    push();

    translate(this.pos.x * CELL_UNIT, this.pos.y * CELL_UNIT);
    fill(255, 0, 0);
    strokeWeight(0);
    circle(CELL_UNIT / 2, CELL_UNIT / 2, 5);

    pop();
  }

  edges() {
    if (this.pos.x < 0) {
      this.pos.x = CELL_COL_COUNT;
    }
    if (this.pos.x > CELL_COL_COUNT) {
      this.pos.x = 0;
    }
    if (this.pos.y < 0) {
      this.pos.y = CELL_ROW_COUNT;
    }
    if (this.pos.y > CELL_ROW_COUNT) {
      this.pos.y = 0;
    }
  }
}

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
        let loc = createVector(i, j);
        let d = target.copy().sub(loc);
        // the flow vector for the cell is now specified by
        // the angle between the vector from cell to target, and target.
        grid[index] = p5.Vector.fromAngle(target.angleBetween(d));
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
      if (target != null && floor(target.x) === i && floor(target.y) === j) {
        fill("red");
        square(0, 0, CELL_UNIT);
        noFill();
      } else {
        square(0, 0, CELL_UNIT);
      }
      let c = grid[index];
      translate(CELL_UNIT / 2, CELL_UNIT / 2);
      rotate(c.heading());
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
  for (let i = 0; i < NUM_PARTICLES; i++) {
    particles.push(new Particle(grid));
  }

  background(220);
}

function draw() {
  background(220, 220, 220, 10);

  updateGrid();
  // drawGrid();

  for (let i = 0; i < NUM_PARTICLES; i++) {
    particles[i].update();
    particles[i].draw();
  }
  // noLoop();

  // filter(BLUR, 3);
}

// Save a 5-second gif when the user presses the 's' key.
// Wait 1 second after the key press before recording.
function keyPressed() {
  if (key === "s") {
    saveGif("sketch", 5, { delay: 1 });
  }
}

function mouseMoved() {
  target = createVector(mouseX / CELL_UNIT, mouseY / CELL_UNIT);
  targetMoved = true;
}
