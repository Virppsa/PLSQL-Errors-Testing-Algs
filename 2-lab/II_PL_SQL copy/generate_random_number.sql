--Package specification:
CREATE OR REPLACE PACKAGE RANDOM_NUMBERS_ARRAY IS
 -- Function to generate an array of random numbers and return it
    FUNCTION GENERATE_RANDOM_NUMBER RETURN NUMBER;
    FUNCTION GENERATE_NUMBERS(
        N IN NUMBER
    ) RETURN NUMBER_TABLE.NUMBERTABLE;
END RANDOM_NUMBERS_ARRAY;
/

-- Package body:
CREATE OR REPLACE PACKAGE BODY RANDOM_NUMBERS_ARRAY IS
 -- Function to generate a single random number
    FUNCTION GENERATE_RANDOM_NUMBER RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(DBMS_RANDOM.VALUE(1, 100)); -- Generates random integers from 1 to 99
    END GENERATE_RANDOM_NUMBER; -- Function to generate an array of random numbers and return it
    FUNCTION GENERATE_NUMBERS(
        N IN NUMBER
    ) RETURN NUMBER_TABLE.NUMBERTABLE IS
        NUMBERS NUMBER_TABLE.NUMBERTABLE := NUMBER_TABLE.NUMBERTABLE(); -- Initialize the collection
    BEGIN
        FOR I IN 1..N LOOP
            NUMBERS.EXTEND; -- Extend the collection to accommodate new elements
            NUMBERS(NUMBERS.LAST) := GENERATE_RANDOM_NUMBER; -- Fill the array with random numbers
        END LOOP;
        RETURN NUMBERS; -- Return the populated array
    END GENERATE_NUMBERS;
END RANDOM_NUMBERS_ARRAY;
/

-- DECLARE
--     NUMBERS NUMBER_TABLE.NUMBERTABLE;
-- BEGIN
--     NUMBERS := RANDOM_NUMBERS_ARRAY.GENERATE_NUMBERS(10);
--     DBMS_OUTPUT .PUT_LINE('Nesurūšiuotas sąrašas:');
--  -- DBMS_OUTPUT .PUT_LINE(NUMBERS(1));
-- END;
-- /

--   --Sudedam į array
--     PROCEDURE GENERATENUMBERS(
--         N IN NUMBER
--     ) IS
--     BEGIN
--         FOR I IN 1..N LOOP
--             NUMBERS(I) := GENERATERANDOMNUMBER; --Sudedam į arrays suindeksuotus skaičius
--  -- sortedNumbers(i) := numbers(i); --Dėsim vėliau surūšiuotus
--         END LOOP;
--         SORTEDNUMBERS := NUMBERS; --vietoj 22
--     END GENERATENUMBERS;