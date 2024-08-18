import java.util.HashMap;

HashMap<String, Integer> coresCelulas;
HashMap<String, Integer> contadorCliques;

float zoom = 1.0, deslocamentoX = 0, deslocamentoY = 0;
int tamanhoCelula = 50;

boolean estaArrastando = false;
float inicioArrasteX, inicioArrasteY;

void setup(){
  size(800, 800);
  coresCelulas = new HashMap<String, Integer>();
  contadorCliques = new HashMap<String, Integer>();
  noLoop();
}

void draw(){
  background(255);
  desenharGrade();
}

void desenharGrade(){
  stroke(240);
  
  float tamanhoEfetivoCelula = tamanhoCelula * zoom;
  
  int inicioX = floor((deslocamentoX - width/2) / tamanhoEfetivoCelula) - 1;
  int fimX = ceil((deslocamentoX + width/2) / tamanhoEfetivoCelula) + 1;
  int inicioY = floor((deslocamentoX - height/2) / tamanhoEfetivoCelula) - 1;
  int fimY = ceil((deslocamentoX + height/2) / tamanhoEfetivoCelula) + 1;
  
  for(int x = inicioX; x <= fimX; x++){
    for(int y = inicioY; y <= fimY; y++){
      
      float telaX = x * tamanhoEfetivoCelula - deslocamentoX + width/2;
      float telaY = y * tamanhoEfetivoCelula - deslocamentoY + height/2;
      
      String chave = x + "," + y;
      int corCelula = coresCelulas.containsKey(chave) ? coresCelulas.get(chave) : color(255);
      
      fill(corCelula);
      rect(telaX, telaY, tamanhoEfetivoCelula, tamanhoEfetivoCelula);
    }
  }
}

void mousePressed(){
  estaArrastando  = false;
  inicioArrasteX = mouseX;
  inicioArrasteY = mouseY;
}

void mouseDragged(){
  float distanciaArraste = dist(inicioArrasteX, inicioArrasteY, mouseX, mouseY);
  if(distanciaArraste > 5){
    estaArrastando = true;
    deslocamentoX -= (mouseX - pmouseX) / zoom;
    deslocamentoY -= (mouseY - pmouseY) / zoom;
    redraw();
  }
}

void mouseReleased() {
  if (!estaArrastando) {
    float mundoX = (mouseX - width/2 + deslocamentoX) / zoom;
    float mundoY = (mouseY - height/2 + deslocamentoY) / zoom;
    
    int gradeX = floor(mundoX / tamanhoCelula);
    int gradeY = floor(mundoY / tamanhoCelula);
    
    String chave = gradeX + "," + gradeY;
    
    if (mouseButton == LEFT) {
      int conta = contadorCliques.containsKey(chave) ? contadorCliques.get(chave) : 0;
      conta = (conta + 1) % 6; // Reseta após 6 cliques
      contadorCliques.put(chave, conta);
      
      int novaCor;
      if (conta == 1) {
        novaCor = color(0); 
      } else if (conta == 2) {
        novaCor = color(0, 100, 0);
      } else if (conta == 3) {
        novaCor = color(255, 0, 0);
      } else if (conta == 4) {
        novaCor = color(0, 0, 255);
      } else if (conta == 5) {
        novaCor = color(247, 247, 50);
      } else {
        coresCelulas.remove(chave);
        contadorCliques.remove(chave);
        novaCor = color(255);
      }
      coresCelulas.put(chave, novaCor);
    } else if (mouseButton == RIGHT) {
      coresCelulas.remove(chave);
      contadorCliques.remove(chave);
    }
    
    redraw();
  }
}

void mouseWheel(MouseEvent evento) {
  float fatorEscala = 1.05;
  float novoZoom = (evento.getCount() < 0) ? zoom * fatorEscala : zoom / fatorEscala;
  
  novoZoom = constrain(novoZoom, 0.1, 5.0);
  
  float mouseXAntesZoom = (mouseX - width/2) / zoom + deslocamentoX;
  float mouseYAntesZoom = (mouseY - height/2) / zoom + deslocamentoY;
  
  zoom = novoZoom;
  
  float mouseXAposZoom = (mouseX - width/2) / zoom + deslocamentoX;
  float mouseYAposZoom = (mouseY - height/2) / zoom + deslocamentoY;
  
  deslocamentoX += mouseXAntesZoom - mouseXAposZoom;
  deslocamentoY += mouseYAntesZoom - mouseYAposZoom;
  
  redraw();
}
