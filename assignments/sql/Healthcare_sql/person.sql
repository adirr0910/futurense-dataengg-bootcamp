-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Person;
CREATE TABLE Person(
   personID    INTEGER  PRIMARY KEY 
  ,personName  VARCHAR(22)
  ,phoneNumber BIGINT 
  ,gender      VARCHAR(6)
  ,addressID   INTEGER 
);

select count(*) from person;

ALTER TABLE Person ADD CONSTRAINT FK_Addr_Person FOREIGN KEY (addressID) REFERENCES  Address(addressID);
