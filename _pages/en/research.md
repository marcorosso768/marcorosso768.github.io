---
page_id: research
layout: page
permalink: /research/
title: research
description: <i>My research agenda develops clean, testable theoretical frameworks—centered on incentives, information frictions, and selection—to clarify mechanisms before tracing their empirical implications. Empirically, I work with reproducible, end-to-end pipelines that often combine web scraping and NLP with geocoding and panel construction. My workflow typically relies on Python (e.g., pandas, BeautifulSoup, spaCy, GeoPandas), Stata (e.g., reghdfe/hdfe, frames, rdrobust, event-study routines, esttab), and spatial tools such as QGIS (and, when appropriate, R). The items collected below provide abstracts and links to papers and slides, together with keywords and JEL codes.</i>
subtitle: >
    <div class="lang-links">
        <a href="/it/ricerca/" hreflang="it">ricerca</a>
        <span class="separator">|</span>
        <a href="/es/investigación/" hreflang="es">investigación</a>
    </div>
nav: true
nav_order: 1
---

<!-- Publications Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-0')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs rotated" id="chevron-content-0"></i>
      <span>publications</span>
    </h2>
  </a>
</div>

<!-- Content -->
<div id="content-0" class="toggle-section expanded">

  <!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-newspaper fa-fw"></i>
      <span>
        Farina E., Rosso M., Dansero L., et al. (2023). 
        <a href="https://doi.org/10.1136/jech-2022-220088" target="_blank" rel="noopener noreferrer">
          Short-term effect of colorectal cancer on income.
        </a> 
        <i>Journal of Epidemiology & Community Health</i>, 77:196–201.
      </span>
    </div>
    <div class="pill-container">
      <div class="pill-button toggle-pill" data-target="abstract-crc">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Abstract</span>
      </div>
    </div>
    <div id="abstract-crc" class="toggle-box">
      <b>Introduction</b> The ability to return to work after a cancer diagnosis is a key aspect of cancer survivorship and quality of life. Studies have reported a significant risk of income loss for cancer survivors; however, there is limited evidence of the Italian context. <br> <b>Methods</b> The Work Histories Italian Panel (WHIP)-Salute database was used to select a cohort of incident cases of colorectal cancer (CRC) among workers in the private sector, based on hospital discharges. A propensity score matching was used to find a balanced control group for several confounders. Ordinary least square and logistic regressions were used to estimate the effect of a CRC diagnosis on annual income and the probability of switching from a full-time contract to a part-time one considering 3 years after the diagnosis. <br> <b>Results</b> Overall, we identified 925 CRC incident cases from 2006 until 2012. Our results confirm a statistically significant reduction in survivors’ income compared with controls. This reduction was greater in the first year and then tend to decrease, with an average income loss over 3 years of about €12 000. Stratified analyses by sex and position confirmed the overall trend while indicating a strong effect modification. Regarding the switching from full-time to part-time employment, the results were never significant. <br> <b>Conclusion</b> Income loss does not seem to be related to an increase in part-time contracts, but rather to survivors’ reduced work capacity following the invasive treatments. Further research is needed to investigate the complex dynamics behind this association.
    </div>
  </div>

</div>

<!-- JMP Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-1')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs rotated" id="chevron-content-1"></i>
      <span>job market paper</span>
    </h2>
  </a>
</div>

<!-- Content -->
<div id="content-1" class="toggle-section expanded">

<!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-file-lines fa-fw"></i>
      <span>
        <em>Crime Perception and Voting Behavior: Evidence from Individual Data</em><br>
          joint with
          <a href="https://sites.google.com/site/giovanniprarolo/" target="_blank" rel="noopener noreferrer"> Giovanni Prarolo</a>
      </span>
    </div>
    <div class="pill-container">
      <div class="pill-button toggle-pill" data-target="abstract-crime">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Abstract</span>
      </div>
      <div class="pill-button toggle-pill" data-target="keywords-crime">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Keywords</span>
      </div>
      <div class="pill-button toggle-pill" data-target="jel-crime">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">JEL</span>
      </div>
      <a href="/assets/pdf/papers/Marco_Rosso_Crime_Perception_and_Voting_Behavior.pdf" class="pill-link no-external">
        <i class="fa-regular fa-newspaper fa-2xs"></i>
        <span class="toggle-label" title="Crime Perception and Voting Behavior: Evidence from Individual Data">Paper</span>
      </a>
      <a href="/assets/pdf/slides/[Marco Rosso] Crime Perception and Voting Behaviour. Evidence from Individual Data (slides).pdf" class="pill-link no-external">
        <i class="fa-solid fa-download fa-2xs"></i>
        <span class="toggle-label" title="last version: BoMoPaV Economics Meeting 2025">Slides</span>
      </a>
      <a href="/assets/pdf/slides/[Marco Rosso] Crime Perception and Voting Behaviour. Evidence from Individual Data (slides short).pdf" class="pill-link no-external">
        <i class="fa-solid fa-download fa-2xs"></i>
        <span class="toggle-label" title="last version: 66th Annual Conference - Italian Economic Association">Slides (short)</span>
      </a>
    </div>
    <div id="abstract-crime" class="toggle-box">
     This study investigates how exposure to local crime-related news affects individual voting behavior, using geolocated newspaper coverage as a proxy for crime salience. Leveraging a retrospective panel survey of approximately 5,000 voters observed across multiple election rounds, we exploit within-individual variation in exposure to crime news occurring near voters’ residences in the pre-election
