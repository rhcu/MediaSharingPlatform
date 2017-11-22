USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_getLikeStatus`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getLikeStatus`(
    IN _item_id int,
    IN _user_id int
)
BEGIN
    select CAST(getSum(_item_id) as unsigned) ,hasLiked(_item_id, _user_id);
END$$
DELIMITER ;