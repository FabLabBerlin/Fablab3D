import controlP5.*;
import apwidgets.*;
import nervoussystem.obj.*;

// for android
import android.media.AudioRecord;
import android.media.AudioFormat;
import android.media.MediaRecorder;
import android.media.MediaPlayer;
import android.os.Environment;
import android.content.Context;
import android.os.Looper; 
import android.widget.Toast;  
import android.view.inputmethod.InputMethodManager;
import android.view.inputmethod.EditorInfo;
import android.text.InputType;

// screenshot stuff
import java.nio.IntBuffer;
import android.opengl.GLES20;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
//import android.graphics.BitmapFactory;
import java.io.FileOutputStream;

PFont f_bold, f_regu, f_regu_small, f_regu_big;
float sw, sh, image_scale;

Recorder recorder;

// some helpers to know what we are doing 
boolean load_sequence = false;
boolean load_mail_sequence = false;
boolean preview_sequence = false;
boolean mail_sequence = false;
boolean email_error = false;
boolean done_sequence = false;

//frame rate
int frame_rate = 30;

// parameter retreaved from recording
PVector[] p;

// trinket stuff
Trinket t;
int trinket_height = 40;

// flower stuff
Flower f;

// shape to load
PShape s; 
String shape;

// filenames
String mOBJFileName = null;
String mPNGFileName = null;

void setup() {
  // for android
  size(displayWidth, displayHeight, P3D);
  orientation(PORTRAIT);
  sw = displayWidth;
  sh = displayHeight;
  frameRate(frame_rate);
  
  // uncomment for desktop
//  size( 400, round(400*1.65), P3D);
//  sw = width;
//  sh = height;
  
  smooth();
  ortho();

  // load fonts
  f_bold = loadFont("fonts/Roboto-Bold-48.vlw");
  f_regu = loadFont("fonts/Roboto-Regular-32.vlw");
  f_regu_small = loadFont("fonts/Roboto-Regular-28.vlw");
  f_regu_big = loadFont("fonts/Roboto-Regular-48.vlw");
  
  recorder = new Recorder();
  
  gui_setup();
  
  // store files on SD Card
  mOBJFileName = Environment.getExternalStorageDirectory().getAbsolutePath();
  mOBJFileName += "/audio2flower.obj";
  
  mPNGFileName = Environment.getExternalStorageDirectory().getAbsolutePath();
  mPNGFileName += "/audio2flower.png";
  
}
  

void draw() {
  ortho();
  background(255);
  pushMatrix();
  pushStyle();
  
  if (mail_sequence) {
    background(255,0,0);
  } else {
    translate(0,0,-100);
    image(i_background, 0, 0);
  }
  
  popStyle();
  popMatrix();
  
  if ( load_sequence) {
    loader_sequence_draw();
  }
  if(load_mail_sequence) {
    loader_mail_sequence_draw();
  }
  
  gui_messages(); 
  
}


void onDestroy() {
  super.onDestroy();
  recorder.destroy();
}
