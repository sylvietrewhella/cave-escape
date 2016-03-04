program GameMain;
uses SwinGame, sgTypes, sgSprites;

procedure LoadResources();
begin
	LoadBitmapNamed('bg_day', 'bg_day.png');
	LoadBitmapNamed('scrolling_bg', 'scrolling_bg.png');
	LoadFontNamed('game font', 'arial.ttf', 48);
end;

procedure DrawScrollingBackground(var bgSprite: Sprite);
begin
	SpriteSetX(bgSprite, SpriteX(bgSprite) - 1);
	DrawSprite(bgSprite);
	if (SpriteX(bgSprite) <= (SpriteWidth(bgSprite) / 2) * -1) then
	begin
		SpriteSetX(bgSprite, 0);
	end;
end;

procedure Main();
var
	scrollingBackGround: Sprite;
begin
  OpenGraphicsWindow('Flappy Bird', 368, 653);
  LoadResources();
  scrollingBackGround := CreateSprite(BitmapNamed('scrolling_bg'));
  SpriteSetX(scrollingBackGround, 0);
  SpriteSetY(scrollingBackGround, BitmapHeight(BitmapNamed('bg_day')) - BitmapHeight(BitmapNamed('scrolling_bg')));
  repeat // The game loop...
    ProcessEvents();
    
    ClearScreen(ColorWhite);

    DrawBitmap('bg_day', 0, 0);
    DrawScrollingBackground(scrollingBackGround);
    DrawFramerate(0,0);
    
    RefreshScreen(60);
  until WindowCloseRequested();
end;

begin
  Main();
end.
