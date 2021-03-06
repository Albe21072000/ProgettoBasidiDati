##################### CREAZIONE BASE DI DATI #############################

DROP DATABASE IF EXISTS ProgettoBiblioteca;
CREATE DATABASE IF NOT EXISTS ProgettoBiblioteca;
USE ProgettoBiblioteca;

##################### CREAZIONE TABELLE #############################

DROP TABLE IF EXISTS Risorsa_Astratta;

CREATE TABLE IF NOT EXISTS Risorsa_Astratta (
    ID VARCHAR(30) PRIMARY KEY,
    Titolo VARCHAR(70),
    Data_Pubblicazione DATE,
    Genere VARCHAR(20),
    Tipologia ENUM('Libro', 'Tesi', 'Articolo')
) ENGINE=INNODB;
  
DROP TABLE IF EXISTS Autore;

CREATE TABLE IF NOT EXISTS Autore (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(15),
    Cognome VARCHAR(45) NOT NULL
) ENGINE=INNODB;
  
DROP TABLE IF EXISTS Pubblicazione;

CREATE TABLE IF NOT EXISTS Pubblicazione (
    Risorsa VARCHAR(30),
    ID_Autore INT,
    FOREIGN KEY (Risorsa)
        REFERENCES Risorsa_Astratta (ID)
        ON UPDATE CASCADE,
    FOREIGN KEY (ID_Autore)
        REFERENCES Autore (ID)
        ON UPDATE CASCADE,
    PRIMARY KEY (risorsa , ID_autore)
) ENGINE=INNODB;
  
DROP TABLE IF EXISTS Biblioteca;

CREATE TABLE IF NOT EXISTS Biblioteca (
    Nome VARCHAR(20) PRIMARY KEY,
    Dipartimento VARCHAR(20),
    ID_Responsabile INT
) ENGINE=INNODB;
    
DROP TABLE IF EXISTS Dipendente;

CREATE TABLE IF NOT EXISTS Dipendente (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    CF VARCHAR(16),
    Impiego VARCHAR(20),
    FOREIGN KEY (Impiego)
        REFERENCES Biblioteca (Nome)
) ENGINE=INNODB;
    
DROP TABLE IF EXISTS Recapito;

CREATE TABLE IF NOT EXISTS Recapito (
    Dipendente INT,
    Contatto VARCHAR(30),
    FOREIGN KEY (Dipendente)
        REFERENCES Dipendente (ID),
    PRIMARY KEY (Dipendente , Contatto)
) ENGINE=INNODB;
    
ALTER TABLE Biblioteca 
	ADD FOREIGN KEY(ID_Responsabile) REFERENCES Dipendente(ID);

DROP TABLE IF EXISTS Risorsa_Fisica;

CREATE TABLE IF NOT EXISTS Risorsa_Fisica (
    Risorsa_Astratta VARCHAR(30),
    Barcode INT,
    Disponibilita ENUM('SI', 'NO'),
    Biblioteca VARCHAR(20),
    Sala VARCHAR(20),
    PRIMARY KEY (Risorsa_Astratta , Barcode),
    FOREIGN KEY (Risorsa_Astratta)
        REFERENCES Risorsa_Astratta (ID),
    FOREIGN KEY (Biblioteca)
        REFERENCES Biblioteca (Nome)
) ENGINE=INNODB;
    
DROP TABLE IF EXISTS Attivita;

CREATE TABLE IF NOT EXISTS Attivita (
    Nome VARCHAR(40),
    Data_Inizio DATE,
    Scadenza_Prevista DATE,
    Data_Fine DATE DEFAULT NULL,
    PRIMARY KEY (Nome , Data_Inizio)
) ENGINE=INNODB;
  
DROP TABLE IF EXISTS Partecipazione;

CREATE TABLE IF NOT EXISTS Partecipazione (
    Dipendente INT,
    Attivita VARCHAR(40),
    Data_Inizio_Attivita DATE,
    FOREIGN KEY (Dipendente)
        REFERENCES Dipendente (ID),
    FOREIGN KEY (Attivita , Data_Inizio_Attivita)
        REFERENCES Attivita (Nome , Data_Inizio)
) ENGINE=INNODB;
    
DROP TABLE IF EXISTS Contributo;

CREATE TABLE IF NOT EXISTS Contributo (
    ID_Risorsa VARCHAR(30),
    Barcode_Risorsa INT,
    Attivita VARCHAR(40),
    Data_Inizio_Attivita DATE,
    FOREIGN KEY (ID_Risorsa , Barcode_Risorsa)
        REFERENCES Risorsa_Fisica (Risorsa_Astratta , Barcode),
    FOREIGN KEY (Attivita , Data_Inizio_Attivita)
        REFERENCES Attivita (Nome , Data_Inizio)
) ENGINE=INNODB;
  
