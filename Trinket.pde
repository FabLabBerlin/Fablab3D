class Trinket {

  PVector start_pos;     // start position X,Y
  PVector[] contour;     // vector list holding contour
  PVector[] param;           // input parameter from pcm data
  int segm, sides;       // segments and sides of sphere like form 
                         // segments must be 18,36  
  int sizeZ;             // total height
 
   Trinket(PVector pos, PVector[] parameter, int segments, int sides_Z, int size_Z) {
     start_pos = pos.get();
     param = parameter;
     segm = segments;
     sides = sides_Z;
     sizeZ = size_Z;
     getXZContour();
   } 
 

    
  public void draw() {    
    float angle = 360 / sides;
 
 
    //draw torus 
    float tposY = contour[contour.length-1].y + 4;
    pushMatrix();
    translate(0,0,tposY);
    rotateZ(PI/2);
    drawTorus(4,2.5,20,20,1);
    popMatrix();
 
     
    pushStyle();
    noStroke();
    noFill();
 
    // draw top shape
    beginShape();
    for (int j = 0  ; j < sides; j++) {
        float x = cos( radians( j * angle ) ) * (contour[contour.length-1].x - start_pos.x);
        float y = sin( radians( j * angle ) ) * (contour[contour.length-1].x - start_pos.x);
        vertex( x, y,(contour[contour.length-1].y));  
    }
    endShape(CLOSE);
    for (int i = 0; i < contour.length-1; i++) {
      // draw body
      if ( i == 0 ) {
        beginShape(TRIANGLE_STRIP);
        for (int j = sides + 1; j > 0; j--) {
          float x1 = cos( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float y1 = sin( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float x2 = cos( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
          float y2 = sin( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
         
          vertex( x2 + start_pos.x, y2, contour[i+1].y - 0.25);
          vertex( x1 + start_pos.x, y1, contour[i].y);  
        }
        endShape(CLOSE);
      
      } else if ( i == contour.length-2) {
        beginShape(TRIANGLE_STRIP);
        for (int j = sides + 1; j > 0; j--) {
          float x1 = cos( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float y1 = sin( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float x2 = cos( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
          float y2 = sin( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
          vertex( x2 + start_pos.x, y2, contour[i+1].y);
          vertex( x1 + start_pos.x, y1, contour[i].y - 0.25);  
        }
        endShape(CLOSE);
      
      } else {
        beginShape(TRIANGLE_STRIP);
        for (int j = sides + 1; j > 0; j--) {
          float x1 = cos( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float y1 = sin( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float x2 = cos( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
          float y2 = sin( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
          
          vertex( x1 + start_pos.x, y1, contour[i].y + 0.25);
          vertex( x1 + start_pos.x, y1, contour[i].y - 0.25);
         
        }
        endShape(CLOSE);
        beginShape(TRIANGLE_STRIP);
        for (int j = sides + 1; j > 0; j--) {
          float x1 = cos( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float y1 = sin( radians( j * angle ) ) * (contour[i].x - start_pos.x);
          float x2 = cos( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
          float y2 = sin( radians( j * angle ) ) * (contour[i+1].x - start_pos.x);
          vertex( x2 + start_pos.x, y2, contour[i+1].y - 0.25);
          vertex( x1 + start_pos.x, y1, contour[i].y + 0.25);   
        }
        endShape(CLOSE);
      } 
    } 
    // draw bottom shape
    beginShape();
    for (int j = sides; j > 0; j--) {
        float x = cos( radians( j * angle ) ) * (contour[0].x - start_pos.x);
        float y = sin( radians( j * angle ) ) * (contour[0].x - start_pos.x);
        vertex( x, y, contour[0].y);
    }
    endShape(CLOSE);
    
    popStyle();
    
  }
  
  // creates XZ contour from param
  private void getXZContour() {
    contour = new PVector[(param.length)+3];
    float segm_height_increase = (float)sizeZ/(float)(param.length+1);
    float segm_height = start_pos.y;
      
    contour[0] = new PVector(5,segm_height);
    segm_height += segm_height_increase;
    
    for ( int i = 0; i < param.length; i++) {
      contour[i+1] = new PVector(param[i].x,param[i].y);
      
      // make shure all angels ar bigger than 30 degree
      float angle = getAngle(contour[i], contour[i+1], new PVector((contour[i].x * 2),contour[i].y));
      if(angle < 40) {
        PVector h = PVector.fromAngle(radians(40));
        float diff_fac = (contour[i+1].x - contour[i].x) / h.x;
        h.mult(diff_fac);
        h.add(contour[i]);
        contour[i+1] = h;
      } else if ( angle > 140) {
        PVector h = PVector.fromAngle(radians(140));
        float diff_fac = (contour[i+1].x - contour[i].x) / h.x;
        h.mult(diff_fac);
        h.add(contour[i]);
        contour[i+1] = h;
      }
      segm_height += segm_height_increase;
    }
    contour[contour.length-2] = new PVector(2.5,segm_height);
    segm_height += 2;
    contour[contour.length-1] = new PVector(2.5,segm_height);
  }
  
  // creates XZ contour line with arc's between param
  private void getXZContour_arc() {

    PVector lpos, npos;                 // last and next point
    float x_middle = start_pos.x;       // middle of curve 
    float angle, angle_step, angle_rad; // angle of arc 
    int array_c = 0;
    
    contour = new PVector[(param.length*segm)-segm];
    lpos = new PVector(start_pos.x+param[0].x,start_pos.y);
    npos = new PVector();
    
    // skip first ellement
    for(int i=1; i < param.length; i++) {
      npos.set(start_pos.x + param[i].x, lpos.y + (sizeZ/(param.length -1)  ));
      println(npos);  
      PVector center = getArcCenter(lpos,npos,new PVector(x_middle,0),new PVector(x_middle, height));
      float radius = center.dist(lpos);
  
      angle = getAngle(center, npos, lpos);
      angle_rad = radians(angle);
      angle_step = angle_rad/segm;

      for (int j = 0; j<segm; j++) {
        float x = center.x+((lpos.x - center.x)*cos(angle_step*j))+((center.y-lpos.y)*sin(angle_step*j));
        float y = center.y+((lpos.y-center.y)*cos(angle_step*j))+((lpos.x-center.x)*sin(angle_step*j));
          
        contour[array_c] = new PVector(x,y);
        array_c++;
      }   
      lpos = npos.get();  
    }
  }
  
  // find intersection between line p1-p2 and m1-m2
  private PVector getArcCenter(PVector p1, PVector p2, PVector m1, PVector m2) {
    // first get the center between the two points
    PVector c1 = new PVector( ((p1.x + p2.x)/2), ((p1.y + p2.y)/2));
    
    PVector c2;
    // get a new point that is 45deg from c1 and p1 or p2
    if ( p1.x < p2.x ) {
      c2 = new PVector( (c1.x + (p2.y - c1.y)), (c1.y - (p2.x - c1.x)));
    } 
    else { 
      c2 = new PVector( (c1.x + (p2.y - c1.y)), (c1.y - (p2.x - c1.x)));
    }
    
    // now calculate where the lines passing c1-c2 and m1-m2 intersect
    float bx = m2.x - m1.x;
    float by = m2.y - m1.y;
    float dx = c2.x - c1.x;
    float dy = c2.y - c1.y; 
    float b_dot_d_perp = bx*dy - by*dx;
    if(b_dot_d_perp == 0) {
      return null;
    }
    float cx = c1.x-m1.x; 
    float cy = c1.y-m1.y;
    float t = (cx*dy - cy*dx) / b_dot_d_perp; 
  
    return new PVector(m1.x+t*bx, m1.y+t*by); 
  
  }
  
  // function to calculate the angle using three points.
  private float getAngle(PVector v1, PVector v2, PVector v3) {
    float l1x = v2.x - v1.x;
    float l1y = v2.y - v1.y;
    float l2x = v3.x - v1.x;
    float l2y = v3.y - v1.y;
   
    float angle1 = (float)Math.atan2(l1y, l1x);
    float angle2 = (float) Math.atan2(l2y, l2x);
    float degree=degrees((float)angle1-(float)angle2);
   
    if (degree < 0) {
      degree += 360;
    }
    return degree;
  }
  
  private void drawTorus(float outerRad, float innerRad, int numc, int numt, int axis) {
    float x, y, z, s, t, u, v;
    float nx, ny, nz;
    float aInner, aOuter;
    int idx = 0;
    
    beginShape(QUAD_STRIP);
    for (int i = numc-1; i >= 0; i--) {
      for (int j = numt; j >= 0; j--) {
        t = j;
        v = t / (float)numt;
        aOuter = v * TWO_PI;
        float cOut = cos(aOuter);
        float sOut = sin(aOuter);
        for (int k = 1; k >= 0; k--) {
          s = (i + k);
          u = s / (float)numc;
          aInner = u * TWO_PI;
          float cIn = cos(aInner);
          float sIn = sin(aInner);
           
          if (axis == 0) {
            x = (outerRad + innerRad * cIn) * cOut;
            y = (outerRad + innerRad * cIn) * sOut;
            z = innerRad * sIn;
          } else if (axis == 1) {
            x = innerRad * sIn;
            y = (outerRad + innerRad * cIn) * sOut;
            z = (outerRad + innerRad * cIn) * cOut;           
          } else {
            x = (outerRad + innerRad * cIn) * cOut;
            y = innerRad * sIn;
            z = (outerRad + innerRad * cIn) * sOut;
          }           
           
          nx = cIn * cOut; 
          ny = cIn * sOut;
          nz = sIn;
           
          normal(nx, nx, nz);
          vertex(x, y, z);
        }  
      }
    }
    endShape();
  }

}
