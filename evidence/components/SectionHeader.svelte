<script>
  export let eyebrow = "";
  export let title = "";
  export let description = "";
  export let marginTop = "24px";
  export let marginBottom = "14px";
</script>

<div style="margin-top: {marginTop}; margin-bottom: {marginBottom};">
  {#if eyebrow}
    <div class="section-eyebrow">{@html eyebrow}</div>
  {/if}
  <h3 class="section-title">{@html title}</h3>
  {#if description}
    <p class="section-copy">{@html description}</p>
  {/if}
</div>
