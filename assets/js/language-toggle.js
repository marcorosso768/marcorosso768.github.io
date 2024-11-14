document.addEventListener("DOMContentLoaded", function () {
  const urlMap = {{ site.data.url_map | jsonify }};
  const defaultLanguage = 'en';
  const currentPageId = document.body.getAttribute('data-page-id');
  const userLanguage = localStorage.getItem('userLanguage') || defaultLanguage;

  // Language Toggle Function
  function setLanguage(language) {
    if (!urlMap[language] || !currentPageId) return;

    const newPath = urlMap[language][currentPageId] || urlMap[defaultLanguage][currentPageId];
    localStorage.setItem('userLanguage', language);

    // Redirect only if the new path is different from the current one
    if (newPath && newPath !== window.location.pathname) {
      window.location.href = newPath;
    }
  }

  // Check User Language Preference and Redirect on Homepage
  const isHomepage = (currentPageId === 'about');
  if (isHomepage && userLanguage !== defaultLanguage) {
    const newURL = urlMap[userLanguage]['about'];
    if (newURL && newURL !== window.location.pathname) {
      window.location.href = newURL;
    }
  }

  // Expose setLanguage for the toggle dropdown
  window.setLanguage = setLanguage;
});
