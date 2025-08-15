const canvasWidth = 400;
const canvasHeight = 400;
const cellBoundaryColour = "#000000"; // Black for cell boundaries
const cellBoundaryWidth = 1; // Width of the cell boundary lines
const wallColour = "#8B4513"; // Brown for walls
const emptyColour = "#FFFFFF"; // White for empty cells
const backgroundColour = "#423232"; // Dark gray for background

/**
 * A position class representing a point in the dungeon grid.
 * It has x and y coordinates.
 */
class Position {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

/**
 * A dungeon represented using a grid of cells.
 * Constructor accepts a width and height for the dungeon.
 * Each cell can be empty or contain a wall.
 * The grid is a 2D array where each element is a cell.
 */
class Dungeon {
  /**
   * Create a new Dungeon instance with specified dimensions.
   *
   * @param {Number} width width of the dungeon
   * @param {Number} height height of the dungeon
   */
  constructor(width, height) {
    this.width = width;
    this.height = height;
    this.grid = Array.from({ length: height }, () => Array(width).fill(null));

    // Initialize all cells to 'wall'
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        this.grid[y][x] = "wall";
      }
    }

    this.cellWidth = canvasWidth / width;
    this.cellHeight = canvasHeight / height;
  }

  /**
   * Check if the specified coordinates are within the dungeon bounds.
   *
   * @param {Position} position a Position object with x and y coordinates
   * @returns {Boolean} true if within bounds, false otherwise
   */
  inBounds(position) {
    return (
      position.x >= 0 &&
      position.x < this.width &&
      position.y >= 0 &&
      position.y < this.height
    );
  }

  /**
   * Get the cell value at the specified coordinates.
   * If the coordinates are out of bounds, return null.
   *
   * @param {Position} position a Position object with x and y coordinates
   * @returns {String|null} the cell value ('wall' or 'empty') or null if out of bounds
   */
  getCell(position) {
    if (!this.inBounds(position)) {
      return null;
    }
    return this.grid[position.y][position.x];
  }

  /**
   * Set the cell at the specified coordinates to a new value.
   * Only 'wall' or 'empty' are valid values.
   * If the coordinates are out of bounds, return false, otherwise set the value
   * and return true.
   * @param {Position} position a Position object with x and y coordinates
   * @param {String} value the value to set ('wall' or 'empty')
   * @return {Boolean} true if the value was set, false if out of bounds or invalid value
   */
  setCell(position, value) {
    if (!this.inBounds(position) || (value !== "wall" && value !== "empty")) {
      return false;
    }
    this.grid[position.y][position.x] = value;
    return true;
  }

  /**
   * Set the cell at the specified coordinates to 'wall'.
   * If the coordinates are out of bounds, return false, otherwise set the value
   * and return true.
   * @param {Position} position a Position object with x and y coordinates
   * @return {Boolean} true if the value was set, false if out of bounds
   */
  setWall(position) {
    return this.setCell(position, "wall");
  }

  /**
   * Set the cell at the specified coordinates to 'empty'.
   * If the coordinates are out of bounds, return false, otherwise set the value
   * and return true.
   * @param {Position} position a Position object with x and y coordinates
   * @return {Boolean} true if the value was set, false if out of bounds
   */
  setEmpty(position) {
    return this.setCell(position, "empty");
  }

  /**
   * Check if the specified cell is a wall.
   *
   * @param {Position} position a Position object with x and y coordinates
   * @returns {Boolean} true if the cell is a wall, false otherwise
   */
  isWall(position) {
    const cell = this.getCell(position);
    return cell === "wall";
  }

  /**
   * Check if the specified cell is empty.
   *
   * @param {Position} position a Position object with x and y coordinates
   * @returns {Boolean} true if the cell is empty, false otherwise
   */
  isEmpty(position) {
    const cell = this.getCell(position);
    return cell === "empty";
  }

  /**
   * Get the cell position to the right of the specified coordinates.
   * If the specified coordinates are not valid return null
   * Use wrap around to get to the fist column if the x-coordinate is at the right edge.
   * @param {Position} position a Position object with x and y coordinates
   * @return {Position|null} an a Position object or null if out of bounds
   */
  getRight(position) {
    if (!this.inBounds(position)) {
      return null;
    }
    const newX = (position.x + 1) % this.width;
    return new Position(newX, position.y);
  }

  /**
   * Get the cell position to the left of the specified coordinates.
   * If the specified coordinates are not valid return null
   * Use wrap around to get to the last column if the x-coordinate is at the left edge.
   * @param {Position} position a Position object with x and y coordinates
   * @return {Position|null} an a Position object or null if out of bounds
   */
  getLeft(position) {
    if (!this.inBounds(position)) {
      return null;
    }
    const newX = (position.x - 1 + this.width) % this.width;
    return new Position(newX, position.y);
  }

  /**
   * Get the cell position above the specified coordinates.
   * If the specified coordinates are not valid return null
   * Use wrap around to get to the last row if the y-coordinate is at the top.
   * @param {Position} position a Position object with x and y coordinates
   * @return {Position|null} an a Position object or null if out of bounds
   */
  getAbove(position) {
    if (!this.inBounds(position)) {
      return null;
    }
    const newY = (position.y - 1 + this.height) % this.height;
    return new Position(position.x, newY);
  }

  /**
   * Get the cell position below the specified coordinates.
   * If the specified coordinates are not valid return null
   * Use wrap around to get to the first row if the y-coordinate is at the bottom.
   * @param {Position} position a Position object with x and y coordinates
   * @return {Position|null} an a Position object or null if out of bounds
   */
  getBelow(position) {
    if (!this.inBounds(position)) {
      return null;
    }
    const newY = (position.y + 1) % this.height;
    return new Position(position.x, newY);
  }

  /**
   * Draw the dungeon on the canvas.
   * Each cell is a square, walls are drawn in wallColour,
   * and empty cells are drawn in emptyColour.
   */
  draw() {
    for (let y = 0; y < this.height; y++) {
      for (let x = 0; x < this.width; x++) {
        const cell = this.grid[y][x];
        if (cell === "wall") {
          fill(wallColour);
        } else if (cell === "empty") {
          fill(emptyColour);
        } else {
          fill(emptyColour); // Default to empty if cell is null
        }

        // Draw the cell
        rect(
          x * this.cellWidth,
          y * this.cellHeight,
          this.cellWidth,
          this.cellHeight
        );

        // Draw cell boundaries
        stroke(cellBoundaryColour);
        strokeWeight(cellBoundaryWidth);
        noFill();
        rect(
          x * this.cellWidth,
          y * this.cellHeight,
          this.cellWidth,
          this.cellHeight
        );
      }
    }
  }
}

