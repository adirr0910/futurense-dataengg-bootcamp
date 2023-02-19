-- Active: 1670398793949@@127.0.0.1@3308@healthcare

-- Q1


select a.city,count(distinct p.pharmacyID)/count(pr.prescriptionID) as ratio
from address a 
left join pharmacy p using(`addressID`)
inner join prescription pr using(`pharmacyID`)
group by a.city
having count(pr.`prescriptionID`)>100
order by ratio limit 3;


--Q2


select city,diseaseName,treat_cnt from(
select city,diseaseName,treat_cnt, max(treat_cnt) over(partition by city order by treat_cnt desc) as maxi from(
    select a.city,d.diseaseName,count(t.`treatmentID`) as treat_cnt from address a inner join person p using(`addressID`)
    inner join patient pa on p.`personID`=pa.`patientID`
    inner join treatment t using(`patientID`)
    inner join disease d using(`diseaseID`)
    where a.state='AL'
    group by a.city,d.diseaseName
order by treat_cnt desc)a)b where treat_cnt=maxi order by treat_cnt desc;


--Q3
select distinct uin,count(uin) from claim  group by uin;

select count(distinct diseaseID) from treatment;

with claim_counts as (
    select c.uin,count(diseaseName) as claim_count,diseaseName 
    from claim c inner join treatment t using(`claimID`)
    inner join disease using(`diseaseID`) 
    group by uin,diseaseName
),
min_claims as (
    select diseaseName,min(claim_count) as min_claim
    from claim_counts
    group by `diseaseName`
),
max_claims as (
    select diseaseName,max(claim_count) as max_claim
    from claim_counts
    group by `diseaseName`
)
select cc.diseaseName,uin,
       mc.max_claim,
       case 
        when cc.claim_count = mc.max_claim then 'Max Claimed'
        else 'Least Claimed'
        end as claim_status
from claim_counts cc 
join max_claims mc on cc.diseaseName=mc.`diseaseName`
join min_claims mn ON cc.diseaseName = mn.`diseaseName`
where cc.claim_count = mc.max_claim OR cc.claim_count = mn.min_claim;

--Q4

-- refer
WITH patient_counts AS (
  SELECT 
    address, 
    disease, 
    COUNT(*) AS num_of_patients
  FROM 
    patient_records
  GROUP BY 
    address, 
    disease
)
SELECT 
  disease, 
  COUNT(*) AS num_of_households
FROM 
  patient_counts
WHERE 
  num_of_patients > 1
GROUP BY 
  disease;




--Q5

select a.state,count(t.`treatmentID`)/count(t.claimID) as ratio
from address a
join person p using(`addressID`)
join treatment t on p.`personID`=t.`patientID`
where t.date between '2021-04-01' and '2022-03-31'
group by a.state;

