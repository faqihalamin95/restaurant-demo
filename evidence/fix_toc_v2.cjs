const fs = require('fs');
const path = require('path');

function walkDir(dir, callback) {
    fs.readdirSync(dir).forEach(f => {
        let dirPath = path.join(dir, f);
        let isDirectory = fs.statSync(dirPath).isDirectory();
        isDirectory ? walkDir(dirPath, callback) : callback(path.join(dir, f));
    });
}

let modifiedCount = 0;

walkDir('./pages', function(filePath) {
    if (!filePath.endsWith('.md')) return;
    
    let content = fs.readFileSync(filePath, 'utf8');
    let original = content;

    // We don't remove existing ones because they were carefully added, 
    // actually let's just do a fresh pass if needed, but it's fine.

    // 1. Match <h2 class="hero-card-title"> (multi-line potentially)
    content = content.replace(/<h2 class="hero-card-title"[^>]*>([\s\S]*?)<\/h2>/g, (match, titleHtml) => {
        if (match.includes('toc-anchor')) return match; // Skip if already done
        let cleanTitle = titleHtml.replace(/<[^>]+>/g, '').trim();
        if (!cleanTitle) return match;
        return `<div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">\n\n## ${cleanTitle}\n\n</div>\n${match}`;
    });

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated ${filePath}`);
        modifiedCount++;
    }
});

console.log(`Done v2! Modified ${modifiedCount} files.`);
