<script>
  export let eyebrow = "";
  export let title = "";
  export let description = "";
</script>

<div class="section-card">
  <div class="section-head">
    {#if eyebrow}
      <div class="section-eyebrow">{@html eyebrow}</div>
    {/if}
    <h3 class="section-title">{@html title}</h3>
    {#if description}
      <p class="section-copy">{@html description}</p>
    {/if}
  </div>
  <slot />
</div>
