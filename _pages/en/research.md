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
     This paper examines how exposure to geolocated crime-related news affects individual voting behavior in Italian elections. Using a panel of non-relocating voters observed across multiple election rounds, we exploit within-individual variation in exposure to nearby crime news during the pre-election month, via individual and district-time fixed effects. Aggregate exposure yields weak, unstable effects Disaggregating by offender nationality reveals systematic patterns: immigrant-attributed crime news reduces support for parties with ambiguous immigration stances (e.g., Five Star Movement) and increases support for clear “law-and-order” parties, while Italian-attributed crime has negligible effects. Effects are stronger among high-skilled voters shifting from M5S and low-skilled voters abandoning Lega. In local elections, Italian crime punishes incumbents, while immigrant crime increases abstention. These asymmetric responses—absent in aggregate measures—indicate that crime salience operates through identity framing rather than general security concerns. The findings highlight how media attribution shapes electoral accountability.
    </div>
    <div id="keywords-crime" class="toggle-box">
       crime; elections; immigration; news media; individual voting behavior.
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
      occupational selection; self-control; corruption; moral frictions; public sector quality.
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
        <em>Parenthood, Age, and the Opportunity Cost of Voting: Evidence from Administrative Voter Records</em>
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
        &body=Dear%20Marco,%0D%0A%0D%0AI%20would%20like%20to%20request%20the%20draft%20of%20your%20paper%20%E2%80%9CParenthood%2C%20Age%2C%20and%20the%20Opportunity%20Cost%20of%20Voting%3A%20Evidence%20from%20Administrative%20Voter%20Records%E2%80%9D.%0D%0A%0D%0AThank%20you!%0D%0A"
  class="pill-link no-external">
        <i class="fa-regular fa-newspaper fa-2xs"></i>
        <span class="toggle-label" title="Draft under request">Paper</span>
      </a>
    </div>
    <div id="abstract-ageturnout" class="toggle-box">
     This paper studies how parenthood and parental age are associated with voter turnout using a comprehensive administrative panel covering the universe of registered voters in Bologna across four municipal and national elections between 2004 and 2013. By linking individual turnout records to demographic, fiscal, and residential information, we identify parents, track the age of their children, and follow the same individuals over time.
We estimate linear probability models with individual and election-year fixed effects, exploiting within-individual variation to account for permanent differences in civic engagement. On average, parenthood is not associated with lower turnout once individual fixed effects are included. However, substantial heterogeneity emerges over the parental life cycle. Parents of young children vote significantly less than comparable non-parents at younger ages: those with children aged 0--2 and 3--5 exhibit turnout penalties of approximately three to five percentage points. These gaps decline steadily---by about 0.2 percentage points per additional year of parental age---and disappear by around age forty. Parents of older children display no turnout deficit.
The participation gap is driven almost entirely by mothers, while fathers’ turnout remains unaffected. The results are robust to alternative specifications and to controls for residential mobility, neighborhood characteristics, and distance to polling stations. Taken together, the findings highlight the importance of life-cycle factors in shaping political participation and suggest that periods of intensive childcare are associated with temporarily lower electoral engagement. More broadly, the analysis points to a channel through which demographic trends, such as delayed fertility, may have implications for democratic representation.
    </div>
    <div id="keywords-ageturnout" class="toggle-box">
       voter turnout; parenthood; age; electoral participation; fixed effects.
    </div>
    <div id="jel-ageturnout" class="toggle-box">
       D72; J13; J22.
    </div>
  </div>

</div>

<!-- Thesis -->
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

  <!-- Thesis -->
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

  <!-- Thesis -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-bookmark fa-fw"></i>
      <span><em>The Effect of Erasmus Programs on Voting</em></span>
    </div>
  </div>

</div>

<!-- Theses Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-4')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs" id="chevron-content-4"></i>
      <span>theses</span>
    </h2>
  </a>
</div>

