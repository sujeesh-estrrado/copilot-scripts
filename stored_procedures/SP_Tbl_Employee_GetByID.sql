IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_GetByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_GetByID]
            @Empid BIGINT
        AS
        BEGIN
            SELECT Employee_FName, 
                   Employee_Id, 
                   Employee_FName, 
                   Employee_LName, 
                   Employee_DOB, 
                   Employee_Gender, 
                   Employee_Permanent_Address, 
                   Employee_Present_Address, 
                   Employee_Phone, 
                   Employee_Mail, 
                   Employee_Mobile, 
                   Employee_Martial_Status, 
                   Blood_Group, 
                   Employee_Id_Card_No, 
                   Employee_Nationality, 
                   Employee_Experience_If_Any, 
                   Employee_Father_Name, 
                   Employee_Nominee_Name, 
                   Employee_Nominee_Relation, 
                   Employee_Nominee_Phone, 
                   Employee_Nominee_Address, 
                   Employee_Status, 
                   Employee_Type, 
                   Employee_Img, 
                   Employee_Aadhar, 
                   Employee_FName + '' '' + Employee_LName AS Employee_Name,
                   Employee_DOB AS DOB,
                   Employee_Gender AS Gender,
                   Employee_Mobile AS Mobile
            FROM [Tbl_Employee]
            WHERE Employee_Status = 0
              AND Employee_Id = @Empid
        END
    ')
END
