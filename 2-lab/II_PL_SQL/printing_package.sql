CREATE OR REPLACE PACKAGE PRINTING AS
 --Spausdinam pradinį mąsyvą
    PROCEDURE PRINT_ARRAY(
        ARR IN NUMBER_TABLE.NUMBERTABLE
    );
 --Spausdinam iteraciją
    PROCEDURE PRINT_SINGLE_ITERATION(
        SEARCH_TYPE IN VARCHAR2,
        WANTED IN NUMBER,
        ITERATIONS_NEEDED IN PLS_INTEGER
    );
 --Spausdinam vidurkį kiekvieno searčo pagal search_type
    PROCEDURE PRINT_AVERAGE_ITERATIONS(
        SEARCH_TYPE IN VARCHAR2,
        TOTAL_ITERATIONS PLS_INTEGER,
        TIMES_TESTED PLS_INTEGER
    );
END PRINTING;
/

CREATE OR REPLACE PACKAGE BODY PRINTING AS
 --Spausdinam pradinį mąsyvą
    PROCEDURE PRINT_ARRAY(
        ARR IN NUMBER_TABLE.NUMBERTABLE
    ) IS
        OUTPUT_LINE VARCHAR2(4000) := '';
    BEGIN
        FOR I IN ARR.FIRST..ARR.LAST LOOP
            OUTPUT_LINE := OUTPUT_LINE
                || ARR(I)
                || ' | ';
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('| '
            || OUTPUT_LINE);
    END PRINT_ARRAY; --
 --Spausdinam iteraciją
    PROCEDURE PRINT_SINGLE_ITERATION(
        SEARCH_TYPE IN VARCHAR2,
        WANTED IN NUMBER,
        ITERATIONS_NEEDED IN PLS_INTEGER
    ) IS
    BEGIN
        IF SEARCH_TYPE IS NULL OR TRIM(SEARCH_TYPE) = '' THEN
            RAISE G_ERROR_HANDLING.SEARCH_TYPE_IS_EMPTY_EXCEPTION;
        END IF;
 --
        DBMS_OUTPUT.PUT_LINE('Number: '
            || TO_CHAR(WANTED)
            || ' found in: '
            || TO_CHAR(ITERATIONS_NEEDED)
            || ' iterations with '
            || SEARCH_TYPE
            || ' search.' );
    EXCEPTION
        WHEN G_ERROR_HANDLING.SEARCH_TYPE_IS_EMPTY_EXCEPTION THEN
            G_ERROR_HANDLING.LOG_ERROR();
    END PRINT_SINGLE_ITERATION; --
 --Spausdinam vidurkį kiekvieno searčo pagal search_type
    PROCEDURE PRINT_AVERAGE_ITERATIONS(
        SEARCH_TYPE IN VARCHAR2,
        TOTAL_ITERATIONS PLS_INTEGER,
        TIMES_TESTED PLS_INTEGER
    ) IS
        AVERAGE NUMBER := 0;
    BEGIN
        IF SEARCH_TYPE IS NULL OR TRIM(SEARCH_TYPE) = '' THEN
            RAISE G_ERROR_HANDLING.SEARCH_TYPE_IS_EMPTY_EXCEPTION;
        END IF;
 --
        AVERAGE := TOTAL_ITERATIONS / TIMES_TESTED; --Kritinė klaida jei iš 0 - negalim tiesiog log error, reikia ir į aplinką error grąžinti
        DBMS_OUTPUT.PUT_LINE('Average '
            || SEARCH_TYPE
            || ' search: '
            || TO_CHAR(AVERAGE));
    EXCEPTION --log error kai sutaisysiu - visos when dalys bus identiškos tai vieną galima bus palikti
        WHEN G_ERROR_HANDLING.SEARCH_TYPE_IS_EMPTY_EXCEPTION OR ZERO_DIVIDE THEN
            G_ERROR_HANDLING.LOG_ERROR();
            RAISE;
    END PRINT_AVERAGE_ITERATIONS; --Tiesiog log error, jei yra klaida
 --Su neigiamais parametrais, jei klaida padaro apėjimą (vėl vidinis su BEGIN bloku ir if'ą padarė) - defaultinį paramą davė
 --SVARBU NUSPRĘSTI AR FATAL AR NE IR KĄ SU TUO DARYTI!!!!!
END PRINTING;
/