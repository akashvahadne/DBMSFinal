-- **************************************
-- PRACTICAL 6: Parameterized Cursor Example
-- **************************************

-- 1️⃣ Drop existing tables if they exist
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE N_RollCall';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE O_RollCall';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 2️⃣ Create Old Table (Existing Records)
CREATE TABLE O_RollCall (
    roll_no NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    class VARCHAR2(20)
);

-- 3️⃣ Create New Table (New Records)
CREATE TABLE N_RollCall (
    roll_no NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    class VARCHAR2(20)
);

-- 4️⃣ Insert Data into Old Table
INSERT INTO O_RollCall VALUES (1, 'Akash', 'FY');
INSERT INTO O_RollCall VALUES (2, 'Neha', 'SY');
INSERT INTO O_RollCall VALUES (3, 'Rohan', 'TY');

-- 5️⃣ Insert Data into New Table
INSERT INTO N_RollCall VALUES (2, 'Neha', 'SY');      -- duplicate
INSERT INTO N_RollCall VALUES (3, 'Rohan', 'TY');     -- duplicate
INSERT INTO N_RollCall VALUES (4, 'Meera', 'FY');     -- new
INSERT INTO N_RollCall VALUES (5, 'Saurabh', 'TY');   -- new
COMMIT;

-- 6️⃣ PL/SQL Block: Merge Using Parameterized Cursor
DECLARE
    -- Parameterized cursor: takes Roll Number as input
    CURSOR c_new(p_roll N_RollCall.roll_no%TYPE) IS
        SELECT roll_no, name, class
        FROM N_RollCall
        WHERE roll_no = p_roll;

    v_roll N_RollCall.roll_no%TYPE;
    v_name N_RollCall.name%TYPE;
    v_class N_RollCall.class%TYPE;
    v_exists NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Merge Operation ---');

    -- Loop through all records in N_RollCall
    FOR rec IN (SELECT roll_no FROM N_RollCall) LOOP
        -- Check if Roll Number already exists in Old Table
        SELECT COUNT(*) INTO v_exists FROM O_RollCall WHERE roll_no = rec.roll_no;

        IF v_exists = 0 THEN
            -- Fetch data from N_RollCall using parameterized cursor
            OPEN c_new(rec.roll_no);
            FETCH c_new INTO v_roll, v_name, v_class;
            CLOSE c_new;

            -- Insert new record into Old Table
            INSERT INTO O_RollCall VALUES (v_roll, v_name, v_class);
            DBMS_OUTPUT.PUT_LINE('✅ Inserted Roll No: ' || v_roll || ' | Name: ' || v_name);
        ELSE
            DBMS_OUTPUT.PUT_LINE('⚠️ Skipped Duplicate Roll No: ' || rec.roll_no);
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Merge Completed Successfully! ---');
END;
/
