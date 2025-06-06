IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_StudentSubmitStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        create procedure [dbo].[SP_Update_StudentSubmitStatus]    -- 1008, ''Candidate_Second ''             
(@Candidate_Id bigint,
 @ApplicationStatus varchar(Max)
 )                    
AS                    
BEGIN                    
UPDATE Tbl_Student_NewApplication                    
SET
ApplicationStatus=@ApplicationStatus where Candidate_Id=@Candidate_Id
end
    ')
END;
