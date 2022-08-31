// Imports
// =======

#include <stdint.h>

#define U32 uint32_t
#define F32 float
#define F64 double

extern "C" void _print(const char *ptr, U32 len);

// Helper
void print(const char *str) {
  U32 len = 0;
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
extern "C" U32 sizeOfControls() { return sizeof(ctl); }

// Screen
#define Width 960
#define Height 540

U32 screen[Width * Height];

extern "C" void *getScreen() { return &screen; }
extern "C" U32 sizeOfScreen() { return sizeof(screen); }
extern "C" U32 screenWidth() { return Width; }
extern "C" U32 screenHeight() { return Height; }

struct Game {
  F32 x = 100;
  F32 y = 100;
  F32 speed = 200;
} game;

// "Main"
extern "C" void updateAndRender(F64 delta) {
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
  for (U32 i = 0; i < sizeof(screen) / sizeof(screen[0]); i++) {
    // 0xAABBGGRR
    screen[i] = 0xFF000044;
  }
  for (U32 y = game.y; y < game.y + 10; y++) {
    for (U32 x = game.x; x < game.x + 10; x++) {
      U32 i = y * Width + x;
      if (i >= sizeof(screen))
        break;
      screen[i] = 0xFFFFFFFF;
    }
  }
}
