SELECT * from PILOTE;

ALTER TABLE PILOTE RENAME TO NAVIGANT;

CREATE TABLE PILOTE (
    brevet VARCHAR2(4),
    prenom VARCHAR2(20),
    nom VARCHAR2(20)
);

INSERT INTO PILOTE(
    brevet, prenom, nom
)VALUES(
    'PL-1',
    'JP',
    'Ferrage'
);

ALTER TABLE PILOTE ADD (
    NBHVOL NUMBER(7,2)
);

ALTER TABLE PILOTE ADD (
    COMPA VARCHAR2(4) DEFAULT 'AF',
    ville VARCHAR2(30) DEFAULT 'Paris' NOT NULL
);

ALTER TABLE PILOTE RENAME COLUMN ville TO ADRESSE;

DESC PILOTE;

ALTER TABLE PILOTE MODIFY (
    COMPA VARCHAR(6) DEFAULT 'SING'
);

INSERT INTO PILOTE(
    BREVET,
    PRENOM,
    NOM
)VALUES(
    'PL-2',
    'Arnaud',
    'Sayag'
);

ALTER TABLE PILOTE MODIFY(
    COMPA CHAR(4) NOT NULL
);
SELECT * FROM PILOTE;

ALTER TABLE PILOTE MODIFY(
    COMPA NULL
);

ALTER TABLE PILOTE drop COLUMN ADRESSE;

-- MARQUER DES COLONNES A L'EFFACEMENT
/*
l'avantage ici est de faire un gain de temps par 
rapport à la commande DROP COLUMN qui sur des bases de données
volumineuses prendre beaucoup de temps car la commande 
UNUSED COLUMN ne fait pas de modification physique mais a les
mêmes effets que la commande DROP COLUMN 
*/
ALTER TABLE PILOTE SET UNUSED COLUMN COMPA;

DESC PILOTE;
/*
les colonnes marquées à l'effacement ne peuvent plus être 
utilisées et la seule manipulation qui peut être éffectuée
sur elle est un effacement définitif avec la commande
DROP UNUSED COLUMNS
*/
ALTER TABLE PILOTE DROP unused COLUMNS;

-- COLONNE VIRTUELLE

CREATE TABLE AVION (
    IMMAT VARCHAR2(6),
    typeavion VARCHAR2(15),
    NBHVOL NUMBER(10,2),
    age NUMBER(4,1),
    freqvolmois GENERATED ALWAYS AS (NBHVOL/age/12) virtual,
    NBPAX NUMBER(3),
    CONSTRAINT pk_avion primary key (IMMAT)
);

DESC AVION;



INSERT INTO AVION (
    IMMAT,
    TYPEAVION,
    NBHVOL,
    AGE,
    NBPAX
)VALUES(
    'F-WTSS',
    'Concorde',
    20000,
    18,
    90
);

INSERT INTO AVION (
    IMMAT,
    TYPEAVION,
    NBHVOL,
    AGE,
    NBPAX
)VALUES(
    'F-GHTY',
    'A380',
    450,
    0.5,
    460
);

SELECT IMMAT, freqvolmois FROM AVION;
/*

L'intérêt des colonnes virtuelles n'est pas de permettre de partitionner une table,
 c'est une sorte d'effet de bord, mais un effet de bord positif 
 (le calcul de la clé de partionnement peut se trouver dans la définition de la table )

L'intérêt des colonnes virtuelles est bien d'avoir des colonnes calculées, dérivées.
 Des exemples pratiques où les colonnes virtuelles peuvent apporter un plus:
- Une conversion de devise (Euro vers Franc Belges, Francs Français, etc.)
- Une conversion d'unités (mètres vers des pieds/pouces, pascal en atmosphère,
 litres vers gallons...)
- Calculer un prix après Rabais, remises, ristourne
- ...

Un exemple que j'ai dernièrement mis en pratique. J'ai dans une application deux colonnes
 Nom, Prénom... Une colonne virtuelle (NOM+PRENOM) a été dérivée sur base de ces
deux colonnes. Dans la colonnes virtuelles, seul les caractères de A à Z sont gardés. 
Pas de numérique, pas d'accent, pas de tréma, pas de tiret:
- Albert 2 de Belgique devient ALBERT-DEBELGIQUE
- Jean-José Sañû devient JEANJOSE-SANU

Ainsi, c'est ainsi que les exigences applicatives ont été écrits pour pouvoir rechercher 
une personne. Désormais, plus besoin de trigger pour garder cette colonnes à jour.

Par contre, il faut bien garder en tête que seule les fonctions 'DETERMINISTIC' 
peuvent être appelée dans la définition de la colonne virtuelle... 
Une fonction déterministique est (pour faire simple) une fonction ne dépendant pas d'un 
facteur variable.

Pour illustrer les fonction deterministic, prenons rapidement deux petits exemples:

La fonction UPPER renvoi la chaine de caractère qui lui est passé en MAJUSCULES. Cette 
fonction renverra toujours la même chaine en majuscule si on lui passe 
Hello (elle renverra toujours HELLO).

Par contre, immaginons une fonction CALCULER_AGE(date_naissance). 
On passe en paramètre une date de naissance et notre fonction calculer age renverrait 
un nombre (l'age). Cette fonction, pour pouvoir faire son travail a besoin d'un élément 
variable, à savoir l'heure actuelle. 
Comment pouvoir calculer l'age d'une personne sans connaitre la date du jour??

*/

