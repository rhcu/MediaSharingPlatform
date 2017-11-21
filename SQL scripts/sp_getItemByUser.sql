USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_GetItemByUser`;
 
DELIMITER $$
USE `media_sharing_platform`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetItemByUser`(
IN _user_id bigint,
IN _limit int,
IN _offset int,
out _total bigint
)
BEGIN
	
    select count(*) into _total from tbl_item where item_user_id = _user_id;
 
    SET @t1 = CONCAT( 'select * from tbl_item where item_user_id = ', _user_id, ' order by item_date desc limit ', _limit,' offset ', _offset);
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
END$$
 
DELIMITER ;