-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Prescription;
CREATE TABLE Prescription(
   prescriptionID BIGINT  PRIMARY KEY 
  ,pharmacyID     INTEGER 
  ,treatmentID    INTEGER 
);


ALTER TABLE Prescription ADD CONSTRAINT FK_PHARMA_Presc FOREIGN KEY (pharmacyID) REFERENCES  Pharmacy(pharmacyID);

ALTER TABLE Prescription ADD CONSTRAINT FK_Treatment_Presc FOREIGN KEY (treatmentID) REFERENCES  Treatment(treatmentID);


select count(*) from prescription;

