import pyray as rl
from ship import Ship
from asteroid import Asteroid, AsteroidSize
from bullet import Bullet
from explosion import Explosion
import utils
import random


def main():
    rl.init_window(utils.SCREEN_W, utils.SCREEN_H, "python + raylib")
    rl.set_target_fps(120)

    player = Ship(utils.SCREEN_W // 2, utils.SCREEN_H // 2)

    asteroids = []
    bullets = []
    explosions = []

    for _ in range(3):
        x = random.uniform(0, utils.SCREEN_W)
        y = random.uniform(0, utils.SCREEN_H)
        asteroids.append(Asteroid(x, y, AsteroidSize.LARGE))
    for _ in range(2):
        x = random.uniform(0, utils.SCREEN_W)
        y = random.uniform(0, utils.SCREEN_H)
        asteroids.append(Asteroid(x, y, AsteroidSize.MEDIUM))

    rl.init_audio_device()
    shoot = rl.load_sound("assets/shoot.wav")
    explode = rl.load_sound("assets/explode.wav")

    background = rl.load_image("assets/stars.jpg")
    rl.image_resize(background, utils.SCREEN_W, utils.SCREEN_H)
    texture = rl.load_texture_from_image(background)
    rl.unload_image(background)

    while not rl.window_should_close():
        dt = rl.get_frame_time()

        player.update(dt)
        player.wrap()

        if rl.is_key_pressed(rl.KeyboardKey.KEY_SPACE):
            dir_x, dir_y = utils.rotate_point(0, -15, player.angle)
            x = player.x + dir_x
            y = player.y + dir_y
            bullets.append(Bullet(x, y, player.angle))

            rl.play_sound(shoot)

        for ast in asteroids:
            ast.update(dt)
            ast.wrap()

        for bullet in bullets:
            bullet.update(dt)
            bullet.wrap()

        for exp in explosions:
            exp.update(dt)

        for b in bullets:
            for a in asteroids:
                if b.alive and a.alive:
                    if utils.check_collision_circles(b.x, b.y, b.radius, a.x, a.y, a.radius):
                        b.alive = False
                        a.alive = False
                        explosions.append(Explosion(a.x, a.y, a.radius))
                        rl.play_sound(explode)

        bullets = [b for b in bullets if b.alive]
        asteroids = [a for a in asteroids if a.alive]
        explosions = [e for e in explosions if e.alive]

        rl.begin_drawing()
        rl.clear_background(rl.RAYWHITE)
        rl.draw_texture(texture, 0, 0, rl.WHITE)

        for ast in asteroids:
            ast.draw()

        for exp in explosions:
            exp.draw()

        for bullet in bullets:
            bullet.draw()

        player.draw()

        rl.draw_text("Strzalki: Ruch i obrot  |  Z: Hamulec Awaryjny | SPACJA: Strzal", 10, 10, 18, rl.LIGHTGRAY)

        rl.end_drawing()

    rl.unload_texture(texture)
    rl.unload_sound(shoot)
    rl.unload_sound(explode)
    rl.close_audio_device()
    rl.close_window()


if __name__ == "__main__":
    main()