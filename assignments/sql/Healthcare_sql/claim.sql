-- Active: 1670398793949@@127.0.0.1@3308@healthcare

DROP TABLE IF EXISTS Claim;
CREATE TABLE Claim(
   claimID BIGINT  NOT NULL PRIMARY KEY 
  ,balance BIGINT  NOT NULL
  ,uin     VARCHAR(22) NOT NULL
);

ALTER TABLE Claim ADD CONSTRAINT FK_InsPlan_Claim FOREIGN KEY (uin) REFERENCES  InsurancePlan(uin);

-- ALTER TABLE Claim DROP CONSTRAINT FK_InsPlan_Claim;

select count(*) from claim;

show create table claim;


