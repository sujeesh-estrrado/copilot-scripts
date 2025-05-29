IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Hstl_AddHostel_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Hstl_AddHostel_GetAll]	
AS
BEGIN
	SELECT a.Hostel_Id, a.Hostel_Name, a.Hostel_Address, a.Hostel_City, a.Hostel_State, a.Hostel_Phone_Number, 
	a.Hostel_Category, a.Hostel_Incharge, b.Employee_Id, b.Employee_FName, b.Employee_LName,
	c.Department_Id, d.Department_Name FROM dbo.Tbl_Hstl_AddHostel a 
	LEFT JOIN dbo.Tbl_Employee b ON a.Hostel_Incharge = b.Employee_Id 
	LEFT JOIN dbo.Tbl_Employee_Official c ON b.Employee_Id = c.Employee_Id
	LEFT JOIN dbo.Tbl_Department d ON c.Department_Id = d.Department_Id
	WHERE a.Hostel_Delete_Status = 0
END    
    ');
END;
