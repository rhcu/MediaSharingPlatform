DELIMITER $$
DROP PROCEDURE IF EXISTS `media_sharing_platform`.`sp_createUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `media_sharing_platform`.`sp_createUser`(
    IN _email VARCHAR(45),
    IN _username VARCHAR(45),
    IN _hashed_password VARCHAR(1000)
)
BEGIN
    if ( select exists (select * from media_sharing_platform.user u where u.Username = _username COLLATE utf8_unicode_ci) ) THEN
     
        select 'Username Exists !!';
     
    ELSE
     
        insert into media_sharing_platform.user
        (
			Email,
            Username,
            userPassword
        )
        values
        (
			_email,
            _username,
            _hashed_password
        );
     
    END IF;
END$$
DELIMITER ;