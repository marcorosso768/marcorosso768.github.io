# marcorosso.com

<p align="center">
  <a href="https://marcorosso.com"><img src=".github/readme-preview.png" alt="marcorosso.com in light and dark theme" width="800"></a>
</p>

Source of [marcorosso.com](https://marcorosso.com), the academic website of Marco Rosso, in English, Italian and Spanish.

Built with [Jekyll](https://jekyllrb.com/) on a heavily modified [al-folio](https://github.com/alshedivat/al-folio) /
[multi-language-al-folio](https://github.com/george-gca/multi-language-al-folio) theme, with
[jekyll-polyglot](https://github.com/untra/polyglot) for the three languages.

## Where the content lives

Most pages are generated from data files: the structure and the data that do not change with the language are in
`_data/<page>.yml`, the translated texts in `_data/<lang>/<page>_text.yml` (the different name is deliberate:
polyglot would merge a file with the same name). Each data file starts with a comment that explains its fields.

| Page                         | Data                                                          |
| ---------------------------- | ------------------------------------------------------------- |
| research                     | `_data/research.yml`, `_data/<lang>/research_text.yml`        |
| talks                        | `_data/talks.yml`, `_data/<lang>/talks_text.yml`              |
| teaching, materials          | `_data/teaching.yml`, `_data/<lang>/teaching_text.yml`        |
| course pages (materials)     | `_data/courses.yml`, `_data/<lang>/courses_text.yml`          |
| supervision                  | `_data/supervision.yml`, `_data/<lang>/supervision_text.yml`  |
| references                   | `_data/references.yml`, `_data/<lang>/references_text.yml`    |
| CV                           | `_data/<lang>/cv.yml`                                         |
| people (coauthors, referees) | `_data/people.yml`                                            |
| news                         | `_news/<lang>/*.md`                                           |
| blog (posts in English only) | `_posts/*.md`, `_pages/<lang>/blog.md`, `_data/blog_tags.yml` |
| about, contacts              | `_pages/<lang>/about.md`, `_pages/<lang>/contacts.md`         |
| URLs across languages        | `_data/url_map.yml` (language switch and `hreflang` tags)     |

## Build and checks

- **Deploy**: every push to `master` builds the site with GitHub Actions and publishes it on the `gh-pages` branch.
- **Preview**: a push to a `refactor/**` branch builds the site and publishes it on the `preview` branch (not served),
  with a W3C validator report and a heading check in `_report/`.
- **Links**: after every deploy and every Monday, a link check on the published site; the report goes to an issue.
- **Formatting**: Prettier (`npx prettier . --check`), also run by a GitHub Action.
- **JavaScript**: files in `assets/js` must stay readable by the minifier (uglify-es): `node .husky/check-js.mjs`.
- **Performance**: [PageSpeed Insights](https://pagespeed.web.dev/analysis?url=https%3A%2F%2Fmarcorosso.com%2F&form_factor=mobile)
  runs a fresh test of the home page. Scores vary from run to run: on mobile they ranged from 96 to 100 in
  September 2026.

## License

The repository contains two different things, under different terms.

**Layout and code: MIT License.** Everything that makes the site work (layouts, includes, styles, scripts, plugins,
workflows, configuration) is released under the [MIT License](LICENSE), inherited from al-folio. You may reuse it,
including for your own website, provided you keep the copyright notices in [`LICENSE`](LICENSE) (al-folio's and Marco
Rosso's). A link back to [marcorosso.com](https://marcorosso.com) is not required, but it is appreciated.

**Content: all rights reserved.** The content of the site is **not** covered by the MIT License. It may not be
reused, republished or redistributed, in whole or in part, modified or not, without written permission from Marco
Rosso. Content means texts, CV, news, blog posts, research, talks, teaching and supervision data, people,
references, teaching materials, papers, images and videos, in particular:

- `_pages/`, `_news/`, `_posts/`;
- `_data/` (research, talks, teaching, courses, supervision, references, CV, people, venues and their translations
  in `_data/<lang>/`);
- `assets/img/`, `assets/pdf/`, `assets/teaching_material/`, `assets/video/`.

**If you use this repository as a starting point for your own site, you must remove all of this content and replace
it with your own.** A site that publishes Marco Rosso's pages, texts, data or files is not a permitted use of the
layout.

The film clip in `assets/video/blog/` is an excerpt from _Smetto quando voglio_ (Sydney Sibilia, 2014), used for
illustrative purposes: all rights belong to their owners, and it is covered by neither license above. Third-party
components (fonts, icons, libraries) keep their own licenses, for example the SIL Open Font License for Roboto
(`assets/fonts/roboto/LICENSE`).
