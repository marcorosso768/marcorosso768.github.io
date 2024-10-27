let determineThemeFavicon = () => {
   if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      themeSetting = "dark";
    } else {
      themeSetting = "light";
    }
  return themeSetting;
};
