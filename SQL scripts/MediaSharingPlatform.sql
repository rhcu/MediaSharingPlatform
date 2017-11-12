-- MySQL Script generated by MySQL Workbench
-- Sat Oct 28 19:13:08 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Media_Sharing_Platform
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Media_Sharing_Platform` ;

-- -----------------------------------------------------
-- Schema Media_Sharing_Platform
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Media_Sharing_Platform` DEFAULT CHARACTER SET utf8 COLLATE utf8_hungarian_ci ;
USE `Media_Sharing_Platform` ;

-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`USER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`USER` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`USER` (
  `Email` VARCHAR(45) NOT NULL,
  `Username` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NULL,
  `FirstName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Email`, `Username`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`GROUP OF INTEREST`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`GROUP OF INTEREST` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`GROUP OF INTEREST` (
  `GroupID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Description` LONGTEXT NULL,
  `Number of Participants` INT NULL,
  `ADMIN_USER_Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`GroupID`),
  UNIQUE INDEX `GroupID_UNIQUE` (`GroupID` ASC),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC),
  CONSTRAINT `Administered_by`
    FOREIGN KEY (`ADMIN_USER_Email`)
    REFERENCES `Media_Sharing_Platform`.`USER` (`Email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`BOARD`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`BOARD` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`BOARD` (
  `Name` INT NOT NULL,
  `Number of Items` VARCHAR(45) NULL,
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC),
  PRIMARY KEY (`Name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`MEDIA CONTENT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`MEDIA CONTENT` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`MEDIA CONTENT` (
  `Item ID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Media_Content_Type` VARCHAR(45) NOT NULL COMMENT 'Discriminating attribute for Super-Subclass TOTAL DISJOINT specialization',
  `Date_posted` DATE NULL,
  `Upvotes` INT NULL,
  `Downvotes` INT NULL,
  `Description` LONGTEXT NULL,
  `Resolution` INT NOT NULL,
  `Image Format` VARCHAR(10) NOT NULL,
  `Title` VARCHAR(45) NOT NULL,
  `Author` VARCHAR(45) NULL,
  `Page number` VARCHAR(45) NULL,
  `USER_Username` VARCHAR(45) NOT NULL COMMENT 'Foreign Key to set \'OWNS\' relationship',
  UNIQUE INDEX `Item ID_UNIQUE` (`Item ID` ASC),
  PRIMARY KEY (`Item ID`),
  CONSTRAINT `fk_MEDIA CONTENT_USER1`
    FOREIGN KEY (`USER_Username`)
    REFERENCES `Media_Sharing_Platform`.`USER` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`CREATES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`CREATES` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`CREATES` (
  `BOARD_Name` INT NOT NULL,
  `USER_Username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`BOARD_Name`, `USER_Username`),
  CONSTRAINT `fk_BOARD_has_USER_BOARD1`
    FOREIGN KEY (`BOARD_Name`)
    REFERENCES `Media_Sharing_Platform`.`BOARD` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BOARD_has_USER_USER1`
    FOREIGN KEY (`USER_Username`)
    REFERENCES `Media_Sharing_Platform`.`USER` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`IS_JOINED_BY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`IS_JOINED_BY` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`IS_JOINED_BY` (
  `PUsername` VARCHAR(45) NOT NULL,
  `UGroupID` INT NOT NULL,
  PRIMARY KEY (`PUsername`, `UGroupID`),
  CONSTRAINT `fk_USER_has_GROUP OF INTEREST_USER1`
    FOREIGN KEY (`PUsername`)
    REFERENCES `Media_Sharing_Platform`.`USER` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_USER_has_GROUP OF INTEREST_GROUP OF INTEREST1`
    FOREIGN KEY (`UGroupID`)
    REFERENCES `Media_Sharing_Platform`.`GROUP OF INTEREST` (`GroupID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`REFERS_TO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`REFERS_TO` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`REFERS_TO` (
  `RGroupID` INT NOT NULL,
  `BName` INT NOT NULL,
  PRIMARY KEY (`RGroupID`, `BName`),
  CONSTRAINT `fk_BOARD_has_GROUP OF INTEREST_BOARD1`
    FOREIGN KEY (`BName`)
    REFERENCES `Media_Sharing_Platform`.`BOARD` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BOARD_has_GROUP OF INTEREST_GROUP OF INTEREST1`
    FOREIGN KEY (`RGroupID`)
    REFERENCES `Media_Sharing_Platform`.`GROUP OF INTEREST` (`GroupID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`CONTAINS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`CONTAINS` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`CONTAINS` (
  `BName` INT NOT NULL,
  `MItem ID` INT NOT NULL,
  PRIMARY KEY (`BName`, `MItem ID`),
  CONSTRAINT `fk_BOARD_has_MEDIA CONTENT_BOARD1`
    FOREIGN KEY (`BName`)
    REFERENCES `Media_Sharing_Platform`.`BOARD` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BOARD_has_MEDIA CONTENT_MEDIA CONTENT1`
    FOREIGN KEY (`MItem ID`)
    REFERENCES `Media_Sharing_Platform`.`MEDIA CONTENT` (`Item ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Media_Sharing_Platform`.`RATES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Media_Sharing_Platform`.`RATES` ;

CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`RATES` (
  `USER_Username` VARCHAR(45) NOT NULL,
  `MEDIA CONTENT_Item ID` INT NOT NULL,
  `Upvote_FLAG` TINYINT NOT NULL,
  `Downvote_FLAG` TINYINT NOT NULL,
  PRIMARY KEY (`USER_Username`, `MEDIA CONTENT_Item ID`),
  CONSTRAINT `fk_USER_has_MEDIA CONTENT_USER2`
    FOREIGN KEY (`USER_Username`)
    REFERENCES `Media_Sharing_Platform`.`USER` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_USER_has_MEDIA CONTENT_MEDIA CONTENT2`
    FOREIGN KEY (`MEDIA CONTENT_Item ID`)
    REFERENCES `Media_Sharing_Platform`.`MEDIA CONTENT` (`Item ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
