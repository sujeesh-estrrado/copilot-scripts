-- Check if the stored procedure [dbo].[Proc_Insert_Departmentnew] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Departmentnew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Departmentnew]
        (
            @department_name VARCHAR(300),
            @department_Descripition VARCHAR(500),
            @CourseCode VARCHAR(50),
            @IntroDate DATETIME,
            @GraduationTypeId BIGINT
        )
        AS
        BEGIN
            DECLARE @DepartId BIGINT;

            -- Check if the department name already exists with status 0 (inactive)
            IF EXISTS(
                SELECT Department_Name 
                FROM dbo.Tbl_Department 
                WHERE Department_Name = @department_name 
                AND Department_Status = 0
            )
            BEGIN
                -- Raise an error if data already exists
                RAISERROR (
                    ''Data Already Exists.'',  -- Message text
                    16,  -- Severity
                    1  -- State
                );
            END
            ELSE
            BEGIN
                -- Insert a new department record into Tbl_Department
                INSERT INTO Tbl_Department 
                (
                    Department_Name,
                    Department_Descripition,
                    Department_Status,
                    Course_Code,
                    Intro_Date,
                    GraduationTypeId
                )
                VALUES
                (
                    @department_name,
                    @department_Descripition,
                    0,  -- Department_Status = 0 (Inactive)
                    @CourseCode,
                    @IntroDate,
                    @GraduationTypeId
                );

                -- Get the identity value of the newly inserted department
                SET @DepartId = (SELECT SCOPE_IDENTITY());

                -- Return the Department ID
                SELECT @DepartId;
            END
        END
    ')
END
