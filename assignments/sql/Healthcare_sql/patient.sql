-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient(
   patientID INTEGER  PRIMARY KEY 
  ,ssn       INTEGER 
  ,dob       DATE 
);

select count(*) from patient;

ALTER TABLE Patient ADD CONSTRAINT FK_Person_Patient FOREIGN KEY (patientID) REFERENCES  Person(personID);



