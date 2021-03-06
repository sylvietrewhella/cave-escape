program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

procedure Main();
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    RefreshScreen();
  until WindowCloseRequested();
end;

begin
  Main();
end.
