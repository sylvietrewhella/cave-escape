program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

procedure LoadResources();
begin
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);
end;

function GetNewPlayer(): Sprite;
begin
	result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
	SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
	SpriteSetY(result, ScreenHeight() / 2);
	SpriteStartAnimation(result, 'Fly');
end;

procedure Main();
var
  player: Sprite;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  LoadResources();

  player := GetNewPlayer();

  repeat // The game loop...
    ProcessEvents();
		ClearScreen(ColorWhite);

		UpdateSprite(player);
    DrawSprite(player);

    RefreshScreen();

  until WindowCloseRequested();
end;

begin
  Main();
end.
