-- Check if the stored procedure [dbo].[Proc_GetallGradingSchemeById] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetallGradingSchemeById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetallGradingSchemeById](@gradingSchemeId bigint)  
        AS  
        BEGIN  
            SELECT *, 
                   CASE WHEN resit_status = 1 THEN ''Yes'' ELSE ''No'' END AS resit 
            FROM Tbl_GradingScheme 
            WHERE Grade_Scheme_Id = @gradingSchemeId;  

            SELECT GS.*, 
                   CASE WHEN GS.Pass = ''PASS'' THEN ''1'' ELSE ''2'' END AS passvalue 
            FROM Tbl_GradeSchemeSetup GS 
            WHERE Grade_Scheme_Id = @gradingSchemeId;  

            SELECT * 
            FROM Tbl_GradeSpecial 
            WHERE Grade_Scheme_Id = @gradingSchemeId;  
        END
    ')
END
