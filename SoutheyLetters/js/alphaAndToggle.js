(function () {
  // 1. Cache alphabet buttons and map them by hash href
  const alphaBtns = Array.from(document.querySelectorAll('.alpha-btn'));
  const btnMap = new Map(alphaBtns.map(btn => [btn.getAttribute('href'), btn]));
  const alphaContainer = document.querySelector('.alphabet-container');

  let activeBtn = null;

  function highlightActiveLetter() {
    const currentHash = window.location.hash;

    // Clear previous active state
    if (activeBtn) {
      activeBtn.classList.remove('active');
      activeBtn = null;
    }

    // Set new active button instantly
    if (currentHash && btnMap.has(currentHash)) {
      activeBtn = btnMap.get(currentHash);
      activeBtn.classList.add('active');
    }
  }

  // 2. Global Event Delegation for toggle headings
  document.body.addEventListener('click', (e) => {
    const hdr = e.target.closest('.menList > h5.menHdr, .toList > h5.toHdr');
    if (!hdr) return;

    hdr.classList.toggle('expanded');
    const list = hdr.nextElementSibling;
    if (list) {
      list.classList.toggle('expanded');
    }
  });

  // 3. Expose clear function globally for inline onclick handlers
  window.clearAlphabetFilter = function () {
    history.replaceState(null, '', window.location.pathname + window.location.search);
    highlightActiveLetter();
    if (alphaContainer) {
      alphaContainer.scrollIntoView({ behavior: 'smooth' });
    }
  };

  // 4. Initialize hash highlighting on load and listen for hash changes
  window.addEventListener('hashchange', highlightActiveLetter);
  highlightActiveLetter();
})();