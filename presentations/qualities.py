from math import cos, pi, sin
from manim import *

from presentations.util.core import BaseScene, export_image
from presentations.util.common import *


PRESENTATION = "Quality Attributes"



RANDOM_QUALITIES = [
    "Availability",
    "Reliability",
    "Deployability",
    "Scalability",
    "Interoperability",
    "Security",
    "Modifiability",
    "Performance",
    "Testibility",
]


class Introduction(TitleSlide):
    title = "Quality Attributes"
    subtitle = "(the -ilities)"


class Pentagram(VGroup):
    def __init__(self, edges, **kwargs):
        super().__init__(**kwargs)

        increment = (pi*2) / len(edges)
        radius = 3

        self.points = points = VGroup()
        for i, quality in enumerate(edges):
            angle = increment * i

            x = radius * cos(angle)
            y = radius * sin(angle)

            text = Text(quality, color="white").scale(0.3).move_to([x, y, 0])
            circle = Circle(0.8, color=FONT_COLOUR,
                            fill_opacity=1).move_to([x, y, 0])
            points.add(VGroup(circle, text))

        points.scale(0.8)
        points.set_z_index(10)

        self.arrows = arrows = VGroup()
        for text, circle in points:
            for dest_text, dest_circle in points:
                if text == dest_text:
                    continue

                #angle = angle_between_vectors(text.get_center(), dest_text.get_center())
                #x, y = cos(angle), sin(angle)
                start_edge = text.get_center()# * [x, y, 0]
                #angle = angle_between_vectors(dest_text.get_center(), text.get_center())
                #x, y = cos(angle), sin(angle)
                end_edge = dest_text.get_center()# * [x, y, 0]

                arrow = Line(start_edge, end_edge, buff=0, stroke_width=2)
                arrows.add(arrow)

        self.add(points, arrows)


class Tension(BaseScene):
    def play_scene(self):
        qualities = RANDOM_QUALITIES[:]
        pentagram = Pentagram(qualities)
        refined_qualities = (RANDOM_QUALITIES[5], RANDOM_QUALITIES[8])
        refined_pentagram = Pentagram(refined_qualities)

        self.play(Write(pentagram.points))

        self.pause()

        self.play(Write(pentagram.arrows))

        self.pause()

        export_image(pentagram.points, name="circle")

        self.play(AnimationGroup(
            ReplacementTransform(pentagram.points, refined_pentagram.points),
            ReplacementTransform(pentagram.arrows, refined_pentagram.arrows)))
        
        self.pause()

        self.play(FadeOut(refined_pentagram.points, refined_pentagram.arrows))

        law = Text("Everything in software architecture is a trade-off").scale(0.8).shift(UP * 0.5)
        self.play(Write(law))
        self.pause()

        collary = Text("If an architect thinks they have discovered something that isn't a trade-off,\n more likely they just haven't identified the trade-off yet.")
        collary.scale(0.5)
        collary.next_to(law, DOWN)
        self.play(Write(collary))
        self.pause()

        self.play(FadeOut(law, collary))

        return super().play_scene()
