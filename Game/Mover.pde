
class Mover {
  // properties of the ball
  PVector location;
  PVector gravityForce;
  PVector velocity;
  PVector friction;

  Mover() {
    // instantiate the vectors
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
  }

  void update() {
    physics();
    velocity.add(gravityForce);
    velocity.add(friction);
    location.add(velocity);
  }

  void display() {
    // draw the ball on the plate
    translate(mover.location.x, mover.location.y, mover.location.z);
    fill(255, 0, 0);
    sphere(radius);
  }
  
  void displayShift(){
    translate(mover.location.x,mover.location.z,mover.location.y);
    fill(255,0,0);
    sphere(radius);
  }

  void checkEdges() {
    // check that the ball doesn't go out of the plate
    if (location.x > boxXZ / 2) {
      //updateScore(-1*velocity.mag());
      location.x = boxXZ / 2;
      velocity.x = velocity.x * -rebondcoeff;
    } else if (location.x < -boxXZ / 2) {
      //updateScore(-1*velocity.mag());
      location.x = -boxXZ / 2;
      velocity.x = velocity.x * -rebondcoeff;
    }
    if (location.z > boxXZ / 2) {
      //updateScore(-.1*velocity.mag());
      location.z = boxXZ / 2;
      velocity.z = velocity.z * -rebondcoeff;
    } else if (location.z < -boxXZ / 2) {
      //updateScore(-.1*velocity.mag());
      location.z = -boxXZ / 2;
      velocity.z = velocity.z * -rebondcoeff;
    }
  }


  void checkCylinderCollision() {
    // check that the ball doesn't go inside a cylinder
    // and that it bounces on it
    for (PVector o : obstacles) {
      // we swapped coordinates in shiftMode
      PVector swap = new PVector(o.x, o.z, o.y);
      if (location.dist(swap) < cylinderBaseSize + radius) {
        //a collision occurs 
        //updateScore(velocity.mag());
        // apply formula
        PVector n = PVector.sub(location, swap);
        n.normalize();
        location = PVector.mult(n, cylinderBaseSize + radius).add(swap);
        PVector v2 = PVector.sub(velocity, 
          PVector.mult(n, 2 * PVector.dot(velocity, n)));
        velocity = v2;
      }
    }
  }


  void physics() {
    // apply the plate's positions particularities
    gravityForce.x = sin(angleZ) * gravityConstant;
    gravityForce.z = sin(angleX) * -gravityConstant;
    float normalForce = 1;
    float frictionMagnitude = normalForce * mu;
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
  }
}