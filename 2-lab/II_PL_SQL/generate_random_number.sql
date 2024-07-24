CREATE OR REPLACE PACKAGE RANDOM_NUMBERS_ARRAY IS
 --F'ja generuoti skaičiui
    FUNCTION GENERATE_RANDOM_NUMBER RETURN NUMBER;
 --F'ja generuoti mąsyvui
    FUNCTION GENERATE_NUMBERS(
        N IN NUMBER
    ) RETURN NUMBER_TABLE.NUMBERTABLE;
END RANDOM_NUMBERS_ARRAY;
/

CREATE OR REPLACE PACKAGE BODY RANDOM_NUMBERS_ARRAY IS
 --F'ja generuoti skaičiui
    FUNCTION GENERATE_RANDOM_NUMBER RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(DBMS_RANDOM.VALUE(1, 100));
    END GENERATE_RANDOM_NUMBER; --
 --F'ja generuoti mąsyvui
    FUNCTION GENERATE_NUMBERS(
        N IN NUMBER
    ) RETURN NUMBER_TABLE.NUMBERTABLE IS
        NUMBERS NUMBER_TABLE.NUMBERTABLE := NUMBER_TABLE.NUMBERTABLE();
    BEGIN
        IF N < 1 THEN
            RAISE G_ERROR_HANDLING.NEGATIVE_ARRAY_EXCEPTION; --ištrinti main savo exeption su value
        END IF;
        FOR I IN 1..N LOOP
            NUMBERS.EXTEND;
            NUMBERS(NUMBERS.LAST) := GENERATE_RANDOM_NUMBER;
        END LOOP;
        RETURN NUMBERS;
    EXCEPTION
        WHEN G_ERROR_HANDLING.NEGATIVE_ARRAY_EXCEPTION THEN
            G_ERROR_HANDLING.LOG_ERROR(); --Vidinės dalies nemesti
            RETURN NUMBER_TABLE.NUMBERTABLE();
        WHEN OTHERS THEN
            G_ERROR_HANDLING.LOG_ERROR();
            RAISE;
    END GENERATE_NUMBERS; --
 --
END RANDOM_NUMBERS_ARRAY;
/

--Klaidos kodas susietas su klaidos pasiekimu, ne tekstas svarbiausia
--Kaip susieti klaidos kodą su klaidos pasiekimu (get error mesage - paduodamas klaidos kodas ir tada atrinkti klaidą )

--Kai norėdavau pamatyti kas nutiko lentelėje
-- SELECT
--     LINE,
--     POSITION,
--     TEXT
-- FROM
--     USER_ERRORS
-- WHERE
--     NAME = 'ALGORYTHMS'
-- ORDER BY
--     SEQUENCE;