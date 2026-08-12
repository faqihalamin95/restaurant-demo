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

    // Remove span markers completely
    content = content.replace(/<span class="toc-anchor-marker"><\/span>\s*/g, '');
    
    // The previous injected ## headers are still there! 
    // They are right before <h2 or <SectionHeader.
    // We should be careful. I'll just remove the span, which leaves the ## Title.
    // Wait, if I leave ## Title, the user sees duplicates!
    // Let me find ## Title\n\n<h2 and remove the ## Title.
    
    content = content.replace(/^##\s+.*?\n+(?=<h2|<SectionHeader)/gm, '');

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Cleaned ${filePath}`);
        modifiedCount++;
    }
});

console.log(`Done cleanup v2! Modified ${modifiedCount} files.`);
