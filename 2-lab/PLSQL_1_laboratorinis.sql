/*
Paieškos algoritmų efektyvumo tyrimas, 
kuris susideda iš sekančių uždavinių: 

1)Realizuoti tiesinės paieškos (angl. Linear Search) algoritmą. 

2) Realizuoti dvejetainės paieškos (angl. Binary Search) algoritmą. 

3) Realizuoti dvigubo išrinkimo rūšiavimo (angl. Double Selection sort) algoritmą. 

4) Sugeneruoti n atsitiktinių skaičių seką ir ją surūšiuoti, naudojantis anksčiau
realizuotu rūšiavimo algoritmu. 

5) Nesurūšiuoto masyvo elementus surasti surūšiuotame masyve tiesinės ir dvejetainės
paieškos algoritmais, užfiksuojant per kiek iteracijų buvo surastas norimas elementas.
(Paieškos rezultatų masyvas galėtų būti sudarytas iš įrašų, kurio struktūra – 
ieškomas elementas ir paieškos iteracijų skaičius.) 

6) Naudojantis anksčiau gautais rezultatais, surasti vidutinį iteracijų skaičių
abejiems algoritmams (t.y. iteracijų suma/ieškotų elementų kiekio). 

Gautus rezultatus (pradinis masyvas, surūšiuotas masyvas ir vidutinius iteracijų
skaičius abiem paieškos algoritmams) išvesti į ekraną ir rezultatų tekstinį failą. 


Dvigubo išrinkimo algoritmo idėja - iš turimo skaičių sąrašo išrenkamas mažiausias
ir didžiausias elementas ir rašomas į pirmą vietą, bei paskutinę vietą (sukeičiant
pirmoje vietoje esantį elementą su rastu minimaliu ir paskutinėje vietoje esantį
elementą su didžiausiu). Po to tas pats principas taikomas sąrašui be pirmojo ir
paskutinio elemento, ir t.t. kol sąrašas tampa tuščias.

*/

SPOOL /USERS/GRETAVIRPSAITE/PL_SQL/RESULTS_LAB1.TXT;

SET SERVEROUTPUT ON;

DECLARE
 ----------------------------------------------------------------------------------------------------------
 -- Function to generate a single random number
    FUNCTION GENERATERANDOMNUMBER RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(DBMS_RANDOM.VALUE(1, 100)); --Čia generuojame skaičius nuo ą iki 9
    END GENERATERANDOMNUMBER;
 --------------------------------------------------------------------------------------------------------
 -- Procedure to generate n random numbers and print them
    PROCEDURE GENERATEANDPRINTNUMBERS(
        N IN NUMBER
    ) IS
        OUTPUT_LINE VARCHAR2(4000) := '';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Sugeneruoti skaičiai: ');
        FOR I IN 1..N LOOP
 -- Use the function to generate a random number and append it to the output line
            OUTPUT_LINE := OUTPUT_LINE
                || GENERATERANDOMNUMBER
                || ' | ';
        END LOOP;
 -- Print the formatted string of numbers
        DBMS_OUTPUT.PUT_LINE('| '
            || OUTPUT_LINE);
    END GENERATEANDPRINTNUMBERS;
 --------------------------------------------------------------------------------------------------------
BEGIN
 -- Generate and print 10 random numbers
    GENERATEANDPRINTNUMBERS(20);
END;
/

SPOOL OFF;


-- SPOOL /USERS/GRETAVIRPSAITE/PL_SQL/RESULTS.TXT;

-- SET SERVEROUTPUT ON;

