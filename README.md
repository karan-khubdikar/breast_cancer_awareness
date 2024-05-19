# Breast Cancer Awareness
![image](https://github.com/karan-khubdikar/breast_cancer_awareness/blob/master/img/Breast-cancer-awareness.jpg)

Contributor: Karan Khubdikar

### Motivation

According to a [2021 clinical review](https://ascopubs.org/doi/full/10.1200/op.20.00793), 
breast cancer is now the most common type of cancer for women younger than 39.
Breast cancer is also among one of the top 5 cancer deaths in 2020 according to World Health Organization
This dashboard aims to raise awareness among women about the importance of regular check-ups, 
encouraging proactive measures to prevent the onset of breast cancer.

**Target audience:** Women aged 20-65 and healthcare professionals
Breast cancer awareness and early detection are critical for saving lives. 
This dashboard aims to empower women by providing insights into breast cancer statistics across Canada
and raise awareness about it. It also serves as a educational platform and a reminder for women to have regular checkups
so as to avoid developing breast cancer or help with diagnosing it at the early stage and mitigate complications. 
The app is also useful for the healthcare professionals, especially for educational
so that they can spread awareness among the group of women, especially those who are more susceptible to develop it. 
The dashboard can also be used for monitoring and targeting the focus of medication for the highly susceptible group by
marketing professionals of the healthcare sector. 


### App description

The video below provides a more detailed description of the app. However to briefly summarize, 
there are 4 components that can be viewed:
1. Overall no. of new breast cancer cases in Canada
2. Top 5 provinces with new breast cancer cases on year to year basis
3. Distribution of the top 5 cancers that cause deaths among women across each province(yearly average)
4. Agewise distribution of new breast cancer cases across each province(yearly average)
There are filters for `year` and `province` to deep dive for the respective charts/tables.

### Installation instructions

Please follow the instructions below to run the app locally.

1. Clone the repository

```
git clone https://github.ubc.ca/MDS-2023-24/DSCI_532_individual-assignment_karan647.git
cd DSCI_532_individual-assignment_karan647
```
2. Open RStudio project file (`DSCI_532_individual-assignment_karan647`)

**Note:** To install RStudio follow [link](https://rstudio-education.github.io/hopr/starting.html) if you do not have Rstudio installed.

3. Install `renv` by typing the following in the Rstudio console
```
install.packages("renv")
```

4. Open the `app.R` file and run the following command in console to update the dependencies required
```
renv::restore()
```

5. After installing the packages, you can run the Shiny app by clicking the "Run App" button 
located at the top right corner of the `app.R` script tab in RStudio or enter the following command in console.
```
shiny::runApp("src/app.R")
```
6. The Shiny app should open in your default web browser, allowing you to interact with it locally

### Video walkthrough

The following video provides a walkthrough to navigate through the app

![Video walkthrough](https://github.ubc.ca/MDS-2023-24/DSCI_532_individual-assignment_karan647/blob/master/img/DSCI_532_individual-assignment_karan647.mp4)

### References

https://www.who.int/news-room/fact-sheets/detail/cancer

https://ascopubs.org/doi/full/10.1200/op.20.00793

https://mastering-shiny.org/basic-app.html

[Data Source](https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310011101&pickMembers%5B0%5D=2.1&pickMembers%5B1%5D=3.3&pickMembers%5B2%5D=4.28&cubeTimeFrame.startYear=2012&cubeTimeFrame.endYear=2021&referencePeriods=20120101%2C20210101)
