IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Proc_CLass_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_Proc_CLass_Update] 

@Class_Id bigint,
@Class_Name varchar(200)


AS

BEGIN

Update LMS_Tbl_Class
set Class_Name=@Class_Name
where
Class_Id = @Class_Id 
        
END
    ')
END
