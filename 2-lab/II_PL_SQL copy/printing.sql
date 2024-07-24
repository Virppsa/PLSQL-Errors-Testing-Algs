CREATE OR REPLACE PACKAGE PRINTING AS
 -- Procedure to print the numbers in an array
    PROCEDURE PRINT_ARRAY(
        ARR IN NUMBER_TABLE.NUMBERTABLE
    );
END PRINTING;
/

CREATE OR REPLACE PACKAGE BODY PRINTING AS
 -- Procedure to print the numbers in an array
    PROCEDURE PRINT_ARRAY(
        ARR IN NUMBER_TABLE.NUMBERTABLE
    ) IS
 -- Declare a variable to store the output line
        OUTPUT_LINE VARCHAR2(4000) := '';
    BEGIN
 -- Loop through the array and construct the output line
        FOR I IN ARR.FIRST..ARR.LAST LOOP
            OUTPUT_LINE := OUTPUT_LINE
                || ARR(I)
                || ' | ';
        END LOOP;
 -- Print the output line
        DBMS_OUTPUT.PUT_LINE('| '
            || OUTPUT_LINE);
    END PRINT_ARRAY;
END PRINTING;
/