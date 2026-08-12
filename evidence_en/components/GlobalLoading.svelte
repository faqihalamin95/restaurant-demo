<script>
  export let title = "Processing Millions of Transaction Data Rows...";
  export let desc = "Analyzing restaurant performance & customer trends. Please wait a moment.";
</script>

<div class="global-loading-container">
  <div class="global-loading-spinner">
    <div class="spinner-ring"></div>
    <div class="spinner-ring delayed"></div>
  </div>
  <div class="global-loading-title">{title}</div>
  <div class="global-loading-desc">{desc}</div>
</div>

<style>
  .global-loading-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 55vh;
    padding: 48px 24px;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.6) 0%, rgba(255, 255, 255, 0) 100%);
    border-radius: 24px;
    text-align: center;
    animation: fadeIn 0.5s ease-out;
  }
  
  .global-loading-spinner {
    position: relative;
    width: 64px;
    height: 64px;
    margin-bottom: 32px;
  }
  
  .spinner-ring {
    position: absolute;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: 4px solid transparent;
    border-top-color: #0d9488;
    border-left-color: rgba(13, 148, 136, 0.2);
    animation: spin 1s cubic-bezier(0.5, 0, 0.5, 1) infinite;
  }
  
  .spinner-ring.delayed {
    border-top-color: #34d399;
    border-left-color: rgba(52, 211, 153, 0.2);
    animation-direction: reverse;
    animation-duration: 1.5s;
    width: 70%;
    height: 70%;
    top: 15%;
    left: 15%;
  }

  .global-loading-title {
    font-size: 1.25rem;
    font-weight: 800;
    color: var(--color-text-primary, #1e293b);
    margin-bottom: 12px;
    letter-spacing: -0.02em;
  }
  
  .global-loading-desc {
    font-size: 0.95rem;
    color: var(--color-text-secondary, #64748b);
    max-width: 420px;
    line-height: 1.6;
  }
  
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  :global([data-theme='dark']) .global-loading-container {
    background: linear-gradient(180deg, rgba(0, 0, 0, 0.2) 0%, rgba(0, 0, 0, 0) 100%);
  }
</style>
