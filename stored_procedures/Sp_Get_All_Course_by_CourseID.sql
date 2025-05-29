IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Course_by_CourseID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_All_Course_by_CourseID] --2        
(@Course_Id BIGINT)                
                
AS                
BEGIN                
                
SELECT  S.Course_Id,S.Org_Id,tcm.[Assessment_Code],S.AssessmentCode,O.Organization_Name,L.Course_Level_Name,                
S.Org_Id,S.Faculty_Id,S.Course_Name,S.Course_code,S.Course_Credit,  
S.ContactHours,S.SubjectTotalHours,S.Course_GPS,S.Grade_Id,G.Grade_Scheme,S.Course_Type,S.Course_Prequisite,  
S.Active_Status,S.Course_Prequisite,S.Minimum_Students ,S.ResitGrade              
                
from dbo.Tbl_New_Course S                              
left join [dbo].[Tbl_Assessment_Code_Master] tcm on tcm.[Assessment_Code_Id]=s.AssessmentCode    
left join [dbo].[Tbl_GradingScheme] G on G.Grade_Scheme_Id=S.Grade_Id  
left join [dbo].[Tbl_Organzations ] O on O.Organization_Id=S.Org_Id  
left join [dbo].[Tbl_Course_Level] L on L.Course_Level_Id=S.Faculty_Id 
left join [dbo].[Tbl_GradingScheme] RG on RG.Grade_Scheme_Id=S.ResitGrade  

where S.Course_Id=@Course_Id and S.Delete_Status=0     

                
END     
  
  
--select * from Tbl_New_Course  
--select * from Tbl_Course_Level  
  
    ')
END
