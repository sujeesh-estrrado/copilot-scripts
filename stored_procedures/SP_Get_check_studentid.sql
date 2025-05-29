IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_check_studentid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_check_studentid]
	-- Add the parameters for the stored procedure here
	(
@studentid varchar(100)
)
AS
BEGIN
	

    -- Insert statements for procedure here
SELECT * 
FROM dbo.Tbl_Candidate_Personal_Det
WHERE IDMatrixNo=@studentid
	
END
');
END;
