IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Non_TeachingEmployee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_All_Non_TeachingEmployee]     
  
As  
Begin  
  
Select 
Employee_Id,  
Employee_FName+'' ''+Employee_LName as EmployeeName,  
Employee_Type  
from Tbl_Employee where Employee_Type=''Non-Teaching'' and Employee_Status=0 
  
End
    ')
END
