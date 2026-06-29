/* Static Reader (no framework) */

(function () {
    
    const EDITIONS = {
        "LB00-1": {
            transcript: "./data/LB00-1_facs.html", pagemap: "./data/pmLB00-1.json", provenance: "./data/LB00-1_provenance.html"
        },
        "LB98-L": {
            transcript: "./data/LB98-L_facs.html", pagemap: "./data/pmLB98-L.json", provenance: "./data/LB98-Lprovenance.html"
        },
    };
    let currentEdition = null;
    
    // Elements
    const provenanceModal = document.getElementById("provenanceModal");
    const provenanceBtn = document.getElementById("provenanceBtn");
    const transcriptPane = document.getElementById("transcriptPane");
    const transcriptInner = document.getElementById("transcriptInner");
    const imagePane = document.getElementById("imagePane");
    const divider = document.getElementById("divider");
    
    const prevBtn = document.getElementById("prevBtn");
    const nextBtn = document.getElementById("nextBtn");
    const prevOverlay = document.getElementById("prevOverlay");
    const nextOverlay = document.getElementById("nextOverlay");
    
    const romanForm = document.getElementById("romanForm");
    const arabicForm = document.getElementById("arabicForm");
    const romanInput = document.getElementById("romanInput");
    const arabicInput = document.getElementById("arabicInput");
    const romanDisplay = document.getElementById("romanDisplay");
    const arabicDisplay = document.getElementById("arabicDisplay");
    
    const toggleMobileMode = document.getElementById("toggleMobileMode");
    const editionSelect = document.getElementById("editionSelect");
    
    // State
    let pageMap = {
    };
    let internalDisplayMap = {
    };
    let orderedInternalIds =[];
    let romanDisplayCount = 0;
    let arabicDisplayCount = 0;
    
    let currentPage = "0005";
    let osdViewer = null;
    let isMobile = window.innerWidth < 1024;
    let viewMode = "transcript";
    let dividerPct = 50;
    
    // Flag to manage the transition between manual typing and manual scrolling
    let isManualJumping = false;
    
    // Utils
    function toRoman(num) {
        if (! num || num <= 0) return "";
        const vals =[1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        const syms =[ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
        let res = "";
        for (let i = 0; i < vals.length; i++) {
            while (num >= vals[i]) {
                num -= vals[i];
                res += syms[i];
            }
        }
        return res.toLowerCase();
    }
    
    const extractInternal = (path) => {
        const m = path.match(/(\d+)\.jpg$/);
        return m ? m[1]: null;
    };
    
    function buildDynamicMap(pm) {
        const map = {
        };
        const entries = Object.entries(pm).sort((a, b) => {
            const aNum = parseInt((a[1].match(/(\d+)\.jpg$/) ||[0, "0"])[1], 10);
            const bNum = parseInt((b[1].match(/(\d+)\.jpg$/) ||[0, "0"])[1], 10);
            return aNum - bNum;
        });
        
        for (const[key, path] of entries) {
            const internal = extractInternal(path);
            if (! internal) continue;
            const type = /^[ivxlcdm]+$/i.test(key) ? "roman": "arabic";
            map[internal] = {
                type, display: key
            };
        }
        return map;
    }
    
    function getDisplayFromInternal(id) {
        return internalDisplayMap[id] ?.display || id;
    }
    
    function getInternalFromDisplay(display) {
        const isRomanLiteral = /^[ivxlcdm]+$/i.test(display);
        const isArabicNumber = /^\d+$/.test(display);
        
        if (isRomanLiteral) {
            const key = display.toLowerCase();
            for (const id of orderedInternalIds) {
                if (internalDisplayMap[id].type === "roman" && internalDisplayMap[id].display === key)
                return id;
            }
        }
        
        if (isArabicNumber) {
            const n = parseInt(display, 10);
            if (! n || n <= 0) return orderedInternalIds[0];
            for (const id of orderedInternalIds) {
                if (internalDisplayMap[id].type === "arabic" && parseInt(internalDisplayMap[id].display, 10) === n)
                return id;
            }
            if (n <= romanDisplayCount) {
                let count = 0;
                for (const id of orderedInternalIds) {
                    if (internalDisplayMap[id].type === "roman") {
                        count++;
                        if (count === n) return id;
                    }
                }
            }
        }
        return orderedInternalIds[0];
    }
    
    function updateInputsFromCurrent() {
        const cur = internalDisplayMap[currentPage];
        const type = cur ?.type;
        const disp = cur ?.display || "—";
        
        if (document.activeElement !== romanInput && document.activeElement !== arabicInput) {
            if (type === "roman") {
                romanInput.value = disp;
                arabicInput.value = "";
            } else if (type === "arabic") {
                arabicInput.value = disp;
                romanInput.value = "";
            }
        }
        
        romanDisplay.textContent = romanDisplayCount ? `i-${toRoman(romanDisplayCount)}`: "—";
        arabicDisplay.textContent = arabicDisplayCount ? `1-${arabicDisplayCount}`: "—";
        
        const promptText = "Enter # ↵";
        romanInput.placeholder = romanDisplayCount ? promptText: "";
        arabicInput.placeholder = arabicDisplayCount ? promptText: "";
    }
    
    function setSplitWidth(pct) {
        dividerPct = pct;
        transcriptPane.style.width = `${dividerPct}%`;
    }
    
    // This handles the "Global" behaviors (Open and Escape key)
    function initProvenanceGlobalLogic() {
        if (! provenanceBtn || ! provenanceModal) return;
        
        // Open the modal when the icon is clicked
        provenanceBtn.addEventListener("click", () => {
            provenanceModal.style.display = "block";
        });
        
        // Close on Background Click
        window.addEventListener("click", (event) => {
            if (event.target === provenanceModal) provenanceModal.style.display = "none";
        });
        
        // Close on Escape Key
        document.addEventListener("keydown", (event) => {
            if (event.key === "Escape" && provenanceModal.style.display === "block") {
                provenanceModal.style.display = "none";
            }
        });
    }
    
    // This fetches the specific HTML and binds the "X" button
    async function loadProvenance(url) {
        try {
            const res = await fetch(url);
            if (! res.ok) throw new Error(`Provenance fetch failed: ${res.status}`);
            const html = await res.text();
            
            provenanceModal.innerHTML = html;
            
            // Re-bind the Close button because it's a "fresh" element from the fetch
            const newCloseBtn = provenanceModal.querySelector(".close-btn");
            if (newCloseBtn) {
                newCloseBtn.onclick = () => {
                    provenanceModal.style.display = "none";
                };
            }
        }
        catch (err) {
            console.error("Could not load provenance:", err);
            provenanceModal.innerHTML = `<div class="modal-content"><p>Error loading metadata.</p></div>`;
        }
    }
    
    function setMobileLayout() {
        isMobile = window.innerWidth < 1024;
        if (! isMobile) {
            transcriptPane.style.display = "block";
            imagePane.style.display = "block";
            toggleMobileMode.textContent = "Image";
            return;
        }
        if (viewMode === "transcript") {
            transcriptPane.style.display = "block";
            imagePane.style.display = "none";
            toggleMobileMode.textContent = "Image";
        } else {
            transcriptPane.style.display = "none";
            imagePane.style.display = "block";
            toggleMobileMode.textContent = "Transcript";
            if (osdViewer) osdViewer.viewport && osdViewer.viewport.goHome(true);
            if (osdViewer) osdViewer.forceRedraw();
        }
    }
    
    function currentImagePath() {
        const key = getDisplayFromInternal(currentPage);
        return pageMap[key] ? `./${pageMap[key]}`: null;
    }
    
    function initOrUpdateViewer() {
        const img = currentImagePath();
        if (! img) return;
        
        if (! window.OpenSeadragon) {
            setTimeout(initOrUpdateViewer, 50);
            return;
        }
        
        if (osdViewer) {
            try {
                osdViewer.destroy();
            }
            catch {
            }
            osdViewer = null;
        }
        
        osdViewer = window.OpenSeadragon({
            id: "osd",
            prefixUrl: "https://cdn.jsdelivr.net/npm/openseadragon@3.1.0/build/openseadragon/images/",
            tileSources: {
                type: "image", url: img
            },
            showNavigationControl: ! isMobile,
            showZoomControl: ! isMobile,
            showHomeControl: ! isMobile,
            showFullPageControl: false,
            navigationControlAnchor: window.OpenSeadragon.ControlAnchor.BOTTOM_LEFT,
            gestureSettingsMouse: {
                clickToZoom: true,
                dblClickToZoom: false,
                flickEnabled: true,
                pinchRotate: false,
            },
        });
    }
    
    function scrollTranscriptToCurrent(instant = true) {
        const el = document.getElementById(currentPage);
        if (el) {
            const targetScrollTop = el.offsetTop + 1;
            transcriptInner.scrollTo({
                top: targetScrollTop,
                behavior: instant ? "auto": "smooth"
            });
        }
    }
    
    function setCurrentPage(id, opts = { scrollTranscript: false, updateViewer: true
    }) {
        if (! id || id === currentPage) return;
        currentPage = id;
        
        updateInputsFromCurrent();
        
        if (opts.updateViewer) initOrUpdateViewer();
        
        if (opts.scrollTranscript) {
            isManualJumping = true;
            scrollTranscriptToCurrent(false);
            setTimeout(() => {
                isManualJumping = false;
            },
            1200);
        }
    }
    
    function goPrev() {
        const idx = orderedInternalIds.indexOf(currentPage);
        if (idx > 0) setCurrentPage(orderedInternalIds[idx - 1], {
            scrollTranscript: true, updateViewer: true
        });
    }
    
    function goNext() {
        const idx = orderedInternalIds.indexOf(currentPage);
        if (idx < orderedInternalIds.length - 1) setCurrentPage(orderedInternalIds[idx + 1], {
            scrollTranscript: true, updateViewer: true
        });
    }
    
    function onTranscriptScroll(e) {
        if (isManualJumping) return;
        
        const els = transcriptInner.querySelectorAll(".newPage");
        const paneRect = transcriptInner.getBoundingClientRect();
        
        const triggerThreshold = paneRect.top + (paneRect.height * 0.12);
        
        for (const el of els) {
            const r = el.getBoundingClientRect();
            if (r.top >= paneRect.top && r.top <= triggerThreshold) {
                const id = el.id;
                if (id && id !== currentPage) {
                    setCurrentPage(id, {
                        scrollTranscript: false, updateViewer: true
                    });
                }
                break;
            }
        }
    }
    
    async function loadTranscript(url) {
        const timestamp = new Date().getTime();
        const res = await fetch(`${url}?t=${timestamp}`, {
            cache: "no-cache"
        });
        if (! res.ok) throw new Error(`Transcript fetch failed: ${res.status}`);
        const html = await res.text();
        
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, "text/html");
        
        doc.querySelectorAll("img.pgImg").forEach((img) => img.remove());
        transcriptInner.removeEventListener("scroll", onTranscriptScroll);
        transcriptInner.innerHTML = doc.body.innerHTML;
        
        transcriptInner.addEventListener("scroll", onTranscriptScroll, {
            passive: true
        });
        
        const firstPage = transcriptInner.querySelector(".newPage[id]");
        if (firstPage ?.id) currentPage = firstPage.id;
    }
    
    async function loadPageMap(url) {
        const timestamp = new Date().getTime();
        const res = await fetch(`${url}?t=${timestamp}`, {
            cache: "no-cache"
        });
        if (! res.ok) throw new Error(`Page map fetch failed: ${res.status}`);
        pageMap = await res.json();
        
        internalDisplayMap = buildDynamicMap(pageMap);
        orderedInternalIds = Object.keys(internalDisplayMap).sort((a, b) => parseInt(a, 10) - parseInt(b, 10));
        
        romanDisplayCount = orderedInternalIds.filter(id => internalDisplayMap[id].type === "roman").length;
        arabicDisplayCount = orderedInternalIds.length - romanDisplayCount;
    }
    
    async function loadEdition(editionKey) {
        const ed = EDITIONS[editionKey];
        if (! ed) return;
        currentEdition = editionKey;
        await loadPageMap(ed.pagemap);
        await loadTranscript(ed.transcript);
        await loadProvenance(ed.provenance);
        
        // Automatically fall back to the first page if current ID doesn't exist
        if (! document.getElementById(currentPage)) {
            currentPage = orderedInternalIds[0];
        }
        updateInputsFromCurrent();
        initOrUpdateViewer();
        scrollTranscriptToCurrent(true);
    }
    
    function wireEvents() {
        initProvenanceGlobalLogic();
        // Set up the click/ESC listeners once
        prevBtn.addEventListener("click", goPrev);
        nextBtn.addEventListener("click", goNext);
        prevOverlay.addEventListener("click", goPrev);
        nextOverlay.addEventListener("click", goNext);
        
        romanForm.addEventListener("submit", (e) => {
            e.preventDefault();
            const v = romanInput.value.trim().toLowerCase();
            if (! v) return;
            const id = getInternalFromDisplay(v);
            if (id) {
                romanInput.blur();
                setCurrentPage(id, {
                    scrollTranscript: true, updateViewer: true
                });
            }
        });
        
        arabicForm.addEventListener("submit", (e) => {
            e.preventDefault();
            const v = arabicInput.value.trim();
            if (! v) return;
            const id = getInternalFromDisplay(v);
            if (id) {
                arabicInput.blur();
                setCurrentPage(id, {
                    scrollTranscript: true, updateViewer: true
                });
            }
        });
        
        editionSelect.addEventListener("change", () => {
            loadEdition(editionSelect.value);
        });
        
        toggleMobileMode.addEventListener("click", () => {
            viewMode = viewMode === "transcript" ? "image": "transcript";
            setMobileLayout();
        });
        
        let dragging = false;
        function onMove(ev) {
            if (! dragging) return;
            const pct = (ev.clientX / window.innerWidth) * 100;
            if (pct > 20 && pct < 80) setSplitWidth(pct);
        }
        function onUp() {
            dragging = false;
            document.removeEventListener("mousemove", onMove);
            document.removeEventListener("mouseup", onUp);
        }
        divider.addEventListener("mousedown", () => {
            dragging = true;
            document.addEventListener("mousemove", onMove);
            document.addEventListener("mouseup", onUp, {
                once: true
            });
        });
        
        window.addEventListener("resize", () => {
            setMobileLayout();
        });
    }
    
    async function main() {
        setSplitWidth(dividerPct);
        wireEvents();
        setMobileLayout();
        editionSelect.value = "LB00-1";
        await loadEdition("LB00-1");
    }
    
    main(). catch ((err) => {
        console.error(err);
        transcriptInner.innerHTML = `<p style="color:#b00;">Reader failed: ${String(err.message || err)}</p>`;
    });
})();