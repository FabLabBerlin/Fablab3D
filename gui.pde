
ControlP5 cp5;
ControlTimer timer0;

APWidgetContainer widgetContainer; 
APEditText nameField, emailField;

PImage i_background, i_record, i_pause, i_trinket, i_flower; 

Toggle b_rec;
Button b_trinket, b_flower, b_send, b_send_agb, b_restart;

int loader_sequence_rot, loader_sequence_rot_c, loader_sequence_step;

Mail m; 
 
void gui_setup() {
   
  // define scaling factor  
  image_scale = (sw/1100.8);
 
  // load images and scale
  i_background = loadImage("background/fablab_bg.png");
  i_background.resize(round(i_background.width*image_scale),0);
  
  i_record = loadImage("buttons/record.png");
  i_record.resize(round(i_record.width*image_scale),0);
  i_pause = loadImage("buttons/pause.png");
  i_pause.resize(round(i_pause.width*image_scale),0);
  
  i_trinket = loadImage("buttons/trinket.png");
  i_trinket.resize(round(i_trinket.width*image_scale),0);
  i_flower = loadImage("buttons/flower.png");
  i_flower.resize(round(i_flower.width*image_scale),0);
  
  // initialize rot vars for loader sequence
  loader_sequence_rot = 30;
  loader_sequence_rot_c = loader_sequence_rot;
  loader_sequence_step = 0;
  
  // initialise appWidget
  widgetContainer = new APWidgetContainer(this); 
  
  nameField = new APEditText(round(sw*0.35), round(sh*0.2), round(sw*0.6), round(sh*0.1)); //create a textfield from x- and y-pos., width and height
  nameField.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
  
  emailField = new APEditText(round(sw*0.35), round(sh*0.35), round(sw*0.6), round(sh*0.1)); //create a textfield from x- and y-pos., width and height
  emailField.setInputType(InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
  
  widgetContainer.addWidget(nameField);
  widgetContainer.addWidget(emailField); 
  widgetContainer.hide();
  
  // initialize p5
  cp5 = new ControlP5(this);
  
  // p5 font
  ControlFont pf_regu = new ControlFont(f_regu, 32);
  ControlFont pf_regu_big = new ControlFont(f_regu_big, 48);
  
  ControlFont pf_bold_big = new ControlFont(f_bold, 48);
  
  // create timer
  timer0 = new ControlTimer();
  timer0.setSpeedOfTime(1);
  
  // create a toggle for record/pause button
  b_rec = cp5.addToggle("rec_pause")
     .setPosition(sw/2-(i_record.width/2),(sh*0.7)-(i_record.height/2))
     .setSize(i_record)
     .setImage(i_record, cp5.DEFAULT)
     .setImage(i_record, cp5.OVER)
     .setImage(i_pause, cp5.ACTIVE)
     ;
     
   b_trinket = cp5.addButton("gen_trinket")
     .setPosition(sw/3-(i_trinket.width/2),sh*0.75-(i_trinket.height/2))
     .setSize(i_trinket)
     .setImage(i_trinket)
     .hide()
     ;  
     
   b_flower = cp5.addButton("gen_flower")
     .setPosition(sw/3*2-(i_flower.width/2),sh*0.75-(i_flower.height/2))
     .setSize(i_flower)
     .setImage(i_flower)
     .hide()
     ;  
    
    b_send = cp5.addButton("send")
     .setPosition(sw/2-sw*0.35,sh*0.7)
     .setSize(round(sw*0.7), round(sh*0.1))
     .hide()
     ;   
    
    b_send.getCaptionLabel()
     .setText("AN DRUCKER SENDEN")
     .setFont(pf_regu)
     .setSize(24)
     .align(CENTER,CENTER)
     ; 
     
    b_send.getColor()
     .setBackground(color(0))
     .setForeground(color(0))
     .setActive(color(0))
     ;
     
    b_send_agb = cp5.addButton("send_agb")
     .setPosition(sw/2-sw*0.45,sh*0.5)
     .setSize(round(sw*0.9), round(sh*0.1))
     .hide()
     ;   
    
    b_send_agb.getCaptionLabel()
     .setText("SENDEN UND AGB AKZEPTIEREN")
     .setFont(pf_bold_big)
     .setSize(28)
     .setColor(color(255,0,0))
     .align(CENTER,CENTER)
     ; 
     
    b_send_agb.getColor()
     .setBackground(color(255))
     .setForeground(color(255))
     .setActive(color(255))
     ;

    b_restart = cp5.addButton("restart")
     .setPosition(sw/2-sw*0.35,sh*0.85)
     .setSize(round(sw*0.7), round(sh*0.1))
     .hide()
     ;   
    
    b_restart.getCaptionLabel()
     .setText("NEU STARTEN")
     .setFont(pf_regu)
     .setSize(24)
     .align(CENTER,CENTER)
     ; 
     
    b_restart.getColor()
     .setBackground(color(0))
     .setForeground(color(0))
     .setActive(color(0))
     ;
     
}


// callbacks
void rec_pause(boolean theFlag) {
  if ( b_rec.isVisible()) {
    if (theFlag==true) {
      timer0.reset();
    } else {
      recorder.cut_start();
      b_rec.hide();
      b_trinket.show();
      b_flower.show();
    }
    println("a toggle event." + theFlag);
  }
}

void gen_trinket() {
  if (b_trinket.isVisible()) {
    println("gen trinket");
    shape = "trinket";
    b_trinket.hide();
    b_flower.hide();
    loader_sequence_start();
  }
}

void gen_flower() {
  if (b_flower.isVisible()) {
    println("gen flower");
    shape = "flower";
    b_trinket.hide();
    b_flower.hide();
    loader_sequence_start();
  }
}

void send() {
//   PImage screenshot = get(0,0,100,100);
//   screenshot.save(mPNGFileName);
   saveScreenShot(0, round(sh/4), int(sw), int(sh-(sh/4)));  
   // need to change background fast
   background(255,0,0);
   if ( preview_sequence ) {
     preview_sequence = false;
   }
   mail_sequence = true;
   b_send.hide();
   b_restart.hide();
   widgetContainer.show();
   b_send_agb.show(); 
}

void send_agb() {
  loader_mail_sequence_start();
//  Mail m = new Mail();
//  String[] toArr = {"ifa3d@fablab-berlin.org", emailField.getText()}; 
//  m.setTo(toArr); 
//  m.setFrom("ifa3d@fablab-berlin.org"); 
//  m.setSubject("[VODAFONE IFA 3D]"); 
//  m.setBody("Thanks for sending us your 3D creation named: " + nameField.getText() + "." );
 
//  try { 
//    String filename = "3d.obj";
//    m.addAttachment(mOBJFileName, filename); 
//    
//    if(m.send()) {
//      email_error = false;
//      b_send_agb.hide();
//      widgetContainer.hide();
//      mail_sequence = false;
//      done_sequence = true;
//      b_restart.show();
//      hideVirtualKeyboard();  
//      println("Email was sent successfully."); 
//    } else {
//      hideVirtualKeyboard();
//      email_error = true; 
//      println("Email was not sent."); 
//    } 
//  } catch(Exception e) { 
//    hideVirtualKeyboard();
//    email_error = true; 
//    println(e.toString());  
//  } 
}

void restart() {
  if(done_sequence) {
    done_sequence = false;
  }
  if(preview_sequence) {
    preview_sequence = false;
  }
  nameField.setText(new String(""));
  emailField.setText(new String(""));
  recorder.empty_buffer();
  b_send.hide();
  b_restart.hide();
  b_rec.setState(false);
  b_rec.show();
}


// gui messages
void gui_messages() {
  
  // messages for record screen
  if ( b_rec.isVisible()) {
    pushStyle();
    fill(0);
    textFont(f_regu, 32);
    textAlign(CENTER, CENTER);

    if ( b_rec.getState()) {
          
      timer0.update();
      
      // timer construct, when we reach 5 seconds we stop otherwhise we show current time in sec
      if (timer0.second() > 5) {
        rec_pause(false);
      } else {
        recorder.record_noise(timer0.second());
        text("NIMMT AUF...", sw/2, sh*0.87 );
        text(Integer.toString(5-timer0.second()), sw/2, sh*0.91 );
      }  
    
    } else {
      recorder.display_noise();
      text("AUFNAHME", sw/2, sh*0.87 );
      text("(5 sek.)", sw/2, sh*0.91 );
    }
    popStyle();
  }
  
  // message for shape choice
  if ( b_trinket.isVisible()) {
    pushStyle();
    fill(0);
    textFont(f_regu, 32);
    textAlign(CENTER, CENTER);
    text("WÄHLE EINE FORM", sw/2, sh*0.9 );  
    popStyle();
    recorder.buffered_noise();
  }
  
  // message for load sequence
  if (load_sequence) {
    pushStyle();
    fill(0);
    textFont(f_regu, 32);
    textAlign(CENTER, CENTER);
    text("ERSTELLE FORM...", sw/2, sh*0.9 );  
    popStyle();
  }
  
  
  // preview sequence 
  if ( preview_sequence) {
    pushMatrix();
    pushStyle();
    lights();
    ambientLight(102, 102, 102);
    
    translate(sw/2, sh/2);
    //rotateZ(radians(mouseX));
    //rotateX(radians(mouseY));
    
    //s.rotateY(radians(359));
    fill(0);
    if ( shape == "trinket" ) scale(6.5);
    if ( shape == "flower" ) scale(7.5);
    shape(s, 0,0);
    
    noLights(); 
    popStyle();
    popMatrix();
  }
  
  // email input
  if (mail_sequence) {
    String s = "Bitte gib einen Namen für Deine Kreation und Deine E-Mail-Adresse ein. So können wir Dir Dein Bild schicken. Danach werden Deine Daten vollständig gelöscht.."; 
    pushStyle();
    fill(255);
    rectMode(CENTER);
    textFont(f_regu_small, 24);
    textAlign(LEFT, TOP);
    text(s, sw/2, sh*0.12, sw-sw*0.15, sh*0.2 );  
    popStyle();
    pushStyle();
    fill(255);
    textFont(f_regu_big, 48);
    textAlign(LEFT, CENTER);
    text("NAME",round(sw*0.05), round(sh*0.2+sh*0.05));
    text("EMAIL",round(sw*0.05), round(sh*0.35+sh*0.05));
    popStyle();
    if(email_error) {
      String e = "Die Email konnte nicht versendet werden. Bitte überprüfe Deine E-Mail-Adresse und probiere es noch einmal."; 
      pushStyle();
      fill(255);
      rectMode(CENTER);
      textFont(f_regu_small, 24);
      textAlign(LEFT, TOP);
      text(e, sw/2, sh*0.8, sw-sw*0.15, sh*0.2 );  
      popStyle();
      pushStyle();
    }
  }
  
  // message for done sequence
  if (done_sequence) {
    pushMatrix();
    pushStyle();
    lights();
    ambientLight(102, 102, 102);
    
    translate(sw/2, sh/2);
    //rotateZ(radians(mouseX));
    //rotateX(radians(mouseY));
    
    //s.rotateY(radians(359));
    fill(0);
    if ( shape == "trinket" ) scale(6.5);
    if ( shape == "flower" ) scale(7.5);
    shape(s, 0,0);
    
    noLights(); 
    popStyle();
    popMatrix();
    
    //String s = "HERZLICHEN GLÜCKWUNSCH! DU KANNST DEINEN 3D-DRUCK IN CA. 1 STUNDE IM BLUMEN- LADEN ABHOLEN."; 
    String s = "HERZLICHEN GLÜCKWUNSCH! DU KANNST DEINEN 3D-DRUCK IN CA. 1 STUNDE IM FAB LAB BERLIN ABHOLEN.";
    pushStyle();
    fill(0);
    rectMode(CENTER);
    textFont(f_regu_big, 26);
    textAlign(LEFT, TOP);
    text(s, sw/2, sh*0.78, sw*0.7, sh*0.2 );
    popStyle();
  }
}

// loader sequence

void loader_mail_sequence_start() {
  timer0.reset();
  hideVirtualKeyboard();
  load_mail_sequence = true;
}


void loader_mail_sequence_draw() {
    
  // load circle
  pushMatrix();
  pushStyle();
  rectMode(CENTER);
  noStroke();
  
  translate(sw/2, sh*0.65);
  rotate(radians(loader_sequence_rot_c));

  for ( int i = 0; i <360/loader_sequence_rot; i++) {
    rotate(-radians(loader_sequence_rot));
    pushMatrix();
    pushStyle();
    translate(0,-24);
  
    //fill(255, i*24,i*24);
    fill(i*24,0,0,127);
    rect(0,0,6,18,3);
    popStyle();
    popMatrix();
  }
  
  popStyle();
  popMatrix();
 
  // change timer and loader_sequence_step in the moment it is 3*1 Second
  timer0.update();
  if (timer0.second() > 1) {
    timer0.reset();
    if ( loader_sequence_step == 0 ) {
       m = new Mail();
       String[] toArr = {"soundprinter@fablab-berlin.org", emailField.getText()}; 
       m.setTo(toArr); 
       m.setFrom("soundprinter@fablab-berlin.org"); 
       m.setSubject("Dein 3D-Objekt " + nameField.getText()); 
       m.setBody("Hallo, \n\n hier ist Dein individuelles 3D-Objekt, das Du mit der Fab Lab Berlin Soundprinter App erstellt hast. \n\n Der Name deiner Kreation ist " + nameField.getText() + ". \n\n Mit freundlichen Grüßen, \n\n\n Dein Fablab-Berlin Team \n\n\n" );
       loader_sequence_step++;
    } else if ( loader_sequence_step > 0 ) {
      try { 
        String filenameOBJ = emailField.getText() + ".obj";
        String filenamePNG = emailField.getText() + ".png";
        // addAttachment adds attachments before body, but we need it after
//        m.addAttachment(mOBJFileName, filenameOBJ); 
//        m.addAttachment(mPNGFileName, filenamePNG);
        String[][] attachements = {{mPNGFileName, filenamePNG}, {mOBJFileName, filenameOBJ}};
        m.setAttachmentAfterBody(attachements);
        
        if(m.send()) {
          email_error = false;
          b_send_agb.hide();
          widgetContainer.hide();
          mail_sequence = false;
          done_sequence = true;
          b_restart.show();
          println("Email was sent successfully."); 
        } else {
          email_error = true; 
          println("Email was not sent."); 
        } 
      } catch(Exception e) { 
        email_error = true; 
        println(e.toString());         
      } 
      
      load_mail_sequence = false; 
      loader_sequence_step = 0;
    } 
  }
  
  loader_sequence_rot_c = loader_sequence_rot_c + loader_sequence_rot;    
}

void loader_sequence_start() {
  timer0.reset();
  load_sequence = true;
}

void loader_sequence_draw() {
    
  // load circle
  pushMatrix();
  pushStyle();
  rectMode(CENTER);
  noStroke();
  
  translate(sw/2, sh*0.65);
  rotate(radians(loader_sequence_rot_c));

  for ( int i = 0; i <360/loader_sequence_rot; i++) {
    rotate(-radians(loader_sequence_rot));
    pushMatrix();
    pushStyle();
    translate(0,-24);
  
    //fill(255, i*24,i*24);
    fill(i*24);
    rect(0,0,6,18,3);
    popStyle();
    popMatrix();
  }
  
  popStyle();
  popMatrix();
   
  // change timer and loader_sequence_step in the moment it is 3*1 Second
  timer0.update();
  if (timer0.second() > 1) {
    timer0.reset();
    if ( loader_sequence_step > 3 ) {
      loader_sequence_load(loader_sequence_step);
      loader_sequence_step = 0;
      load_sequence = false;
    } else {
      loader_sequence_load(loader_sequence_step);
      loader_sequence_step++;
    }
  }
  
  loader_sequence_rot_c = loader_sequence_rot_c + loader_sequence_rot;    
}

void loader_sequence_load(int step) {
  if ( step == 0) {
    p = recorder.get_param(16);
//    for(int i = 0; i < p.length; i++) {
//      println(p[i].x + ":" + p[i].y);
//    }

    if ( shape == "trinket") t = new Trinket(new PVector(0,0), p, 2, 18, trinket_height);
    if ( shape == "flower") f = new Flower(p);
  } else if ( step == 1) {
    beginRecord("nervoussystem.obj.OBJExport", mOBJFileName);
    println("genObj");
    if ( shape == "trinket") t.draw();
    if ( shape == "flower") f.draw();
    endRecord();
  } else if ( step == 2) {
    s = loadShape(mOBJFileName);
    s.setFill(color(127));
    if ( shape == "trinket" ) s.rotateX(PI/2);
    if ( shape == "flower" ) s.rotateZ(PI);
    if ( shape == "flower" ) s.rotateX(radians(-20));
    if ( shape == "flower" ) s.rotateY(radians(-18));
    if ( shape == "flower" ) s.rotateZ(radians(-20));
    if ( shape == "trinket" ) s.translate(0,0,-(trinket_height/2));
    if ( shape == "flower" ) s.translate(0,-17.5,0);  
  } else if ( step == 4) {
    b_send.show();
    b_restart.show();
    preview_sequence = true;
  }
  
}


// show/hide keyboard

void showVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.SHOW_FORCED,0);
}

