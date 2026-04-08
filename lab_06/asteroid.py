import pyray as rl
import math
import random
import utils

class AsteroidSize:
    SMALL = "SMALL"
    MEDIUM = "MEDIUM"
    LARGE = "LARGE"

class Asteroid:
    def __init__(self, x, y, size):
        self.x = x
        self.y = y
        self.size = size
        self.angle = random.uniform(0, math.tau)

        if size == AsteroidSize.LARGE:
            self.radius = 60
            speed = random.uniform(20, 50)
            self.rot_speed = random.uniform(-1.0, 1.0)
            num_verts = random.randint(8, 12)
        elif size == AsteroidSize.MEDIUM:
            self.radius = 30
            speed = random.uniform(50, 100)
            self.rot_speed = random.uniform(-2.0, 2.0)
            num_verts = random.randint(6, 9)
        else:
            self.radius = 15
            speed = random.uniform(100, 200)
            self.rot_speed = random.uniform(-3.0, 3.0)
            num_verts = random.randint(5, 7)

        move_angle = random.uniform(0, math.tau)
        self.vx = math.cos(move_angle) * speed
        self.vy = math.sin(move_angle) * speed

        self.verts = []
        for i in range(num_verts):
            a = (i / num_verts) * math.tau
            r = self.radius * random.uniform(0.7, 1.3)
            self.verts.append((math.cos(a) * r, math.sin(a) * r))

    def update(self, dt):
        self.x += self.vx * dt
        self.y += self.vy * dt
        self.angle += self.rot_speed * dt

    def wrap(self):
        self.x %= utils.SCREEN_W
        self.y %= utils.SCREEN_H

    def draw(self):
        ghosts = utils.ghost_positions(self.x, self.y, self.radius * 1.3)

        for gx, gy in ghosts:
            screen_verts = []

        for vx, vy in self.verts:
            rx, ry = utils.rotate_point(vx, vy, self.angle)
            screen_verts.append((gx + rx, gy + ry))

            for i in range(len(screen_verts)):
                p1 = screen_verts[i]
                p2 = screen_verts[(i + 1) % len(screen_verts)]
                rl.draw_line(int(p1[0]), int(p1[1]), int(p2[0]), int(p2[1]), rl.RAYWHITE)