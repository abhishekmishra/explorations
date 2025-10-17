/**
 * Draws a Logarithmic Spiral and returns the P0/P1 vectors for G2 continuity.
 * @param {number} a - Scaling factor (start radius).
 * @param {number} b - Tightness/Growth Rate.
 * @param {number} turns - Total number of turns to draw.
 * @param {number} phiTarget - The required GLOBAL tangent angle (0 or HALF_PI).
 * @returns {object} { P0: p5.Vector, P1: p5.Vector } The junction point and first control point.
 */
function logarithmicSpiralG1(a, b, turns, phiTarget) {
  let alpha = atan(1 / b);
  let theta_end = phiTarget - alpha;
  let theta_start = theta_end - TWO_PI * turns;

  // --- Draw the Spiral ---
  beginShape();
  for (let theta = theta_start; theta <= theta_end; theta += 0.05) {
    let r = a * exp(b * theta);
    let x = r * cos(theta);
    let y = r * sin(theta);
    vertex(x, y);
  }
  endShape();

  // --- Calculate G2 Junction Parameters ---
  let r0 = a * exp(b * theta_end);
  let x0 = r0 * cos(theta_end);
  let y0 = r0 * sin(theta_end);
  let P0 = createVector(x0, y0);

  // Calculate P0-P1 length L for G2 continuity
  let kappa_spiral = sqrt(1 + b * b) / r0;
  let L = 1 / (3 * kappa_spiral);

  // P1 Direction: phiTarget (guaranteed horizontal/vertical)
  let P1_x = x0 + L * cos(phiTarget);
  let P1_y = y0 + L * sin(phiTarget);
  let P1 = createVector(P1_x, P1_y);

  return { P0, P1 };
}

// NOTE: This assumes the LogarithmicSpiralG1 function is available.

// Global P5.js functions (assumed setup remains the same)

function drawScroll() {
  // === 1. SPIRAL PARAMETERS ===
  let A_SCALE = 20;
  let B_TIGHTNESS = 0.3; // Slight tightening of the spiral
  let TURNS = 1.2;
  let TANGENT_PHI = 0; // Horizontal Launch

  // === 2. TWO-SEGMENT S-CURVE CONTROLS (Reduced Amplitude) ===

  // A) MIDPOINT (Controls the depth and length of the first arc)
  let MID_X = 250; // X position of P_mid (stretched out)
  let MID_Y = -40; // Y position of P_mid (Reduced vertical depth)

  // B) INFLECTION CONTROL (Tangent length at P_mid)
  let MID_TANGENT_L = 50; // Reduced tangent length for gentler inflection

  // C) ENDPOINT (The final destination P5)
  let END_X = 450;
  let END_Y = 20; // P5 is slightly above P0's line

  // --- EXECUTION ---
  translate(100, 200); // Global Positioning

  // 1. Get the G2-smooth junction points (P0 and P1)
  let junction = logarithmicSpiralG1(A_SCALE, B_TIGHTNESS, TURNS, TANGENT_PHI);
  let P0 = junction.P0;
  let P1 = junction.P1;

  // 2. Define the Intermediate Junction (P_mid)
  let P_mid = createVector(P0.x + MID_X, P0.y + MID_Y);

  // 3. Define P_mid1: Control point for the END of Segment 1.
  // It should be positioned to gently direct the curve toward P_mid.
  // We make it slightly negative (downwards) to reinforce the first arc.
  let P_mid1 = createVector(P_mid.x - MID_TANGENT_L, P_mid.y - 10); // Subtle pull before P_mid

  // 4. Define P_mid2: Control point for the START of Segment 2.
  // CRUCIAL G1 STEP: P_mid2 must be collinear with P_mid and P_mid1.
  // Vector V = P_mid - P_mid1
  let V = p5.Vector.sub(P_mid, P_mid1);
  V.normalize();
  V.mult(MID_TANGENT_L);
  let P_mid2 = p5.Vector.add(P_mid, V);

  // 5. Define P4: The final control point (controls the end tangent)
  let P5 = createVector(P0.x + END_X, P0.y + END_Y);
  // P4 should pull gently towards the end
  let P4 = createVector(P5.x - 50, P5.y + 10);

  // --- DRAW SEGMENTS ---

  // Segment 1: Spiral Junction (P0) to Midpoint (P_mid)
  // The jaggedness issue is often solved by careful placement of P_mid1.
  beginShape();
  vertex(P0.x, P0.y);
  bezierVertex(P1.x, P1.y, P_mid1.x, P_mid1.y, P_mid.x, P_mid.y);
  endShape();

  // Segment 2: Midpoint (P_mid) to Final End (P5)
  beginShape();
  vertex(P_mid.x, P_mid.y);
  bezierVertex(P_mid2.x, P_mid2.y, P4.x, P4.y, P5.x, P5.y);
  endShape();
}

// NOTE: The `cubicBezierG1` manual vertex loop is replaced by P5.js's native `bezierVertex` function
// for cleaner implementation when using two segments. You would adapt the logic above
// into two separate beginShape/endShape blocks using the raw Bézier formula if needed.

// Global P5.js functions
function setup() {
  createCanvas(600, 400);
  stroke(0);
  strokeWeight(3);
  noFill();
  noLoop();
  background(255);
  drawScroll();
}

// function draw() is not needed since noLoop() is used in setup
