-- Active: 1670398793949@@127.0.0.1@3308@healthcare

-- Q1
select category,sum(tot_treat) as total_treatments from(
select case 
    when timestampdiff(year,dob,curdate()) between 00 and 14 then 'Children'
    when timestampdiff(year,dob,curdate()) between 15 and 24 then 'Youth'
    when timestampdiff(year,dob,curdate()) between 25 and 64 then 'Adult'
    when timestampdiff(year,dob,curdate()) >= 65  then 'Seniors'
    end as category,
count(treatmentID) as tot_treat,patientID,timestampdiff(year,p.dob,curdate()) as age
from treatment inner join patient p using(`patientID`)
group by `patientID`)a
group by category;


--Q2

select diseaseName,concat(count,":",next_val) as `Ratio(F:M)` from(
select gender,diseaseName,count,lead(count) over(partition by `diseaseName` order by gender) as next_val from (
select pe.gender as gender,count(pe.gender) as count,d.`diseaseName` as diseaseName
    from 
    patient pa 
    join person pe on pe.personID=pa.`patientID` 
    join treatment t using(`patientID`)
    join disease d using(`diseaseID`)
    group by pe.gender,t.`diseaseID`)a
)b where next_val is not NULL;


--Q3


-- gives total female and male patient
select pe.gender,t.patientID,t.`treatmentID`,t.claimID
from person pe
inner join 
patient pa on pe.personID=pa.patientID
inner join treatment t using(`patientID`)
group by pe.gender,t.`treatmentID`,t.claimID;



-- patients as male and female
select gender,count(treat_count)as treatment_count from (
    select pe.gender,pa.patientID,count(treatmentID) as treat_count from person pe inner join 
    patient pa on pe.personID=pa.patientID
    inner join treatment t using(`patientID`)
    where patientID=104329
    group by pe.gender,t.`patientID`)
a group by gender;

select gender,sum(total_treat),sum(total_claim),concat(sum(total_treat),":",sum(total_claim))as ratio 
from(
    select gender,total_treat,total_claim 
    from(
        select gender,patientID,sum(treat_count) total_treat,sum(claim_count)as total_claim 
        from (
            select pe.gender,pa.patientID,count(treatmentID) as treat_count,count(t.claimID) as claim_count
            from 
                person pe inner join 
                patient pa on pe.personID=pa.patientID
                inner join treatment t using(`patientID`)
                group by pe.gender,t.`patientID`,t.claimID
              )a
    group by gender,patientID)
    b)
c group by gender; 


--Q4

-- pharmacy 213 distinct 
-- units of med with EACH
-- total max retail price 
-- total price after discount

with cte as (
    select pharmacyID,medicineID,quantity,maxPrice,discount,
    (maxPrice*quantity) as total_mrp,
    round(((maxPrice*quantity)-((maxPrice*quantity)*discount/100)),2) as total_discounted_price
    from keep inner join medicine using(`medicineID`))
select pharmacyID,sum(quantity) as total_quantity,sum(total_mrp) total_cost,sum(total_discounted_price) total_discount_cost
from cte group by pharmacyID;

--Q5

select * from prescription join contain using(`prescriptionID`)
where pharmacyID=5976 ;

select * from prescription where pharmacyID=5976 ;

select pharmacyID,prescriptionID,min(quantity),max(quantity),round(avg(quantity))
from prescription join contain using(`prescriptionID`)
group by prescriptionID,pharmacyID;


