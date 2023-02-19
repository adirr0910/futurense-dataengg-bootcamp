-- Active: 1670398793949@@127.0.0.1@3308@healthcare

-- Q1 
WITH cte AS (
    SELECT `pharmacyID`,`pharmacyName`, SUM(quantity) TotalMedicinesPres, 
    SUM(IF(`hospitalExclusive`='S',quantity,0)) 'Total Hospital Exl'
    FROM pharmacy
    LEFT JOIN prescription USING(`pharmacyID`)
    INNER JOIN contain USING(`prescriptionID`)
    INNER JOIN medicine USING(`medicineID`)
    INNER JOIN treatment USING(`treatmentID`)
    WHERE YEAR(date)=2022
    GROUP BY `pharmacyID`
) SELECT *, ROUND(`Total Hospital Exl`/`TotalMedicinesPres`*100,2) 'Percentage' FROM cte;



-- Q2

select a.state,
    (sum(CASE
            when t.claimID is NULL then 1 else 0 end)/count(t.treatmentID))*100 as percent 
from treatment t inner join person p on t.patientID=p.personID
inner join address a using(`addressID`)
group by a.state;

--Q3


WITH cte AS (
    SELECT state, `diseaseName`,COUNT(`treatmentID`) 'noOftreatments'
    FROM address
    INNER JOIN person p USING (`addressID`)
    INNER JOIN treatment t ON p.`personID`=t.`patientID`
    INNER JOIN disease USING(`diseaseID`)
    WHERE YEAR(date)=2022
    GROUP BY state,`diseaseName`
    ORDER BY state,noOftreatments DESC
)
SELECT DISTINCT state, FIRST_VALUE(`diseaseName`) OVER(PARTITION BY state) 'MaxDisease',
FIRST_VALUE(noOftreatments) OVER(PARTITION BY state) 'noOfMAXtreatments',
LAST_VALUE(`diseaseName`) OVER(PARTITION BY state) 'MinDisease',
LAST_VALUE(noOftreatments) OVER(PARTITION BY state) 'noOfMINtreatments'
FROM cte;


--Q4
SELECT city, COUNT(`personID`) 'no_Patients',ROUND(COUNT(`patientID`)/COUNT(`personID`)*100,2) "Percentage"
FROM address
INNER JOIN person pe USING (`addressID`)
LEFT JOIN patient pa ON pe.`personID`=pa.`patientID`
GROUP BY city
HAVING no_Patients >10;

--Q5

SELECT DISTINCT `companyName`
FROM medicine
WHERE `substanceName` LIKE '%ranitidina%'
LIMIT 3;





