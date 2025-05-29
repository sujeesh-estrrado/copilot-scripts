IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Search_Employee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Search_Employee]

as

begin


  
Select e.Employee_Id,e.Employee_FName+'' ''+e.Employee_LName+'' '' as [Employee Name],e.Employee_Id_Card_No 
 FROM [Tbl_Employee] e 

end');
END;