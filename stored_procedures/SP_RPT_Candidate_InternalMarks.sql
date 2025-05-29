IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_Candidate_InternalMarks]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_RPT_Candidate_InternalMarks]     
@Duration_Mapping_Id bigint         
As      
Begin    
DECLARE @Mapping_ID varchar(10)    
SET @Mapping_ID=cast (@Duration_Mapping_Id As varchar(10))    
DECLARE @query VARCHAR(4000)      
      
DECLARE @subjects VARCHAR(2000)      
SELECT  @subjects = STUFF(( SELECT DISTINCT      
                        ''],['' + Subject_Code      
                        FROM    Tbl_Semester_Subjects SS        
 INNER JOIN Tbl_Course_Duration_Mapping CDM On SS.Duration_Mapping_Id=CDM.Duration_Mapping_Id          
 INNER JOIN Tbl_Course_Duration_PeriodDetails CDP On CDM.Duration_Period_Id=CDP.Duration_Period_Id          
 INNER JOIN Tbl_Department_Subjects DS On SS.Department_Subjects_Id=DS.Department_Subject_Id        
 INNER JOIN Tbl_Subject S on DS.Subject_Id=S.Subject_Id        
 INNER JOIN Tbl_Student_Semester ST on ST.Duration_Mapping_Id=SS.Duration_Mapping_Id        
 INNER JOIN Tbl_Candidate_Personal_Det C On C.Candidate_Id=ST.Candidate_Id           
 INNER JOIN Tbl_Candidate_RollNumber CR on CR.Candidate_Id=C.Candidate_Id       
 Left Join Tbl_Exam_Internal_Marks IM On IM.Semester_Subject_Id=SS.Semester_Subject_Id        
 Left Join Tbl_Exam_Candidate_Internal_Marks CIM On CIM.Exam_InternalMarks_Id=IM.Exam_InternalMarks_Id and CIM.Candidate_Id=C.Candidate_Id          
 Where SS.Semester_Subjects_Status=0  and SS.Duration_Mapping_Id=@Duration_Mapping_Id and      
(select Count(Subject_Id) From Tbl_Subject Where Parent_Subject_Id=S.Subject_Id)=0        
 Group By S.Subject_Code,CR.RollNumber,C.Candidate_Fname+Candidate_Mname+Candidate_Lname,CIM.Internal_Marks      
                        ORDER BY ''],['' + Subject_Code      
                        FOR XML PATH('''')      
                        ), 1, 2, '''') + '']''      
      
      
SET @query =      
''SELECT * FROM      
(      
SELECT       
CR.RollNumber,          
 C.Candidate_Fname+'''' ''''+Candidate_Mname+'''' ''''+Candidate_Lname As [Student Name],        
 S.Subject_Code,      
 ISNULL(cast(CIM.Internal_Marks as varchar(100)),''''NA'''') As Internal_Marks        
 From   Tbl_Semester_Subjects SS        
 INNER JOIN Tbl_Course_Duration_Mapping CDM On SS.Duration_Mapping_Id=CDM.Duration_Mapping_Id          
 INNER JOIN Tbl_Course_Duration_PeriodDetails CDP On CDM.Duration_Period_Id=CDP.Duration_Period_Id          
 INNER JOIN Tbl_Department_Subjects DS On SS.Department_Subjects_Id=DS.Department_Subject_Id        
 INNER JOIN Tbl_Subject S on DS.Subject_Id=S.Subject_Id        
 INNER JOIN Tbl_Student_Semester ST on ST.Duration_Mapping_Id=SS.Duration_Mapping_Id        
 INNER JOIN Tbl_Candidate_Personal_Det C On C.Candidate_Id=ST.Candidate_Id           
 INNER JOIN Tbl_Candidate_RollNumber CR on CR.Candidate_Id=C.Candidate_Id       
 Left Join Tbl_Exam_Internal_Marks IM On IM.Semester_Subject_Id=SS.Semester_Subject_Id        
 Left Join Tbl_Exam_Candidate_Internal_Marks CIM On CIM.Exam_InternalMarks_Id=IM.Exam_InternalMarks_Id and CIM.Candidate_Id=C.Candidate_Id          
 Where SS.Semester_Subjects_Status=0  and SS.Duration_Mapping_Id = ''+@Mapping_ID+'' and       
(select Count(Subject_Id) From Tbl_Subject Where Parent_Subject_Id=S.Subject_Id)=0        
 Group By S.Subject_Code,CR.RollNumber,C.Candidate_Fname+'''' ''''+Candidate_Mname+'''' ''''+Candidate_Lname,CIM.Internal_Marks      
)t      
PIVOT (MAX(Internal_Marks) FOR Subject_Code      
IN (''+@subjects+'')) AS pvt''      
EXECUTE (@query)      
      
      
End
')
END