void hideVirtualKeyboard() 
{
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  if (imm.isAcceptingText()) {
    imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
  } else {
    println("Software Keyboard allready hidden");
  }
}

// screenshot

private void saveScreenShot(int x, int y, int w, int h) {
  Bitmap bmp = grabPixels(x, y, w, h);
  try {
//    File directory = new File (Environment.getExternalStorageDirectory() + "/screenshot");
//    directory.mkdirs();
//    String filename1 = "myscreenshot" + i + ".png";
//    File yourFile = new File(directory, filename1);
//     
//    while (yourFile.exists())
//    {
//        i++;   
//        filename1 = "screenshot" + i + ".png"; 
//        yourFile = new File(directory, filename1);
//    }   
//     
//    yourFile.createNewFile();
      
    //FileOutputStream fos = new FileOutputStream(yourFile);
    FileOutputStream fos = new FileOutputStream(mPNGFileName);
    bmp.compress(CompressFormat.PNG, 100, fos);
 
    fos.flush();
      
    fos.close();
      
    } catch (Exception e) {
        println(e.getStackTrace().toString());
    }
}  

private Bitmap grabPixels(int x, int y, int w, int h) {
    int b[] = new int[w * (y + h)];
    int bt[] = new int[w * h];
    IntBuffer ib = IntBuffer.wrap(b);
    ib.position(0);
      
    GLES20.glReadPixels(x, y, w, y + h, 
               GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, ib);
 
    for (int i = 0, k = 0; i < h; i++, k++) {
        for (int j = 0; j < w; j++) {
            int pix = b[i * w + j];
            int pb = (pix >> 16) & 0xff;
            int pr = (pix << 16) & 0x00ff0000;
            int pix1 = (pix & 0xff00ff00) | pr | pb;
            bt[(h - k - 1) * w + j] = pix1;
        }
    }  
    Bitmap sb = Bitmap.createBitmap(bt, w, h, Bitmap.Config.ARGB_8888);
    return sb;
}
 


