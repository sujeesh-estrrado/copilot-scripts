IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[get_coursename]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[get_coursename]  
As  
Begin  
Select ''1'' as dept,Department_Name,Department_Id,Course_Code from dbo.Tbl_Department 
where Department_Status=0  
  
End
    ')
END;