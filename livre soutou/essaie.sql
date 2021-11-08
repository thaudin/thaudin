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

-- Create a new relational table with 3 columns

CREATE TABLE durees 
(
  dureeanneemois INTERVAL YEAR TO MONTH NOT NULL,
  dureejouurseconde INTERVAL DAY TO SECOND
);

INSERT INTO durees(
    dureeanneemois, dureejoursecondes
)VALUES(
    '1-7','5 15:13:56.17'
);

-- Alter a Relational table to drop a column

ALTER TABLE DUREES DROP 
(
  dureejouurseconde
);

-- Alter a Relational table to add a column

ALTER TABLE durees ADD
(
  dureejoursecondes interval day to SECOND
);


select * from DUAL;

SELECT CURRENT_DATE, LOCALTIMESTAMP, SYSTIMESTAMP,DBTIMEZONE FROM DUAL;

CREATE TABLE TROMBINOSCOPE(
    nometudiant VARCHAR(30),
    photo BFILE
);

CREATE DIRECTORY repertoire_etudiants AS 'D:\photo_soutou';

-- Insert rows in a Table

INSERT INTO trombinoscope 
(
  nometudiant,
  photo
)
VALUES
(
  'soutou',
  BFILENAME('repertoire_etudiants','photoCS.jpg')
);

