IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_CourseName]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure  [dbo].[Sp_Get_All_CourseName]
As
Begin 

Select Department_Id,Department_Name from  dbo.Tbl_Department where Department_Status=0

End
    ')
END
