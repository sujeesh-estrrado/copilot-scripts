IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectExamTermforCampus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SelectExamTermforCampus]  
(@Campus varchar(100))       
as         
begin        
select distinct(Exam_Term) from dbo.Tbl_Exam_Code_Master where Campus= @Campus      
end

    ')
END;
