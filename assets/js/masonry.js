// Griglia Masonry (senza jQuery: Masonry e imagesLoaded funzionano anche da soli)
document.addEventListener("DOMContentLoaded", function () {
  const grid = document.querySelector(".grid");
  if (!grid) return;
  const msnry = new Masonry(grid, {
    gutter: 10,
    horizontalOrder: true,
    itemSelector: ".grid-item",
  });
  imagesLoaded(grid).on("progress", function () {
    msnry.layout();
  });
});
