CREATE TABLE IF NOT EXISTS `gangs` (
  `gang_id` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(30) DEFAULT NULL,
  `gang_owner` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`gang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `gang_members` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` text NOT NULL,
  `gang_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;