<!-- Content -->
<div id="content-4" class="toggle-section">

  <!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-book fa-fw"></i>
      <span>
          Ph.D. Thesis (2026),
          <em>"Essays in Political Economy and Crime Economics"</em>
      </span>
    </div>
    <div class="pill-container">
      <div class="pill-button toggle-pill" data-target="abstract-phd">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Abstract</span>
      </div>
      <div class="pill-button toggle-pill" data-target="chapters-phd">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Chapters</span>
      </div>
    </div>
      <!-- Boxes style="margin-top: -0.005rem;"-->
      <div id="abstract-phd" class="toggle-box">
          This dissertation investigates how institutional incentives, behavioral frictions, and demographic factors shape individual decision-making in the domains of public employment and political participation. It comprises three chapters that combine theoretical modeling with empirical analysis to shed light on the interplay between corruption, crime salience, and family formation in influencing economic and political outcomes.<br>
<br>
The first chapter develops a theoretical framework to study how corruption opportunities affect self-selection into the public sector. The model highlights a dual mechanism: corruption rents attract individuals with low intrinsic motivation, who are more prone to unethical behavior, while simultaneously deterring highly motivated candidates who anticipate self-control problems when faced with temptation. This selection pattern has important implications for the quality of the public workforce and the efficiency of state institutions.<br>
<br>
The second chapter examines how exposure to crime-related news shapes voting behavior. Leveraging a unique dataset that links geolocated survey responses to media coverage around five Italian elections—two national and three municipal—the study shows that crime salience has heterogeneous electoral consequences. At the national level, only crimes attributed to immigrants significantly shift voter preferences, reducing support for the populist Five Star Movement and increasing support for right-wing parties emphasizing law and order. At the municipal level, by contrast, crimes committed by Italians lead to punishment of incumbents, whereas immigrant-related crimes induce higher abstention, especially among left-leaning voters. These findings underscore the role of information shocks in driving electoral realignments and in mediating the political impact of immigration.<br>
<br>
The third chapter explores how childcare responsibilities interact with parental age to shape civic participation. Using rich administrative data from Bologna that match voter turnout records to household demographics and geospatial measures of proximity to schools, the analysis documents strong age-dependent effects of parenthood on political engagement. Parents of infants and preschoolers—particularly mothers—are significantly less likely to vote compared to childless adults, with turnout penalties concentrated in early adulthood and dissipating by the late thirties. These results highlight how time-intensive childcare duties and the timing of family formation condition life-cycle patterns of civic participation, with broader implications for political representation in aging societies.<br>
<br>
Taken together, the three chapters show how corruption incentives, crime perceptions, and family dynamics intersect with institutional and demographic contexts to shape individual behavior. The dissertation contributes to our understanding of the microfoundations of governance, electoral outcomes, and democratic participation, offering insights relevant for the design of public policy.
      </div>
      <div id="chapters-phd" class="toggle-box">
          <span>
              1. Corruption, temptation, and self-selection in the public sector<br>
              2. Crime Perception and Voting Behavior: Evidence from Individual Data<br>
              3. Parenthood, Age, and the Opportunity Cost of Voting: Evidence from Administrative Voter Records
          </span>
      </div>
  </div>

  <!-- Paper -->
  <div class="entry-block">
    <div class="icon-entry indented">
      <i class="fa-solid fa-book fa-fw"></i>
      <span>
          Master's Thesis (2018),
          <em>"Effect of Breast and Colorectal Cancer on Earnings: Evidence from Italy"</em>
      </span>
    </div>
    <div class="pill-container">
      <div class="pill-button toggle-pill" data-target="abstract-master">
        <i class="fa-solid fa-chevron-right fa-2xs"></i>
        <span class="toggle-label">Abstract</span>
      </div>
    </div>
    <!-- Boxes -->
    <div id="abstract-master" class="toggle-box">
        Using the Work History Italian Panel (WHIP) we estimate the causal effects of breast and colorectal cancer on earnings, on unemployment, and on the possibility to work part-time in the following three years after the cancer diagnosis. Since cancer patients differ from the rest of the population at socio-economic levels, we perform a propensity score matching to balance our observations. We analyse the effect on earnings throughout an OLS regression and on part-time and unemployment using a logistic regression. We observe that colorectal and breast cancer patients have different effects on earnings. A diagnosis of colorectal cancer appears to be more disabling, leading to a total reduction in earnings up to 10,000 € after three years. On the contrary, the negative effects of breast cancer are more concentrated in the short term and from the second year onwards these women are able to resume a normal working activity. This diversity is also supported by the results we achieved on unemployment and on part-time work.
    </div>
  </div>

</div>
