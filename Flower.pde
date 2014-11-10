class Flower{

  PVector anch0, anch1, cont0, cont1;  
  PVector[] leave_out, leave_in, wave_shape, param;
  
  int faccets, flower_height;
  float line_width, line_width_wave;
  
  // fl_anch (-5<->7) flo_cont(3.5<->7)
  //Flower(float fl_anch, float fl_cont) {
  Flower(PVector[] param_pass) {
    
    param = param_pass;
    
    anch0 = new PVector(0,-17.5);
    anch1 = new PVector(1.5,-3.5);
    cont0 = new PVector(6.5,-14.5);
    cont1 = new PVector(5,-7);
    
    faccets = 20;
    flower_height = 4;
    line_width = 0.7;
    line_width_wave = 3;
    
    param_map();
    
    anch1.x = param[0].x;
    cont0.x = param[1].x;
    
    get_contour();
  }
  
  public void draw() {
    
    pushMatrix();
    translate(0,-anch0.y,0);
    // create hanger
    int sides = 36;
    float angle = 360 / sides;
    float tposY = anch0.y - 2.75;
    pushMatrix();
    translate(0,-tposY,0);
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j <= sides; j++) {
      float x1 = cos( radians( j * angle ) ) * (3.75);
      float y1 = sin( radians( j * angle ) ) * (3.75);
     
      vertex( x1, y1, 0);
      vertex( x1, y1, flower_height);  
    }
    endShape(CLOSE);
    beginShape(TRIANGLE_STRIP);
    for (int j = sides + 1; j > 0; j--) {
      float x1 = cos( radians( j * angle ) ) * (2.75);
      float y1 = sin( radians( j * angle ) ) * (2.57);
      vertex( x1, y1, 0);
      vertex( x1, y1, flower_height);  
    }
    endShape(CLOSE);
    beginShape(TRIANGLE_STRIP);
     for (int j = sides + 1; j > 0; j--) {
      float x1 = cos( radians( j * angle ) ) * (3.75);
      float y1 = sin( radians( j * angle ) ) * (3.75);
      float x2 = cos( radians( j * angle ) ) * (2.75);
      float y2 = sin( radians( j * angle ) ) * (2.75);
     
      vertex( x1, y1, 0);
      vertex( x2, y2, 0);
     }
    endShape(CLOSE);  
    beginShape(TRIANGLE_STRIP);
     for (int j = 0; j <= sides; j++) {
      float x1 = cos( radians( j * angle ) ) * (3.75);
      float y1 = sin( radians( j * angle ) ) * (3.75);
      float x2 = cos( radians( j * angle ) ) * (2.75);
      float y2 = sin( radians( j * angle ) ) * (2.75);
     
      vertex( x1, y1, flower_height);
      vertex( x2, y2, flower_height);
     }
    endShape(CLOSE);  
    popMatrix();
    
    
    // create 6 leaves
    for( int r = 0; r < 6 ; r++) { 
      pushMatrix();
      rotate(radians(r*60));
    
      // draw leave outside
      beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < leave_out.length; i++) {
            vertex( leave_out[i].x, leave_out[i].y, 0);
            vertex( leave_out[i].x, leave_out[i].y, flower_height);  
       }       
       endShape(CLOSE);
       beginShape(TRIANGLE_STRIP);
       for (int i = leave_out.length-1; i >= 0; i--) {
            vertex( -leave_out[i].x, leave_out[i].y, 0);
            vertex( -leave_out[i].x, leave_out[i].y, flower_height);  
       }       
       endShape(CLOSE);
       
       // draw leave inside
       beginShape(TRIANGLE_STRIP);
       for (int i = leave_in.length-1; i >= 0; i--) {
            vertex( leave_in[i].x, leave_in[i].y, 0);
            vertex( leave_in[i].x, leave_in[i].y, flower_height);  
       }       
       endShape(CLOSE);
       beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < leave_in.length; i++) {
            vertex( -leave_in[i].x, leave_in[i].y, 0);
            vertex( -leave_in[i].x, leave_in[i].y, flower_height);  
       }       
       endShape(CLOSE);
       
       // close leave bottom
       beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < leave_in.length; i++) {
            vertex( leave_in[i].x, leave_in[i].y, 0);
            vertex( leave_out[i].x, leave_out[i].y, 0);  
       }       
       endShape(CLOSE);
       beginShape(TRIANGLE_STRIP);
       for (int i = leave_in.length-1; i >= 0; i--) {
            vertex( -leave_in[i].x, leave_in[i].y, 0);
            vertex( -leave_out[i].x, leave_out[i].y, 0);  
       }       
       endShape(CLOSE);
  
       // close leave top
       beginShape(TRIANGLE_STRIP);
       for (int i = leave_in.length-1; i >= 0; i--) {
            vertex( leave_in[i].x, leave_in[i].y, flower_height);
            vertex( leave_out[i].x, leave_out[i].y, flower_height);  
       }       
       endShape(CLOSE);
       beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < leave_in.length; i++) {
            vertex( -leave_in[i].x, leave_in[i].y, flower_height);
            vertex( -leave_out[i].x, leave_out[i].y, flower_height);  
       }       
       endShape(CLOSE);  
       
      // close lower sides 
      beginShape(TRIANGLE_STRIP);
            vertex( leave_out[leave_out.length-1].x, leave_out[leave_out.length-1].y, 0);
            vertex( leave_out[leave_out.length-1].x, leave_out[leave_out.length-1].y, flower_height);
            vertex( leave_in[leave_in.length-1].x, leave_in[leave_in.length-1].y, 0); 
            vertex( leave_in[leave_in.length-1].x, leave_in[leave_in.length-1].y, flower_height);        
       endShape(CLOSE);
       beginShape(TRIANGLE_STRIP);
            vertex( -leave_in[leave_in.length-1].x, leave_in[leave_in.length-1].y, 0); 
            vertex( -leave_in[leave_in.length-1].x, leave_in[leave_in.length-1].y, flower_height);
            vertex( -leave_out[leave_out.length-1].x, leave_out[leave_out.length-1].y, 0);
            vertex( -leave_out[leave_out.length-1].x, leave_out[leave_out.length-1].y, flower_height);        
       endShape(CLOSE);  
       
      // create wave form 
      // outside faces
      beginShape(TRIANGLE_STRIP);
      for (int i = wave_shape.length-1; i >= 0; i--) {
            vertex( wave_shape[i].x, wave_shape[i].y, 0);
            vertex( wave_shape[i].x, wave_shape[i].y, flower_height);  
       }       
       endShape(CLOSE); 
       beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < wave_shape.length; i++) {
            vertex( -wave_shape[i].x, wave_shape[i].y, 0);
            vertex( -wave_shape[i].x, wave_shape[i].y, flower_height);  
       }       
       endShape(CLOSE);
        
       // inside faces 
       beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < wave_shape.length; i++) {
         if ( i == wave_shape.length-1) {
            vertex( 0, wave_shape[i].y+line_width_wave, 0);
            vertex( 0, wave_shape[i].y+line_width_wave, flower_height);
         } else if (i == 0) {
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, 0);
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, flower_height);
         }  else {
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, 0);
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, flower_height);
         }
       }       
       endShape(CLOSE); 
       beginShape(TRIANGLE_STRIP);
       for (int i = wave_shape.length-1; i >= 0; i--) {
         if ( i == wave_shape.length-1) {
            vertex( 0, wave_shape[i].y+line_width_wave, 0);
            vertex( 0, wave_shape[i].y+line_width_wave, flower_height);
         } else if (i == 0) {
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, 0);
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, flower_height);
         }  else {
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, 0);
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, flower_height);
         }
       }       
       endShape(CLOSE); 
       
       // bottom 
       beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < wave_shape.length; i++) {
         if ( i == wave_shape.length-1) {
            vertex( 0, wave_shape[i].y, 0);
            vertex( 0, wave_shape[i].y+line_width_wave, 0);
         } else if (i == 0) {
            vertex( wave_shape[i].x, wave_shape[i].y, 0);
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, 0);
         }  else {
            vertex( wave_shape[i].x, wave_shape[i].y, 0);
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, 0);
         }
       }
       endShape(CLOSE); 
       beginShape(TRIANGLE_STRIP);
       for (int i = wave_shape.length-1; i >= 0; i--) {
         if ( i == wave_shape.length-1) {
            vertex( 0, wave_shape[i].y, 0);
            vertex( 0, wave_shape[i].y+line_width_wave, 0);
         } else if (i == 0) {
            vertex( -wave_shape[i].x, wave_shape[i].y, 0);
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, 0);
         }  else {
            vertex( -wave_shape[i].x, wave_shape[i].y, 0);
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, 0);
         }
       }
       endShape(CLOSE);  
       
       // top
       beginShape(TRIANGLE_STRIP);
       for (int i = wave_shape.length-1; i >= 0; i--) {
         if ( i == wave_shape.length-1) {
            vertex( 0, wave_shape[i].y, flower_height);
            vertex( 0, wave_shape[i].y+line_width_wave, flower_height);
         } else if (i == 0) {
            vertex( wave_shape[i].x, wave_shape[i].y, flower_height);
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, flower_height);
         }  else {
            vertex( wave_shape[i].x, wave_shape[i].y, flower_height);
            vertex( wave_shape[i].x-line_width_wave, wave_shape[i].y, flower_height);
         }
       }
       endShape(CLOSE); 
       beginShape(TRIANGLE_STRIP);
       for (int i = 0; i < wave_shape.length; i++) {
         if ( i == wave_shape.length-1) {
            vertex( 0, wave_shape[i].y, flower_height);
            vertex( 0, wave_shape[i].y+line_width_wave, flower_height);
         } else if (i == 0) {
            vertex( -wave_shape[i].x, wave_shape[i].y, flower_height);
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, flower_height);
         }  else {
            vertex( -wave_shape[i].x, wave_shape[i].y, flower_height);
            vertex( -wave_shape[i].x+line_width_wave, wave_shape[i].y, flower_height);
         }
       }
       endShape(CLOSE);
       
       // close lower sides 
       beginShape(TRIANGLE_STRIP);
            vertex( wave_shape[0].x, wave_shape[0].y, 0);
            vertex( wave_shape[0].x, wave_shape[0].y, flower_height);
            vertex( wave_shape[0].x-line_width_wave, wave_shape[0].y, 0); 
            vertex( wave_shape[0].x-line_width_wave, wave_shape[0].y, flower_height);        
        endShape(CLOSE);
        beginShape(TRIANGLE_STRIP);
            vertex( -wave_shape[0].x+line_width_wave, wave_shape[0].y, 0);
            vertex( -wave_shape[0].x+line_width_wave, wave_shape[0].y, flower_height);
            vertex( -wave_shape[0].x, wave_shape[0].y, 0); 
            vertex( -wave_shape[0].x, wave_shape[0].y, flower_height);        
        endShape(CLOSE);
           
       popMatrix();
    }   
    popMatrix();
  }
  
  public void param_map() {
    
    // map param for leave
    param[0].x = map(param[0].x, 2.5, 10.5, -5, 7);
    param[1].x = map(param[1].x, 2.5, 10.5, 3.5, 7);
  
    // map param for wave;
    boolean inc = true;
    for (int i = 2 ; i < 7 ; i++) {
      param[i].x = map(param[i].x, 2.5, 10.5, 1, 8);
      param[i].y = map(param[i].y, param[1].y, param[7].y, 3, 16);
    }
  }
   
  
  private void get_contour() {
    
    leave_out = new PVector[faccets+1];
    for (int i = 0; i <= faccets; i++) {
      float t = i / float(faccets);
      float x = bezierPoint(anch0.x, cont0.x, cont1.x, anch1.x, t);
      float y = bezierPoint(anch0.y, cont0.y, cont1.y, anch1.y, t);
      leave_out[i] = new PVector(x,y);
     }
     leave_in = new PVector[faccets+1];
      for (int i = 0; i <= faccets; i++) {
      float t = i / float(faccets);
      float x = bezierPoint(anch0.x, cont0.x-(line_width*2), cont1.x-line_width, anch1.x-line_width, t);
      float y = bezierPoint(anch0.y+line_width, cont0.y+line_width, cont1.y-line_width, anch1.y, t);
      leave_in[i] = new PVector(x,y);
     }
     
     boolean inc = true;
     wave_shape = new PVector[7];
     wave_shape[0] = new PVector(1.3, -3);
     for (int i = 1; i < wave_shape.length-1; i++) {
       if (inc) {
         wave_shape[i] = new PVector(wave_shape[i-1].x + param[i+1].x, -param[i+1].y);
         inc = false;
       } else {
         wave_shape[i] = new PVector((wave_shape[i-1].x - param[i+1].x), -param[i+1].y);
         inc = true;
       }
     }
     wave_shape[6] = new PVector(0, -16.5);
  }
}
