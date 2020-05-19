class Population {

  float mutationRate;
  Rocket[] population;
  ArrayList<Rocket> matingPool;
  ArrayList<Obstacle> obs;
  int generations;
  color col = color(175);
  int hitAmount = 0;
  int deadAmount = 0;

   Population(float m, int num, color c) {
    col = c;
    mutationRate = m;
    population = new Rocket[num];
    matingPool = new ArrayList<Rocket>();
    obs = new ArrayList<Obstacle>();
    generations = 0;
    for (int i = 0; i < population.length; i++) {
      PVector position = new PVector(width/2,height-20);
      population[i] = new Rocket(position, new DNA());
      population[i].col = col;
    }
  }

  void live () {
    hitAmount = 0;
    deadAmount = 0;
    float x = 0;
    float y = 0;
    for (int i = 0; i < population.length; i++) {
      population[i].run();
      population[i].col = col;
      if(population[i].dead) deadAmount++;
      if(population[i].hitTarget) hitAmount++;
      x += population[i].position.x;
      y += population[i].position.y;
      if(obs!=null){
        boolean state = false;
        for(Obstacle o : obs){
          if(o.checkRocket(population[i])){state = true;}
        }
        population[i].dead = state;
      }
    }
    x = x/population.length;
    y = y/population.length;
    flightPattern.add(new PVector(x, y));
  }
  
  void display() {
    if(obs!=null){for(Obstacle o : obs){o.display();}}
    Rocket bestRocket = population[0];
    for(int i = 0; i<population.length; i++){
      population[i].display();
      if(bestRocket.getDist()>population[i].getDist() && !population[i].hitTarget){bestRocket = population[i];}
    }
    strokeWeight(1);
    line(target.x, target.y, bestRocket.position.x, bestRocket.position.y);
    bestRocket.col = color(255);
    
  }

  void fitness() {
    for (int i = 0; i < population.length; i++) {
      population[i].fitness();
    }
  }

  void selection() {
    matingPool.clear();

    float maxFitness = getMaxFitness();

    for (int i = 0; i < population.length; i++) {
      float fitnessNormal = map(population[i].getFitness(),0,maxFitness,0,1);
      int n = (int) (fitnessNormal * 100);
      for (int j = 0; j < n; j++) {
        matingPool.add(population[i]);
      }
    }
  }

  void reproduction() {
    for (int i = 0; i < population.length; i++) {
      int m = int(random(matingPool.size()));
      int d = int(random(matingPool.size()));
      Rocket mom = matingPool.get(m);
      Rocket dad = matingPool.get(d);
      DNA momgenes = mom.getDNA();
      DNA dadgenes = dad.getDNA();
      DNA child = momgenes.crossover(dadgenes);
      child.mutate(mutationRate);
      PVector position = new PVector(width/2,height+20);
      population[i] = new Rocket(position, child);
      population[i].col = col;
    }
    generations++;
  }

  void createObstacle(PVector p1, PVector p2) {
    obs.add(new Obstacle(p1, p2));
  }

  int getGenerations() {
    return generations;
  }

  float getMaxFitness() {
    float record = 0;
    for (int i = 0; i < population.length; i++) {
       if(population[i].getFitness() > record) {
         record = population[i].getFitness();
       }
    }
    return record;
  }

}
