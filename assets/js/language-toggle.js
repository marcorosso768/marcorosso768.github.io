// Voci del menu delle lingue: <a href="/it/..." data-lang="it">. Il link porta alla stessa pagina
// nell'altra lingua (href calcolato in _includes/header.liquid); qui si salva solo la scelta.
document.addEventListener("click", function (event) {
  const item = event.target.closest(".dropdown-item[data-lang]");
  if (!item) return;
  try {
    localStorage.setItem("userLanguage", item.getAttribute("data-lang"));
    sessionStorage.removeItem("languageRedirected");
  } catch (e) {
    // memoria del browser non disponibile: il link funziona comunque
  }
});

// Apply language preference on homepage load
document.addEventListener("DOMContentLoaded", function () {
  const userLanguage = localStorage.getItem("userLanguage") || "en";
  const isHomepage = window.location.pathname === "/";
  const hasRedirected = sessionStorage.getItem("languageRedirected");

  // Only redirect on the homepage if no redirect has been done in this session
  if (isHomepage && userLanguage !== "en" && !hasRedirected) {
    const newURL = `/${userLanguage}/`;
    sessionStorage.setItem("languageRedirected", "true");
    window.location.href = newURL;
  }
});
