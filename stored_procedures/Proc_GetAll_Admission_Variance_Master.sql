IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Admission_Variance_Master]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_GetAll_Admission_Variance_Master]

AS
BEGIN

Select * from  Tbl_admission_variance_master  

END
    ')
END;
