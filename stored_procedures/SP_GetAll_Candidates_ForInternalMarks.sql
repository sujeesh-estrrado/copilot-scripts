IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Candidates_BySemesterSubjectID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_Candidates_BySemesterSubjectID]  (@Semester_Subjects_Id bigint)       
AS        
BEGIN        
Declare @Parent_Id bigint        
Set @Parent_Id=(        
Select Parent_Subject_Id From Tbl_Semester_Subjects SS Inner Join Tbl_Department_Subjects DS        
On DS.Department_Subject_Id=SS.Department_Subjects_Id Inner Join Tbl_Subject S On S.Subject_Id=DS.Subject_Id        
Where SS.Semester_Subject_Id=@Semester_Subjects_Id        
)        
        
IF(@Parent_Id=0)        
Begin        
 Select              
         
  S.Candidate_Id,          
  S.Duration_Mapping_Id,         
  SS.Semester_Subject_Id,           
  Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname As [CandidateName],        
  Isnull(CIM.Internal_Marks,0) As Internal_Marks,      
  CRN.RollNumber, CUR.University_Regno,      
  IM.Total_Marks,IM.Min_Marks        
         
  From Tbl_Student_Semester S            
  Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id=C.Candidate_Id            
  Inner Join dbo.Tbl_Semester_Subjects SS On SS.Duration_Mapping_Id=S.Duration_Mapping_Id        
  Left Join Tbl_Exam_Internal_Marks IM On IM.Semester_Subject_Id=SS.Semester_Subject_Id        
  Left Join Tbl_Exam_Candidate_Internal_Marks CIM On CIM.Exam_InternalMarks_Id=IM.Exam_InternalMarks_Id and CIM.Candidate_Id=C.Candidate_Id        
Left Join Tbl_Candidate_RollNumber CRN on CRN.Candidate_Id=C.Candidate_Id       
Left Join dbo.Tbl_Candidate_University_Regno CUR on CUR.Candidate_Id = C.Candidate_Id       
  Where  SS.Semester_Subject_Id=@Semester_Subjects_Id and Student_Semester_Delete_Status=0      
and Student_Semester_Current_Status=1   and C.Candidate_DelStatus=0       
  Order By CandidateName          
End        
        
Else/* Elective Subjects*/        
Begin        
 select         
        
SE.Candidate_Id,        
SE.Semester_Subjects_Id,        
SS.Duration_Mapping_Id,        
CP.Candidate_Fname+'' ''+CP.Candidate_Mname+'' ''+CP.Candidate_Lname as [CandidateName],        
  Isnull(CIM.Internal_Marks,0) As Internal_Marks,IM.Total_Marks,IM.Min_Marks,  
CRN.RollNumber, CUR.University_Regno        
from dbo.Tbl_Semester_Elective_Students SE        
        
INNER JOIN Tbl_Semester_Subjects SS on  SE.Semester_Subjects_Id=SS.Semester_Subject_Id        
INNER JOIN Tbl_Candidate_Personal_Det CP on SE.Candidate_Id=CP.Candidate_Id        
Left Join Tbl_Exam_Internal_Marks IM On IM.Semester_Subject_Id=SS.Semester_Subject_Id        
Left Join Tbl_Exam_Candidate_Internal_Marks CIM On CIM.Exam_InternalMarks_Id=IM.Exam_InternalMarks_Id and CIM.Candidate_Id=CP.Candidate_Id        
Left Join Tbl_Candidate_RollNumber CRN on CRN.Candidate_Id=SE.Candidate_Id       
Left Join dbo.Tbl_Candidate_University_Regno CUR on CUR.Candidate_Id = SE.Candidate_Id       
        
where SE.Semester_Subjects_Id=@Semester_Subjects_Id  and CP.Candidate_DelStatus=0         
    
End        
        
        
END
    ')
END
GO