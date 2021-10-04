setwd("~/Documents/R_Statistics") 
KenyaData <- read.csv("1230RKenya.csv")
View(KenyaData)
attach(KenyaData)

library(tidyverse)

#Samples with pest damage:
pests <- KenyaData %>%
  filter(Pest == 'Y')
View(pests)

pestplot <- ggplot(data = pests, mapping = aes(x =months, fill = Species))+
  geom_bar()

print(pestplot)

out <- aov(PercentY ~ Species)
summary(out)

# ANOVA on PercentY and Species 
#             Df Sum Sq Mean Sq F value Pr(>F)
# Species      3   87.7   29.23   1.265  0.313
# Residuals   20  462.2   23.11  

boxplot(PercentY ~ Species, data=KenyaData, xlab="Species", ylab="Percent Yield", col = terrain.colors(4))
New_Data <- select(KenyaData, Species, PercentY)
View(New_Data)


library(ggplot2)

plot1 <- ggplot(KenyaData, mapping = aes(x=Species, y=PercentY))+
  stat_boxplot(geom = 'errorbar', linetype=1, width=0.5)+
  geom_boxplot(outlier.shape = 1, fill = terrain.colors(4), cex.lab = 1.5)+
  stat_summary(fun.y=mean, geom = 'point', size = 2)

print(plot1 + labs(x="Species", y = "Percent Yield") + theme_linedraw()+ 
        theme(plot.title = element_text(size = 20, hjust = 0.5),
              axis.title.x = element_text(size = 20),
              axis.title.y = element_text(size = 20),
              axis.text.x = element_text(size = 18),
              axis.text.y = element_text(size = 18)))


#BEST SO FAR....?
p <- ggplot(KenyaData, mapping = aes(x=Species, y = PercentY, xlab = "Species", ylab="Percent Yield"))+
  geom_boxplot(fill = terrain.colors(4))+
  geom_jitter(position=position_jitter(0.2))

print(p + labs(x="Species", y = "Percent Yield"))

?geom_boxplot()

prem <- aov(PCharcoalY ~ Species)
summary(prem)

ggplot(data=KenyaData, mapping = aes(x = Species, y = PercentY, xlab="Species", ylab="Percent Yield"))+
  geom_boxplot()
?labs()

# ANOVA on PCharcoalY and Species 
#            Df Sum Sq Mean Sq F value  Pr(>F)   
# Species      3  112.0   37.34   5.131 0.00856 **
#  Residuals   20  145.5    7.28    

plot2 <- ggplot(KenyaData, mapping = aes(x=Species, y=PCharcoalY))+
  stat_boxplot(geom = 'errorbar', linetype=1, width=0.5)+
  geom_boxplot(outlier.shape = 1, fill = terrain.colors(4), cex.lab = 1.5)+
  stat_summary(fun.y=mean, geom = 'point', size = 2)

print(plot2 + labs(x="Species", y = "Premium Charcoal Yield (%)") + theme_linedraw()+ 
        theme(plot.title = element_text(size = 20, hjust = 0.5),
              axis.title.x = element_text(size = 20),
              axis.title.y = element_text(size = 20),
              axis.text.x = element_text(size = 18),
              axis.text.y = element_text(size = 18)))

boxplot(PCharcoalY ~ Species, data=KenyaData, xlab="Species", ylab="Premium Charcoal Yield (%)", col = terrain.colors(4))
KWSpecies<- kruskal.test(PercentY ~ Species, data=KenyaData)
summary(KWSpecies)
head(KenyaData)
levels(KenyaData$Species)
install.packages("dplyr")
library(dplyr)

sum <- KenyaData %>%
  select(Species, PercentY)
install.packages(psych)

summary(sum)

aSum <- sum %>% group_by(Species) %>%
  summarise(mean = mean(PercentY, na.rm = TRUE), sd = sd(PercentY, na.rm = TRUE),SE = (sd(PercentY, na.rm = TRUE)/sqrt(6)), median = median(PercentY, na.rm = TRUE), IQR = IQR(PercentY, na.rm = TRUE))

View(aSum)
kruskal.test(PercentY ~ Species, data=KenyaData)

#Kruskal - Wallis Rank Sum Test Species and PercentY 
# Kruskal-Wallis rank sum test
# data:  PercentY by Species
# Kruskal-Wallis chi-squared = 2.86, df = 3, p-value = 0.4137

