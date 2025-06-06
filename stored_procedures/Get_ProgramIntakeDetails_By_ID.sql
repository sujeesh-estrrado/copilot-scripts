IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_ProgramIntakeDetails_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_ProgramIntakeDetails_By_ID] --3      
(@Batch_Id bigint)              
              
AS              
              
BEGIN              
                   
 SELECT        D.Department_Id, D.Department_Name, D.Department_Descripition, D.Course_Code, C.Program_Code, CD.ProviderId, PM.ProviderCode, C.Course_Category_Id, D.Department_Descripition AS Expr1, D.Intro_Date,   
                         CL.Course_Level_Name, CL.Course_Level_Id, C.Course_Category_Id AS Expr2, D.Org_Id, D.Submission_Date, D.MQA_Approval_Date, D.MOE_Approval_Date, D.Payment_Date, D.Expiry_Date, D.Renewal_Code,   
                         D.Renewal_Date, D.Accreditation_Date, D.AnnualPracticingCertification, CBD.IntakeMasterID, CBD.intake_month, CBD.intake_year,  CBD.Batch_Code,FORMAT (CBD.Batch_From , ''dd/MM/yyyy '') as Batch_From,FORMAT (CBD.Batch_To , ''dd/MM/yyyy '') as Batch_To   
FROM            dbo.Tbl_Department AS D INNER JOIN  
                         dbo.Tbl_Course_Batch_Duration AS CBD ON D.Department_Id = CBD.Duration_Id LEFT OUTER JOIN  
                         dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id LEFT OUTER JOIN  
                         dbo.Tbl_ProviderMaster AS PM ON PM.ProviderId = CD.ProviderId LEFT OUTER JOIN  
                         dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = CD.Course_Category_Id LEFT OUTER JOIN  
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId  
WHERE        (CBD.Batch_Id = @Batch_Id)           
END 
    ')
END
