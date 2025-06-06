IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Attendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Attendance]
        AS
        BEGIN
            SELECT 
                dbo.Tbl_Attendance.Atte_Device_Id,
                dbo.Tbl_Attendance.Atte_Id,
                dbo.Tbl_Attendance.Atte_Type_Id,
                dbo.Tbl_Attendance.Employee_Id, 
                dbo.Tbl_Attendance.Atte_Punch_Time,
                dbo.Tbl_Attendance.Atte_Device_Type, 
                dbo.Tbl_Employee.Employee_FName + dbo.Tbl_Employee.Employee_LName AS Employee, 
                dbo.Tbl_Attendance_Device.Atte_Device_Name, 
                dbo.Tbl_Attendance_Type.Attendance_Type_Name
            FROM 
                dbo.Tbl_Attendance 
            INNER JOIN 
                dbo.Tbl_Employee ON dbo.Tbl_Attendance.Employee_Id = dbo.Tbl_Employee.Employee_Id 
            INNER JOIN 
                dbo.Tbl_Attendance_Device ON dbo.Tbl_Attendance.Atte_Device_Id = dbo.Tbl_Attendance_Device.Atte_Device_Id 
            INNER JOIN 
                dbo.Tbl_Attendance_Type ON dbo.Tbl_Attendance.Atte_Type_Id = dbo.Tbl_Attendance_Type.Attendance_Type_Id
            WHERE 
                dbo.Tbl_Attendance_Type.Attendance_Type_Status = 0 
                AND dbo.Tbl_Attendance_Device.Atte_Device_Status = 0 
                AND dbo.Tbl_Employee.Employee_Status = 0
                AND dbo.Tbl_Attendance.Atte_Verified_Status = 0
        END
    ')
END
