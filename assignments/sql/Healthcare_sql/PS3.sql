-- Active: 1670398793949@@127.0.0.1@3308@healthcare

--Q1

with cte as
(select ph.pharmacyid,count(m.medicineid) as no_of_HEX_medicines,sum(c.quantity) as total_qty from 
pharmacy ph inner join prescription pr using(pharmacyid)
inner join treatment t on pr.treatmentid = t.treatmentid
inner join contain c on  pr.prescriptionid = c.prescriptionID
inner join medicine m on c.medicineid = m.medicineid
where m.hospitalExclusive = "S" and (year(t.date) in (2021,2022))
group by ph.pharmacyid
)
select phr.pharmacyname,cte.pharmacyID,cte.no_of_HEX_medicines,cte.total_qty
from pharmacy phr inner join cte using(pharmacyid)
order by cte.no_of_HEX_medicines DESC
limit 20;



--Q2

select 
    c.companyName,ip.planName,count(`treatmentID`) as num_of_treatments
from 
    insurancecompany c 
join 
    insuranceplan ip 
using(`companyID`)
JOIN
    claim cl 
using(uin)
join
    treatment t
using(`claimID`)
group by 
    ip.planName,c.companyID;



-- Q3

with comp_plan_claim as(
    select ic.companyName,ip.planName,count(c.claimID) as claim_count
    from insurancecompany ic inner join insuranceplan ip using(`companyID`)
    inner join claim c using(uin)
    group by ic.`companyName`,ip.`planName`
    order by ic.`companyName`,claim_count desc),
comp_plan_claim_max as(
    select companyName,planName,claim_count,max(claim_count) over(partition by companyName) as max_cl
    from comp_plan_claim
    group by companyName,planName
    ),
comp_plan_claim_min as(
    select companyName,planName,claim_count,min(claim_count) over(partition by companyName) as min_cl
    from comp_plan_claim
    group by companyName,planName
)
select distinct cc.companyName,cc.planName,
                case when cc.claim_count = mc.max_cl then 'Most Claimed'
                     end as status
from comp_plan_claim cc
join comp_plan_claim_max mc on cc.`companyName`=mc.`companyName`
where cc.claim_count = mc.max_cl
union
select distinct cc.companyName,cc.planName,
                case when cc.claim_count = mn.min_cl then 'Least Claimed'
                     end as status
from comp_plan_claim cc
join comp_plan_claim_min mn on cc.`companyName`=mn.`companyName`
where cc.claim_count = mn.min_cl;


--Q4

--refer

select
        a.state,count(pe.personID) as total_people,count(pa.patientID) 
        as total_patients,
        count(pe.personID)/count(pa.patientID) as ratio
    from
        address a left join person pe using(addressID)
        left join patient pa on pe.`personID`=pa.`patientID`
    group by a.state 
    order by ratio desc;



--Q5

select distinct taxCriteria from medicine;

select p.pharmacyName,sum(c.quantity) as total_quant
from 
      address a inner join pharmacy p using(addressID)
      inner join prescription pr using(`pharmacyID`)
      inner join contain c using(`prescriptionID`)
      inner join medicine m using(`medicineID`)
      inner join treatment t on pr.`treatmentID`=t.`treatmentID`
where m.taxCriteria='I' 
and t.date between '2021-01-31' and '2021-12-31'
and a.state='AZ'
group by p.`pharmacyName`;