CREATE TABLE affreter (
    numaff NUMBER(5),
    COMP VARCHAR2(4),
    IMMAT VARCHAR2(6),
    DATEAFF DATE,
    NBPAX NUMBER(3),
    CONSTRAINT pk_affreter PRIMARY KEY (numaff)
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
    INCREMENT BY 10
    START WITH 100
    MAXVALUE 100000
    NOMINVALUE  
;

-- Insert rows in a Table

INSERT INTO AFFRETER VALUES(
    seqaff.nextval,
    'af',
    'f-wtss',
    TO_DATE('13052003' /*char [ DEFAULT return_value ON CONVERSION ERROR ]*/,
            'ddmmyy' /*'nlsparam'*/),
    85
);

INSERT INTO AFFRETER VALUES(
    seqaff.nextval,
    'sing',
    'f-gafu',
    TO_DATE('05022003' /*char [ DEFAULT return_value ON CONVERSION ERROR ]*/,
            'ddmmyyyy' /*'nlsparam'*/),
    155
);

INSERT INTO PASSAGER (
    NUMPAX,NOM,SIEGE,DERNIERVOL
)VALUES(
    seqpax.nextval,'payrissat','7a',seqaff.CURRVAL
);

INSERT INTO AFFRETER VALUES(
    seqaff.nextval,'af','f_wtss',SYSDATE,85
);

INSERT INTO PASSAGER VALUES(
    seqpax.nextval,'castaings','2e',seqaff.CURRVAL
);

select*from AFFRETER;

DROP SEQUENCE seqaff;
DROP SEQUENCE seqpax;

--Create a new Sequence

CREATE SEQUENCE seqaff
    MAXVALUE 10000
    NOMINVALUE
;

DECLARE
    seq_valeur NUMBER;
BEGIN
    seq_valeur := seqaff.CURRVAL;
    DBMS_OUTPUT.PUT_LINE('Pour l''instant, il y a'||TO_CHAR(seq_valeur)||'affrétements.');
    seq_valeur := seqaff.NEXTVAL;
    INSERT INTO AFFRETER VALUES(
        seq_valeur,
        'af',
        'f-woww',
        SYSDATE-5,
        490
    );
END;

SELECT seqaff.CURRVAL FROM DUAL;

DECLARE 
    v_nom CHAR(20) := 'pierre lamothe';
BEGIN
    DELETE FROM PILOTE WHERE NOM=v_nom;
END;
commit;

CREATE TABLE segment (
  indip VARCHAR2(11),
  nomsegment VARCHAR2(20) CONSTRAINT nn_nomsegment NOT NULL,
  etage NUMBER(2),
  CONSTRAINT pk_segment PRIMARY KEY (indip)
);

CREATE TABLE salle(
    nsalle VARCHAR2(7),
    nomsalle VARCHAR2(20) CONSTRAINT nn_nomsalle NOT NULL,
    nbposte NUMBER(2),
    indip VARCHAR2(11),
    CONSTRAINT pk_salle PRIMARY KEY (nsalle)
);

CREATE TABLE poste(
    nposte VARCHAR2(7),
    nomposte VARCHAR2(20) CONSTRAINT nn_nomposte NOT NULL,
    indip VARCHAR2(11),
    ad VARCHAR2(3),
    typeposte VARCHAR2(2),
    nsalle VARCHAR2(7),
    CONSTRAINT pk_poste PRIMARY KEY (nposte),
    CONSTRAINT ck_ad CHECK (ad BETWEEN '000' AND '255')
);

CREATE TABLE logiciel(
    nlog VARCHAR2(5),
    nomlog VARCHAR2(20),
    dateach DATE,
    version VARCHAR2(7),
    typelog VARCHAR2(9),
    prix NUMBER(6,2),
    CONSTRAINT pk_logiciel PRIMARY KEY (nlog),
    CONSTRAINT ck_prix  CHECK (prix >= 0)
);

CREATE TABLE installer(
    nposte VARCHAR2(7),
    nlog VARCHAR2(5),
    numins NUMBER(5),
    dateins DATE DEFAULT SYSDATE,
    delai INTERVAL DAY(5) TO SECOND(2),
    CONSTRAINT pk_installer PRIMARY KEY (nposte,nlog)
);

CREATE TABLE types(
    typelp VARCHAR2(9),
    nomtype VARCHAR2(20),
    CONSTRAINT pk_types PRIMARY KEY (typelp)
);

-- commentaire sur les tables et les colonnes
COMMENT ON TABLE COMPAGNIE IS 'table des compagnies aériennes françaises';
COMMENT ON COLUMN COMPAGNIE.COMP IS 'code abréviation de la compagnie';
COMMENT ON COLUMN COMPAGNIE.NOM_COMP IS 'ville de la compagnie, défaut paris';
INSERT INTO Segment VALUES ('130.120.80','Brin RDC',NULL);
INSERT INTO Segment VALUES ('130.120.81','Brin 1er  étage',NULL);
INSERT INTO Segment VALUES ('130.120.82','Brin 2ème étage',NULL);

INSERT INTO Salle VALUES ('s01','Salle 1',3,'130.120.80');
INSERT INTO Salle VALUES ('s02','Salle 2',2,'130.120.80');
INSERT INTO Salle VALUES ('s03','Salle 3',2,'130.120.80');
INSERT INTO Salle VALUES ('s11','Salle 11',2,'130.120.81');
INSERT INTO Salle VALUES ('s12','Salle 12',1,'130.120.81');
INSERT INTO Salle VALUES ('s21','Salle 21',2,'130.120.82');
INSERT INTO Salle VALUES ('s22','Salle 22',0,'130.120.83');
INSERT INTO Salle VALUES ('s23','Salle 23',0,'130.120.83');

INSERT INTO poste VALUES ('p1','Poste 1','130.120.80','01','TX','s01');
INSERT INTO poste VALUES ('p2','Poste 2','130.120.80','02','UNIX','s01');
INSERT INTO poste VALUES ('p3','Poste 3','130.120.80','03','TX','s01');
INSERT INTO poste VALUES ('p4','Poste 4','130.120.80','04','PCWS','s02');
INSERT INTO poste VALUES ('p5','Poste 5','130.120.80','05','PCWS','s02');
INSERT INTO poste VALUES ('p6','Poste 6','130.120.80','06','UNIX','s03');
INSERT INTO poste VALUES ('p7','Poste 7','130.120.80','07','TX','s03');
INSERT INTO poste VALUES ('p8','Poste 8','130.120.81','01','UNIX','s11');
INSERT INTO poste VALUES ('p9','Poste 9','130.120.81','02','TX','s11');
INSERT INTO poste VALUES ('p10','Poste 10','130.120.81','03','UNIX','s12');
INSERT INTO poste VALUES ('p11','Poste 11','130.120.82','01','PCNT','s21');
INSERT INTO poste VALUES ('p12','Poste 12','130.120.82','02','PCWS','s21');

INSERT INTO logiciel VALUES 
('log1','Oracle 6',   TO_DATE('13-05-1995','DD-MM-YYYY'),'6.2','UNIX',3000);
INSERT INTO logiciel VALUES 
('log2','Oracle 8',   TO_DATE('15-09-1999','DD-MM-YYYY'),'8i','UNIX',5600);
INSERT INTO logiciel VALUES 
('log3','SQL Server', TO_DATE('12-04-1998','DD-MM-YYYY'),'7','PCNT',3000);
INSERT INTO logiciel VALUES 
('log4','Front Page', TO_DATE('03-06-1997','DD-MM-YYYY'),'5','PCWS',500);
INSERT INTO logiciel VALUES 
('log5','WinDev',     TO_DATE('12-05-1997','DD-MM-YYYY'),'5','PCWS',750);
INSERT INTO logiciel VALUES 
('log6','SQL*Net', NULL, '2.0','UNIX',500);
INSERT INTO logiciel VALUES 
('log7','I. I. S.',   TO_DATE('12-04-2002','DD-MM-YYYY'),'2','PCNT',900);
INSERT INTO logiciel VALUES 
('log8','DreamWeaver',TO_DATE('21-09-2003','DD-MM-YYYY'),'2.0','BeOS',1400);


INSERT INTO Types VALUES ('TX',  'Terminal X-Window');
INSERT INTO Types VALUES ('UNIX','Système Unix');
INSERT INTO Types VALUES ('PCNT','PC Windows  NT');
INSERT INTO Types VALUES ('PCWS','PC Windows');
INSERT INTO Types VALUES ('NC',  'Network Computer');


CREATE SEQUENCE sequenceIns
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 10000
  NOCYCLE;

INSERT INTO installer VALUES ('p2', 'log1', sequenceIns.NEXTVAL,
TO_DATE('15-05-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p2', 'log2', sequenceIns.NEXTVAL,
TO_DATE('17-09-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p4', 'log5', sequenceIns.NEXTVAL, NULL,NULL);
INSERT INTO installer VALUES ('p6', 'log6', sequenceIns.NEXTVAL,
TO_DATE('20-05-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p6', 'log1', sequenceIns.NEXTVAL,
TO_DATE('20-05-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p8', 'log2', sequenceIns.NEXTVAL,
TO_DATE('19-05-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p8', 'log6', sequenceIns.NEXTVAL,
TO_DATE('20-05-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p11','log3', sequenceIns.NEXTVAL,
TO_DATE('20-04-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p12','log4', sequenceIns.NEXTVAL,
TO_DATE('20-04-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p11','log7', sequenceIns.NEXTVAL,
TO_DATE('20-04-2003','DD-MM-YYYY'),NULL);
INSERT INTO installer VALUES ('p7', 'log7', sequenceIns.NEXTVAL,
TO_DATE('01-04-2002','DD-MM-YYYY'),NULL);

COMMIT;

SELECT * FROM Segment;

SELECT * FROM Salle;

SELECT * FROM Poste;

SELECT * FROM Logiciel;

SELECT * FROM Installer;

SELECT * FROM Types;