############### POPOLAMENTO TABELLE #########################

INSERT INTO Risorsa_Astratta VALUES
("8854180858-978-8854180857","Architettura romana", "1999-03-01", "Architettura", "Libro"),
("8838694451-978-8838694455","Basi di dati", "2018-02-15", "Informatica", "Libro"),
("884983084X-978-8849830842","La via della schiavit??", "2011-04-13", "Economia", "Libro"),
("10.1145-98457.98525","An approximate analysis of the LRU and FIFO buffer replacement schemes", "1990-04-15", "Informatica", "Articolo"), #articoli di dominio pubblico o inventati
("10.1245-9543457.98525","Architettura fra Passato e presente", "2021-02-15", "Architettura", "Articolo"), #Abbiamo usato tesi di persone che o non esitono od hanno dato il consenso
("ARTL1994000000061","I FALSI PROBLEMI STRUTTURALI DI GUARINO GUARINI", "1994-04-15", "Architettura", "Tesi"),
("ARTL200600032342361","Economia e Finanza", "2006-04-15", "Economia", "Tesi"),
("ARTL202000032342361","Algoritmi", "2020-04-15", "Informatica", "Tesi");

INSERT INTO Autore(Nome,cognome) VALUES
( "Friedrich A.", "von Hayek"),
("Savina", "Mazzantini"),
("Mario", "Rossi"),
("Paolo", "Atzeni"),
("Stefano", "Ceri "),
("Piero", "Fraternali"),
("Riccardo", "Torlone"),
("Paolo","Verdi"),
("Asit", "Dan"),
("Don", "Towsley");

INSERT INTO Pubblicazione VALUES
("884983084X-978-8849830842",1),
("8838694451-978-8838694455",4),
("8838694451-978-8838694455",5),
("8838694451-978-8838694455",6),
("8838694451-978-8838694455",7),
("8854180858-978-8854180857", 3),
("8854180858-978-8854180857", 2),
("10.1145-98457.98525", 9),
("10.1145-98457.98525", 10),
("ARTL202000032342361", 8),
("ARTL1994000000061", 2),
("ARTL200600032342361", 1),
("10.1245-9543457.98525", 3);

LOAD DATA LOCAL INFILE "Biblioteche.csv" INTO TABLE Biblioteca  #inserire il proprio filepath
	FIELDS TERMINATED BY ";"
	LINES TERMINATED BY "\r\n"
	IGNORE 1 ROWS;

INSERT INTO Risorsa_Fisica VALUES
("8854180858-978-8854180857", 1234567, "Si",  'Scienze Tecnolgiche', "Lettura"),
("8838694451-978-8838694455", 126743567, "No",  'DIMAI-Ulisse DINI', "S1"),
("884983084X-978-8849830842", 123242354, "Si", 'DIMAI-Ulisse DINI', "S2"),
("10.1145-98457.98525", 125622354, "Si", 'Scienze Economiche', "A1"),
("884983084X-978-8849830842", 125642354, "No", 'Scienze Economiche', "S2"),
("10.1245-9543457.98525", 123642354, "Si", 'Scienze Tecnolgiche', "Ingresso"),
("ARTL1994000000061", 0342354, "Si", 'Scienze Tecnolgiche', "Archivio 1"),
("ARTL200600032342361", 12523354, "No", 'Scienze Economiche', "Sala Tesi2"),
("ARTL202000032342361", 1343354, "Si", 'DIMAI-Ulisse DINI', "ST");

LOAD DATA LOCAL INFILE "Dipendenti.txt" INTO TABLE Dipendente  #inserire il proprio filepath
	FIELDS TERMINATED BY ";"
	LINES TERMINATED BY "\r\n"
	IGNORE 1 ROWS;

UPDATE Biblioteca 
	SET ID_Responsabile = 203
	WHERE Nome = 'DIMAI-Ulisse DINI';
UPDATE Biblioteca 
	SET ID_Responsabile = 430
	WHERE Nome = 'Scienze Economiche';
UPDATE Biblioteca 
	SET ID_Responsabile = 519
	WHERE Nome = 'Scienze Tecnolgiche';

INSERT INTO Recapito VALUES
('203', '555-345668'),
('410', 'gianni.smp@gmail.com'),
('410', '256-384739'),
('510', 'laura.noncu@outlook.it'),
('514', '045-3453245'),
('519', '12-312478'),
('519', 'Il.nc@gmail.com'),
('519', '234-35567');

INSERT INTO Attivita VALUES
("Dall'Architettura romana ad oggi", '2018-06-01', '2018-07-21','2018-07-01'),
("Algoritmi Informatici e Basi di Dati", '2017-09-01', '2018-09-21','2018-12-01'),
("Dall'Architettura romana ad oggi", '2019-06-01', '2019-07-21','2019-07-01'),
("Economia moderna", '2021-05-10', '2021-07-20', NULL),
("Algoritmi Informatici e Basi di Dati", '2021-09-01', '2021-09-21',NULL);

