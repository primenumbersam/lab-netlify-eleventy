// ==========================================
// Lightweight Bauhaus Search (src/assets/js/search.js)
// search.json 기반 실시간 클라이언트 검색 모달
// ==========================================

(function() {
  let searchIndex = null;

  window.addEventListener("DOMContentLoaded", () => {
    const modal = document.getElementById("search-modal");
    const openBtn = document.getElementById("search-open");
    const closeBtn = document.getElementById("search-close");
    const input = document.getElementById("search-input");
    const results = document.getElementById("search-results");

    if (!modal || !openBtn || !input || !results) return;

    // 인덱스 지연 로드 (초기 네트워크 부담 방지)
    async function loadIndex() {
      if (!searchIndex) {
        try {
          const res = await fetch("/search.json");
          searchIndex = await res.json();
        } catch (e) {
          console.error("Failed to load search index", e);
          searchIndex = [];
        }
      }
    }

    function openModal() {
      modal.classList.add("open");
      loadIndex();
      setTimeout(() => input.focus(), 50);
    }

    function closeModal() {
      modal.classList.remove("open");
      input.value = "";
      results.innerHTML = "";
    }

    openBtn.addEventListener("click", openModal);
    closeBtn?.addEventListener("click", closeModal);

    // ESC 키로 닫기, '/' 단축키로 열기
    document.addEventListener("keydown", (e) => {
      if (e.key === "/" && !["INPUT", "TEXTAREA"].includes(document.activeElement.tagName)) {
        e.preventDefault();
        openModal();
      }
      if (e.key === "Escape" && modal.classList.contains("open")) {
        closeModal();
      }
    });

    // 배경 클릭 시 닫기
    modal.addEventListener("click", (e) => {
      if (e.target === modal) closeModal();
    });

    // 검색 필터링
    input.addEventListener("input", () => {
      const q = input.value.trim().toLowerCase();
      if (!q || !searchIndex) {
        results.innerHTML = "";
        return;
      }

      const matches = searchIndex.filter(item => {
        const titleMatch = item.title?.toLowerCase().includes(q);
        const descMatch = item.description?.toLowerCase().includes(q);
        return titleMatch || descMatch;
      }).slice(0, 8);

      if (matches.length === 0) {
        results.innerHTML = `<li style="padding: 0.75rem; color: var(--text-secondary);">검색 결과가 없습니다.</li>`;
        return;
      }

      results.innerHTML = matches.map(item => `
        <li>
          <a href="${item.url}">
            <div style="font-weight: 800;">${item.title}</div>
            ${item.description ? `<div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 2px;">${item.description}</div>` : ""}
          </a>
        </li>
      `).join("");
    });
  });
})();
