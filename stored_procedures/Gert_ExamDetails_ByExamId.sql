IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Gert_ExamDetails_ByExamId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Gert_ExamDetails_ByExamId]
@ExamTerm VARCHAR(100)        
        
as        
begin        
        

  
select distinct Id, C.ExamCode,ExamDescription, CONVERT(VARCHAR(10),C.ExamDate,103) as ExamDate,  
Invigilator,Venue,ExamTerm,            
case OpenStatus        
when ''0'' then ''Closed''            
else ''Open''            
end as OpenStatus,CONVERT(VARCHAR(5),[From],108)+''-''+CONVERT(VARCHAR(5),[To],108)  as time_exam,Subject_Name          
            
from Tbl_Exam_Code_Master A  
inner join dbo.Tbl_Exam_Code_Child B on B.Exam_Code_Master_Id=A.Exam_Code_Master_Id  
INNER JOIN Tbl_GroupChangeExamDates C ON C.EXAMCODE=B.EXAM_CODE_FINAL  
inner JOIN Tbl_Department_Subjects D ON D.Subject_Id=A.Subject_Id               
inner JOIN Tbl_Semester_Subjects SD ON SD.Department_SubjectS_Id=D.Department_Subject_Id    
inner JOIN Tbl_Subject S ON s.Subject_Id=A.Subject_Id         
WHERE  ExamTerm=@ExamTerm --and OpenStatus=1    
  
      
end

    ')
END
ELSE
BEGIN
EXEC('        ALTER procedure [dbo].[Gert_ExamDetails_ByExamId]
@ExamTerm VARCHAR(100)        
        
as        
begin        
        

  
select distinct Id, C.ExamCode,ExamDescription, CONVERT(VARCHAR(10),C.ExamDate,103) as ExamDate,  
Invigilator,Venue,ExamTerm,            
case OpenStatus        
when ''0'' then ''Closed''            
else ''Open''            
end as OpenStatus,CONVERT(VARCHAR(5),[From],108)+''-''+CONVERT(VARCHAR(5),[To],108)  as time_exam,Subject_Name          
            
from Tbl_Exam_Code_Master A  
inner join dbo.Tbl_Exam_Code_Child B on B.Exam_Code_Master_Id=A.Exam_Code_Master_Id  
INNER JOIN Tbl_GroupChangeExamDates C ON C.EXAMCODE=B.EXAM_CODE_FINAL  
inner JOIN Tbl_Department_Subjects D ON D.Subject_Id=A.Subject_Id               
inner JOIN Tbl_Semester_Subjects SD ON SD.Department_SubjectS_Id=D.Department_Subject_Id    
inner JOIN Tbl_Subject S ON s.Subject_Id=A.Subject_Id         
WHERE  ExamTerm=@ExamTerm --and OpenStatus=1    
  
      
end
')
END