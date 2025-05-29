IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_User_By_EmpID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employee_User_By_EmpID]

(@Employee_Id bigint)

AS

BEGIN 

SELECT*FROM dbo.Tbl_Employee_User

WHERE Employee_Id=@Employee_Id

ORDER BY user_Id DESC

END

	');
END;
