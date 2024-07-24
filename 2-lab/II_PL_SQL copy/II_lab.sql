--laboratorinis darbas II

/*
Perrašyti I užduotyje sukurtą anoniminį bloką į išsaugotas paprogrames (paketus, procedūras ir funkcijas):
    -kodas yra centralizuotas, struktūrizuotas, lengvai skaitomas ir vystomas/keičiamas
    -vengti kodo dubliavimo ir “hard code“

Pridėti klaidų apdorojimo dalį pirmame punkte sukurtose paprogramėse:
    -deklaruoti, inicijuoti ir apdoroti bent 3 programuotojo apibrėžtas klaidas ir bent 3 Oracle apibrėžtas klaidas
    -sukurti klaidų apdorojimui naudojamą paketą, kuriame būtų visas reikalingas funkcionalumas:
        -apibrėžtos išimtinės situacijos
        -klaidos inicijavimas
        -informacijos apie klaidą išsaugojimas
        -klaidos teksto pagal numerį suradimas ir pan. 
    -apie įvykusias klaidas išsaugoti informaciją:
        -klaidos kodas ir klaidos pranešimas
        -paprogramos savininkas, paprogramės pavadinimas ir eilutės numeris (arba visas FORMAT_ERROR_BACKTRACE)
        -vartotojas, kuris inicijavo klaidą ir kada
*/

SPOOL /USERS/GRETAVIRPSAITE/PL_SQL/RESULTS_LAB5.TXT;

SET SERVEROUTPUT ON;

