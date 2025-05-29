IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Hstl_Floor_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Hstl_Floor_GetAll]  
   
AS  
BEGIN  
 SELECT a.Floor_Id, a.Hostel_Id, b.Hostel_Name, a.Block_Id, c.Block_Name, a.Floor_Name, a.Floor_Code,   
 a.Floor_incharge, d.Employee_FName, d.Employee_LName FROM dbo.Tbl_Hstl_Floor a LEFT JOIN dbo.Tbl_HostelRegistration b  
 ON a.Hostel_Id = b.Hostel_Id   
 LEFT JOIN dbo.Tbl_Hostel_Block c ON c.Block_Id = a.Block_Id  
 LEFT JOIN dbo.Tbl_Employee d ON d.Employee_Id = a.Floor_incharge  
 WHERE a.Floor_Del_Status = 0  
END    
    ');
END;
