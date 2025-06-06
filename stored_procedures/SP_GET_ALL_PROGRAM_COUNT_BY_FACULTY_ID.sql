IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_ALL_PROGRAM_COUNT_BY_FACULTY_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GET_ALL_PROGRAM_COUNT_BY_FACULTY_ID]
        @facultyid BIGINT,
        @flag BIGINT
        AS
        BEGIN
            DECLARE @totalpgm BIGINT
            DECLARE @inactivepgm BIGINT
            DECLARE @activepgm BIGINT
            DECLARE @Intake BIGINT
            DECLARE @activeIntake BIGINT

            IF (@flag = 1)
            BEGIN
                SET @totalpgm = (SELECT COUNT(*) FROM Tbl_Department WHERE GraduationTypeId = @facultyid)
                SET @inactivepgm = (SELECT COUNT(*) FROM Tbl_Department WHERE GraduationTypeId = @facultyid AND Active_Status = ''Inactive'')
                SET @activepgm = (SELECT COUNT(*) FROM Tbl_Department WHERE GraduationTypeId = @facultyid AND Active_Status = ''Active'')
            END

            IF (@flag = 2)
            BEGIN
                SET @Intake = (SELECT COUNT(*) 
                               FROM Tbl_Course_Batch_Duration CBD
                               INNER JOIN Tbl_Program_Duration PD ON PD.Duration_Id = CBD.Duration_Id
                               INNER JOIN Tbl_Department D ON D.Department_Id = PD.Program_Category_Id
                               WHERE D.GraduationTypeId = @facultyid)

                SET @activeIntake = (SELECT COUNT(*) 
                                     FROM Tbl_Course_Batch_Duration CBD
                                     INNER JOIN Tbl_Program_Duration PD ON PD.Duration_Id = CBD.Duration_Id
                                     INNER JOIN Tbl_Department D ON D.Department_Id = PD.Program_Category_Id
                                     WHERE D.GraduationTypeId = @facultyid AND CBD.Batch_DelStatus = 0)
            END

            CREATE TABLE #tempchart (valuetype VARCHAR(MAX), value BIGINT)

            INSERT INTO #tempchart
            SELECT ''Total Programmes'', @totalpgm - @inactivepgm - @activepgm
            UNION ALL
            SELECT ''Inactive Programmes'', @inactivepgm
            UNION ALL
            SELECT ''Active Programmes'', @activepgm
            UNION ALL
            SELECT ''Total intake'', @Intake
            UNION ALL
            SELECT ''Active intake'', @activeIntake

            SELECT * FROM #tempchart WHERE value != 0
        END
    ')
END
