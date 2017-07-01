MySQL = {}

MySQL.playerTable = "CREATE TABLE IF NOT EXISTS `player` ( `uid` BIGINT(20) NOT NULL AUTO_INCREMENT, `username` VARCHAR(255), `password` VARCHAR(255) NOT NULL, `skinID` INT, `position` LONGTEXT, `rotation` LONGTEXT, PRIMARY KEY (`uid`) ) COLLATE='utf8_general_ci';"
