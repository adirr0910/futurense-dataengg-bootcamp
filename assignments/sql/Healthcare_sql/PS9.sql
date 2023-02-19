-- Active: 1670398793949@@127.0.0.1@3308@healthcare


-- Q1


SELECT  state,IFNULL(gender, 'Total') AS Gender, IFNULL(COUNT(`treatmentID`), 'Total') AS 'Total'
FROM address
INNER JOIN person USING(`addressID`)
INNER JOIN patient ON person.`personID`=`patient`.`patientID` 
INNER JOIN treatment USING(`patientID`)
INNER JOIN disease USING(`diseaseID`)
WHERE `diseaseName` = 'Autism'
GROUP BY state,gender WITH ROLLUP;


-- Q2

SELECT `planName`,IFNULL(`companyName`,'Total'), YEAR(date) AS 'year',COUNT(`treatmentID`)
FROM insurancecompany
INNER JOIN insuranceplan USING(`companyID`)
INNER JOIN claim USING(UIN)
INNER JOIN treatment USING(`claimID`)
WHERE YEAR(date) IN (2020,2021,2022)
GROUP BY `planName`,`companyName`,year WITH ROLLUP;

-- Q3

WITH cte AS (
SELECT state,`diseaseName`,COUNT(`treatmentID`) AS 'noOfTreatments', 
DENSE_RANK() OVER (PARTITION BY state ORDER BY COUNT(`treatmentID`) DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 'dRank'
FROM address
INNER JOIN person USING(`addressID`)
INNER JOIN patient ON person.`personID`=`patient`.`patientID` 
INNER JOIN treatment USING(`patientID`)
INNER JOIN disease USING(`diseaseID`)
WHERE YEAR(`date`) = 2022
GROUP BY state,`diseaseName`
)
SELECT state,`diseaseName`,SUM(noOfTreatments) FROM cte
WHERE dRank =ANY (SELECT MAX(dRank) FROM cte ) OR dRank=1
GROUP BY state,`diseaseName` WITH ROLLUP;


--Q4



-- Q5

