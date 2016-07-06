#include <stdio.h>
#include "SwinGame.h"

int main()
{
    open_graphics_window("Cave Escape", 432, 768);

    do // The game loop...
    {
      process_events();

      clear_screen(COLOR_WHITE);
      refresh_screen();

    } while(!window_close_requested());

    return 0;
}
