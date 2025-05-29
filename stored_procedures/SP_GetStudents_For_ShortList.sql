IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStudents_For_ShortList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetStudents_For_ShortList]    
AS    
BEGIN    
SELECT    
   cpd.Candidate_Id,    
   cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,    
   cc.Course_Category_Id,    
   cc.Course_Category_Name,    
 (case when sd.Candidate_Percentage is not null then ''SSLC-''+ cast(sd.Candidate_Percentage as varchar(100))+''%''     
  else '''' end)+    
 (case when hd.Candidate_Percentage is not null then '',HSC-''+ cast(hd.Candidate_Percentage as varchar(100))+''%''     
  else '''' end)+    
 (case when ugd.Candidate_Percentage is not null then '',UG-''+cast(ugd.Candidate_Percentage as varchar(100))+''%''     
  else '''' end)+    
 (case when pgd.Candidate_Percentage is not null then '',PG-''+cast(pgd.Candidate_Percentage as varchar(100))+''%''     
  else '''' end)    
   As TotalMarks,    
   DepartmentName = substring((SELECT distinct ( '', '' + cast(cp.Cand_Selected_Priority as varchar(5))+''-''+d.Department_Name )                               
From     
Tbl_Candidate_Personal_Det c    
inner Join Tbl_Candidate_CoursePriority cp On c.Candidate_Id=cp.Candidate_Id    
inner Join Tbl_Department d on cp.Department_Id=d.Department_Id    
 WHERE  cp.Candidate_Id=cpd.Candidate_Id    
    FOR XML PATH( '''' )),3,1000)    
From Tbl_Candidate_Personal_Det cpd    
Inner Join Tbl_Candidate_CoursePriority cp On cpd.Candidate_Id=cp.Candidate_Id    
Inner Join Tbl_Course_Category cc on cp.Course_Category_Id=cc.Course_Category_Id    
Inner Join Tbl_Department d on cp.Department_Id=d.Department_Id    
left Join Tbl_Candidate_SSLC_Det sd on cpd.Candidate_Id=sd.Candidate_Id     
left Join Tbl_Candidate_HSCDet hd on cpd.Candidate_Id=hd.Candidate_Id    
left Join Tbl_Candidate_UGDet ugd on cpd.Candidate_Id=ugd.Candidate_Id    
left Join Tbl_Candidate_PGDet pgd on cpd.Candidate_Id=pgd.Candidate_Id    
left Join Tbl_Student_Shortlist ss on cpd.Candidate_Id=ss.Candidate_Id    
Where cpd.Candidate_Id not in(Select Candidate_Id From Tbl_Student_Shortlist)  
GROUP BY     
cpd.Candidate_Id,    
cpd.Candidate_Fname,    
cpd.Candidate_Mname,    
cpd.Candidate_Lname,    
cc.Course_Category_Name,    
sd.Candidate_Percentage,    
hd.Candidate_Percentage,    
ugd.Candidate_Percentage,    
pgd.Candidate_Percentage,    
cc.Course_Category_Id    
END
    ');
END;
