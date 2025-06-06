IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Lead_Count_CounselorLead_Filtered]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      


CREATE PROCEDURE [dbo].[Sp_Get_All_Lead_Count_CounselorLead_Filtered]
    @FacultyId NVARCHAR(MAX),
    @ProgrammeId NVARCHAR(MAX),
    @IntakeId NVARCHAR(MAX),
    @CounselorEmployeeId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare tables for input filtering
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
        -- 1. Total Leads
         (SELECT COUNT(*)
         FROM Tbl_Lead_Personal_Det CPD
         left JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id 
         WHERE  cpd.ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected''  
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
        ) AS TotalLeads,

        -- 2. Pending Followups
        (SELECT COUNT(DISTINCT cpd.Candidate_Id)
         FROM tbl_Lead_personal_det cpd
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
         LEFT JOIN (
    SELECT FD.*
    FROM Tbl_FollowUpLead_Detail FD
    WHERE FD.Follow_Up_Detail_Id = (
        SELECT MAX(Follow_Up_Detail_Id) 
        FROM Tbl_FollowUpLead_Detail 
        WHERE candidate_id = FD.candidate_id
    )
) f 
    ON f.candidate_id = cpd.candidate_id
         
        -- LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE (f.Next_Date is null or f.Next_Date<=  convert(date,getdate())) and (cpd.ApplicationStatus=''Lead'') 
         
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
           --AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
         ) AS PendingFollowups,

        -- 3. Unallocated Leads
        (SELECT COUNT(CPD.Candidate_Id)
         FROM Tbl_Lead_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE (CPD.CounselorEmployee_id = '''' OR CPD.CounselorEmployee_id = 0)
            AND CPD.Moved_id IS NULL
           AND CPD.ApplicationStatus = ''Lead''
     
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
           --AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) 
           ) AS Unallocated,

        -- 4. Total Applications
     --   (SELECT COUNT(*)
     --    FROM Tbl_Candidate_Personal_Det CPD
     --    LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
          
     --    WHERE --(CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
          
     --        NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
     --      AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
     --     -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           --AND (CPD.ApplicationStatus IN (''Pending'', ''submited''))
     --   ) AS TotalApplications,

        
                    (SELECT COUNT(*) 
            FROM   
                  Tbl_Candidate_Personal_Det CPD
                  
                LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id 
                WHERE (ApplicationStatus = ''Pending'' or ApplicationStatus = ''pending'' OR ApplicationStatus = ''submited'') 
                --and (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
                     AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
                     AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
            )   AS TotalApplications,


        -- 5. Pending Followups for Applications
        (SELECT COUNT(DISTINCT cpd.Candidate_Id)
         FROM Tbl_Candidate_Personal_Det cpd
         LEFT JOIN (
    SELECT FD.*
    FROM Tbl_FollowUp_Detail FD
    WHERE FD.Follow_Up_Detail_Id = (
        SELECT MAX(Follow_Up_Detail_Id) 
        FROM Tbl_FollowUp_Detail 
        WHERE candidate_id = FD.candidate_id
    )
) f 
    ON f.candidate_id = cpd.candidate_id
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
         
         --LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE (f.Next_Date IS NULL OR f.Next_Date <= CONVERT(DATE, GETDATE()))
           AND  (ApplicationStatus = ''Pending'' or ApplicationStatus = ''pending'' OR ApplicationStatus = ''submited'')
        
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
           --AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS PendingFollowupsApplication,

        -- 6. Unallocated Applications
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE (ApplicationStatus = ''Pending'' or ApplicationStatus = ''pending'' OR ApplicationStatus = ''submited'')
         AND (CPD.CounselorEmployee_id = '''' OR CPD.CounselorEmployee_id  = 0)
       
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
           --AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS UnallocatedApplication,

        -- 7. Prospect Verified
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''approved''
           --AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
           AND CPD.Active_Status IN (''Active'', ''ACTIVE'')
        
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS ProspectVerified,

        -- 8. Admission Verified
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Verified''
           AND CPD.Candidate_DelStatus = 0
          -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
       
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
           AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS AdmissionVerified,

        -- 9. Pre-Activated
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Preactivated''
           --AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)

        
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS PreActivated,

        -- 10. Total On Hold
   --     (SELECT COUNT(DISTINCT M.Candidate_Id)
   --      FROM Tbl_Status_change_by_Marketing M
   --      LEFT JOIN Tbl_Candidate_Personal_Det CPD ON M.Candidate_Id = CPD.Candidate_Id
   --      LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         
         --LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
   --      WHERE M.status = ''Hold''
   --       -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
          
        
   --        AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
   --        AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
   --       -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
         --  ) AS TotalOnHold,

        -- 11. Leads On Hold
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Lead_Personal_Det CPD
         LEFT JOIN Tbl_LeadStatus_Change_by_Marketing m ON m.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Lead''
           AND m.status = ''Hold''
         
          -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
          
       
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
           --AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS LeadsOnHold,

        -- 12. Applications On Hold
        (SELECT COUNT(DISTINCT M.Candidate_Id)
         FROM Tbl_Status_change_by_Marketing M
         LEFT JOIN Tbl_Candidate_Personal_Det CPD ON M.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id

         WHERE M.status = ''Hold''
          -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
         
        
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
           --AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS ApplicationsOnHold,
           (SELECT 
    ( 
        -- Leads On Hold
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Lead_Personal_Det CPD
         LEFT JOIN Tbl_LeadStatus_Change_by_Marketing m ON m.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Lead''
           AND m.status = ''Hold''
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        ) 

        + 

        -- Applications On Hold
        (SELECT COUNT(DISTINCT M.Candidate_Id)
         FROM Tbl_Status_change_by_Marketing M
         LEFT JOIN Tbl_Candidate_Personal_Det CPD ON M.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
         WHERE M.status = ''Hold''
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        ) 
    )) AS TotalOnHold,


        -- 13. Total Rejected
   --     (SELECT COUNT(DISTINCT CPD.Candidate_Id)
   --      FROM Tbl_Candidate_Personal_Det CPD
   --      LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         
         --LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
   --      WHERE CPD.ApplicationStatus = ''rejected''
   --       -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)          
        
   --        AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
   --        AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
   --       -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
         --  ) AS TotalRejected,

        -- 14. Leads Rejected
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Lead_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''rejected''
          -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)           
       
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS LeadsRejected,

        -- 15. Applications Rejected
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''rejected''
          -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)           
        
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) AS ApplicationsRejected,

            ( SELECT( (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Lead_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''rejected''
          -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)           
       
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           ) 

        +
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
         
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''rejected''
          -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)           
        
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
           )))TotalRejected ,

        -- 16. Total Active Students
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN Tbl_Student_status S ON S.id = CPD.active
         LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id        
         LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         LEFT JOIN Tbl_Student_Semester ON Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN Tbl_Course_Batch_Duration bd ON NA.Batch_Id = bd.Batch_Id
         LEFT JOIN Tbl_IntakeMaster im ON im.id = bd.intakemasterid
         LEFT JOIN Tbl_Course_Department Cdep ON Cdep.Department_Id = NA.Department_Id
         LEFT JOIN Tbl_Department D ON D.Department_Id = Cdep.Department_Id
         LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = D.GraduationTypeId
         WHERE CPD.ApplicationStatus = ''Completed''
           AND CPD.active IN (3, 4, 5)         
         
           AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
           AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
          -- AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)  -- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
        ) AS TotalActiveStudents
END
    ')
END