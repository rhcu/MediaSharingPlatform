USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_AddUpdateLikes`;
DELIMITER $$
 
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddUpdateLikes`(
	_item_id int,
    _user_id int,
    _like int
)
BEGIN
    if (select exists (select 1 from tbl_likes where item_id = _item_id and user_id = _user_id)) then
 
         
        select item_like into @currentVal from tbl_likes where item_id = _item_id and user_id = _user_id;
         
        if @currentVal = 0 then
            update tbl_likes set item_like = 1 where item_id = _item_id and user_id = _user_id;
        else
            update tbl_likes set item_like = 0 where item_id = _item_id and user_id = _user_id;
        end if;
         
    else
         
        insert into tbl_likes(
            item_id,
            user_id,
            item_like
        )
        values(
            _item_id,
            _user_id,
            _like
        );
 
    end if;
END


 


    