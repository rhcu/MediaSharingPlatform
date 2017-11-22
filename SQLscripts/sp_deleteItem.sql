DELIMITER $$
		USE `media_sharing_platform` $$
		CREATE PROCEDURE `sp_deleteItem` (
		IN _item_id bigint,
		IN _user_id bigint
		)
		BEGIN
		delete from tbl_item where item_id = _item_id and _user_id = _user_id;
		END$$
DELIMITER ;