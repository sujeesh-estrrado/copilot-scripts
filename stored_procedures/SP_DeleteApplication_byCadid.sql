IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteApplication_byCadid]') 
    AND type = N'P'
)
BEGIN
    EXEC('

create procedure [dbo].[SP_DeleteApplication_byCadid]  
(
@Candidate_id bigint=0
)
AS
BEGIN
     IF EXISTS (SELECT * FROM Tbl_Candidate_Personal_Det WHERE Candidate_Id=@Candidate_Id )
     Begin
    UPDATE Tbl_Candidate_Personal_Det SET Candidate_DelStatus=1 WHERE Candidate_Id=@Candidate_id
    select 100  AS RETVAL 
    end
    else
    begin 
    select 0  AS RETVAL 
    end
END
    ')
END
