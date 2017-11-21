DROP TABLE IF EXISTS Media_Sharing_Platform.user;
CREATE TABLE IF NOT EXISTS `Media_Sharing_Platform`.`USER` (
  `user_id` BIGINT AUTO_INCREMENT, 
  `Email` VARCHAR(45) NOT NULL,
  `Username` VARCHAR(45) NOT NULL,
  `userPassword` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC))
ENGINE = InnoDB;
