# DAGs (Directed Acyclic Graphs) 

# Setup ----

#... Libraries ----

library(tidyverse)
library(ggdag)

# Adverse Events Associated with Benzodiazepine Usage ----

#... Variables and Cause / Effect ----

bzd_ae <- ggdag::dagify(
  hip_fract ~ falls + bzd, 
  bzd ~ age + sex, 
  age ~ sex, 
  falls ~ bzd + age, 
  frail ~ age + weak_bones, 
  hip_fract ~ weak_bones + falls, 
  worse_bal ~ age, 
  latent = "weak_bones", # Latent variable since we can't actually measure it
  exposure = "bzd", 
  outcome = "hip_fract",
  labels = c(
    "hip_fract" = "Hip\nFracture", 
    "falls" = "Falls",
    "bzd" = "Benzodiazepine",
    "age" = "Age", 
    "sex" = "Sex",
    "falls" = "Falls",
    "frail" = "Frailty",
    "weak_bones" = "Weak\n Bones",
    "worse_bal" = "Worse\n Balance"
  )
)

#... BZD AE DAG ----

ggdag::ggdag(bzd_ae,
             text = FALSE,
             use_labels = "label") + 
  ggdag::theme_dag()

#... Adjustment required ----

ggdag::ggdag_adjustment_set(
  bzd_ae,
  text = FALSE,
  use_labels = "label"
  ) + 
  ggdag::theme_dag()
