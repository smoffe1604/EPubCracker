# get 3.1.0
https://github.com/Alex313031/thorium/releases

# run the installed Thorium executable with flags
"C:\Users\SimonLolkPallesen\AppData\Local\Programs\Thorium\Thorium.exe" --remote-debugging-port=9223 --remote-allow-origins=*

# download zip
"C:\Program Files\7-Zip\7z.exe" a -mx0 mybook.epub mimetype

"C:\Program Files\7-Zip\7z.exe" a -mx9 mybook.epub * -x!mimetype -x!mybook.epub

# GET the xhtml text and download it.
```javascript

fetch(window.location.href)
  .then(response => response.text())
  .then(html => {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const bodyElement = doc.querySelector('body');

    if (!bodyElement) {
      console.log('No`<body>` tag found in the source.');
      return;
    }

    const bodyHTML = bodyElement.outerHTML;

    const fullHTML = ``<!DOCTYPE html>`

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" lang="da" xml:lang="da">
<head>
    <meta charset="utf-8" />
</head>

${bodyHTML}
</html>`;

    // Create a Blob for the file content
    const blob = new Blob([fullHTML], { type: 'text/html' });

    // Use File System Access API to trigger a real Save As dialog
    if ('showSaveFilePicker' in window) {
      window.showSaveFilePicker({
        suggestedName: 'content.xhtml',  // You can change the default filename here
        types: [{
          description: 'XHTML File',
          accept: { 'application/xhtml+xml': ['.xhtml', '.html'] },
        }],
      })
      .then(handle => handle.createWritable())
      .then(writable => writable.write(blob).then(() => writable.close()))
      .then(() => {
        console.log('✅ File saved successfully via Save As dialog!');
      })
      .catch(err => {
        if (err.name !== 'AbortError') {  // User didn't cancel
          console.error('Save failed:', err);
        } else {
          console.log('Save cancelled by user.');
        }
      });
    } else {
      // Fallback message if browser doesn't support the API (unlikely on modern Chrome/Edge)
      console.log('Your browser doesn\'t support direct Save As. Falling back to copy-to-clipboard.');
      navigator.clipboard.writeText(fullHTML).then(() => {
        console.log('Copied to clipboard instead! Paste into a new file.');
      });
    }
  })
  .catch(err => console.error('Error:', err));
```
  
