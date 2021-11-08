INSERT INTO COMPAGNIE VALUES(
    'SING',
    'singapoure al',
    TO_DATE('19470101','yyyymmdd')

);

INSERT INTO COMPAGNIE(
    NOM_COMP,COMP,DATE_CREATION
)VALUES(
    'AIR France','AF',TO_DATE('19330101' /*char [ DEFAULT return_value ON CONVERSION ERROR ]*/,
                              'yyyymmdd' /*'nlsparam'*/)
);

INSERT INTO COMPAGNIE(
    NOM_COMP,COMP,DATE_CREATION
)VALUES(NULL,'GO',TO_DATE('20141231' /*char [ DEFAULT return_value ON CONVERSION ERROR ]*/,
                          'yyyymmdd' /*fmt*/)
);

INSERT INTO VOL_JOUR(
    NUM_VOL,AERO_DEP,AERO_ARR,JOUR_VOL,NB_PASSAGERS
)VALUES(
    'AF6143','TLS','ORY',TO_DATE('20141120 15:30', 'yyyymmdd hh24:mi'),120

);

INSERT INTO VOL_JOUR(
    NUM_VOL,AERO_DEP,AERO_ARR,JOUR_VOL,NB_PASSAGERS
)VALUES(
    'AF6145','ORY','TLS',TO_DATE('20141120 18:45', 'yyyymmdd hh24:mi'),NULL
);

INSERT INTO VOL_JOUR(
    NUM_VOL,AERO_DEP,AERO_ARR,COMP,JOUR_VOL,NB_PASSAGERS
)VALUES(
    'SQ747','CDG','SIN','SING',TO_DATE('20141120 19:30','yyyymmdd hh24:mi'),NULL
);

INSERT INTO VOL_JOUR(
    NUM_VOL,AERO_DEP,AERO_ARR,COMP,JOUR_VOL,NB_PASSAGERS
)VALUES(
    'AF6550','CDG','TLS',DEFAULT,to_date('20141120 20:00','yyyymmdd hh24:mi'),195
);

INSERT INTO VOL_JOUR(
    NUM_VOL,AERO_DEP,AERO_ARR,COMP,JOUR_VOL,NB_PASSAGERS
)VALUES(
    'AF6530','AGN','AGN','AF',to_date('20141120 10:00','yyyymmdd hh24:mi'),95
);

CREATE TABLE pilote(
    brevet VARCHAR2(6),
    prenom VARCHAR2(20) NOT NULL,
    nom VARCHAR2(20) NOT NULL,
    date_nais DATE NOT NULL,
    embauche DATE NOT NULL,
    constraint pk_pilote PRIMARY KEY (brevet)
);

INSERT INTO PILOTE (
    brevet,prenom,nom,date_nais,embauche
)VALUES(
    'b1','christian','mermoz',to_date('05/02/1965','dd/mm/yyyy'),SYSDATE
);

INSERT INTO PILOTE(
    brevet,prenom,nom,date_nais,embauche
)VALUES(
    'b2','christian','mermoz',to_date('19650205','yyyymmdd'),SYSDATE
);

CREATE TABLE EVENEMENTS(
    arrive TIMESTAMP,
    arrivelocalement TIMESTAMP WITH TIME ZONE
);

INSERT INTO EVENEMENTS(
    arrive,arrivelocalement
)VALUES(
    TIMESTAMP '1965-02-05 09:30:02.123', TIMESTAMP '1963-01-16 12:30:05.98 + 4:30'
);

CREATE TABLE durees 
(
  dureeanneemois INTERVAL YEAR TO MONTH NOT NULL,
  dureejouurseconde INTERVAL DAY TO SECOND
);



--pour avoir des infos sur le serveur on utilise les variables suivantes
SELECT CURRENT_DATE/*date et heure de la session au format DATE*/,
LOCALTIMESTAMP/*date et heure de la session*/,
SYSTIMESTAMP/*date er heure du serveur*/,
DBTIMEZONE/*fuseau horaire du serveur*/,
SESSIONTIMEZONE/*fuseau horaire de la session client*/
FROM DUAL /*speudo table defini dans oracle*/;


CREATE TABLE TROMBINOSCOPE(
    nometudiant VARCHAR(30),
    photo BFILE
);

