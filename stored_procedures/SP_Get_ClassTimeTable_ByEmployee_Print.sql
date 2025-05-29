IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimeTable_ByEmployee_Print]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_ClassTimeTable_ByEmployee_Print]                       
 (                               
  @Employee_Id         BIGINT          
 
)                                    
AS                                     
BEGIN  
 
 SELECT DISTINCT
DE.Department_Name AS Program, 
concat(CBD.Batch_Code , ''-'' , cs.Semester_Code) AS BatchSemester,
CBD.Batch_From,
CBD.Batch_To,    
CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS EmployeeName 

FROM Tbl_Class_TimeTable			 CT
INNER JOIN Tbl_New_Course			 C   ON CT.Semster_Subject_Id=C.Course_Id
INNER JOIN Tbl_Course_Department	 CD  ON CD.Course_Department_Id=CT.Department_Id                  
INNER JOIN Tbl_Course_Category		 CC  ON CC.Course_Category_Id=CD.Course_Category_Id             
INNER JOIN Tbl_Department			 DE  ON DE.Department_Id=CT.Department_Id 
INNER JOIN Tbl_Semester_Subjects     SS  ON CT.Semster_Subject_Id=SS.Department_Subjects_Id
INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CT.Duration_Mapping_Id=CDP.Duration_Period_Id
INNER JOIN Tbl_Course_Batch_Duration CBD ON  CDP.Batch_Id=CBD.Batch_Id
INNER JOIN Tbl_Employee              E   ON  CT.Employee_Id=E.Employee_Id
INNER JOIN Tbl_Course_Semester	     CS  ON CS.Semester_Id = CDP.Semester_Id                   
           
   WHERE CT.Employee_Id=@Employee_Id
                                    
END')
END;
