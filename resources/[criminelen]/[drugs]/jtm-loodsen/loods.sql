CREATE TABLE `loodsen` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(50),
    `location` VARCHAR(255),
    `inhabitants` TEXT,
    PRIMARY KEY (`id`)
);

CREATE TABLE `loods_employees` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `employee` VARCHAR(50),
    `loods_id` INT,
    `key` BOOLEAN DEFAULT 0,
    PRIMARY KEY (`id`)
);

CREATE TABLE `paddo_progress` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `employee` VARCHAR(50),
    `paddos_plukt` INT DEFAULT 0,
    `paddos_gewassen` INT DEFAULT 0,
    PRIMARY KEY (`id`)
);
