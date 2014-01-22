
class ServoController {
  Serial port;
  
  ServoController(Serial _port) {
    println("start");
    port = _port;
  }
  
  void set(int servo, int value) {
    //println("set(" + str(servo) + ", " + str(value) + ")");
  
    port.write(str(servo));
    port.write(':');
    port.write(str(value));
    port.write(';');
  }
}
