#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/gentle-clues:1.3.1": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/catppuccin:1.1.0": catppuccin, flavors
#import "@preview/iconify:0.5.3": icon, provide-icons

#let gitHash = sys.inputs.at("gitHash", default: datetime.today().display())

#let edstemLink = sys.inputs.at("edStemPracticalLink", default: "https://csse6400.uqcloud.net")

#let practical(
  title: "",
  authors: (),
  body
) = {
  // Basics
  set document(author: authors, title: title)
  set page(margin: 0.5in)
  set par(leading: 0.55em, spacing: 0.55em, first-line-indent: 1.8em, justify: true)
  set page(
    numbering: "1",
    number-align: center,
    footer: context {
      // Omit page number on the first page
      let page-number = counter(page).get().at(0);

      align(center)[
        #if page-number > 1 {
          text(size: 12pt, weight: "regular")[
            #page-number
          ]
        }
      ]
    }
  )
  
  // Text Formatting
  show heading: set block(above: 1.4em, below: 1em)
  show heading: set text(font: "Noto Sans")
  set text(font: "Noto Serif", size: 12pt)

  // Style
  show: catppuccin.with(flavors.latte)

  // Icons
  provide-icons(json("icons/ph.json"))

  // Code
  codly(
    languages: codly-languages,
    zebra-fill: none,
    number-format: none
  )
  show: codly-init.with()

  // Admotions
  show: gentle-clues.with(
    stroke-width: 1pt,
  ) 

  // Diagrams
  set scale(reflow: true)

  // Cover Section
  align(top + right)[
    #text(size: 10pt)[Last Updated on #gitHash]
  ]
  align(top)[
    #line(length: 100%, stroke: 1pt)
    #grid(
      columns: (auto, 1fr),
      rows: (auto, auto),
      gutter: 2pt,
      row-gutter: 20pt,
      text(size: 12pt, weight: "bold")[#title],
      align(right)[#text(size: 10pt)[Software Architecture]],
      grid.cell(colspan: 2, align(right)[#text(size: 10pt)[#authors.join(", ")]]),
    )
    #line(length: 100%, stroke: 1pt)
  ]

  // Main body.
  body
}

// Extra Admotions

#let aside(..args) = clue(
  title: "Aside",
  icon: text(fill: rgb("#303446"))[#icon("ph:notepad", width: 1.2em)],
  accent-color: rgb("#303446"),
  ..args
)

#let teacher(..args) = clue(
  title: "Teacher",
  icon: text(fill: rgb("#40a02b"))[#icon("ph:chalkboard-teacher", width: 1.5em)],
  accent-color: rgb("#40a02b"),
  ..args
)

// Extra Assets
#let edstem = link(edstemLink)[#box(baseline: 20%)[#image("assets/ed.png", width: 1em)] Edstem]