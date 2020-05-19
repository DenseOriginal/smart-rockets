int lifetime;
Population pop;
int lifeCounter;
PVector target;
int marginTop = 10;
boolean isPlaying = true;
int targetSize = 48;
ArrayList<PVector> flightPattern;
int populationSize;
boolean superSpeed = false;
int s;
float mutationRate;

void setup() {
  //size(740, 460);
  fullScreen();
  
  s = 1;
  
  lifetime = 650;
  populationSize = 800;

  lifeCounter = 0;

  target = new PVector(width/2, 48+marginTop);
  
  mutationRate = 0.0002;
  pop = new Population(mutationRate, populationSize, color(175, 100));
  pop.createObstacle(new PVector(width/2 + width/5, height/2), new PVector(width/2 - width/5, height/2));
  flightPattern = new ArrayList<PVector>();
}

void draw() {
  background(255);
  int speed;
  if(superSpeed){speed = lifetime+1;}else{speed = s;}
  for(int i = 0; i<speed; i++){
    if (isPlaying) {
      if (lifeCounter < lifetime) {
        pop.live();
        lifeCounter++;
      } else {
        nxtGen();
      }
    }
  }
  pop.display();
  
  strokeWeight(1);
  fill(0);
  ellipse(target.x, target.y, targetSize, targetSize);
  
  fill(0);
  textSize(25);
  
  ArrayList<String> infoTexts = new ArrayList<String>();
  infoTexts.add("Generation #: " + pop.getGenerations());
  infoTexts.add("Cycles left: " + (lifetime-lifeCounter));
  infoTexts.add("Dead rockets: " + pop.deadAmount + "/" + populationSize);
  infoTexts.add("Succes rockets: " + pop.hitAmount + "/" + populationSize);
  infoTexts.add("Fastmode: " + superSpeed);
  infoTexts.add("Speed: " + s);
  infoTexts.add("Mutation rate: " + nf(mutationRate, 0, 4));
  infoTexts.add("Poplation size: " + populationSize);
  
  int i = 0;
  for(String s : infoTexts) {
    text(s, 10, 18 + marginTop + (30*i));
    i++;
  }
  
  noFill();
  strokeWeight(2);
  beginShape();
  for(PVector v : flightPattern) {
    vertex(v.x, v.y);
  }
  endShape();
}

void nxtGen() {
  lifeCounter = 0;
  pop.fitness();
  pop.selection();
  pop.reproduction();
  flightPattern.clear();
}

void keyPressed() {
    if(key == CODED){
      if(keyCode == RIGHT){
        s++;
      }
      if(keyCode == LEFT && s>1){
        s--;
      }
    }
    if(key == 'f' || key == 'F'){
      superSpeed = !superSpeed;
      
      if(superSpeed){
        nxtGen();
        if (isPlaying) {
          for(int i = 0; i<lifetime-1; i++){
            pop.live();
            lifeCounter++;
          }
        }
      }
    }
    if(key == 'r'){
      nxtGen();
    }
    if(key == 'R') {
      setup();
    }
}

void mousePressed(){
  if(dist(mouseX, mouseY, target.x, target.y)<targetSize/2 && isPlaying){
    isPlaying = !isPlaying;
    return;
  }
  if (!isPlaying) {
      target.x = mouseX;
      target.y = mouseY;
      isPlaying = !isPlaying;
  }
  
}
