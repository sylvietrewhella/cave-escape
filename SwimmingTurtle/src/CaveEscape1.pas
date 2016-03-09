program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

procedure Main();
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
	OpenAudio();
  LoadResources();

  repeat // The game loop...
    ProcessEvents();

    ClearScreen(ColorWhite);
    RefreshScreen()

  until WindowCloseRequested();
end;

begin
  Main();
end.
