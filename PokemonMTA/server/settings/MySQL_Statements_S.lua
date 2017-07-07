MySQL = {}

MySQL.accountTable = "accounts"

MySQL.createAccountTable = "CREATE TABLE IF NOT EXISTS `" .. MySQL.accountTable .. "` ( `account_id` BIGINT(20) NOT NULL AUTO_INCREMENT, `account_name` VARCHAR(255), `password` VARCHAR(255) NOT NULL, `skin_id` INT NOT NULL, `player_name` VARCHAR(255) NOT NULL, `position` LONGTEXT, `rotation` LONGTEXT, `player_title` VARCHAR(255) NOT NULL, `player_xp` INT NOT NULL, `player_level` INT NOT NULL, `money` INT NOT NULL, `pokemon_seen` INT NOT NULL, `pokemon_catched` INT NOT NULL, `pokemon_killed` INT NOT NULL, PRIMARY KEY (`account_id`) ) COLLATE=`utf8_general_ci`;"

MySQL.getAllAccountData = "SELECT * FROM " .. MySQL.accountTable
MySQL.getAccountData = "SELECT * FROM " .. MySQL.accountTable .. " WHERE account_name=?"
MySQL.saveAccountData = "INSERT INTO " .. MySQL.accountTable .. " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
MySQL.updateAccountData = "UPDATE " .. MySQL.accountTable .. " SET account_name=?, password=?, skin_id=?, player_name=?, position=?, rotation=?, player_title=?, player_xp=?, player_level=?, money=? ,pokemon_seen=?, pokemon_catched=?, pokemon_killed=? WHERE account_id=?"