IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Inactive_New_Admission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Inactive_New_Admission]

AS

BEGIN

select * from dbo.tbl_New_Admission 
where Admission_Status=1

End
    ')
END
