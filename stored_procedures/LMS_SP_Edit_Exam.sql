IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Edit_Exam]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Edit_Exam]-- 2          
@Exam_Id bigint             
AS                    
BEGIN              
Declare @ExamType varchar(10)  
set   @ExamType=(select ExamType from LMS_Tbl_OnlineExams where Exam_Id=@Exam_Id)  
  
if(@ExamType=''OE'')  
begin             
select distinct OE.Exam_Id,OE.Semster_Subject_Id,S.Subject_Name,OE.ExamType,cdm.Course_Department_Id,D.Department_Name,cdm.Duration_Mapping_Id,Batch_Code+''-''+Semester_Code as Batch,OE.ExamName,OE.ExamDate,OE.ExamDuration       
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
inner join LMS_Tbl_OnlineExams OE on E.Employee_Id=OE.User_Id and SS.Semester_Subject_Id=OE.Semster_Subject_Id  
inner join   Tbl_Department D on CD.Department_Id=D.Department_Id  
where  Class_TimeTable_Status=0 and E.Employee_Status=0 and SSS.Student_Semester_Current_Status=1         
and OE.Exam_Id=@Exam_Id   
end  
else  
begin      
select  distinct OE.Exam_Id,OE.Semster_Subject_Id,'''' as Subject_Name,OE.ExamType,cdm.Duration_Mapping_Id,cdm.Course_Department_Id,D.Department_Name,Batch_Code+''-''+Semester_Code as Batch,OE.ExamName,OE.ExamDate,OE.ExamDuration       
from  LMS_Tbl_OnlineExams OE          
inner join Tbl_Student_Semester SSS on OE.DurationMapping_Id=SSS.Duration_Mapping_Id          
INNER JOIN Tbl_Course_Duration_Mapping cdm   ON SSS.Duration_Mapping_Id=cdm.Duration_Mapping_Id          
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                            
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                     
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                    
inner join  Tbl_Course_Department CD on   cdm.Course_Department_Id=CD.Course_Department_Id   
inner join   Tbl_Department D on CD.Department_Id=D.Department_Id  
where   SSS.Student_Semester_Current_Status=1           
and OE.Exam_Id=@Exam_Id   
end    
          
          
END
    ')
END
