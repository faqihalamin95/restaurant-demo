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

    // Remove old broken div pattern completely
    content = content.replace(/<div class="toc-anchor"[^>]*>\s*##\s*(.*?)\s*<\/div>/g, '<span class="toc-anchor-marker"></span>\n\n## $1');

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated ${filePath}`);
        modifiedCount++;
    }
});

console.log(`Done v3! Modified ${modifiedCount} files.`);
