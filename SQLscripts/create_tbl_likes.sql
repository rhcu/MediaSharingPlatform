CREATE TABLE `media_sharing_platform`.`tbl_likes` (
  `item_id` INT NOT NULL,
  `like_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL,
  `item_like` INT NULL DEFAULT 0,
  PRIMARY KEY (`like_id`));