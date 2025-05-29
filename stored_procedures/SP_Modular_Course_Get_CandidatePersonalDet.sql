IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Course_Get_CandidatePersonalDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('


CREATE PROCEDURE [dbo].[SP_Modular_Course_Get_CandidatePersonalDet]             
    @Candidate_Id BIGINT                                  
AS                                  
BEGIN     
   SELECT 
   mc.status,
   MC.Modular_Candidate_Id,
    MC.Candidate_Fname + '' '' + MC.Candidate_Lname AS CandidateName,      
    MC.Ic_Passport AS AdharNumber,
    MC.Ic_Passport AS ICPassport,
    mc.Create_Date as RegDate,
    MC.Gender,
    MC.Type,
    MC.Modular_Course_Id,
    MC.Email,
    C.Nationality AS Nationality,
   '' ('' + CAST(MC.Country_Code AS VARCHAR(10)) + '')''+ CAST(MC.Contact AS VARCHAR(50))   AS Contact,
    MC.Application_Status AS ModularCourseStatus,
    MC.Modular_Slot_Id
FROM 
    Tbl_Modular_Candidate_Details MC
    Inner Join Tbl_Nationality C on MC.Country=C.Nationality_Id
    WHERE 
        MC.Modular_Candidate_Id = @Candidate_Id
         AND MC.Delete_Status=0
END
    ')
END;
