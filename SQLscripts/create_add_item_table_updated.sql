CREATE TABLE `tbl_item` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_title` varchar(45) DEFAULT NULL,
  `item_description` varchar(5000) DEFAULT NULL,
  `item_user_id` int(11) DEFAULT NULL,
  `item_date` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;