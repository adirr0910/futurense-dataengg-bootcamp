-- Active: 1670398793949@@127.0.0.1@3308@healthcare


-- Q1

SELECT DATEDIFF(hour, dob , GETDATE())/8766 AS age, count(*) AS numTreatments
FROM Person
JOIN Patient ON Patient.patientID = Person.personID
JOIN Treatment ON Treatment.patientID = Patient.patientID
group by DATEDIFF(hour, dob , GETDATE())/8766
order by numTreatments desc;

-- optimized
SELECT TIMESTAMPDIFF(YEAR,dob,CURDATE()) AS age, count(*) AS numTreatments
FROM Person
INNER JOIN patient ON Patient.patientID = Person.personID
INNER JOIN treatment USING(`patientID`)
group by age
order by numTreatments desc;



-- Q2

drop table if exists T1;
drop table if exists T2;
drop table if exists T3;

select Address.city, count(Pharmacy.pharmacyID) as numPharmacy 
--into T1
from Pharmacy right join Address on Pharmacy.addressID = Address.addressID
group by city
order by count(Pharmacy.pharmacyID) desc;

select Address.city, count(InsuranceCompany.companyID) as numInsuranceCompany
-- into T2
from InsuranceCompany right join Address on InsuranceCompany.addressID = Address.addressID
group by city
order by count(InsuranceCompany.companyID) desc;

select Address.city, count(Person.personID) as numRegisteredPeople
-- into T3
from Person right join Address on Person.addressID = Address.addressID
group by city
order by count(Person.personID) desc;

select T1.city, T3.numRegisteredPeople, T2.numInsuranceCompany, T1.numPharmacy
from T1, T2, T3
where T1.city = T2.city and T2.city = T3.city
order by numRegisteredPeople desc;


show tables;

select city, COUNT(`personID`) 'numPersons' ,count(pharmacyID) as numPharmacy, COUNT(companyID) as numInsurance
from address 
LEFT JOIN pharmacy USING(`addressID`)
LEFT JOIN insurancecompany USING (`addressID`)
INNER JOIN person USING (`addressID`)
group by city
order by numPharmacy DESC;


-- Q3
select 
C.prescriptionID, sum(quantity) as totalQuantity,
CASE WHEN sum(quantity) < 20 THEN 'Low Quantity'
WHEN sum(quantity) < 50 THEN 'Medium Quantity'
ELSE 'High Quantity' END AS Tag
FROM Contain C
JOIN Prescription P 
on P.prescriptionID = C.prescriptionID
JOIN Pharmacy on Pharmacy.pharmacyID = P.pharmacyID
where Pharmacy.pharmacyName = 'Ally Scripts'
group by C.prescriptionID;

--Optimized 
SELECT 
C.prescriptionID, sum(quantity) as totalQuantity,
CASE 
WHEN sum(quantity) < 20 THEN 'Low Quantity'
WHEN sum(quantity) < 50 THEN 'Medium Quantity'
ELSE 'High Quantity' END AS Tag
FROM Contain C
INNER JOIN Prescription P ON P.prescriptionID = C.prescriptionID
INNER JOIN Pharmacy  USING(`pharmacyID`)
where Pharmacy.pharmacyName = 'Ally Scripts'
group by prescriptionID;


-- Q4

drop table if exists T1;

select Pharmacy.pharmacyID, Prescription.prescriptionID, sum(quantity) as totalQuantity
into T1
from Pharmacy
join Prescription on Pharmacy.pharmacyID = Prescription.pharmacyID
join Contain on Contain.prescriptionID = Prescription.prescriptionID
join Medicine on Medicine.medicineID = Contain.medicineID
join Treatment on Treatment.treatmentID = Prescription.treatmentID
where YEAR(date) = 2022
group by Pharmacy.pharmacyID, Prescription.prescriptionID
order by Pharmacy.pharmacyID, Prescription.prescriptionID;


select * from T1
where totalQuantity > (select avg(totalQuantity) from T1);

--Optimized
WITH cte AS (
select Pharmacy.pharmacyID, Prescription.prescriptionID, sum(quantity) as totalQuantity
from Pharmacy
join Prescription on Pharmacy.pharmacyID = Prescription.pharmacyID
join Contain on Contain.prescriptionID = Prescription.prescriptionID
join Medicine on Medicine.medicineID = Contain.medicineID
join Treatment on Treatment.treatmentID = Prescription.treatmentID
where YEAR(date) = 2022
group by Pharmacy.pharmacyID, Prescription.prescriptionID
order by Pharmacy.pharmacyID, Prescription.prescriptionID
)
SELECT * FROM cte
WHERE totalQuantity > (select avg(totalQuantity) from cte);


-- Q5

-- Select every disease that has 'p' in its name, and 
-- the number of times an insurance claim was made for each of them. 

EXPLAIN FORMAT=TREE SELECT Disease.diseaseName, COUNT(*) as numClaims
FROM Disease
JOIN Treatment ON Disease.diseaseID = Treatment.diseaseID
JOIN Claim On Treatment.claimID = Claim.claimID
WHERE diseaseName IN (SELECT diseaseName from Disease where diseaseName LIKE '%p%')
GROUP BY diseaseName;