INSERT INTO Partecipazione VALUES
(203, "Algoritmi Informatici e Basi di Dati", '2017-09-01'),
(410, "Algoritmi Informatici e Basi di Dati", '2017-09-01'),
(203, "Algoritmi Informatici e Basi di Dati", '2021-09-01'),
(412, "Algoritmi Informatici e Basi di Dati", '2021-09-01'),
(430, "Economia moderna", '2021-05-10'),
(510, "Economia moderna", '2021-05-10'),
(513, "Dall'Architettura romana ad oggi", '2018-06-01'),
(519, "Dall'Architettura romana ad oggi", '2019-06-01');

INSERT INTO Contributo VALUES
('10.1145-98457.98525', '125622354', 'Economia moderna', '2021-05-10'),
('10.1245-9543457.98525', '123642354', "Algoritmi Informatici e Basi di Dati", '2017-09-01'),
('8838694451-978-8838694455', '126743567', "Algoritmi Informatici e Basi di Dati", '2017-09-01'),
('10.1245-9543457.98525', '123642354', "Algoritmi Informatici e Basi di Dati", '2021-09-01'),
('884983084X-978-8849830842',	'125642354', 'Economia moderna', '2021-05-10'),
('10.1245-9543457.98525', '123642354', "Dall'Architettura romana ad oggi", "2018-06-01" ),
('8854180858-978-8854180857', '1234567',  "Dall'Architettura romana ad oggi", "2018-06-01"),
('ARTL1994000000061',  '342354', "Dall'Architettura romana ad oggi", "2018-06-01"),
('10.1245-9543457.98525', '123642354', "Dall'Architettura romana ad oggi", "2019-06-01" ),
('8854180858-978-8854180857', '1234567',  "Dall'Architettura romana ad oggi", "2019-06-01");

###################### INTERROGAZIONI #####################

## Trovare i dipendenti(nome e cognome) il cui coidice fiscale inizia per M o finisce per R

SELECT Nome, Cognome
	FROM Dipendente
	WHERE CF LIKE 'M%' OR '%R';

## Trovare gli autori presenti nella Biblioteca di Architettura

SELECT DISTINCT ID, Au.Nome, Cognome
	FROM Autore au JOIN pubblicazione pub ON au.Id = pub.ID_Autore
        JOIN Risorsa_fisica Ris ON Ris.Risorsa_Astratta = Risorsa
        JOIN Biblioteca Bi ON Biblioteca = Bi.Nome
	WHERE Dipartimento = 'Architettura';
    
## Trovare per ogni attivit?? tutti i dipendenti che ci hanno partecipato

# SET sql_mode=(SELECT REPLACE (@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
SELECT att.Nome, Data_inizio, GROUP_CONCAT(CONCAT(dip.nome, ' ', cognome)) AS Partecipanti
	FROM attivita Att JOIN Partecipazione Pa ON Pa.Attivita = Att.nome AND Pa.Data_Inizio_Attivita = Att.Data_Inizio
        JOIN Dipendente Dip ON Pa.Dipendente = Dip.ID
	GROUP BY (att.Data_inizio);

## Trovare i dipendenti che non hanno mai partecipato ad un'attivit??
DROP VIEW IF EXISTS DipendentiAttivita;
CREATE VIEW DipendentiAttivita AS
	SELECT D.ID, COUNT(P.Attivita) AS NumAttivita
		FROM Dipendente D JOIN Partecipazione P ON D.ID=P.Dipendente
		GROUP BY D.ID; # contiene ID Dipendente e numero di attivita a cui ha partecipato

SELECT D.ID, D.Nome, D.Cognome
	FROM Dipendente D
	WHERE NOT EXISTS (SELECT DA.ID FROM DipendentiAttivita DA WHERE DA.ID=D.ID);
    
## Trovare gli autori che hanno pubblicato pi?? di una risorsa 

SELECT DISTINCT Nome, Cognome
	FROM Autore Au JOIN Pubblicazione Pub ON Au.ID = Pub.ID_Autore
	WHERE ID_Autore NOT IN 
		(SELECT DISTINCT ID_Autore FROM Autore JOIN pubblicazione ON ID = ID_Autore
			GROUP BY ID_Autore
			HAVING COUNT(*) < 2);
        
## Trovare il dipendente che ha partecipato al maggior numero di attivita

SELECT D.Nome, D.Cognome, D.ID
	FROM Dipendente D NATURAL JOIN DipendentiAttivita DA 
	WHERE NumAttivita=(SELECT max(NumAttivita) FROM DipendentiAttivita);
    
