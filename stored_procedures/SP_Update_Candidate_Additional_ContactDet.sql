IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_Additional_ContactDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Candidate_Additional_ContactDet](@Candidate_Id bigint,@Candidate_Brother_Sister bit,  
@Brother_Sister_Name varchar(100),@Standard varchar(50),@Division varchar(50),@Candidate_Previous_School varchar(100),@Candidate_Previous_School_Place varchar(100),@Boarder_Status bit,  
@Dayscholar_Status bit,@School_Bus_Number varchar(100),@Boarding_Point varchar(100),@Identification_Marks varchar(200),@Mother_Tounge varchar(50)  
)  
  
  
   
AS  
BEGIN  
UPDATE Tbl_Candidate_Additional_Details  
SET  
Candidate_Id=@Candidate_Id,  
[Candidate_Brother_Sister_OfThe _Applicant_Studyng_InThis_School]=@Candidate_Brother_Sister,  
Candidate_Brother_Sister_Name=@Brother_Sister_Name,  
Standard=@Standard,  
Division=@Division,  
Candidate_Name_OfThe_School_Last_Attended=@Candidate_Previous_School,  
Candidate_Place_OfThe_School_Last_Attended=@Candidate_Previous_School_Place,  
Candidate_Boarder=@Boarder_Status,  
Candidate_Dayscholar=@Dayscholar_Status,  
Candidate_School_Bus_Number=@School_Bus_Number,  
Candidate_Boarding_Point=@Boarding_Point,  
Candidate_Identification_Marks=@Identification_Marks,  
Candidate_Mother_Tounge=@Mother_Tounge  
 
  
WHERE @Candidate_Id=Candidate_Id  
  
END
    ')
END;
