class Obstacle {
  PVector p1;
  PVector p2;
  
  Obstacle(PVector p1_, PVector p2_) {
    p1 = p1_;
    p2 = p2_;
  }
  
  void display() {
    strokeWeight(7);
    line(p1.x, p1.y, p2.x, p2.y);
  }
  
  boolean checkRocket(Rocket r) {
    float rx = r.position.x;
    float ry = r.position.y;
    
    float rocketd = dist(rx, ry, p1.x, p1.y) + dist(rx, ry, p2.x, p2.y);
    
    float lined = dist(p1.x, p1.y, p2.x, p2.y);
    
    if(abs(lined-rocketd)<0.5){return true;}
    
    return false;
  }
  
}
