document.addEventListener("DOMContentLoaded", () => {
  const currentOrigin = window.location.origin;

  document.querySelectorAll("a[href^='http']").forEach(link => {
    const isExternal = !link.href.startsWith(currentOrigin);
    const isNotMail = !link.href.startsWith("mailto:");
    const isNotTel = !link.href.startsWith("tel:");

    if (isExternal && isNotMail && isNotTel) {
      link.classList.add("external");
    }
  });
});
