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
  if (language === defaultLanguage) {
    // For default language, use the English URL without a prefix
    newPath = urlMap[defaultLanguage][currentPath] || '/';
  } else {
    // For other languages, look up the corresponding URL
    newPath = urlMap[language][currentPath] || `/${language}/`;
  }

  // Store the user's choice for future visits
  localStorage.setItem('userLanguage', language);
  sessionStorage.removeItem('languageRedirected'); // Clear flag to allow further changes

  // Redirect to the mapped URL
  window.location.href = newPath;
}