let dungeon;

/**
 * Implement a random walk algorithm on the dungeon limited to a certain number of steps.
 * The random walk starts at the specified position and moves to adjacent cells.
 * When moving to a new cell, mark it as 'empty'.
 * The walk continues until the specified number of steps is reached.
 *
 * @param {Dungeon} dungeon the dungeon to perform the random walk on
 * @param {Position} startPosition starting position for the random walk
 * @param {Number} steps the number of steps to take in the random walk
 */
function randomWalkDungeonLimSteps(dungeon, startPosition, steps) {
  let currentPosition = startPosition;

  for (let i = 0; i < steps; i++) {
    // Mark the current position as empty
    dungeon.setEmpty(currentPosition);

    // Get a random direction to move
    const directions = [
      dungeon.getRight(currentPosition),
      dungeon.getLeft(currentPosition),
      dungeon.getAbove(currentPosition),
      dungeon.getBelow(currentPosition),
    ];

    // Filter out null positions (out of bounds)
    const validDirections = directions.filter((pos) => pos !== null);

    // Choose a random valid direction
    if (validDirections.length > 0) {
      const randomIndex = Math.floor(Math.random() * validDirections.length);
      currentPosition = validDirections[randomIndex];
    }
  }
}

function setup() {
  createCanvas(canvasWidth, canvasHeight);
  let dungeonW = 10;
  let dungeonH = 10;
  dungeon = new Dungeon(dungeonW, dungeonH);
  // Start in the middle of the dungeon
  const startPosition = new Position(dungeonW / 2, dungeonH / 2);
  const steps = 100; // Number of steps for the random walk
  randomWalkDungeonLimSteps(dungeon, startPosition, steps);
}

function draw() {
  background(backgroundColour);
  dungeon.draw();
}
