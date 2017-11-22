DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getSum`(
    _item_id int
) RETURNS int(11)
BEGIN
    select sum(item_like) into @sm from tbl_likes where item_id = _item_id;
RETURN @sm;
END$$
DELIMITER ;
     