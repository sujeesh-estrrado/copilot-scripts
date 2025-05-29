IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_Department_by_faculty_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetAll_Department_by_faculty_id] --8  
(@facultyid bigint)  
  
AS  
  
BEGIN  
  
 SELECT DISTINCT   
                         TOP (100) PERCENT D.Department_Id, D.Department_Name, D.Department_Descripition, D.Course_Code, C.Program_Code, CD.ProviderId, PM.ProviderCode,   
                         C.Course_Category_Id, D.Intro_Date, CL.Course_Level_Name, CD.Course_Department_Id, C.Course_Category_Name, D.Submission_Date, D.MQA_Approval_Date,   
                         D.MOE_Approval_Date, D.Payment_Date, D.Expiry_Date, D.Renewal_Code, D.Renewal_Date, D.Accreditation_Date, D.Active_Status, D.Created_Date,   
                         D.Updated_Date, D.Delete_Status, O.Organization_Name,D.MQA_Approval_Date,D.MOE_Approval_Date,D.Payment_Date,D.Expiry_Date,D.Renewal_Code,D.Renewal_Date,D.Accreditation_Date,Hypothesiedcode
FROM            dbo.Tbl_Department AS D INNER JOIN  
 dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId inner join  
                         dbo.[Tbl_Organzations ] AS O ON D.Org_Id = O.Organization_Id   
        inner join Tbl_Emp_CourseDepartment_Allocation EM on em.Allocated_CourseDepartment_Id=CL.Course_Level_Id LEFT OUTER JOIN  
                         dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id LEFT OUTER JOIN  
                         dbo.Tbl_ProviderMaster AS PM ON PM.ProviderId = CD.ProviderId LEFT OUTER JOIN  
                         dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = CD.Course_Category_Id   
                          
WHERE        (D.Department_Status = 0) AND (D.Delete_Status = 0 and EM.Employee_Id=@facultyid )  
   
END  

');
END;