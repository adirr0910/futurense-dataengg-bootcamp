-- Active: 1670398793949@@127.0.0.1@3308@healthcare


--Q1 
select distinct a.productName,a.category from (
    select productName,productType,taxCriteria,
        CASE
                when `productType`=1 then 'Generic'
                when `productType`=2 then 'Patent'
                when `productType`=3 then 'Refernce'
                when `productType`=4 then 'Similar'
                when `productType`=5 then 'New'
                when `productType`=6 then 'Specific'
                when `productType`=7 then 'Biological'
                when `productType`=8 then 'Dinamized'
                end as category
    from medicine)a
where a.category in ('Generic','Patent','Refernce') and a.taxCriteria='I'
or a.category in ('Similar','New','Specific') and a.taxCriteria='II';

select distinct productType from medicine order by `productType`;

--Q2

select distinct pharmacyName from pharmacy order by `pharmacyName`;

select pr.prescriptionID,sum(c.quantity) as total_quantity,
       case 
            when sum(c.quantity)<20 then "Low quantity"
            when sum(c.quantity) between 20 and 49 then "Med quantity"
            else "High quantity"
            end as Tag
from 
    pharmacy p 
        inner join 
            prescription pr using(`pharmacyID`)
        inner join
            contain c using(`prescriptionID`)
where p.`pharmacyName`='Ally Scripts' group by pr.`prescriptionID`;

--Q3

select * from pharmacy where pharmacyName='Spot Rx';

with high_low_products as (
    select m.productName,
        case 
                when k.quantity>7500 then "High Quantity"
                when k.quantity<1000 then "Low Quantity"
                end as Quantity_tag,
        case 
                when k.discount>=30 then "High Discount"
                when k.discount=0 then "None" 
                end as Discount_tag
    from pharmacy p inner join keep k using(pharmacyID)
        inner join medicine m using(`medicineID`)
    where p.`pharmacyName`='Spot Rx')
select productName,Quantity_tag,Discount_tag
from high_low_products
where Quantity_tag like 'Low%' and Discount_tag like 'High%'
union
select productName,Quantity_tag,Discount_tag
from high_low_products
where Quantity_tag like 'High%' and Discount_tag like 'Low%';


--Q4


-- WITH avg_price AS (
--   SELECT AVG(maxPrice) as avg_max_price
--   FROM medicine where hospitalExclusive='S'
-- ), 
-- affordable AS (
--   SELECT productName, maxPrice
--   FROM medicine
--   JOIN avg_price
--   ON maxPrice < avg_max_price / 2 where hospitalExclusive='S'
-- ), 
-- costly AS (
--   SELECT productName, maxPrice
--   FROM medicine
--   JOIN avg_price
--   ON maxPrice > 2 * avg_max_price where hospitalExclusive='S'
-- )
-- SELECT affordable.productName, 'Affordable' as type, affordable.maxPrice
-- FROM affordable
-- UNION ALL
-- SELECT costly.productName, 'Costly' as type, costly.maxPrice
-- FROM costly;


with cte as
(select productname as name , `maxPrice` as maxprice, (select round(avg(maxprice),2) from medicine) as avgMed
from medicine m
join keep using (`medicineID`)
join pharmacy p USING(`pharmacyID`)
where m.hospitalExclusive="S"
and 
p.`pharmacyName`="HealthDirect"
)
select name,category from 
(select name, maxprice, avgMed,
case
    when maxprice < 0.5 * avgMed then "Affordable"
    when maxprice > 2 * avgMed then "Costly"
    else null
    end as category
from cte 
)a 
where category is not null;


--Q5

select pe.personName,pe.gender,pa.dob,
case 
    when pa.dob>'2005-01-01' and pe.gender='male' then "YoungMale"
    when pa.dob>'2005-01-01' and pe.gender='female' then "YoungFemale"
    when pa.dob<'2005-01-01' and pa.dob>'1985-01-01' AND pe.gender='male' then "AdultMale"
    when pa.dob<'2005-01-01' and pa.dob>'1985-01-01' AND pe.gender='female' then "AdultFemale"
    when pa.dob<'1985-01-01' and pa.dob>'1970-01-01' AND pe.gender='male' then "MidAgeMale"
    when pa.dob<'1985-01-01' and pa.dob>'1970-01-01' AND pe.gender='female' then "MidAgeFemale"
    when pa.dob<'1970-01-01' AND pe.gender='male' then "ElderMale"
    when pa.dob<'1970-01-01' AND pe.gender='female' then "ElderFemale"
    end as Category
from person pe inner join patient pa 
on pe.personID=pa.`patientID`;




