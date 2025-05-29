IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectExamCodeForChangingStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SelectExamCodeForChangingStatus] -- ''Campus1'',''2018 new year''          
(@Campus varchar(100),@Exam_Term varchar(100))            
as            
begin            
            
select distinct(GC.ExamCode) ExamCode,GC.ExamDescription,Convert(varchar(10),GC.ExamDate,103) ExamDate,  --Convert(varchar(10),GC.ExamDate,103) ExamDate,    
ECM.Assessment_Code,ECC.AssesmentType,SM.Grading_Scheme,    
case GC.OpenStatus when ''1'' then ''Opened''    
when ''0'' then ''Closed'' end as OpenStatus    
from Tbl_GroupChangeExamDates GC            
inner join  Tbl_Exam_Code_Child ECC on ECC.Exam_Code_final=GC.ExamCode            
inner join Tbl_Exam_Code_Master ECM on ECC.Exam_Code_Master_Id=ECM.Exam_Code_Master_Id            
inner join Tbl_Assessment_Type AT on ECC.AssesmentType=AT.Assesment_Type        
inner join Tbl_Subject S on S.Subject_Id=ECM.Subject_Id         
inner join   Tbl_Subject_Master SM on SM.Subject_Master_Code_Id=S.Subject_Master_Code_Id           
inner join Tbl_Assessment_Code_Child ACC on ACC.Assessment_Type_Id=AT.Assessment_Type_Id             
where ECM.Campus=@Campus and ECM.Exam_Term=@Exam_Term and  GC.ExamTerm=@Exam_Term         
end  
    ')
END;
