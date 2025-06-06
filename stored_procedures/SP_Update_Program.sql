IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Program]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Update_Program]                    
            @Department_Id BIGINT,
            @Department_Name VARCHAR(300),
            @Department_Descripition VARCHAR(500),
            @CourseCode VARCHAR(50),              
            @Introdate DATETIME,
            @GraduationTypeId BIGINT,
            @Submission_date DATETIME,          
            @MQA_Approval_date DATETIME,
            @MOE_Approval_date DATETIME,
            @Payment_date DATETIME,          
            @Expiry_date DATETIME,
            @Renewal_date DATETIME,
            @Renewal_code VARCHAR(50),
            @Accreditation_date DATETIME,        
            @OrganizationId BIGINT,
            @AnnualPracticingCertification VARCHAR(MAX),
            @PartnerUniversity BIGINT = 0,      
            @HypothesiedCode VARCHAR(MAX) = '''',
            @Program_Type_Id BIGINT,
            @Online_checkstatus BIGINT,  
            @Modeofstudy BIGINT = 0,
            @PrgmDuration VARCHAR(50) = ''''
        AS                    
        BEGIN
        

            -- Check if the department name already exists with status 0 and a different ID
            IF EXISTS (
                SELECT 1 FROM dbo.Tbl_Department 
                WHERE Department_Name = @Department_Name 
                AND Department_Status = 0 
                AND Department_Id <> @Department_Id
            )                                
            BEGIN                                
                RAISERROR (''Data Already Exists.'', 16, 1);
                RETURN;
            END                                

            -- Update department details
            UPDATE dbo.Tbl_Department                    
            SET                     
                Department_Name = @Department_Name,                    
                Department_Descripition = @Department_Descripition,                
                Course_Code = @CourseCode,              
                Intro_Date = @Introdate,            
                GraduationTypeId = @GraduationTypeId,          
                Org_Id = @OrganizationId,          
                Submission_Date = @Submission_date,          
                MQA_Approval_Date = @MQA_Approval_date,          
                MOE_Approval_Date = @MOE_Approval_date,          
                Payment_Date = @Payment_date,          
                Expiry_Date = @Expiry_date,          
                Renewal_Code = @Renewal_code,          
                Renewal_Date = @Renewal_date,          
                Accreditation_Date = @Accreditation_date,          
                HypothesiedCode = @HypothesiedCode,     
                Program_Type_Id = @Program_Type_Id,    
                Online_checkstatus = @Online_checkstatus,    
                Modeofstudy = @Modeofstudy,         
                Updated_Date = GETDATE(),          
                AnnualPracticingCertification = @AnnualPracticingCertification,        
                PartnerUniversity = @PartnerUniversity        
            WHERE Department_Id = @Department_Id;
        END
    ')
END;