ALTER TABLE AVION ADD(
    heurepax NUMBER(10,2) GENERATED ALWAYS AS (NBHVOL/AGE) VIRTUAL 
    CHECK (heurepax BETWEEN 0 AND 2000) NOT NULL
);

SELECT*FROM avion;

/*

SQL> INSERT INTO avion
  2  (
  3    immat,
  4    typeavion,
  5    nbhvol,
  6    age,
  7    nbpax
  8  )
  9  VALUES
  10  (
  11    'F-LIAP',
  12    'concorde',
  13    2100,
  14    1,
  15    50
  16  );

INSERT INTO avion
*
ERROR at line 173:
ORA-02290: check constraint (SOUTOU.SYS_C009770) violated

l'insertion de valeur ne respectant la contrainte d'une 
colonne virtuelle entraine une erreur
*/

-- COLONNES INVISIBLES

CREATE TABLE passagers(
    id_pax NUMBER(3),
    nom_pax VARCHAR2(30),
    bonus NUMBER(7,2) invisible,
    date_nais DATE
);

DESC passagers;

INSERT INTO passagers VALUES(
    1,'Belfont',20.5,to_date('05/03/1974','dd/MM/YYYY')
);
/*
INSERT INTO passagers VALUES(
            *
ERROR at line 210:
ORA-00913: too many values
*/

INSERT INTO passagers (
    id_pax,
    nom_pax,
    date_nais
)VALUES(
    1,
    'Belfont',
    to_date ('05/03/1974','DD/MM/YYYY')
);

/*
1 row created.
insertion validées
*/

INSERT INTO passagers(
    id_pax,
    nom_pax,
    bonus,
    date_nais
)VALUES(
    2,
    'Fontbel',
    45.6,
    to_date ('05/03/1990','DD/MM/YYYY')
);

SELECT*FROM passagers;
-- pour afficher la colonne invisible
SELECT id_pax,nom_pax,bonus,date_nais FROM passagers;
/*
pour afficher les colonnes invisibles dans le DESC taper la commande
"SET COLINVISIBLE ON"
*/
SET COLINVISIBLE ON
DESC passagers;
--SET COLINVISIBLE OFF


-----------MODIFICATIONS COMPORTEMENTALES ----------------
DESC COMPAGNIE;
DESC AFFRETER;
DESC avion;


DROP TABLE COMPAGNIE;
DROP TABLE affreter;
DROP TABLE AVION;

CREATE TABLE compagni(
    comp VARCHAR2(5),
    nrue NUMBER(5),
    rue VARCHAR2(30),
    ville VARCHAR2(10),
    nomcomp VARCHAR2(30)
);
CREATE TABLE affrete(
    compaff VARCHAR2(5),
    IMMAT VARCHAR2(10),
    DATEAFF DATE,
    NBPAX NUMBER(5)
);
CREATE TABLE avion(
    IMMAT VARCHAR2(10),
    TYPEAVION VARCHAR2(10),
    NBHVOL NUMBER(10,2),
    proprio VARCHAR2(10)
);

INSERT INTO compagni VALUES(
    'AF',
    124,
    'Port Royal',
    'Paris',
    'Air France'
);
INSERT INTO compagni VALUES(
    'SING',
    7,
    'Camparois',
    'Singapour',
    'Singapore AL'
);

INSERT INTO affrete VALUES(
    'AF',
    'F-WTSS',
    to_date('13/05/2003','DD/MM/YYYY'),
    85
);
INSERT INTO affrete VALUES(
    'SING',
    'F-GAFU',
    to_date('05/02/2003','DD/MM/YYYY'),
    155
);
INSERT INTO affrete VALUES(
    'AF',
    'F-WTSS',
    to_date('15/05/2003','DD/MM/YYYY'),
    82
);

