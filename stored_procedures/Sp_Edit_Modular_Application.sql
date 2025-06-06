IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Edit_Modular_Application]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Edit_Modular_Application]
(
    @Modular_Candidate_Id bigint
)
AS
BEGIN
    SELECT 
        MC.Modular_Candidate_Id,
        MC.Ic_Passport,
        MC.Salutation,
        MC.Candidate_Fname,
        MC.Candidate_Lname,
        MC.Email,
        MC.Contact,
        MC.Type,
        MC.Gender,
        MC.Modular_Course_Id,
        MC.Payment_Method,
        MC.SponsorID,
        MC.Country AS Country_Id,
        C.Country AS Country_Name,
        MC.Modular_Slot_Id,
        MC.Country_Code
    FROM 
        Tbl_Modular_Candidate_Details MC
    INNER JOIN 
        Tbl_Country C ON MC.Country = C.Country_Id
    WHERE 
        MC.Modular_Candidate_Id = @Modular_Candidate_Id AND MC.Delete_Status=0
END
   ')
END;
