import sys
import inspect
from importlib import import_module

from PIL import Image

from manim._config import config
from manim.utils.file_ops import open_file as open_media_file

import presentations.util.core as core
from presentations.util.core import BaseScene


def get_ordered_classes(module):
    classes = inspect.getmembers(module, inspect.isclass)
    def _line_order(value):
        return inspect.getsourcelines(value[1])[1]

    classes.sort(key = _line_order)
    # all classes declared in the same module
    return filter(lambda value: inspect.getmodule(value[1]) == module, classes)
    return classes

def get_slides(module, export=False):
    slides = {}
    for name, slide in get_ordered_classes(module):
        if not issubclass(slide, BaseScene):
            continue
        if slide in (BaseScene,):
            continue
        if getattr(slide, "SECTION", None) is None:
            slide.SECTION = getattr(module, "PRESENTATION", None)
        slide.EXPORT = export
        slides[name] = slide

    return slides


def render(clazz, output_directory="dist"):
    config["media_dir"] = f"{output_directory}/media"

    inst = clazz()
    inst.output_folder = f"{output_directory}/presentation"
    inst.render()
    return inst


def export_pdf(images, export_to="media/slides.pdf"):
    rbg_images = []
    for image in images:
        background = Image.new("RGB", image.size, (255, 255, 255))
        background.paste(image, mask=image.split()[3]) # 3 is the alpha channel
        rbg_images.append(background)

    rbg_images[0].save(export_to, "PDF", resolution=100.0, save_all=True, append_images=rbg_images[1:])


def build_presentation(module):
    slides = get_slides(module, export=True)

    output_path = f"workdir/{sys.argv[1]}"
    core.OUTPUT_DIR = f"workdir/images/{sys.argv[1]}"

    if len(sys.argv) > 2:
        slide = slides.get(sys.argv[2])
        if slide is None:
            print(f"unknown scene name: {sys.argv[2]}")
            print(f"scenes: {', '.join(slides.keys())}")
            exit(1)
        
        page_number = list(slides.values()).index(slide) + 1
        slide.PAGE = page_number
        inst = render(slide, output_directory=output_path)
        open_media_file(inst.renderer.file_writer.movie_file_path)
        if len(inst.images) > 0:
            export_pdf(inst.images, export_to=f"{output_path}/slides.pdf")
        return
    
    all_images = []
    for page_number, slide in enumerate(slides.values()):
        slide.PAGE = page_number + 1
        inst = render(slide, output_directory=output_path)
        all_images.extend(inst.images)

    if len(all_images) > 0:
        export_pdf(all_images, export_to=f"{output_path}/slides.pdf")

def main():
    if len(sys.argv) <= 1:
        print("presentation required i.e. layered")
        sys.exit(1)
    
    presentation = import_module(f".{sys.argv[1]}", package="presentations")
    build_presentation(presentation)
    

if __name__ == '__main__':
    main()