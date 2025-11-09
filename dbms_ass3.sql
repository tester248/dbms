CREATE TABLE Borrower (
    Rollno NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    DateofIssue DATE,
    NameofBook VARCHAR2(100),
    Status CHAR(1) -- 'I' for issued, 'R' for returned
);

CREATE TABLE Fine (
    Roll_no NUMBER,
    finedate DATE,
    Amt NUMBER,
    CONSTRAINT fk_borrower FOREIGN KEY (Roll_no) REFERENCES Borrower(Rollno)
);

-- Insert sample data into the Borrower table

-- Book issued 10 days ago (no fine)
INSERT INTO Borrower (Rollno, Name, DateofIssue, NameofBook, Status)
VALUES (101, 'Ashwin', SYSDATE - 10, 'Introduction to SQL', 'I');

-- Book issued 25 days ago (fine: 10 days * 5 Rs/day)
INSERT INTO Borrower (Rollno, Name, DateofIssue, NameofBook, Status)
VALUES (102, 'Bob', SYSDATE - 25, 'Data Structures', 'I');

-- Book issued 40 days ago (fine: (15 days * 5 Rs/day) + (10 days * 50 Rs/day))
INSERT INTO Borrower (Rollno, Name, DateofIssue, NameofBook, Status)
VALUES (103, 'Raj', SYSDATE - 40, 'Database Systems', 'I');

-- A book that has already been returned
INSERT INTO Borrower (Rollno, Name, DateofIssue, NameofBook, Status)
VALUES (104, 'David', SYSDATE - 50, 'Operating Systems', 'R');

COMMIT;

PL/SQL BLOCK:

DECLARE
    v_rollno          Borrower.Rollno%TYPE := '&roll_no';
    v_nameofbook      Borrower.NameofBook%TYPE := '&book_name';
    v_dateofissue     Borrower.DateofIssue%TYPE;
    v_status          Borrower.Status%TYPE;
    v_fineamt         NUMBER := 0;
    v_days            NUMBER;
    v_finedate        DATE := SYSDATE;
    
    -- Corrected exception for an invalid borrower/book combination
    book_not_issued EXCEPTION;
    
    -- Corrected exception for no fine needed
    no_fine_needed EXCEPTION;
    
BEGIN
    -- Retrieve the book issue date and status for the given roll number and book name
    -- Using a single SELECT statement with a check for status 'I'
    SELECT DateofIssue, Status
    INTO v_dateofissue, v_status
    FROM Borrower
    WHERE Rollno = v_rollno
      AND NameofBook = v_nameofbook
      AND Status = 'I';

    -- Calculate the number of days the book has been overdue
    v_days := TRUNC(v_finedate) - v_dateofissue;
    
    -- Corrected fine calculation logic
    IF v_days > 15 AND v_days <= 30 THEN
        v_fineamt := (v_days - 15) * 5;
    ELSIF v_days > 30 THEN
        v_fineamt := (15 * 5) + (v_days - 30) * 50;
    END IF;

    -- Update the book's status to 'R' (Returned)
    UPDATE Borrower
    SET Status = 'R'
    WHERE Rollno = v_rollno
      AND NameofBook = v_nameofbook
      AND Status = 'I';

    -- If a fine is incurred, insert a record into the Fine table
    IF v_fineamt > 0 THEN
        -- Corrected INSERT statement syntax
        INSERT INTO Fine (Roll_no, finedate, Amt)
        VALUES (v_rollno, SYSDATE, v_fineamt);
    END IF;

    -- Handle the case where the book is returned on time (less than 15 days)
    IF v_fineamt = 0 AND v_days <= 15 THEN
        RAISE no_fine_needed;
    END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Book "' || v_nameofbook || '" has been successfully returned for Roll No: ' || v_rollno);
    DBMS_OUTPUT.PUT_LINE('Total fine incurred: Rs. ' || v_fineamt);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handles the case where the SELECT statement finds no matching records
        DBMS_OUTPUT.PUT_LINE('Error: Book not found, or it is already returned.');
    WHEN no_fine_needed THEN
        -- This part is for books returned within the grace period (<= 15 days)
        DBMS_OUTPUT.PUT_LINE('Book returned successfully. No fine is applicable.');
        
        -- To ensure the status is still updated if a book is returned on time,
        -- the UPDATE statement should be moved outside the main logic
        UPDATE Borrower
        SET Status = 'R'
        WHERE Rollno = v_rollno
          AND NameofBook = v_nameofbook;
          
        COMMIT;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/
