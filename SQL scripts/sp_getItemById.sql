USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_GetItemById`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetItemById`(
IN _item_id bigint,
In _user_id bigint
)
BEGIN
	select item_id, item_title, item_description, item_file_path, item_private, item_favorite 
    from tbl_item where item_id = _item_id and item_user_id = _user_id;
END