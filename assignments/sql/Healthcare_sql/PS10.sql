-- Active: 1670398793949@@127.0.0.1@3308@healthcare


-- Q1

DROP PROCEDURE `stateReport`;
DELIMITER //

CREATE PROCEDURE stateReport(comId INT)
BEGIN
    WITH cte AS (
    SELECT `planName`, `diseaseName`,
    COUNT(`treatmentID`) noOfTreatments,
    DENSE_RANK() OVER (PARTITION BY `companyID` ORDER BY COUNT(`treatmentID`) DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 'dRank'
    FROM insurancecompany
    INNER JOIN insuranceplan USING(`companyID`)
    LEFT JOIN claim USING(UIN)
    LEFT JOIN treatment USING(`claimID`)
    INNER JOIN disease USING(`diseaseID`)
    WHERE `companyID`=comId
    GROUP BY `planName`, `diseaseName`
    ORDER BY noOfTreatments DESC
    )
    SELECT `planName`,`diseasename`, noOfTreatments FROM cte
    WHERE dRank=1;
END //

DELIMITER ;

CALL stateReport(1118);


-- Q2

DROP PROCEDURE `stateReport`;
DELIMITER //

CREATE PROCEDURE stateReport(disName VARCHAR(45))
BEGIN
    SELECT `pharmacyName`, COUNT(`treatmentID`) 'noOfTreatments'
    FROM pharmacy
    INNER JOIN prescription USING(`pharmacyID`)
    INNER JOIN contain USING(`prescriptionID`)
    INNER JOIN treatment USING(`treatmentID`)
    INNER JOIN disease USING(`diseaseID`)
    WHERE `diseaseName`=disName AND YEAR(date) IN (2021,2022)
    GROUP BY `pharmacyName`
    ORDER BY noOfTreatments DESC
    LIMIT 3;
END //

DELIMITER ;

CALL stateReport('Asthma');
CALL stateReport('Psoriasis');


-- Q3

DROP PROCEDURE `stateReport`;
DELIMITER //

CREATE PROCEDURE stateReport(stName VARCHAR(45))
BEGIN
    WITH cte AS (
        SELECT state, COUNT(`patientID`) num_patients, COUNT(DISTINCT`companyID`) num_insurance_companies, 
        COUNT(DISTINCT`patientID`)/ COUNT(`companyID`) insurance_patient_ratio
        FROM address
        INNER JOIN insurancecompany USING(`addressID`)
        INNER JOIN person USING(`addressID`)
        INNER JOIN patient ON person.`personID`=patient.`patientID`
        INNER JOIN treatment USING(`patientID`)
        WHERE state=stName
        GROUP BY state
    ), cte2 AS (SELECT AVG(insurance_patient_ratio) avg_insurance_patient_ratio FROM cte)
    SELECT state, num_patients, num_insurance_companies, insurance_patient_ratio,
    CASE WHEN insurance_patient_ratio < avg_insurance_patient_ratio 
        THEN 'Recommended'
        ELSE 'Not Recommeded'
    END AS 'Recommendation'
     FROM cte,cte2
;
END //

DELIMITER ;

CALL stateReport('FL');


-- Q4

CREATE TABLE IF NOT EXISTS placesAdded  ( 
    placeId BIGINT PRIMARY KEY AUTO_INCREMENT,
    placeName VARCHAR(65) NOT NULL,
    placeType ENUM('city','state'),
    timeAdded DATETIME );
    
ALTER TABLE placesAdded AUTO_INCREMENT=1;

DELIMITER // 
CREATE TRIGGER after_address_insert
AFTER INSERT 
ON address FOR EACH ROW BEGIN
IF (NEW.city NOT IN (SELECT placeName FROM placesAdded WHERE placeType='city')) THEN
    INSERT INTO placesAdded VALUES (NEW.addressId,NEW.city,'city',NOW());
ELSEIF (NEW.state NOT IN (SELECT placeName FROM placesAdded WHERE placeType='state')) THEN
    INSERT INTO placesAdded VALUES (NEW.addressId,NEW.state,'state',NOW());
ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='**No Record Inserted Into placesAdded Table**';
END IF;

END //

DELIMITER ;

INSERT INTO address VALUES(102,'102 Koramangala', 'Banglore','Karnataka',570095);

SELECT * FROM placesadded;

-- Q5

CREATE TABLE keep_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_id INT,
    quantity INT
    );

ALTER TABLE keep_log AUTO_INCREMENT=1;


DELIMITER // 
CREATE TRIGGER after_keep_insert
AFTER UPDATE 
ON keep FOR EACH ROW BEGIN

DECLARE v INT;
SET v= NEW.quantity - OLD.quantity;

UPDATE keep_log SET quantity= v WHERE medicineId=NEW.medicineId;

END //

DELIMITER ;



