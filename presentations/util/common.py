from functools import partial
from manim import *

from .core import BaseScene, FONT_COLOUR


Text = partial(Text, color=FONT_COLOUR)
Line = partial(Line, color=FONT_COLOUR)
Arrow = partial(Arrow, color=FONT_COLOUR)


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


class EnumerateSlide(BaseScene):
    title = None
    points = None

    def play_scene(self):
        if self.title is None or self.points is None:
            raise NotImplemented()
        
        header = Title(self.title, color=self.FONT_COLOUR)

        points = BulletedList(*self.points, color=self.FONT_COLOUR)
        points.align_to(header, LEFT)

        for part in (header, *points):
            self.play(Write(part))
            self.pause()

    
class TitleSlide(BaseScene):
    title = None
    subtitle = None

    def play_scene(self):
        if self.title is None:
            raise NotImplemented()

        title = Text(self.title)
        title.move_to(self.center)

        self.play(Write(title))
        if self.subtitle is not None:
            subtitle = Text(self.subtitle).scale(0.6)
            subtitle.next_to(title, DOWN)
            self.play(Write(subtitle))

        self.pause()

        elements = (title,) + (subtitle,) if self.subtitle is not None else tuple()
        self.play(FadeOut(VGroup(*elements)))
        
        return super().play_scene()