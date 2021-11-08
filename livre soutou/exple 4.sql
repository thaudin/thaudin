GRANT SELECT ANY TABLE TO soutou;

-------------- Utilisation de DUAL ----------
SELECT 'il reste encore beaucoup de pages ?'
FROM DUAL;

SELECT TO_CHAR(SYSDATE,'dd,month yyyy, hh24:mi:ss') "maintenant :"
FROM DUAL;

SELECT TO_CHAR(SYSDATE) "maintenant :"
FROM DUAL;

SELECT POWER(2,14 ), POWER(cos(135*3.14159265359/180),2 ), EXP(1)
FROM DUAL;

---------- projection du SELECT ----------
SELECT * FROM pilote;

DELETE FROM PILOTE;
ALTER TABLE pilote ADD compa VARCHAR2(5);

INSERT INTO pilote VALUES('PL-1','Benoit','Sarda',4500,'AF');
INSERT INTO pilote VALUES('PL-2','Aime','Giaconne',2000,'AF');
INSERT INTO pilote VALUES('PL-3','Pierre','Calac',1500,'SING');
INSERT INTO pilote VALUES('PL-4','Jean Phi','Ferrage',2450,'CAST');
INSERT INTO pilote VALUES('PL-5','Jean','Gazagnes',NULL,'SING');
INSERT INTO pilote VALUES('PL-6','Arnaud','Sayag',2450,'AF');

--afficher quelque colonne
SELECT compa,brevet FROM pilote;

--alias de colonne
SELECT compa AS compagnie, nom as name, brevet num_pilote
FROM pilote;

--alias de table
SELECT a_pilotes.compa AS compagnie, a_pilotes.nom
FROM pilote a_pilotes;

--duplicatas(distinct=unique)
SELECT DISTINCT compa FROM pilote;
SELECT UNIQUE compa FROM pilote;
SELECT DISTINCT nbhvol,compa FROM pilote;


--expression (||= concatenation)
SELECT brevet, nbhvol*1.75 AS prime, nbhvol||nom as heure_nom
FROM pilote;

--ordonnancement
SELECT brevet, nbhvol FROM pilote  
ORDER BY nbvol ASC NULLS FIRST;

SELECT brevet, nbhvol,prenom from pilote  
ORDER BY nbhvol ASC NULLS FIRST, prenom asc;

--substitutions conditionnelles
SELECT nom, DECODE(compa /*expr*/,
                   'AF' /*search*/,
                   'Air France' /*result*/,
                   'SING','Singapore AIR' /*search, result*/,
                   'CAST','Trans Casta' /*search, result...*/,
                   'Autre ou aucune' /*default*/)
                   AS COMPAGNIE
FROM PILOTE
ORDER BY nom;

--rowid, rownum
SELECT ROWID,brevet,NOM
FROM pilote;
SELECT ROWNUM,brevet,NOM
FROM PILOTE;

SELECT brevet,nom
FROM pilote 
WHERE rownum<=3
ORDER BY nom;

--insertion multiligne
CREATE TABLE nomsethvildespilotes AS SELECT nom, nbhvol, compa FROM pilote;
/*
bon l'option insertion multiligne est surtout utile pour copier des infos d'une table 
déja existante et les inserées dans une nouvelle 
*/
CREATE TABLE nomsethvoldespilotes(
    nom VARCHAR(16),
    nbhvol NUMBER(7,2),
    compa CHAR(4)
);
INSERT INTO nomsethvoldespilotes 
SELECT nom, nbhvol, compa 
FROM pilote;

--limite du nombre de lignes
SELECT brevet, prenom, nom, nbhvol 
FROM pilote  
WHERE nbhvol IS NOT NULL
ORDER BY nbhvol DESC
FETCH FIRST 2 ROWS ONLY;

SELECT brevet, prenom, nom, nbhvol  
FROM pilote  
WHERE nbhvol IS NOT NULL
ORDER BY nbhvol  DESC
FETCH NEXT 2 ROWS WITH TIES;

SELECT brevet, prenom, nom, nbhvol  
from pilote  
WHERE nbhvol IS NOT NULL
ORDER BY nbhvol DESC
FETCH FIRST 2 ROWS ONLY;








