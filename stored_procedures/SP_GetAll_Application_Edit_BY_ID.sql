IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Application_Edit]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_Application_Edit]         
AS BEGIN      
      
SELECT  Tbl_Candidate_Personal_Det.Candidate_Id as ID,Tbl_Candidate_Personal_Det.Candidate_Fname as [Name],        
Tbl_Candidate_Personal_Det.Candidate_Gender as [Gender],        
Tbl_Candidate_Personal_Det.Religion as [Religion],Tbl_Candidate_Personal_Det.Caste as [Caste],        
Tbl_Candidate_ContactDetails.Candidate_Email as Email,Tbl_Candidate_ContactDetails.Candidate_Mob1 as Mobile,        
dbo.Tbl_Candidate_PaymentDet.Application_Status as [Status],NA.New_Admission_Id,        
Tbl_Candidate_HSCDet.Candidate_MonthofPass+'' ''+        
Tbl_Candidate_HSCDet.Candidate_YearofPass as [HSEYearOfPass],        
        
  
C.Course_Level_Name as Course_LEVEL,        
        
CC.Course_Category_Name as Course_Category,        
        
        
NA.Course_Level_Id as Course_LEVEL_Id,        
        
NA.Course_Category_Id as Course_Category_Id         
       
,Tbl_Candidate_Personal_Det.Initial_Application_Id,Tbl_Candidate_Personal_Det.New_Admission_Id ,      
cbd.Batch_Id as BatchID,cbd.Batch_Code as Batch ,    
NA.Department_Id ,    
D.Department_Name as Department    
from dbo.Tbl_Candidate_Personal_Det         
        
left join Tbl_Candidate_ContactDetails on Tbl_Candidate_Personal_Det.Candidate_Id=Tbl_Candidate_ContactDetails.Candidate_Id        
--left join Tbl_Candidate_CoursePriority on Tbl_Candidate_Personal_Det.Candidate_Id=Tbl_Candidate_CoursePriority.Candidate_Id        
left join Tbl_Candidate_PaymentDet on Tbl_Candidate_Personal_Det.Candidate_Id=Tbl_Candidate_PaymentDet.Candidate_Id        
left join Tbl_Candidate_HSCDet on Tbl_Candidate_Personal_Det.Candidate_Id=Tbl_Candidate_HSCDet.Candidate_Id        
inner join tbl_New_Admission NA On NA.New_Admission_Id=Tbl_Candidate_Personal_Det.New_Admission_Id   
inner join Tbl_Course_Category  CC on CC.Course_Category_Id=NA.Course_Category_Id  
INNER JOIN Tbl_Course_Level C on C.Course_Level_Id=NA.Course_Level_Id     
inner join Tbl_Course_Batch_Duration cbd on cbd.Batch_Id=NA.Batch_Id      
inner Join Tbl_Department D On D.Department_Id=NA.Department_Id    
        
where Tbl_Candidate_Personal_Det.Candidate_DelStatus=0 order by Tbl_Candidate_Personal_Det.Candidate_Id     desc 
end
    ');
END
GO