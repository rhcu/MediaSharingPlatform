USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_updateItem`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateItem`(
	IN _title varchar(45),
	IN _description varchar(5000),
	IN _item_id int(11),
	IN _user_id int(11),
	IN _file_path varchar(200),
	IN _is_private int(11),
	IN _is_favorite int(11)
)
BEGIN
update tbl_item 
set item_title = _title, 
	item_description = _description,
    item_file_path = _file_path,
    item_private = _is_private,
    item_favorite = _is_favorite
    where item_id = _item_id and item_user_id = _user_id;
END$$
DELIMITER ;
 