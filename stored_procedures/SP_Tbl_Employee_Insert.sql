IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Insert]
            @Employee_FName varchar(50),
            @Employee_LName varchar(50),
            @Employee_DOB datetime,
            @Employee_Gender varchar(50),
            @Employee_Permanent_Address varchar(250),
            @Employee_Present_Address varchar(250),
            @Employee_Phone varchar(50),
            @Employee_Mail varchar(50),
            @Employee_Mobile varchar(50),
            @Employee_Martial_Status varchar(20),
            @Blood_Group varchar(20),
            @Employee_Id_Card_No varchar(20),
            @Employee_Nationality varchar(max),
            @Employee_State varchar(max),
            @Employee_Experience_If_Any varchar(500),
            @Employee_Father_Name varchar(50),
            @Employee_Nominee_Name varchar(50),
            @Employee_Nominee_Relation varchar(50),
            @Employee_Nominee_Phone varchar(50),
            @Employee_Nominee_Address varchar(500),
            @Employee_Type varchar(50),
            @Employee_Aadhar varchar(30),
            @Identification_No varchar(50),
            @Employee_City varchar(max),
            @Employee_postcode varchar(50),
            @Spouse_Name varchar(MAX),
            @Spouse_LName VARCHAR(MAX),
            @Spouse_IC_No varchar(MAX),
            @NoofChildren varchar(MAX),
            @Spouse_Email varchar(MAX),
            @Spouse_MobileNo varchar(15),
            @Emergency_Name varchar(100),
            @Emergency_Number varchar(max),
            @Employee_Country varchar(MAX)
        AS
        BEGIN
            DECLARE @Class_Id AS BIGINT;
            DECLARE @Employee_Id AS BIGINT;
    
            INSERT INTO Tbl_Employee
                ([Employee_FName], [Employee_LName], [Employee_DOB], [Employee_Gender], [Employee_Permanent_Address],
                 [Employee_Present_Address], [Employee_Phone], [Employee_Mail], [Employee_Mobile], [Employee_Martial_Status],
                 [Blood_Group], [Employee_Id_Card_No], [Employee_Nationality], [Employee_State], Employee_City, 
                 Employee_postcode, [Employee_Experience_If_Any], [Employee_Father_Name], [Employee_Nominee_Name],
                 [Employee_Nominee_Relation], [Employee_Nominee_Phone], [Employee_Nominee_Address], [Employee_Status],
                 [Employee_Type], Employee_Aadhar, Identification_No, Spouse_FName, Spouse_LName, Spouse_IC_No, NoofChildren,
                 Spouse_Email, Spouse_MobileNo, Emergency_Name, Emergency_Number, Employee_Country)
            VALUES
                (@Employee_FName, @Employee_LName, @Employee_DOB, @Employee_Gender, @Employee_Permanent_Address,
                 @Employee_Present_Address, @Employee_Phone, @Employee_Mail, @Employee_Mobile, @Employee_Martial_Status,
                 @Blood_Group, @Employee_Id_Card_No, @Employee_Nationality, @Employee_State, @Employee_City, @Employee_postcode,
                 @Employee_Experience_If_Any, @Employee_Father_Name, @Employee_Nominee_Name, @Employee_Nominee_Relation,
                 @Employee_Nominee_Phone, @Employee_Nominee_Address, 0, @Employee_Type, @Employee_Aadhar, @Identification_No,
                 @Spouse_Name, @Spouse_LName, @Spouse_IC_No, @NoofChildren, @Spouse_Email, @Spouse_MobileNo, @Emergency_Name,
                 @Emergency_Number, @Employee_Country);
    
            SET @Employee_Id = (SELECT SCOPE_IDENTITY());
    
            IF(@Employee_Type = ''Teaching'')
            BEGIN
                SET @Class_Id = (SELECT Class_Id FROM LMS_Tbl_Class WHERE Type = ''College'');
                IF(@Class_Id IS NOT NULL)
                BEGIN
                    INSERT INTO LMS_Tbl_Emp_Class(Class_Id, Emp_Id, Is_Class_Owner, Active_Status)
                    VALUES(@Class_Id, @Employee_Id, 0, 1);
                END
            END
    
            UPDATE Tbl_Employee
            SET Active_Status = ''Active''
            WHERE Employee_Id = @Employee_Id;
    
            SELECT @Employee_Id;
        END
    ')
END
