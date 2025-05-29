IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_marketing_Stange_Status]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create PROCEDURE [dbo].[Sp_Get_marketing_Stange_Status]
	
AS
BEGIN

	select id,name from Tbl_Student_status where id not  between 2 and 13 and id != 15 and id not between 17 and 18

END
    ')
END
