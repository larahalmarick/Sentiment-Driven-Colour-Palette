import java.util.ArrayList;

ArrayList<Integer> colors;  // Array to hold color values
ArrayList<Float> sentiments; // Array to hold sentiment values
int numColors = 12; // Increased number of colors in the palette
String userInput = ""; // To store user input mood
PFont font; // Font for displaying text
float[] targetSizes; // Target sizes for smooth transitions
float[] currentSizes; // Current sizes for smooth transitions
ArrayList<Particle> particles; // Particle system

void setup() {
  size(1920, 1080);  // Set the window size to match the video resolution
  colors = new ArrayList<Integer>();
  sentiments = new ArrayList<Float>();
  targetSizes = new float[numColors];
  currentSizes = new float[numColors];
  particles = new ArrayList<Particle>(); // Initialize particle system
  font = createFont("Arial", 32, true); // Create a font

  // Initialise colors and sentiments
  for (int i = 0; i < numColors; i++) {
    colors.add(color(random(255), random(255), random(255))); // Random colors
    sentiments.add(random(1)); // Random sentiment values between 0 and 1
    targetSizes[i] = 150; // Increased default target size
    currentSizes[i] = targetSizes[i]; // Initialize current size
  }
}

void draw() {
  // Create a gradient background based on user input
  createGradientBackground();

  // Update sentiments and sizes based on user input
  updateSentimentsAndSizes();

  // Draw circles with animated sizes and movement
  for (int i = 0; i < numColors; i++) {
    fill(colors.get(i));
    float x = width / (numColors + 1) * (i + 1);
    float y = height / 2 + sin(radians(frameCount * 2 + i * 30)) * 100; // Vertical movement

    // Update current size smoothly towards target size
    currentSizes[i] += (targetSizes[i] - currentSizes[i]) * 0.1; // Smooth transition
    float size = currentSizes[i] * 1.5;
    ellipse(x, y, size, size); // Draw larger circles
    
    // Add pulsating effect based on sentiment
    float pulse = sin(radians(frameCount * 3 + i * 50)) * 10; // Pulsate effect
    ellipse(x, y, size + pulse, size + pulse); // Draw pulsating effect
  }

  // Draw particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isFinished()) {
      particles.remove(i); // Remove finished particles
    }
  }

  // Display user input mood
  textFont(font);
  fill(0);
  textSize(32);
  text("Mood: " + userInput, 20, 50); // Display the user mood input
}

// Create a gradient background based on the user mood
void createGradientBackground() {
  for (int i = 0; i <= height; i++) {
    float inter = map(i, 0, height, 0, 1);
    int c = lerpColor(color(255), color(200, 200, 255), inter); // Default gradient
    stroke(c);
    line(0, i, width, i);
  }
}

// Update sentiments and sizes based on user input
void updateSentimentsAndSizes() {
  if (userInput.length() > 0) {
    for (int i = 0; i < numColors; i++) {
      // Map mood to colors and sizes
      if (userInput.toLowerCase().contains("happy")) {
        colors.set(i, color(255, 223, 0)); // Bright Yellow for happy
        targetSizes[i] = 250; // Increase size for happy
      } else if (userInput.toLowerCase().contains("sad")) {
        colors.set(i, color(0, 0, 255)); // Deep Blue for sad
        targetSizes[i] = 75; // Decrease size for sad
      } else if (userInput.toLowerCase().contains("angry")) {
        colors.set(i, color(255, 0, 0)); // Bright Red for angry
        targetSizes[i] = 200; // Moderate size for angry
      } else if (userInput.toLowerCase().contains("excited")) {
        colors.set(i, color(255, 165, 0)); // Bright Orange for excited
        targetSizes[i] = 220; // Size for excited
      } else if (userInput.toLowerCase().contains("calm")) {
        colors.set(i, color(144, 238, 144)); // Soft Green for calm
        targetSizes[i] = 180; // Size for calm
      } else if (userInput.toLowerCase().contains("love")) {
        colors.set(i, color(255, 182, 193)); // Light Pink for love
        targetSizes[i] = 250; // Size for love
      } else if (userInput.toLowerCase().contains("confused")) {
        colors.set(i, color(230, 230, 250)); // Light Purple for confused
        targetSizes[i] = 150; // Size for confused
      } else if (userInput.toLowerCase().contains("nervous")) {
        colors.set(i, color(255, 255, 224)); // Pale Yellow for nervous
        targetSizes[i] = 170; // Size for nervous
      } else if (userInput.toLowerCase().contains("surprised")) {
        colors.set(i, color(255, 0, 255)); // Bright Magenta for surprised
        targetSizes[i] = 200; // Size for surprised
      } else if (userInput.toLowerCase().contains("bored")) {
        colors.set(i, color(139, 69, 19)); // Neutral Brown for bored
        targetSizes[i] = 80; // Size for bored
      } else {
        colors.set(i, color(random(255), random(255), random(255))); // Random for other moods
        targetSizes[i] = 150; // Default size
      }

      // Update sentiment values (for additional effects)
      sentiments.set(i, constrain(sentiments.get(i) + 0.1, 0, 1)); // Example of sentiment adjustment
    }
  }
}

// Handle user input
void keyPressed() {
  if (key == BACKSPACE) {
    if (userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1); // Remove last character
    }
  } else if (key == ENTER) {
    // Activate particles on mood submission
    activateParticles();
  } else {
    userInput += key; // Add the pressed key to user input
  }
}

// Activate particles when user submits their mood
void activateParticles() {
  for (int i = 0; i < 100; i++) { // Create 100 particles
    particles.add(new Particle(random(width), random(height))); // Random position
  }
}

// Particle class for creating effects
class Particle {
  float x, y; // Position
  float speedX, speedY; // Speed
  float lifespan; // Lifespan

  Particle(float startX, float startY) {
    x = startX;
    y = startY;
    speedX = random(-2, 2);
    speedY = random(-2, 2);
    lifespan = 255; // Initial lifespan
  }

  void update() {
    x += speedX;
    y += speedY;
    lifespan -= 5; // Reduce lifespan
  }

  void display() {
    fill(255, lifespan); // White color with fading effect
    noStroke();
    ellipse(x, y, 12, 12); // Draw particle
  }

  boolean isFinished() {
    return lifespan < 0; // Check if particle is finished
  }
}
