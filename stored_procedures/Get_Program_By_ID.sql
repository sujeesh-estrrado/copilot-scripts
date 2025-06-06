IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Program_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_Program_By_ID] --3              
(@Department_Id bigint)                      
                      
AS                      
                      
BEGIN                      
                           
  Select D.Department_Id,D.Department_Name,D.Department_Descripition,D.Course_Code,Modeofstudy,                    
         C.Program_Code,CD.ProviderId,PM.ProviderCode ,C.Course_Category_Id,D.Department_Descripition,D.Intro_Date,CL.Course_Level_Name,          
           CL.Course_Level_Id,C.Course_Category_Id,D.Org_Id, D.Submission_Date,D.MQA_Approval_Date,D.MOE_Approval_Date,D.Payment_Date,          
     D.Expiry_Date,D.Renewal_Code,D.Renewal_Date,D.Accreditation_Date,AnnualPracticingCertification,PartnerUniversity,HypothesiedCode ,Online_checkstatus           
                           
   from  Tbl_Department D             
   left join  Tbl_Course_Department CD on CD.Department_Id=D.Department_Id                    
    left join Tbl_ProviderMaster PM on PM.ProviderId=CD.ProviderId                  
    left join Tbl_Course_Category C on C.Course_Category_Id=CD.Course_Category_Id                 
    left join  Tbl_Course_Level CL on CL.Course_Level_Id=D.GraduationTypeId                  
                      
                     
 where D.Department_Id=@Department_Id                      
END    
    ')
END
