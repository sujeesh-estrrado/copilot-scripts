IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_ApplicationStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Candidate_ApplicationStatus]    -- 1008, ''Candidate_Second ''             
(@Candidate_Id bigint,
 @Display_Status varchar(Max)
 )                    
AS                    
BEGIN                    
UPDATE Tbl_Candidate_Personal_Det                    
SET
Display_Status=@Display_Status where Candidate_Id=@Candidate_Id
end
    ')
END;
