SET SERVEROUTPUT ON
SET VERIFY OFF

ACCEPT s_nLog        PROMPT 'Numéro de logiciel : '
ACCEPT s_nomLog      PROMPT 'Nom du logiciel    : '
ACCEPT s_version     PROMPT 'Version du logiciel : '
ACCEPT s_typeLog     PROMPT 'Type du logiciel    : '
ACCEPT s_prix        PROMPT 'Prix du logiciel (en euros) : '


DECLARE
  v_nPoste Poste.nPoste%TYPE := 'p7';
  v_dateAchat DATE;
BEGIN
--Insère dans Logiciel
  INSERT INTO Logiciel
    VALUES ('&s_nLog','&s_nomLog',SYSDATE,'&s_version','&s_typeLog','&s_prix',0) ;
  DBMS_OUTPUT.PUT_LINE('Logiciel inséré dans la base');
--récupère la date de l'achat
  SELECT dateach INTO v_dateAchat FROM Logiciel WHERE nLog = '&s_nLog';
  DBMS_OUTPUT.PUT_LINE('Date achat : ' || TO_CHAR(v_dateAchat,'DD-MM-YYYY HH24:MI:SS'));
--On attend 5 petites secondes
  DBMS_LOCK.SLEEP (5);
--Insère dans Installer
  DBMS_OUTPUT.PUT_LINE('Date installation : ' || TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SS'));
  INSERT INTO Installer 
     VALUES (v_nPoste, '&s_nLog', sequenceIns.NEXTVAL, SYSDATE,
              NUMTODSINTERVAL(SYSDATE-v_dateAchat,'SECOND'));
 DBMS_OUTPUT.PUT_LINE('Logiciel installé sur le poste');
 COMMIT;
END;
/