period. Aggregate exposure measures yield weak and unstable effects on voting behavior. Disaggregating by offender nationality reveals systematic heterogeneity: in national elections, immigrant-related crime news reduces support for populist right-wing parties with ambiguous immigration stances and increases support for traditional right-wing “law and order” parties, while Italian-perpetrated
crime has no effect. In administrative elections, Italian crime news punishes incumbents, whereas immigrant-related news increases abstention. These findings demonstrate that electoral responses to crime salience—previously obscured in aggregate measures—depend critically on media framing of offender identity.
    </div>
    <div id="keywords-crime" class="toggle-box">
       crime; elections; media; voting behavior; immigration.
    </div>
    <div id="jel-crime" class="toggle-box">
       D72; K42; J15; D83; L82.
    </div>
  </div>

</div>

<!-- Working Papers Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-2')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs rotated" id="chevron-content-2"></i>
      <span>working papers</span>
    </h2>
  </a>
</div>

<!-- Content -->
<div id="content-2" class="toggle-section expanded">

<!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-file-lines fa-fw" title="Working paper"></i>
      <span>
        <em>The Tipping Point of Temptation: Selection, Integrity, and Public Service Quality</em>
      </span>
    </div>
    <div class="pill-container">
      <div class="pill-button toggle-pill" data-target="abstract-corruption">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Abstract</span>
      </div>
      <div class="pill-button toggle-pill" data-target="keywords-corruption">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Keywords</span>
      </div>
      <div class="pill-button toggle-pill" data-target="jel-corruption">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">JEL</span>
      </div>
      <a 
  href="mailto:marco.rosso4@unibo.it
        ?subject=Request%20for%20draft%20-%20The%20Tipping%20Point%20of%20Temptation:%20Selection,%20Integrity,%20and%20Public%20Service%20Quality
        &body=Dear%20Marco,%0D%0A%0D%0AI%20would%20like%20to%20request%20the%20draft%20of%20your%20paper%20%E2%80%9CThe%20Tipping%20Point%20of%20Temptation:%20Selection,%20Integrity,%20and%20Public%20Service%20Quality%E2%80%9D.%0D%0A%0D%0AThank%20you!%0D%0A"
  class="pill-link no-external">
        <i class="fa-regular fa-newspaper fa-2xs"></i>
        <span class="toggle-label" title="Draft under request">Paper</span>
      </a>
    </div>
    <div id="abstract-corruption" class="toggle-box">
      This paper establishes a behavioral theory of occupational selection that resolves the long-standing empirical ambiguity regarding the quality of the public sector workforce in environments characterized by corruption and moral friction. The framework incorporates self-control costs and temptation into a standard model of occupational choice, consistent with the utility framework of Gul and Pesendorfer (2001). We show that intrinsically motivated (honest) agents face a disproportionately higher psychological cost when resisting temptation, leading to a dual effect on selection: low-motivation types are attracted, while high-motivation types are severely deterred. To resolve the ambiguity that arises from these opposing forces, the analysis establishes three general principles that govern institutional selection, supported by analytical derivations and numerical robustness checks. First, we identify a critical institutional tipping point, &lambda;<sup>*</sup>, which dictates the selection regime: below it, corruption leads to quality deterioration (<i>"more but worse"</i>); above it, it acts as a selective filter, improving quality (<i>"less but better"</i>). Second, we show that the selection outcome is fundamentally conditional on the societal correlation between ability and honesty. Third, the model offers a novel rationale for high public wages, demonstrating that large salaries mask or attenuate the selective power of corruption. Overall, our findings clarify the mechanisms governing workforce composition in morally frictional environments, contributing to the literature on occupational selection, public service motivation, and institutional design.
    </div>
    <div id="keywords-corruption" class="toggle-box">
      occupational selection, self-control, corruption, moral frictions, public sector quality.
    </div>
    <div id="jel-corruption" class="toggle-box">
       D73; J45; D90; H83; K42.
    </div>
  </div>

  <!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-file-lines fa-fw"></i>
      <span>
        <em>Childcare and Civic Participation: Parental Age, Child Stage, and Voter Turnout</em><br>
        joint with 
        <a href="https://sites.google.com/site/giorgiobellettiniwebpage" target="_blank" rel="noopener noreferrer">Giorgio Bellettini</a> 
        and <a href="https://www.unibo.it/sitoweb/carlotta.berticeroni" target="_blank" rel="noopener noreferrer">Carlotta Berti Ceroni</a>
      </span>
    </div>
    <div class="pill-container">
      <div class="pill-button toggle-pill" data-target="abstract-ageturnout">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Abstract</span>
      </div>
      <div class="pill-button toggle-pill" data-target="keywords-ageturnout">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Keywords</span>
      </div>
      <div class="pill-button toggle-pill" data-target="jel-ageturnout">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">JEL</span>
      </div>
      <a 
  href="mailto:marco.rosso4@unibo.it
        ?subject=Request%20for%20draft%20-%20Childcare%20and%20Civic%20Participation%3A%20Parental%20Age%2C%20Child%20Stage%2C%20and%20Voter%20Turnout
        &body=Dear%20Marco,%0D%0A%0D%0AI%20would%20like%20to%20request%20the%20draft%20of%20your%20paper%20%E2%80%9CChildcare%20and%20Civic%20Participation%3A%20Parental%20Age%2C%20Child%20Stage%2C%20and%20Voter%20Turnout%E2%80%9D.%0D%0A%0D%0AThank%20you!%0D%0A"
  class="pill-link no-external">
        <i class="fa-regular fa-newspaper fa-2xs"></i>
        <span class="toggle-label" title="Draft under request">Paper</span>
      </a>
    </div>
    <div id="abstract-ageturnout" class="toggle-box">
     This paper examines how parenthood and parental age influence voter turnout using a comprehensive administrative panel that covers the universe of registered voters in Bologna across four municipal and national elections between 2004 and 2013. We link individual turnout records to detailed demographic, fiscal, and geospatial information, including the location and catchment areas of public childcare facilities and the distance to polling stations. This unique linkage allows us to identify parents, measure the age of their youngest child, and control for a rich set of individual and spatial characteristics. Linear probability models with individual and year fixed effects show no average turnout difference between parents and non-parents once permanent heterogeneity is absorbed. However, sizable turnout penalties emerge when children are very young: parents of infants (0–2 years) and preschoolers (3–5 years) vote three to five percentage points less than comparable non-parents. These penalties diminish by roughly 0.2 percentage points per additional year of parental age and disappear around age forty; parents of older children show no gap. The negative effect is concentrated among mothers, while fathers’ turnout remains unaffected. Robustness checks including neighborhood fixed effects, additional socioeconomic controls, and measures of residential proximity to childcare facilities confirm these results and show that access to schools plays no role in shaping turnout. Taken together, the findings suggest that intensive childcare demands, rather than the physical availability of childcare infrastructure, constrain political participation. They underscore the importance of life-cycle factors in models of voter behavior and highlight how delayed fertility and declining birth rates can skew democratic representation by reducing the political voice of younger families.
    </div>
    <div id="keywords-ageturnout" class="toggle-box">
       voter turnout, childcare, age, electoral participation, fixed effects.
    </div>
    <div id="jel-ageturnout" class="toggle-box">
       D72; J13; J22; H75.
    </div>
  </div>

</div>

<!-- Work in Progress Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-3')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs rotated" id="chevron-content-3"></i>
      <span>work in progress</span>
    </h2>
  </a>
</div>

<!-- Content -->
<div id="content-3" class="toggle-section expanded">

  <!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-bookmark fa-fw"></i>
      <span>
          <em>Bridging the Participation Gap? Public Goods as a Determinant of Electoral Engagement</em><br>
        joint with 
        <a href="https://sites.google.com/site/giorgiobellettiniwebpage" target="_blank" rel="noopener noreferrer">Giorgio Bellettini</a>, 
        <a href="https://www.unibo.it/sitoweb/carlotta.berticeroni" target="_blank" rel="noopener noreferrer">Carlotta Berti Ceroni</a>, 
        <a href="https://sites.google.com/view/mgeiras/inicio" target="_blank" rel="noopener noreferrer">Martín Gonzalez-Eiras</a>, 
        and <a href="https://sites.google.com/site/giovanniprarolo/" target="_blank" rel="noopener noreferrer">Giovanni Prarolo</a>
      </span>
    </div>
  </div>

  <!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-bookmark fa-fw"></i>
      <span><em>The Effect of Erasmus Programs on Voting</em></span>
    </div>
  </div>

</div>
