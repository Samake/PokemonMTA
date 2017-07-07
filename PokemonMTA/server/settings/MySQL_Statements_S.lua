MySQL = {}

MySQL.accountTable = "accounts"

MySQL.createAccountTable = "CREATE TABLE IF NOT EXISTS `" .. MySQL.accountTable .. "` ( `account_id` BIGINT(20) NOT NULL AUTO_INCREMENT, `account_name` VARCHAR(255), `password` VARCHAR(255) NOT NULL, `skin_id` INT, `player_name` VARCHAR(255), `position` LONGTEXT, `rotation` LONGTEXT, PRIMARY KEY (`account_id`) ) COLLATE=`utf8_general_ci`;"

MySQL.getAllAccountData = "SELECT * FROM " .. MySQL.accountTable
MySQL.getAccountData = "SELECT * FROM " .. MySQL.accountTable .. " WHERE account_name=?"
MySQL.saveAccountData = "INSERT INTO " .. MySQL.accountTable .. " VALUES (?,?,?,?,?,?,?)"
MySQL.updateAccountData = "UPDATE " .. MySQL.accountTable .. " SET account_name=?, password=?, skin_id=?, player_name=?, position=?, rotation=? WHERE account_id=?"