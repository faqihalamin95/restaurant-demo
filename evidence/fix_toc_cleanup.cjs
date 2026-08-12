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

    // Remove span markers and their following ## headings that were injected
    // Pattern: <span class="toc-anchor-marker"></span>\n\n## Title\n\n followed by the real HTML heading
    content = content.replace(/<span class="toc-anchor-marker"><\/span>\s*\n\n## [^\n]+\n\n/g, '');
    
    // Also remove any leftover .md.test files references
    
    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Cleaned ${filePath}`);
        modifiedCount++;
    }
});

console.log(`Done cleanup! Modified ${modifiedCount} files.`);
