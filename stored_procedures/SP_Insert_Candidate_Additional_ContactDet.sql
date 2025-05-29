IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Candidate_Additional_ContactDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Insert_Candidate_Additional_ContactDet]  
(@Candidate_Id bigint,@Candidate_BrotherSister_Status bit,@Candidate_Name varchar(100),@Candidate_Standard varchar(50),  
@Candidate_Division varchar(50),@Candidate_Previous_School varchar(100),  
 @Candidate_Previous_School_Place varchar(100),@Candidate_Boarder_Status bit,  
@Candidate_Dayscholar_Status bit,@Candidate_SchoolBus_Number varchar(100),@Candidate_BoardingPoint varchar(100),@Candidate_IdentificationMarks varchar(200),  
@Candidate_MotherTounge varchar(50))  
   
AS  
BEGIN  
BEGIN TRAN  
INSERT INTO dbo.Tbl_Candidate_Additional_Details(Candidate_Id,[Candidate_Brother_Sister_OfThe _Applicant_Studyng_InThis_School],Candidate_Brother_Sister_Name,Standard,  
Division,Candidate_Name_OfThe_School_Last_Attended,  
 Candidate_Place_OfThe_School_Last_Attended,Candidate_Boarder,  
Candidate_Dayscholar,Candidate_School_Bus_Number,Candidate_Boarding_Point,Candidate_Identification_Marks,  
Candidate_Mother_Tounge)  
VALUES  
(@Candidate_Id,@Candidate_BrotherSister_Status,@Candidate_Name,@Candidate_Standard,  
@Candidate_Division,@Candidate_Previous_School,  
 @Candidate_Previous_School_Place,@Candidate_Boarder_Status,  
@Candidate_Dayscholar_Status,@Candidate_SchoolBus_Number,@Candidate_BoardingPoint,@Candidate_IdentificationMarks,  
@Candidate_MotherTounge)  
  
select Scope_identity()  
COMMIT TRAN   
  
END  
    ')
END;
