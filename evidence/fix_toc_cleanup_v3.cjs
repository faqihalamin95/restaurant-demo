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

    // The previous injected ## headers are still there! 
    // They are right before <h2 or <SectionHeader.
    // Use multi-line regex that accounts for spaces before ##
    
    content = content.replace(/^\s*##\s+[^\n]+\n+(?=<h2|<SectionHeader)/gm, '');

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Cleaned ${filePath}`);
        modifiedCount++;
    }
});

console.log(`Done cleanup v3! Modified ${modifiedCount} files.`);
