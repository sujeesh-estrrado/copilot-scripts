IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Gert_ExamDetails_ByBatch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Gert_ExamDetails_ByBatch]   --6
@Duration_Mapping_Id bigint                
                
as                
begin                
                

    
    
    
                
----select distinct Exam_Term as ExamCode,Exam_Term AS Id           
----from Tbl_Exam_Code_Master A    
----inner JOIN Tbl_Department_Subjects D ON D.Subject_Id=A.Subject_Id                 
----inner JOIN Tbl_Semester_Subjects SD ON SD.Department_SubjectS_Id=D.Department_Subject_Id      
--WHERE sD.Duration_Mapping_Id=@Duration_Mapping_Id      

select * from Tbl_Exam_Master where Duration_Period_id=@Duration_Mapping_Id and Result_PublishStatus=1
end      
--////////////////////////////////////////////// 

    ')
END
