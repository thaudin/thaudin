
CREATE USER         soutou
       IDENTIFIED BY mouton
       DEFAULT TABLESPACE users
       QUOTA 10M ON      users;


GRANT CONNECT, RESOURCE TO eyrolles;