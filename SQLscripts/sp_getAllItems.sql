USE `media_sharing_platform`;
DROP procedure IF EXISTS `sp_GetAllItems`;
 
DELIMITER $$
USE `media_sharing_platform`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllItems`(
_user int)
BEGIN
    select i.item_id, i.item_title, i.item_description, i.item_file_path,
    CAST(sum(l.item_like) as UNSIGNED ) as likeSum, hasLiked(i.item_id,_user), i.item_favorite, u.Username, i.item_date
    from (tbl_item as i left outer join tbl_likes as l on i.item_id = l.item_id) join user as u on u.user_id = i.item_user_id
    where i.item_private = 0
    group by i.item_id;
END$$
 
DELIMITER ;
