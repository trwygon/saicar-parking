CREATE DATABASE saicar;

USE saicar;

/* utilizador */
CREATE TABLE users (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(32) NOT NULL unique,
    password_hash VARCHAR(128) NOT NULL,
    perms TINYINT NOT NULL,
    PRIMARY KEY(id)
);

/* sensores e atuadores */
CREATE TABLE dispositivos (
    id TINYINT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(32) NOT NULL unique,
    valor VARCHAR(16) NOT NULL,
    hora VARCHAR(64) NOT NULL,
    PRIMARY KEY(id)
);

/* sensores e atuadores */
CREATE TABLE logs (
    id TINYINT NOT NULL AUTO_INCREMENT,
    id_disp TINYINT NOT NULL,
    valor VARCHAR(16) NOT NULL,
    hora VARCHAR(64) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_disp) REFERENCES dispositivos(id)
);



DELIMITER //

/*
Efetuar o login de um utilizador
Output:
	code:
		0 - login com sucesso
		1 - password incorreta
		2 - não existe esse utilizador
*/
CREATE PROCEDURE LoginUser(pUsername VARCHAR(32), pPassword VARCHAR(50), OUT code TINYINT)
BEGIN
    SET code=2;

    IF (SELECT COUNT(*) FROM users WHERE username=pUsername) = 1 THEN
        SET code=1;
        IF (SELECT password_hash FROM users WHERE username=pUsername) = SHA2(pPassword,512) THEN
            SET code=0;
        END IF;
    END IF;
END//

/*
Registar um utilizador
Output:
	code:
		0 - registo com sucesso
		1 - esse utilizador já existe
*/
CREATE PROCEDURE RegisterUser(pUsername VARCHAR(32), pPassword VARCHAR(50), pPerms TINYINT, OUT code TINYINT)
BEGIN
    SET code=1;
	IF (SELECT COUNT(*) FROM users WHERE username=pUsername) = 0 THEN
		INSERT INTO users (username, password_hash, perms)
			VALUES(pUsername, SHA2(pPassword,512), pPerms);
        SET code=0;
    END IF;
	
END//



DELIMITER ;

CALL RegisterUser("goncalo", "paulino123", 3, @code);
CALL RegisterUser("rafael", "tavares321", 3, @code);
CALL RegisterUser("vigilante", "vigilante", 2, @code);
CALL RegisterUser("user", "user", 1, @code);