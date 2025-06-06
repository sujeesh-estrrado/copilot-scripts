IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_New_Admission_by_NewAdmn_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_New_Admission_by_NewAdmn_Id] (@Nw_Admission_id BIGINT)
        AS
        BEGIN
            SELECT * 
            FROM dbo.tbl_New_Admission 
            WHERE New_Admission_Id = @Nw_Admission_id
        END
    ')
END
