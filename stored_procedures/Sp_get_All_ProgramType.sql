IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_get_All_ProgramType]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_get_All_ProgramType]
As
Begin 
Select Course_Category_Id,(Course_Category_Name) as Program_Code from dbo.Tbl_Course_Category where Course_Category_Status=0 
End
    ');
END