GRANT create any directory TO soutou;

CREATE DIRECTORY repertoire_etudiants AS 'D:\photo_soutou';

/*
SQL> CREATE DIRECTORY repertoire_etudiants AS 'D:\photoetudiant';

ERROR at line 105:
Not connected
SQL> CREATE DIRECTORY repertoire_etudiants AS 'D:\photoetudiant';

CREATE DIRECTORY repertoire_etudiants AS 'D:\photoetudiant'
*
ERROR at line 105:
ORA-01031: insufficient privileges
SQL> SHOW USER;
USER is "JACK"
SQL> CONNECT system/ mouton;

ORA-12154: TNS : impossible de résoudre l'identificateur de connexion indiqué
SQL> CONNECT system;

ORA-12154: TNS : impossible de résoudre l'identificateur de connexion indiqué
SQL> SHOW USER;
USER is ""
SQL> CREATE DIRECTORY repertoire_etudiants AS 'D:\photoetudiant';

ERROR at line 105:
Not connected
SQL> CREATE DIRECTORY repertoire_etudiants AS 'D:\documents';

CREATE DIRECTORY repertoire_etudiants AS 'D:\documents'
*
ERROR at line 105:
ORA-01031: insufficient privileges
SQL> CREATE DIRECTORY repertoire_etudiants AS 'D:\documents';

DIRECTORY created
*/

------------------------RESOLUTION------------------------------
-- 1- SE CONNECTER SUR LA CONSOLE EN MODE ADMIN 
-- 2- ATTRIBUER LES PRIVILEGES directory A L'UTILISATEUR JACK
/* GRANT create any directory TO jack;*/
----------------------- PROBLEME RESOLUE------------------

INSERT INTO TROMBINOSCOPE (
    NOMETUDIANT, PHOTO
)VALUES(
    'soutou', BFILENAME('repertoire_etudiants' /*'directory'*/,
                        'photoCS.jpg' /*'filename'*/)
);

GRANT CREATE ANY SEQUENCE TO JACK;

CREATE TABLE affreter(
    numaff NUMBER(5),
    COMP VARCHAR2(4),
    immat VARCHAR2(6),
    dateaff DATE,
    nbpax NUMBER(3),
    CONSTRAINT pk_affreter PRIMARY KEY(numaff)
);

CREATE TABLE passager(
    numpax NUMBER(6),
    nom VARCHAR2(15),
    siege VARCHAR2(4),
    derniervol NUMBER(5),
    CONSTRAINT pk_passager PRIMARY KEY (numpax),
    CONSTRAINT fk_pax_vol_affreter FOREIGN KEY (derniervol)
    REFERENCES affreter(numaff)
);

CREATE SEQUENCE seqaff
    MAXVALUE 10000
    NOMINVALUE
;

CREATE SEQUENCE seqpax
    increment by 10
    START WITH 100
    MAXVALUE 100000
    NOMINVALUE
;


-----PRIVILEGE SELECT SUR UNE SEQUENCE-------
GRANT SELECT ON seq TO JACK;
/* erreur ORA-01749: you may not GRANT/REVOKE privileges to/from yourself */
----------RESOLUTION -----------------------------------------
-- 1- lancement de sqlpus sur le terminal
/*PS C:\Users\liapoui> sqlplus*/

/*SQL*Plus: Release 11.2.0.2.0 Production on Jeu. Avr. 29 07:39:37 2021

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Enter user-name: system
Enter password:

Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
*/
-- 2- attribution du privilege select par l'utilisateur system
/*SQL> grant select on seq to jack;

Grant succeeded.*/
-------------------------------------------------------------------
INSERT INTO AFFRETER VALUES(
    seqaff.nextval,
    'af','f-wtss',TO_DATE('13052003','ddmmyyyy'),85
);

INSERT INTO AFFRETER VALUES(
    seqaff.nextval,'sing','f-gafu',TO_DATE('05022003','ddmmyyyy' ),155
);

INSERT INTO PASSAGER (
    NUMPAX,NOM,SIEGE,DERNIERVOL
)VALUES(
    seqpax.nextval,'payrissat','7a',seqaff.CURRVAL
);

INSERT INTO AFFRETER VALUES(
    seqaff.nextval,'af','f_wtss',TO_DATE('15052003','ddmmyyyy'),82
);

