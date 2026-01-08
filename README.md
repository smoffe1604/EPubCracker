# get 3.1.0
https://github.com/Alex313031/thorium/releases

# run the installed Thorium executable with flags
"C:\Users\SimonLolkPallesen\AppData\Local\Programs\Thorium\Thorium.exe" --remote-debugging-port=9223 --remote-allow-origins=*

# download zip
"C:\Program Files\7-Zip\7z.exe" a -mx0 mybook.epub mimetype

"C:\Program Files\7-Zip\7z.exe" a -mx9 mybook.epub * -x!mimetype -x!mybook.epub

# GET the xhtml text and download it.
```javascript


(async () => {
    // === 1. Extract filename ===
    let filename = 'chapter.xhtml';
    try {
        const pathname = window.location.pathname;
        const lastSlashIndex = pathname.lastIndexOf('/');
        if (lastSlashIndex !== -1) {
            const potentialName = pathname.slice(lastSlashIndex + 1);
            const cleanName = potentialName.split('?')[0];
            if (cleanName && cleanName.endsWith('.xhtml')) filename = cleanName;
        }
    } catch (e) {}
    console.log(`📄 Saving as: ${filename}`);

    // === 2. Clone document ===
    const clonedDoc = document.cloneNode(true);

    // === 3. Thorough entity decoding in scripts and styles ===
    const aggressiveDecode = text => text
        .replace(/&gt;/g, '>')
        .replace(/&lt;/g, '<')
        .replace(/&amp;/g, '&')
        .replace(/&quot;/g, '"')
        .replace(/&#39;/g, "'");

    clonedDoc.querySelectorAll('script, style').forEach(el => {
        if (el.textContent) {
            el.textContent = aggressiveDecode(el.textContent);
        }
    });

    // === 4. Remove Thorium scripts ===
    clonedDoc.querySelectorAll('script').forEach(script => {
        const txt = script.textContent || '';
        if (txt.includes('_thorium_websql_void_openDatabase') ||
            txt.includes('ers.name = "Thorium"') ||
            txt.includes('dragstart capture')) {
            script.remove();
        }
    });

    // === 5. Remove cursor-hiding class and rules ===
    clonedDoc.documentElement.classList.remove('r2-hideCursor');
    clonedDoc.querySelectorAll('style').forEach(style => {
        if (style.textContent && style.textContent.includes('r2-hideCursor')) {
            style.textContent = style.textContent.replace(/\.r2-hideCursor[^}]*\}|\.r2-hideCursor\s*,[\s\S]*?\{[^}]*\}/g, '');
        }
    });

    // Clean reader attributes
    clonedDoc.documentElement.removeAttribute('data-readiumcss-injected');
    clonedDoc.documentElement.removeAttribute('data-readiumcss');

    // === 6. Force readable colors + visible cursor ===
    const forceStyle = clonedDoc.createElement('style');
    forceStyle.textContent = `
        :root {
            --RS__backgroundColor: white !important;
            --RS__textColor: black !important;
            --USER__backgroundColor: white !important;
            --USER__textColor: black !important;
        }
        body { background-color: white !important; color: black !important; }
        *, *::before, *::after { cursor: auto !important; }
        html, body { cursor: default !important; }
    `;
    clonedDoc.head.appendChild(forceStyle);

    // === 7. Serialize and save ===
    const xhtml = `<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
${clonedDoc.documentElement.outerHTML}`;

    const blob = new Blob([xhtml], { type: 'application/xhtml+xml' });

    if ('showSaveFilePicker' in window) {
        try {
            const handle = await window.showSaveFilePicker({
                suggestedName: filename,
                types: [{ description: 'EPUB Chapter (XHTML)', accept: { 'application/xhtml+xml': ['.xhtml'] } }],
            });
            const writable = await handle.createWritable();
            await writable.write(blob);
            await writable.close();
            console.log(`✅ "${filename}" saved – clean CSS (no &gt; anywhere), visible cursor, perfect rendering!`);
        } catch (err) {
            if (err.name !== 'AbortError') console.error(err);
        }
    } else {
        await navigator.clipboard.writeText(xhtml);
        console.log(`📋 Copied clean version – paste into "${filename}"`);
    }
})();


```
  
