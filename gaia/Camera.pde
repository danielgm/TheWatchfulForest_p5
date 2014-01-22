
// Maximum time for a full range motion: 5 sec.
class Camera {
  String cameraId;
  
  int[] panRange;
  int[] tiltRange;
  
  float pan;
  float tilt;
  
  float panStart;
  float tiltStart;
  
  float panTarget;
  float tiltTarget;
  
  int animationStart;
  int animationDuration;
  
  int wakeTime;
  Boolean hasTarget;
  
  Camera(String _cameraId, int[] _panRange, int[] _tiltRange) {
    cameraId = _cameraId;
    panRange = _panRange;
    tiltRange = _tiltRange;
    
    setPanTilt(0.5, 0.5);
    setPanTiltTarget(0.5, 0.5);
    
    wakeTime = millis();
    hasTarget = false;
  }
  
  int getPan() {
    return floor(pan);
  }
  
  int getTilt() {
    return floor(tilt);
  }
  
  void setPanTilt(float x, float y) {
    pan = map(x, 0, 1, panRange[0], panRange[1]);
    tilt = map(y, 0, 1, tiltRange[0], tiltRange[1]);
  }
  
  void setPanTiltTarget(float p, float t) {
    println("Camera " + cameraId + " current pan/tilt: " + str(floor(pan)) + ", " + str(floor(tilt)));
    
    panStart = pan;
    tiltStart = tilt;
    panTarget = map(p, 0, 1, panRange[0], panRange[1]);
    tiltTarget = map(t, 0, 1, tiltRange[0], tiltRange[1]);
    
    println("Camera " + cameraId + " target pan/tilt: " + str(floor(panTarget)) + ", " + str(floor(tiltTarget)));

    animationDuration = getDuration(panStart, tiltStart, panTarget, tiltTarget);
    animationStart = millis();
    hasTarget = true;
  }
  
  Boolean isAnimationComplete() {
    return abs(panTarget - pan) < 5 && abs(tiltTarget - tilt) < 5;
  }
  
  void update() {
    int now = millis();
    pan = easeInOut(now - animationStart, panStart, panTarget - panStart, animationDuration);
    tilt = easeInOut(now - animationStart, tiltStart, tiltTarget - tiltStart, animationDuration);
    
    println("Camera " + cameraId + " pan/tilt: " + str(floor(pan)) + ", " + str(floor(tilt))
      + "\t\tstart=" + str(now - animationStart));
    
    float safePan = constrain(pan, panRange[0], panRange[1]);
    if (pan != safePan) {
      println("WARN Camera " + cameraId + " pan constrained to " + str(floor(safePan)));
      pan = safePan;
    }
    
    float safeTilt = constrain(tilt, tiltRange[0], tiltRange[1]);
    if (tilt != safeTilt) {
      println("WARN Camera " + cameraId + " tilt constrained to " + str(floor(safeTilt)));
      tilt = safeTilt;
    }
    
    hasTarget = !isAnimationComplete();
  }
  
  void sleep(int ms) {
    wakeTime = millis() + ms;
  }
  
  Boolean isAsleep() {
    return millis() < wakeTime;
  }
  
  Boolean hasTarget() {
    return hasTarget;
  }
  
  
  /**
   * Calculate duration of animation given initial and final pan/tilt.
   */
  int getDuration(float p0, float t0, float p1, float t1) {
    float dPan = p1 - p0;
    float dTilt = t1 - t0;
    float delta = sqrt(dPan * dPan + dTilt * dTilt);
    
    float rPan = panRange[1] - panRange[0];
    float rTilt = tiltRange[1] - tiltRange[0];
    float rDelta = sqrt(rPan * rPan + rTilt * rTilt);
    
    return floor(map(delta / rDelta, 0, 1, 1000, 3500));
  }
  
  /**
   * Thanks, Penner!
   * @see https://github.com/jesusgollonet/processing-penner-easing/blob/master/src/Quart.java
   *
   * t: current time, b: begInnIng value, c: change In value, d: duration
   */
  float  easeIn(float t,float b , float c, float d) {
    return c*(t/=d)*t*t*t + b;
  }
  
  float  easeOut(float t,float b , float c, float d) {
    return -c * ((t=t/d-1)*t*t*t - 1) + b;
  }
  
  float  easeInOut(float t,float b , float c, float d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
    return -c/2 * ((t-=2)*t*t*t - 2) + b;
  }
}
