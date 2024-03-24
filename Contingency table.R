library(readxl)
library(gplots)
library(graphics)
library(corrplot)
library(viridis)
setwd(dirname(getActiveDocumentContext()$path))


nazwaZbioruWejB <- "MarcelXYTMeanC4.xlsx"
dataB <- read_excel(nazwaZbioruWejB, sheet=2)

nazwaZbioruWejA <- "Marcel filar C-4 G-2 505.xlsx"
dataA <- read_excel(nazwaZbioruWejA)


# statistics and plots for ClusterTable
dataA$groupE <- as.factor(ifelse(dataA$Energia<1e3, 'A',
                                 ifelse(dataA$Energia<1e4, 'B',
                                        ifelse(dataA$Energia<1e5, 'C','D'
                                        ))))


ClusterTable <- table(dataA$groupE, dataA$Cluster)

rownames(ClusterTable) = c("Low", "Medium", "High", "VeryHigh")

ClusterTableRel <- prop.table(ClusterTable, margin=2)


chi <- chisq.test(ClusterTable)
stdres <- chi$stdres
chi
assocstats(ClusterTable)

colorScale <- viridis(200)

corrplot(chi$stdres, col = colorScale, is.cor = FALSE, cl.align.text = 'l', cl.pos="n"
         , tl.col = 'black', tl.srt = 0)
colorlegend(colbar = colorScale, round(seq(min(chi$stdres),max(chi$stdres),by=1)), col = 'black', align = 'l',
            xlim = c(0, 20), ylim = c(-2.1, -0.1), vertical = FALSE)



corrplot(ClusterTable, col = colorScale, is.cor = FALSE, cl.align.text = 'l', cl.pos="n"
         , tl.col = 'black', tl.srt = 0)
colorlegend(colbar = colorScale, seq(min(ClusterTable),max(ClusterTable),by=20), col = 'black', align = 'l',
            xlim = c(0, 20), ylim = c(-2.1, -0.1), vertical = FALSE)

