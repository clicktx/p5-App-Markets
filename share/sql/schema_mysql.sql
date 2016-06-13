-- -----------------------------------------------------
-- Schema markets
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `markets` DEFAULT CHARACTER SET utf8mb4 ;
USE `markets` ;

-- -----------------------------------------------------
-- Table `markets`.`sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `markets`.`sessions` (
  `sid` VARCHAR(40) NOT NULL COMMENT '',
  `data` LONGTEXT NULL COMMENT '',
  `expires` INT UNSIGNED NOT NULL COMMENT '',
  PRIMARY KEY (`sid`)  COMMENT '')
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `markets`.`preferences`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `markets`.`preferences` (
  `name` VARCHAR(50) NOT NULL COMMENT '',
  `default_value` TEXT NULL COMMENT '',
  `value` TEXT NULL COMMENT '',
  `summary` TEXT NULL COMMENT '',
  `category` INT NULL COMMENT '',
  `position` INT NULL COMMENT '',
  PRIMARY KEY (`name`)  COMMENT '')
ENGINE = InnoDB;
