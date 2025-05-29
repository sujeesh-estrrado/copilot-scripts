IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Teaching_Department_By_EmpID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_Teaching_Department_By_EmpID]
(@Employee_Id bigint)
AS
BEGIN
SELECT *    
FROM         Tbl_Course_Duration_Mapping CDM INNER JOIN
                      Tbl_Subject_Hours_PerWeek SHW ON CDM.Duration_Mapping_Id = SHW.Duration_Mapping_Id
Where Employee_Id=@Employee_Id
END

    ');
END;
