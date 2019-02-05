import processing.sound.SoundFile;

int puntuacionA,puntuacionB;
float sizePelota,pelotaX,pelotaY,xSpeed,ySpeed;
float sizePlayers,widthPlayers;
float posPlayerAX,posPlayerAY,posPlayerBX,posPlayerBY,speedPlayerA,speedPlayerB;
boolean keys[] = new boolean[128];

PFont f;
SoundFile rebote;
SoundFile choque;
SoundFile punto;

void setup() {
  size(400,400);
  fill(255);
  stroke(255);
  
  f = createFont("bit5x5.ttf",50);
  textFont(f);
  puntuacionA = 0;
  puntuacionB = 0;
  
  sizePelota = 10;
  pelotaX = width/2;
  pelotaY = 30;
  xSpeed = random(-3,3);
  ySpeed = 3;
  
  sizePlayers = 25;
  widthPlayers = 5;
  posPlayerAY = height/2 - 30;
  posPlayerBY = height/2 - 30;
  posPlayerAX = 40;
  posPlayerBX = width - 40;
  speedPlayerA = 10;
  speedPlayerB = 10;
  
  rebote = new SoundFile(this, "reboteParedes.wav");
  choque = new SoundFile(this,"choquePaletaPelota.wav");
  punto = new SoundFile(this,"loseSound.wav");
}

void draw() {
  background(0);
  dibujarEscenario();
  dibujarPlayers();
  dibujarPelota();
  
  movePlayerA();
  movePlayerB();
  moverPelota();
  
  choquePelotaRaqueta();
}

// Función para regresar a un estado inicial de la partida:
// - Jugadores en punto medio
// - Pelota partiendo hacia un sitio random desde el centro
// Se ejecuta cuando un jugador consigue un punto
void reinicio() {
  pelotaX = width/2;
  pelotaY = 30;
  xSpeed = random(-3,3);
  ySpeed = 3;
  
  posPlayerAY = height/2 - 30;
  posPlayerBY = height/2 - 30;
}

// Función para dibujar elementos estáticos del escenario:
// - Puntuaciones
// - Línea de separación de campos
// Link de la fuente: http://www.mattlag.com/bitfonts/
void dibujarEscenario() {
  for(int i = 60; i < height - 20; i += 20) {
      rect(width/2,i,5,10);
  }
  text(puntuacionA,width/4,50);
  text(puntuacionB,width/4 + width/2 - 20,50);
}

// Función para dibujar la pelota
void dibujarPelota() {
  ellipse(pelotaX,pelotaY,sizePelota,sizePelota);
}

// Función para dibujar las paletas de los jugadores
void dibujarPlayers() {
  rect(posPlayerAX,posPlayerAY,widthPlayers,sizePlayers);
  rect(posPlayerBX,posPlayerBY,widthPlayers,sizePlayers);
}

// Función para mover la pelota con rebotes
void moverPelota() {
  
  // Choca con alguna pared lateral
  pelotaX += xSpeed;  
  if (pelotaX > width) {
    puntuacionA++;
    punto.play();
    reinicio();
  }
  if (pelotaX < 0) {
    puntuacionB++;
    punto.play();
    reinicio();
  }
  
  // Choca con techo o suelo
  pelotaY += ySpeed;  
  if (pelotaY > height || pelotaY < 0) {
    ySpeed *= -1;
    rebote.play();
  }
}

// Función de control de PlayerA
void movePlayerA() {
  if(keyPressed) {
    
    // PlayerA se mueve hacia arriba
    if(key == 'w' && posPlayerAY > 0) {
      posPlayerAY += speedPlayerA * -1;
    }
    
    // PlayerA se mueve hacia abajo
    if(key == 's' && posPlayerAY + speedPlayerA*3 < height) {
      posPlayerAY += speedPlayerA;
    }
  }
}

// Función de control de PlayerB
void movePlayerB() {
  if(keyPressed) {
    if(key == CODED) {
      
      // PlayerB se mueve hacia arriba
      if(keyCode == UP && posPlayerBY > 0) {
          posPlayerBY += speedPlayerB * -1;
      }
      
      // PlayerB se mueve hacia abajo
      if(keyCode == DOWN && posPlayerBY + speedPlayerB*3 < height) {
          posPlayerBY += speedPlayerB;
      }
    }
  }
}

// Función para cambiar el movimiento de la pelota cuando choca con una paleta
void choquePelotaRaqueta() {
  
  // Choque contra la paleta izquierda
  if(pelotaX - sizePelota/2 < posPlayerAX + widthPlayers/2 && pelotaY - sizePelota/2 < posPlayerAY + sizePlayers/2 && pelotaY + sizePelota/2 > posPlayerAY - sizePlayers/2) { 
    if(xSpeed < 0) {
      choque.play();
      xSpeed *= -1;
    }
  }
  
  // Choque contra la paleta derecha
  else if(pelotaX + sizePelota/2 > posPlayerBX - widthPlayers/2 && pelotaY + sizePelota/2 > posPlayerBY - sizePlayers/2 && pelotaY - sizePelota/2 < posPlayerBY + sizePlayers/2) {
    if(xSpeed > 0) {
      choque.play();
      xSpeed *= -1;
    }
  }
}