INSERT INTO PASSAGER VALUES(
    seqpax.nextval,'castaings','2e',seqaff.CURRVAL
);

select*from AFFRETER;

SELECT SEQAFF.CURRVAL, SEQAFF.NEXTVAL, SEQPAX.CURRVAL, SEQPAX.NEXTVAL
FROM DUAL;


CREATE SEQUENCE MASTER_SEQ
START WITH 1
INCREMENT BY 10;

CREATE SEQUENCE DETAIL_SEQ;

CREATE TABLE vol(
    id NUMBER DEFAULT MASTER_SEQ.NEXTVAL,
    DESCRIPTION VARCHAR2(6),
    JOUR_VOL DATE
);

CREATE TABLE places(
    id NUMBER DEFAULT DETAIL_SEQ.NEXTVAL,
    vol_id NUMBER DEFAULT MASTER_SEQ.CURRVAL,
    pax_nom VARCHAR2(30)
);

INSERT INTO vol(
    DESCRIPTION,JOUR_VOL
)VALUES(
    'af6143',SYSDATE-1
);
INSERT INTO places(
    PAX_NOM
)VALUES(
    'Joppé'
);
INSERT INTO places(
    PAX_NOM
)VALUES(
    'Rienna'
);
INSERT INTO places(
    PAX_NOM
)VALUES(
    'Guilbaud'
);

SELECT*FROM vol;
SELECT*FROM places;
/*

ALTER SEQUENCE DETAIL_SEQ
INCREMENT BY 10
START WITH 1 ;

-------- l'option 'START WITH' ne peut pas être modifié -----
 
la clause start with ne peut être modifié sans supprimer et recréer la séquence
*/ 

ALTER SEQUENCE DETAIL_SEQ
INCREMENT BY 10
;

ALTER SEQUENCE MASTER_SEQ
INCREMENT BY 1
;

CREATE TABLE billets(
    id  NUMBER(6)
        GENERATED ALWAYS
        AS IDENTITY,
    vol_id VARCHAR2(6) NOT NULL,
    jour_vol DATE DEFAULT SYSDATE NOT NULL,
    pax_nom VARCHAR2(30) NOT NULL,
    siege_pax CHAR(3) NOT NULL,
    CONSTRAINT pk_billets primary key(id)
);

INSERT INTO BILLETS(
    VOL_ID,PAX_NOM,SIEGE_PAX
)VALUES(
    'af6143','guilbaud','03f'
);
INSERT INTO BILLETS(
    VOL_ID,PAX_NOM,SIEGE_PAX
)VALUES(
    'AF6145','Blanchet','23B'
);
INSERT INTO BILLETS(
    VOL_ID,PAX_NOM,SIEGE_PAX
)VALUES(
    'AF6145','Bruchez','02A'
);

 
UPDATE COMPAGNIE
SET NOM_COMP='Go Airways'
    DATE_CREATION= TO_DATE('30/12/2014','DD/MM/YYYY')
WHERE COMP ='GO'
;
UPDATE VOL_JOUR
SET NB_PASSAGERS =10
WHERE NB_PASSAGERS IS NULL
;

--------- TESTE DES ERREURS UPDATE -----------------------

UPDATE COMPAGNIE
SET COMP= 'af'
WHERE COMP= 'Go'
;
update vol_jour
    set aero_dep = null
    where num_vol = 'AF6143'
;
UPDATE VOL_JOUR
SET AERO_ARR = 'TLS'
WHERE NUM_VOL = 'AF6143'
;
UPDATE COMPAGNIE
SET NOM_COMP = 'Go Airways'
WHERE COMP = 'AF'
;
UPDATE VOL_JOUR 
SET COMP = 'EJET'
WHERE NUM_VOL = 'AF6143'
;

