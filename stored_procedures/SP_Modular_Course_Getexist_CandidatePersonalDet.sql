IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Course_Getexist_CandidatePersonalDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Modular_Course_Getexist_CandidatePersonalDet]             
    @Candidate_Id BIGINT                                  
AS                                  
BEGIN     
   SELECT 
      mc.status,
    MC.Candidate_Fname AS CandidateName,
    MC.Ic_Passport AS AdharNumber,
    MC.Ic_Passport AS ICPassport,
    MC.Gender,
    MC.Type,
    MC.Email,
    C.Country AS Nationality,
   '' ('' + CAST(MC.Country_Code AS VARCHAR(10)) + '')''+ CAST(MC.Contact AS VARCHAR(50))   AS Contact,
    MC.Application_Status AS ModularCourseStatus
FROM 
    Tbl_Modular_Candidate_Details MC
    Inner Join Tbl_Country C on MC.Country=C.Country_Id
    WHERE 
        MC.Candidate_Id = @Candidate_Id
END
    ')
END;
