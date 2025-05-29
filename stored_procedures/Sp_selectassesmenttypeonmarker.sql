IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_selectassesmenttypeonmarker]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_selectassesmenttypeonmarker]  
(@CourseCode varchar(50),  
@term varchar(50),  
@marker varchar(50),  
@SubjectID bigint)  
as  
begin  
select   
distinct ECC.AssesmentType  
from dbo.Tbl_Exam_Code_Master ECM   
inner join dbo.Tbl_Exam_Code_Child ECC on ECC.Exam_Code_Master_Id=ECM.Exam_Code_Master_Id  
inner join dbo.Tbl_Exam_Mark_Entry_Child EMEC on EMEC.ExamCode=ECC.Exam_Code_final   
inner join Tbl_Subject S on ECM.Subject_Id=S.Subject_Id  
inner join Tbl_Subject_Master SM on SM.Subject_Master_Code_Id=S.Subject_Master_Code_Id  
inner join dbo.Tbl_GradingScheme GS on GS.Grade_Scheme=SM.Grading_Scheme  
inner join dbo.Tbl_GradeSchemeSetup GSS on GSS.Grade_Scheme_Id=GS.Grade_Scheme_Id and GSS.Grade=EMEC.Grade  
where EMEC.Course_Code=@CourseCode and ECM.Exam_Term=@term and ECM.Subject_Id=@SubjectID and EMEC.Marker=@marker  
end
');
END;