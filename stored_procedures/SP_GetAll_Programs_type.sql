IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Programs_type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Programs_type]  --3,'''',1          
        @Flag INT = 0,          
        @Type VARCHAR(50) = '''',                     
        @Status BIGINT = 0,                    
        @Department_Id BIGINT = 0,        
        @Intake_Id BIGINT = 0     
    AS                            

    BEGIN
        -- For Flag 1
        IF @Flag = 1
        BEGIN
            SELECT DISTINCT            
                TOP (100) PERCENT 
                D.Department_Id, 
                CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name, 
                D.Department_Descripition, 
                D.Course_Code, 
                C.Program_Code, 
                CD.ProviderId, 
                PM.ProviderCode,           
                C.Course_Category_Id, 
                D.Intro_Date, 
                CL.Course_Level_Name, 
                CD.Course_Department_Id, 
                C.Course_Category_Name, 
                D.Submission_Date, 
                D.MQA_Approval_Date,           
                D.MOE_Approval_Date, 
                D.Payment_Date, 
                D.Expiry_Date, 
                D.Hypothesiedcode, 
                D.Renewal_Code, 
                D.Renewal_Date, 
                D.Accreditation_Date, 
                D.Active_Status, 
                D.Created_Date,           
                D.Updated_Date, 
                D.Delete_Status, 
                O.Organization_Name          
            FROM dbo.Tbl_Department AS D 
            LEFT JOIN dbo.[Tbl_Organzations] AS O ON D.Org_Id = O.Organization_Id 
            LEFT JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id 
            LEFT JOIN dbo.Tbl_ProviderMaster AS PM ON PM.ProviderId = CD.ProviderId 
            LEFT JOIN dbo.Tbl_Course_Category AS C ON C.Course_Category_Id = CD.Course_Category_Id 
            LEFT JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId   
            LEFT JOIN Tbl_New_Admission AS NA ON NA.Department_Id = D.Department_Id 
            LEFT JOIN Tbl_Candidate_Personal_Det AS CPD ON CPD.New_Admission_Id = NA.Department_Id    
            WHERE D.Department_Status = 0
                AND D.Delete_Status = 0
                AND D.Active_Status = ''Active'' 
                AND CASE 
                        WHEN CPD.ApplicationStatus = ''pending'' THEN ''Enquiry''
                        WHEN CPD.ApplicationStatus = ''Pending'' THEN ''Enquiry''
                        WHEN CPD.ApplicationStatus = ''submited'' THEN ''Enquiry''
                        WHEN CPD.ApplicationStatus = ''Completed'' THEN ''Student''
                    END = @Type
            ORDER BY Department_Name          
        END

        -- For Flag 2
        IF @Flag = 2
        BEGIN            
            SELECT 
                BD.Batch_Id,
                BD.Duration_Id AS DurationID,
                BD.Batch_Code AS BatchCode,
                BD.Batch_From,
                BD.Batch_To,                                               
                BD.Study_Mode,                                          
                PD.Program_Duration_Type,                      
                PD.Program_Duration_Year,               
                PD.Program_Duration_Month,                  
                BD.Intro_Date,                    
                BD.SyllubusCode       
            FROM dbo.Tbl_Course_Batch_Duration BD                             
            INNER JOIN Tbl_Program_Duration PD ON BD.Duration_Id = PD.Duration_Id                        
            INNER JOIN dbo.Tbl_Department D ON D.Department_Id = PD.Program_Category_Id     
            INNER JOIN dbo.Tbl_Course_Department AS CD ON CD.Department_Id = D.Department_Id     
            WHERE BD.Batch_DelStatus = 0 
                AND CD.Department_Id = @Department_Id    
            ORDER BY BD.Batch_Id DESC    
        END
    END
    ')
END
GO
