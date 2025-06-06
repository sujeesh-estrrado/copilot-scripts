IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_SubjectsforExam]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_SubjectsforExam] --277,45   
@Employee_Id bigint          ,
@Duration_Mapping_Id bigint
AS                
BEGIN          
             
select distinct S.Subject_Name ,CT.Semster_Subject_Id
from Tbl_Subject S                    
inner join Tbl_Department_Subjects DS on S.Subject_Id=DS.Subject_Id                    
inner join Tbl_Semester_Subjects SS on DS.Department_Subject_Id=SS.Department_Subjects_Id                    
inner join Tbl_Class_TimeTable CT on SS.Semester_Subject_Id=CT.Semster_Subject_Id        
inner join Tbl_Employee E on  CT.Employee_Id=E.Employee_Id        
inner join Tbl_Student_Semester SSS on CT.Duration_Mapping_Id=SSS.Duration_Mapping_Id      
INNER JOIN Tbl_Course_Duration_Mapping cdm   ON CT.Duration_Mapping_Id=cdm.Duration_Mapping_Id      
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                        
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                 
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                
inner join  Tbl_Course_Department CD on   cdm.Course_Department_Id=CD.Course_Department_Id       
where  Class_TimeTable_Status=0 and E.Employee_Status=0 and SSS.Student_Semester_Current_Status=1     
and E.Employee_Id=@Employee_Id  and CT.Duration_Mapping_Id=@Duration_Mapping_Id    
     
      
      
END
    ')
END
