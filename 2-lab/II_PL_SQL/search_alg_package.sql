-- CREATE OR REPLACE PACKAGE ALGORYTHMS AS
--     FUNCTION LINEARSEARCH(
--         ARR IN NUMBERTABLE,
--         TARGET IN NUMBER
--     ) RETURN PLS_INTEGER;
--     FUNCTION BINARYSEARCH(
--         ARR IN NUMBERTABLE,
--         TARGET IN NUMBER
--     ) RETURN PLS_INTEGER;
-- END ALGORYTHMS;
-- /

CREATE OR REPLACE PACKAGE ALGORYTHMS AS
 --linijinė paieška
    FUNCTION LINEARSEARCH(
        ARR IN NUMBER_TABLE.NUMBERTABLE,
        TARGET IN NUMBER
    ) RETURN PLS_INTEGER;
 --dvejetainė paieška
    FUNCTION BINARYSEARCH(
        ARR IN NUMBER_TABLE.NUMBERTABLE,
        TARGET IN NUMBER
    ) RETURN PLS_INTEGER;
END ALGORYTHMS;
/

CREATE OR REPLACE PACKAGE BODY ALGORYTHMS IS
 --linijinė paieška
    FUNCTION LINEARSEARCH(
        ARR IN NUMBER_TABLE.NUMBERTABLE,
        TARGET IN NUMBER
    ) RETURN PLS_INTEGER IS
        ITERATIONS PLS_INTEGER := 0;
    BEGIN
        FOR I IN ARR.FIRST..ARR.LAST LOOP
            ITERATIONS := ITERATIONS + 1;
            IF ARR(I) = TARGET THEN
                RETURN ITERATIONS;
            END IF;
        END LOOP;
        RAISE G_ERROR_HANDLING.TARGET_NOT_FOUND_EXCEPTION;
        RETURN -1;
    END LINEARSEARCH; ----dvejetainė paieška
    FUNCTION BINARYSEARCH(
        ARR IN NUMBER_TABLE.NUMBERTABLE,
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
                RETURN ITERATIONS;
            END IF;
        END LOOP;
        RAISE G_ERROR_HANDLING.TARGET_NOT_FOUND_EXCEPTION;
        RETURN -1;
    EXCEPTION
 -- Tikriname ar fore netycia nebandome rast neegzistuojacio elemento
        WHEN OTHERS THEN
            G_ERROR_HANDLING.LOG_ERROR();
            RAISE;
    END BINARYSEARCH;
END ALGORYTHMS;
/

-- SELECT LINE, POSITION, TEXT
-- FROM USER_ERRORS
-- WHERE NAME = 'ALGORYTHMS'
-- ORDER BY SEQUENCE;


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