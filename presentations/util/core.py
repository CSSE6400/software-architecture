from functools import partial
import os
from PIL import Image

from manim import *
from manim_presentation import Slide

FONT_COLOUR = "#525893"
BACKGROUND_COLOUR = "#ece6e2"

setattr(Mobject, "FONT_COLOUR", FONT_COLOUR)
class BaseScene(Slide):
    BACKGROUND_COLOUR = BACKGROUND_COLOUR
    FONT_COLOUR = FONT_COLOUR
    PAGE = 1
    SECTION = None

    EXPORT = False

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._images = []

    @property
    def images(self):
        return self._images

    def move_title(self, title):
        title.scale(0.5)
        title.to_edge(UP)
        
        return title

    def new_code(self, code):
        object = Code(code=code, tab_width=4, language="java", style="zenburn", insert_line_no=False)
        object.scale(0.8)
        return object

    def scene_setup(self):
        self.camera.background_color = BaseScene.BACKGROUND_COLOUR
        page_number = Text(str(self.PAGE), color=self.FONT_COLOUR)
        page_number.scale(0.35)

        bar = Rectangle(width=self.camera.frame_width + 2, height=0.6, stroke_width=0.5, color=self.FONT_COLOUR)
        bar.to_edge(DOWN, buff=-0.05)

        page_number.move_to(bar)
        page_number.to_edge(RIGHT)

        footer = ""
        if self.SECTION is not None:
            footer = self.SECTION

        footer = Text(footer, color=self.FONT_COLOUR)
        footer.scale(0.35)
        footer.move_to(bar)
        footer.to_edge(LEFT)

        self.add(bar, footer, page_number)

        self.height = self.camera.frame_height - bar.height
        self.center = self.camera.frame_center + [0, bar.height / 2, 0]
    
    def play_scene(self):
        pass

    def construct(self):
        self.scene_setup()
        self.play_scene()
        return super().construct()

    def pause(self):
        super().pause()
        if self.EXPORT:
            self.save_image()

    def save_image(self):
        self._images.append(self.camera.get_image().copy())


Text = partial(Text, color=FONT_COLOUR)
Line = partial(Line, color=FONT_COLOUR)
Arrow = partial(Arrow, color=FONT_COLOUR)


OUTPUT_DIR = None
def export_image(mobj: VMobject, name="untitled"):
    if OUTPUT_DIR is not None:
        os.makedirs(f"{OUTPUT_DIR}", exist_ok=True)
        camera = Camera()
        camera.background_opacity = 50
        camera.background_color = BACKGROUND_COLOUR
        image = mobj.get_image(camera=camera)
        # image.putalpha(1)
        # image.putdata(mobj.get_image(camera=camera).getdata(2))

        image.save(f"{OUTPUT_DIR}/{name}.png", "PNG")
