IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[filledit]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[filledit]   
(
    @candidate int = '''',
    @Flag BIGINT = 0
)
AS    
BEGIN    
    IF (@Flag = 0)
    BEGIN  
       
            SELECT 
            Modular_Candidate_Id,Ic_Passport,Salutation,Candidate_Fname,mc.CourseCode,
            Candidate_Lname,Email,Contact,Type,Country,Gender,Modular_Course_Id,Modular_Slot_Id,Country_Code
            ,Candidate_Id,Payment_Method,SponsorID,Status,Application_Status
               from Tbl_Modular_Candidate_Details 
               left join tbl_Modular_Courses as mc on mc.Id=Modular_Course_Id
               where Modular_Candidate_Id=@candidate
END
end
    ')
END;
