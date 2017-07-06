MySQL = {}

MySQL.playerTable = "player"

MySQL.createPlayerTable = "CREATE TABLE IF NOT EXISTS `" .. MySQL.playerTable .. "` ( `uid` BIGINT(20) NOT NULL AUTO_INCREMENT, `username` VARCHAR(255), `password` VARCHAR(255) NOT NULL, `skinID` INT, `name` VARCHAR(255), `position` LONGTEXT, `rotation` LONGTEXT, PRIMARY KEY (`uid`) ) COLLATE=`utf8_general_ci`;"

MySQL.getAllPlayerData = "SELECT * FROM " .. MySQL.playerTable
MySQL.getPlayerData = "SELECT * FROM " .. MySQL.playerTable .. " WHERE name=?"
MySQL.savePlayerData = "INSERT INTO " .. MySQL.playerTable .. " VALUES (?,?,?,?,?,?,?)" -- id, username, password, skin, name, position, rotation