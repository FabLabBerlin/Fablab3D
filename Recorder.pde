class Recorder {
  final int RECORDER_SAMPLERATE = 44100;
  final int RECORDER_CHANNELG = AudioFormat.CHANNEL_IN_MONO;
  final int RECORDER_AUDIO_ENCODING = AudioFormat.ENCODING_PCM_16BIT;
  
  short[] bufferG;
  int bufferSizeG;
  int bufferSizeD;
  
  // buffer to hold the actuall recording
  short[] bufferRecordG;
  
  AudioRecord audioRecordG;
 
  // amount of max seconds the record is long
  final int recSeconds = 5;
  // wave Y-achsis center
  final float wave_y = sh/2-sh*0.05;
  // wave Y-achsis size
  final float wave_y_size = sh/3;
  final float wave_y_size_min = sh/5;
  // wave size per recording frame ( X-achis )
  final float sw_map_frame_size = sw/recSeconds/frame_rate;

  
  // some counter and fade effect helpers  
  int mFrameCount;
   
  // switch to turn recording on  
  boolean recording;
  
  Recorder() {
    mFrameCount = 1;
    
    bufferSizeG = AudioRecord.getMinBufferSize(RECORDER_SAMPLERATE, RECORDER_CHANNELG, RECORDER_AUDIO_ENCODING);
    audioRecordG = new AudioRecord(MediaRecorder.AudioSource.MIC, RECORDER_SAMPLERATE, RECORDER_CHANNELG, RECORDER_AUDIO_ENCODING, bufferSizeG);
    audioRecordG.startRecording();
    
    bufferG = new short[bufferSizeG];
    // make a recording buffer for 5 seconds
    // bufferRecordG = new short[bufferSizeG];
  
  }

  void display_noise() {
    // recording view animations with audio input
    int bufferReadResultG = audioRecordG.read(bufferG, 0, (bufferSizeG));
    pushMatrix();
    pushStyle();
  
    //strokeWeight(4*5);
    //fill(255,0,0);
    
    // fluid visualisation before recording
    for( int i = 0; i < (bufferReadResultG) -8; i += 12) {
      float disp_ix0 = map(i, 0, bufferReadResultG/8, 0, sw);
      float disp_ix1 = map(i+8, 0, bufferReadResultG/8, 0, sw);
      
      float disp_iy0 = map(bufferG[i], -32767.5, 32767.5, -wave_y_size, wave_y_size);
      float disp_iy1 = map(bufferG[i+8], -32767.5, 32767.5, -wave_y_size, wave_y_size);
      
      //line(disp_ix0, wave_y+(bufferG[i]/20), disp_ix1, wave_y+(bufferG[i+1]/20));   
      //line(disp_ix0, wave_y+disp_iy0, disp_ix1, wave_y+disp_iy1);
      noStroke();
      ellipse(disp_ix0, wave_y+disp_iy0, 16, 16);    
    }
    popStyle();
    popMatrix();
    
  }
  
  public void record_noise(int seconds) {
    int bufferReadResultG = audioRecordG.read(bufferG, 0, (bufferSizeG));
    pushMatrix();
    pushStyle();
    
    
    float sw_map_slot_size_finale = sw_map_frame_size*mFrameCount;      
    mFrameCount++;  
      
    bufferRecordG = concat(bufferRecordG, bufferG, bufferReadResultG);
  
    
    for( int i = 0; i < (bufferRecordG.length) -1000; i += 1000) {
            
      //float disp_i0 = map(i, 0, bufferRecordG.length, 0, sw_map_slot_size + (int)(sw_map_frame_size*(frame_rate-countDownFrames)));
      //float disp_i1 = map(i+1000, 0, bufferRecordG.length, 0, sw_map_slot_size + (int)(sw_map_frame_size*(frame_rate-countDownFrames)));
      //line(disp_i0, sh/2+(bufferRecordG[i]/20), disp_i1, sh/2+(bufferRecordG[i+1000]/20));
      
      float disp_ix0 = map(i, 0, bufferRecordG.length, 0, sw_map_slot_size_finale);
      float disp_iy0 = map(bufferRecordG[i], -32767.5, 32767.5, -wave_y_size, wave_y_size);
      
      //line(disp_ix0, wave_y+(bufferRecordG[i]/20), disp_ix0, wave_y-(bufferRecordG[i]/20));
      strokeWeight(6);
      line(disp_ix0, wave_y+disp_iy0, disp_ix0, wave_y-disp_iy0);    
    }
    for( int i = 0; i < (bufferReadResultG) -8; i +=100) {
      float disp_ix0 = map(i, 0, bufferReadResultG, sw_map_slot_size_finale, sw);
      float disp_ix1 = map(i+8, 0, bufferReadResultG, sw_map_slot_size_finale, sw);
      
      float disp_iy0 = map(bufferG[i], -32767.5, 32767.5, -wave_y_size, wave_y_size);
      float disp_iy1 = map(bufferG[i+8], -32767.5, 32767.5, -wave_y_size, wave_y_size);
      
      //line(disp_ix0, sh/2+(bufferG[i]/20), disp_ix1, sh/2+(bufferG[i+1]/20));
      //line(disp_ix0, wave_y+disp_iy0, disp_ix1, wave_y+disp_iy1);
      noStroke();
      ellipse(disp_ix0, wave_y+disp_iy0, 16, 16);      
    }
    
    popStyle();
    popMatrix();
  }
  
  void buffered_noise() {
    pushMatrix();
    pushStyle();
  
    //strokeWeight(4*5);
    //fill(255,0,0);
    
    // fluid visualisation before recording
    for( int i = 0; i < (bufferRecordG.length) -8; i += 100) {
      float disp_ix0 = map(i, 0, bufferRecordG.length, sw*0.1, sw-(sw*0.1));
      float disp_iy0 = map(bufferRecordG[i], -32767.5, 32767.5, -wave_y_size, wave_y_size);
      
      //line(disp_ix0, wave_y+(bufferG[i]/20), disp_ix1, wave_y+(bufferG[i+1]/20));   
      //line(disp_ix0, wave_y+disp_iy0, disp_ix1, wave_y+disp_iy1);
      strokeWeight(6);
      line(disp_ix0, wave_y+disp_iy0, disp_ix0, wave_y-disp_iy0);  
    }
    popStyle();
    popMatrix();
  
  }
  
  public PVector[] get_param(int steps) {
    int slice_size = round((bufferRecordG.length-1)/steps);
    //println("slice_size" + slice_size);
    PVector[] ret = new PVector[steps-2];
    for ( int i = 1; i < steps-1; i++) {
      float param_x = 2.5;
      float param_y = map(i*slice_size, 0, slice_size*(steps), 0, trinket_height);
      for ( int j = (i*slice_size) ; j < (i*slice_size) + slice_size; j++) {
        float sample = bufferRecordG[j];
        if (sample < 0) sample = -sample;
        sample = map(sample, 0, 32767.5/3, 2, 10.5);
        if( sample > param_x ) {
          param_x = sample;
          if ( param_x >10.5) param_x = 10.5;
          param_y = map(j, 0, slice_size*(steps), 0, trinket_height);
        }     
      }
      ret[i-1] = new PVector(param_x, param_y);
    }
    for( int i = 0; i<ret.length; i++) {
    //println("Vec: " + i  + "X: " + ret[i].x + "Y: " + ret[i].y);
    } 
    //println(ret.length);
    return ret;  
  } 
  
  public void empty_buffer() {
    bufferRecordG = new short[0];
    mFrameCount = 1;
  } 
  
  public void destroy() {
    audioRecordG.release();
    
  }
  
  public void cut_start() {
    int cut = 4096*3;
    int bLen = bufferRecordG.length-cut;
    short[] C= new short[bLen-1];
    System.arraycopy(bufferRecordG, cut+1, C, 0, bLen-1);
    bufferRecordG = C;
  }
  
  private short[] concat(short[] A, short[] B, int sizeB) {
    if (A == null) return B;
    if (B == null) return A;
    int aLen = A.length;
    //int bLen = B.length;
    int bLen = sizeB;
    short[] C= new short[aLen+bLen];
    System.arraycopy(A, 0, C, 0, aLen);
    System.arraycopy(B, 0, C, aLen, bLen);
    return C;
  }
}
