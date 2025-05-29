IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPLOYEE_CERTIFICATE_BY_EMPLOYEE_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GET_EMPLOYEE_CERTIFICATE_BY_EMPLOYEE_ID]   --2  
 @Employee_Id bigint    
AS    
BEGIN    
SELECT Certificate_Id,Employee_Id,Title,Image_Path    
FROM Tbl_Employee_Certificates    
WHERE Employee_Id= @Employee_Id    
END

'

);
END;
