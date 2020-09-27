int cols, rows;
int scl = 30;
int w = 8000;
int h = 6000;
float flying = 0;

float[][] terrain;
color[] sColorArr;
color[] fColorArr;

void setup() {
  // Set canvas size and use P3D as the renderer for this 3D sketch.
  size(1500, 1500, P3D);
  
  // Set number of rows and columns for the terrain array then initialize arrays to fit.
  cols = w/ scl;
  rows = h/ scl;
  terrain = new float[cols][rows];
  sColorArr = new color[rows];
  fColorArr = new color[rows];
  
  // Define foreground and background colors for the stroke and fill of the terrain.
  color s1 = color(255, 156, 94);
  color s2 = color(253, 94, 83);
  color f1 = color(49, 120, 115);
  color f2 = color(0, 170, 150);

  // Interpolate between the color values across the y axis.
  for (int y = 0; y < rows; y++) {
    sColorArr[y] = lerpColor(s1, s2, 1.0*y/rows);
    fColorArr[y] = lerpColor(f1, f2, 1.0*y/rows);
  }
}

void draw() {
  // Draw the background color and set coordinate translations for better viewing.
  // Play with these to expore the simulation from other angles. 
  background(252, 156, 84);
  translate(width/2, height/2);
  rotateX((5*PI)/12);
  translate(-w/5, -1.3*h);
  
  // Generate terrain array, shifting noise values by "flying" each frame.
  // Change yoff and xoff to play with how smooth the noise values will be.
  flying -= 0.01;
  float xoff = flying;
  for (int x = 0; x < cols; x++) {
    float yoff = 0;
    for (int y = 0; y < rows; y++) {
      // impose an x-coordinate dependance on the magnitude of the noise
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -x*15, x*15);
      yoff += 0.008;
    }
    xoff += 0.008;
  }

  // Draw each trangle strip across the x and y grid, setting each vertex's z value
  // from the perlin noise generated terrain array.
  for (int y = 0; y < rows-1; y++) {
    stroke(sColorArr[y]);
    fill(fColorArr[y]);
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    }
    endShape();
  }

  // Uncomment to save each frame as a png in a frames folder. These can be 
  // converted to a movie file using ffmpeg in your terminal with the command 
  // >> ffmpeg -r 30 -i %07d.png -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -vcodec libx264 out.mov
  //saveFrame("frames/#######.png");
}
