import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private static int NUM_ROWS = 20;
private static int NUM_COLS = 20;
private static int bombCount = 50;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean firstClick = true;
boolean flagging = false;
MyButton flagButton;
MyButton uncoverButton;
boolean finished = false;


void setup ()
{
    size(400, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    uncoverButton = new MyButton(0,400,200,100,"Uncover",false, color(190,147,117));
    flagButton = new MyButton(200,400,200,100,"Flag",true, color(238,45,123));
}
public void setMines(int cR, int cC)
{
    while(mines.size() < bombCount){
      int r = (int)(Math.random() * NUM_ROWS);
      int c = (int)(Math.random() * NUM_COLS);
      if(!mines.contains(buttons[r][c]) && 
      (r<cR-1 || r>cR+1 || c<cC-1 || c>cC+1)){
        mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage(8,6);
}

public boolean isWon()
{
    for(int i = 0; i < buttons.length; i++){
      for(int j = 0; j < buttons[i].length; j++){
        if(mines.contains(buttons[i][j])){
          continue;
        }
        else if(!buttons[i][j].isClicked()){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage(int r, int c)
{
  finished = true;
  for(MSButton b: mines){
    b.clicked = true;
  }
  String message = "You lose";
  for(int i = 0; i < message.length(); i++){
    buttons[r][c+i].clicked = false;
    buttons[r][c+i].flagged = true;
    buttons[r][c+i].setLabel(message.substring(i,i+1));
  }
}
public void displayWinningMessage(int r, int c)
{
  finished = true;
  String message = "You Win!";
  for(MSButton b: mines){
    b.flagged = true;
  }
  for(int i = 0; i < message.length(); i++){
    buttons[r][c+i].clicked = false;
    buttons[r][c+i].flagged = true;
    buttons[r][c+i].setLabel(message.substring(i,i+1));
  }
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
      return true;
    }
    return false;
}
public ArrayList<MSButton> returnValidNeighbours(int r, int c){
  ArrayList<MSButton> n = new ArrayList<MSButton>();
  MSButton clickedButton = buttons[r][c];
  for(int i = r - 1; i <= r+1; i++){
    for(int j = c - 1; j <= c+1; j++){
      if(isValid(i,j)){
        if(buttons[i][j] == clickedButton){
          continue;
        }
        n.add(buttons[i][j]);
      }
    }
  }
  return n;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  ArrayList<MSButton> neighbours = returnValidNeighbours(row,col);
  for(int i = 0; i < neighbours.size(); i++){
    if(mines.contains(neighbours.get(i))){
      numMines++;
    }
  }
  return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
       if(finished){
         return;
       }
       if(mouseButton == RIGHT || flagging){
        if(!clicked){
          flagged = !flagged;
          if(!flagged){
            clicked = false;
          }
        }
      } else if(mouseButton == LEFT){
        if(firstClick){
          setMines(myRow,myCol);
          firstClick = false;
        }
        if(!flagged){
          clicked = true;
          if(mines.contains(this)){
            displayLosingMessage(8,6);
          } else if(countMines(myRow,myCol) > 0) {
            setLabel(countMines(myRow,myCol));
          } else {
            for(MSButton b: returnValidNeighbours(myRow,myCol)){
              if(!b.clicked){
                b.mousePressed();
              }
            }
          }
        }
      }
    }
    public void draw () 
    {
      /*if(colorVersion == 0){
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
      }*/
      if (flagged)
      //Pink
          fill(238,45,123);    
      else if(clicked && mines.contains(this)) 
      //White
          fill(255);
      else if(clicked)
      //Beije
          fill(190,147,117);
      else 
      //Brown
          fill(59,20,18);
      rect(x, y, width, height);
      fill(0);
      textSize(10);
      text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public String getLabel(){
      return myLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked(){
      return clicked;
    }
}
public class MyButton {
  protected boolean clicked;
  protected float x,y,width,height;
  protected String myLabel;
  private boolean myVal;
  protected int myCol;
  public MyButton(float mx, float my, float mW, float mH, String ml, boolean mV, int mC) {
    width = mW;
    height = mH;
    x = mx;
    y = my;
    clicked = false;
    myLabel = ml;
    myVal = mV;
    myCol = mC;
    Interactive.add( this ); // register it with the manager
  }
  // called by manager
  public void mousePressed () 
  {
    if(mouseButton == LEFT)
      flagging = myVal;
  }
  public void draw(){
    fill(myCol);
    rect(x, y, width, height);
    fill(0);
    if(flagging == myVal){
      textSize(30);
    } else {
      textSize(20);
    }
    text(myLabel,x+width/2,y+height/2);
  }
}