DECLARE
 --Padarau naują tipą (composite data type). Čia mano array realiai, kur dėsiu skaičius, tai tipas skaitinis
    TYPE NUMBERTABLE IS
        TABLE OF NUMBER(3) INDEX BY PLS_INTEGER; --Taip ir galima pažymėti dydį
    NUMBERS        NUMBERTABLE; --Čia eis mano paprasti skaičiai
    SORTED_NUMBERS NUMBERTABLE; --Čia eis mano surūšiuoti skaičiai
 --Generate numbers
 -- FUNCTION GENERATE_NUMBERS(
 --     N IN NUMBER
 -- ) RETURN NUMBERTABLE IS
 --     NUMBERS NUMBERTABLE;
 -- BEGIN
 --     FOR I IN 1..N LOOP
 --         NUMBERS(I) := GENERATE_RANDOM_NUMER;
 --Sudedam į arrays suindeksuotus skaičius
 -- sortedNumbers(i) := numbers(i); --Dėsim vėliau surūšiuotus
 -- END LOOP;
 -- SORTEDNUMBERS := NUMBERS; --vietoj 22
 --     RETURN NUMBERS;
 -- END;
 --random_num NUMBER;
 --Atspausdinu skaičius, kurie sudėti array
 --     PROCEDURE PRINTNUMBERS(
 --         ARR IN NUMBERTABLE
 --     ) IS
 --  --Dedam į stringą mūsų norimus atspausdinti skaičius
 --         OUTPUT_LINE VARCHAR2(4000) := ''; --čia gal ir mažesnį galima būtų imti
 --     BEGIN
 --         FOR I IN ARR.FIRST..ARR.LAST LOOP --Bandome paimti i'tajį elementą iš sąrašo nuo pirmo iki paskutinio
 --             OUTPUT_LINE := OUTPUT_LINE
 --                 || ARR(I)
 --                 || ' | ';
 --         END LOOP;
 --         DBMS_OUTPUT.PUT_LINE('| '
 --             || OUTPUT_LINE);
 --     END PRINTNUMBERS;
 --Mano Double Selection Sort - arba smagiau Cocktail Sort :))-------------------------------
 --     FUNCTION DOUBLESELECTIONSORT(
 --         ARR IN NUMBERTABLE
 --     ) RETURN NUMBERTABLE IS
 --         TMP          NUMBER;
 --  --kur eis maži ir dideli skaičiai (kairė/dešinė)
 --         MIN_INDEX    PLS_INTEGER;
 --         MAX_INDEX    PLS_INTEGER;
 --         SORTED_ARRAY NUMBERTABLE;
 --     BEGIN
 --         FOR I IN 1..ARR.COUNT/2 LOOP --skaičiuojame iki vidurio
 --             MIN_INDEX := I;
 --             MAX_INDEX := I;
 --             FOR J IN I..ARR.COUNT-I+1 LOOP --pajudinam paiešką į kitą poz (ne ten kur maži ar dideli sk)
 --                 IF ARR(J) < ARR(MIN_INDEX) THEN --dedam į kairį šoną prie mažų
 --                     MIN_INDEX := J;
 --                 END IF;
 --                 IF ARR(J) > ARR(MAX_INDEX) THEN --dedam į dešinį šoną prie didelių
 --                     MAX_INDEX := J;
 --                 END IF;
 --             END LOOP;
 --  --Čia metam į priekį mažiausią
 --             TMP := ARR(MIN_INDEX); --Temp value (laikyti prieš nusprendžiant kur dėti)
 --             ARR(MIN_INDEX) := ARR(I);
 --             ARR(I) := TMP;
 --  --Tikrinam ar ne blogai numetėm auksčiausią skaičių pabaigoje, kai mažiausias jau kairėje
 --             IF MAX_INDEX = ARR.COUNT-I+1 THEN
 --                 MAX_INDEX := MIN_INDEX;
 --             END IF;
 --  --Čia į galą numetam didžiausią
 --             TMP := ARR(MAX_INDEX);
 --             ARR(MAX_INDEX) := ARR(ARR.COUNT-I+1);
 --             ARR(ARR.COUNT-I+1) := TMP;
 --         END LOOP;
 --         RETURN ARR;
 --     END;
 --Linear search --------------------------------------------------------------------
 --Target yra mano ieškomas skaičius
    FUNCTION LINEARSEARCH(
        ARR IN NUMBERTABLE,
        TARGET IN NUMBER
    ) RETURN PLS_INTEGER IS
        ITERATIONS PLS_INTEGER := 0; --Sakėt berods, kad greitesnis ir mažiau vietos užima, tai panaudojau
    BEGIN
        FOR I IN ARR.FIRST..ARR.LAST LOOP --Paprastas cikliukas - einam pro kiekvieną skaičių
            ITERATIONS := ITERATIONS + 1;
            IF ARR(I) = TARGET THEN
                RETURN ITERATIONS;
            END IF;
        END LOOP;
        RETURN ITERATIONS;
    END LINEARSEARCH;
 --Binary search ---------------------------------------------------------------------
    FUNCTION BINARYSEARCH(
        ARR IN NUMBERTABLE,
        TARGET IN NUMBER
    ) RETURN PLS_INTEGER IS
        LOW        PLS_INTEGER := ARR.FIRST;
        HIGH       PLS_INTEGER := ARR.LAST;
        MID        PLS_INTEGER;
        ITERATIONS PLS_INTEGER := 0;
    BEGIN
        WHILE LOW <= HIGH LOOP --Kad neliktų 1 sk, nes jei tik vienas,tai turėtų palikti 1 iteraciją, vadinasi radom savo sk
            ITERATIONS := ITERATIONS + 1;
            MID := (LOW + HIGH) / 2; --Formulė kaip eiti toliau, kai
            IF ARR(MID) < TARGET THEN
                LOW := MID + 1;
            ELSIF ARR(MID) > TARGET THEN
                HIGH := MID - 1;
            ELSE
                RETURN ITERATIONS;
            END IF;
        END LOOP;
        RETURN ITERATIONS;
    END BINARYSEARCH;
 -- Atprintina mano visas norimas reikšmes po skaičiavimų, palygina kuris it sk didesnis --------
    PROCEDURE SEARCHANDPRINTITERATIONS IS
        TOTALITERATIONSLINEAR    PLS_INTEGER := 0;
        TOTALITERATIONSBINARY    PLS_INTEGER := 0;
        AVGITERATIONSLINEAR      NUMBER; --Naudoju NUMBER, nes reikia tiksliau paskaičiuoti (bent manau taip statistiškai tiksliau)
        AVGITERATIONSBINARY      NUMBER;
        LINEAR_SEARCH_ITERATIONS PLS_INTEGER;
        BINARY_SEARCH_ITERATIONS PLS_INTEGER;
    BEGIN
        FOR I IN NUMBERS.FIRST..NUMBERS.LAST LOOP
 --
 -- Guaname linear search iteraciju kiek
            LINEAR_SEARCH_ITERATIONS := LINEARSEARCH(SORTED_NUMBERS, NUMBERS(I));
            TOTALITERATIONSLINEAR := TOTALITERATIONSLINEAR + LINEAR_SEARCH_ITERATIONS;
            DBMS_OUTPUT.PUT_LINE('Number: '
                || TO_CHAR(NUMBERS(I))
                || ' found in: '
                || TO_CHAR(LINEAR_SEARCH_ITERATIONS)
                || ' iterations with linear search.' );
 --
 -- Guaname binary search iteraciju kieki
            BINARY_SEARCH_ITERATIONS := BINARYSEARCH(SORTED_NUMBERS, NUMBERS(I));
            TOTALITERATIONSBINARY := TOTALITERATIONSBINARY + BINARY_SEARCH_ITERATIONS;
            DBMS_OUTPUT.PUT_LINE('Number: '
                || TO_CHAR(NUMBERS(I))
                || ' found in: '
                || TO_CHAR(BINARY_SEARCH_ITERATIONS)
                || ' iterations with binary search.' );
        END LOOP;
        AVGITERATIONSLINEAR := TOTALITERATIONSLINEAR / NUMBERS.COUNT;
        AVGITERATIONSBINARY := TOTALITERATIONSBINARY / NUMBERS.COUNT;
        DBMS_OUTPUT.PUT_LINE('Avg - Linear Search: '
            || TO_CHAR(AVGITERATIONSLINEAR));
        DBMS_OUTPUT.PUT_LINE('Avg - Binary Search: '
            || TO_CHAR(AVGITERATIONSBINARY));
        DBMS_OUTPUT.PUT_LINE('Palyginimas: Linear Search reikia '
            || TO_CHAR(AVGITERATIONSLINEAR - AVGITERATIONSBINARY)
            || ' daugiau iteracijų (by average) nei Binry Search.');
    END SEARCHANDPRINTITERATIONS; -- Procedura kuri atspausdina iteracijas
BEGIN
 --Pasirinkau 20 skaičių (manau ir 10 u=tenka, tiesiog manau aiškiau matosi su didesniu arr)
    NUMBERS := GENERATE_NUMBERS(10);
    DBMS_OUTPUT .PUT_LINE('Nesurūšiuotas sąrašas:');
    PRINTNUMBERS (NUMBERS);
    SORTED_NUMBERS := NUMBERS;
    SORTED_NUMBERS := DOUBLESELECTIONSORT (NUMBERS);
    DBMS_OUTPUT .PUT_LINE('Surūšiuotas sąrašas:');
    PRINTNUMBERS (SORTED_NUMBERS);
    SEARCHANDPRINTITERATIONS;
END;
/

SPOOL OFF;