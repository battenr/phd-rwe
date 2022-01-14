# DAGs (Directed Acyclic Graphs) 

# Setup ----

#... Libraries ----

library(tidyverse)
library(ggdag)

# Variables Associated with BZD / Dementia ----

# From Guo (2021): education level, marital status, depression, stroke, 
#                  diabetes, hypertension, coronary heart disease, 
#                  physical activity, smoking, medicines affecting cognition (especially insomnia)


# Anxiety and depression (since these can impact insomnia)






#... Variables and Cause / Effect ----

bzd_ae <- ggdag::dagify(
  hip_fract ~ falls + bzd, 
  bzd ~ age + sex, 
  age ~ sex, 
  falls ~ bzd + age +  worse_bal, 
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

# DAG ----

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
