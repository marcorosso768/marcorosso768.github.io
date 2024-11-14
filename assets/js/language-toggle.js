document.addEventListener("DOMContentLoaded", function () {
  const urlMap = JSON.parse(document.getElementById('urlMapData').textContent);
  const defaultLanguage = 'en';
  const currentPageId = document.body.getAttribute('data-page-id');
  const userLanguage = localStorage.getItem('userLanguage') || defaultLanguage;

  function setLanguage(language) {
    if (!urlMap[language] || !currentPageId) return;
    const newPath = urlMap[language][currentPageId] || urlMap[defaultLanguage][currentPageId];
    localStorage.setItem('userLanguage', language);
    if (newPath && newPath !== window.location.pathname) {
      window.location.href = newPath;
    }
  }

  const isHomepage = (currentPageId === 'about');
  if (isHomepage && userLanguage !== defaultLanguage) {
    const newURL = urlMap[userLanguage]['about'];
    if (newURL && newURL !== window.location.pathname) {
      window.location.href = newURL;
    }
  }

  window.setLanguage = setLanguage;
});
