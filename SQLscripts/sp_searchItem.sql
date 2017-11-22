USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_searchItem`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_searchItem`(
	IN _item varchar(45),
    IN _user_id int
)
BEGIN
	select item_id, item_title, item_description, item_file_path, Username,  
			CAST(getSum(item_id) as unsigned), hasLiked(item_id, _user_id), item_favorite, item_date
    from tbl_item join user on user_id = item_user_id
    where (item_description like CONCAT("%",CAST(_item as CHAR),"%") or
						item_title like CONCAT("%",CAST(_item as CHAR),"%"))
                        and item_private = 0;
END$$
DELIMITER ;
 