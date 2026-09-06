# 📘 Deploy Docs with SSG + Typesetting
> **Eleventy(Web SSG)**와 **Typst(Typesetting PDF)**를 결합한 초경량 미니멀 보일러플레이트 (Lightweight Minimal Boilerplate)

인공지능 이해를 위한 기초수학 교과서를 주제로 구축되었으며, **웹에는 개괄적인 총론**을 빠르고 반응성 높은 SSG로 제공하고, **심화 각론은 수식 조판 엔진인 Typst를 통해 고품질 PDF**로 빌드하여 HTML에 유기적으로 연결한다.

[🌐 배포 사이트 미리보기 (Netlify)](https://lab-eleventy-libdoc.netlify.app)

---

## 🎯 프로젝트 목적 및 설계 철학

기존 복잡한 테마(LibDoc 등)는 과도한 디렉터리 뎁스, 수많은 블랙박스 설정 파일, CPU를 과점유하는 실시간 이미지 프로세싱 등으로 인해 개발 환경에서 극심한 병목과 유지보수 피로를 유발했다.

본 프로젝트는 다음 철학을 바탕으로 재설계되었다:

1. **Clear & Minimal (블랙박스 제로)**: 
   - 테마 라이브러리에 종속된 불필요한 레이어(`core/`, `_data/`, 수십 개의 JS 헬퍼)를 걷어내고, 구조를 한눈에 파악할 수 있는 단일화된 구조로 정돈했다.
2. **관심사의 분리 (SSG 총론 ↔ 조판 각론)**:
   - **웹 총론 (`content/`)**: Eleventy가 Markdown을 정적 HTML로 컴파일하여 초고속 서빙.
   - **PDF 각론 (`typst/`)**: Typst 엔진이 LaTeX급 미려한 조판으로 컴파일하여 인쇄/다운로드용 문서 생성.
3. **Bauhaus Art Style UI**:
   - 기하학적 형태(원·사각형·삼각형), 선명한 굵은 선(Bold Borders), 바우하우스 삼원색(Red `#D82B27`, Blue `#185ADB`, Yellow `#F4B41A`) 기반의 독창적이고 기능적인 디자인 시스템.
   - 다크/라이트 테마 및 모바일 드로어 메뉴 지원.
4. **Zero-Overhead & One-Step Pipeline**:
   - 로컬에서는 `0.2초` 내외의 초고속 증분 빌드를 제공하고, Netlify 배포 환경에서는 `npm run build` 명령 하나로 Typst 컴파일과 웹 빌드가 동시에 수행된다.

---

## 🛠 기술적 도구 및 개선점 (Technical Stack & Improvements)

### 1. 기술 스택 (Tools)
*   **SSG 엔진**: [Eleventy (11ty) v3](https://www.11ty.dev/) (ESM 기반 빠른 빌드)
*   **조판 엔진**: [Typst v0.15+](https://typst.app/) (C++ 기반 초고속 PDF Typesetting 컴파일러)
*   **수식 렌더링**: `markdown-it` + `markdown-it-katex` (LaTeX 수식 네이티브 렌더링)
*   **스타일링**: 순수 Vanilla CSS (Tailwind 등 번들러 의존성 배제, CSS 변수 기반 바우하우스 테마 시스템)
*   **검색 엔진**: 정적 `search.json` 기반 초경량 바닐라 클라이언트 검색 (단축키 `/` 지원)
*   **배포 환경**: Netlify (CI/CD 자동 빌드 및 독립 Typst 바이너리 파이프라인 연동)

### 2. 주요 기술적 개선점 (Key Improvements)
*   **빌드 속도 획기적 개선**:
    - 기존 테마의 무거운 이미지 On-demand 트랜스폼(sharp/avif 3벌 리사이징 병목)을 제거하고, 정적 에셋 직접 복사 방식으로 전환하여 빌드 시간을 **0.3초대**로 대폭 단축.
*   **마크다운 상대 이미지 경로 자동 보정**:
    - 마크다운 문서 내 상대 경로(`![alt](폴더/이미지.png)`)가 서브디렉터리 URL 계층 구조에서 깨지는 문제를 해결하기 위해, `markdown-it` 렌더러 수준에서 사이트 루트 절대 경로(`/content/...`)로 자동 치환하는 정밀 훅 적용.
*   **Typst 템플릿 2종 내장**:
    - `typst/templates/textbook.typ`: 기하학적 바우하우스 헤더와 정의/정리/참고 박스가 포함된 교재형 템플릿.
    - `typst/templates/paper.typ`: 아티클/논문 형태의 학술형 조판 템플릿.
*   **모바일 반응형 드로어 UI**:
    - 데스크톱의 듀얼 컬럼 레이아웃이 860px 이하 뷰포트에서 상단 햄버거 버튼(`☰`)과 슬라이딩 드로어 메뉴로 자연스럽게 전환.

---

## 📁 디렉터리 구조 (File Structure)

```text
lab-netlify-eleventy/
├── .eleventy.js           # Eleventy 핵심 설정 (KaTeX, 이미지 경로 보정, 컬렉션, 복사 규칙)
├── .eleventyignore        # 빌드 제외 목록 (bin, typst, scripts 등)
├── package.json           # 빌드 스크립트 파이프라인 정의
├── netlify.toml           # Netlify 배포 빌드 환경 설정
│
├── content/               # [웹 총론 콘텐츠] Eleventy Markdown 문서 및 관련 이미지
│   ├── index.md           # 대문 / 총론 개요
│   ├── 01-정보 윤리.md
│   ├── 04-자료-이미지-영상.md
│   └── 04-자료-이미지-영상/ # 단원별 로컬 이미지 디렉터리
│
├── typst/                 # [조판 각론 콘텐츠] Typst 소스 파일 및 조판 템플릿
│   ├── templates/
│   │   ├── textbook.typ   # 교재/강의노트용 바우하우스 템플릿
│   │   └── paper.typ      # 심화 논문/아티클용 템플릿
│   ├── 01-정보-윤리-각론.typ
│   └── 04-자료-이미지-영상-각론.typ
│
├── src/                   # [웹 UI 레이아웃 및 프론트엔드 에셋]
│   ├── _includes/
│   │   ├── base.liquid    # 기본 HTML 뼈대, 헤더, 사이드바, 검색 모달
│   │   └── page.liquid    # 본문 템플릿 + 각론 PDF 다운로드/열람 배너 카드
│   ├── search.json.liquid # 실시간 검색 인덱스 자동 생성 템플릿
│   └── assets/
│       ├── css/
│       │   └── bauhaus.css # 바우하우스 디자인 시스템, 다크/라이트 테마, 모바일 반응형
│       └── js/
│           ├── theme.js   # 테마 토글러 (localStorage 유지)
│           └── search.js  # 실시간 클라이언트 검색 스크립트
│
├── scripts/
│   ├── ensure-typst.sh    # 플랫폼별 Typst 바이너리 자동 다운로드 및 검증
│   └── build-pdf.sh       # typst/*.typ 파일들을 _site/pdf/*.pdf로 일괄 컴파일
│
└── _site/                 # [배포 산출물] Web HTML + PDF 파일
    ├── content/...
    └── pdf/               # Typst에서 컴파일되어 생성된 PDF 모음
        ├── 01-정보-윤리-각론.pdf
        └── 04-자료-이미지-영상-각론.pdf
```

---

## 🚀 사용법 (Usage & Workflow)

### 1. 사전 준비 및 의존성 설치
Node.js 20+ 환경에서 다음 명령어로 의존성을 설치한다:
```bash
npm install
```

### 2. 로컬 실시간 개발 (Live Reload)
증분 빌드(`--incremental`)가 적용된 로컬 개발 서버를 구동한다:
```bash
npm run dev
```
*   서버 주소: `http://localhost:8080/`
*   마크다운이나 CSS 수정 시 `0.1~0.2초` 내에 변경사항이 즉시 반영된다.

### 3. Typst PDF 각론 조판 빌드
Typst CLI가 로컬 환경에 없어도 `scripts/ensure-typst.sh`가 Linux 바이너리를 자동 확보하여 컴파일을 수행한다:
```bash
npm run build:pdf
```
*   `typst/*.typ`의 모든 문서가 `_site/pdf/*.pdf`로 컴파일된다.

### 4. 배포용 통합 빌드 (Production Build)
Netlify CI 환경에서 실행되는 전체 빌드 커맨드:
```bash
npm run build
```
*   `npm run build:pdf` → `npm run build:site` 순서로 자동 실행되어 완전한 정적 사이트 패키지가 `_site/`에 생성된다.

### 5. 웹 총론에 각론 PDF 연동하기
마크다운 문서 상단 Frontmatter에 `pdf: "파일명.pdf"` 속성만 추가하면, 해당 웹 페이지 상단에 바우하우스 스타일의 **[다운로드 / 열람]** 배너 카드가 자동으로 생성된다:

```markdown
---
title: "04-자료-이미지, 영상"
description: "이미지 자료는 행렬로 표현되며, 흑백은 단층, 컬러는 다층 행렬이다."
eleventyNavigation:
  key: "04-자료-이미지, 영상"
  order: 4
pdf: "04-자료-이미지-영상-각론.pdf"
---

본문 총론 내용...
```