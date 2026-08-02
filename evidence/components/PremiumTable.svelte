<script>
  export let data = [];
  export let columns = [];
  export let pageSize = 10;
  export let rowColor = null;
  
  let currentPage = 1;
  
  // Convert QueryStore or array-like object to a real JavaScript array safely
  $: dataArray = data ? Array.from(data) : [];
  $: totalPages = Math.ceil((dataArray.length || 0) / pageSize) || 1;
  $: paginatedData = dataArray.slice((currentPage - 1) * pageSize, currentPage * pageSize);

  function prevPage() {
    if (currentPage > 1) currentPage--;
  }
  function nextPage() {
    if (currentPage < totalPages) currentPage++;
  }

  function formatValue(row, col) {
     let val = row[col.key];
     if (val === null || val === undefined) return '0';
     
     // Check if type is numeric and ensure val is a number
     const isNumericType = ['currency', 'currency_raw', 'pct', 'pct_ratio'].includes(col.type);
     if (isNumericType && typeof val === 'string') {
        const parsed = parseFloat(val);
        if (!isNaN(parsed)) val = parsed;
     }
     
     if (col.type === 'currency') {
        const num = typeof val === 'number' ? val : parseFloat(val);
        return 'Rp ' + (isNaN(num) ? '0' : num.toLocaleString('id-ID', {maximumFractionDigits: 0}));
     }
     if (col.type === 'currency_raw') {
        const num = typeof val === 'number' ? val : parseFloat(val);
        return isNaN(num) ? '0' : num.toLocaleString('id-ID');
     }
     if (col.type === 'pct') {
        const num = typeof val === 'number' ? val : parseFloat(val);
        if (isNaN(num)) return '0,0%';
        return (num > 0 && col.showPlus ? '+' : '') + num.toLocaleString('id-ID', {minimumFractionDigits: 1, maximumFractionDigits: 1}) + '%';
     }
     if (col.type === 'pct_ratio') {
        const num = typeof val === 'number' ? val : parseFloat(val);
        if (isNaN(num)) return '0.0%';
        return (num * 100).toFixed(1) + '%';
     }
     if (col.type === 'date_month') {
        if (val instanceof Date) {
           return val.toISOString().split('T')[0].substring(0, 7);
        }
        if (typeof val === 'string') {
           return val.substring(0, 7);
        }
        return val;
     }
     if (col.type === 'margin_growth') {
        const valNow = parseFloat(row[col.key]);
        const valPrev = parseFloat(row[col.prevKey]);
        if (isNaN(valNow) || isNaN(valPrev)) return '0,0%';
        const gap = valNow - valPrev;
        const icon = gap > 0 ? '▲' : gap < 0 ? '▼' : '';
        const color = gap > 0 ? '#16a34a' : gap < 0 ? '#dc2626' : 'inherit';
        
        let nowStr = valNow.toLocaleString('id-ID', {minimumFractionDigits: 1, maximumFractionDigits: 1}) + '%';
        let gapStr = Math.abs(gap).toLocaleString('id-ID', {minimumFractionDigits: 1, maximumFractionDigits: 1}) + '%';
        if (gap === 0) return nowStr;
        return `${nowStr} <span style="color: ${color}; font-size: 0.85em; font-weight: 700; margin-left: 6px;">${icon} ${gapStr}</span>`;
     }
     if (col.type === 'number_growth') {
        const valNow = parseFloat(row[col.key]);
        const valPrev = parseFloat(row[col.prevKey]);
        if (isNaN(valNow) || isNaN(valPrev)) return '0';
        const gap = valNow - valPrev;
        const pct = valPrev !== 0 ? (gap / valPrev) * 100 : 0;
        const icon = gap > 0 ? '▲' : gap < 0 ? '▼' : '';
        const color = gap > 0 ? '#16a34a' : gap < 0 ? '#dc2626' : 'inherit';
        
        let nowStr = valNow.toLocaleString('id-ID');
        let pctStr = Math.abs(pct).toLocaleString('id-ID', {minimumFractionDigits: 1, maximumFractionDigits: 1}) + '%';
        if (gap === 0) return nowStr;
        return `${nowStr} <span style="color: ${color}; font-size: 0.85em; font-weight: 700; margin-left: 6px;">${icon} ${pctStr}</span>`;
     }
     return val;
  }
  
  function getColor(row, col) {
     const val = row[col.key];
     if (col.colorRules) {
        const num = typeof val === 'number' ? val : parseFloat(val);
        if (isNaN(num)) return 'inherit';
        if (col.colorRules === 'growth') return num > 0 ? '#16a34a' : num < 0 ? '#dc2626' : 'inherit';
        if (col.colorRules === 'loss') return '#dc2626'; // static red
        if (col.colorRules === 'fluctuation') return num > 0.5 ? '#dc2626' : 'inherit';
        if (col.colorRules === 'expense') return num > 10 ? '#dc2626' : num > 0 ? '#ca8a04' : '#16a34a';
     }
     return 'inherit';
  }
</script>

<div class="table-scroll-container" style="border-radius: 12px; overflow: hidden; border: 1px solid var(--color-border-tertiary);">
  <table class="markdown" style="margin: 0; width: 100%;">
    <thead style="background: var(--color-background-secondary);">
      <tr>
        {#each columns as col}
          <th class="markdown" style="text-align: {col.align || 'left'}; font-size: 0.85rem; color: var(--color-text-tertiary); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 2px solid var(--color-border-tertiary);">{col.title}</th>
        {/each}
      </tr>
    </thead>
    <tbody>
      {#each paginatedData as row, i}
        {@const customBg = rowColor ? rowColor(row) : null}
        <tr style="background: {customBg || (i % 2 === 0 ? 'transparent' : 'rgba(0,0,0,0.02)')}; border-bottom: 1px solid var(--color-border-tertiary);">
          {#each columns as col}
            <td class="markdown" style="text-align: {col.align || 'left'}; font-weight: {col.bold ? '600' : 'normal'}; color: {getColor(row, col)}; padding: 12px 16px;">
              {@html formatValue(row, col)}
            </td>
          {/each}
        </tr>
      {/each}
    </tbody>
  </table>

  {#if totalPages > 1}
  <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 16px; background: var(--color-background-secondary); border-top: 1px solid var(--color-border-tertiary);">
    <button on:click={prevPage} disabled={currentPage === 1} style="padding: 6px 16px; border-radius: 6px; border: 1px solid var(--color-border-tertiary); background: {currentPage === 1 ? 'transparent' : '#0d9488'}; color: {currentPage === 1 ? 'var(--color-text-tertiary)' : 'white'}; cursor: {currentPage === 1 ? 'not-allowed' : 'pointer'}; font-size: 13px; font-weight: 600; transition: all 0.2s;">
      &#8592; Prev
    </button>
    <span style="font-size: 0.85rem; color: var(--color-text-secondary); font-weight: 600;">Halaman {currentPage} dari {totalPages}</span>
    <button on:click={nextPage} disabled={currentPage === totalPages} style="padding: 6px 16px; border-radius: 6px; border: 1px solid var(--color-border-tertiary); background: {currentPage === totalPages ? 'transparent' : '#0d9488'}; color: {currentPage === totalPages ? 'var(--color-text-tertiary)' : 'white'}; cursor: {currentPage === totalPages ? 'not-allowed' : 'pointer'}; font-size: 13px; font-weight: 600; transition: all 0.2s;">
      Next &#8594;
    </button>
  </div>
  {/if}
</div>

