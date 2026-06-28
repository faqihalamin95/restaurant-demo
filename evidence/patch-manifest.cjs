const fs = require('fs');
const path = require('path');

const targetFile = path.join(__dirname, 'node_modules/@evidence-dev/evidence/template/src/pages/api/pagesManifest.json/+page.server.js');
// Wait, is it +page.server.js or +server.js? Let's check node_modules.
// The file is src/pages/api/pagesManifest.json/+server.js.
const file1 = path.join(__dirname, 'node_modules/@evidence-dev/evidence/template/src/pages/api/pagesManifest.json/+server.js');

function patch(filePath) {
	if (!fs.existsSync(filePath)) {
		console.log('Target file not found:', filePath);
		return;
	}

	let content = fs.readFileSync(filePath, 'utf8');

	if (content.includes('pruneTree')) {
		console.log('Manifest builder already patched.');
		return;
	}

	// Inject pruneTree function
	const pruneTreeFunc = `
function pruneTree(node) {
	for (const [key, child] of Object.entries(node.children)) {
		pruneTree(child);
		if (child.frontMatter?.sidebar_link === false) {
			delete node.children[key];
		}
	}
}
`;

	// Insert it before export function _buildPageManifest
	content = content.replace('export function _buildPageManifest', pruneTreeFunc + '\nexport function _buildPageManifest');

	// Insert pruneTree(fileTree); before return fileTree; inside _buildPageManifest
	content = content.replace('return fileTree;', 'pruneTree(fileTree);\n\treturn fileTree;');

	fs.writeFileSync(filePath, content, 'utf8');
	console.log('Successfully patched pagesManifest.json/+server.js');
}

patch(file1);
