IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Name_And_Mobile_Number]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE procedure  [dbo].[SP_Get_Employee_Name_And_Mobile_Number]
@dept_Id bigint	
AS
BEGIN
	SELECT eo.Employee_Id,e.Employee_FName +'' ''+e.Employee_LName as Employee ,e.Employee_Mobile ,eo.Department_Id
FROM Tbl_Employee_Official eo INNER JOIN  Tbl_Employee e ON eo.Employee_Id = e.Employee_Id 
where  eo.Department_Id=@dept_Id
END

	');
END;
