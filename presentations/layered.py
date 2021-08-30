from presentations.util.common import EnumerateSlide
from presentations.util.core import *

PRESENTATION = "Layered Architecture"


class Overview(BaseScene):
    def play_scene(self):
        # title sequence
        title = Text("Layered Architecture")
        subtitle = Text("(Multi-tiered or Tiered Architecture)").scale(0.4)
        subtitle.next_to(title, DOWN)

        group = VGroup(title, subtitle).move_to(self.center)

        self.play(Write(group))

        self.pause()

        self.play(FadeOut(group))

        return super().play_scene()


class CuttingMonolith(BaseScene):
    def play_scene(self):
        header = Text("Monolithic Architecture").scale(0.8)

        # cutting a monolith
        monolith = Square(color=self.FONT_COLOUR)
        monolith.stretch_to_fit_height(self.height - 2)
        monolith.stretch_to_fit_width(self.camera.frame_width - 3)

        cuts = []
        for i in range(1, 5):
            line = Line(monolith.get_corner(LEFT + UP), monolith.get_corner(RIGHT + UP))
            line.shift(DOWN * i)
            cuts.append(line)

        self.play(Write(header))
        self.pause()

        self.play(ApplyMethod(header.to_edge, UP))
        self.play(Create(monolith))
        self.pause()

        for cut in cuts:
            self.play(Create(cut))
        self.pause()

        self.play(Uncreate(VGroup(monolith, *cuts, header)))

        return super().play_scene()


class LayeredArchitecture(VGroup):
    def __init__(self, layers, height, width, *vmobjects, **kwargs):
        super().__init__(*vmobjects, **kwargs)
        monolith = Rectangle(color=self.FONT_COLOUR)
        monolith.stretch_to_fit_height(height)
        monolith.stretch_to_fit_width(width)

        layer_boxes = []
        for layer in layers:
            presentation = RoundedRectangle(fill_opacity=0.3, fill_color=self.FONT_COLOUR, color=self.FONT_COLOUR, corner_radius=0.1)
            presentation.stretch_to_fit_height(monolith.height / (len(layers) + 2))
            presentation.stretch_to_fit_width(monolith.width - 2)

            label = Text(layer).scale(0.8).move_to(presentation)
            
            layer_boxes.append(VGroup(presentation, label))

        boxes = VGroup(*layer_boxes).arrange(DOWN)
        boxes.align_to(monolith, UP).move_to(monolith)

        monolith.stretch_to_fit_height(boxes.height + DEFAULT_MOBJECT_TO_EDGE_BUFFER)
        monolith.stretch_to_fit_width(boxes.width + DEFAULT_MOBJECT_TO_EDGE_BUFFER)

        self.add(monolith, boxes)


class DistributedLayeredArchitecture(VGroup):
    def __init__(self, *components, **kwargs):
        super().__init__(**kwargs)
        last = components[0]
        self.add(last)

        for component in components[1:]:
            component.next_to(last, DOWN).shift(DOWN * 0.5)
            connection = Arrow(start=last.get_bottom(), end=component.get_top(), buff=0)
            last = component
            self.add(connection, component)


class StandardForm(BaseScene):
    def play_scene(self):
        layers = ("Presentation Layer", "Business Layer", "Persistence Layer", "Database Layer")
        standard = LayeredArchitecture(layers, self.height, self.camera.frame_width)
        standard.move_to(self.center)

        self.play(Create(standard[0]))
        self.pause()

        for box in standard[1]:
            self.play(Write(box))
            self.pause()

        self.play(FadeOut(standard))

        return super().play_scene()


class DeploymentTopologies(BaseScene):
    def new_layer(self, layers):
        return LayeredArchitecture(layers, self.height, self.camera.frame_width).scale(0.8)

    def play_scene(self):
        layers = ("Presentation Layer", "Business Layer", "Persistence Layer", "Database Layer")
        monolith = self.new_layer(layers)

        export_image(monolith, "monolithic")

        no_db = self.new_layer(layers[:-1])
        only_db = self.new_layer((layers[-1],))
        split_db = DistributedLayeredArchitecture(no_db, only_db).scale(0.75).center()

        export_image(split_db, "separate-db")

        middleware = self.new_layer(layers[1:-1])
        presentation = self.new_layer((layers[0],))
        only_db = self.new_layer((layers[-1],))

        distributed = DistributedLayeredArchitecture(presentation, middleware, only_db).scale(0.6).center()

        export_image(distributed, "distributed")

        def out_of_way(direction, scale=0.4):
            def f(obj):
                return obj.scale(scale).to_edge(direction)
            return f

        self.play(FadeIn(monolith))
        self.pause()

        self.play(ApplyFunction(out_of_way(LEFT + UP), monolith))
        
        self.play(FadeIn(split_db))
        self.pause()

        self.play(ApplyFunction(out_of_way(RIGHT + UP), split_db))

        self.play(FadeIn(distributed))
        self.pause()

        self.play(ApplyFunction(out_of_way(UP, scale=0.6), distributed))
        self.pause()

        self.play(FadeOut(monolith, split_db, distributed))

        return super().play_scene()




class Advantages(EnumerateSlide):
    title = "Layered Architecture Advantages"
    points = [
        "Low Cost",
        "Conceptual Simplicity"
    ]