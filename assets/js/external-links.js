document.addEventListener("DOMContentLoaded", () => {
  const siteOrigin = window.location.origin;

  document.querySelectorAll("a[href]:not(.no-external)").forEach(link => {
    const href = link.getAttribute("href");

    if (!href || href.startsWith("#") || href.startsWith("/#") || href.startsWith("javascript:")) return;

    const isMailto = href.startsWith("mailto:");
    const isTel = href.startsWith("tel:");
    const isAbsolute = href.startsWith("http");

    let isExternal = false;

    if (isAbsolute) {
      try {
        const linkOrigin = new URL(href).origin;
        isExternal = linkOrigin !== siteOrigin;
      } catch (e) {
        // ignore invalid URLs
        console.warn("Invalid URL in href:", href);
      }
    } else if (isMailto || isTel) {
      isExternal = true;
    }

    if (isExternal) {
      link.classList.add("external");
      link.setAttribute("target", "_blank");
      link.setAttribute("rel", "noopener noreferrer");
    }
  });
});
