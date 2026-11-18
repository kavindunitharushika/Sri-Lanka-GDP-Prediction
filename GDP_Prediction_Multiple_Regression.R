# Predicting Sri Lanka's GDP Using Multiple Linear Regression
# Adapted from Appendix B (pages 57-68) of the September 2025 case-study report.
# PDF typesetting spaces in function/column names have been corrected.
# Input required: final.csv in the same folder as this script.
# Expected columns: Year, ln_GDP, Trade, FDI, Domestic_Credit,
#                   Capital_Formation, Pop_Growth
# This script reproduces the analysis code presented in the appendix;
# it does not recreate the earlier data-cleaning steps described in the report.

library(ggplot2)
library(gridExtra)
library(reshape2)
library(dplyr)
library(broom)
library(olsrr)
library(lmtest)
library(car)
library(ggfortify)

if (!file.exists('final.csv')) stop('Place final.csv in the working directory before running.')
data <- read.csv('final.csv')
required <- c('ln_GDP', 'Trade', 'FDI', 'Domestic_Credit', 'Capital_Formation', 'Pop_Growth')
if (!all(required %in% names(data))) stop(paste('Missing columns:', paste(setdiff(required, names(data)), collapse=', ')))
# The appendix removes Year for exploratory analysis.
eda_data <- data[, !names(data) %in% 'Year', drop=FALSE]
print(eda_data)
print(summary(eda_data))

# B.1 Exploratory Data Analysis: histograms
for (variable in c('ln_GDP', 'Trade', 'FDI', 'Domestic_Credit', 'Capital_Formation', 'Pop_Growth')) {
  print(ggplot(eda_data, aes(x=.data[[variable]])) +
    geom_histogram(aes(y=after_stat(density)), bins=30, fill='grey', color='black') +
    theme_minimal() + labs(title=paste(variable, 'Distribution'), x=variable, y='Density'))
}

# Boxplots
for (variable in c('Pop_Growth', 'Capital_Formation', 'Domestic_Credit', 'FDI', 'Trade', 'ln_GDP')) {
  print(ggplot(eda_data, aes(y=.data[[variable]])) +
    geom_boxplot(fill='lightblue', color='black') +
    labs(title=paste('Boxplot of', variable), y=variable) +
    theme_minimal() + theme(plot.title=element_text(size=14, face='bold')))
}

# Scatterplots with regression lines
scatter_plot <- function(variable) {
  ggplot(eda_data, aes(x=.data[[variable]], y=ln_GDP)) +
    geom_point(color='black', size=1, alpha=0.6) +
    geom_smooth(method='lm', color='red', se=FALSE) +
    labs(title=paste(variable, 'vs ln_GDP'), x=variable, y='ln_GDP') +
    theme_minimal() + theme(plot.title=element_text(size=14, face='bold'))
}
p1 <- scatter_plot('Pop_Growth')
p2 <- scatter_plot('Capital_Formation')
p3 <- scatter_plot('Domestic_Credit')
p4 <- scatter_plot('FDI')
p5 <- scatter_plot('Trade')
grid.arrange(p1, p2, p3, p4, p5, ncol=3)

# Correlation heatmap
cor_matrix <- cor(eda_data)
melted_cor_matrix <- melt(cor_matrix)
print(ggplot(melted_cor_matrix, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() + geom_text(aes(label=round(value, 2)), color='white', size=4) +
  scale_fill_gradient2(low='darkred', mid='white', high='darkblue',
                       midpoint=0, limits=c(-1, 1), name='Correlation') +
  theme_minimal() +
  theme(axis.text.x=element_text(angle=45, vjust=1, hjust=1),
        axis.title=element_blank()) + labs(title='Correlation Heatmap'))

# B.2 Quantitative Analysis
full_model <- lm(ln_GDP ~ Domestic_Credit + FDI + Trade + Capital_Formation + Pop_Growth, data=data)
print(full_model)
print(summary(full_model))
print(anova(full_model))

reduced_model <- lm(ln_GDP ~ Domestic_Credit + FDI + Trade, data=data)
print(reduced_model)
print(summary(reduced_model))
print(anova(reduced_model))
print(confint(reduced_model, level=0.95))
coef_df <- broom::tidy(reduced_model, conf.int=TRUE, conf.level=0.95)
print(coef_df)
print(ggplot(coef_df, aes(x=term, y=estimate)) +
  geom_point(color='blue', size=3) +
  geom_errorbar(aes(ymin=conf.low, ymax=conf.high), width=0.2, color='red') +
  geom_hline(yintercept=0, linetype='dashed', color='black') +
  coord_flip() +
  labs(title='95% Confidence Intervals for Coefficients', x='Predictors', y='Estimated Coefficients') +
  theme_minimal(base_size=14))

print(anova(full_model, reduced_model))
bs <- ols_step_best_subset(full_model)
print(bs)
stp <- ols_step_both_p(full_model, pent=0.05, prem=0.05, details=FALSE)
print(stp)

residuals_df <- data.frame(Residuals=residuals(reduced_model), Fitted=fitted(reduced_model))
print(ggplot(residuals_df, aes(sample=Residuals)) +
  stat_qq(color='black', size=2) + stat_qq_line(color='darkred', linetype='dashed') +
  labs(title='Normal Q-Q Plot', x='Theoretical Quantiles', y='Sample Quantiles') + theme_minimal())
print(shapiro.test(residuals(reduced_model)))
print(ggplot(residuals_df, aes(x=Fitted, y=Residuals)) +
  geom_point(color='black', size=2) + geom_hline(yintercept=0, color='darkred', linetype='dashed') +
  labs(title='Residuals vs Fitted', x='Fitted Values', y='Residuals') + theme_minimal())
print(bptest(reduced_model))
print(vif(reduced_model))
print(durbinWatsonTest(reduced_model))

df <- data.frame(Trade=data$Trade, FDI=data$FDI,
                 Domestic_Credit=data$Domestic_Credit, Residuals=residuals(reduced_model))
for (variable in c('Trade', 'FDI', 'Domestic_Credit')) {
  point_color <- c(Trade='blue', FDI='darkgreen', Domestic_Credit='purple')[[variable]]
  print(ggplot(df, aes(x=.data[[variable]], y=Residuals)) +
    geom_point(color=point_color, alpha=0.7, size=2) +
    geom_hline(yintercept=0, linetype='dashed', color='red') +
    labs(title=paste('Residuals vs', gsub('_', ' ', variable)),
         x=gsub('_', ' ', variable), y='Residuals') + theme_minimal())
}
