import markdownIt from "markdown-it";
import katex from "katex";
import { InputPathToUrlTransformPlugin } from "@11ty/eleventy";
import fs from "node:fs";

// 최신 KaTeX 인라인/블록 렌더러 플러그인
function modernKatexPlugin(md, options = {}) {
  const defaultInline = function(latex) {
    try {
      return katex.renderToString(latex, { displayMode: false, throwOnError: false, ...options });
    } catch (e) {
      return latex;
    }
  };

  const defaultBlock = function(latex) {
    try {
      return `<p>${katex.renderToString(latex, { displayMode: true, throwOnError: false, ...options })}</p>`;
    } catch (e) {
      return latex;
    }
  };

  md.inline.ruler.after("escape", "math_inline", (state, silent) => {
    if (state.src[state.pos] !== "$") return false;
    let start = state.pos + 1;
    let match = state.src.indexOf("$", start);
    if (match === -1) return false;
    if (!silent) {
      const token = state.push("math_inline", "math", 0);
      token.markup = "$";
      token.content = state.src.slice(start, match);
    }
    state.pos = match + 1;
    return true;
  });

  md.block.ruler.after("blockquote", "math_block", (state, start, end, silent) => {
    let pos = state.bMarks[start] + state.tShift[start];
    let max = state.eMarks[start];
    if (pos + 2 > max || state.src.slice(pos, pos + 2) !== "$$") return false;
    pos += 2;
    let firstLine = state.src.slice(pos, max);
    if (silent) return true;
    let next = start;
    let lastLine = "";
    if (firstLine.trim().slice(-2) === "$$") {
      firstLine = firstLine.trim().slice(0, -2);
    } else {
      while (++next < end) {
        let p = state.bMarks[next] + state.tShift[next];
        let m = state.eMarks[next];
        if (state.src.slice(p, m).trim().slice(-2) === "$$") {
          let idx = state.src.slice(0, m).lastIndexOf("$$");
          lastLine = state.src.slice(p, idx);
          break;
        }
      }
    }
    state.line = next + 1;
    const token = state.push("math_block", "math", 0);
    token.block = true;
    token.content = (firstLine ? firstLine + "\n" : "") + (lastLine ? lastLine : "");
    token.markup = "$$";
    return true;
  });

  md.renderer.rules.math_inline = (tokens, idx) => defaultInline(tokens[idx].content);
  md.renderer.rules.math_block = (tokens, idx) => defaultBlock(tokens[idx].content) + "\n";
}

export default function(eleventyConfig) {
  // 전역 사이트 설정 주입
  const settings = JSON.parse(fs.readFileSync("./settings.json", "utf-8"));
  eleventyConfig.addGlobalData("site", settings);

  // 0. 상대 경로 이미지 및 링크 자동 변환
  eleventyConfig.addPlugin(InputPathToUrlTransformPlugin);
  // 1. 마크다운 & 최신 KaTeX 수식 설정
  const mdOptions = {
    html: true,
    breaks: true,
    linkify: true
  };
  const markdownLib = markdownIt(mdOptions).use(modernKatexPlugin);

  // 마크다운 상대 이미지 경로를 사이트 루트 기준 절대 경로로 자동 보정
  const defaultImageRender = markdownLib.renderer.rules.image || function(tokens, idx, options, env, self) {
    return self.renderToken(tokens, idx, options);
  };
  markdownLib.renderer.rules.image = function(tokens, idx, options, env, self) {
    const token = tokens[idx];
    const srcIndex = token.attrIndex("src");
    if (srcIndex >= 0) {
      const src = token.attrs[srcIndex][1];
      if (!src.startsWith("/") && !src.startsWith("http://") && !src.startsWith("https://") && !src.startsWith("data:")) {
        token.attrs[srcIndex][1] = `/content/${src}`;
      }
    }
    return defaultImageRender(tokens, idx, options, env, self);
  };

  eleventyConfig.setLibrary("md", markdownLib);

  // 2. 단원 정렬 컬렉션 (order 기준)
  eleventyConfig.addCollection("chapters", function(collectionApi) {
    return collectionApi.getFilteredByTag("chapter").sort((a, b) => {
      const orderA = a.data.eleventyNavigation?.order ?? 99;
      const orderB = b.data.eleventyNavigation?.order ?? 99;
      return orderA - orderB;
    });
  });

  // 3. 정적 파일 복사
  eleventyConfig.addPassthroughCopy({ "src/assets": "assets" });
  eleventyConfig.addPassthroughCopy({ "assets": "assets" });
  eleventyConfig.addPassthroughCopy("content/**/*.{png,jpg,jpeg,gif,svg,webp}");

  return {
    dir: {
      input: ".",
      includes: "src/_includes",
      output: "_site"
    }
  };
}