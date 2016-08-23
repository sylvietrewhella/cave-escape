#include <stdio.h>
#include <stdlib.h>
#include "SwinGame.h"

#define GRAVITY 0.08
#define MAX_SPEED 5
#define JUMP_RECOVERY_BOOST 2
#define FOREGROUND_FOREROOF_POLE_SCROLL_SPEED -2
#define BACKGROUND_SCROLL_SPEED -1
#define NUM_POLES 4

typedef struct pole_data
{
  bool score_limiter;
  sprite up_pole, down_pole;
} pole_data;

typedef struct pole_data poles[NUM_POLES];

typedef struct background_data
{
  sprite foreroof, foreground, background;
} background_data;

typedef struct player
{
  sprite sprite;
  int score;
  bool is_dead;
} player;

typedef struct game_data
{
  player player;
  background_data scene;
  poles poles;
} game_data;

player get_new_player()
{
  player result;

  result.sprite = create_sprite(bitmap_named("Player"), animation_script_named("PlayerAnimations"));
  sprite_set_x(result.sprite, screen_width() / 2 - sprite_width(result.sprite));
  sprite_set_y(result.sprite, screen_height() / 2);
  sprite_start_animation(result.sprite, "Fly");
  result.score = 0;
  result.is_dead = false;

  return result;
}

pole_data get_random_poles()
{
  pole_data result;

  result.up_pole = create_sprite(bitmap_named("UpPole"));
  result.down_pole = create_sprite(bitmap_named("DownPole"));
  sprite_set_x(result.up_pole, screen_width() + rnd(1200));
  sprite_set_y(result.up_pole, screen_height() - sprite_height(result.up_pole) -  rnd(bitmap_height(bitmap_named("Foreground"))));
  sprite_set_x(result.down_pole, sprite_x(result.up_pole));
  sprite_set_y(result.down_pole, rnd(bitmap_height(bitmap_named("Foreroof"))));
  sprite_set_dx(result.up_pole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  sprite_set_dx(result.down_pole, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  result.score_limiter = true;

  return result;
}

background_data get_new_background()
{
  background_data result;

  result.background = create_sprite(bitmap_named("Background"));
  sprite_set_x(result.background, 0);
  sprite_set_y(result.background, 0);
  sprite_set_dx(result.background, BACKGROUND_SCROLL_SPEED);

  result.foreground = create_sprite(bitmap_named("Foreground"), animation_script_named("ForegroundAminations"));
  sprite_set_x(result.foreground, 0);
  sprite_set_y(result.foreground, screen_height() - sprite_height(result.foreground));
  sprite_set_dx(result.foreground, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);
  sprite_start_animation(result.foreground, "Fire");

  result.foreroof = create_sprite(bitmap_named("Foreroof"));
  sprite_set_x(result.foreroof, 0);
  sprite_set_y(result.foreroof, 0);
  sprite_set_dx(result.foreroof, FOREGROUND_FOREROOF_POLE_SCROLL_SPEED);

  return result;
}

void handle_input(sprite player)
{
  if (key_typed(SPACE_KEY))
  {
    sprite_set_dy(player, sprite_dy(player) - JUMP_RECOVERY_BOOST);
  }
}

void check_for_collisions(game_data *game)
{
  int i;

  if (sprite_collision(game->player.sprite, game->scene.foreground) || sprite_collision(game->player.sprite, game->scene.foreroof))
  {
    game->player.is_dead = true;
    return;
  }

  for (i = 0; i < NUM_POLES; i++)
  {
    if (sprite_collision(game->player.sprite, game->poles[i].up_pole) || sprite_collision(game->player.sprite, game->poles[i].down_pole))
    {
      game->player.is_dead = true;
      return;
    }
  }
}

void reset_pole_data(pole_data *poles)
{
  free_sprite(poles->up_pole);
  free_sprite(poles->down_pole);
  *poles = get_random_poles();
}

void reset_player(player *player)
{
  free_sprite(player->sprite);
  *player = get_new_player();
}

void reset_game(game_data *game)
{
  int i;

  reset_player(&game->player);
  for (i = 0; i < NUM_POLES; i++)
  {
    reset_pole_data(&game->poles[i]);
  }
}

void update_velocity(sprite player)
{
  sprite_set_dy(player, sprite_dy(player) + GRAVITY);

  if (sprite_dy(player) > MAX_SPEED)
  {
    sprite_set_dy(player, MAX_SPEED);
  }
  else if (sprite_dy(player) < -(MAX_SPEED))
  {
    sprite_set_dy(player, -(MAX_SPEED));
  }
}

void update_poles(pole_data *poles, player *player)
{
  update_sprite(poles->up_pole);
  update_sprite(poles->down_pole);

  if ((sprite_x(poles->up_pole) < sprite_x(player->sprite)) && (poles->score_limiter == true))
  {
    poles->score_limiter = false;
    player->score++;
  }

  if ((sprite_x(poles->up_pole) + sprite_width(poles->up_pole) < 0) && (sprite_x(poles->down_pole) + sprite_width(poles->down_pole) < 0))
  {
    reset_pole_data(poles);
  }
}

void update_poles_array(poles poles_array, player *player)
{
  int i;

  for (i = 0; i < NUM_POLES; i++)
  {
    update_poles(&poles_array[i], player);
  }
}

void update_background(background_data scene)
{
  update_sprite(scene.foreground);
  update_sprite(scene.foreroof);
  update_sprite(scene.background);

  if (sprite_x(scene.foreground) <= -(sprite_width(scene.foreground) / 2))
  {
    sprite_set_x(scene.foreground, 0);
    sprite_set_x(scene.foreroof, 0);
  }
  if (sprite_x(scene.background) <= -(sprite_width(scene.background) / 2))
  {
    sprite_set_x(scene.background, 0);
  }
}

void update_player(sprite player)
{
  update_velocity(player);
  update_sprite(player);
}

void update_game(game_data *game)
{
  if (!game->player.is_dead)
  {
    check_for_collisions(game);
    handle_input(game->player.sprite);
    update_background(game->scene);
    update_player(game->player.sprite);
    update_poles_array(game->poles, &game->player);
  }
  else
  {
    reset_game(game);
  }
}

void draw_poles(pole_data poles)
{
  draw_sprite(poles.up_pole);
  draw_sprite(poles.down_pole);
}

void draw_poles_array(poles poles_array)
{
  int i;

  for (i = 0; i < NUM_POLES; i++)
  {
    draw_poles(poles_array[i]);
  }
}

void draw_game(game_data *game)
{
  char str[15];

  sprintf(str, "%d", game->player.score);

  draw_sprite(game->scene.background);
  draw_poles_array(game->poles);
  draw_sprite(game->scene.foreroof);
  draw_sprite(game->scene.foreground);
  draw_sprite(game->player.sprite);
  draw_text(str, COLOR_WHITE, "GameFont", 10, 0);
}

void set_up_game(game_data *game)
{
  int i;

  load_resource_bundle_named("CaveEscape", "CaveEscape.txt", false);
  for (i = 0; i < NUM_POLES; i++)
  {
    game->poles[i] = get_random_poles();
  }
  game->player = get_new_player();
  game->scene = get_new_background();
  fade_music_in("GameMusic", -1, 15000);
}

int main()
{
    game_data game;

    open_graphics_window("Cave Escape", 432, 768);
    set_up_game(&game);

    do
    {
      process_events();
      clear_screen(COLOR_WHITE);
      update_game(&game);
      draw_game(&game);
      refresh_screen();

    } while(!window_close_requested());

    return 0;
}
