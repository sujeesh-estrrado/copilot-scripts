IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_getEmpoyeeuserupdate]') 
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
CREATE PROCEDURE [dbo].[SP_getEmpoyeeuserupdate]     
@employee_id bigint ,    
@Active_Status varchar(10)=''''    
AS      
BEGIN      
update Tbl_Employee set Active_Status=@Active_Status where Employee_Id=@employee_id
END  ';
END;
