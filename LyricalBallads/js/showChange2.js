//* This script is for LB00-1a and LB00-1b, to display a popup comparison for cancel / uncancelled pages */
  function openChangeInPopup(e, selector) {
    e.preventDefault();

    // Figure out which element we clicked on (the <a> or whatever)
    const trigger = e.currentTarget || e.target.closest('a');
    if (!trigger) return console.error('Couldn’t find trigger element');

    // Grab the content you want to show
    const sourceEl = document.querySelector(selector);
    if (!sourceEl) {
      console.error('Missing content for selector: ' + selector);
      return;
    }
    const content = sourceEl.innerHTML;

    // Compute screen‐coordinates of the trigger
    const rect  = trigger.getBoundingClientRect();
    const left  = window.screenX + rect.right + 400; // element’s right edge + 600px
    const top   = window.screenY + rect.top;

    // Open the popup at that position
    const popup = window.open('',
      'changePopup',
      `width=500,height=300,left=${left},top=${top},scrollbars=yes,resizable=yes`
    );
    if (!popup) {
      return alert('Popup blocked—please allow pop‑ups for this site.');
    }

    // Inject your HTML
    popup.document.write(`
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <title>New</title>
          <style>
            body { font-family: serif; margin: 1em; line-height: 1.6; }
          </style>
        </head>
        <body>
          ${content}
        </body>
      </html>
    `);
    popup.document.close();
  }
