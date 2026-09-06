// ==========================================
// Bauhaus Textbook Template (typst/templates/textbook.typ)
// 기하학적 형태와 바우하우스 삼원색 기반 교재/강의 템플릿
// ==========================================

#let bauhaus-red = rgb("#D82B27")
#let bauhaus-blue = rgb("#185ADB")
#let bauhaus-yellow = rgb("#F4B41A")
#let bauhaus-black = rgb("#1A1A1A")
#let bauhaus-cream = rgb("#FBF9F5")

#let project(
  title: "",
  subtitle: "",
  unit: "",
  author: "gitsam",
  date: none,
  body,
) = {
  set document(title: title, author: author)

  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 3cm, bottom: 2.5cm),
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        grid(
          columns: (1fr, auto),
          align(left)[#text(size: 8.5pt, fill: bauhaus-black.lighten(30%), weight: "medium")[
            #if unit != "" [#unit | ] #title
          ]],
          align(right)[#text(size: 8.5pt, fill: bauhaus-blue, weight: "bold")[BAUHAUS MATH DOCS]],
        )
        v(-4pt)
        line(length: 100%, stroke: 1.5pt + bauhaus-black)
      }
    },
    footer: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        line(length: 100%, stroke: 0.8pt + bauhaus-black)
        v(2pt)
        grid(
          columns: (1fr, auto),
          align(left)[#text(size: 8pt, fill: bauhaus-black.lighten(40%))[인공지능 이해를 위한 기초수학]],
          align(right)[#text(size: 9pt, weight: "bold")[#page-num]],
        )
      }
    },
  )

  set text(
    font: ("Pretendard", "Noto Sans CJK KR", "Liberation Sans", "Arial"),
    size: 10.5pt,
    fill: bauhaus-black,
    lang: "ko",
    spacing: 120%,
  )

  set par(justify: true, leading: 0.78em)

  // ------------------------------------------
  // 표지 / 헤더 블록 (바우하우스 기하학 카드)
  // ------------------------------------------
  block(
    width: 100%,
    stroke: 3pt + bauhaus-black,
    fill: bauhaus-cream,
    inset: 18pt,
    radius: 0pt,
    [
      #grid(
        columns: (12pt, 1fr),
        gutter: 12pt,
        rect(width: 100%, height: 100%, fill: bauhaus-red),
        [
          #if unit != "" [
            #box(
              fill: bauhaus-yellow,
              inset: (x: 8pt, y: 4pt),
              stroke: 1.5pt + bauhaus-black,
              text(size: 9pt, weight: "black", fill: bauhaus-black, tracking: 1pt)[#unit]
            )
            #v(6pt)
          ]
          #text(size: 22pt, weight: "black", fill: bauhaus-black)[#title]
          #if subtitle != "" [
            #v(4pt)
            #text(size: 12pt, weight: "medium", fill: bauhaus-blue)[#subtitle]
          ]
          #v(8pt)
          #grid(
            columns: (auto, auto),
            gutter: 16pt,
            text(size: 9pt, weight: "bold")[저자: #author],
            if date != none [ #text(size: 9pt)[발행: #date] ],
          )
        ]
      )
    ]
  )

  v(20pt)

  body
}

// ------------------------------------------
// 바우하우스 커스텀 블록 (정리, 정의, 예제)
// ------------------------------------------

#let definition(title: "정의 (Definition)", body) = {
  v(6pt)
  block(
    width: 100%,
    stroke: (left: 5pt + bauhaus-blue, rest: 1.5pt + bauhaus-black),
    fill: rgb("F0F4FC"),
    inset: 12pt,
    [
      #text(weight: "black", fill: bauhaus-blue, size: 10pt)[#title]
      #v(4pt)
      #body
    ]
  )
  v(6pt)
}

#let theorem(title: "핵심 정리 (Theorem)", body) = {
  v(6pt)
  block(
    width: 100%,
    stroke: (left: 5pt + bauhaus-red, rest: 1.5pt + bauhaus-black),
    fill: rgb("FCF2F2"),
    inset: 12pt,
    [
      #text(weight: "black", fill: bauhaus-red, size: 10pt)[#title]
      #v(4pt)
      #body
    ]
  )
  v(6pt)
}

#let note(title: "주의 및 참고 (Note)", body) = {
  v(6pt)
  block(
    width: 100%,
    stroke: (left: 5pt + bauhaus-yellow, rest: 1.5pt + bauhaus-black),
    fill: rgb("FFFBEB"),
    inset: 12pt,
    [
      #text(weight: "black", fill: bauhaus-black, size: 10pt)[#title]
      #v(4pt)
      #body
    ]
  )
  v(6pt)
}
