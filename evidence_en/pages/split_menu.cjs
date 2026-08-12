const fs = require('fs');
const content = fs.readFileSync('pages/05-menu-performance.md', 'utf8');
const lines = content.split('\n');

const endHeader = 1844;
const headerLines = lines.slice(0, endHeader);
// Remove the page title if it exists at the top to prevent duplicate titles in Evidence
// Usually the title is the first H1 "# Performa Menu"
let headerText = headerLines.join('\n');

// Find sections
const getLines = (startStr, endStr) => {
    let startIdx = lines.findIndex(l => l.includes(startStr));
    let endIdx = endStr ? lines.findIndex((l, i) => i > startIdx && l.includes(endStr)) : lines.length;
    if (startIdx === -1) return '';
    return lines.slice(startIdx, endIdx).join('\n');
};

const periodStrip = getLines('<!-- ════ PERIOD STRIP ════ -->', '<!-- ════ STATUS UTAMA ════ -->');
const statusUtama = getLines('<!-- ════ STATUS UTAMA ════ -->', '<!-- ════ PORTFOLIO SNAPSHOT ════ -->');
const portfolioSnapshot = getLines('<!-- ════ PORTFOLIO SNAPSHOT ════ -->', '<!-- ════ PRIORITY MENU CARDS ════ -->');
const priorityCards = getLines('<!-- ════ PRIORITY MENU CARDS ════ -->', '<!-- ════ PORTFOLIO MAP ════ -->');
const portfolioMap = getLines('<!-- ════ PORTFOLIO MAP ════ -->', '<!-- ════ MOVERS & DECLINING ════ -->');
const movers = getLines('<!-- ════ MOVERS & DECLINING ════ -->', '<!-- ════ ACTION QUEUE ════ -->');
const actionQueue = getLines('<!-- ════ ACTION QUEUE ════ -->', null);

fs.mkdirSync('pages/05-menu-performance', { recursive: true });

fs.writeFileSync('pages/05-menu-performance/index.md', headerText + '\n\n<MenuTabs activeTab="ringkasan" />\n\n' + periodStrip + '\n' + statusUtama + '\n' + portfolioSnapshot);
fs.writeFileSync('pages/05-menu-performance/prioritas.md', headerText + '\n\n<MenuTabs activeTab="prioritas" />\n\n' + priorityCards);
fs.writeFileSync('pages/05-menu-performance/matriks.md', headerText + '\n\n<MenuTabs activeTab="matriks" />\n\n' + portfolioMap);
fs.writeFileSync('pages/05-menu-performance/pergerakan.md', headerText + '\n\n<MenuTabs activeTab="pergerakan" />\n\n' + movers);
fs.writeFileSync('pages/05-menu-performance/aksi.md', headerText + '\n\n<MenuTabs activeTab="aksi" />\n\n' + actionQueue);

// Rename original
fs.renameSync('pages/05-menu-performance.md', 'pages/05-menu-performance.md.bak');
console.log('Split complete');
