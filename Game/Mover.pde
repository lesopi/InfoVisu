
    class Mover {
      PVector location;
      PVector gravityForce;
      PVector velocity;
      PVector friction;
      Mover() {
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
        translate(mover.location.x, mover.location.y, mover.location.z);
        sphere(radius);
      }
      
      void checkEdges() {
        if (location.x > 150) {
          location.x = 150;
          velocity.x = velocity.x*-rebondcoeff;
        }
        else if (location.x < -150) {
         location.x = -150;
          velocity.x = velocity.x*-rebondcoeff;
}
        if (location.z > 150) {
          location.z = 150;
          velocity.z = velocity.z*-rebondcoeff;
        }
        else if (location.z < -150) {
          location.z = -150;
          velocity.z = velocity.z*-rebondcoeff;
        }
} 
  void physics(){
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