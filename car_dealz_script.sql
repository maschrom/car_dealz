-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema car_dealz_schema
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `car_dealz_schema` ;

-- -----------------------------------------------------
-- Schema car_dealz_schema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `car_dealz_schema` DEFAULT CHARACTER SET utf8 ;
USE `car_dealz_schema` ;

-- -----------------------------------------------------
-- Table `car_dealz_schema`.`cars`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `car_dealz_schema`.`cars` ;

CREATE TABLE IF NOT EXISTS `car_dealz_schema`.`cars` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `price` INT NULL,
  `model` VARCHAR(45) NULL,
  `make` VARCHAR(45) NULL,
  `year` VARCHAR(45) NULL,
  `description` MEDIUMTEXT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`, `user_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `car_dealz_schema`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `car_dealz_schema`.`users` ;

CREATE TABLE IF NOT EXISTS `car_dealz_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(255) NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `car_dealz_schema`.`purchases`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `car_dealz_schema`.`purchases` ;

CREATE TABLE IF NOT EXISTS `car_dealz_schema`.`purchases` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `car_id` INT NOT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`, `user_id`, `car_id`),
  INDEX `fk_users_has_cars_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_users_has_cars_cars1_idx` (`car_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_cars_cars1`
    FOREIGN KEY (`car_id`)
    REFERENCES `car_dealz_schema`.`cars` (`id`),
  CONSTRAINT `fk_users_has_cars_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `car_dealz_schema`.`users` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
