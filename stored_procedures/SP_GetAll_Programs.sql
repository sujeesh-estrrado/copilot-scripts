IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Programs]') 
    AND type = N'P'
)
BEGIN
    EXEC('
           
CREATE procedure [dbo].[SP_GetAll_Programs]  --3,'''',1    
@Flag int = 0,    
@Org varchar(max)='''',                   
@Course_Category_Id bigint=0 ,  
@Department_Id bigint=0  
AS                      
                      
BEGIN                      
    if @Flag=0    
 begin                
  SELECT DISTINCT     
                         TOP (100) PERCENT D.Department_Id, D.Department_Name, D.Department_Descripition, D.Course_Code, C.Program_Code, CD.ProviderId, PM.ProviderCode,     
                         C.Course_Category_Id, D.Intro_Date, CL.Course_Level_Name, CD.Course_Department_Id, C.Course_Category_Name, D.Submission_Date, D.MQA_Approval_Date,     
                         D.MOE_Approval_Date, D.Payment_Date, D.Expiry_Date, D.Renewal_Code, D.Renewal_Date, D.Accreditation_Date, D.Active_Status, D.Created_Date,     
                         D.Updated_Date, D.Delete_Status, O.Organization_Name,Hypothesiedcode,D.MQA_Approval_Date,D.MOE_Approval_Date,D.Payment_Date,D.Expiry_Date,D.Renewal_Code,D.Renewal_Date,D.Accreditation_Date    
FROM            dbo.Tbl_Department AS D INNER JOIN    
                         dbo.[Tbl_Organzations ] AS O ON D.Org_Id = O.Organization_Id LEFT OUTER JOIN    
                         dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id LEFT OUTER JOIN    
                         dbo.Tbl_ProviderMaster AS PM ON PM.ProviderId = CD.ProviderId LEFT OUTER JOIN    
                         dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = CD.Course_Category_Id LEFT OUTER JOIN    
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId    
WHERE        (D.Department_Status = 0) AND (D.Delete_Status = 0)    
ORDER BY D.Department_Name     
 end     
 if @Flag=1    
 begin                
  SELECT DISTINCT      
            TOP (100) PERCENT D.Department_Id, concat(D.Course_Code,'' - '',D.Department_Name) as Department_Name, D.Department_Descripition, D.Course_Code, C.Program_Code, CD.ProviderId, PM.ProviderCode,     
        C.Course_Category_Id, D.Intro_Date, CL.Course_Level_Name, CD.Course_Department_Id, C.Course_Category_Name, D.Submission_Date, D.MQA_Approval_Date,     
        D.MOE_Approval_Date, D.Payment_Date, D.Expiry_Date,Hypothesiedcode, D.Renewal_Code, D.Renewal_Date, D.Accreditation_Date, D.Active_Status, D.Created_Date,     
        D.Updated_Date, D.Delete_Status, O.Organization_Name    
  FROM            dbo.Tbl_Department AS D LEFT OUTER JOIN    
       dbo.[Tbl_Organzations ] AS O ON D.Org_Id = O.Organization_Id LEFT OUTER JOIN    
        dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id LEFT OUTER JOIN    
        dbo.Tbl_ProviderMaster AS PM ON PM.ProviderId = CD.ProviderId LEFT OUTER JOIN    
        dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = CD.Course_Category_Id LEFT OUTER JOIN    
        dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId    
  WHERE        (D.Department_Status = 0)and (D.Delete_Status = 0)and (D.Active_Status = ''Active'')    
  ORDER BY Department_Name      
 end       
 if @Flag=2    
 begin                
  SELECT DISTINCT     
        TOP (100) PERCENT D.Department_Id, D.Department_Name,Hypothesiedcode, D.Department_Descripition, D.Course_Code, C.Program_Code, CD.ProviderId, PM.ProviderCode,     
        C.Course_Category_Id, D.Intro_Date, CL.Course_Level_Name, CD.Course_Department_Id, C.Course_Category_Name, D.Submission_Date, D.MQA_Approval_Date,     
        D.MOE_Approval_Date, D.Payment_Date, D.Expiry_Date, D.Renewal_Code, D.Renewal_Date, D.Accreditation_Date, D.Active_Status, D.Created_Date,     
        D.Updated_Date, D.Delete_Status, O.Organization_Name    
  FROM            dbo.Tbl_Department AS D LEFT OUTER JOIN    
       dbo.[Tbl_Organzations ] AS O ON D.Org_Id = O.Organization_Id LEFT OUTER JOIN    
        dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id LEFT OUTER JOIN    
        dbo.Tbl_ProviderMaster AS PM ON PM.ProviderId = CD.ProviderId LEFT OUTER JOIN    
        dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = CD.Course_Category_Id LEFT OUTER JOIN    
        dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId    
  WHERE        (D.Department_Status = 0)and (D.Delete_Status = 0)and (D.Active_Status = ''Active'') and (O.Organization_Name=@Org)    
  ORDER BY D.Department_Name      
 end                
     if @Flag=3    
 begin                
  SELECT D.Department_Id,concat(D.Department_Name,'' - '',Course_Code) as Department_Name    
   FROM dbo.Tbl_Department AS D INNER JOIN    
                         dbo.[Tbl_Organzations ] AS O ON D.Org_Id = O.Organization_Id LEFT OUTER JOIN    
                         dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id LEFT OUTER JOIN    
                         dbo.Tbl_ProviderMaster AS PM ON PM.ProviderId = CD.ProviderId LEFT OUTER JOIN    
                         dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = CD.Course_Category_Id LEFT OUTER JOIN    
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId    
WHERE        (D.Department_Status = 0) AND (D.Delete_Status = 0) and C.Course_Category_Id=@Course_Category_Id    
ORDER BY D.Department_Name     
 end     
       
     if @Flag=4    
 begin                
  SELECT D.Department_Id,concat(D.Department_Name,'' - '',Course_Code) as Department_Name,Modeofstudy,GraduationTypeId,Program_Type_Id ,Hypothesiedcode   
   FROM dbo.Tbl_Department AS D   
     
WHERE    D.Department_Id=@Department_Id    
  
 end                  
END    
    ')
END
GO
