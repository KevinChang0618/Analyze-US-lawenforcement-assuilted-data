# Future analysis questions:

1.	Trying to categorize each states' cases of assaulting law enforcements.   
2.	Analyzing the data set to find the relation between the crime time to the number of cases.
3.	Do two sample t test for daytime and nighttime to find if there is difference for occurring  crime cases in daytime and nighttime.
4.	Trying to find the relations for different kinds of weapons with injury or not to protect law enforcement officers.
5.  Initial data analyze.  
This data is from FBI National Incident-Based Reporting System (NIBRS)(https://crime-data-explorer.fr.cloud.gov/downloads-and-docs).  
   The columns meaning are follow:  
   DATE_YEAR: The number for year. (from 1995 ~ 2018)  
   PUB_AGENCY_NAME: Agency name for taking each cases.  
   PUB_AGENCY_UNIT: Agency unit for each cases.  
   STATE_ABBR: U.S State abbreviation.  
   DIVISION_NAME: Division for each cases.  
   REGION_NAME: Region for each cases. (North, South, East, West)  
   AGENCY_TYPE_NAME: Agency type. (ex. City, County, Federal ...)  
   POPULATION_GROUP_DESC: Population of the cases city.  
   COUNTY_NAME: County name for each cases.  
   TIME_0001_0200_CNT: Number of crimes during 00-02.  
   TIME_0201_0400_CNT: Number of crimes during 02-04.  
   TIME_0401_0600_CNT: Number of crimes during 04-06.  
   TIME_0601_0800_CNT: Number of crimes during 06-08.  
   TIME_0801_1000_CNT: Number of crimes during 08-10.  
   TIME_1001_1200_CNT: Number of crimes during 10-12.  
   TIME_1201_1400_CNT: Number of crimes during 12-14.  
   TIME_1401_1600_CNT: Number of crimes during 14-16.  
   TIME_1601_1800_CNT: Number of crimes during 16-18.  
   TIME_1801_2000_CNT: Number of crimes during 18-20.  
   TIME_2001_2200_CNT: Number of crimes during 20-22.  
   TIME_2201_0000_CNT: Number of crimes during 22-00.  
   FIREARM_INJURY_CNT: Number of officer injure in firearm assault.  
   FIREARM_NO_INJURY_CNT: Number of officer not injure in firearm assault.  
   KNIFE_INJURY_CNT: Number of officer injure in knife assault.  
   KNIFE_NO_INJURY_CNT: Number of officer not injure in knife assault.  
   HANDS_FISTS_FEET_INJURY_CNT: Number of officer injure in fist assault.  
   HANDS_FISTS_FEET_NO_INJURY_CNT: Number of officer not injure in fist assault.  
   OTHER_INJURY_CNT: Number of officer injure in other type assault.  
   OTHER_NO_INJURY_CNT: Number of officer not injure in other type assault.  
   LEOKA_FELONY_KILLED: Law Enforcement Officers Killed and Assaulted in purpose.  
   LEOKA_ACCIDENT_KILLED: Law Enforcement Officers Killed and Assaulted in accident.  

# Shiny App Ideas:

1.	Using the USA geographic map to do interactions for users (checking a state then showing up the state's data with plots, data, and statistics.)  
We will use "tmap" and "leaflet" packages in R to plot out the USA map as our very first interface, then guide the users to click on the states and show information. 
2.	Using timer to do reactivity on each year's crime cases data in each state.  
3.	Plotting out the regression statistics (e.g. the crime time to the number of cases; injuring parts to the weapons) for each state in each year. 
