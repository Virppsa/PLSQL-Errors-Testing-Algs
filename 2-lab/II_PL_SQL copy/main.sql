DECLARE
 -- Declare a variable to store the generated array
    GENERATED_ARRAY NUMBER_TABLE.NUMBERTABLE;
BEGIN
 -- Call the GENERATE_NUMBERS function to generate an array of random numbers
    GENERATED_ARRAY := RANDOM_NUMBERS_ARRAY.GENERATE_NUMBERS(5); -- Generate an array of 5 random numbers
 -- Display the generated array
    DBMS_OUTPUT.PUT_LINE('Generated Array:');
    PRINTING.PRINT_ARRAY(GENERATED_ARRAY);
END;
/