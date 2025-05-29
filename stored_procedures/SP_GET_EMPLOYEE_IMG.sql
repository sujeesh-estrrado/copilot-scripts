IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPLOYEE_IMG]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GET_EMPLOYEE_IMG]
@Employee_Id bigint
AS
BEGIN
		SELECT Employee_Img FROM Tbl_Employee
WHERE Employee_Id=@Employee_Id 
END

'

);
END;