----------------------------- RESULTAT -------------------
/*
SQL> update vol_jour
  2      set aero_dep = null
  3      where num_vol = 'AF6143'
  4  ;

    set aero_dep = null
         *
ERROR at line 165:
ORA-01407: cannot update ("SOUTOU"."VOL_JOUR"."AERO_DEP") to NULL
SQL> UPDATE VOL_JOUR
  2  SET AERO_ARR = 'TLS'
  3  WHERE NUM_VOL = 'AF6143'
  4  ;

UPDATE VOL_JOUR
*
ERROR at line 168:
ORA-02290: check constraint (SOUTOU.CK_TRAJET) violated
SQL> UPDATE COMPAGNIE
  2  SET NOM_COMP = 'Go Airways'
  3  WHERE COMP = 'AF'
  4  ;

1 row updated.

Commit complete.

SQL> UPDATE VOL_JOUR
  2  SET COMP = 'EJET'
  3  WHERE NUM_VOL = 'AF6143'
  4  ;

UPDATE VOL_JOUR
*
ERROR at line 176:
ORA-02291: integrity constraint (SOUTOU.FK_VOL_JOUR_COMP_COMPAGNIE) violated -
 parent key not found
*/
DROP TABLE PILOTE;
CREATE TABLE PILOTE(
    brevet VARCHAR(6),
    nom VARCHAR(20),
    datenaiss DATE,
    derniervol DATE,
    dateEmbauche DATE,
    prochainVolControle DATE,
    nombreJourNaisBoulot NUMBER,
    intervallenaisboulot INTERVAL DAY(7) TO SECOND(3),
    intervallevolexterieur INTERVAL DAY(2) TO SECOND(0),
    intervalleentrevols INTERVAL DAY(2) TO SECOND(2),
    intervalleembauchecontrole INTERVAL DAY(2) TO SECOND(1),
    compa VARCHAR(4),
    CONSTRAINT pk_pilote primary key (brevet)
);

INSERT INTO PILOTE
VALUES(
    'pl-1','thierry albaric',to_date('25/03/1967','dd/mm/yyyy'),to_date('10/04/2003','dd/mm/yyyy'),SYSDATE,to_date('13/05/2003 15:30:00','dd/mm/yyyy hh24:mi:ss'),NULL,NULL,NULL,NULL,NULL,'af'
);

---modification de l'heure----
UPDATE PILOTE
SET datenaiss = TO_DATE('25/03/1967 12:35:00','dd/MM/YYYY HH24:mi:ss')
WHERE   brevet = 'pl-1'
;


------ comment afficher les heures dans le select ------
/*
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';

---------DETERMINER LES PRIVILEGES DE L'UTILISATEUR--------
 select * from  USER_SYS_PRIVS;
*/
SELECT * FROM PILOTE;m
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
select * from  USER_SYS_PRIVS;

select DATENAISS from pilote;
COMMIT;

UPDATE PILOTE
SET DATEEMBAUCHE = DATEEMBAUCHE+7+(10/(24*60))
WHERE   BREVET = 'pl-1'
;

UPDATE PILOTE
SET NOMBREJOURNAISBOULOT = DATEEMBAUCHE-DATENAISS
WHERE   BREVET = 'pl-1'
;

UPDATE PILOTE
set INTERVALLENAISBOULOT = NUMTODSINTERVAL(dateembauche-DATENAISS, 'DAY')
WHERE   BREVET = 'pl-1'
;
UPDATE PILOTE
SET INTERVALLEENTREVOLS = NUMTODSINTERVAL(PROCHAINVOLCONTROLE-DERNIERVOL,'DAY'),
    INTERVALLEVOLEXTERIEUR = NUMTODSINTERVAL(dateembauche-derniervol /*n*/,
                                             'DAY' /*'interval_unit'*/)
WHERE BREVET = 'pl-1'
;


UPDATE PILOTE
SET INTERVALLEEMBAUCHECONTROLE = INTERVALLEENTREVOLS-INTERVALLEVOLEXTERIEUR
WHERE BREVET = 'pl-1'
;
/*
ERROR at line 298:
ORA-01873: the leading precision of the interval is too small
*/

ALTER TABLE PILOTE
MODIFY  INTERVALLEEMBAUCHECONTROLE INTERVAL DAY(7) TO SECOND(2);

