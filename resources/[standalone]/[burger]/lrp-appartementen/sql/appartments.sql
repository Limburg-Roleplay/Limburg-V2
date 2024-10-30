CREATE TABLE IF NOT EXISTS `appartments` (
  `owner` varchar(50) NOT NULL,
  `appartment` varchar(50) NOT NULL,
  `rent` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `outfits` (
  `owner` varchar(50) DEFAULT NULL,
  `outfitName` varchar(50) DEFAULT NULL,
  `outfitModel` varchar(50) DEFAULT NULL,
  `outfitProps` varchar(1000) DEFAULT NULL,
  `outfitComponents` varchar(1500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;