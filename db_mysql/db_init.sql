
-- DROP DATABASE `TreeManager`;

-- TreeManager Database
CREATE DATABASE IF NOT EXISTS `TreeManager` DEFAULT CHARACTER SET utf8;

-- CREATE USER 'tree_manager'@'localhost' IDENTIFIED BY 'qwerty123456QWERTY';
-- GRANT ALL PRIVILEGES ON TreeManager.* TO 'tree_manager'@'localhost';

USE `TreeManager`;

-- |Schema| --

DROP TABLE IF EXISTS Nodes;

-- Nodes Schema
CREATE TABLE IF NOT EXISTS Nodes
(
    node_id INT AUTO_INCREMENT,

    parent_node_id INT,
    FOREIGN KEY (parent_node_id)
        REFERENCES Nodes(node_id)
        ON DELETE CASCADE,
    
    path VARCHAR(256),

    depth INT,

    PRIMARY KEY(node_id)

) ENGINE=INNODB;

DELIMITER $$

DROP FUNCTION IF EXISTS `substr_count`$$

CREATE FUNCTION IF NOT EXISTS `substr_count` (_str TEXT, substr TEXT) RETURNS INTEGER DETERMINISTIC
BEGIN
    RETURN (CHAR_LENGTH(_str) - CHAR_LENGTH(REPLACE(_str, substr, SPACE(LENGTH(substr)-1)) ) );
END $$

DROP TRIGGER IF EXISTS `node_name`$$

CREATE TRIGGER `node_name` BEFORE INSERT ON Nodes
FOR EACH ROW BEGIN
    DECLARE future_node_id int;

    SELECT auto_increment INTO future_node_id
        FROM information_schema.tables
        WHERE table_name = 'Nodes'
            AND table_schema = 'TreeManager';

    SET NEW.path = CONCAT(
        IFNULL(
            (SELECT path FROM Nodes WHERE node_id = NEW.parent_node_id),
            'R'
        ),
        '.',
        future_node_id
    );

    SET NEW.depth = substr_count(NEW.path, '.');

END $$

DELIMITER ;
