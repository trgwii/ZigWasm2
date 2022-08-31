// Imports
// =======

extern "C" void _print(const char *ptr, unsigned int len);

// Helper
void print(const char *str) {
  unsigned int len = 0;
  while (str[len])
    len++;
  _print(str, len);
}

// Exports
// =======

// Controls
struct KeyState {
  bool pressed = false;
  bool changed = false;
};

struct Controls {
  struct KeyState up;
  struct KeyState left;
  struct KeyState down;
  struct KeyState right;
  struct KeyState space;
} ctl;

extern "C" void *getControls() { return &ctl; }
extern "C" unsigned int sizeOfControls() { return sizeof(ctl); }

// Screen
#define Width 960
#define Height 540

unsigned int screen[Width * Height];

extern "C" void *getScreen() { return &screen; }
extern "C" unsigned int sizeOfScreen() { return sizeof(screen); }
extern "C" unsigned int screenWidth() { return Width; }
extern "C" unsigned int screenHeight() { return Height; }

struct Game {
  double x = 100;
  double y = 100;
  double speed = 200;
} game;

// "Main"
extern "C" void updateAndRender(double delta) {
  double speed = 200;
  // Handle input
  if (ctl.space.pressed)
    game.speed = 500;
  else
    game.speed = 200;
  if (ctl.up.pressed)
    game.y -= game.speed * delta;
  if (ctl.left.pressed)
    game.x -= game.speed * delta;
  if (ctl.down.pressed)
    game.y += game.speed * delta;
  if (ctl.right.pressed)
    game.x += game.speed * delta;
  if (game.y < 0)
    game.y = 0;
  if (game.x < 0)
    game.x = 0;
  if (game.y > Height - 10)
    game.y = Height - 10;
  if (game.x > Width - 10)
    game.x = Width - 10;

  // Render
  for (unsigned int i = 0; i < sizeof(screen) / sizeof(screen[0]); i++) {
    // 0xAABBGGRR
    screen[i] = 0xFF000044;
  }
  for (unsigned int y = game.y; y < game.y + 10; y++) {
    for (unsigned int x = game.x; x < game.x + 10; x++) {
      unsigned int i = y * Width + x;
      if (i >= sizeof(screen))
        break;
      screen[i] = 0xFFFFFFFF;
    }
  }
}
