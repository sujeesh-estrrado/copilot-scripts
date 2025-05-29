IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_Admission_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Candidate_Admission_Type]        
(@Candidate_Id bigint
,@Type varchar(100))        
         
AS        
BEGIN        
UPDATE Tbl_Candidate_Personal_Det        
SET         
AdmissionType=@Type        

WHERE Candidate_Id=@Candidate_Id and Candidate_DelStatus=0        
        
        
END



    ')
END;
