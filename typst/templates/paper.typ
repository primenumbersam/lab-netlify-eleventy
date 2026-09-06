// ==========================================
// Bauhaus Research / Deep-Dive Paper Template (typst/templates/paper.typ)
// 단일 주제 심화 아티클용 템플릿
// ==========================================

#let bauhaus-red = rgb("#D82B27")
#let bauhaus-blue = rgb("#185ADB")
#let bauhaus-yellow = rgb("#F4B41A")
#let bauhaus-black = rgb("#1A1A1A")

#let paper(
  title: "",
  abstract: none,
  author: "gitsam",
  date: datetime.today().display("[year]-[month]-[day]"),
  body,
) = {
  set document(title: title, author: author)

  set page(
    paper: "a4",
    margin: (x: 2.8cm, top: 3.2cm, bottom: 2.8cm),
    header: context {
      let page-num = counter(page).get().first()
      if page-num > 1 {
        align(right)[
          #text(size: 8pt, fill: bauhaus-black.lighten(30%))[
            *심화 각론 연구* | #title
          ]
        ]
        v(-4pt)
        line(length: 100%, stroke: 1pt + bauhaus-black)
      }
    },
    footer: context {
      let page-num = counter(page).get().first()
      align(center)[#text(size: 8.5pt, weight: "bold")[- #page-num -]]
    },
  )

  set text(
    font: ("Pretendard", "Noto Sans CJK KR", "Liberation Sans", "Arial"),
    size: 10pt,
    fill: bauhaus-black,
    lang: "ko",
    spacing: 120%,
  )

  set par(justify: true, leading: 0.8em)

  // 상단 바우하우스 컬러 라인
  grid(
    columns: (1fr, 1fr, 1fr),
    rect(width: 100%, height: 4pt, fill: bauhaus-red),
    rect(width: 100%, height: 4pt, fill: bauhaus-yellow),
    rect(width: 100%, height: 4pt, fill: bauhaus-blue),
  )

  v(24pt)

  // 제목
  align(left)[
    #text(size: 20pt, weight: "black", fill: bauhaus-black)[#title]
    #v(8pt)
    #text(size: 9.5pt, fill: bauhaus-black.lighten(30%))[
      작성자: *#author* | 최종수정일: #date
    ]
  ]

  v(14pt)

  if abstract != none [
    block(
      width: 100%,
      stroke: 1.5pt + bauhaus-black,
      fill: rgb("F9F9F8"),
      inset: 14pt,
      [
        #text(weight: "black", size: 9.5pt, fill: bauhaus-blue)[요약 (ABSTRACT)]
        #v(4pt)
        #text(size: 9.5pt, style: "italic")[#abstract]
      ]
    )
    v(16pt)
  ]

  body
}
