install.packages("tidyverse",dep=T)

library(tidyverse)

df<-tribble(
  ~Comparisons,~Age, ~HR,  ~LCL, ~UCL,
 "COMISA vs Control", "20-54yrs", 2.952, 1.549, 5.626,
 "OSA vs Control", "20-54yrs", 1/.503, 1/.199,1/1.272,
"Insomnia vs Control","20-54yrs",1/.486,1/.169,1/1.4,
"COMISA vs Control", "55-67yrs", 2.191, 1.369, 3.508,
 "OSA vs Control", "55-67yrs", 1/.66,1/.31,1/1.42,
"Insomnia vs Control","55-67yrs",1/1.072,1/.375,1/3.06,
"COMISA vs Control", "68-103yrs", 1.709, 1.022, 2.857,
 "OSA vs Control", "68-103yrs",1/.841,1/.396,1/1.788,
"Insomnia vs Control","68-103yrs",1/1.086,1/.443,1/2.667)
 
ggplot(data=df, aes(y=Comparisons, x=HR,
                             xmin=LCL, 
                             xmax=UCL)) +
  geom_point() + 
  geom_errorbarh(height=.1)+
  geom_vline(xintercept=1) +
  facet_wrap(~Age)+
  labs(title="Age")+
  xlab("Hazard Ratio with 95% CI")+
  scale_x_continuous(breaks=c(1,3,5))+
  coord_fixed(ratio=2/1)+
  theme_bw()+
 theme(axis.text.y=element_text(colour="black"),
       axis.text.x=element_text(colour="black"),
       axis.title.y=element_text(vjust=+3.5), #moves y-title away
      plot.title=element_text(hjust=0.5), 
	strip.background=element_blank())


ggplot(data=df, aes(y=Comparisons, x=HR,
                             xmin=LCL, 
                             xmax=UCL)) +
  geom_point() + 
  geom_errorbarh(height=.1)+
  geom_vline(xintercept=1) +
  facet_wrap(~Age)+
  xlab("Hazard Ratio with 95% CI")+
  ylab(NULL)+  #removes y-title
  scale_x_continuous(breaks=c(1,3,5))+
  coord_fixed(ratio=2/1)+
  theme_bw()+
 theme(axis.text.y=element_text(colour="black"),
       axis.text.x=element_text(colour="black"),
       strip.background=element_blank())


