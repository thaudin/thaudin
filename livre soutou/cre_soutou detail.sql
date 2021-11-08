-------resousdre le probléme de caractére accentuè sur oracle -------
-- premierement ouvrir l'editeur de registre 
/* taper "regedit" dans la barre de recherche windows*/
-- atteindre le paramétre NLS_LANG
/* sélectionner "oracle"
    -> selectionner "hkey_local_machine"
      -> selectionner "software"
         -> selectionner "software"
            ->selectionner"key_oradb12home1"
        FRENCH_FRANCE.WE8PC850
*/
--modifier le paramétre NLS_LANG
/*
 selectionner dans le registre "NLS_LANG"
 modifier sa valeur en "FRENCH_FRANCE.WE8PC850"
*/


CREATE USER  soutou
       IDENTIFIED BY mouton
       DEFAULT TABLESPACE users
       QUOTA 10M ON      users;
GRANT CONNECT, RESOURCE;


------ cette syntaxe sur oracle 12c donne une erreur ------

/*
  car sur oracle 12c à cause du multitenant il existe lors de l'installation 3 connexions
  ou pluggin (pdb$seed; orclpdb;cdb$root)et c'est cette derniere qui est par défaut 
  activé lors de l'installation et le soucis c'est que elle ne permet pas la création de
  nouvel utilisateur pour y remédier on chemine comme suit:
*/


------ on cherche d'abord sur quel pluggin notre base est connecté ------
/*
   show con_name

   CON_NAME
   ------------------------------
   CDB$ROOT
*/

------- ensuite on recherche les différents pluggins disponible -------
/*
  SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 ORCLPDB                        MOUNTED

---- cette commande peut retourner une erreur si on est pas connecté en tant que SYSDBA
        "SP2-0382: La commande SHOW PDBS n'est pas disponible" 
*/

-----connexion en tant que admin--------
/* SQL> conn sys/mouton AS sysdba */

----- on change le statut du pluggin orclpdb  pour l'ouvrir-----
/*
  SQL> alter pluggable database orclpdb open;

  Base de donnÚes pluggable modifiÚe.
*/

----- on vérifie si notre manipulation a marché -----
/*
  SQL> show pdbs

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 ORCLPDB                    --- READ WRITE NO----

" orclpdb est maintenant en  READ WRITE NO" 
*/

----- on change alors le pluggin de notre session pour orclpdb-----
/*
  SQL> ALTER SESSION SET container=orclpdb;

  Session modifiÚe.
*/

----------On va ensuite procéder au vérification suivante--------
---- on vérifie si les services sont bien démarrés

/*
ouvrir le gestionnaire de services et vérifier les services 
--OracleOraDB12Home1TNSListener est démarré
--OracleServiceORCL est démarré
*/

---- on vérifie les status du listener dans le terminal 
/* lsnrctl status*/
-- si tout va bien on devrait alors avoir la réponse suivante
/*
LSNRCTL for 64-bit Windows: Version 12.2.0.1.0 - Production on 10-JUIN -2021 16:30:50

Copyright (c) 1991, 2016, Oracle.  All rights reserved.

Connexion à (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1522)))
STATUT du PROCESSUS D'ECOUTE
------------------------
Alias                     LISTENER
Version                   TNSLSNR for 64-bit Windows: Version 12.2.0.1.0 - Production
Date de départ                       10-JUIN -2021 13:45:21
Durée d'activité                    0 jours 2 heures 45 min. 43 sec
Niveau de trace           off
Sécurité                  ON: Local OS Authentication
SNMP                      OFF
Fichier de paramètres du processus d'écoute     C:\app\liapoui\virtual\product\12.2.0\dbhome_1\network\admin\listener.ora
Fichier journal du processus d'écoute             C:\app\liapoui\virtual\diag\tnslsnr\liapoui-PC\listener\alert\log.xml
Récapitulatif d'écoute des points d'extrémité...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=127.0.0.1)(PORT=1522)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(PIPENAME=\\.\pipe\EXTPROC1522ipc)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=liapoui-PC)(PORT=5500))(Security=(my_wallet_directory=C:\APP\LIAPOUI\VIRTUAL\admin\orcl\xdb_wallet))(Presentation=HTTP)(Session=RAW))
Récapitulatif services...
Le service "312a7deb47274f8291fb5e3a736feae8" comporte 1 instance(s).
  L'instance "orcl", statut READY, comporte 1 gestionnaire(s) pour ce service...
Le service "CLRExtProc" comporte 1 instance(s).
  L'instance "CLRExtProc", statut UNKNOWN, comporte 1 gestionnaire(s) pour ce service...
Le service "orcl" comporte 1 instance(s).
  L'instance "orcl", statut READY, comporte 1 gestionnaire(s) pour ce service...
Le service "orclXDB" comporte 1 instance(s).
  L'instance "orcl", statut READY, comporte 1 gestionnaire(s) pour ce service...
Le service "orclpdb" comporte 1 instance(s).
  L'instance "orcl", statut READY, comporte 1 gestionnaire(s) pour ce service...
La commande a réussi

-- si on arrive à ce résultat alors le probleme vient soit "des informations dans le fichier tnsnames.ora"

ORCLPDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1522))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = orclpdb)
    )
  )
-- le principe ici est de donner aux instances "SERVICE_NAME" le même nom que le pluggin pdb dans notre cas ="ORCLPDB"
-- et aussi s'assurer que la variable de connection a le même nom que le pluggin pdb qui dans notre "ORCLPDB"

-- soit de la variable d'environnement 

*/

---- si on arrive à ce résultat alors le probleme vient soit "des informations dans le fichier tnsnames.ora"
-- soit de la variable d'environnement 
/*
au quel cas il vaut 
*/
/*
Set the TNS_Admin environment variable if it is not set

    Navigate to Control Panel > System
    Select Advanced System Settings
    In the Advanced tab, select Environment Variables
    Under System Variables, click New
    In the Variable name text box, type TNS_ADMIN
    In the Variable value text box, type the location of the TNSNames.ora file
    Click OK to add the variable
    Restart the server

*/
/*
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = CLRExtProc)
      (ORACLE_HOME = C:\app\liapoui\virtual\product\12.2.0\dbhome_1)
      (PROGRAM = extproc)
      (ENVS = "EXTPROC_DLLS=ONLY:C:\app\liapoui\virtual\product\12.2.0\dbhome_1\bin\oraclr12.dll")
    )
  )
*/





