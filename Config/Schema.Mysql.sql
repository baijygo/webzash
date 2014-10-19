CREATE TABLE `%_PREFIX_%groups` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`parent_id` int(11) DEFAULT '0',
	`name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`affects_gross` int(1) NOT NULL DEFAULT '0',
        PRIMARY KEY(`id`),
	UNIQUE KEY `unique_id` (`id`),
	UNIQUE KEY `name` (`name`),
	KEY `id` (`id`),
	KEY `parent_id` (`parent_id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_unicode_ci,
AUTO_INCREMENT=1,
ENGINE=InnoDB;

CREATE TABLE `%_PREFIX_%ledgers` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`group_id` int(11) NOT NULL,
	`name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`op_balance` float(25,2) NOT NULL DEFAULT '0.00',
	`op_balance_dc` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`type` int(2) NOT NULL DEFAULT '0',
	`reconciliation` int(1) NOT NULL DEFAULT '0',
	PRIMARY KEY(`id`),
	UNIQUE KEY `unique_id` (`id`),
	UNIQUE KEY `name` (`name`),
	KEY `id` (`id`),
	KEY `group_id` (`group_id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_unicode_ci,
AUTO_INCREMENT=1,
ENGINE=InnoDB;

-- DROP TRIGGER IF EXISTS `bfins_%_PREFIX_%ledgers`;
-- DELIMITER //
-- CREATE TRIGGER `bfins_%_PREFIX_%ledgers` BEFORE INSERT ON `%_PREFIX_%ledgers`
-- FOR EACH ROW BEGIN
-- 	SET NEW.op_balance_dc = UPPER(NEW.op_balance_dc);
-- 	IF !(NEW.op_balance_dc <=> 'D' OR NEW.op_balance_dc <=> 'C') THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'op_balance_dc restricted to char D or C.';
-- 	END IF;
-- 	IF (NEW.op_balance < 0.0) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'op_balance cannot be less than 0.00.';
-- 	END IF;
-- END
-- //
-- DELIMITER ;

-- DROP TRIGGER IF EXISTS `bfup_%_PREFIX_%ledgers`;
-- DELIMITER //
-- CREATE TRIGGER `bfup_%_PREFIX_%ledgers` BEFORE UPDATE ON `%_PREFIX_%ledgers`
-- FOR EACH ROW BEGIN
-- 	IF (NEW.op_balance_dc IS NOT NULL) THEN
-- 		SET NEW.op_balance_dc = UPPER(NEW.op_balance_dc);
-- 		IF !(NEW.op_balance_dc <=> 'D' OR NEW.op_balance_dc <=> 'C') THEN
-- 			SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'op_balance_dc restricted to char D or C.';
-- 		END IF;
-- 	END IF;
-- 	IF (NEW.op_balance IS NOT NULL) THEN
-- 		IF (NEW.op_balance < 0.0) THEN
-- 			SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'op_balance cannot be less than 0.00.';
--	 	END IF;
-- 	END IF;
-- END
-- //
-- DELIMITER ;

