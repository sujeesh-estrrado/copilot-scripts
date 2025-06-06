-- Check if the stored procedure [dbo].[Proc_Insert_Subjects_Hours_Per_Week] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Subjects_Hours_Per_Week]') 
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
        CREATE PROCEDURE [dbo].[Proc_Insert_Subjects_Hours_Per_Week]
        (
            @Duration_Mapping_Id BIGINT,
            @Employee_Id BIGINT,
            @Semester_Subject_Id BIGINT,
            @Subject_MaxHours INT,
            @Allowed_ContinuousHours INT,
            @Is_Continuous BIT
        )
        AS
        BEGIN
            DECLARE @Class_Id BIGINT;
            DECLARE @rc INT;
            DECLARE @Student_Id BIGINT;
            DECLARE @Class_Name NVARCHAR(200);
            DECLARE @Subject_Name NVARCHAR(200);
            DECLARE @Course_Desc NVARCHAR(200);
            DECLARE @Course_Id BIGINT;

            -- Delete existing subject hours record for employee and semester subject
            DELETE FROM [Tbl_Subject_Hours_PerWeek]
            WHERE [Employee_Id] = @Employee_Id AND [Semester_Subject_Id] = @Semester_Subject_Id;

            -- Insert new subject hours per week
            INSERT INTO [Tbl_Subject_Hours_PerWeek]
            (
                [Duration_Mapping_Id],
                [Employee_Id],
                [Semester_Subject_Id],
                [Subject_MaxHours],
                [Allowed_ContinuousHours],
                [Is_Continuous]
            )
            VALUES
            (
                @Duration_Mapping_Id,
                @Employee_Id,
                @Semester_Subject_Id,
                @Subject_MaxHours,
                @Allowed_ContinuousHours,
                @Is_Continuous
            );

            -- Fetch Class Name
            SET @Class_Name = (
                SELECT TOP 1
                    B.[Subject_Name] + N'' - '' +
                    CBD.[Batch_Code] + N'', '' +
                    CS.[Semester_Code] + N'' - '' +
                    D.[Department_Name]
                FROM [Tbl_Subject] B
                LEFT JOIN [Tbl_Subject] A ON A.[Parent_Subject_Id] = B.[Subject_Id]
                INNER JOIN [Tbl_Department_Subjects] DS ON DS.[Subject_Id] = B.[Subject_Id]
                INNER JOIN [Tbl_Semester_Subjects] SS ON SS.[Department_Subjects_Id] = DS.[Department_Subject_Id]
                INNER JOIN [Tbl_Course_Department] CD ON CD.[Course_Department_Id] = DS.[Course_Department_Id]
                INNER JOIN [Tbl_Department] D ON D.[Department_Id] = CD.[Department_Id]
                INNER JOIN [Tbl_Course_Duration_Mapping] CDM ON CDM.[Duration_Mapping_Id] = SS.[Duration_Mapping_Id]
                INNER JOIN [Tbl_Course_Batch_Duration] CBD ON CBD.[Batch_Id] = CDM.[Duration_Mapping_Id]
                INNER JOIN [Tbl_Course_Semester] CS ON CS.[Semester_Id] = CBD.[Batch_Id]
                WHERE SS.[Semester_Subject_Id] = @Semester_Subject_Id
            );

            -- Fetch Subject Name
            SET @Subject_Name = (
                SELECT TOP 1
                    B.[Subject_Name]
                FROM [Tbl_Subject] B
                INNER JOIN [Tbl_Department_Subjects] DS ON DS.[Subject_Id] = B.[Subject_Id]
                INNER JOIN [Tbl_Semester_Subjects] SS ON SS.[Department_Subjects_Id] = DS.[Department_Subject_Id]
                WHERE SS.[Semester_Subject_Id] = @Semester_Subject_Id
            );

            -- Fetch Course Description
            SET @Course_Desc = (
                SELECT TOP 1
                    CC.[Course_Category_Name] + N'', '' +
                    CBD.[Batch_Code] + N'', '' +
                    CS.[Semester_Code] + N'' - '' +
                    D.[Department_Name]
                FROM [Tbl_Subject] B
                INNER JOIN [Tbl_Department_Subjects] DS ON DS.[Subject_Id] = B.[Subject_Id]
                INNER JOIN [Tbl_Semester_Subjects] SS ON SS.[Department_Subjects_Id] = DS.[Department_Subject_Id]
                INNER JOIN [Tbl_Course_Department] CD ON CD.[Course_Department_Id] = DS.[Course_Department_Id]
                INNER JOIN [Tbl_Course_Category] CC ON CC.[Course_Category_Id] = CD.[Course_Category_Id]
                INNER JOIN [Tbl_Department] D ON D.[Department_Id] = CD.[Department_Id]
                INNER JOIN [Tbl_Course_Duration_Mapping] CDM ON CDM.[Duration_Mapping_Id] = SS.[Duration_Mapping_Id]
                INNER JOIN [Tbl_Course_Batch_Duration] CBD ON CBD.[Batch_Id] = CDM.[Duration_Mapping_Id]
                INNER JOIN [Tbl_Course_Semester] CS ON CS.[Semester_Id] = CBD.[Batch_Id]
                WHERE SS.[Semester_Subject_Id] = @Semester_Subject_Id
            );

            -- Check if LMS Class exists for the subject
            IF NOT EXISTS (
                SELECT 1 
                FROM [LMS_Tbl_Class] 
                WHERE [Type_Id] = @Semester_Subject_Id 
                    AND [Type] = N''Subject'' 
                    AND [Active_Status] = 1
            )
            BEGIN
                INSERT INTO [LMS_Tbl_Class]
                ([Class_Name], [Is_Existing_Class], [Type], [Type_Id], [Active_Status])
                VALUES (@Class_Name, 1, N''Subject'', @Semester_Subject_Id, 1);

                SET @Class_Id = SCOPE_IDENTITY();

                INSERT INTO [LMS_Tbl_Course]
                ([Course_Name], [Is_Existing_Course], [Type], [Type_Id], [Active_Status], [Course_Description], [Class_Id])
                VALUES (@Subject_Name, 1, N''Subject'', @Semester_Subject_Id, 1, @Course_Desc, @Class_Id);

                SET @Course_Id = SCOPE_IDENTITY();

                -- Insert students into LMS Class and Course
                INSERT INTO [LMS_Tbl_Student_Class] ([Class_Id], [Student_Id], [Approval_Status])
                SELECT @Class_Id, [Candidate_Id], 1
                FROM [Tbl_Student_Semester]
                WHERE [Duration_Mapping_Id] = @Duration_Mapping_Id;

                INSERT INTO [LMS_Tbl_Student_Course] ([Course_Id], [Student_Id], [Approval_Status])
                SELECT @Course_Id, [Candidate_Id], 1
                FROM [Tbl_Student_Semester]
                WHERE [Duration_Mapping_Id] = @Duration_Mapping_Id;
            END
            ELSE
            BEGIN
                SET @Class_Id = (SELECT [Class_Id] FROM [LMS_Tbl_Class] WHERE [Type] = N''Subject'' AND [Type_Id] = @Semester_Subject_Id);
                SET @Course_Id = (SELECT [Course_Id] FROM [LMS_Tbl_Course] WHERE [Type_Id] = @Semester_Subject_Id AND [Type] = N''Subject'' AND [Active_Status] = 1);

                INSERT INTO [LMS_Tbl_Emp_Class] ([Class_Id], [Emp_Id], [Is_Class_Owner])
                VALUES (@Class_Id, @Employee_Id, 1);

                INSERT INTO [LMS_Tbl_Emp_Course] ([Course_Id], [Emp_Id], [Is_Course_Owner])
                VALUES (@Course_Id, @Employee_Id, 1);
            END
        END'
END;