-- DECLARE
--  --Realizuoti tiesinės paieškos (angl. Linear Search) algoritmą. --------------------------
--     FUNCTION LINEARSEARCH(
--         ARR IN NUMBER,
--         SEARCH_ELEMENT IN NUMBER
--     ) RETURN NUMBER IS
--     BEGIN
--         FOR I IN 1 .. ARR.COUNT LOOP
--             IF ARR(I) = SEARCH_ELEMENT THEN
--                 RETURN I; -- Gra=inamas rasto elemnto indeksas
--             END IF;
--         END LOOP;
--         RETURN -1; -- Nerastas elements
--     END; --2) Realizuoti dvejetainės paieškos (angl. Binary Search) algoritmą. -------------------
--     FUNCTION BINARYSEARCH(
--         ARR IN NUMBER,
--         SEARCH_ELEMENT IN NUMBER
--     ) RETURN NUMBER IS
--         LOW  NUMBER := 1;
--         HIGH NUMBER := ARR.COUNT;
--         MID  NUMBER;
--     BEGIN
--         WHILE LOW <= HIGH LOOP
--             MID := TRUNC((LOW + HIGH) / 2);
--             IF ARR(MID) < SEARCH_ELEMENT THEN
--                 LOW := MID + 1;
--             ELSIF ARR(MID) > SEARCH_ELEMENT THEN
--                 HIGH := MID - 1;
--             ELSE
--                 RETURN MID; -- Nerastas elementas
--             END IF;
--         END LOOP;
--         RETURN -1; -- Nerastas elementas
--     END;
--  --3) Realizuoti dvigubo išrinkimo rūšiavimo (angl. Double Selection sort) algoritmą.----------
--     PROCEDURE DOUBLESELECTIONSORT(
--         ARR IN OUT NUMBER
--     ) IS
--         MININDEX NUMBER;
--         MAXINDEX NUMBER;
--         TEMP     NUMBER;
--     BEGIN
--         FOR I IN 1 .. TRUNC(ARR.COUNT / 2) LOOP
--             MININDEX := I;
--             MAXINDEX := I;
--             FOR J IN I .. ARR.COUNT - I + 1 LOOP
--                 IF ARR(J) < ARR(MININDEX) THEN
--                     MININDEX := J;
--                 END IF;
--                 IF ARR(J) > ARR(MAXINDEX) THEN
--                     MAXINDEX := J;
--                 END IF;
--             END LOOP;
--  -- Apkeičiam min elementą su start
--             TEMP := ARR(I);
--             ARR(I) := ARR(MININDEX);
--             ARR(MININDEX) := TEMP;
--  -- Patikslinam maxIndex jei jis būtų pajudintas
--             IF MAXINDEX = I THEN
--                 MAXINDEX := MININDEX;
--             END IF;
--  -- Apkeičiam max elementą su end
--             TEMP := ARR(ARR.COUNT - I + 1);
--             ARR(ARR.COUNT - I + 1) := ARR(MAXINDEX);
--             ARR(MAXINDEX) := TEMP;
--         END LOOP;
--     END;
--  --Bandome sudaryti būdą duomenims: ---------------------------------------------------
--     TYPE NUMBERARRAY IS
--         TABLE OF INTEGER INDEX BY PLS_INTEGER;
--     MY_NUMBERS NUMBERARRAY;
--  -- Assuming Is_unique checks if a given number is unique in the array
--     FUNCTION IS_UNIQUE(
--         NEW_NUMBER IN INTEGER,
--         ARR IN NUMBERARRAY
--     ) RETURN BOOLEAN IS
--     BEGIN
--         FOR I IN ARR.FIRST..ARR.LAST LOOP
--             IF ARR.EXISTS(I) THEN
--                 IF ARR(I) = NEW_NUMBER THEN
--                     RETURN FALSE; -- Found a duplicate
--                 END IF;
--             END IF;
--         END LOOP;
--         RETURN TRUE; -- No duplicates found
--     END;
--  -- Procedure to generate unique random numbers
--     PROCEDURE GENERATING_RANDOM_NUMBERS(
--         MAX_NUMBERS IN INTEGER,
--         ARR IN OUT NUMBERARRAY
--     ) IS
--         NEW_NUMBER       INTEGER;
--         MIN_RANDOM_VALUE INTEGER := 1;
--         MAX_RANDOM_VALUE INTEGER := 30;
--     BEGIN
--         FOR I IN 1 .. MAX_NUMBERS LOOP
--             LOOP
--                 NEW_NUMBER := TRUNC(DBMS_RANDOM.VALUE(MIN_RANDOM_VALUE, MAX_RANDOM_VALUE));
--                 EXIT WHEN IS_UNIQUE(NEW_NUMBER, ARR);
--             END LOOP;
--             ARR(I) := NEW_NUMBER;
--         END LOOP;
--     END;
-- BEGIN
-- END;
-- SPOOL OF;