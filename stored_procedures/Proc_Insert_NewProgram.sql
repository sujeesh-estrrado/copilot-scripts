-- Check if the stored procedure [dbo].[Proc_Insert_NewProgram] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_NewProgram]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_NewProgram]
        (
            @department_name VARCHAR(MAX),
            @department_Descripition VARCHAR(MAX),
            @CourseCode VARCHAR(50),
            @IntroDate DATETIME,
            @GraduationTypeId BIGINT,
            @Submission_date DATETIME,
            @Program_Type_Id BIGINT,
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
            @HypothesiedCode VARCHAR(MAX) = NULL,
            @Online_checkstatus BIGINT = 0,
            @Modeofstudy BIGINT = 0,
            @PrgmDuration VARCHAR(10) = NULL
        )
        AS
        BEGIN
        
            
            DECLARE @DepartId BIGINT;

            -- Check if the department already exists
            IF EXISTS (
                SELECT Department_Name
                FROM dbo.Tbl_Department
                WHERE Department_Name = @department_name
                    AND Course_Code = @CourseCode
                    AND Department_Status = 0
            )
            BEGIN
                RAISERROR (
                    ''Data Already Exists.'', -- Message text.
                    16, -- Severity.
                    1  -- State.
                );
                RETURN;
            END
            
            -- Insert a new department
            INSERT INTO Tbl_Department
            (
                Department_Name,
                Department_Descripition,
                Department_Status,
                Course_Code,
                Intro_Date,
                GraduationTypeId,
                Org_Id,
                Submission_Date,
                MQA_Approval_Date,
                MOE_Approval_Date,
                Payment_Date,
                Expiry_Date,
                Renewal_Code,
                Renewal_Date,
                Accreditation_Date,
                Active_Status,
                Created_Date,
                Updated_Date,
                Delete_Status,
                AnnualPracticingCertification,
                PartnerUniversity,
                HypothesiedCode,
                Program_Type_Id,
                Online_checkstatus,
                Modeofstudy
            )
            VALUES
            (
                @department_name,
                @department_Descripition,
                0,
                @CourseCode,
                @IntroDate,
                @GraduationTypeId,
                @OrganizationId,
                @Submission_date,
                @MQA_Approval_date,
                @MOE_Approval_date,
                @Payment_date,
                @Expiry_date,
                @Renewal_code,
                @Renewal_date,
                @Accreditation_date,
                ''Active'',
                GETDATE(),
                GETDATE(),
                0,
                @AnnualPracticingCertification,
                @PartnerUniversity,
                @HypothesiedCode,
                @Program_Type_Id,
                @Online_checkstatus,
                @Modeofstudy
            );

            -- Get the ID of the newly inserted department
            SET @DepartId = SCOPE_IDENTITY();

            -- Return the department ID
            SELECT @DepartId;
        END
    ')
END
