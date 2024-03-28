# Flocking Simulation: Boids

This is another simulation based on one of the ["Coding Train"][1] channel's 
videos [Coding Challenge #124: Flocking Simulation][2]. It is based on the
original work - [Boids by Craig Reynolds][3]. The simulation is built using 
[love2d][4].

**Boids** are "flocking creatures" which simulate the behaviour of birds and
fishes when flying or swimming together respectively. It is based on the
autonomous behaviour of each organism in the group which tries to move based on
changes around it.

Each **boid** tries to stay together of the **boids** around it, but not too
close. It also tries to move in the general direction of the **boids** around
it. These behaviours can be programmed into the autonomous boid based on three
simple rules:

1. **Separation**: Move in such a way that one avoids a collision with, or 
   coming too close to a nearby organism/boid.
2. **Alignment**: Move in the same average direction as the nearby boids.
3. **Cohesion**: Move towards the average location of the nearby boids.

The above rules have some parameters which can be tweaked, especially the
definition of *nearby*.

The movement of each boid is a combination of the **acceleration** computed by
evaluating each of the above three rules separately. The values of *separation*,
*alignment*, and *cohesion* can be combined in various proportions to make the
final acceleration of the individual boid. This leads remarkably different
flocking behaviours from the boids.

The following gif shows some of the possibilities of the simulation.
(Apologies for the potato quality of the gif. My gif creation skills are
poor as you can see.)

![Flocking Simulation of Boids](FlockingSimulationBoids-28032024.gif)

[1]: https://www.youtube.com/@TheCodingTrain
[2]: https://www.youtube.com/watch?v=mhjuuHl6qHM&pp=ygUSY29kaW5nIHRyYWluIGJvaWRz
[3]: https://www.red3d.com/cwr/boids/
[4]: https://love2d.org