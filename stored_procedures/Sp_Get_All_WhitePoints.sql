IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_WhitePoints]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_All_WhitePoints]  
AS  
BEGIN  
  
  SELECT wp.*,e.Employee_FName+'' ''+e.Employee_LName as Teachr_Name from dbo.LMS_Tbl_WhitePoits wp  
 inner join dbo.Tbl_Employee e on e.Employee_Id=wp.Employee_Id  
END
    ');
END
