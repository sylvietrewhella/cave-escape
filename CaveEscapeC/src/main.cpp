#include <stdio.h>
#include "SwinGame.h"

int main()
{
    open_graphics_window("Circle Moving", 800, 600);
    
    clear_screen(ColorWhite);
    refresh_screen(60);

    delay(5000);

    return 0;
}

