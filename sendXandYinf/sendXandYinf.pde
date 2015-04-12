/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;  

Capture video;
OpenCV opencv;
OscP5 oscP5;
NetAddress myRemoteLocation;
float posx=0;
float posy=0;
float ancho=0;
float alto=0;

void setup() {
  size(400, 400);
  frameRate(25);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);



  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}


void draw() {
  //background(0); 
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 255);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);
  if (faces.length==1) {
    for (int i = 0; i < faces.length; i++) {
      posx=faces[i].x;
      posy=faces[i].y;
      ancho = faces[i].width;
      alto = faces[i].height;
      //    println(faces[i].x + "," + faces[i].y);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    enviarMensaje();
  }
}
void captureEvent(Capture c) {
  c.read();
}

void enviarMensaje() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");

  myMessage.add(posx); /* add an int to the osc message */
  myMessage.add(posy);
  myMessage.add(ancho);
  myMessage.add(alto);
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}

/**
 void mousePressed() {
/* in the following different ways of creating osc messages are shown by example */
/* OscMessage myMessage = new OscMessage("/test");
 
 myMessage.add(x); /* add an int to the osc message */
/*myMessage.add(y);
/* send the message */
/* oscP5.send(myMessage, myRemoteLocation); 
 }
 **/

/* incoming osc message are forwarded to the oscEvent method.*/
/*void oscEvent(OscMessage theOscMessage) {
  //print the address pattern and the typetag of the received OscMessage
  print(posx);
  print(posy);
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  float x_ = theOscMessage.get(0).floatValue();
  float y_ = theOscMessage.get(1).floatValue();
  println(x_ + " " + y_);
}*/
