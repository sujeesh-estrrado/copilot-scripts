IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_EMPLOYEE_CERTIFICATE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DELETE_EMPLOYEE_CERTIFICATE]   
 @Certificate_Id bigint 
AS  
BEGIN  
DELETE FROM Tbl_Employee_Certificates WHERE Certificate_Id=@Certificate_Id
END
    ')
END
