attach(facebook)
facebook
#model 1
m1= lm(Total_Conversion~Spent)
summary(m1)
plot(m1)
#model 2
m2= lm(Total_Conversion~Spent+Impressions+Clicks)
summary(m2)
plot(m2)

#Overall model 2 has better performance than model 1.
#While both models have the same p value, model 2 shows stronger correlation amongst coefficients and 
#has a higher adjusted r squared value of 0.73 compared to model 1 which was only 0.53. 