INSERT INTO AVION VALUES(
    'F-WTSS',
    'Concorde',
    6570,
    'SING'
);
INSERT INTO AVION VALUES(
    'F-GAFU',
    'A320',
    3500,
    'AF'
);
INSERT INTO AVION VALUES(
    'F-GLFS',
    'TB-20',
    2000,
    'SING'
);

ALTER TABLE compagni ADD(
    CONSTRAINT pk_compagni primary key (comp)
);
ALTER TABLE AVION ADD(
    CONSTRAINT pk_avion primary key (IMMAT)
);

ALTER TABLE AVION ADD(
    CONSTRAINT nn_proprio CHECK (proprio IS NOT NULL),
    CONSTRAINT fk_avion_comp_compag foreign key (proprio) REFERENCES compagni(comp)
);
ALTER TABLE affrete ADD(
    CONSTRAINT pk_affrete primary key (compaff,immat,dateaff),
    CONSTRAINT fk_aff_comp_compag foreign key (compaff) REFERENCES compagni(comp)
);

ALTER TABLE affrete ADD(
    CONSTRAINT fk_aff_na_avion foreign key (immat) REFERENCES avion(immat)
);
/*
Gènére une erreur car dans la colonne pere ou de references " avion(immat)"
on a une valeur qui n'apparait pas dans la colonne fille affrete(immat)
DONC TOUJOURS DEFINIR SES CONTRAINTES A LA CREATION DE LA BASE

--l'erreur ici etait du au fait dans avion immat etait F_WTSS au lieu F-WTSS
-- on a du supprimer tous les enregistrements avant que la commande passe
DELETE FROM affrete
WHERE IMMAT= 'F-WTSS';
DELETE FROM affrete
WHERE IMMAT= 'F-GAFU';


UPDATE AVION SET IMMAT='F-WTSS' WHERE IMMAT='F_WTSS';
*/

-- SUPPRESION CONTRAINTE

ALTER TABLE AVION DROP CONSTRAINT nn_proprio;
ALTER TABLE AVION DROP constraint fk_avion_comp_compag;
ALTER TABLE AVION DROP CONSTRAINT pk_avion;
/*
ALTER TABLE AVION DROP CONSTRAINT pk_avion;
ERROR at line 381:
ORA-02273: this unique/primary key is referenced by some foreign keys
*/
--car cette table est référencée par une clé étrangère dans la table AFFRETE

ALTER TABLE AVION DROP CONSTRAINT pk_avion CASCADE;
/*
ceci a pour effet de supprimer aussi la contrainte fk_aff_na_avion
*/
-- SUPPRESSION DES COLONNES EN EVITANT CASCADE
-- il suffit de supprimer les contraintes dans l'ordre inverse de leur création 
ALTER TABLE affrete DROP CONSTRAINT fk_aff_comp_compag;
ALTER TABLE compagni DROP CONSTRAINT pk_compagni;
ALTER TABLE affrete DROP CONSTRAINT pk_affrete;

--DESACTIVATION DE CONTRAINTES

--mise à jour de la base

DELETE FROM AFFRETE WHERE compaff= 'SING';
DELETE FROM AFFRETE WHERE COMPAFF='AF' AND NBPAX=82;
DELETE FROM AVION WHERE IMMAT ='F-GAFU' ;
DELETE FROM AVION WHERE IMMAT='F-GLFS';
ALTER TABLE AVION ADD(
    CONSTRAINT pk_avion primary key (IMMAT)
);
ALTER TABLE affrete ADD (
    CONSTRAINT fk_aff_comp_immat foreign key (IMMAT) REFERENCES AVION(immat)
);
ALTER TABLE compagni ADD(
    CONSTRAINT pk_compagni primary key (COMP)
);
ALTER TABLE AVION ADD(
    CONSTRAINT fk_avion_comp FOREIGN KEY (proprio) REFERENCES compagni(comp)
);
ALTER TABLE affrete ADD(
    CONSTRAINT fk_aff_comp_compag FOREIGN KEY (COMPAFF) REFERENCES compagni(comp)
);
ALTER TABLE AVION ADD(
    CONSTRAINT nn_proprio CHECK (proprio IS NOT NULL)
);

---------------------------------------------------

ALTER TABLE AVION DISABLE CONSTRAINT nn_proprio;

-- insertion un avion qui n'est rattaché a aucune compagnie
INSERT INTO AVION VALUES(
    'Bidon1',
    'TB-20',
    2000,
    NULL
);

