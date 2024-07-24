SPOOL "/Users/gretavirpsaite/PL_SQL/results_lab1.txt"
SET SERVEROUTPUT ON 

/*
DROP TABLE error_logs;
/
CREATE TABLE error_logs (
    log_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    error_code VARCHAR2(20),
    error_message VARCHAR2(250),
    backtrace CLOB,
    owner VARCHAR2(100),
    timestamp DATE
);
/
*/

/* ERROR HANDLING PACKAGE */
CREATE OR REPLACE PACKAGE P_ERROR_HANDLING AS
    INVALID_ARRAY_SIZE EXCEPTION; 
    UNSORTED_ARRAY EXCEPTION;
    MAX_VALUE_OVER_LIMIT EXCEPTION;

    PRAGMA EXCEPTION_INIT(INVALID_ARRAY_SIZE, -20001);
    PRAGMA EXCEPTION_INIT(UNSORTED_ARRAY, -20002);
    PRAGMA EXCEPTION_INIT(MAX_VALUE_OVER_LIMIT, -20003);

    PROCEDURE log_error_proc;
END P_ERROR_HANDLING;
/   
CREATE OR REPLACE PACKAGE BODY P_ERROR_HANDLING AS
    FUNCTION get_error_message
    RETURN VARCHAR2
    IS
    error_id number := SQLCODE;
    err_message VARCHAR2(250);
    BEGIN
      IF error_id < -21000 OR error_id > -20000 THEN
        RETURN SQLERRM;
      END IF;

      CASE error_id
      WHEN -20001 THEN 
        err_message := 'Invalid array size';
      WHEN -20002 THEN 
         err_message := 'Array unsorted';
      WHEN -20003 THEN 
         err_message := 'Value over limit';
      ELSE err_message := 'unknown';
      END CASE;

      RETURN err_message;
    END;

    PROCEDURE log_error_proc
    IS
    err_code VARCHAR2(20) := TO_CHAR(SQLCODE);
    err_message VARCHAR2(250) := get_error_message();
    created_id number;
    PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
      INSERT INTO error_logs (
            error_code, error_message, backtrace, owner, timestamp
        ) VALUES (
            err_code, err_message, DBMS_UTILITY.format_error_backtrace, USER, SYSDATE
        ) RETURNING log_id INTO created_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Created error log with id: '|| created_id || ' (err: ' || err_message || ')');
    EXCEPTION 
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Could not log error: ' || SQLERRM);
        RAISE;
    END log_error_proc;
END P_ERROR_HANDLING;
/   

/* TYPES PACKAGE */
CREATE OR REPLACE PACKAGE P_TYPES as
  SUBTYPE num_type IS number(4);
  TYPE num_array IS table of num_type;
  TYPE search_result IS RECORD(idx pls_integer, iterations num_type);
END P_TYPES;
/

/* SEARCH FUNCTIONS PACKAGE */
CREATE OR REPLACE PACKAGE P_SEARCH_FUNCTIONS AS
    FUNCTION linear_search_func(query_value P_TYPES.num_type, arr P_TYPES.num_array) RETURN P_TYPES.search_result;
    FUNCTION binary_search_func(query_value P_TYPES.num_type, arr P_TYPES.num_array) RETURN P_TYPES.search_result;
END P_SEARCH_FUNCTIONS;
/
CREATE OR REPLACE PACKAGE BODY P_SEARCH_FUNCTIONS AS 
/* LINEAR SEARCH */
  FUNCTION linear_search_func(query_value P_TYPES.num_type, arr P_TYPES.num_array)
  RETURN P_TYPES.search_result 
  IS
  sr P_TYPES.search_result;
  BEGIN
    sr.idx := -1;
    sr.iterations := -1;

    FOR i in 1 .. arr.count LOOP
      IF arr(i) = query_value THEN
        sr.idx := i;
        sr.iterations := i;
        EXIT;
      END IF;
    END LOOP;

    IF SR.idx = -1 THEN
      RAISE NO_DATA_FOUND;
    END IF;

    RETURN sr;
    EXCEPTION  
      WHEN ACCESS_INTO_NULL OR COLLECTION_IS_NULL OR NO_DATA_FOUND THEN
        P_ERROR_HANDLING.log_error_proc();  
        RAISE; 
  END linear_search_func;

  /* BINARY SEARCH */
  FUNCTION binary_search_func(query_value P_TYPES.num_type, arr P_TYPES.num_array)
  RETURN P_TYPES.search_result
  IS
  l pls_integer;
  m pls_integer;
  r pls_integer;
  sr P_TYPES.search_result;
  BEGIN 
    FOR i IN 2 .. arr.count LOOP
      IF arr(i) < arr(i - 1) THEN
        RAISE P_ERROR_HANDLING.UNSORTED_ARRAY;
      END IF;
    END LOOP;

    sr.idx := -1;
    sr.iterations := 1;

    l := 1;
    r := arr.count;

    WHILE l <= r
    LOOP 

      m := (l + r) / 2;

      IF arr(m) = query_value THEN
        sr.idx := m;
        EXIT;
      ELSIF arr(m) < query_value THEN
        sr.iterations := sr.iterations + 1;
        l := m + 1;
      ELSE 
        sr.iterations := sr.iterations + 1;
        r := m - 1;
      END IF;

    END LOOP;

    IF SR.idx = -1 THEN
      RAISE NO_DATA_FOUND;
    END IF;

    RETURN sr; 
    EXCEPTION  
      WHEN ACCESS_INTO_NULL OR COLLECTION_IS_NULL OR P_ERROR_HANDLING.UNSORTED_ARRAY OR NO_DATA_FOUND THEN
        P_ERROR_HANDLING.log_error_proc(); 
        RAISE;
  END binary_search_func;
