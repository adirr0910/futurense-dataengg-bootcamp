-- Active: 1670398793949@@127.0.0.1@3308@healthcare


--Q1

select 
      pe.personName,count(t.treatmentID) as num_of_treatments,year(curdate())-year(p.dob) as age
from 
    treatment t 
    inner join
        patient p
        using(`patientID`) 
    inner join
        person pe
        on p.`patientID`=pe.`personID`
group by p.patientID order by num_of_treatments desc;



--Q2

select gender,diseaseName,total_count, ifnull(concat(total_count,":",l_val),'--') as 'ratio(M:F)'
from(
    select *,lag(total_count) over(partition by diseaseName) as l_val
    from (
        select pe.gender,d.diseaseName,
        count(pe.gender) as total_count
        from person pe inner join patient pa on pa.`patientID`=pe.`personID`
        inner join treatment t using(`patientID`)
        inner join disease d using(`diseaseID`)
        where year(t.date)='2021' 
        group by d.`diseaseName`,pe.gender
        order by d.`diseaseName`,pe.gender)a)b;

--Q3


select `diseaseName`,city,count from(
    select d.diseaseName,a.city,count(t.treatmentID) as count,
        row_number() over(partition by d.diseaseName order by count(t.treatmentID) desc) as rnk
        from disease d inner join treatment t using(`diseaseID`)
        inner join person pe on t.`patientID`=pe.`personID`
        inner join address a using(`addressID`)
        group by d.`diseaseName`,a.city) as t
where rnk<=3;

--Q4

select p.pharmacyName,d.diseaseName,
       sum(case when year(t.date)=2021 then 1 else 0 end) AS prescriptions_2021,
       sum(case when year(t.date)=2022 then 1 else 0 end) AS prescriptions_2022
from pharmacy p inner join prescription pr using(`pharmacyID`)
    inner join treatment t inner join disease d using(`diseaseID`)
where year(t.date) in (2021,2022)
group by p.`pharmacyName`,d.`diseaseName`
order by p.`pharmacyName`;


--Q5



select companyname,state,total_claims from(
    select companyName,state,total_claims,max(total_claims) over(partition by state) as M
    from(
        select ic.companyName,a.state,count(t.`claimID`) as total_claims
        from address a inner join insurancecompany ic using(`addressID`)
        inner join insuranceplan ip using(`companyID`)
        inner join claim c using(uin)
        inner join treatment t using(claimId)
        group by ic.`companyName`,a.state
        order by a.state,total_claims desc)a)b
where total_claims=M;








