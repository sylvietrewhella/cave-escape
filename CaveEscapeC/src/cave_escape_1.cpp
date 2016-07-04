#include <stdio.h>
#include "SwinGame.h"

int main()
{
    open_graphics_window("Cave Escape", 432, 768);

    do
    {
      process_events();

      clear_screen(ColorWhite);
      refresh_screen();

    } while(!window_close_requested());

    return 0;
}
