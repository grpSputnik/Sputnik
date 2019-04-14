boolean isNonProcess = false; //Détermine le type de donnée à traiter (128*128 ou 32*32 features)

void settings() {
  if (isNonProcess)
    size(128, 128);
  else
    size(32, 32);
}

String[] np = {"nonprocessnum0island", "nonprocessnum3chaparral", "nonprocessnum11forest", "nonprocessnum20snowberg"};
String[] pp = {"preprocessnum0snowberg", "preprocessnum1island", "preprocessnum2forest", "preprocessnum4chaparral"};

void setup() {
  noLoop();
}

void draw() {
  if (isNonProcess) {
    //  ---=====  Non-Process  =====---
    for (String d : np) {                                          // Pour chaque fichier source (une image par fichier) :
      String[] cs = loadStrings("Nonprocess/" + d + ".txt");           //On charges les chaînes de caractères contenue dans le fichier
      loadPixels();
      for (int i = 0; i<128*128; i++) {
        int y = i%128;                                                 //On détermine la position x,y du pixel en cours de traîtement sur l'image
        int x = i-y*128;
        pixels[y * width + x] =                                        //On "recréer" le pixel en prenant les informations du fichier source
          color(Integer.parseInt(cs[i*3]), Integer.parseInt(cs[i*3+1]), Integer.parseInt(cs[i*3+2]));
      }
      updatePixels();
      saveFrame(d+".png");                                            //On sauvegarde l'image en format PNG
      
    }
  }
  //  ---=====  Pre-Process  =====---
  else {
    for (String d : pp) {                                         // Pour chaque fichier source (une image par fichier) :
      String[] cs = loadStrings("Preprocess/" + d + ".txt");          //On charges les chaînes de caractères contenue dans le fichier
      //println(cs.length);
      float min = 99999;
      float max = -99999;
      for (String a : cs) {                                            //On détermine le minimum et le maximum des valeurs de features pour chaque fichier  
        float b = Float.parseFloat(a);
        if (b > max)
          max = b;
        if (b < min)
          min = b;
      }
      loadPixels();
      for (int i = 0; i<32*32; i++) {
        int y = i%32;                                                //On détermine la position x,y du pixel en cours de traîtement sur l'image
        int x = i-y*32;
        color c = color(50, map(Float.parseFloat(cs[i]), min, max, 50, 255), map(Float.parseFloat(cs[i]), min, max, 128, 50));
        pixels[y * width + x] = c;                                   //On établit la couleur du pixel en cours de traitement en fonction de la valeur de la feature associé
                                                                     //Les couleurs sont dans un dégradé de bleu (min) et de jaune (max)
        
      }
      updatePixels();
      saveFrame(d+".png");                                           //On sauvegarde l'image en format PNG
    }
  }
}