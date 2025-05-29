IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Tbl_Candidate_RollNumber_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Tbl_Candidate_RollNumber_Insert]   
@Candidate_Id bigint,  
@Duration_Mapping_Id bigint,  
@RollNumber int  
AS  
BEGIN  
DELETE FROM Tbl_Candidate_RollNumber Where Duration_Mapping_Id=@Duration_Mapping_Id and Candidate_Id=@Candidate_Id
 INSERT INTO [Tbl_Candidate_RollNumber]  
           ([Candidate_Id]  
           ,[Duration_Mapping_Id]  
           ,[RollNumber])  
     VALUES  
           (  
            @Candidate_Id  
           ,@Duration_Mapping_Id  
           ,@RollNumber)  
END

   ')
END;
