-- **************************************
-- PRACTICAL 7: Stored Procedure - proc_Grade
-- **************************************

-- 1️⃣ Drop existing tables if any
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Stud_Marks';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Result';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 2️⃣ Create Tables
CREATE TABLE Stud_Marks (
    roll NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    total_marks NUMBER(5)
);

CREATE TABLE Result (
    roll NUMBER,
    name VARCHAR2(50),
    class VARCHAR2(30)
);

-- 3️⃣ Insert Sample Data
INSERT INTO Stud_Marks VALUES (1, 'Akash', 1450);
INSERT INTO Stud_Marks VALUES (2, 'Neha', 940);
INSERT INTO Stud_Marks VALUES (3, 'Rohan', 870);
INSERT INTO Stud_Marks VALUES (4, 'Meera', 780);
COMMIT;

-- 4️⃣ Create Stored Procedure
CREATE OR REPLACE PROCEDURE proc_Grade (
    p_roll Stud_Marks.roll%TYPE,
    p_name Stud_Marks.name%TYPE,
    p_marks Stud_Marks.total_marks%TYPE
)
IS
    v_class VARCHAR2(30);
BEGIN
    -- Categorize Student
    IF p_marks >= 990 AND p_marks <= 1500 THEN
        v_class := 'Distinction';
    ELSIF p_marks BETWEEN 900 AND 989 THEN
        v_class := 'First Class';
    ELSIF p_marks BETWEEN 825 AND 899 THEN
        v_class := 'Higher Second Class';
    ELSE
        v_class := 'Fail';
    END IF;

    -- Insert result
    INSERT INTO Result (roll, name, class)
    VALUES (p_roll, p_name, v_class);

    DBMS_OUTPUT.PUT_LINE('Student: ' || p_name || ' | Class: ' || v_class);
END;
/

-- **************************************
-- Block to Use Procedure proc_Grade
-- **************************************

DECLARE
    v_roll Stud_Marks.roll%TYPE;
    v_name Stud_Marks.name%TYPE;
    v_marks Stud_Marks.total_marks%TYPE;
BEGIN
    -- Loop through all students and call procedure
    FOR rec IN (SELECT * FROM Stud_Marks) LOOP
        proc_Grade(rec.roll, rec.name, rec.total_marks);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('✅ Grades inserted successfully in Result table.');
END;
/

SELECT * FROM Result;
