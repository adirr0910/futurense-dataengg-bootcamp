-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Treatment;
CREATE TABLE Treatment(
   treatmentID INTEGER  PRIMARY KEY 
  ,date        DATE 
  ,patientID   INTEGER 
  ,diseaseID   INTEGER 
  ,claimID     BIGINT 
);


select count(*) from treatment;

ALTER TABLE treatment ADD CONSTRAINT FK_Disease_Treat FOREIGN KEY (diseaseID) REFERENCES  disease(diseaseID);

ALTER TABLE treatment ADD CONSTRAINT FK_Claim_Treat FOREIGN KEY (claimID) REFERENCES  Claim(claimID);

ALTER TABLE treatment ADD CONSTRAINT FK_Patient_Treat FOREIGN KEY (patientID) REFERENCES  Patient(patientID);