ALTER TABLE AVION DISABLE CONSTRAINT fk_avion_comp;
--insertion un avion rattaché à une compagnie inexistanre
INSERT INTO AVION VALUES(
    'F-GLFS',
    'TB-22',
    500,
    'Toto'
);

ALTER TABLE AVION disable CONSTRAINT pk_avion CASCADE DROP INDEX;
--insertion un avion qui ne respecte pas la clé primaire
INSERT INTO AVION VALUES(
    'Bidon1',
    'TB-21',
    1000,
    'AF'
);

INSERT INTO AFFRETE VALUES(
    'AF',
    'Toto',
    to_date('13/05/2003','DD/MM/YYYY'),
    0
);

--REACTIVATION DES CONTRAINTES

ALTER TABLE AVION ENABLE CONSTRAINT pk_avion USING INDEX (CREATE UNIQUE INDEX pk_avion ON AVION(IMMAT));
/*
ERROR at line 456:
ORA-02437: cannot validate (SOUTOU.PK_AVION) - primary key violated
on obtient cette erreur car les valeurs de la table avion ne respecte
pas les contraintes de clé primaire
*/
----- RECUPERATION DE DONNEES ERRONEES

CREATE TABLE problemes(
    adresse ROWID,
    utilisateur VARCHAR2(30),
    nomtable VARCHAR2(30),
    nomcontrainte VARCHAR2(30)
);

ALTER TABLE AVION ENABLE CONSTRAINT nn_proprio EXCEPTIONS INTO problemes;
ALTER TABLE AVION ENABLE CONSTRAINT fk_avion_comp EXCEPTIONS INTO problemes;
ALTER TABLE avion ENABLE CONSTRAINT pk_avion EXCEPTIONS INTO problemes;
--affichage des exceptions 
SELECT * FROM problemes;
SELECT * FROM avion;

UPDATE AVION set IMMAT ='F-TB20' WHERE IMMAT = 'Bidon1' AND TYPEAVION='TB-20';
UPDATE AVION SET PROPRIO ='AF' WHERE NOT(PROPRIO = 'SING');
UPDATE AFFRETE SET IMMAT = 'F-TB20' WHERE IMMAT = 'Toto';


--il convient de supprimer les valeurs de la table d'exceptions(PROBLEME)

DELETE from PROBLEMES;
ALTER TABLE AVION ENABLE CONSTRAINT nn_proprio EXCEPTIONS INTO PROBLEMES;
ALTER TABLE AVION ENABLE CONSTRAINT fk_avion_comp EXCEPTIONS INTO PROBLEMES;
ALTER TABLE AVION ENABLE CONSTRAINT pk_avion EXCEPTIONS INTO PROBLEMES;
ALTER TABLE AFFRETE ENABLE CONSTRAINT........  EXCEPTIONS INTO PROBLEMES;


-------CONTRAINTES DIFFEREES------

--suppression des tables
DROP TABLE compagnie CASCADE CONSTRAINT;
DROP TABLE compagni CASCADE CONSTRAINT;
DROP TABLE affrete;
DROP TABLE affreter CASCADE CONSTRAINT;
DROP TABLE avion;

--directives DEFERRABLE et INITIALLY

-- mode différé

CREATE TABLE compagnie(
    comp VARCHAR2(4),
    nrue NUMBER(3),
    rue VARCHAR2(20),
    ville VARCHAR2(15),
    nomcomp VARCHAR2(15),
    CONSTRAINT pk_compagnie PRIMARY KEY (comp) NOT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE avion(
    immat VARCHAR2(6),
    typeavion VARCHAR2(15),
    nbhvol NUMBER(10,2),
    proprio VARCHAR2(4),
    CONSTRAINT fk_avion_comp_compag FOREIGN KEY (proprio) REFERENCES compagnie(comp) DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT pk_avion PRIMARY KEY (immat)
);
INSERT INTO avion VALUES(
    'F-WTSS',
    'Concorde',
    6570,
    'SING'
);

 
/*
1 row created.
*/
COMMIT;
/*
Après le commit la vérification s'éffectue et là la violation de la contrainte se fait donc constater
et on obtient l'erreur suivante avec une annulation de l'insertion

Erreur SQL : ORA-02091: transaction annulée
ORA-02291: violation de contrainte d'intégrité (SOUTOU.FK_AVION_COMP_COMPAG) - clé parent introuvable
02091. 00000 -  "transaction rolled back"
*/

--mode immediat

DELETE FROM AVION
WHERE immat = 'F-WTSS';

SET AUTOCOMMIT ON;



