IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Leave_Setting_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Leave_Setting_By_Id](@Grade_Id bigint)
as
begin
SELECT      dbo.Tbl_Leave_Settings.Leave_Settings_Id as ID,dbo.Tbl_Leave_Settings.Grade_Id, dbo.Tbl_Employee_Grade.Emp_Grade_Name as [Grade Name], dbo.Tbl_Leave_Type.Leave_Type_Name as [LeaveType Name], 
                      dbo.Tbl_Leave_Settings.Leave_Settings_MaxLeave as MaxLeave, dbo.Tbl_Leave_Settings.Leave_Type_Id, dbo.Tbl_Leave_Settings.Leave_DateFrom as FromDate, 
                      dbo.Tbl_Leave_Settings.Leave_DateTo as ToDate, dbo.Tbl_Leave_Settings.Leave_Per_MonthYear
FROM         dbo.Tbl_Leave_Settings INNER JOIN
                      dbo.Tbl_Employee_Grade ON dbo.Tbl_Leave_Settings.Grade_Id = dbo.Tbl_Employee_Grade.Emp_Grade_Id INNER JOIN
                      dbo.Tbl_Leave_Type ON dbo.Tbl_Leave_Settings.Leave_Type_Id = dbo.Tbl_Leave_Type.Leave_Type_Id
 where Tbl_Leave_Settings.Leave_Delete_Status=0 and dbo.Tbl_Leave_Settings.Grade_Id=@Grade_Id

end
    ')
END
