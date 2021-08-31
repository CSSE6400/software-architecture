from math import cos, pi, sin
from manim import *

from presentations.util.core import BaseScene, export_image
from presentations.util.common import *


PRESENTATION = "Architectural Views"

IMAGE_ROOT = "presentations/assets/images/"


class Introduction(TitleSlide):
    title = PRESENTATION
    subtitle = "communicating designs"


class Communication(BaseScene):
    def play_scene(self):
        architect = SVGMobject(f"{IMAGE_ROOT}architect")
        architect.to_edge(LEFT)
        architect_talk = SVGMobject(f"{IMAGE_ROOT}speech").scale(0.2).next_to(architect, RIGHT+UP)

        blueprint = SVGMobject(f"{IMAGE_ROOT}blueprint").scale(0.2).next_to(architect, RIGHT)

        developer = SVGMobject(f"{IMAGE_ROOT}developers").next_to(architect, RIGHT)
        developer_talk = SVGMobject(f"{IMAGE_ROOT}speech").scale(0.2).next_to(developer, RIGHT+UP)
        developers = VGroup()
        talk = VGroup()
        for _ in range(4):
            developer = developer.copy().next_to(developer, RIGHT)
            developer_talk = developer_talk.copy().next_to(developer, RIGHT+UP)
            developers.add(developer)
            talk.add(developer_talk)

        self.play(FadeIn(architect))

        self.pause()

        self.play(FadeIn(developers))

        self.pause()

        self.play(FadeIn(architect_talk, talk))

        self.pause()

        self.play(FadeOut(architect_talk, talk))
        
        self.pause()

        prints = VGroup()
        prints.add(blueprint)

        self.play(Write(blueprint))

        self.play(ApplyMethod(blueprint.to_edge, UP))

        for developer in developers:
            blueprint_copy = blueprint.copy().move_to(developer)
            self.play(ReplacementTransform(blueprint.copy(), blueprint_copy))
            prints.add(blueprint_copy)

        self.pause()

        self.play(FadeOut(architect, developers, prints))

        return super().play_scene()


class TypeOfViews(BaseScene):
    def play_scene(self):
        uml = SVGMobject(f"{IMAGE_ROOT}uml")
        module = Text("Module Views").next_to(uml, DOWN)
        server = SVGMobject(f"{IMAGE_ROOT}server")
        allocation = Text("Allocation Views").next_to(server, DOWN)
        network = SVGMobject(f"{IMAGE_ROOT}network")
        cc = Text("Component-and-connector Views").next_to(network, DOWN)


        self.play(Write(uml))
        self.play(Write(module))

        self.pause()

        self.play(
            AnimationGroup(
                Write(server),
                ApplyMethod(VGroup(uml, module).scale, 0.02)
            )
        )
        self.play(Write(allocation))

        self.pause()

        self.play(
            AnimationGroup(
                Write(network),
                ApplyMethod(VGroup(uml, module, server, allocation).scale, 0.02)
            )
        )
        self.play(Write(cc))

        self.pause()

        self.play(FadeOut(uml, server, network, module, cc, allocation))

        return super().play_scene()

    def pause(self):
        self.wait()


class ModuleViewTitle(TitleSlide):
    title = "Module Views"


class ModuleView(BaseScene):
    EXAMPLE_PROGRAM = """
import json
import xml

class JSONtoXML:
    def load(self, json_file):
        with open(json_file) as f:
            data = json.load(f)
        self.data = self.convert(data)

    def export(self, xml_file):
        xml.write(xml_file, data)

    def convert(self, data: JSON) -> XML:
        ...
"""

    def play_scene(self):
        code = self.new_code(self.EXAMPLE_PROGRAM)
        vertices = ["\\text{JSONtoXML}", "\\text{json}", "\\text{xml}"]
        graph = Graph(
            vertices,
            [(vertices[0], vertices[1]), (vertices[0], vertices[2])],
            label_fill_color=WHITE,
            vertex_config={vertex: {"fill_color": FONT_COLOUR, "stroke_color": "#fff"} for vertex in vertices},
            labels=True, layout="tree", root_vertex=vertices[0],
            layout_scale=3)

        self.play(Write(code))

        self.pause()

        self.play(ApplyMethod(code.to_edge, LEFT))

        graph.next_to(code, RIGHT).shift(RIGHT)
        self.play(Write(graph))

        self.pause()

        self.play(FadeOut(code, graph))

        return super().play_scene()


class CCTitle(TitleSlide):
    title = "Component-and-connector Views"


# class CC(BaseScene):
#     def play_scene(self):

#         # TODO: user registration CC view

#         return super().play_scene()
