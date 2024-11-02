function setLanguage(language) {
  // Adjust the URL for the selected language
  const defaultLanguage = 'en'; // Set your default language here
  const pathWithoutLang = window.location.pathname.replace(/^\/(en|it|es)(\/|$)/, '/');
  const newPath = language === defaultLanguage ? pathWithoutLang : `/${language}${pathWithoutLang}`;
  
  // Store the user's language choice and redirect
  localStorage.setItem('userLanguage', language);
  window.location.href = newPath;
}
