IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_CLass_Approve]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_CLass_Approve]

@Class_Id bigint


AS

BEGIN

Update LMS_Tbl_Class
set Active_Status = 1
where 
Class_Id = @Class_Id 


END
    ')
END
