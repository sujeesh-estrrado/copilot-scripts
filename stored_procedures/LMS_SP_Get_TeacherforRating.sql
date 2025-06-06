IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_TeacherforRating]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_TeacherforRating] --446              
@Candidate_Id bigint         
                            
AS                                                            
BEGIN               
  Declare @DurationMapping_Id bigint       
  --select distinct Duration_Mapping_Id from LMS_Tbl_StudPerformance  where Candidate_Id=@Candidate_Id         
set @DurationMapping_Id=(select distinct Duration_Mapping_Id from Tbl_Student_Semester       
where Student_Semester_Delete_Status=0 and Student_Semester_Current_Status=1        
and Candidate_Id=@Candidate_Id)         
      
select distinct S.Subject_Name+'' (''+E.Employee_FName+'' ''+E.Employee_LName+'')'' as Teacher,CT.Employee_Id,
@DurationMapping_Id as DurationMapping_Id,SS.Semester_Subject_Id from Tbl_Subject S                
inner join Tbl_Department_Subjects DS on S.Subject_Id=DS.Subject_Id                
inner join Tbl_Semester_Subjects SS on DS.Department_Subject_Id=SS.Department_Subjects_Id                
inner join Tbl_Class_TimeTable CT on SS.Semester_Subject_Id=CT.Semster_Subject_Id    
inner join Tbl_Employee E on  CT.Employee_Id=E.Employee_Id    
where  Class_TimeTable_Status=0  and CT.Duration_Mapping_Id=@DurationMapping_Id and E.Employee_Status=0  
and  @Candidate_Id not in (select Student_Id from LMS_Tbl_SubWiseTeacherRating
where Status=0)      
END
    ')
END
