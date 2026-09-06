// ==========================================
// Bauhaus Theme Controller (src/assets/js/theme.js)
// 다크/라이트 모드 로컬 스토리지 연동 및 모바일 메뉴 제어
// ==========================================

(function() {
  const STORAGE_KEY = "bh-theme";
  const root = document.documentElement;

  // 1. 테마 초기화
  const saved = localStorage.getItem(STORAGE_KEY);
  const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
  const currentTheme = saved || (prefersDark ? "dark" : "light");
  root.setAttribute("data-theme", currentTheme);

  window.addEventListener("DOMContentLoaded", () => {
    const themeBtn = document.getElementById("theme-toggle");
    if (themeBtn) {
      updateThemeBtn(themeBtn, currentTheme);
      themeBtn.addEventListener("click", () => {
        const nextTheme = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
        root.setAttribute("data-theme", nextTheme);
        localStorage.setItem(STORAGE_KEY, nextTheme);
        updateThemeBtn(themeBtn, nextTheme);
      });
    }

    // 모바일 사이드바 토글
    const menuBtn = document.getElementById("menu-toggle");
    const sidebar = document.querySelector(".bh-sidebar");
    if (menuBtn && sidebar) {
      menuBtn.addEventListener("click", () => {
        sidebar.classList.toggle("open");
      });
      // 본문 클릭 시 사이드바 닫기
      document.querySelector(".bh-main-content")?.addEventListener("click", () => {
        sidebar.classList.remove("open");
      });
    }
  });

  function updateThemeBtn(btn, theme) {
    btn.innerHTML = theme === "dark" 
      ? `<span>☀️</span><span class="btn-text">Light</span>` 
      : `<span>🌙</span><span class="btn-text">Dark</span>`;
  }
})();
