import java.io.*;
import java.util.*; 

boolean[][] Current;
boolean[][] Next;
int w;
int h;
int size;
int rate;
int counter = 0;
boolean CanDraw,keydown;

int R = floor(random(20,250)),G = floor(random(20,250)),B = floor(random(20,250));
int rs = 1;
int gs = 1;
int bs = 1;

void setup()
{
  fullScreen();
  //size(1920,1080);
  frameRate(1000);
  
  size = 160;
  rate = 1;
  
  CanDraw = false;
  keydown = false;
 
  size = height/size;
  println("size: "+size);
  w = width/size;
  h = height/size;
  //println("width = "+w);
  //println("height = "+h);
  stroke(10);
  //noStroke();
  fill(0);
  
  Current = new boolean[w][h];
  
  try
  { 
    //10,10
     FromFile(0,0); 
  } 
  catch(Exception e) 
  { 
      System.out.println(e); 
  } 
}


void InitialiseArray()
{
  for(int i=0;i<w;i++)
  {
    for(int j=0;j<h;j++)
    {
      if(j==h/2)
      {
        int ad = 10;
        if((i >= 1+ad && i <= 8+ad) || (i >= 10+ad && i <= 14+ad) || (i >= 18+ad && i <= 20+ad) || (i >= 27+ad && i <= 33+ad) || (i >= 35+ad && i <= 39+ad))
          Current[i][j] = true;
        else
          Current[i][j] = false;               
      }
      else
        Current[i][j] = false;
        //Current[i][j] = floor(random(0,2)) == 0 ? true:false; //use random
    }
  }
}


void FromFile(int xoff,int yoff) throws Exception
{
  List<String> ls = new ArrayList<String>();
  
 
  BufferedReader br = new BufferedReader(new FileReader("Path to pattern.txt file, 1 = set,  anything else = unset"));
    try 
    {
        String line = br.readLine();
        while (line != null) 
        { 
            ls.add(line);       
            line = br.readLine();
        }             
    } 
    finally 
    {
        br.close();
    }
     
    for(int i=0;i<w;i++)
    {
      for(int j=0;j<h;j++)
      {        
        if(i >= xoff && j >= yoff)
        {
          if( j - yoff < ls.size() && i - xoff < ls.get(j-yoff).length())
          {        
            Current[i][j] = (ls.get(j-yoff).charAt(i-xoff) == '1') ? true:false;
          }           
        }
        else
          Current[i][j] = false;          
      }
    }    
}
 
void draw()
{ 
  for(int i=0;i<w;i++)
  {
     for(int j=0;j<h;j++)
     {
       if(Current[i][j])
         fill(R,G,B);
       else
         fill(0);
         
       rect(i*size,j*size,size,size);
     }
  }
  
 if(CanDraw && counter%rate==0)
 {
    ChangeColor();
    GameOfLife();    
 }
  
  if(counter%1==0)
    surface.setTitle("FPS: " + frameRate+ " Speed:"+ rate);
    
   counter++;
   
  if(counter == 5000)
     counter = 0;   
}

void keyPressed()
{
  if(keyCode == BACKSPACE)
  {
    for(int i=0;i<w;i++)  
      for(int j=0;j<h;j++)        
        Current[i][j] = false;           
  } 
  keydown = true;
}
void keyReleased()
{
  keydown = false;
}
void mouseDragged() 
{
  if(keydown)
     mouseOperation(false,true);
  else
     mouseOperation(false,false);   
}
void mousePressed() 
{
  mouseOperation(true,false);
}
void mouseWheel(MouseEvent event) 
{
  int e = (int)event.getCount();
  if(e == 1)
  {
    rate += 1;
  }
  else
  {
    if(rate > 1)
    {
      rate--;
    }
      
  }
}

void mouseOperation(boolean change,boolean Del)
{
  int x = floor(mouseX/size);
  int y = floor(mouseY/size);
  
  if(x < w && y <h && x > -1 && y > -1)
  {
    boolean flip = Current[x][y] ? false : true;
     
      if (mouseButton == LEFT)
      {
        if(Del)
          Current[x][y] = false;
        else if (change)
          Current[x][y] = flip;
        else
          Current[x][y] = true;
        CanDraw = false;
      }
      if(mouseButton == RIGHT)   
        CanDraw = true;                 
  }
}
  

void ChangeColor()
{
   int addr = floor(random(0,5));
   int addg = floor(random(0,5));
   int addb = floor(random(0,5));
   
   
   if(R > 255-addr)    
     rs = -1;
   if(R < addr || R < 10)
     rs = 1;
     
   if(G > 255-addg)    
     gs = -1;
   if(G < addg || G < 10)
     gs = 1;
     
   if(B > 255-addb)    
     bs = -1;
   if(B < addb || B < 10)
     bs = 1;
   
   R += addr*rs; 
   G += addg*gs; 
   B += addb*bs; 
   
     
   if(R > 255 || G > 255 || B > 255)
       println("R:"+R+"  G:"+G+"  B:"+B);
   if(R < 0 || G < 0 || B < 0)
       println("R:"+R+"  G:"+G+"  B:"+B);
}

void GameOfLife()
{    
   Next = new boolean[w][h];
   
  for(int i=0;i<w;i++)
  {
     for(int j=0;j<h;j++)
     {                
      boolean Alive = Current[i][j]; 
           
     int neighbours = 0;  
     for(int ii=-1;ii<2;ii++)
     {
       for(int jj=-1;jj<2;jj++)
       {
         if(ii == 0 && jj == 0)
           continue;                                 
         //if(Current[(i + ii + w) % w][(j + jj + h) % h])//wrap around  
         
         int  xclamp = (i + ii);
         int  yclamp = (j + jj);
         
         if(xclamp >= w || yclamp >= h || xclamp < 0 || yclamp < 0)
           continue;
         
        
         
         if(Current[xclamp][yclamp])
           neighbours++;                    
       }
     }        
                    
    if(!Alive && neighbours == 3)
      Next[i][j] = true;            
    else if(Alive && (neighbours < 2 || neighbours > 3))
             Next[i][j] = false;         
    else
      Next[i][j] = Alive; 
     }
  }
  Current = Next;
}