END P_SEARCH_FUNCTIONS;
/

/* RADIX SORT PACKAGE */
CREATE OR REPLACE PACKAGE P_RADIX_SORT AS
  FUNCTION radix_sort_func(arr P_TYPES.num_array) RETURN P_TYPES.num_array;
END P_RADIX_SORT;
/
CREATE OR REPLACE PACKAGE BODY P_RADIX_SORT AS
  /* COUNT SORT */
  FUNCTION count_sort_func(arr P_TYPES.num_array, exp P_TYPES.num_type)
  RETURN P_TYPES.num_array
  IS
  n pls_integer;
  tmp_idx pls_integer;
  count_arr P_TYPES.num_array;
  sorted_arr P_TYPES.num_array;
  BEGIN 
    sorted_arr := P_TYPES.num_array();
    sorted_arr.extend(arr.count);

    count_arr := P_TYPES.num_array();
    count_arr.extend(10);

    FOR i in 1 .. 10 LOOP
      count_arr(i) := 0;
    END LOOP;

    FOR i in 1 .. arr.count LOOP
      tmp_idx := FLOOR((arr(i) / exp) mod 10) + 1;
      count_arr(tmp_idx) := count_arr(tmp_idx) + 1;
    END LOOP;

    FOR i in 2 .. 10 LOOP
      count_arr(i) := count_arr(i - 1) + count_arr(i);
    END LOOP;

    FOR i in 1 .. arr.count LOOP
      n := arr.count - i + 1;
      tmp_idx := FLOOR((arr(n) / exp) mod 10) + 1;
      sorted_arr(count_arr(tmp_idx)) := arr(n);
      count_arr(tmp_idx) := count_arr(tmp_idx) - 1;
    END LOOP;

    RETURN sorted_arr; 
  END count_sort_func;

  /* RADIX SORT */
  FUNCTION radix_sort_func(arr P_TYPES.num_array)
  RETURN P_TYPES.num_array
  IS
  exp pls_integer;
  max_value P_TYPES.num_type;
  sorted_arr P_TYPES.num_array;
  BEGIN 
    sorted_arr := P_TYPES.num_array();
    sorted_arr.extend(arr.count);

    FOR i in 1 .. arr.count LOOP
      sorted_arr(i) := arr(i);
    END LOOP;

    max_value := P_HELPER_FUNCTIONS.get_max_func(arr);
    exp := 1;

    WHILE cast(max_value / exp as pls_integer) > 0 LOOP
      sorted_arr := P_RADIX_SORT.count_sort_func(sorted_arr, exp);
      exp := exp * 10;
    END LOOP;

    RETURN sorted_arr;
    EXCEPTION  
      WHEN ACCESS_INTO_NULL OR COLLECTION_IS_NULL THEN
        P_ERROR_HANDLING.log_error_proc();
        RAISE;
  END radix_sort_func;
END P_RADIX_SORT;
/

/* HELPER FUNCTIONS PACKAGE */
CREATE OR REPLACE PACKAGE P_HELPER_FUNCTIONS AS
  FUNCTION generate_data_func(n pls_integer, upTo P_TYPES.num_type) RETURN P_TYPES.num_array;
  FUNCTION get_max_func(arr P_TYPES.num_array) RETURN P_TYPES.num_type;
END P_HELPER_FUNCTIONS;
/
CREATE OR REPLACE PACKAGE BODY P_HELPER_FUNCTIONS AS
FUNCTION get_max_func(arr P_TYPES.num_array)
  RETURN P_TYPES.num_type
  IS
  max_value P_TYPES.num_type;
  BEGIN 
    max_value := arr(1);

    FOR i in 1 .. arr.count LOOP
      IF arr(i) > max_value THEN
        max_value := arr(i);
      END IF;
    END LOOP;

    RETURN max_value; 
    EXCEPTION  
      WHEN ACCESS_INTO_NULL OR COLLECTION_IS_NULL THEN
        P_ERROR_HANDLING.log_error_proc();
        RAISE;
  END get_max_func;

FUNCTION generate_data_func(n pls_integer, upTo P_TYPES.num_type)
  RETURN P_TYPES.num_array
  IS
  arr P_TYPES.num_array;
  BEGIN
    IF n < 1 THEN
        RAISE P_ERROR_HANDLING.INVALID_ARRAY_SIZE;
    ELSIF upTo > 9999 THEN
        RAISE P_ERROR_HANDLING.MAX_VALUE_OVER_LIMIT;
    END IF;

    arr := P_TYPES.num_array();
    arr.extend(n);
    
    FOR i in 1 .. n LOOP
      arr(i) := (abs(DBMS_RANDOM.RANDOM()) mod upTo) + 1;
    END LOOP;

    RETURN arr;
    EXCEPTION 
      WHEN P_ERROR_HANDLING.INVALID_ARRAY_SIZE OR P_ERROR_HANDLING.MAX_VALUE_OVER_LIMIT THEN
        P_ERROR_HANDLING.log_error_proc();
        RAISE;
  END generate_data_func;
END P_HELPER_FUNCTIONS;
/
SPOOL OFF