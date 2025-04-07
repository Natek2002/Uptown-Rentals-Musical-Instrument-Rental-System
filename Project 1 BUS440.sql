-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema uptown
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `uptown` ;

-- -----------------------------------------------------
-- Schema uptown
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `uptown` DEFAULT CHARACTER SET utf8 ;
USE `uptown` ;

-- -----------------------------------------------------
-- Table `uptown`.`CUSTOMER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`CUSTOMER` ;

CREATE TABLE IF NOT EXISTS `uptown`.`CUSTOMER` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `CustomerName` VARCHAR(100) NOT NULL,
  `Age` INT NULL,
  `Address` VARCHAR(200) NULL,
  `ContactEmail` VARCHAR(100) NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uptown`.`RENTAL_TIER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`RENTAL_TIER` ;

CREATE TABLE IF NOT EXISTS `uptown`.`RENTAL_TIER` (
  `RentalTier` VARCHAR(20) NULL,
  `DailyOverdueFee` DECIMAL(6,2) NULL,
  PRIMARY KEY (`RentalTier`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uptown`.`INSTRUMENT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`INSTRUMENT` ;

CREATE TABLE IF NOT EXISTS `uptown`.`INSTRUMENT` (
  `SerialNumber` VARCHAR(20) NULL,
  `InstrumentType` VARCHAR(50) NULL,
  `RentalTier` VARCHAR(20) NULL,
  `InstrumentCondition` VARCHAR(100) NULL,
  `DailyRentalFee` DECIMAL(6,2) NULL,
  PRIMARY KEY (`SerialNumber`),
  INDEX `fk_instrument_tier_idx` (`RentalTier` ASC) VISIBLE,
  CONSTRAINT `fk_instrument_tier`
    FOREIGN KEY (`RentalTier`)
    REFERENCES `uptown`.`RENTAL_TIER` (`RentalTier`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uptown`.`STAFF`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`STAFF` ;

CREATE TABLE IF NOT EXISTS `uptown`.`STAFF` (
  `StaffID` INT NULL AUTO_INCREMENT,
  `StaffName` VARCHAR(100) NULL,
  `StaffEmail` VARCHAR(100) NULL,
  `StaffRole` VARCHAR(100) NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uptown`.`RENTAL`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`RENTAL` ;

CREATE TABLE IF NOT EXISTS `uptown`.`RENTAL` (
  `RentalID` INT NULL AUTO_INCREMENT,
  `CustomerID` INT NULL,
  `RentalDate` DATE NULL,
  `DueDate` DATE NULL,
  `ReturnDate` DATE NULL,
  `SerialNumber` VARCHAR(20) NULL,
  `StaffID` INT NULL,
  PRIMARY KEY (`RentalID`),
  INDEX `fk_rental_customer_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_rental_serial_idx` (`SerialNumber` ASC) VISIBLE,
  INDEX `fk_rental_staff_idx` (`StaffID` ASC) VISIBLE,
  CONSTRAINT `fk_rental_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `uptown`.`CUSTOMER` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rental_serial`
    FOREIGN KEY (`SerialNumber`)
    REFERENCES `uptown`.`INSTRUMENT` (`SerialNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rental_staff`
    FOREIGN KEY (`StaffID`)
    REFERENCES `uptown`.`STAFF` (`StaffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uptown`.`MAINTENANCE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`MAINTENANCE` ;

CREATE TABLE IF NOT EXISTS `uptown`.`MAINTENANCE` (
  `MaintenanceID` INT NULL AUTO_INCREMENT,
  `SerialNumber` VARCHAR(20) NULL,
  `MaintenanceDate` DATE NULL,
  `RepairIssue` VARCHAR(200) NULL,
  `RepairCost` DECIMAL(6,2) NULL,
  PRIMARY KEY (`MaintenanceID`),
  INDEX `fk_maintenance_serial_idx` (`SerialNumber` ASC) VISIBLE,
  CONSTRAINT `fk_maintenance_serial`
    FOREIGN KEY (`SerialNumber`)
    REFERENCES `uptown`.`INSTRUMENT` (`SerialNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uptown`.`RENTAL_HISTORY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`RENTAL_HISTORY` ;

CREATE TABLE IF NOT EXISTS `uptown`.`RENTAL_HISTORY` (
  `HistoryID` INT NULL AUTO_INCREMENT,
  `CustomerID` INT NULL,
  `SerialNumber` VARCHAR(20) NULL,
  `RentalDate` DATE NULL,
  `ReturnDate` DATE NULL,
  `LateFeePaid` DECIMAL(6,2) NULL,
  PRIMARY KEY (`HistoryID`),
  INDEX `fk_history_customer_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_history_serial_idx` (`SerialNumber` ASC) VISIBLE,
  CONSTRAINT `fk_history_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `uptown`.`CUSTOMER` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_history_serial`
    FOREIGN KEY (`SerialNumber`)
    REFERENCES `uptown`.`INSTRUMENT` (`SerialNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uptown`.`PHONE_NUMBER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `uptown`.`PHONE_NUMBER` ;

CREATE TABLE IF NOT EXISTS `uptown`.`PHONE_NUMBER` (
  `PhoneID` INT NULL AUTO_INCREMENT,
  `CustomerID` INT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `PhoneType` VARCHAR(20) NULL,
  PRIMARY KEY (`PhoneID`),
  INDEX `fk_phone_customer_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_phone_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `uptown`.`CUSTOMER` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
