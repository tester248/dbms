DROP TABLE Borrower CASCADE CONSTRAINTS;
DROP TABLE Fine CASCADE CONSTRAINTS;
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

-- Sample Data

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


DECLARE
    v_rollno          Borrower.Rollno%TYPE := ${roll_no};
    v_nameofbook      Borrower.NameofBook%TYPE := '${book_name}';
    v_dateofissue     Borrower.DateofIssue%TYPE;
    v_status          Borrower.Status%TYPE;
    v_fineamt         NUMBER := 0;
    v_days            NUMBER;
    v_finedate        DATE := SYSDATE;
    
    no_fine_needed EXCEPTION;
BEGIN
    -- Retrieve book issue date and status
    SELECT DateofIssue, Status
    INTO v_dateofissue, v_status
    FROM Borrower
    WHERE Rollno = v_rollno
      AND NameofBook = v_nameofbook
      AND Status = 'I';

    -- Calculate the number of days overdue
    v_days := TRUNC(v_finedate) - v_dateofissue;
    
    -- Fine calculation logic
    IF v_days > 15 AND v_days <= 30 THEN
        v_fineamt := (v_days - 15) * 5;
    ELSIF v_days > 30 THEN
        v_fineamt := (15 * 5) + (v_days - 30) * 50;
    END IF;

    -- Update the book status to returned
    UPDATE Borrower
    SET Status = 'R'
    WHERE Rollno = v_rollno
      AND NameofBook = v_nameofbook
      AND Status = 'I';

    -- Insert fine record if applicable
    IF v_fineamt > 0 THEN
        INSERT INTO Fine (Roll_no, finedate, Amt)
        VALUES (v_rollno, SYSDATE, v_fineamt);
    END IF;

    -- Handle no fine scenario
    IF v_fineamt = 0 AND v_days <= 15 THEN
        RAISE no_fine_needed;
    END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Book "' || v_nameofbook || '" has been successfully returned for Roll No: ' || v_rollno);
    DBMS_OUTPUT.PUT_LINE('Total fine incurred: Rs. ' || v_fineamt);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Book not found or already returned.');
    WHEN no_fine_needed THEN
        DBMS_OUTPUT.PUT_LINE('Book returned successfully. No fine applicable.');
        UPDATE Borrower
        SET Status = 'R'
        WHERE Rollno = v_rollno
          AND NameofBook = v_nameofbook;
        COMMIT;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        ROLLBACK;
END;
/
