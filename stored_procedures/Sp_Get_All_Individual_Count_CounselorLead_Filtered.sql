IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Individual_Count_CounselorLead_Filtered]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_Individual_Count_CounselorLead_Filtered]
            @FacultyId NVARCHAR(MAX),
            @ProgrammeId NVARCHAR(MAX),
            @IntakeId NVARCHAR(MAX),
            @CounselorEmployeeId BIGINT
        AS
        BEGIN

            DECLARE @FacultyTable TABLE (FacultyId INT);
            DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
            DECLARE @IntakeTable TABLE (IntakeId INT);

            -- Declare helper variables
            DECLARE @HasZeroIntake BIT = CASE WHEN @IntakeId = ''0'' OR @IntakeId LIKE ''%0%'' THEN 1 ELSE 0 END;
            DECLARE @HasZeroProgram BIT = CASE WHEN @ProgrammeId = ''0'' OR @ProgrammeId LIKE ''%0%'' THEN 1 ELSE 0 END;
            DECLARE @HasZeroFaculty BIT = CASE WHEN @FacultyId = ''0'' OR @FacultyId LIKE ''%0%'' THEN 1 ELSE 0 END;

            -- Populate Intake Table
            IF @HasZeroIntake = 1
            BEGIN
                INSERT INTO @IntakeTable (IntakeId)
                SELECT DISTINCT Duration_Period_Id FROM Tbl_Course_Duration_PeriodDetails;
            END
            ELSE
            BEGIN
                INSERT INTO @IntakeTable (IntakeId)
                SELECT DISTINCT value FROM dbo.SplitStringFunction(@IntakeId, '','') WHERE value <> ''0'';
            END

            -- Populate Program Table
            IF @HasZeroProgram = 1
            BEGIN
                INSERT INTO @ProgrammeTable (ProgrammeId)
                SELECT DISTINCT ProgramId FROM Tbl_Programs;
            END
            ELSE
            BEGIN
                INSERT INTO @ProgrammeTable (ProgrammeId)
                SELECT DISTINCT value FROM dbo.SplitStringFunction(@ProgrammeId, '','') WHERE value <> ''0'';
            END
         
            IF @HasZeroFaculty = 1
            BEGIN
                INSERT INTO @FacultyTable (FacultyId)
                SELECT DISTINCT FacultyId FROM Tbl_Faculties;
            END
            ELSE
            BEGIN
                INSERT INTO @FacultyTable (FacultyId)
                SELECT DISTINCT value FROM dbo.SplitStringFunction(@FacultyId, '','') WHERE value <> ''0'';
            END

            SELECT 
                (SELECT COUNT(*) 
                 FROM Tbl_Lead_Personal_Det CPD
                 LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                 LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
                 WHERE CAST(RegDate AS DATE) = CAST(GETDATE() AS DATE)
                 AND ApplicationStatus NOT IN (''Pending'', ''Rejected'')
                 AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
                 AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
                 AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
                ) AS leadtodayCounts,

                (SELECT COUNT(*) 
                 FROM Tbl_Candidate_Personal_Det CPD
                 LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                 LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
                 WHERE CAST(RegDate AS DATE) = CAST(GETDATE() AS DATE)
                 AND ApplicationStatus IN (''Pending'', ''Submited'')
                 AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
                 AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
                 AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
                ) AS todayCounts,

                (SELECT COUNT(*) 
                 FROM Tbl_Lead_Personal_Det CPD
                 LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                 LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
                 WHERE ApplicationStatus NOT IN (''Pending'', ''Rejected'')
                 AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
                 AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
                 AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
                ) AS leadtotalCounts,

                (SELECT COUNT(DISTINCT CPD.Candidate_Id)
                 FROM Tbl_Candidate_Personal_Det CPD
                 LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                 LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
                 WHERE ApplicationStatus IN (''Pending'', ''Submited'')
                 AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
                 AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
                 AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
                ) AS totalCounts,

                (SELECT COUNT(DISTINCT CPD.Candidate_Id)
                 FROM Tbl_Lead_Personal_Det CPD
                 LEFT JOIN Tbl_FollowUpLead_Detail F ON F.Candidate_Id = CPD.Candidate_Id
                 LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                 LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
                 WHERE (F.Next_Date IS NULL OR F.Next_Date <= CONVERT(DATE, GETDATE()))
                 AND CPD.ApplicationStatus = ''Lead''
                 AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
                 AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
                 AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
                ) AS leadpending,

                (SELECT COUNT(DISTINCT CPD.Candidate_Id)
                 FROM Tbl_Candidate_Personal_Det CPD
                 LEFT JOIN Tbl_FollowUp_Detail F ON F.Candidate_Id = CPD.Candidate_Id
                 LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
                 LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
                 WHERE (F.Next_Date IS NULL OR F.Next_Date <= CONVERT(DATE, GETDATE()))
                 AND CPD.ApplicationStatus IN (''Pending'', ''Submited'')
                 AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
                 AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
                 AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
                ) AS pending
        END
    ')
END
