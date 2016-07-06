program GameMain;
uses SwinGame, sgTypes, sgTimers, sgSprites, sysUtils;

const
  GRAVITY = 0.08;
  JUMP_RECOVERY_BOOST = 2;
  MAX_SPEED = 5;
  FOREGROUND_FOREROOF_POLE_SCROLL_SPEED = -2;
  BACKGROUND_SCROLL_SPEED = -1;

type
  PoleData = record
    UpPole: Sprite;
    DownPole: Sprite;
  end;

  Poles = array [0..3] of PoleData;

  GameData = record
    Player: Sprite;
    Foreroof: Sprite;
    Foreground: Sprite;
    Background: Sprite;
    Poles: Poles;
  end;

function GetRandomPoles(): PoleData;
begin
  result.UpPole := CreateSprite(BitmapNamed('UpPole'));
  result.DownPole := CreateSprite(BitmapNamed('DownPole'));
  SpriteSetX(result.UpPole, ScreenWidth() + RND(1200));
  SpriteSetY(result.UpPole, ScreenHeight() - SpriteHeight(result.UpPole) - RND(BitmapHeight(BitmapNamed('Foreground'))));
  SpriteSetX(result.DownPole, SpriteX(result.UpPole));
  SpriteSetY(result.DownPole, RND(BitmapHeight(BitmapNamed('Foreroof'))));
  SpriteSetDx(result.UpPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  SpriteSetDx(result.DownPole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
end;

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
  SpriteSetDy(result, 0);
end;

procedure SetUpBackground(var background, foreground, foreroof: Sprite);
begin
  background := CreateSprite(BitmapNamed('Background'));
  SpriteSetX(background, 0);
  SpriteSetY(background, 0);
  SpriteSetDx(background, BACKGROUND_SCROLL_SPEED);

  foreground := CreateSprite(BitmapNamed('Foreground'), AnimationScriptNamed('ForegroundAminations'));
  SpriteSetX(foreground, 0);
  SpriteSetY(foreground, ScreenHeight() - SpriteHeight(foreground));
  SpriteSetDx(foreground, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  foreroof := CreateSprite(BitmapNamed('Foreroof'));
  SpriteSetX(foreroof, 0);
  SpriteSetY(foreroof, 0);
  SpriteSetDx(foreroof, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
end;

procedure SetUpGame(var game: GameData);
var
  i: Integer;
begin
  LoadResourceBundleNamed('CaveEscape', 'CaveEscape.txt', false);
  for i:= Low(game.Poles) to High(game.Poles) do
  begin
    game.Poles[i] := GetRandomPoles();
  end;
  game.Player := GetNewPlayer();
  SetUpBackground(game.Background, game.Foreground, game.Foreroof);

  SpriteStartAnimation(game.Foreground, 'Fire');
end;

procedure UpdateVelocity(var player: Sprite);
begin
  SpriteSetDy(player, SpriteDy(player) + GRAVITY);

  if SpriteDy(player) > MAX_SPEED then
  begin
    SpriteSetDy(player, MAX_SPEED);
  end
  else if SpriteDy(player) < -(MAX_SPEED) then
  begin
    SpriteSetDy(player, -(MAX_SPEED));
  end;
end;

procedure UpdateBackground(var game: GameData);
begin
  UpdateSprite(game.ForeGround);
  UpdateSprite(game.Foreroof);
  updateSprite(game.Background);
  if (SpriteX(game.Foreground) <= -(SpriteWidth(game.ForeGround) / 2)) then
  begin
    SpriteSetX(game.Foreground, 0);
    SpriteSetX(game.Foreroof, 0);
  end;
  if (SpriteX(game.Background) <= -(SpriteWidth(game.Background) / 2)) then
  begin
    SpriteSetX(game.Background, 0);
  end;
end;

procedure UpdatePlayer(var player: Sprite);
begin
  UpdateVelocity(player);
  UpdateSprite(player);
end;

procedure HandleInput(var player: Sprite);
begin
  if KeyTyped(SpaceKey) then
  begin
    SpriteSetDy(player, SpriteDy(player) - JUMP_RECOVERY_BOOST);
  end;
end;

procedure ResetPoleData(var pole: PoleData);
begin
  FreeSprite(pole.UpPole);
  FreeSprite(pole.DownPole);
  pole := GetRandomPoles();
end;

procedure UpdatePoles(var poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    UpdateSprite(poles[i].UpPole);
    UpdateSprite(poles[i].DownPole);

    if ((SpriteX(poles[i].UpPole) + SpriteWidth(poles[i].UpPole)) < 0) and ((SpriteX(poles[i].DownPole) + SpriteWidth(poles[i].DownPole)) < 0) then
    begin
      ResetPoleData(poles[i]);
    end;
  end;
end;

procedure UpdateGame(var game: GameData);
begin
  HandleInput(game.Player);
  UpdateBackground(game);
  UpdatePlayer(game.Player);
  UpdatePoles(game.Poles);
end;

procedure DrawPoles(const poles: Poles);
var
  i: Integer;
begin
  for i:= Low(poles) to High(poles) do
  begin
    DrawSprite(poles[i].UpPole);
    DrawSprite(poles[i].DownPole);
  end;
end;

procedure DrawGame(const game: GameData);
begin
  DrawSprite(game.Background);
  DrawPoles(game.Poles);
  DrawSprite(game.Foreroof);
  DrawSprite(game.ForeGround);
  DrawSprite(game.Player);
end;

procedure Main();
var
  game: GameData;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  OpenAudio();
  SetUpGame(game);

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    UpdateGame(game);
    DrawGame(game);
    RefreshScreen();
  until WindowCloseRequested();
end;

begin
  Main();
end.
