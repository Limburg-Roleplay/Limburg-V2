CREATE TABLE IF NOT EXISTS `rxhousing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT 0,
  `shell` varchar(50) NOT NULL,
  `stashgrade` int(11) DEFAULT 1,
  `security_price` int(11) DEFAULT 2000,
  `security` tinyint(1) DEFAULT 0,
  `stashid` varchar(50) DEFAULT NULL,
  `coords` longtext DEFAULT NULL,
  `messages` longtext DEFAULT '[]',
  `keyholders` longtext DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;