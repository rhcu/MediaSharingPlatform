ALTER TABLE `media_sharing_platform`.`tbl_item` 
ADD COLUMN `item_file_path` VARCHAR(200) NULL AFTER `item_date`,
ADD COLUMN `item_favorite` INT NULL DEFAULT 0 AFTER `item_file_path`,
ADD COLUMN `item_private` INT NULL DEFAULT 0 AFTER `item_favorite`; 