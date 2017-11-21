USE `media_sharing_platform`;
DROP function IF EXISTS `hasLiked`;

DELIMITER $$

USE `media_sharing_platform`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `hasLiked`(
    _item int,
    _user int
) RETURNS int(11)
BEGIN
     
    select item_like into @myval from tbl_likes where item_id =  _item and user_id = _user;
RETURN @myval;
END$$
DELIMITER ;