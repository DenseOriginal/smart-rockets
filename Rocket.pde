class Rocket {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float recordDist = 10000;
  color col;

  float r;

  float fitness;
  DNA dna;
  int geneCounter = 0;

  boolean hitTarget = false;
  boolean dead = false;
  
  int myTime;
  
  //constructor
  Rocket(PVector l, DNA dna_) {
    acceleration = new PVector();
    velocity = new PVector();
    position = l;
    r = 4;
    dna = dna_;
  }

  void fitness() {
    float d = recordDist;
    //float d = dist(position.x, position.y, target.x, target.y);
    fitness = pow(1/(d*pow(myTime, 2)), 4);
    if(hitTarget){fitness*=1.5;}
    if(dead){fitness*=0.1;}
    
  }

  void run() {
    checkTarget();
    if (!hitTarget && !dead) {
      applyForce(dna.genes[geneCounter]);
      geneCounter = (geneCounter + 1) % dna.genes.length;
      if(dist(position.x, position.y, target.x, target.y)<recordDist){recordDist = dist(position.x, position.y, target.x, target.y);}
      update();
    }
    if(!hitTarget){myTime++;}
  }

  void checkTarget() {
    float d = dist(position.x, position.y, target.x, target.y);
    if (d < targetSize/2) {
      hitTarget = true;
    }
  }

  void applyForce(PVector f) {
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(4);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    float rot = velocity.heading() + PI/2;
    strokeWeight(1);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(rot);

    // Rocket body
    fill(col);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();

    popMatrix();
  }

  float getFitness() {
    return fitness;
  }
  
  float getDist() {
    return dist(position.x, position.y, target.x, target.y);
  }

  DNA getDNA() {
    return dna;
  }

}
