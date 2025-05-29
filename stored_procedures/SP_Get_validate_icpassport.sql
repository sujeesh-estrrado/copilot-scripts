IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_validate_icpassport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
create PROCEDURE [dbo].[SP_Get_validate_icpassport]
    -- Add the parameters for the stored procedure here
    (
@username varchar(100)
)
AS
BEGIN
    

  SELECT top 1  * from dbo.Tbl_Candidate_Personal_Det where ApplicationStatus != ''rejected'' and AdharNumber=@username  order by 1 
    

END


    ')
END
