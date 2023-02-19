-- Active: 1670398793949@@127.0.0.1@3308@healthcare

--Q1
DROP PROCEDURE `diseaseClaims`;
DELIMITER //

CREATE PROCEDURE diseaseClaims(IN disId INT)
BEGIN
    
    DECLARE avgClaim NUMERIC(12,2);
    DECLARE avgDisClaim NUMERIC(12,2);

    WITH cte1 AS (
        SELECT `diseaseName`,COUNT(claimId) n
        FROM claim
        INNER JOIN treatment USING(`claimID`)
        INNER JOIN disease USING(`diseaseID`)
        GROUP BY `diseaseName`
    )
    SELECT AVG(n) INTO avgClaim FROM cte1;

    SELECT COUNT(`claimID`) INTO avgDisClaim
    FROM claim
    INNER JOIN treatment USING(`claimID`)
    INNER JOIN disease USING(`diseaseID`)
    WHERE `diseaseID`=disId;

    IF (avgDisClaim > avgClaim) THEN
        SELECT disId AS 'disease Id',avgDisClaim,'Claimed Higher than Average' AS 'Claimed';
    ELSE
        SELECT disId AS 'disease Id',avgDisClaim,'Claimed Lower than Average' AS 'Claimed';
    END IF;
END //

DELIMITER;

CALL diseaseClaims(1);


--Q2

DROP PROCEDURE `genderWiseReport`;
DELIMITER //

CREATE PROCEDURE genderWiseReport(IN disId INT)
BEGIN
    DECLARE nMales INT;
    DECLARE nFemales INT;
    DECLARE dName VARCHAR(45);

    SELECT d.diseaseName, SUM(IF(p.gender = 'male',1,0)),
                SUM(if(p.gender = 'female',1,0)) INTO dName,nMales,nFemales
    FROM disease d 
    INNER JOIN treatment t on t.`diseaseID` = d.`diseaseID`
    INNER JOIN person p on p.`personID` = t.`patientID`
    WHERE d.`diseaseID`=disId
    GROUP BY diseaseName;

    SELECT dName,nMales,nFemales, IF(nMales>nFemales,'Male','Female') AS 'Gender';
END //

DELIMITER ;

CALL genderWiseReport(1);


--Q3

with cte as (
    select *, dense_rank() over(partition by `companyName` order by cnt desc) as rnk from(
    select ip.planName,ic.companyName,count(t.claimID) as cnt
    from insurancecompany ic inner join insuranceplan ip using(`companyID`)
    inner join claim c using(uin)
    inner join treatment t using(`claimID`)
    group by ip.planName,ic.companyName
    order by cnt desc)a)
select planName,`companyName`,cnt,
if(rnk<3,'Most Claimed','Least Claimed') as stat from cte;


--Q4


select `diseaseName`,category,cnt from (
select `diseaseName`,category,cnt,
max(cnt) over(partition by `diseaseName`) as most_affected from (
    select diseaseName,category,count(category) as cnt from (
        select pe.personName,pe.gender,pa.dob,d.`diseaseName`,
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
        on pe.personID=pa.`patientID`
        inner join treatment t using(`patientID`)
        inner join disease d using(`diseaseID`)
        order by category,`diseaseName`)a
    group by `diseaseName`,category)b)c
where cnt=most_affected;



--Q5 

-- medname,most exp most affordabke meds

select companyName,productName,description,maxPrice from medicine limit 9;

select companyName,productName,description,maxPrice,
case 
    when maxPrice>1000 then "Most Expensive"
    when maxPrice<5 then "Most Affordable"
end as Category
from medicine 
order by maxPrice desc;