DROP VIEW DipendentiAttivita;
        
###################### PROCEDURE E FUNZIONI #####################

## Operazione 2: ricercare la disponibilit?? e la collocazione di una risorsa

DROP PROCEDURE IF EXISTS RicercaTitolo;

DELIMITER $$
CREATE PROCEDURE RicercaTitolo(Titolo VARCHAR(70))
BEGIN
	SELECT DISTINCT Biblioteca, Sala, Disponibilita
		FROM Risorsa_Astratta RA JOIN Risorsa_Fisica RF ON RA.ID=RF.Risorsa_Astratta
		WHERE RA.Titolo=Titolo;
END $$
DELIMITER ;

CALL RicercaTitolo("La via della schiavitu");

## Ricerca del responsabile della biblioteca in cui lavora un dato dipendente

DROP PROCEDURE IF EXISTS ResponsabileDipendente;
DELIMITER $$
CREATE PROCEDURE ResponsabileDipendente(ID INT)
BEGIN
	DECLARE bib VARCHAR(20);
    SELECT Impiego INTO bib FROM Dipendente D WHERE D.ID=ID;
    SELECT D.ID, D.Nome, D.Cognome, D.Impiego
		FROM Biblioteca B JOIN Dipendente D ON B.Nome=D.Impiego
		WHERE D.ID=B.ID_Responsabile AND B.Nome=bib;
END $$
DELIMITER ;

CALL ResponsabileDipendente(410);

## Funzione che restituisce il numero di volte in cui una risorsa astratta ?? stata usata in un'attivit?? iniziata un certo anno

DROP FUNCTION IF EXISTS NumeroRisorseAstratteAttivita;

# SET GLOBAL log_bin_trust_function_creators=TRUE;
DELIMITER $$
CREATE FUNCTION NumeroRisorseAstratteAttivita(IDRisorsa VARCHAR(30), Anno YEAR) 
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE n INT DEFAULT 0;
	IF Anno>YEAR(NOW())
		THEN RETURN NULL;
	ELSE
		SELECT COUNT(*) INTO n 
			FROM Contributo C JOIN Risorsa_Astratta RA ON C.ID_Risorsa=RA.ID
			WHERE RA.ID=IDRisorsa AND YEAR(C.Data_inizio_attivita)<Anno<YEAR(NOW())
			GROUP BY RA.ID;
		RETURN n;
	END IF;
END $$
DELIMITER ;
# SET GLOBAL log_bin_trust_function_creators=FALSE;

SELECT NumeroRisorseAstratteAttivita('8838694451-978-8838694455', '2022');
SELECT NumeroRisorseAstratteAttivita('8838694451-978-8838694455', '2017');

###################### VISTE #####################

DROP VIEW IF EXISTS DipendentiMatematica;
CREATE VIEW DipendentiMatematica AS
	SELECT *
		FROM Dipendente D
		WHERE D.Impiego="DIMAI-Ulisse DINI"
	WITH LOCAL CHECK OPTION;
SELECT * FROM DipendentiMatematica;

# INSERT INTO DipendentiMatematica VALUES (999, "A", "B", "C", "DIMAI"); errore per la local check option
INSERT INTO DipendentiMatematica VALUES (999, "Prova", "", "", "DIMAI-Ulisse DINI");
SELECT * FROM DipendentiMatematica;
SELECT * FROM Dipendente WHERE Impiego="DIMAI-Ulisse DINI";

DROP VIEW IF EXISTS AttivitaDipendentiMatematica;
CREATE VIEW AttivitaDipendentiMatematica AS
	SELECT DM.ID, DM.Nome AS NomeDipendente, DM.Cognome, A.Nome AS NomeAttivita, A.Data_inizio, A.scadenza_prevista, A.data_fine
		FROM DipendentiMatematica DM JOIN Partecipazione P ON P.Dipendente=DM.ID
			JOIN Attivita A ON P.Attivita=A.Nome AND P.Data_inizio_attivita=A.Data_inizio;
SELECT * FROM AttivitaDipendentiMatematica;

###################### TRIGGER #####################

DELIMITER $$
CREATE TRIGGER CheckEsistenzaRisorsaAstratta
BEFORE INSERT ON Risorsa_Fisica
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM Risorsa_Astratta RA WHERE RA.ID=NEW.Risorsa_Astratta = 0)
		THEN INSERT INTO Risorsa_Astratta(ID) VALUES (NEW.Risorsa_Astratta);
	END IF;
END $$
DELIMITER ;

SELECT * FROM Risorsa_Astratta;
INSERT INTO Risorsa_Fisica VALUES ("978-88-919-0455-3",42,"SI","DIMAI-Ulisse Dini","Lettura");
SELECT * FROM Risorsa_Astratta;
SELECT * FROM Risorsa_Fisica;