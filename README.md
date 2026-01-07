## Thorium setup (Windows)

- **Download Thorium 3.1.0**: `https://github.com/Alex313031/thorium/releases`

## Launch Thorium with remote debugging

Run this from **CMD**:

```bat
"C:\Users\SimonLolkPallesen\AppData\Local\Programs\Thorium\Thorium.exe" --remote-debugging-port=9223 --remote-allow-origins=*
```

## Create an `.epub` using 7-Zip

Important: EPUB requires `mimetype` to be the **first entry** and stored **without compression**.

```bat
"C:\Program Files\7-Zip\7z.exe" a -mx0 mybook.epub mimetype
"C:\Program Files\7-Zip\7z.exe" a -mx9 mybook.epub * -x!mimetype -x!mybook.epub
```

## Notes on DevTools / rendered content

Thorium (Readium) renders EPUB resources by parsing the XHTML and then injecting runtime CSS / scripts (e.g. ReadiumCSS). The DOM you see in DevTools is therefore a **post-processed runtime view**, not a clean copy of the original chapter source.

If you need an automated workflow for protected publications, use provider/publisher-supported export features or an authorized LCP integration/SDK.