prem.tukey<- TukeyHSD(prem)
prem.tukey

#Tukey Multiple Comparisons of Means: $Species and PCharcoalY
# diff       lwr      upr     p adj
# S. siamea-A. polyacantha       4.516667  0.157619 8.875714 0.0405876
# S. spectabilis-A. polyacantha  5.640000  1.280952 9.999048 0.0084938
# T. brownii-A. polyacantha      2.325000 -2.034048 6.684048 0.4600192
# S. spectabilis-S. siamea       1.123333 -3.235714 5.482381 0.8874475
# T. brownii-S. siamea          -2.191667 -6.550714 2.167381 0.5095211
# T. brownii-S. spectabilis     -3.315000 -7.674048 1.044048 0.1782453

nonprem <- aov(NpCharcoalY ~ Species, data=KenyaData)
summary(nonprem)
boxplot(NpCharcoalY ~ Species, data=KenyaData, xlab="Species", ylab="Briquette Charcoal Yield (%)", col = terrain.colors(4))

plot3 <- ggplot(KenyaData, mapping = aes(x=Species, y=NpCharcoalY))+
  stat_boxplot(geom = 'errorbar', linetype=1, width=0.5)+
  geom_boxplot(outlier.shape = 1, fill = terrain.colors(4), cex.lab = 1.5)+
  stat_summary(fun.y=mean, geom = 'point', size = 2)

print(plot3 + labs(x="Species", y = "Briquette Charcoal Yield (%)") + theme_linedraw()+ 
        theme(plot.title = element_text(size = 20, hjust = 0.5),
              axis.title.x = element_text(size = 20),
              axis.title.y = element_text(size = 20),
              axis.text.x = element_text(size = 18),
              axis.text.y = element_text(size = 18)))

# ANOVA on NpCharcoalY and Species
#            Df Sum Sq Mean Sq F value  Pr(>F)   
# Species      3  219.9   73.32    7.54 0.00145 **
#  Residuals   20  194.5    9.72  

nonprem.tukey<- TukeyHSD(nonprem)
nonprem.tukey

# Tukey Multiple Comparisons of Means: Species and NpCharcoalY 
#                                    diff        lwr         upr     p adj
# S. siamea-A. polyacantha      -4.2566667  -9.295833  0.78249942 0.1169210
# S. spectabilis-A. polyacantha -4.9850000 -10.024166  0.05416608 0.0531615
# T. brownii-A. polyacantha      2.3550000  -2.684166  7.39416608 0.5686495
# S. spectabilis-S. siamea      -0.7283333  -5.767499  4.31083275 0.9770039
# T. brownii-S. siamea           6.6116667   1.572501 11.65083275 0.0075783
# T. brownii-S. spectabilis      7.3400000   2.300834 12.37916608 0.0030355

tbrown <- KenyaData %>%
  filter(Species == 'T. brownii')
tbrown_freq_plot <- ggplot(data = tbrown, mapping = aes(x = PercentY)) +
  geom_freqpoly()

print(tbrown_freq_plot)

ytype<- aov(NpCharcoalY + PCharcoalY ~ Species, data=KenyaData)
summary(ytype)

KWDryTimeY<-kruskal.test(PercentY ~ months, data=KenyaData)
KWDryTimeY

KWDryTimeY.tukey<- TukeyHSD(KWDryTimeY)

out1 <- aov(PercentY ~ months, data = KenyaData)
summary(out1)

TKout1 <- TukeyHSD(out1)


plot <- plot(AvgPercentM, PercentY)
line(AvgPercentM, PercentY)

RegresDiamY<-lm(PercentY ~ AvgSize, data = KenyaData)
summary(RegresDiamY)
plot(PercentY ~ AvgSize)
abline(lm(PercentY ~ AvgSize, data = KenyaData))
ggplot(data = KenyaData, mapping = aes(x = AvgSize, y = PercentY))+
  geom_point()

regresMosit<- lm(PercentY ~ R.Moist, data = KenyaData)
summary(regresMosit)
#Residuals:
#Min      1Q  Median      3Q     Max 
#-7.4493 -2.6127  0.4986  1.8356 14.6000 

