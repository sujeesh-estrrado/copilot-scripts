IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPLOYEES_WITHTIMETABLE_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GET_EMPLOYEES_WITHTIMETABLE_Report]      
      @Location_Id bigint=0
AS BEGIN      
      
SELECT DISTINCT E.Employee_Id,E.Employee_FName+'' ''+E.Employee_LName AS EMPNAME FROM dbo.Tbl_Employee E      
--INNER JOIN dbo.Tbl_Class_TimeTable CT ON CT.Employee_Id=E.Employee_Id      
WHERE --CT.Class_TimeTable_Status=0 AND
E.Employee_Status=0     
     -- and CT.Del_Status=0
END
	');
END;
