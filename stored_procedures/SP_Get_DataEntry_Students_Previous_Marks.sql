IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_DataEntry_Students_Previous_Marks]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_DataEntry_Students_Previous_Marks]  
  
as   
  
begin  
  
SELECT  distinct  
   cpd.Candidate_Id,    
   cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,    
   cc.Course_Category_Id,    
   cc.Course_Category_Name,   
   DepartmentName = substring((SELECT distinct ( '', '' + cast(cp.Cand_Selected_Priority as varchar(5))+''-''+d.Department_Name )  
From     
Tbl_Candidate_Personal_Det c    
inner Join Tbl_Candidate_CoursePriority cp On c.Candidate_Id=cp.Candidate_Id    
inner Join Tbl_Department d on cp.Department_Id=d.Department_Id    
 WHERE  cp.Candidate_Id=cpd.Candidate_Id    
    FOR XML PATH( '''' )),3,1000) ,  
  
SubjectMark=substring((Select distinct ('', ''+cs.Subject_Name+''-''+cast(cpm.Mark as varchar(5)))  
from dbo.Tbl_Candidate_Previous_Mark cpm   
left join dbo.Tbl_Category_Subject cs on cs.Category_Subject_Id=cpm.Category_Subject_Id  
where cpm.Candidate_Id=cpd.Candidate_Id  
  
FOR XML PATH( '''' )),3,1000)  
  
   
From Tbl_Candidate_Personal_Det cpd    
Inner Join Tbl_Candidate_CoursePriority cp On cpd.Candidate_Id=cp.Candidate_Id    
  
Inner Join Tbl_Course_Category cc on cp.Course_Category_Id=cc.Course_Category_Id    
Inner Join Tbl_Department d on cp.Department_Id=d.Department_Id    
  
left Join Tbl_Student_Shortlist ss on cpd.Candidate_Id=ss.Candidate_Id    
Where cpd.Candidate_Id not in(Select Candidate_Id From Tbl_Student_Shortlist)  
  
END
');
END;
