-- Enable DBMS_OUTPUT output to be displayed
/*
        The SET SERVEROUTPUT command specifies whether output from the
        DBMS_OUTPUT message buffer is redirected to standard output.
    */
SET SERVEROUTPUT ON;

-- Kaip spausdinti: -----------------------------------------------------
BEGIN --Neišsaugo lokaliai
    NULL;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World');
END;
/

-- Kaip deklaruoti tipus: -----------------------------------------------

DECLARE
    V_INT INTEGER;
BEGIN
    V_INT := 5;
 -- Explicitly convert the integer to a string
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(V_INT));
END;
/

-- Kaip sujungti sakinius (Concatenates character strings and CLOB data.) su ||-----------------------------------------------

DECLARE
 -- čia varcharo viduje pažymime kokio ilgio bus mūsų stringas
    NAME_USER VARCHAR2(6) := 'Greta';
BEGIN
    DBMS_OUTPUT.PUT_LINE('I am '
        || NAME_USER);
END;
/

-- Kiti tipai:----------------------------------------------------------------------------------------------

-- CHR(10) is used to insert line breaks, CHR(9) is for tabs, and CHR(13) is for carriage returns.
DECLARE
    SKAICIUS    NUMBER(4, 2) := 11.25;
    DATA_DIENOS DATE := TO_DATE('01/04/2024', 'dd/mm/yy');
    CHAR_2      CHAR(10) := 'hihi';
BEGIN
    DBMS_OUTPUT.PUT_LINE(SKAICIUS
 -- line break: chr(10)
        || CHR(10)
        || DATA_DIENOS
        || CHR(10)
        || CHAR_2);
END;
/

-- Struktūra: ---------------------------------------------------------------------------------------

-- HEADER (neprivalomas)
-- DECLARE (optional)
-- Variables, cursors, user defiened exeptions, user defined data types
-- BEGIN (mandatory- business logic)
--Sql statements
--Pl/SQL statements
-- EXCEPTION (optional)
--Actions to perform when errors occur
-- END; (mandatory)

-- Tipo atributas % ----------------------------------------------------------------------------------

-- Reikšmės įvestis: --------------------------------------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    L_STUDENT_ID NUMBER := &S_STUDENT_ID;
    L_COURSE_NO  VARCHAR2(5) := '&set_course_no';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Today is '
        || '&set_day');
    DBMS_OUTPUT.PUT_LINE('Tomorrow will be '
        || '&set_day');
END;
/

-- Jeigu nenorime matyti grąžinamos informacijos kaip įvedimas buvo atliekamas,
-- reikia naudoti SET komandą prieš vykdant PL/SQL bloką:​
-- SET VERIFY OFF;


--Bind variables: ------------------------------------------------------------------------------
ACCEPT USER_INPUT CHAR PROMPT 'Please enter a value for L_INPUT: ';

SET SERVEROUTPUT ON;

DECLARE
    L_INPUT VARCHAR2(30) := '&user_input';
BEGIN
    DBMS_OUTPUT.PUT_LINE('['
        || L_INPUT
        || ']');
END;
/

-- Stored procedure - išsaugoja DB, galima naudoti skirtingus inputus. Pagerina greitį.---------
--Procedures are named blocks and they can be reused - they are like functions
--Skirtumas toks, kad procedūra atlieka veiksmą, o funkcija kažką grąžina
--Yra part of a named block

--Jei norime modifikuoti procedūrą:
-- CREATE OR REPLACE PROCEDURE abc
-- IS|AS
-- ...
-- BEGIN
-- ...
-- END;

--Procedūras sudaro 3 parametrų modes: IN, OUT, IN OUT.
-- IN:
--Default mode - jei nieko nepaminim
--read only parameter (negalima pakeisti value)

--OUT:
--It returns a value to the calling program - pakeičia parametrą tiksliau (tokiu būdu grąžina)
--Galima pakeisti reikšmę

--EX: IN, OUT
DECLARE
    A NUMBER;
    B NUMBER;
    C NUMBER;
 --sudaugins du skaičius:
    PROCEDURE FINDMUL(
        X IN NUMBER,
        Y IN NUMBER,
        Z OUT NUMBER
    ) IS
    BEGIN
 --čia gražiai matosi, kodėl reikia IN numbers x ir y, ir OUT number z
        Z := X * Y;
    END;
