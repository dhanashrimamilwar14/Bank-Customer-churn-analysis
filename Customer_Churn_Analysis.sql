------------------------------------------------------------- Bank_Customer_Churn_Analysis -----------------------------------------------------------------------

-- This analysis was done in MySQL 

-- Problem Statement
/* 
 The aim of this project is to understand the key factors influencing churn and create strategies to reduce customer attrition. */

/* Queries used */

Alter Table churn_modelling
Add column Credit_Card_Status Varchar(10) After HasCRCard;
Update churn_modelling
Set Credit_Card_Status  =
      Case
          When HasCrCard = 1 Then "Owned"
          When HasCrCard = 0 Then "Not Owned"
	  End;
Set Sql_Safe_Updates = 0;


Alter Table churn_modelling
Add Column Activity_Status Varchar(10) After IsActiveMember;
Update churn_modelling
Set Activity_Status  =
      Case
          When IsActiveMember = 1 Then "Active"
          When IsActiveMember = 0 Then "Inactive"
	  End;
Set Sql_Safe_Updates = 0;


Alter Table churn_modelling
Add Column Exit_Status Varchar(10) After Exited;
Update churn_modelling
Set Exit_status  =
      Case
          When Exited = 1 Then "Exited"
          When Exited = 0 Then "Not Exited"
	  End;
      
Alter Table churn_modelling
Drop column HasCrCard;
Alter Table churn_modelling
Drop column IsActiveMember;
Alter Table churn_modelling
Drop column Exited;


-- Checking for duplicate rows
Select customerID, Count(customerID) AS count
From churn_modelling
Group By customerID
Having count(customerID) > 1;

-- Checking For Null Values
SELECT
    SUM(CASE WHEN RowNumber IS NULL THEN 1 ELSE 0 END) AS RowNumber_null_count,
    SUM(CASE WHEN CustomerId IS NULL THEN 1 ELSE 0 END) AS CustomerId_null_count,
    SUM(CASE WHEN Surname IS NULL THEN 1 ELSE 0 END) AS Surname_null_count,
    SUM(CASE WHEN CreditScore IS NULL THEN 1 ELSE 0 END) AS CreditScore_null_count,
    SUM(CASE WHEN Geography IS NULL THEN 1 ELSE 0 END) AS Geography_null_count,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_null_count,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_null_count,
    SUM(CASE WHEN Tenure IS NULL THEN 1 ELSE 0 END) AS Tenure_null_count,
    SUM(CASE WHEN Balance IS NULL THEN 1 ELSE 0 END) AS Balance_null_count,
    SUM(CASE WHEN NumOfProducts IS NULL THEN 1 ELSE 0 END) AS NumOfProducts_null_count,
    SUM(CASE WHEN Credit_Card_Status IS NULL THEN 1 ELSE 0 END) AS Credit_Card_null_count,
    SUM(CASE WHEN Activity_Status IS NULL THEN 1 ELSE 0 END) AS Active_Category_null_count,
    SUM(CASE WHEN EstimatedSalary IS NULL THEN 1 ELSE 0 END) AS EstimatedSalary_null_count,
    SUM(CASE WHEN Exit_Status IS NULL THEN 1 ELSE 0 END) AS Exited_Status_null_count
FROM churn_modelling;
-- No null value found


  -------------------------------------- Analysis ---------------------------------------------    
Select * From churn_modelling;

-- 1) Total Customers Of Bank

SELECT count(*) AS Total_Customers
FROM Churn_modelling;

-- 2) Total Active Customers

SELECT COUNT(*) AS Active_Customers
FROM churn_modelling
WHERE Activity_Status = "Active";
   
-- 3) Total Inactive customers

SELECT COUNT(*) AS Inactive_Customers
FROM churn_modelling
WHERE Activity_Status = "Inactive";
   
   
-- 4) Total credit card owned customers

SELECT COUNT(*) AS Credit_Card_Holders
FROM churn_modelling
WHERE Credit_Card_Status = "Owned";
 
