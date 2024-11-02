// Function to generate the URL based on the selected language
function languageURL(language) {
  const currentURL = window.location.pathname;
  const defaultLanguage = 'en'; // Set the default language here

  // Remove any leading language prefix from the current URL
  const pathWithoutLang = currentURL.replace(/^\/(en|it|es)(\/|$)/, '/');

  // If the selected language is the default, return the base URL + path
  if (language === defaultLanguage) {
    return `{{ site.baseurl }}${pathWithoutLang}`;
  } else {
    // For other languages, add the language prefix before the path
    return `{{ site.baseurl }}/${language}${pathWithoutLang}`;
  }
}