#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)    
#(Intercept)   29.507      3.064   9.630 2.38e-09 ***
#  R.Moist       -1.493      1.315  -1.135    0.268    
#---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 4.859 on 22 degrees of freedom
#Multiple R-squared:  0.05535,	Adjusted R-squared:  0.01241 
#F-statistic: 1.289 on 1 and 22 DF,  p-value: 0.2685

boxplot(PercentY ~ months, data=KenyaData, xlab = "Dry Time (Months)", ylab = "Percent Yield", col = topo.colors(3))

plot4 <- ggplot(KenyaData, mapping = aes(x=months, y=PercentY, group = months))+
  stat_boxplot(geom = 'errorbar', linetype=1, width=0.5)+
  geom_boxplot(outlier.shape = 1, fill = topo.colors(3))+
  stat_summary(fun.y=mean, geom = 'point', size = 2)

print(plot4 + labs(x="Dry Time (months)", y = "Percent Yield") + theme_linedraw()+ 
        theme(plot.title = element_text(size = 20, hjust = 0.5),
              axis.title.x = element_text(size = 20),
              axis.title.y = element_text(size = 20),
              axis.text.x = element_text(size = 18),
              axis.text.y = element_text(size = 18)))

install.packages("ggthemes")
library(ggthemes)

line <-  ggplot(data = KenyaData, mapping = aes(x = R.Moist, y = PercentY))+
  geom_point()+ geom_rangeframe()+
  geom_smooth(se = FALSE, method = lm)+
  theme_linedraw() +
  labs(x= "Moisture Rating", y="Percent Yield")

print(line + theme(axis.title.x = element_text(size = 20), 
              axis.title.y = element_text(size = 20), 
              axis.text = element_text(size = 18)) +
        scale_x_continuous(breaks = seq(0, 4, 0.5)))
        

#load file with diameters of uncarbonized wood
uncarb_wood <- read.csv('diam_uncarb.csv')
View(uncarb_wood)

num_species <- uncarb_wood %>%
  group_by(SPECIES) %>%
  summarise(n = n())

View(num_species)

#build bar plot uncarb wood for speices 
bar_plot_uncarb <-ggplot(data = num_species, mapping = aes(x=SPECIES, y =n, fill=SPECIES))+
  geom_bar(stat='identity')+
  theme_linedraw()

print(bar_plot_uncarb + labs(x='Species', y = 'Number of Uncarbonized Wood Pieces')+ 
        theme(plot.title = element_text(size = 14, hjust = 0.5),
              axis.title.x = element_text(size = 14),
              axis.title.y = element_text(size = 14),
              axis.text.x = element_text(size = 12),
              axis.text.y = element_text(size = 12),
              ))
#build histogram for diameters of uncarb wood by species
diam_uncarb <- ggplot(data=uncarb_wood, mapping = aes(x=DIAMETER, fill = SPECIES))+
  geom_histogram(binwidth = 0.05) +
  theme_linedraw()

print(diam_uncarb + labs(x='Diameter (cm)', y = 'Number of Uncarbonized Wood Pieces', fill = 'Species')+ 
        theme(legend.background = element_rect(fill = 'lightyellow', linetype='solid', colour = 'black'),
              legend.position = c(0.85, 0.8),
              legend.text = element_text(size = 16),
              legend.title = element_text(size=16),
              plot.title = element_text(size = 20, hjust = 0.5),
              axis.title.x = element_text(size = 20),
              axis.title.y = element_text(size = 20),
              axis.text.x = element_text(size = 18),
              axis.text.y = element_text(size = 18)))


#build freq plot uncarb wood
freq_plot_uncarb <- ggplot(data = uncarb_wood, mapping = aes(x=DIAMETER))+
  geom_density()+
  theme_linedraw()

print(freq_plot_uncarb + labs(x='Species', y = 'Number of Uncarbonized Wood Pieces')+ 
        theme(plot.title = element_text(size = 14, hjust = 0.5),
              axis.title.x = element_text(size = 14),
              axis.title.y = element_text(size = 14),
              axis.text.x = element_text(size = 12),
              axis.text.y = element_text(size = 12),
        ))

#Read Diameter Data
diam <- read.csv('DiametersData.csv')
View(diam)

diam_plot <- ggplot(data = diam, mapping = aes(x = D)) +
  geom_histogram(binwidth = 0.2)

print(diam_plot)


