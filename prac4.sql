--check current schema
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL;

DROP TABLE O_Roll_Call CASCADE CONSTRAINTS;
DROP TABLE N_Roll_Call CASCADE CONSTRAINTS;
-- Step 1: Create old and new roll call tables
CREATE TABLE O_Roll_Call (
    Roll_ID       NUMBER PRIMARY KEY,
    Student_Name  VARCHAR2(100) NOT NULL,
    Call_Date     DATE DEFAULT SYSDATE
);

CREATE TABLE N_Roll_Call (
    Roll_ID       NUMBER PRIMARY KEY,
    Student_Name  VARCHAR2(100) NOT NULL,
    Call_Date     DATE DEFAULT SYSDATE
);

-- Step 2: Insert sample data
INSERT INTO O_Roll_Call (Roll_ID, Student_Name) VALUES (101, 'Ashwin Mathur');
INSERT INTO O_Roll_Call (Roll_ID, Student_Name) VALUES (102, 'Student 2');
INSERT INTO O_Roll_Call (Roll_ID, Student_Name) VALUES (103, 'Student 3');
INSERT INTO O_Roll_Call (Roll_ID, Student_Name) VALUES (104, 'Student 4');
INSERT INTO O_Roll_Call (Roll_ID, Student_Name) VALUES (105, 'Student 5');
INSERT INTO O_Roll_Call (Roll_ID, Student_Name) VALUES (106, 'Student 6');

INSERT INTO N_Roll_Call (Roll_ID, Student_Name) VALUES (104, 'Student 4');
INSERT INTO N_Roll_Call (Roll_ID, Student_Name) VALUES (105, 'Student 5');
INSERT INTO N_Roll_Call (Roll_ID, Student_Name) VALUES (107, 'Student 7');
INSERT INTO N_Roll_Call (Roll_ID, Student_Name) VALUES (108, 'Student 8');

-- Step 3: Show old table data before merge
SELECT 'Before Merge' AS Status, Roll_ID, Student_Name
FROM O_Roll_Call
ORDER BY Roll_ID;

-- Step 4: Procedure to merge using a cursor
CREATE OR REPLACE PROCEDURE P_MERGE_ROLL_CALL
AS
    -- Cursor to read all records from the new roll call table
    CURSOR c_new IS
        SELECT Roll_ID, Student_Name, Call_Date
        FROM N_Roll_Call;

    v_new_record c_new%ROWTYPE;
    v_exists     NUMBER;
    v_inserted   NUMBER := 0;
    v_skipped    NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Roll Call Merge Process ---');

    OPEN c_new;

    LOOP
        FETCH c_new INTO v_new_record;
        EXIT WHEN c_new%NOTFOUND;

        -- Check if Roll_ID already exists in the old table
        SELECT COUNT(*) INTO v_exists
        FROM O_Roll_Call
        WHERE Roll_ID = v_new_record.Roll_ID;

        IF v_exists = 0 THEN
            -- Insert new record
            INSERT INTO O_Roll_Call (Roll_ID, Student_Name, Call_Date)
            VALUES (v_new_record.Roll_ID, v_new_record.Student_Name, v_new_record.Call_Date);

            v_inserted := v_inserted + 1;
            DBMS_OUTPUT.PUT_LINE('Inserted: ' || v_new_record.Roll_ID || ' - ' || v_new_record.Student_Name);
        ELSE
            -- Skip existing record
            v_skipped := v_skipped + 1;
            DBMS_OUTPUT.PUT_LINE('Skipped (already exists): ' || v_new_record.Roll_ID || ' - ' || v_new_record.Student_Name);
        END IF;
    END LOOP;

    CLOSE c_new;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('--- Merge Completed ---');
    DBMS_OUTPUT.PUT_LINE('Total Records Inserted: ' || v_inserted);
    DBMS_OUTPUT.PUT_LINE('Total Records Skipped: ' || v_skipped);

EXCEPTION
    WHEN OTHERS THEN
        IF c_new%ISOPEN THEN
            CLOSE c_new;
        END IF;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END P_MERGE_ROLL_CALL;
/

-- Step 5: Execute the procedure

BEGIN
    P_MERGE_ROLL_CALL;
END;

-- Step 6: Show data after merge
SELECT 'After Merge' AS Status, Roll_ID, Student_Name
FROM O_Roll_Call
ORDER BY Roll_ID;