BEGIN
 --čia galime priskirti values:
    A := 10;
    B := 20;
    FINDMUL(A, B, C);
 --Gausis 200
    DBMS_OUTPUT.PUT_LINE('Multiplication is '
        || C);
END;
/

--IN OUT:
--Passes an initial value to the calling program (kaip IN), bet grąžina pakeistą reikšmę

--EX: IN OUT

DECLARE
    A NUMBER;
    PROCEDURE SQUARENUM(
        X IN OUT NUMBER
    ) IS
    BEGIN
        X := X * X;
    END;
BEGIN
    A := 5;
    SQUARENUM(A);
    DBMS_OUTPUT.PUT_LINE('squared value is: '
        || A);
END;
/

--Funkcijos:------------------------------------------------------------------------------------
--Taip pat kaip procedūra - tik funkcija grąžina kažką

--Struktūra:
-- CREATE OR REPLACE FUNCTION ALL_BLOCKCHAIN_TABLES()
-- RETURN return_data_type
-- IS | AS -- Galima vieną iš šitų panaudoti
--...
-- BEGIN
-- ...
-- END;

--EX:
--Replace ten, jei norime parepleisinti sesamą funkciją, bet galima ir be to parašyti tiesiog
-- CREATE OR REPLACE FUNCTION totalCust
-- RETURN number --tieisog data type
-- IS
--     total number(2) := 0;
-- BEGIN
--     SELECT Count(*) INTO V$CELL_REQUEST_TOTALS
--     FROM Customers;
--     RETURN total;
-- END;

DECLARE
 -- Variables to hold the result
    RESULT NUMBER;
 --Funkcija pati
    FUNCTION MULTIPLYTHREENUMBERS(
        X NUMBER,
        Y NUMBER,
        Z NUMBER
    ) RETURN NUMBER IS
    BEGIN
        RETURN X * Y * Z;
    END;
BEGIN
 -- Calling the function and storing the result
    RESULT := MULTIPLYTHREENUMBERS(2, 3, 4);
 -- Output the result
    DBMS_OUTPUT.PUT_LINE('The result is: '
        || RESULT);
END;
/

--Duomenų saugojimas .txt faile. ------------------------------------------------------------------
--Tam naudojame raktažodį SPOOL
--SPOOL directory/dir/d
--... čia dedame mūsų declare begin end dalykus
--SPOOL OFF;

--EX:
SPOOL /USERS/GRETAVIRPSAITE/PL_SQL/RESULTS1.TXT;

DECLARE
    NUM    NUMBER := 4; -- Example number
    SQUARE NUMBER; -- Variable to store the square of the number
BEGIN
    SQUARE := NUM * NUM; -- Calculate square
    DBMS_OUTPUT.PUT_LINE('The square of '
        || NUM
        || ' is: '
        || SQUARE); -- Output the result
END;
/

SPOOL OFF;

--Loops in Oracle: --------------------------------------------
-- Paprasti lūpai (LOOP):
SET SERVEROUTPUT ON;

DECLARE
    I NUMBER(2);
BEGIN
    I :=1;
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
        EXIT WHEN I > 10;
    END LOOP;
END;
/

--While loop (WHILE):
SET SERVEROUTPUT ON;

DECLARE
    I NUMBER(2);
BEGIN
    I := 1;
    WHILE I <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE('i = '
            || I);
        I := I + 1;
    END LOOP;
END;
/

--For loopai (FOR):
--EX1:
SET SERVEROUTPUT ON;

DECLARE
BEGIN
    FOR I IN 1..10 LOOP --nuo 1 iki 10
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

--EX2:
SET SERVEROUTPUT ON;

DECLARE
BEGIN
    FOR I IN REVERSE 1..10 LOOP --nuo 1 iki 10
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

--STORED PROCEDURES: ------------------------------------------------------
--(paketus, proceduras, ir funkcijas)

-- PL sql blocks that are stored in the DB like objects
-- stored procedures do not return any value

--SYNTAX:
-- CREATE [OR REPLACE] PROCEDURE pro_name (para1, para2, ...)
-- IS --The body (dar čia šalia gali būti [AUTHID DEFINER | CURRENT_USER])
--     Declare STATEMENTS
-- BEGIN
--     Execute STATEMENTS
-- END procedure name;
-- /