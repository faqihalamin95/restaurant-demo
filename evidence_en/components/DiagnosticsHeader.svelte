<script>
  export let eyebrow = "";
  export let title = "";
  export let description = "";
  export let marginTop = "0px";
  export let marginBottom = "0px";
</script>

<div class="diagnostics-stack" style="margin-top: {marginTop}; margin-bottom: {marginBottom};">
  <div class="diagnostics-header">
    {#if eyebrow}
      <div class="diagnostics-eyebrow">{@html eyebrow}</div>
    {/if}
    <h3 class="diagnostics-title">{@html title}</h3>
    {#if description}
      <p class="diagnostics-copy">{@html description}</p>
    {/if}
  </div>
</div>
