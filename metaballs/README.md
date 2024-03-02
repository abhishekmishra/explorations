**Table of Contents**

- [1. Metaballs](#1-metaballs)
  - [1.1. What is a Metaball?](#11-what-is-a-metaball)
- [2. Concepts in this Demo](#2-concepts-in-this-demo)
  - [2.1. Isosurface](#21-isosurface)
  - [2.2. Metaball Isosurface](#22-metaball-isosurface)
  - [2.3. Inverse Square Law](#23-inverse-square-law)
  - [2.4. Typical Metaball Function](#24-typical-metaball-function)

# 1. Metaballs

Once again I found out about this cool graphics thing from "The Coding Train"
channel. The is one of the earlier videos in the series - 
["Coding Challenge #28: Metaballs"][1].

I watched the video, liked it a lot and given I'm studying graphics and making
all these shader things these days I thought I'm going to implemented this
in love2d and then if possible do it entirely in shaders if possible. I know
that my "shader-foo" is quite weak at the moment. But I would love to fail and
then come back and accomplish this later if needed.

Let's go!

## 1.1. What is a Metaball?

Here's the [definition from wikipedia][2]:

*In computer graphics, metaballs, also known as blobby objects,are*
*organic-looking n-dimensional isosurfaces, characterised by their ability to* 
*meld together when in close proximity to create single, contiguous objects.*

So as per my understanding a Metaball visualization helps us create a image
of a set of circular shaped objects melding into one with a single unified
surface when they are close, and slowly separating out into individual shapes
as they move farther from each other.

TODO: show example visualization.

# 2. Concepts in this Demo

## 2.1. Isosurface

Simple definition of an isosurface is a surface where every pixel on the 
surface, or a canvas in our case, is a function of its x and y coordinates. The
function can be any function of the position.

`pixelColor = f(x, y)`

## 2.2. Metaball Isosurface

Where the pixel is not just a function of the position, but also a function
of its distance from one or more balls in the canvas. Since distance is already
defined in terms of position of two objects. So effectively the pixel is a
function of its distance from a ball.

`pixelColor = f(d)`

where,

`d = distance(point, centerOfBall)`

## 2.3. Inverse Square Law

One of the functions possible for the Metaball Isosurface is the 
[*Inverse Square Law*][3]. The value of an inverse square law function is
inversely proportional to the square of the distance. So in our case lets say
`d` is the distance between a pixel and the center of a ball on the canvas.

Then our inverse square law isosurface function could be:

`pixelColor = 1/(d^2)`

NOTE: In physics for e.g., the gravitational force is inversely proportional to the
square of the distance between two bodies.

## 2.4. Typical Metaball Function

A typical function chosen for the the Metaball is actually just an inverse
of the distance i.e. `1/d` mutliplied with the radius of the metaball say `r`.

This would be:

`pixelColor = r/d`



[1]: https://www.youtube.com/watch?v=ccYLb7cLB1I
[2]: https://en.wikipedia.org/wiki/Metaballs
[3]: https://en.wikipedia.org/wiki/Inverse-square_law