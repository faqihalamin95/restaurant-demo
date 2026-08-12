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

    // Remove existing toc-anchors just in case we run this twice
    content = content.replace(/<div class="toc-anchor"[^>]*>[\s\S]*?<\/div>\n/g, '');

    // 1. Match <h2 class="diagnostics-title">Title</h2>
    content = content.replace(/<h2 class="diagnostics-title">([^<]+)<\/h2>/g, (match, title) => {
        return `<div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">\n\n## ${title}\n\n</div>\n${match}`;
    });

    // 2. Match <h2 class="strategic-title">Title</h2>
    content = content.replace(/<h2 class="strategic-title">([^<]+)<\/h2>/g, (match, title) => {
        return `<div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">\n\n## ${title}\n\n</div>\n${match}`;
    });

    // 3. Match <SectionHeader ... title="Title" ... /> or <SectionHeader ... title="Title" >
    content = content.replace(/<SectionHeader[^>]*title="([^"]+)"[^>]*>/g, (match, title) => {
        return `<div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">\n\n## ${title}\n\n</div>\n${match}`;
    });
    
    // 4. Match <SectionHeader title="Title" \n subtitle="Subtitle" />
    // (Handled by the above regex since [^>]* matches newlines in JavaScript if we don't use it, wait, [^>]* does match newlines!)

    if (content !== original) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated ${filePath}`);
        modifiedCount++;
    }
});

console.log(`Done! Modified ${modifiedCount} files.`);

// Add hero-card-title to the script and re-run
let content2 = fs.readFileSync('fix_toc.cjs', 'utf8');
content2 = content2.replace('// 3. Match <SectionHeader', `// Hero Card\n    content = content.replace(/<h2 class="hero-card-title"[^>]*>([\\s\\S]*?)<\\/h2>/g, (match, title) => {\n        let cleanTitle = title.replace(/<[^>]+>/g, '').trim();\n        if (!cleanTitle) return match;\n        return \`<div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">\\n\\n## \${cleanTitle}\\n\\n</div>\\n\${match}\`;\n    });\n\n    // 3. Match <SectionHeader`);
fs.writeFileSync('fix_toc_v2.cjs', content2, 'utf8');
