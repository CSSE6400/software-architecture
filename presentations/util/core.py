from functools import partial
import os

from manim import *
from manim_presentation import Slide

FONT_COLOUR = "#525893"

setattr(Mobject, "FONT_COLOUR", FONT_COLOUR)
class BaseScene(Slide):
    BACKGROUND_COLOUR = "#ece6e2"
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


class Title(Tex):
    """
    Examples
    --------
    .. manim:: TitleExample
        :save_last_frame:

        import manim

        class TitleExample(Scene):
            def construct(self):
                banner = ManimBanner()
                title = Title(f"Manim version {manim.__version__}")
                self.add(banner, title)

    """

    def __init__(
        self,
        *text_parts,
        scale_factor=1,
        include_underline=True,
        match_underline_width_to_text=False,
        underline_buff=MED_SMALL_BUFF,
        **kwargs,
    ):
        self.scale_factor = scale_factor
        self.include_underline = include_underline
        self.match_underline_width_to_text = match_underline_width_to_text
        self.underline_buff = underline_buff
        Tex.__init__(self, *text_parts, **kwargs)
        self.scale(self.scale_factor)
        self.to_edge(UP)
        if self.include_underline:
            underline_width = config["frame_width"] - 2
            underline = Line(LEFT, RIGHT, **kwargs)
            underline.next_to(self, DOWN, buff=self.underline_buff)
            if self.match_underline_width_to_text:
                underline.match_width(self)
            else:
                underline.width = underline_width
            self.add(underline)
            self.underline = underline


class BulletedList(Tex):
    """
    Examples
    --------

    .. manim:: BulletedListExample
        :save_last_frame:

        class BulletedListExample(Scene):
            def construct(self):
                blist = BulletedList("Item 1", "Item 2", "Item 3", height=2, width=2)
                blist.set_color_by_tex("Item 1", RED)
                blist.set_color_by_tex("Item 2", GREEN)
                blist.set_color_by_tex("Item 3", BLUE)
                self.add(blist)
    """

    def __init__(
        self,
        *items,
        buff=MED_LARGE_BUFF,
        dot_scale_factor=2,
        tex_environment=None,
        **kwargs,
    ):
        self.buff = buff
        self.dot_scale_factor = dot_scale_factor
        self.tex_environment = tex_environment
        line_separated_items = [s + "\\\\" for s in items]
        Tex.__init__(
            self, *line_separated_items, tex_environment=tex_environment, **kwargs
        )
        for part in self:
            dot = MathTex("\\cdot", **kwargs).scale(self.dot_scale_factor)
            dot.next_to(part[0], LEFT, SMALL_BUFF)
            part.add_to_back(dot)
        self.arrange(DOWN, aligned_edge=LEFT, buff=self.buff)

    def fade_all_but(self, index_or_string, opacity=0.5):
        arg = index_or_string
        if isinstance(arg, str):
            part = self.get_part_by_tex(arg)
        elif isinstance(arg, int):
            part = self.submobjects[arg]
        else:
            raise TypeError(f"Expected int or string, got {arg}")
        for other_part in self.submobjects:
            if other_part is part:
                other_part.set_fill(opacity=1)
            else:
                other_part.set_fill(opacity=opacity)

class EnumerateSlide(VGroup):
    def __init__(self, title, points, **kwargs):
        super().__init__(**kwargs)

        header = Title(title, color=self.FONT_COLOUR)
        self.add(header)

        points = BulletedList(*points, color=self.FONT_COLOUR)
        points.align_to(header, LEFT)

        self.add(*points)

Text = partial(Text, color=FONT_COLOUR)
Line = partial(Line, color=FONT_COLOUR)
Arrow = partial(Arrow, color=FONT_COLOUR)


OUTPUT_DIR = None
def export_image(mobj, name="untitled"):
    if OUTPUT_DIR is not None:
        os.makedirs(f"{OUTPUT_DIR}", exist_ok=True)
        mobj.get_image().save(f"{OUTPUT_DIR}/{name}.png")