/*
TO_CHAR(colonneDate [. format [. 'NLS_DATE_LANGUAGE=Lan.gue' ]]) 
--convertit une date en chaîne suivant un certain format dans un certain langage;
TO_DATE(chaîneCaractères [. format [. 'NLS_DATE_LANGUAGE=Langue']])
--convertit une chaîne en date suivant un certain formatdans un certain langage ;
EXTRACT ({ YEAR | MONTH | DAY | HOUR | MINUTE | SECOND} FROM (expression-DATE | expressionINTERVAL}) 
--extrait une partie donnée d'une date ou d'un intervalle ;
NUMTOYMINTERVAL (expressionNumérique, ( 'YEAR' | 'MONTH'}) 
--convertit un nombre dans un type INTERVAL YEAR TO MONTH;
NUMTODSINTERVAL(expressionNumérique, ('DAY' | 'HOUR' | 'MINUTE' | 'SECOND' } ) 
--convertit un nombre dans un type INTERVAL DAY TO SECOND
*/
--nombre de jour entre le 1/01/-4712 et le 25/03/1967
SELECT to_char(DATENAISS,'j') 
FROM PILOTE
;
--affichage du 25/03/1967 sous forme de date
SELECT TO_CHAR(datenaiss /*n*/,
               'dl' /*fmt*/,
               'nls_date_language = french' /*'nlsparam'*/)
FROM PILOTE
;
--affichage du 25/03/1967 sous le format oracle qui n'a pas la traduction en français
SELECT TO_CHAR(datenaiss /*n*/,
               'day-month-year' /*fmt*/,
               'nls_date_language = french' /*'nlsparam'*/)
FROM PILOTE
;
--affichage du numéro du jour de l'année
SELECT TO_CHAR(DATEEMBAUCHE /*n*/,
               'DDD' /*fmt*/,
               'NLS_DATE_LANGUAGE = FRENCH' /*'nlsparam'*/)
FROM PILOTE
;
--date format americain sert aussi lors des insertions des dates au format americain
SELECT TO_DATE('may 13,1995,12:30 A.M.' /*char [ DEFAULT return_value ON CONVERSION ERROR ]*/,
               'MONTH DD,YYYY,HH:MI A.M.' /*fmt*/,
               'NLS_DATE_LANGUAGE = AMERICAN' /*'nlsparam'*/)
FROM DUAL
;
--date format français
SELECT TO_DATE('13 mai ,1995, 12:30' /*char [ DEFAULT return_value ON CONVERSION ERROR ]*/,
               'DD MONTH,YYYY, HH24:MI' /*fmt*/,
               'NLS_DATE_LANGUAGE = FRENCH' /*'nlsparam'*/)
FROM DUAL
;
--extraction des jours
SELECT EXTRACT(day from INTERVALLEVOLEXTERIEUR /*{YEAR| MONTH| DAY| HOUR| MINUTE| SECOND| TIMEZONE_HOUR| TIMEZONE_MINUTE| TIMEZONE_REGION| TIMEZONE_ABBR} FROM  {expr}*/)
FROM PILOTE
;
--extraction des mois
SELECT EXTRACT(MONTH FROM DATENAISS /*{YEAR| MONTH| DAY| HOUR| MINUTE| SECOND| TIMEZONE_HOUR| TIMEZONE_MINUTE| TIMEZONE_REGION| TIMEZONE_ABBR} FROM  {expr}*/) AS DATENAISS
FROM PILOTE
;

SELECT NUMTODSINTERVAL(1.54 /*n*/,
                       'day' /*'interval_unit'*/)
FROM DUAL
;
SELECT INTERVALLEVOLEXTERIEUR
from PILOTE
;

DELETE FROM COMPAGNIE
WHERE NOM_COMP = 'Go Airways'
;
--- EXECUTE AU CAS OU LE DELETE NE MARCHE PAS ------
/*
UPDATE COMPAGNIE
SET NOM_COMP = 'Air France'
WHERE COMP = 'AF'
;

UPDATE COMPAGNIE
SET NOM_COMP = 'Go Airways'
WHERE COMP = 'GO'
;
*/

-- Delete rows from a Table

DELETE FROM  vol_jour
WHERE jour_vol = to_date('20/11/2014 15:30','dd/mm/yyyy hh24:mi')
;

------- SYNTAXE TRUNCATE-----

----- TRUNCATE TABLE nomtable

/*  
truncate permet de supprimer toutes les valeurs d'une table et 
réinitialiser l'auto-incrémentation tandis que la commande delete
ne réinitialise pas l'auto-increment.
*/
