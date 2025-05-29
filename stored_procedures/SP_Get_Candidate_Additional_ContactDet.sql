IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_Additional_ContactDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Candidate_Additional_ContactDet](@Candidate_Id bigint)  
as  
begin  
select [Candidate_Brother_Sister_OfThe _Applicant_Studyng_InThis_School],Candidate_Brother_Sister_Name,Standard,Division,  
Candidate_Name_OfThe_School_Last_Attended,Candidate_Place_OfThe_School_Last_Attended,Candidate_Boarder,Candidate_Dayscholar,Candidate_School_Bus_Number,Candidate_Boarding_Point,Candidate_Identification_Marks,Candidate_Mother_Tounge
from  dbo.Tbl_Candidate_Additional_Details where Candidate_Id=@Candidate_Id   
  
end
    
    ')
END;