-- 5) Total Non credit card owned customer

SELECT COUNT(*) AS Non_Credit_Card_Holders
FROM churn_modelling
WHERE Credit_Card_Status = "Not Owned";   
   
-- 6) Total Churn Customers

SELECT COUNT(*) AS Churn_Customers
FROM churn_modelling
WHERE Exit_Status = "Exited";  

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 7) What is the overall churn rate of  bank's customers?

SELECT 
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exit_Status = 'Exited' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    concat(Round((SUM(CASE WHEN Exit_Status = 'Exited' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2),"%") AS Churn_Rate
FROM 
    churn_modelling;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 9) Customer Churn With respect to credit_score type
Select
      case
          when creditScore >= 800 Then ">800"
          when creditScore < 800 And creditScore >=700 then "700-800"
          when creditScore < 700 and creditScore >=600 then "600-700"
          when creditScore < 600 and creditScore >=500 Then "500-600"
          when creditScore < 500 and creditScore >=400 then "400-500"
          Else "<400"
          End AS Credit_Score_Type,
          Count(customerID) AS Exited_customer_count
From churn_modelling
Where exit_status = "Exited"
Group By Credit_Score_Type 
Order By Exited_customer_count DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 10) Customer churn with respect to whether the customer is an active member or not
Select
      Activity_Status,
      count(customerID) AS Exit_customer_count
From churn_modelling
Where Exit_status ="Exited"
Group By Activity_Status
Order By Exit_customer_count DESC;
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
 
 -- 11) Customer churn with respect to credit card holder or not
  Select
       credit_card_Status,
       Count(customerID) AS Exit_customer_Count
From churn_modelling
Where exit_status = "Exited"
Group By credit_card_Status
Order By Exit_customer_Count DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------- 
 
 -- 12) Customer churn with respect to country
  Select
       Geography,
       Count(CustomerID) AS exit_customer_count
From churn_modelling
Where Exit_Status = "Exited"
Group By Geography
Order By exit_customer_count DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 13) Customer churn with respect to Number of products
Select
       NumOfProducts,
       count(customerID) AS Exit_customer_count
From Churn_modelling
Where Exit_status = "Exited"
Group By NumOfProducts 
Order by Exit_customer_count Desc;
       
 -----------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 14) Customer churn with respect to Tenure
 
 Select
       Tenure,
       Count(customerID) AS Exit_customer_count
From churn_modelling
Where Exit_status = "Exited"
Group By Tenure
Order by Exit_Customer_count DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- 15) customer churn with respect to age group 
 
 Select
       CASE 
			WHEN age <=20 Then "<20"
	        WHEN age >= 21 AND age <= 30 THEN '21-30'
	        WHEN age >= 31 AND age <= 40 THEN '31-40'
			WHEN age >= 41 AND age <= 50 THEN '41-50'
	        WHEN age >= 51 AND age <= 60 THEN '51-60'
	        ELSE '>60'
       END AS age_group,
       Count(customerID) AS Exit_customer_count
From churn_modelling
where Exit_Status = "Exited"
Group by Age_group
Order by Exit_customer_count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 16) Customer churn with respect to Gender

Select 
      Gender,
      count(customerID) AS Exit_customer_count
From churn_modelling
Where Exit_status = "Exited"
Group By Gender
Order by Exit_customer_count DESC;
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 17) Customer churn with respect to balance group
 
Select 
       Case
           when balance >= 0 And balance < 50000 Then "0 - 50K"
           when balance >= 50000 And balance < 100000 Then "50K - 1L"
           when balance >= 100000 And balance < 150000 Then "1L - 1.5L"
           When balance >=150000 And balance < 200000 Then "1.5L - 2L"
           Else ">2L"
	   End AS Balance_group,
       count(customerID) As Exited_customer_count
From churn_modelling
where Exit_status = "Exited"
Group by balance_group 
ORDER By Exited_customer_count DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------------------------------------------------

















