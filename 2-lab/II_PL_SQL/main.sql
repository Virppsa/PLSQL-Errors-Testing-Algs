SET SERVEROUTPUT ON;

DECLARE
 -- Declare a variable to store the generated array
  GENERATED_ARRAY      NUMBER_TABLE.NUMBERTABLE;
  SORTED_ARRAY         NUMBER_TABLE.NUMBERTABLE;
  LINEAR_SEARCH_RESULT PLS_INTEGER;
  BINARY_SEARCH_RESULT PLS_INTEGER;
BEGIN
 -- Call the GENERATE_NUMBERS function to generate an array of random numbers
  GENERATED_ARRAY := RANDOM_NUMBERS_ARRAY.GENERATE_NUMBERS(5); -- Generate an array of 5 random numbers
  GENERATED_ARRAY.DELETE(1, 3);
 -- Display the generated array
  DBMS_OUTPUT.PUT_LINE('Generated Array:');
  PRINTING.PRINT_ARRAY(GENERATED_ARRAY);
 --Padelytinti elementą - ir iškart sustos su mano sortu  (sisteminė klaida gaunasi) - kad foras yra sorte
  SORTED_ARRAY := SORT_PACKAGE.DOUBLESELECTIONSORT(GENERATED_ARRAY);
  DBMS_OUTPUT.PUT_LINE('Sorted Array:');
 -- SORTED_ARRAY.DELETE(2);
  PRINTING.PRINT_ARRAY(SORTED_ARRAY);
  TESTING.TEST_ITERATIONS(SORTED_ARRAY);
END;
/