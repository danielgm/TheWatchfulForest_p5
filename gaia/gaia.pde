import processing.serial.*;

ServoController sc;
ArrayList<Camera> cameras;

int time;

/*
0: 178-700
1: 290-580 (down-up)
2: 175-550
3: 334-642 (down-up)
4: 160-650
5: 230-460 (up-down)
*/

void setup() {
  size(640, 640);
  println(Serial.list());

  sc = new ServoController(new Serial(this, Serial.list()[0], 9600));
  cameras = new ArrayList<Camera>();
  populateCameras();

  time = millis();
}

void draw() {
  for (int i = 0; i < cameras.size(); i++) {
    Camera camera = cameras.get(i);
    
    if (!camera.isAsleep()) {
      if (!camera.hasTarget()) {
        camera.setPanTiltTarget(random(1), random(1));
      }
      
      camera.update();
      sc.set(i * 2, camera.getPan());
      sc.set(i * 2 + 1, camera.getTilt());
      
      if (camera.isAnimationComplete()) {
        camera.sleep(1500);
      }
    }
  }
  
}

void populateCameras() {
  Camera camera;
  
  camera = new Camera("0", range(178, 700), range(290, 580));
  cameras.add(camera);
  /*
  camera = new Camera("1", range(160, 650), range(340, 460)); // Inverted.
  cameras.add(camera);

  camera = new Camera("2", range(175, 550), range(335, 640));
  cameras.add(camera);
  //*/
}

int[] range(int low, int high) {
  int[] result = {low, high};
  return result;
}

