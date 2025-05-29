IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Getall_Employees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Getall_Employees] 
(@Flag bigint=0)
as
begin
                                      
if(@Flag=0)
begin                                        
SELECT Employee_Id,concat(Employee_Fname,'' '',Employee_Lname)as EmployeeName 
from Tbl_Employee where Employee_Status=0


end
                                                        
    END
');
END;