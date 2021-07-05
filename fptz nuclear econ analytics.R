library(readr)
library(dynlm)
library(tidyverse)
library(stargazer)
library(AER)
library(estimatr)
library(vtable)

options(scipen = 8)

ds <- read_csv("our dataset - Sheet1.csv")
View(ds)
#get the column names
spec(ds)
#rename the column from O&M to OM
colnames(ds)[colnames(ds)=="O&M"] <- "OM"
colnames(ds)[colnames(ds)=="FuelCost"] <- "FC"
colnames(ds)[colnames(ds)=="# Reactors"] <- "Reactors"


#making linear models
d1 <- lm(LCOE~ CF + TCC2020 + FC + OM, data = ds)
d2 <- lm(LCOE~ TCC2020 + FC + OM, data = ds)

#summary stats
summary(d1)
summary(d2)

#taking into account HAC errors
out1 <- coeftest(d1,vcovHAC(d1), type = "HC1")

#nice table printout
stargazer(out1, d1, d2, d3, type = "text")
stargazer(out1, d1, d2, type = "html", out = "lcoe-basic.html")
stargazer(out1, d1, d2, d6, type = "html", out = "lcoe-basic2.html")

#scatter of age and cf
ggplot(data = ds)+
  geom_point(mapping = aes(x = AGE,
                           y = CF,
                           alpha= 0.7))+
  geom_text(aes(label = PLANT,
                x = AGE,
                y = CF), 
            size = 3,
            alpha = 0.7,
            check_overlap = TRUE)
            #nudge_y = 0.05,
            #nudge_x = 0.08)

#more linear models
d3 <- lm(LCOE~ CF + Reactors + TCC2020 + FC + OM, data = ds)
summary(d3)

#probably don't need this because it could cause some errors 
#moved math from being inside LCOE column to make lcoe only addition
ds2 <- ds %>%
  mutate(tcc = (TCC2020/RatedMWe) / (CF * 8760)) %>%
  mutate(om = OM / (CF * 8760)) %>%
  mutate(lcoe = tcc + FC + om) %>%
  mutate(cstart = `CONSTRUCTION START (YEAR)`)

d4 <- lm(TCC2020~ Reactors + RatedMWe + CF + AGE, data = ds2)
summary(d4)
d6 <- lm(tcc~ Reactors + RatedMWe + CF + AGE, data = ds2)
summary(d6)

#scatterplot for AGE and TCC2020
ggplot(data = ds) + 
  geom_point(aes(x = AGE,
                 y = TCC2020)) + 
  geom_smooth(aes(x = AGE,
              y = TCC2020)) + 
  geom_text(aes(label = PLANT,
                x = AGE,
                y = TCC2020), 
                size = 3,
                alpha = 0.7,
                check_overlap = TRUE,
                nudge_y = 0.5,
                nudge_x = 0.8)
  
# i want to order this by TCC2020 value and maybe do a comparison 
# to age of the plant
ggplot(data = ds) + 
  geom_col(aes(x = TCC2020,
              y = PLANT))
