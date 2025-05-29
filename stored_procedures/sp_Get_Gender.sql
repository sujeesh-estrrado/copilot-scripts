IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Gender]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[sp_Get_Gender]         
        
AS
BEGIN
select Gender_Id,Gender_Name
FROM
tbl_Gender

END
    ')
END
