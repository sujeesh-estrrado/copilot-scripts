IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_ExamSUBJSTUDMAPCHILD]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_INSERT_ExamSUBJSTUDMAPCHILD]                
(@Subject_Master_Id bigint,@Subject_Id bigint,@SubJectName varchar(50),            
@SubjectCode varchar(50),@AssesmentCode varchar(50),@GradingScheme varchar(50),            
@ExamCode varchar(50),          
@CurrentStatus varchar(50),          
@Term varchar(50))                
                
AS BEGIN                
      declare @count bigint              
declare @master bigint              
              
set @count=(select count(ExamCode) from dbo.Tbl_StudentExamSubjectsChild               
where ExamCode=@ExamCode and StudentExamSubjectMasterId=@Subject_Master_Id and Term=@Term and SubjectId=@Subject_Id)          
if(@count=0)          
begin           
INSERT INTO dbo.Tbl_StudentExamSubjectsChild(          
StudentExamSubjectMasterId,                
SubjectId,            
SubjectName,            
SubjectCode,            
AssesmentCode,            
GradingScherme,            
ExamCode,          
CurrentStatus,          
  Term          
            
)             
VALUES(@Subject_Master_Id,@Subject_Id,            
@SubJectName,@SubjectCode,            
@AssesmentCode,@GradingScheme,@ExamCode,          
@CurrentStatus,          
@Term          
)                
                
SELECT SCOPE_IDENTITY()                
  end          
  else          
  begin          
  select ''0''          
  end              
END   

    ')
END;
