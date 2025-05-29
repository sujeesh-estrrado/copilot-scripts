IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Lead_Count_Counselor_Dahboard_Lead_Filtered]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Get_All_Lead_Count_Counselor_Dahboard_Lead_Filtered]
@FacultyId  NVARCHAR(MAX),
    @ProgrammeId  NVARCHAR(MAX),
    @IntakeId  NVARCHAR(MAX),
    @CounselorEmployeeId BIGINT
AS
BEGIN
DECLARE @FacultyTable TABLE (FacultyId INT);
    DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
    DECLARE @IntakeTable TABLE (IntakeId INT);

    INSERT INTO @FacultyTable (FacultyId)
    SELECT value FROM dbo.SplitStringFunction(@FacultyId, '','');

    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT value FROM dbo.SplitStringFunction(@ProgrammeId, '','');

    INSERT INTO @IntakeTable (IntakeId)
    SELECT value FROM dbo.SplitStringFunction(@IntakeId, '','');

    SELECT 
        -- 1. Total Leads
        (select count(*) from Tbl_Lead_Personal_Det  cpd
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
		 where 
		 (ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'') 
		
           --AND (NA.Course_Level_Id = @FacultyId OR @FacultyId = 0)
           --AND (NA.Department_Id = @ProgrammeId OR @ProgrammeId = 0)
           --AND (NA.Batch_Id = @IntakeId OR @IntakeId = 0)
		   AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
		--AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
           AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
        ) AS TotalLeads,

        -- 2. Pending Followups
        (SELECT COUNT(DISTINCT cpd.Candidate_Id)
         FROM tbl_Lead_personal_det cpd
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
       LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS f ON f.candidate_id = cpd.candidate_id
         WHERE (f.Next_Date IS NULL OR f.Next_Date <= CONVERT(DATE, GETDATE()))
           AND cpd.ApplicationStatus = ''Lead''
           AND (cpd.counseloremployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
           AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
	--	AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS PendingFollowups,

        -- 3. Unallocated Leads
        (select count(Candidate_Id) from Tbl_Lead_Personal_Det cpd		
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id 
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE (CPD.CounselorEmployee_id = '''' OR CPD.CounselorEmployee_id = 0)
           AND CPD.Moved_id IS NULL
           AND CPD.ApplicationStatus = ''Lead''
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
		AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS Unallocated,

        -- 4. Total Applications
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
           AND 
		   (CPD.ApplicationStatus IN (''Pending'', ''submited''))
		   AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
		--AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS TotalApplications,

        -- 5. Pending Followups for Applications
--        (SELECT COUNT(DISTINCT cpd.Candidate_Id)
--         FROM Tbl_Candidate_Personal_Det cpd
--         LEFT JOIN Tbl_FollowUp_Detail f ON f.candidate_id = cpd.candidate_id
--         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id

--         WHERE (f.Next_Date IS NULL OR f.Next_Date <= CONVERT(DATE, GETDATE()))
--           AND (cpd.ApplicationStatus IN (''Pending'', ''submited''))
--AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
--           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
         
--		AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
--        ) AS PendingFollowupsApplication,

       
(SELECT 
    (SELECT COUNT(*) 
     FROM (
         SELECT cdp.Candidate_Id 
         FROM Tbl_Candidate_Personal_Det cdp
         LEFT JOIN tbl_New_Admission NA ON cdp.New_Admission_Id = NA.New_Admission_Id
		 LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUp_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN ( 
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUp_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS f on f.Candidate_Id=cdp.Candidate_Id
         WHERE 
		 (f.Next_Date IS NULL OR f.Next_Date <= CONVERT(DATE, GETDATE())) and
             (cdp.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
              AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
             AND (ApplicationStatus = ''Pending'' OR ApplicationStatus = ''submited'')
     ) AS m) 
    -
    (SELECT COUNT(*) 
     FROM (
         SELECT cdp.Candidate_Id 
         FROM Tbl_Candidate_Personal_Det cdp
         LEFT JOIN tbl_New_Admission NA ON cdp.New_Admission_Id = NA.New_Admission_Id
         WHERE 
             (ApplicationStatus = ''Pending'' OR ApplicationStatus = ''submited'')
             AND (cdp.CounselorEmployee_id = 0)
             --AND (cdp.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
             AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
			 ) AS t) )
AS PendingFollowupsApplication,
        -- 6. Unallocated Applications
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE (CPD.ApplicationStatus IN (''Pending'', ''submited''))
    AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
		AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS UnallocatedApplication,

        -- 7. Prospect Verified
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''approved''
           AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
          
AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
		--AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS ProspectVerified,

        -- 8. Admission Verified
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Verified''
           AND CPD.Candidate_DelStatus = 0
           AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
         
		--AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS AdmissionVerified,

        -- 9. Pre-Activated
        (SELECT COUNT(*)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Preactivated''
		            AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
 AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
		--AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS PreActivated,

        -- 10. Total On Hold
        (SELECT COUNT(DISTINCT M.Candidate_Id)
         FROM Tbl_Status_change_by_Marketing M
         LEFT JOIN Tbl_Candidate_Personal_Det CPD ON M.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE M.status = ''Hold''
		            AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
		AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
        ) AS TotalOnHold,

        -- 11. Leads On Hold
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Lead_Personal_Det CPD
         LEFT JOIN Tbl_LeadStatus_Change_by_Marketing m ON m.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Lead''
           AND m.status = ''Hold''
                 AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
        ) AS LeadsOnHold,

        -- 12. Applications On Hold
        (SELECT COUNT(DISTINCT M.Candidate_Id)
         FROM Tbl_Status_change_by_Marketing M
         LEFT JOIN Tbl_Candidate_Personal_Det CPD ON M.Candidate_Id = CPD.Candidate_Id
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE M.status = ''Hold''
           AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0) 
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
         
        ) AS ApplicationsOnHold,

        -- 13. Total Rejected
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''rejected''
           AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
         
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
        ) AS TotalRejected,

        -- 14. Leads Rejected
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Lead_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''rejected''
           AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
         
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
        ) AS LeadsRejected,

        -- 15. Applications Rejected
        (SELECT COUNT(DISTINCT CPD.Candidate_Id)
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''rejected''
           AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
         
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
          
        ) AS ApplicationsRejected,

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
     
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
		AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
		   AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
        ) AS TotalActiveStudents
END
');
END;
