//Alt for editions.html
  function show() {
    const x = document.getElementById("explanation");
    const clearBtn = document.getElementById("clear");
    if (window.getComputedStyle(x).display === "none") {
      x.style.display = "block";
      clearBtn.style.display = "none";
    } else {
      x.style.display = "none";
      clearBtn.style.display = "block";
    }
  }

  function clearLinkColors() {
    document.querySelectorAll('#toc a')
      .forEach(link => link.style.color = '');
  }

  document.addEventListener('DOMContentLoaded', function () {
    const tocLinks            = document.querySelectorAll('#toc a');
    const currentViewElement  = document.getElementById('currentView');
    const linkOutAnchor       = document.getElementById('linkOutAnchor');
    const iframeTexts         = document.querySelector('iframe[name="texts"]');

    // create or grab the description <p>
    let desc = document.getElementById('currentDescription');
    if (!desc) {
      desc = document.createElement('p');
      desc.id = 'currentDescription';
      desc.style.marginTop = '0.5rem';
      desc.style.fontStyle = 'italic';
      desc.style.width = '35rem';
      currentViewElement.parentNode.insertBefore(desc, currentViewElement.nextSibling);
    }

    // set initial state to LB00-1
    const initialLink = document.querySelector('#toc a[href="HTML/LB00-1.html"]');
    if (initialLink) {
      desc.textContent         = initialLink.dataset.description || 'No description available.';
      linkOutAnchor.href       = initialLink.href;
      iframeTexts.src          = initialLink.href;
    }

    // wire up all TOC links
    tocLinks.forEach(link => {
      link.addEventListener('click', function (e) {
        e.preventDefault();

        const href = link.getAttribute('href');
        // 1) update title
        currentViewElement.textContent = link.textContent.trim();

        // 2) update description
        desc.textContent = link.dataset.description || 'No description available.';

        // 3) load iframe
        iframeTexts.src = href;

        // 4) update “open in new window” link
        linkOutAnchor.href = href;

        // 5) highlight
        tocLinks.forEach(l => l.style.color = '');
        link.style.color = '#3f6345';
      });
    });
  });