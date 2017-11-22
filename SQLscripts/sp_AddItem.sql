USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_addItem`;
 
DELIMITER $$
USE `media_sharing_platform`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addItem`(
    IN _title varchar(45),
    IN _description varchar(1000),
    IN _user_id bigint,
    IN _file_path varchar(200),
    IN _is_private int,
    IN _is_favorite int
)
BEGIN
    insert into tbl_item(
        item_title,
		item_description,
        item_user_id,
        item_date,
        item_file_path,
        item_private,
		item_favorite
    )
    values
    (
        _title,
        _description,
        _user_id,
        NOW(),
        _file_path,
        _is_private,
        _is_favorite
    );
    SET @last_id = LAST_INSERT_ID();
    insert into tbl_likes(
        item_id,
        user_id,
        item_like
    )
    values(
        @last_id,
        _user_id,
        0
    );
     
END$$
 
DELIMITER ;
