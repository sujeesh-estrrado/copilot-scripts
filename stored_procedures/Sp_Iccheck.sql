IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Iccheck]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Iccheck]   
(
    @icpassport VARCHAR(50) = '''',
    @Flag BIGINT = 0
)
AS    
BEGIN    
    IF (@Flag = 0)
    BEGIN  
        -- Check in Tbl_Candidate_Personal_Det
        IF EXISTS (
            SELECT 1 
            FROM Tbl_Candidate_Personal_Det 
            WHERE AdharNumber = @icpassport
        )
        BEGIN
            SELECT 
                p.Candidate_Id,
                p.Candidate_Fname,
                p.Candidate_Lname,
                p.Candidate_Gender,
                p.TypeOfStudent,
                p.Salutation,
                p.Candidate_Nationality,
                C.Candidate_Email,
                LEFT(C.Candidate_Mob1, CHARINDEX(''-'', C.Candidate_Mob1) - 1) AS CountryCode,
                SUBSTRING(C.Candidate_Mob1, CHARINDEX(''-'', C.Candidate_Mob1) + 1, LEN(C.Candidate_Mob1)) AS PhoneNumber,
                1 AS Exist
            FROM Tbl_Candidate_Personal_Det AS p
            LEFT JOIN Tbl_Candidate_ContactDetails AS C 
                ON C.Candidate_Id = p.Candidate_Id
            WHERE p.AdharNumber = @icpassport
        END
        ELSE
        BEGIN
            -- Check in Tbl_Modular_Candidate_Details
            IF EXISTS (
                SELECT 1 
                FROM Tbl_Modular_Candidate_Details 
                WHERE Ic_Passport = @icpassport
            )
            BEGIN
                SELECT 
                    mc.Candidate_Id,
                    mc.Candidate_Fname,
                    mc.Candidate_Lname,
                    mc.Gender AS Candidate_Gender,
                    mc.Type AS TypeOfStudent,
                    mc.Salutation,
                    mc.Country AS Candidate_Nationality,
                    mc.Email AS Candidate_Email,
                    mc.Country_Code AS CountryCode,
                    mc.Contact AS PhoneNumber,
                    1 AS Exist
                FROM Tbl_Modular_Candidate_Details AS mc
                WHERE mc.Ic_Passport = @icpassport
            END
            ELSE
            BEGIN
                -- No match found in either table
                SELECT 0 AS Exist
            END
        END
    END  
END
    ')
END;
