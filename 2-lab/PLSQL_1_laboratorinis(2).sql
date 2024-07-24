SPOOL /USERS/GRETAVIRPSAITE/PL_SQL/RESULTS_LAB3.TXT;

SET SERVEROUTPUT ON;

DECLARE
    TYPE NUMBERTABLE IS
        TABLE OF NUMBER INDEX BY PLS_INTEGER;
    NUMBERS       NUMBERTABLE;
    SORTEDNUMBERS NUMBERTABLE;
 -- Function to generate a single random number
    FUNCTION GENERATERANDOMNUMBER RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(DBMS_RANDOM.VALUE(1, 9)); -- Generates numbers from 1 to 9
    END GENERATERANDOMNUMBER; -- Procedure to generate n random numbers
    PROCEDURE GENERATENUMBERS(
        N IN NUMBER
    ) IS
    BEGIN
        FOR I IN 1..N LOOP
            NUMBERS(I) := GENERATERANDOMNUMBER;
            SORTEDNUMBERS(I) := NUMBERS(I); -- Copy to sortedNumbers for later sorting
        END LOOP;
    END GENERATENUMBERS;
 -- Procedure to print numbers from the array
    PROCEDURE PRINTNUMBERS(
        ARR IN NUMBERTABLE
    ) IS
        OUTPUT_LINE VARCHAR2(4000) := '';
    BEGIN
        FOR I IN 1..ARR.COUNT LOOP
            OUTPUT_LINE := OUTPUT_LINE
                || ARR(I)
                || ' | ';
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('| '
            || OUTPUT_LINE);
    END PRINTNUMBERS;
 -- Double Selection Sort Algorithm
    PROCEDURE DOUBLESELECTIONSORT(
        ARR IN OUT NUMBERTABLE
    ) IS
        TMP       NUMBER;
        MIN_INDEX PLS_INTEGER;
        MAX_INDEX PLS_INTEGER;
        N         PLS_INTEGER := ARR.COUNT;
    BEGIN
        FOR I IN 1..N/2 LOOP
            MIN_INDEX := I;
            MAX_INDEX := I;
            FOR J IN I..N-I+1 LOOP
                IF ARR(J) < ARR(MIN_INDEX) THEN
                    MIN_INDEX := J;
                END IF;
                IF ARR(J) > ARR(MAX_INDEX) THEN
                    MAX_INDEX := J;
                END IF;
            END LOOP;
 -- Swap min element with start
            TMP := ARR(MIN_INDEX);
            ARR(MIN_INDEX) := ARR(I);
            ARR(I) := TMP;
            IF MAX_INDEX = I THEN
                MAX_INDEX := MIN_INDEX;
            END IF;
 -- Swap max element with end
            TMP := ARR(MAX_INDEX);
            ARR(MAX_INDEX) := ARR(N-I+1);
            ARR(N-I+1) := TMP;
        END LOOP;
    END DOUBLESELECTIONSORT;
 -- Linear Search Algorithm
    FUNCTION LINEARSEARCH(
        ARR IN NUMBERTABLE,
        TARGET IN NUMBER
    ) RETURN PLS_INTEGER IS
        ITERATIONS PLS_INTEGER := 0;
    BEGIN
        FOR I IN 1..ARR.COUNT LOOP
            ITERATIONS := ITERATIONS + 1;
            IF ARR(I) = TARGET THEN
                RETURN ITERATIONS; -- Found target, return iterations
            END IF;
        END LOOP;
        RETURN 0; -- Target not found
    END LINEARSEARCH; -- Procedure to perform linear search for each element of the original array in the sorted array
 ------------------------------------------------------- BINARY SEARCH -------------------
 -- Function for Binary Search algorithm
    FUNCTION BINARYSEARCH(
        ARR IN NUMBERTABLE,
        TARGET IN NUMBER
    ) RETURN PLS_INTEGER IS
        LOW        PLS_INTEGER := ARR.FIRST;
        HIGH       PLS_INTEGER := ARR.LAST;
        MID        PLS_INTEGER;
        ITERATIONS PLS_INTEGER := 0;
    BEGIN
        WHILE LOW <= HIGH LOOP
            ITERATIONS := ITERATIONS + 1;
            MID := TRUNC((LOW + HIGH) / 2);
            IF ARR(MID) < TARGET THEN
                LOW := MID + 1;
            ELSIF ARR(MID) > TARGET THEN
                HIGH := MID - 1;
            ELSE
                RETURN ITERATIONS; -- Element found
            END IF;
        END LOOP;
        RETURN ITERATIONS; -- Element not found, return iterations anyway for consistency
    END BINARYSEARCH;
 -- Procedure to perform searches and print iterations ------------------------------------------------------------
    PROCEDURE SEARCHANDPRINTITERATIONS IS
        TOTALITERATIONSLINEAR PLS_INTEGER := 0;
        TOTALITERATIONSBINARY PLS_INTEGER := 0;
        AVGITERATIONSLINEAR   NUMBER := 0;
        AVGITERATIONSBINARY   NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Search Iterations for each element:');
        FOR I IN 1..NUMBERS.COUNT LOOP
 -- Linear Search
            DECLARE
                ITERATIONSLINEAR PLS_INTEGER;
                ITERATIONSBINARY PLS_INTEGER;
            BEGIN
                ITERATIONSLINEAR := LINEARSEARCH(SORTEDNUMBERS, NUMBERS(I));
                TOTALITERATIONSLINEAR := TOTALITERATIONSLINEAR + ITERATIONSLINEAR;
 -- Binary Search
                ITERATIONSBINARY := BINARYSEARCH(SORTEDNUMBERS, NUMBERS(I));
                TOTALITERATIONSBINARY := TOTALITERATIONSBINARY + ITERATIONSBINARY;
 -- Output for each element
                DBMS_OUTPUT.PUT_LINE('Element '
                    || NUMBERS(I)
                    || ' found in Linear: '
                    || ITERATIONSLINEAR
                    || ' iterations, Binary: '
                    || ITERATIONSBINARY
                    || ' iterations.');
            END;
        END LOOP;
 -- Compute the averages
        IF NUMBERS.COUNT > 0 THEN
            AVGITERATIONSLINEAR := TOTALITERATIONSLINEAR / NUMBERS.COUNT;
            AVGITERATIONSBINARY := TOTALITERATIONSBINARY / NUMBERS.COUNT;
 -- Output the averages
            DBMS_OUTPUT.PUT_LINE('Average iterations for Linear Search: '
                || TO_CHAR(AVGITERATIONSLINEAR));
            DBMS_OUTPUT.PUT_LINE('Average iterations for Binary Search: '
                || TO_CHAR(AVGITERATIONSBINARY));
 -- Comparison
            DBMS_OUTPUT.PUT_LINE('Comparison: Linear Search required '
                || TO_CHAR(AVGITERATIONSLINEAR - AVGITERATIONSBINARY)
                || ' more iterations on average than Binary Search.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('No elements to search.');
        END IF;
    END SEARCHANDPRINTITERATIONS;
BEGIN
 -- Generate and print 20 random numbers
    GENERATENUMBERS(20);
    DBMS_OUTPUT.PUT_LINE('Unsorted Numbers:');
    PRINTNUMBERS(NUMBERS);
 -- Sort and print the sorted numbers
    DOUBLESELECTIONSORT(SORTEDNUMBERS);
    DBMS_OUTPUT.PUT_LINE('Sorted Numbers:');
    PRINTNUMBERS(SORTEDNUMBERS);
 -- Perform linear search for each element and print iterations
    SEARCHANDPRINTITERATIONS;
END;
/

SPOOL OFF;

-- PROCEDURE SEARCHANDPRINTITERATIONS IS
--     totalIterations PLS_INTEGER := 0;
--     avgIterations NUMBER := 0;
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE('Linear Search Iterations for each element:');
--     FOR I IN 1..numbers.COUNT LOOP
--         DECLARE
--             iterations PLS_INTEGER;
--         BEGIN
--             iterations := LINEARSEARCH(sortedNumbers, numbers(I));
--             DBMS_OUTPUT.PUT_LINE('Element ' || numbers(I) || ' found in ' || iterations || ' iterations.');
--             totalIterations := totalIterations + iterations;
--         END;
--     END LOOP;

--     -- Compute the average number of iterations
--     IF numbers.COUNT > 0 THEN
--         avgIterations := totalIterations / numbers.COUNT;
--         DBMS_OUTPUT.PUT_LINE('Average iterations for Linear Search: ' || TO_CHAR(avgIterations));
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('No elements to search.');
--     END IF;
-- END SEARCHANDPRINTITERATIONS;