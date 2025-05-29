IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_validate_icpassport_forexist]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE PROCEDURE [dbo].[SP_Get_validate_icpassport_forexist]
    -- Add the parameters for the stored procedure here
    (
@username varchar(100),
@Candidate_Id bigint
)
AS
BEGIN
    

  --SELECT top 1  * from dbo.Tbl_Candidate_Personal_Det where ApplicationStatus != ''rejected'' and AdharNumber=@username  and candidate_id = @Candidate_Id 

  SELECT candidate_id  from dbo.Tbl_Candidate_Personal_Det where ApplicationStatus != ''rejected'' and AdharNumber=@username -- and candidate_id = @Candidate_Id 
    

END


    ')
END
