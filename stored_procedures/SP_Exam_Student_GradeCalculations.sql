IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Student_GradeCalculations]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Exam_Student_GradeCalculations] --3,60950                                                                              
(                                                                        
@flag bigint=0,                                              
@Exam_Master_id bigint=0  ,    
@Semester_Id bigint=0,    
@EntryType varchar(Max)=''R2'',    
@Student_Id bigint=0 ,  
@CGP decimal(18,2)=0,  
@CGPA decimal(18,2)=0,  
@GradePoint_Semester decimal(18,2)=0,  
@Total_GP decimal(18,2)=0,  
@Cumulative_Credit_Score decimal(18,2)=0  
)                                                                             
AS                                                                              
                                                                              
BEGIN     
if(@flag=0)    
begin    
if not exists (select Student_Id from Tbl_Student_GradeStatus where Student_Id=@Student_Id and EntryType=@EntryType and Exam_Master_id=@Exam_Master_id and Semester_Id=@Semester_Id)  
begin  
Insert into Tbl_Student_GradeStatus (Exam_Master_id,Student_Id,Semester_Id,CGP,GPA,CGPA,GradePoint_Semester,Total_GP,Cumulative_Credit_Score,EntryType,Created_Date,Delete_Status)  
values(@Exam_Master_id,@Student_Id,@Semester_Id,@CGP,@GradePoint_Semester,@CGPA,@GradePoint_Semester,@Total_GP,@Cumulative_Credit_Score,@EntryType,getdate(),0)  
end  
end  
if(@flag=1)  
begin  
Update Tbl_Student_GradeStatus set CGP=@CGP  
,CGPA=@CGPA  
,GradePoint_Semester=@GradePoint_Semester  
,Total_GP=@Total_GP  
,Cumulative_Credit_Score=@Cumulative_Credit_Score  
 where Student_Id=@Student_Id and EntryType=@EntryType and Exam_Master_id=@Exam_Master_id and Semester_Id=@Semester_Id  
end    
if(@flag=2)  
begin  
select isnull(CGP,0.00)as CGP from Tbl_Student_GradeStatus  
 where Student_Id=@Student_Id and EntryType=@EntryType and Exam_Master_id=@Exam_Master_id and Semester_Id=@Semester_Id  
end    
if(@flag=3)  
begin  
select isnull(GPA,0.00)as GPA from Tbl_Student_GradeStatus  
 where Student_Id=@Student_Id and EntryType=@EntryType and Exam_Master_id=@Exam_Master_id and Semester_Id=@Semester_Id  
end   
if(@flag=4)  
begin  
select isnull(Gradepoint_Semester,0.00)as Gradepoint_Semester from Tbl_Student_GradeStatus  
 where Student_Id=@Student_Id and EntryType=@EntryType  and Semester_Id=@Semester_Id --and Exam_Master_id=@Exam_Master_id  
end   
if(@flag=5)  
begin  
select isnull(Total_GP,0.00)as Total_GP from Tbl_Student_GradeStatus  
 where Student_Id=@Student_Id and EntryType=@EntryType and Exam_Master_id=@Exam_Master_id and Semester_Id=@Semester_Id  
end   
if(@flag=6)  
begin  
select isnull(Sum(CGPA)/count(CGPA),0.00)as CGPA from Tbl_Student_GradeStatus  
 where Student_Id=@Student_Id and EntryType=@EntryType and Semester_Id=@Semester_Id--and Exam_Master_id=@Exam_Master_id   
end   
if(@flag=7)  
begin  
select isnull(Cumulative_Credit_Score,0.00) as Cumulative_Credit_Score from Tbl_Student_GradeStatus  
 where Student_Id=@Student_Id and EntryType=@EntryType and Exam_Master_id=@Exam_Master_id and Semester_Id=@Semester_Id  
end   
END    

   ')
END;
