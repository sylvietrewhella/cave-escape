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
    ScoreLimiter: Boolean;
    UpPole: Sprite;
    DownPole: Sprite;
  end;

  Poles = array [0..3] of PoleData;

  GameData = record
    Player: Sprite;
    Foreroof: Sprite;
    Foreground: Sprite;
    Background: Sprite;
    IsDead: Boolean;
    Score: Integer;
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
  result.ScoreLimiter := true;
end;

function GetNewPlayer(): Sprite;
begin
  result := CreateSprite(BitmapNamed('Player'), AnimationScriptNamed('PlayerAnimations'));
  SpriteSetX(result, ScreenWidth() / 2 - SpriteWidth(result));
  SpriteSetY(result, ScreenHeight() / 2);
  SpriteStartAnimation(result, 'Fly');
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
  game.Score := 0;
  game.IsDead := false;
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

procedure CheckForCollisions(var game: GameData);
var
  i: Integer;
begin
  if (SpriteCollision(game.Player, game.Foreground)) or (SpriteCollision(game.Player, game.Foreroof)) then
  begin
    game.IsDead := true;
    exit;
  end;

  for i := Low(game.Poles) to High(game.Poles) do
  begin
    if SpriteCollision(game.Player, game.Poles[i].UpPole) or SpriteCollision(game.Player, game.Poles[i].DownPole)then
    begin
      game.IsDead := true;
      exit;
    end;
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

procedure UpdatePoles(var game: GameData);
var
  i: Integer;
begin
  for i:= Low(game.Poles) to High(game.Poles) do
  begin
    UpdateSprite(game.Poles[i].UpPole);
    UpdateSprite(game.Poles[i].DownPole);

    if SpriteX (game.Poles[i].UpPole) < (SpriteX(game.Player)) then
    begin
      if (game.Poles[i].ScoreLimiter = true) then
      begin
        game.Poles[i].ScoreLimiter := false;
        game.Score += 1;
      end;
    end;

    if (SpriteOffscreen(game.Poles[i].UpPole)) and (SpriteOffscreen(game.Poles[i].DownPole) and (game.Poles[i].ScoreLimiter = false))then
    begin
      ResetPoleData(game.Poles[i]);
    end;
  end;
end;

procedure ResetGame(var game: GameData);
var
  i: Integer;
begin
  game.Player := GetNewPlayer();
  for i:= Low(game.Poles) to High(game.Poles) do
  begin
    ResetPoleData(game.Poles[i]);
  end;
  game.IsDead := false;
  game.Score := 0;
end;

procedure UpdateGame(var game: GameData);
begin
  if not (game.IsDead) then
  begin
    CheckForCollisions(game);
    HandleInput(game.Player);
    UpdateBackground(game);
    UpdatePlayer(game.Player);
    UpdatePoles(game);
  end
  else //The player has died :(
  begin
    ResetGame(game);
  end;
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
  DrawText(IntToStr(game.score), ColorWhite, 'GameFont', 10, 0);
end;

procedure Main();
var
  game: GameData;
begin
  OpenGraphicsWindow('Cave Escape', 432, 768);
  OpenAudio();
  SetUpGame(game);

  FadeMusicIn('GameMusic', -1, 15000);

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
