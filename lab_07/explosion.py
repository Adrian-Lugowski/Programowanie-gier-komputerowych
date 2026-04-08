import pyray as rl

class Explosion:
    def __init__(self, x, y, max_radius):
        self.x = x
        self.y = y
        self.max_radius = max_radius
        self.current_radius = 1.0
        self.timer = 0.0
        self.duration = 0.4
        self.alive = True

    def update(self, dt):
        self.timer += dt
        if self.timer >= self.duration:
            self.alive = False
        else:
            self.current_radius = (self.timer / self.duration) * self.max_radius

    def draw(self):
        rl.draw_circle_lines(int(self.x), int(self.y), int(self.current_radius), rl.ORANGE)