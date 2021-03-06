## 데이터 정의
rm(list=ls())

library(readxl)
netflix <- read_excel('netflix_original_종합_수정(sum)_(정량화보함).xlsx')

### 종합 데이터
netflix_original <- netflix
netflix_original <- netflix_original[,c(9,15,18,32:40)]
netflix_original <- na.omit(netflix_original)
netflix_original[, 4:12] <- lapply(netflix_original[, 4:12], factor)
netflix_original[, 1:3] <- lapply(netflix_original[, 1:3], as.numeric)

### 드라마 데이터
netflix_drama <- netflix[1:170,]
netflix_drama <- netflix_drama[,c(9,15,18,32:40)]
netflix_drama <- na.omit(netflix_drama)
netflix_drama[, 4:12] <- lapply(netflix_drama[, 4:12], factor)
netflix_drama[, 1:3] <- lapply(netflix_drama[, 1:3], as.numeric)

### 영화 데이터
netflix_movie <- netflix[171:589,]
netflix_movie <- netflix_movie[,c(9,15,18,32:40)]
netflix_movie <- na.omit(netflix_movie)
netflix_movie[, 4:12] <- lapply(netflix_movie[, 4:12], factor)
netflix_movie[, 1:3] <- lapply(netflix_movie[, 1:3], as.numeric)


# ALL_rating outlier 제거: 낮은 점수 반영 못함
# myboxplot <- boxplot(netflix$All_rating)
# myboxplot$out
# netflix <- netflix[-c(which(netflix$All_rating<=3.7)),]
# myboxplot <- boxplot(netflix$All_rating)

### 년도
library(ggplot2)
ggplot(netflix_original,aes(x=as.factor(Year),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Year)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("년도") + ylab("점수") + labs(fill = "년도")

### age
ggplot(netflix_original,aes(x=as.factor(Age),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Age)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("age") + ylab("점수") + labs(fill = "Age")

### harmful_themes
ggplot(netflix_original,aes(x=as.factor(Harmful_themes),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Harmful_themes)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("harmful_themes") + ylab("점수") + labs(fill = "Harmful_themes")

### lewdness
ggplot(netflix_original,aes(x=as.factor(Lewdness),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Lewdness)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("lewdness") + ylab("점수") + labs(fill = "Lewdness")

### violence
ggplot(netflix_original,aes(x=as.factor(Violence),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Violence)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("violence") + ylab("점수") + labs(fill = "Violence")

### profanity
ggplot(netflix_original,aes(x=as.factor(Profanity),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Profanity)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("profanity") + ylab("점수") + labs(fill = "Profanity")

### fear
ggplot(netflix_original,aes(x=as.factor(Fear),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Fear)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("fear") + ylab("점수") + labs(fill = "Fear")

### drugs
ggplot(netflix_original,aes(x=as.factor(Drugs),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Drugs)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("drugs") + ylab("점수") + labs(fill = "Drugs")

### immatatable
ggplot(netflix_original,aes(x=as.factor(Immatatable),y=All_rating))+
  geom_boxplot(aes(fill=as.factor(Immatatable)),outlier.colour = 'red',alpha=I(0.4))+
  xlab("immatatable") + ylab("점수") + labs(fill = "Immatatable")

## cooks distance outlier제거
### 종합 데이터
fit_tmp <- lm(All_rating ~ . , data=netflix_original)
cooks <- cooks.distance(fit_tmp)
plot(cooks, pch=".", cex=1.5, main = "Plot for Cook's Distance")

text(x=1:length(cooks), y=cooks, labels = ifelse(cooks > 4/nrow(netflix), names(cooks), ""), col = "red")
outlier <- names(cooks)[(cooks > 4/nrow(netflix))]
outlier <- as.integer(na.omit(outlier))
netflix_original <- netflix_original[-outlier, ]

### 드라마 데이터
fit_tmp <- lm(All_rating ~ . , data=netflix_drama)
cooks <- cooks.distance(fit_tmp)
plot(cooks, pch=".", cex=1.5, main = "Plot for Cook's Distance")

text(x=1:length(cooks), y=cooks, labels = ifelse(cooks > 4/nrow(netflix), names(cooks), ""), col = "red")
outlier <- names(cooks)[(cooks > 4/nrow(netflix))]
outlier <- as.integer(na.omit(outlier))
netflix_drama <- netflix_drama[-outlier, ]

### 영화 데이터
fit_tmp <- lm(All_rating ~ . , data=netflix_movie)
cooks <- cooks.distance(fit_tmp)
plot(cooks, pch=".", cex=1.5, main = "Plot for Cook's Distance")

text(x=1:length(cooks), y=cooks, labels = ifelse(cooks > 4/nrow(netflix), names(cooks), ""), col = "red")
outlier <- names(cooks)[(cooks > 4/nrow(netflix))]
outlier <- as.integer(na.omit(outlier))
netflix_movie <- netflix_movie[-outlier, ]

## 일반회귀
### 종합 데이터
fit_OLS_original <- lm(All_rating ~ . , data=netflix_original)
summary(fit_OLS_original)
anova(fit_OLS_original)
par(mfrow = c(2,2))
plot(fit_OLS_original)

### 드라마 데이터
fit_OLS_drama <- lm(All_rating ~ . , data=netflix_drama)
summary(fit_OLS_drama)
anova(fit_OLS_drama)
par(mfrow = c(2,2))
plot(fit_OLS_drama)

### 영화 데이터
fit_OLS_movie <- lm(All_rating ~ . , data=netflix_movie)
summary(fit_OLS_movie)
anova(fit_OLS_movie)
par(mfrow = c(2,2))
plot(fit_OLS_movie)

## 로버스트 회귀
library('MASS')
### 종합 데이터
fit_m_original <- rlm(All_rating ~ . , data=netflix_original)
summary(fit_m_original)
anova(fit_m_original)
par(mfrow = c(2,2))
plot(fit_m_original)

### 드라마 데이터
fit_m_drama <- rlm(All_rating ~ . , data=netflix_drama)
summary(fit_m_drama)
anova(fit_m_drama)
par(mfrow = c(2,2))
plot(fit_m_drama)

### 영화 데이터
fit_m_movie <- rlm(All_rating ~ . , data=netflix_movie)
summary(fit_m_movie)
anova(fit_m_movie)
par(mfrow = c(2,2))
plot(fit_m_movie)

