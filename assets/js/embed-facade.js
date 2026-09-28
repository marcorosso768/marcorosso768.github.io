// Contenuti esterni caricati solo al clic (post LinkedIn/X/Instagram nelle news, mappa nei contatti).
// Markup: <div class="embed-facade" data-type="linkedin|x|instagram|map" data-src="..." data-height="...">
//           <button class="embed-facade__button"> ... <span class="embed-facade__label" data-show data-hide>
// Senza clic il browser non contatta il servizio esterno; un secondo clic nasconde e mostra di nuovo.
document.addEventListener("click", function (event) {
  const button = event.target.closest(".embed-facade__button");
  if (!button) return;
  const box = button.closest(".embed-facade");
  const label = button.querySelector(".embed-facade__label");
  let frame = box.querySelector(".embed-facade__content");

  if (frame) {
    const open = !frame.hidden;
    frame.hidden = open;
    label.textContent = open ? label.dataset.show : label.dataset.hide;
    button.setAttribute("aria-expanded", String(!open));
    return;
  }

  const type = box.dataset.type;
  const src = box.dataset.src;
  if (!src) return;

  frame = document.createElement("div");
  frame.className = "embed-facade__content";
  box.appendChild(frame);

  const loadScript = function (url) {
    const script = document.createElement("script");
    script.async = true;
    script.src = url;
    document.body.appendChild(script);
  };

  if (type === "x") {
    frame.innerHTML = '<blockquote class="twitter-tweet"><a href="' + src + '"></a></blockquote>';
    if (window.twttr && window.twttr.widgets) window.twttr.widgets.load(frame);
    else loadScript("https://platform.twitter.com/widgets.js");
  } else if (type === "instagram") {
    frame.innerHTML =
      '<blockquote class="instagram-media" data-instgrm-permalink="' +
      src +
      '" data-instgrm-version="14" style="min-width:326px; max-width:540px; width:100%;"></blockquote>';
    if (window.instgrm) window.instgrm.Embeds.process();
    else loadScript("https://www.instagram.com/embed.js");
  } else {
    const iframe = document.createElement("iframe");
    iframe.src = src;
    iframe.height = box.dataset.height;
    if (type === "map") {
      // larghezza dal CSS (.contact-map: 100%, al massimo 800px)
      iframe.title = label.dataset.title || "Map";
      iframe.setAttribute("loading", "lazy");
      iframe.setAttribute("referrerpolicy", "no-referrer-when-downgrade");
    } else {
      iframe.width = "504";
      iframe.title = "Embedded post";
      iframe.setAttribute("allowfullscreen", "");
    }
    iframe.setAttribute("frameborder", "0");
    frame.appendChild(iframe);
  }
  label.textContent = label.dataset.hide;
  button.setAttribute("aria-expanded", "true");
});
