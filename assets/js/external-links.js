document.addEventListener("DOMContentLoaded", () => {
  const siteBase = "https://marcorosso.com"; // Your base URL

  document.querySelectorAll("a[href]:not(.no-external)").forEach(link => {
    const href = link.getAttribute("href");

    const isMailto = href.startsWith("mailto:");
    const isTel = href.startsWith("tel:");
    const isHttp = href.startsWith("http");

    const isExternal =
      (isHttp && !href.startsWith(siteBase)) || isMailto || isTel;

    if (isExternal) {
      link.classList.add("external");
      link.setAttribute("target", "_blank");
      link.setAttribute("rel", "noopener noreferrer");
    }
  });
});
