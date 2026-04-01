import pyray as rl
from ship import Ship

SCREEN_W = 800
SCREEN_H = 600


def main():
    rl.init_window(SCREEN_W, SCREEN_H, "Lab05")

    rl.set_target_fps(60)

    player = Ship(SCREEN_W // 2, SCREEN_H // 2)

    while not rl.window_should_close():
        dt = rl.get_frame_time()

        player.update(dt, SCREEN_W, SCREEN_H)

        rl.begin_drawing()
        rl.clear_background(rl.BLACK)

        player.draw()

        rl.draw_text("Strzalki: Ruch i obrot  |  Z: Hamulec Awaryjny", 10, 10, 18, rl.DARKGRAY)

        rl.end_drawing()

    rl.close_window()


if __name__ == "__main__":
    main()