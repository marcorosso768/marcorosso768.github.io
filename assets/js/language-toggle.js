// Function to set language, store it, and redirect based on the URL mapping
function setLanguage(language) {
  const defaultLanguage = 'en';
  const currentPath = window.location.pathname;
  const isHomepage = currentPath === '/';

  // Fetch the URL mapping from the YAML file
  const urlMap = {{ site.data.url_map | jsonify }};
  const currentLanguage = isHomepage ? defaultLanguage : (currentPath.split('/')[1] || defaultLanguage);

  // Determine the new path based on the selected language
  let newPath;

  // If switching to the default language (English)
  if (language === defaultLanguage) {
    // Use the English URL without a prefix
    newPath = urlMap[defaultLanguage][currentPath] || '/';
  } else {
    // Look up the current page in the selected language
    newPath = urlMap[language][currentPath] || `/${language}/`;
  }

  // Store the user's language choice for future visits
  localStorage.setItem('userLanguage', language);
  sessionStorage.removeItem('languageRedirected'); // Clear flag to allow further changes

  // Redirect to the mapped URL
  window.location.href = newPath;
}

// Apply language preference on homepage load, only if no redirect was done in the session
document.addEventListener("DOMContentLoaded", function() {
  const userLanguage = localStorage.getItem('userLanguage') || 'en';
  const isHomepage = window.location.pathname === '/';
  const hasRedirected = sessionStorage.getItem('languageRedirected');

  // Only redirect on the homepage if no redirect has been done in this session
  if (isHomepage && userLanguage !== 'en' && !hasRedirected) {
    const newURL = `/${userLanguage}/`;
    sessionStorage.setItem('languageRedirected', 'true'); // Prevent further redirects in this session
    window.location.href = newURL;
  }
});