CREATE TABLE `%_PREFIX_%tags` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`color` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`background` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	PRIMARY KEY(`id`),
	UNIQUE KEY `unique_id` (`id`),
	UNIQUE KEY `title` (`title`),
	KEY `id` (`id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_unicode_ci,
AUTO_INCREMENT=1,
ENGINE=InnoDB;

CREATE TABLE `%_PREFIX_%entrytypes` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`label` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`base_type` int(2) NOT NULL DEFAULT '0',
	`numbering` int(2) NOT NULL DEFAULT '1',
	`prefix` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`suffix` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`zero_padding` int(2) NOT NULL DEFAULT '0',
	`restriction_bankcash` int(2) NOT NULL DEFAULT '1',
        PRIMARY KEY(`id`),
	UNIQUE KEY `unique_id` (`id`),
	UNIQUE KEY `label` (`label`),
	KEY `id` (`id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_unicode_ci,
AUTO_INCREMENT=1,
ENGINE=InnoDB;

CREATE TABLE `%_PREFIX_%entries` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`tag_id` int(11) DEFAULT NULL,
	`entrytype_id` int(11) NOT NULL,
	`number` int(11) DEFAULT NULL,
	`date` date NOT NULL,
	`dr_total` float(25,2) NOT NULL DEFAULT '0.00',
	`cr_total` float(25,2) NOT NULL DEFAULT '0.00',
	`narration` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
        PRIMARY KEY (`id`),
	UNIQUE KEY `unique_id` (`id`),
	KEY `id` (`id`),
	KEY `tag_id` (`tag_id`),
	KEY `entrytype_id` (`entrytype_id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_unicode_ci,
AUTO_INCREMENT=1,
ENGINE=InnoDB;

-- DROP TRIGGER IF EXISTS `bfins_%_PREFIX_%entries`;
-- DELIMITER //
-- CREATE TRIGGER `bfins_%_PREFIX_%entries` BEFORE INSERT ON `%_PREFIX_%entries`
-- FOR EACH ROW BEGIN
-- 	IF (NEW.dr_total < 0.0) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'dr_total cannot be less than 0.00.';
-- 	END IF;
-- 	IF (NEW.cr_total < 0.0) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'cr_total cannot be less than 0.00.';
-- 	END IF;
-- 	IF !(NEW.dr_total <=> NEW.cr_total) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'dr_total is not equal to cr_total.';
-- 	END IF;
--
-- 	SELECT fy_start, fy_end FROM `settings` WHERE id = 1 INTO @fy_start, @fy_end;
-- 	IF (NEW.date < @fy_start) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'date before fy_start.';
-- 	END IF;
-- 	IF (NEW.date > @fy_end) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'date after fy_end.';
-- 	END IF;
-- END
-- //
-- DELIMITER ;

-- DROP TRIGGER IF EXISTS `bfup_%_PREFIX_%entries`;
-- DELIMITER //
-- CREATE TRIGGER `bfup_%_PREFIX_%entries` BEFORE UPDATE ON `%_PREFIX_%entries`
-- FOR EACH ROW BEGIN
-- 	DECLARE dr_total float(25,2);
-- 	DECLARE cr_total float(25,2);
--
-- 	IF (NEW.dr_total IS NOT NULL) THEN
-- 		SET dr_total = NEW.dr_total;
-- 	ELSE
-- 		SET dr_total = OLD.dr_total;
-- 	END IF;
-- 	IF (NEW.cr_total IS NOT NULL) THEN
-- 		SET cr_total = NEW.cr_total;
-- 	ELSE
-- 		SET cr_total = OLD.cr_total;
-- 	END IF;
--
-- 	IF (dr_total < 0.0) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'dr_total cannot be less than 0.00.';
-- 	END IF;
-- 	IF (cr_total < 0.0) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'cr_total cannot be less than 0.00.';
-- 	END IF;
-- 	IF !(dr_total <=> cr_total) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'dr_total is not equal to cr_total.';
-- 	END IF;
--
-- 	IF (NEW.date IS NOT NULL) THEN
-- 		SELECT fy_start, fy_end FROM `settings` WHERE id = 1 INTO @fy_start, @fy_end;
-- 		IF (NEW.date < @fy_start) THEN
-- 			SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'date before fy_start.';
-- 		END IF;
-- 		IF (NEW.date > @fy_end) THEN
-- 			SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'date after fy_end.';
-- 		END IF;
-- 	END IF;
-- END
-- //
-- DELIMITER ;

CREATE TABLE `%_PREFIX_%entryitems` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`entry_id` int(11) NOT NULL,
	`ledger_id` int(11) NOT NULL,
	`amount` float(25,2) NOT NULL DEFAULT '0.00',
	`dc` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`reconciliation_date` date DEFAULT NULL,
        PRIMARY KEY (`id`),
	UNIQUE KEY `unique_id` (`id`),
	KEY `id` (`id`),
	KEY `entry_id` (`entry_id`),
	KEY `ledger_id` (`ledger_id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_unicode_ci,
AUTO_INCREMENT=1,
ENGINE=InnoDB;

-- DROP TRIGGER IF EXISTS `bfins_%_PREFIX_%entryitems`;
-- DELIMITER //
-- CREATE TRIGGER `bfins_%_PREFIX_%entryitems` BEFORE INSERT ON `%_PREFIX_%entryitems`
-- FOR EACH ROW BEGIN
-- 	SET NEW.dc = UPPER(NEW.dc);
-- 	IF !(NEW.dc <=> 'D' OR NEW.dc <=> 'C') THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'dc restricted to char D or C.';
-- 	END IF;
-- 	IF (NEW.amount < 0.0) THEN
-- 		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'amount cannot be less than 0.00.';
-- 	END IF;
-- END
-- //
-- DELIMITER ;

-- DROP TRIGGER IF EXISTS `bfup_%_PREFIX_%entryitems`;
-- DELIMITER //
-- CREATE TRIGGER `bfup_%_PREFIX_%entryitems` BEFORE UPDATE ON `%_PREFIX_%entryitems`
-- FOR EACH ROW BEGIN
-- 	IF (NEW.dc IS NOT NULL) THEN
-- 		SET NEW.dc = UPPER(NEW.dc);
-- 		IF !(NEW.dc <=> 'D' OR NEW.dc <=> 'C') THEN
-- 			SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'dc restricted to char D or C.';
-- 		END IF;
-- 	END IF;
--	IF (NEW.amount IS NOT NULL) THEN
-- 		IF (NEW.amount < 0.0) THEN
-- 			SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'amount cannot be less than 0.00.';
-- 		END IF;
-- 	END IF;
-- END
-- //
-- DELIMITER ;

CREATE TABLE `%_PREFIX_%settings` (
	`id` int(1) NOT NULL,
	`name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`address` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`fy_start` date NOT NULL,
	`fy_end` date NOT NULL,
	`currency_symbol` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`date_format` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`timezone` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`manage_inventory` int(1) NOT NULL DEFAULT '0' ,
	`account_locked` int(1) NOT NULL DEFAULT '0',
	`email_use_default` int(1) NOT NULL DEFAULT '0',
	`email_protocol` varchar(9) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`email_host` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`email_port` int(5) NOT NULL,
	`email_tls` int(1) NOT NULL DEFAULT '0',
	`email_username` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`email_password` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`email_from` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`print_paper_height` float NOT NULL DEFAULT '0.0',
	`print_paper_width` float NOT NULL DEFAULT '0.0',
	`print_margin_top` float NOT NULL DEFAULT '0.0',
	`print_margin_bottom` float NOT NULL DEFAULT '0.0',
	`print_margin_left` float NOT NULL DEFAULT '0.0',
	`print_margin_right` float NOT NULL DEFAULT '0.0',
	`print_orientation` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`print_page_format` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`database_version` int(10) NOT NULL,
        PRIMARY KEY(`id`),
	UNIQUE KEY `unique_id` (`id`),
	KEY `id` (`id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_unicode_ci,
ENGINE=InnoDB;

-- DROP TRIGGER IF EXISTS `bfins_%_PREFIX_%settings`;
-- DELIMITER //
-- CREATE TRIGGER `bfins_%_PREFIX_%settings` BEFORE INSERT ON `%_PREFIX_%settings`
-- FOR EACH ROW BEGIN
-- 	SET NEW.id = 1;
--
-- 	IF EXISTS (SELECT id FROM `entries` WHERE date < NEW.fy_start) THEN
--  		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'entries present before fy_start.';
-- 	END IF;
--
--  	IF EXISTS (SELECT id FROM `entries` WHERE date > NEW.fy_end) THEN
--  		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'entries present after fy_end.';
--  	END IF;
--
--  	IF (NEW.fy_start >= NEW.fy_end) THEN
--  		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'fy_start cannot be after fy_end.';
--  	END IF;
-- END
-- //
-- DELIMITER ;

-- DROP TRIGGER IF EXISTS `bfup_%_PREFIX_%settings`;
-- DELIMITER //
-- CREATE TRIGGER `bfup_%_PREFIX_%settings` BEFORE UPDATE ON `%_PREFIX_%settings`
-- FOR EACH ROW BEGIN
--  	DECLARE fy_start date;
--  	DECLARE fy_end date;
--
--  	SET NEW.id = 1;
--
--  	IF (NEW.fy_start IS NULL) THEN
--  		SET fy_start = OLD.fy_start;
--  	ELSE
--  		SET fy_start = NEW.fy_start;
--  	END IF;
--
--  	IF (NEW.fy_end IS NULL) THEN
--  		SET fy_end = OLD.fy_end;
--  	ELSE
--  		SET fy_end = NEW.fy_end;
--  	END IF;
--
--  	IF EXISTS (SELECT id FROM `entries` WHERE date < fy_start) THEN
--  		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'entries present before fy_start.';
--  	END IF;
--
--  	IF EXISTS (SELECT id FROM `entries` WHERE date > fy_end) THEN
--  		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'entries present after fy_end.';
--  	END IF;
--
--  	IF (fy_start >= fy_end) THEN
--  		SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'fy_start cannot be after fy_end.';
--  	END IF;
-- END
-- //
-- DELIMITER ;

CREATE TABLE `%_PREFIX_%logs` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`date` datetime NOT NULL,
	`level` int(1) NOT NULL,
	`host_ip` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`user` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`user_agent` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
	`message` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
        PRIMARY KEY (`id`),
	UNIQUE KEY `unique_id` (`id`),
	KEY `id` (`id`)
) DEFAULT CHARSET=utf8,
COLLATE=utf8_general_ci,
AUTO_INCREMENT=1,
ENGINE=InnoDB;

ALTER TABLE `%_PREFIX_%groups`
	ADD CONSTRAINT `groups_fk_check_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `groups` (`id`);

ALTER TABLE `%_PREFIX_%ledgers`
	ADD CONSTRAINT `ledgers_fk_check_group_id` FOREIGN KEY (`group_id`) REFERENCES `%_PREFIX_%groups` (`id`);

ALTER TABLE `%_PREFIX_%entries`
	ADD CONSTRAINT `entries_fk_check_entrytype_id` FOREIGN KEY (`entrytype_id`) REFERENCES `%_PREFIX_%entrytypes` (`id`),
	ADD CONSTRAINT `entries_fk_check_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `%_PREFIX_%tags` (`id`);

ALTER TABLE `%_PREFIX_%entryitems`
	ADD CONSTRAINT `entryitems_fk_check_ledger_id` FOREIGN KEY (`ledger_id`) REFERENCES `%_PREFIX_%ledgers` (`id`),
	ADD CONSTRAINT `entryitems_fk_check_entry_id` FOREIGN KEY (`entry_id`) REFERENCES `%_PREFIX_%entries` (`id`);
