// Function to set language, store it, and redirect based on the URL mapping
function setLanguage(language) {
  const defaultLanguage = 'en';
  const currentPath = window.location.pathname;
  const isHomepage = currentPath === '/';
  // Parse the JSON data from the HTML script element
  const urlMap = JSON.parse(document.getElementById('urlMapData').textContent);

  // Determine the current language based on the URL prefix
  const currentLanguage = isHomepage ? defaultLanguage : (currentPath.split('/')[1] || defaultLanguage);

  // Determine the new path based on the selected language
  let newPath;
  if (language === defaultLanguage) {
    // Use the English URL without a prefix
    newPath = urlMap[defaultLanguage][currentPath] || '/';
  } else {
    // Look up the current page in the selected language
    newPath = urlMap[language][currentPath] || `/${language}/`;
  }

  // If no valid newPath is found, log an error and return
  if (!newPath) {
    console.error(`No mapped URL found for current path: ${currentPath} and language: ${language}`);
    return;
  }

  // Store the user's language choice for future visits
  localStorage.setItem('userLanguage', language);
  sessionStorage.removeItem('languageRedirected');

  // Redirect to the mapped URL
  window.location.href = newPath;
}

// Apply language preference on homepage load
document.addEventListener("DOMContentLoaded", function () {
  const userLanguage = localStorage.getItem('userLanguage') || 'en';
  const isHomepage = window.location.pathname === '/';
  const hasRedirected = sessionStorage.getItem('languageRedirected');

  // Only redirect on the homepage if no redirect has been done in this session
  if (isHomepage && userLanguage !== 'en' && !hasRedirected) {
    const newURL = `/${userLanguage}/`;
    sessionStorage.setItem('languageRedirected', 'true');
    window.location.href = newURL;
  }
});
