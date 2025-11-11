-- **************************************
-- PRACTICAL 8: Database Trigger - Library Audit
-- **************************************

-- 1️⃣ Drop existing tables if they exist
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Library_Audit';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Library';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 2️⃣ Create Main Table: Library
CREATE TABLE Library (
    book_id NUMBER PRIMARY KEY,
    book_name VARCHAR2(100),
    author VARCHAR2(50),
    price NUMBER(10,2)
);

-- 3️⃣ Create Audit Table: Library_Audit
CREATE TABLE Library_Audit (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
    book_id NUMBER,
    book_name VARCHAR2(100),
    author VARCHAR2(50),
    price NUMBER(10,2),
    operation_type VARCHAR2(10),
    operation_date DATE
);

-- 4️⃣ Insert Sample Records
INSERT INTO Library VALUES (1, 'DBMS Concepts', 'Korth', 500);
INSERT INTO Library VALUES (2, 'Operating System', 'Galvin', 450);
INSERT INTO Library VALUES (3, 'Computer Networks', 'Tanenbaum', 600);
COMMIT;

-- 5️⃣ Create Trigger for UPDATE and DELETE
CREATE OR REPLACE TRIGGER trg_library_audit
AFTER UPDATE OR DELETE ON Library
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        INSERT INTO Library_Audit (book_id, book_name, author, price, operation_type, operation_date)
        VALUES (:OLD.book_id, :OLD.book_name, :OLD.author, :OLD.price, 'UPDATE', SYSDATE);

        DBMS_OUTPUT.PUT_LINE('🔄 Book Updated: ' || :OLD.book_name);
    ELSIF DELETING THEN
        INSERT INTO Library_Audit (book_id, book_name, author, price, operation_type, operation_date)
        VALUES (:OLD.book_id, :OLD.book_name, :OLD.author, :OLD.price, 'DELETE', SYSDATE);

        DBMS_OUTPUT.PUT_LINE('❌ Book Deleted: ' || :OLD.book_name);
    END IF;
END;
/

-- Run above code first then run following command one by one
-- 1
UPDATE Library
SET price = 550
WHERE book_id = 1;

--2
DELETE FROM Library
WHERE book_id = 2;

--3
SELECT * FROM Library_Audit;
