IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_CLass_Delete_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_CLass_Delete_Status] 

@Class_Id bigint


AS

BEGIN

Update LMS_Tbl_Class
set Delete_Status = 1
where 
Class_Id = @Class_Id 


END
    ')
END
