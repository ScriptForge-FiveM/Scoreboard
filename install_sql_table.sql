CREATE TABLE IF NOT EXISTS `business_status` (
  `business` varchar(50) NOT NULL,
  `status` int(11) NOT NULL,
  `job` varchar(50) NOT NULL,
  `grade` int(11) NOT NULL,
  `image` varchar(250) NOT NULL,
  `description` longtext NOT NULL,
  `street` varchar(50) NOT NULL,
  `cap` varchar(50) NOT NULL,
  PRIMARY KEY (`business`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

INSERT INTO `business_status` (`business`, `status`, `job`, `grade`, `image`, `description`, `street`, `cap`) VALUES
	('Ammunation', 0, 'aummanation', 4, 'https://oyster.ignimgs.com/mediawiki/apis.ign.com/grand-theft-auto-5/f/f5/GTAV.PS4.1080P.521.jpg', 'Desert eagle back in stock!', 'Little Seoul', 'Postcode 600'),
	('Bahama Mama', 0, 'bahama', 4, 'https://img.gta5-mods.com/q75/images/open-bahama-mamas-doors/bb43ff-bahamamamaswest-gtav.jpg', 'Best drinks in the city!', 'Del perro', 'Postcode 833'),
	('Fleeca bank', 0, 'banker', 4, 'https://img.gta5-mods.com/q95/images/mlo-vespucci-fleeca-bank-alt-v-ragemp-add-on-sp/eef414-m4vbank-Night-2.png', 'Get your loan now!', 'Alta', 'Postcode 528'),
	('LS Customs', 0, 'mechanic', 4, 'https://img.gta5-mods.com/q75/images/nerdcubed-los-santos-customs/8d402a-2015-10-15_00020.jpg', 'Mechanic and car tuning.', 'Burton', 'Postcode 140'),
	('Motorsport', 0, 'cardealer', 4, 'https://staticg.sportskeeda.com/editor/2022/08/d6589-16611905505196-1920.jpg?w=640', 'Looking for a cheap car?', 'Pillbox hill', 'Postcode 650'),
	('Vanilla unicorn', 0, 'vanilla', 4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRL-32OHoxNvkKgg8vdJtaaL-afbg6Dssrtrw&s', 'Looking for a luxury car?', 'Strawberry avenue', 'Postcode 999');
