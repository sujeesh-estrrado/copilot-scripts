IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Candidate_University_Regno_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Candidate_University_Regno_Insert]   
@Candidate_Id bigint,  
@University_Regno varchar(300)
AS  
BEGIN  

DELETE FROM Tbl_Candidate_University_Regno Where Candidate_Id=@Candidate_Id

 INSERT INTO [Tbl_Candidate_University_Regno]
            (Candidate_Id
           ,University_Regno)
     VALUES
           (@Candidate_Id
           ,@University_Regno)
END

   ')
END;
