import pyray as rl
from ship import Ship
from asteroid import Asteroid, AsteroidSize
import utils
import random


def main():
    rl.init_window(utils.SCREEN_W, utils.SCREEN_H, "Lab06")
    rl.set_target_fps(60)

    player = Ship(utils.SCREEN_W // 2, utils.SCREEN_H // 2)

    asteroids = []
    for _ in range(3):
        x = random.uniform(0, utils.SCREEN_W)
        y = random.uniform(0, utils.SCREEN_H)
        asteroids.append(Asteroid(x, y, AsteroidSize.LARGE))
    for _ in range(2):
        x = random.uniform(0, utils.SCREEN_W)
        y = random.uniform(0, utils.SCREEN_H)
        asteroids.append(Asteroid(x, y, AsteroidSize.MEDIUM))

    while not rl.window_should_close():
        dt = rl.get_frame_time()

        player.update(dt)
        player.wrap()

        for ast in asteroids:
            ast.update(dt)
            ast.wrap()

        rl.begin_drawing()
        rl.clear_background(rl.BLACK)

        for ast in asteroids:
            ast.draw()

        player.draw()

        rl.draw_text("Strzalki: Ruch i obrot  |  Z: Hamulec Awaryjny", 10, 10, 18, rl.DARKGRAY)

        rl.end_drawing()

    rl.close_window()


if __name__ == "__main__":
    main()