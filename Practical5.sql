-- **************************************
-- PRACTICAL 5: Unnamed PL/SQL Block
-- Control Structure + Exception Handling
-- **************************************

-- Drop old tables if exist
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Borrower';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Fine';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 1️⃣ Create Tables
CREATE TABLE Borrower (
    Roll_no NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    DateofIssue DATE,
    NameofBook VARCHAR2(50),
    Status CHAR(1)
);

CREATE TABLE Fine (
    Roll_no NUMBER,
    Date_ DATE,
    Amt NUMBER(10,2)
);

-- 2️⃣ Insert Sample Data
INSERT INTO Borrower VALUES (1, 'Akash', TO_DATE('10-OCT-2024', 'DD-MON-YYYY'), 'DBMS', 'I');
INSERT INTO Borrower VALUES (2, 'Neha', TO_DATE('20-OCT-2024', 'DD-MON-YYYY'), 'Java', 'I');
INSERT INTO Borrower VALUES (3, 'Rohan', TO_DATE('25-OCT-2024', 'DD-MON-YYYY'), 'AI', 'I');
COMMIT;

-- 3️⃣ PL/SQL Block (No user input pop-ups)
DECLARE
    v_roll Borrower.Roll_no%TYPE := 1;        -- Set Roll Number here (change manually)
    v_book Borrower.NameofBook%TYPE := 'DBMS'; -- Set Book Name here (change manually)
    v_dateissue Borrower.DateofIssue%TYPE;
    v_days NUMBER;
    v_fine NUMBER := 0;
    v_status Borrower.Status%TYPE;
    e_already_returned EXCEPTION;
BEGIN
    -- Fetch Borrower Details
    SELECT DateofIssue, Status INTO v_dateissue, v_status
    FROM Borrower
    WHERE Roll_no = v_roll AND NameofBook = v_book;

    -- Check if already returned
    IF v_status = 'R' THEN
        RAISE e_already_returned;
    END IF;

    -- Calculate days
    v_days := SYSDATE - v_dateissue;
    DBMS_OUTPUT.PUT_LINE('📚 Days since issue: ' || v_days);

    -- Fine calculation
    IF v_days BETWEEN 15 AND 30 THEN
        v_fine := (v_days - 14) * 5;
    ELSIF v_days > 30 THEN
        v_fine := (16 * 5) + ((v_days - 30) * 50);
    ELSE
        v_fine := 0;
    END IF;

    -- Update book status to Returned
    UPDATE Borrower
    SET Status = 'R'
    WHERE Roll_no = v_roll AND NameofBook = v_book;

    -- Insert fine if applicable
    IF v_fine > 0 THEN
        INSERT INTO Fine VALUES (v_roll, SYSDATE, v_fine);
        DBMS_OUTPUT.PUT_LINE('💰 Fine imposed: Rs. ' || v_fine);
    ELSE
        DBMS_OUTPUT.PUT_LINE('✅ No fine applicable.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('📗 Book Returned Successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error: No record found.');
    WHEN e_already_returned THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ Book already returned.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('⚡ Unexpected error: ' || SQLERRM);
END;
/
