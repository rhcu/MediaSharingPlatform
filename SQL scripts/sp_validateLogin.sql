DELIMITER $$
DROP PROCEDURE IF EXISTS `media_sharing_platform`.`sp_validateLogin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `media_sharing_platform`.`sp_validateLogin`(
IN _email VARCHAR(45)
)
BEGIN
    select * from media_sharing_platform.user u where u.Email = _email COLLATE utf8_unicode_ci;
END$$
DELIMITER ;