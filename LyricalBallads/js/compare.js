// Referenced by individual comparison files in the compare folder

function setupCompareMenus() {
    const $ = (id) => document.getElementById(id);

    function wire(dropId, descId, frameId) {
        const dd = $(dropId);
        const desc = $(descId);
        const fr = $(frameId);

        if (!dd || !desc || !fr) return;

        dd.addEventListener('change', () => {
            const opt = dd.options[dd.selectedIndex];
            const url = opt ? opt.value : '';
            const text = opt?.value ? (opt.getAttribute('data-description') || 'No description available') : 'Select an edition to view its description';

            if (url) {
                fr.src = url;
                desc.textContent = text;
            } else {
                desc.textContent = 'Select an edition to view its description';
            }
        });
    }

    wire('dropdown1', 'description1', 'f1');
    wire('dropdown2', 'description2', 'f2');

    // Parse URL parameters and set dropdowns
    const params = new URLSearchParams(window.location.search);
    const leftParam = params.get('left');
    const rightParam = params.get('right');

    if (leftParam) {
        const d1 = $('dropdown1');
        if (d1) { d1.value = leftParam; d1.dispatchEvent(new Event('change')); }
    }
    if (rightParam) {
        const d2 = $('dropdown2');
        if (d2) { d2.value = rightParam; d2.dispatchEvent(new Event('change')); }
    }
}

/**
 * Logic for Copy Link Button
 */
function setupCopyButton() {
    const copyBtn = document.getElementById('copyLinkBtn');
    const feedback = document.getElementById('copyFeedback');
    
    if (!copyBtn) return;

    copyBtn.addEventListener('click', () => {
        const left = document.getElementById('dropdown1').value;
        const right = document.getElementById('dropdown2').value;
        
        // Construct a URL with the current selections
        const baseUrl = window.location.origin + window.location.pathname;
        const shareUrl = `${baseUrl}?left=${encodeURIComponent(left)}&right=${encodeURIComponent(right)}`;

        navigator.clipboard.writeText(shareUrl).then(() => {
            if (feedback) {
                feedback.style.display = 'inline';
                setTimeout(() => { feedback.style.display = 'none'; }, 2000);
            }
        });
    });
}

/**
 * Logic for Stanza-based Scroll Sync
 */
function setupScrollSync() {
    const f1 = document.getElementById('f1');
    const f2 = document.getElementById('f2');
    const syncBtn = document.getElementById('syncToggleBtn');
    
    let isSyncEnabled = true;
    let isSyncing = false;

    if (syncBtn) {
        syncBtn.addEventListener('click', () => {
            isSyncEnabled = !isSyncEnabled;
            if (isSyncEnabled) {
                syncBtn.textContent = 'Sync Scrolling: On';
                syncBtn.classList.remove('sync-btn-off');
            } else {
                syncBtn.textContent = 'Sync Scrolling: Off';
                syncBtn.classList.add('sync-btn-off');
            }
        });
    }

    function syncFrames(sourceFrame, targetFrame) {
        if (!isSyncEnabled || isSyncing) return;

        try {
            const srcDoc = sourceFrame.contentDocument;
            const tgtDoc = targetFrame.contentDocument;
            if (!srcDoc || !tgtDoc) return;

            // Use the documentElement or body depending on browser
            const scrollTop = srcDoc.documentElement.scrollTop || srcDoc.body.scrollTop;
            const sourceStanzas = Array.from(srcDoc.querySelectorAll('.stzNbr'));
            
            // Find which stanza is currently at the top of the frame
            let currentStz = null;
            for (let stz of sourceStanzas) {
                if (stz.offsetTop >= scrollTop - 10) {
                    currentStz = parseInt(stz.textContent.trim(), 10);
                    break;
                }
            }

            if (currentStz !== null) {
                const targetStanzas = Array.from(tgtDoc.querySelectorAll('.stzNbr'));
                const match = targetStanzas.find(s => parseInt(s.textContent.trim(), 10) === currentStz);
                
                if (match) {
                    isSyncing = true;
                    // Align the target frame to the matching stanza number
                    tgtDoc.documentElement.scrollTop = match.offsetTop;
                    tgtDoc.body.scrollTop = match.offsetTop;
                    
                    // Small timeout to prevent scroll event loops
                    setTimeout(() => { isSyncing = false; }, 100);
                }
            }
        } catch (e) {
            console.warn("Sync blocked: check cross-origin or frame loading status.");
        }
    }

    [f1, f2].forEach((frame, idx) => {
        const other = (idx === 0) ? f2 : f1;
        frame.addEventListener('load', () => {
            try {
                frame.contentDocument.addEventListener('scroll', () => syncFrames(frame, other), { passive: true });
            } catch (err) {
                console.error("Iframe access denied.");
            }
        });
    });
}

// Global initialization
document.addEventListener('DOMContentLoaded', () => {
    setupCompareMenus();
    setupCopyButton();
    setupScrollSync();
});