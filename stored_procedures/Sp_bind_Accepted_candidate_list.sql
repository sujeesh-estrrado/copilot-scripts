IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_bind_Accepted_candidate_list]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Sp_bind_Accepted_candidate_list] --''Verified'',1,10,0,0,0,0,''970716105914''            
(
  @application_status varchar(500), 
  @CurrentPage int = null, 
  @pagesize bigint null, 
  @organization_id bigint = 0, 
  @intake_id bigint = 0, 
  @Department_id bigint = 0, 
  @Flag bigint = 0, 
  @SearchTerm varchar(500)= '''', 
  @counselorid bigint = 0,
  
@FacultyId NVARCHAR(MAX), 
@ProgrammeId NVARCHAR(MAX), 
@IntakeId NVARCHAR(MAX) 
) as 

 
  DECLARE @FacultyTable TABLE (FacultyId INT);
DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
DECLARE @IntakeTable TABLE (IntakeId INT);
 
IF @FacultyId <> ''0'' AND @FacultyId <> ''''
BEGIN
    INSERT INTO @FacultyTable (FacultyId)
    SELECT value FROM dbo.SplitStringFunction(@FacultyId, '','');
END
ELSE
BEGIN
    INSERT INTO @FacultyTable (FacultyId)
    SELECT DISTINCT Course_Level_Id FROM Tbl_Course_Level;
END
 
IF @ProgrammeId <> ''0'' AND @ProgrammeId <> ''''
BEGIN
    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT value FROM dbo.SplitStringFunction(@ProgrammeId, '','');
END
ELSE
BEGIN 
    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT DISTINCT Department_Id FROM Tbl_Department;  
END
 
IF @IntakeId <> ''0'' AND @IntakeId <> ''''
BEGIN
    INSERT INTO @IntakeTable (IntakeId)
    SELECT value FROM dbo.SplitStringFunction(@IntakeId, '','');
END
ELSE
BEGIN

    INSERT INTO @IntakeTable (IntakeId)
    SELECT DISTINCT Duration_Period_Id FROM Tbl_Course_Duration_PeriodDetails; 
  END 
    
if(@Flag = 0) begin begin (
  SELECT 
    DISTINCT CPD.Candidate_Id AS ID, 
    SG.BloodGroup, 
    CPD.IDMatrixNo, 
    CPD.Candidate_Gender, 
    CPD.IdentificationNo, 
    concat(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname ) AS CandidateName, 
    CPD.Candidate_Fname, 
    CPD.AdharNumber, 
    CPD.TypeOfStudent, 
    CPD.Status, 
    CPD.Candidate_Dob AS DOB, 
    CPD.New_Admission_Id AS AdmnID, 
    CPD.ApplicationStatus, 
    CC.Candidate_idNo AS IdentificationNumber, 
    CC.Candidate_ContAddress AS Address, 
    CC.Candidate_Mob1 AS MobileNumber, 
    CC.Candidate_Email, 
    CCat.Course_Category_Id, 
    cbd.Batch_Id AS BatchID, 
    cbd.Batch_Code AS Batch, 
    NA.Batch_Id, 
    im.Batch_Code as masterintake, 
    CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
      SELECT 
        cbd.Batch_Code 
      FROM 
        Tbl_Course_Batch_Duration cbd 
      WHERE 
        cbd.Batch_Id = NA.Batch_Id
    ) END AS Batch_Code, 
    (
      CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END
    ) AS UserName, 
    NA.Course_Level_Id AS LevelID, 
    CL.Course_Level_Name AS LevelName, 
    NA.Course_Category_Id AS CategoryID, 
    CCat.Course_Category_Name AS Category, 
    NA.Department_Id AS DepartmentID, 
    CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
      SELECT 
        D.Department_Name 
      FROM 
        Tbl_Department D 
      WHERE 
        D.Department_Id = NA.Department_Id
    ) END AS Department_Name, 
    dbo.tbl_approval_log.Offerletter_sent as offerletter,   
  CASE 
    WHEN ((dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL) AND (ISNULL(Offer_letter_Skip_Status,0) = 0))
    THEN CONVERT(VARCHAR(8), dbo.tbl_approval_log.offer_letter_accept_date, 3) 
    ELSE ''-NA-'' 
END AS offerletter_acceptdate, 
    
    (
      select 
        top 1 Offerletter_status 
      from 
        tbl_approval_log 
      where 
        Candidate_id = CPD.Candidate_Id 
      order by 
        Offerletter_status
    ) as offersentsts, 
    --  dbo.tbl_approval_log.Offerletter_status as offersentsts,
    (
      select 
        top 1 Conditional_offerletter 
      from 
        Tbl_Offerlettre 
      where 
        Candidate_id = CPD.Candidate_Id 
      order by 
        Conditional_offerletter
    ) as Conditional_offerletter, 
    --  ol.Conditional_offerletter,
    (
      select 
        top 1 Resend_offerletter 
      from 
        Tbl_Offerlettre 
      where 
        Candidate_id = CPD.Candidate_Id 
      order by 
        Resend_offerletter
    ) as Resend_offerletter, 
    --  ol.Resend_offerletter,
    cpd.verifiedby, 
    CASE WHEN ApprovalStatus = 1 
    and R.RefundStatus is null THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
    and R.RefundStatus is null THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
    and R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
    and R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
    and R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
    and R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
    and R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
    CONVERT(varchar, R.RequestDate, 103) as RequestDate, 
    CONVERT(varchar, R.ApprovalDate, 103) as ApprovalDate,
  OLD.temppath AS OfferLetterDocPath,
  Offer_letter_Skip_Status AS OfferLetterSkipStatus
  FROM 
    dbo.Tbl_Candidate_Personal_Det AS CPD 
    left JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
    and dbo.tbl_approval_log.delete_status = 0LEFT 
    JOIN Tbl_Offerlettre ol on ol.candidate_id = CPD.Candidate_Id 
    and ol.delete_status = 0 
    LEFT JOIN Approval_Request R on CPD.candidate_id = R.StudentId 
    LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
    LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 
    AND SS.Student_Semester_Current_Status = 1 
    LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
    LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
    left join Tbl_IntakeMaster im on im.id = cbd.intakemasterid 
    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
    LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
    LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
    LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
      SELECT 
        Employee_Id 
      FROM 
        dbo.Tbl_Employee_User 
      WHERE 
        (User_Id = SR.UserId)
    ) 
    LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id
  --LEFT OUTER JOIN Tbl_offerletter_log AS OLD ON OLD.candidateid = OL.candidate_id
  LEFT OUTER JOIN (
      SELECT t1.candidateid, t1.senddate AS latest, t1.temppath
      FROM Tbl_offerletter_log t1
      INNER JOIN (
        SELECT candidateid, MAX(senddate) AS latest_senddate
        FROM Tbl_offerletter_log
        GROUP BY candidateid )
        t2 ON t1.candidateid = t2.candidateid 
        AND t1.senddate = t2.latest_senddate
    ) AS OLD ON OLD.candidateid = OL.candidate_id

  where 
    CPD.Candidate_DelStatus = 0 
    and dbo.tbl_approval_log.delete_status = 0 
    and --dbo.tbl_approval_log.delete_status=0 and          
    (
      CPD.Campus = @organization_id 
      or @organization_id = ''0''
    ) 
    and (
      NA.Department_Id = @Department_id 
      or @Department_id = ''0''
    ) --and (NA.Batch_Id= @intake_id or @intake_id=''0'') and  
    and (
      im.id = @intake_id 
      or @intake_id = ''0''
    ) 
    and (
      (
        concat(
          CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
        ) like ''%'' + @SearchTerm + ''%''
      ) 
      or(
        CPD.AdharNumber like ''%'' + @SearchTerm + ''%''
      ) 
      or (
        CPD.IDMatrixNo like ''%'' + @SearchTerm + ''%''
      ) 
      or @SearchTerm = '''' 
      or (
        CC.Candidate_Mob1 like ''%'' + @SearchTerm + ''%''
      )
    ) 
    and (
      CPD.Active_Status = ''Active'' 
      or CPD.Active_Status = ''ACTIVE''
    ) 
    and (
      CPD.ApplicationStatus = @application_status 
      or @application_status is null
    ) 
    and CPD.ApplicationStatus is not null
) 
Union all 
  (
    SELECT 
      DISTINCT NP.Candidate_Id AS ID, 
      SG.BloodGroup, 
      NP.IDMatrixNo, 
      CPD.Candidate_Gender, 
      CPD.IdentificationNo, 
      concat(
        CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
      ) AS CandidateName, 
      CPD.Candidate_Fname, 
      CPD.AdharNumber, 
      CPD.TypeOfStudent, 
      CPD.Status, 
      CPD.Candidate_Dob AS DOB, 
      NP.New_Admission_Id AS AdmnID, 
      NP.ApplicationStatus, 
      CC.Candidate_idNo AS IdentificationNumber, 
      CC.Candidate_ContAddress AS Address, 
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email, 
      CCat.Course_Category_Id, 
      cbd.Batch_Id AS BatchID, 
      cbd.Batch_Code AS Batch, 
      NA.Batch_Id, 
      im.Batch_Code as masterintake, 
      CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          cbd.Batch_Code 
        FROM 
          Tbl_Course_Batch_Duration cbd 
        WHERE 
          cbd.Batch_Id = NA.Batch_Id
      ) END AS Batch_Code, 
      (
        CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END
      ) AS UserName, 
      NA.Course_Level_Id AS LevelID, 
      CL.Course_Level_Name AS LevelName, 
      NA.Course_Category_Id AS CategoryID, 
      CCat.Course_Category_Name AS Category, 
      NA.Department_Id AS DepartmentID, 
      CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          D.Department_Name 
        FROM 
          Tbl_Department D 
        WHERE 
          D.Department_Id = NA.Department_Id
      ) END AS Department_Name, 
      dbo.tbl_approval_log.Offerletter_sent as offerletter,   
  CASE 
    WHEN ((dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL) AND (ISNULL(Offer_letter_Skip_Status,0) = 0))
    THEN CONVERT(VARCHAR(8), dbo.tbl_approval_log.offer_letter_accept_date, 3) 
    ELSE ''-NA-'' 
END AS offerletter_acceptdate,
      (
        select 
          top 1 Offerletter_status 
        from 
          tbl_approval_log 
        where 
          Candidate_id = CPD.Candidate_Id 
        order by 
          Offerletter_status
      ) as offersentsts, 
      -- dbo.tbl_approval_log.Offerletter_status as offersentsts,
      (
        select 
          top 1 Conditional_offerletter 
        from 
          Tbl_Offerlettre 
        where 
          Candidate_id = CPD.Candidate_Id 
        order by 
          Conditional_offerletter
      ) as Conditional_offerletter, 
      --  ol.Conditional_offerletter,
      (
        select 
          top 1 Resend_offerletter 
        from 
          Tbl_Offerlettre 
        where 
          Candidate_id = CPD.Candidate_Id 
        order by 
          Resend_offerletter
      ) as Resend_offerletter, 
      --  ol.Resend_offerletter,
      cpd.verifiedby, 
      CASE WHEN ApprovalStatus = 1 
      and R.RefundStatus is null THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
      and R.RefundStatus is null THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
      and R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
      and R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
      and R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
      and R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
      and R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
      CONVERT(varchar, R.RequestDate, 103) as RequestDate, 
      CONVERT(varchar, R.ApprovalDate, 103) as ApprovalDate,
    OLD.temppath AS OfferLetterDocPath,
    Offer_letter_Skip_Status AS OfferLetterSkipStatus
    from 
      Tbl_Student_NewApplication NP 
      inner join dbo.Tbl_Candidate_Personal_Det AS CPD on NP.Candidate_Id = CPD.Candidate_Id 
      left JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
      LEFT JOIN Tbl_Offerlettre ol on ol.candidate_id = CPD.Candidate_Id 
      and ol.delete_status = 0 
      LEFT JOIN Approval_Request R on CPD.candidate_id = R.StudentId 
      LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
      LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = NP.New_Admission_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
      left join Tbl_IntakeMaster im on im.id = cbd.intakemasterid 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdp.batch_id = na.batch_id 
      LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
      AND SS.Student_Semester_Delete_Status = 0 
      AND SS.Student_Semester_Current_Status = 1 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.duration_period_id = cdm.duration_period_id 
      LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
      LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
        SELECT 
          Employee_Id 
        FROM 
          dbo.Tbl_Employee_User 
        WHERE 
          (User_Id = SR.UserId)
      ) 
      LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
    --LEFT OUTER JOIN Tbl_offerletter_log AS OLD ON OLD.candidateid = OL.candidate_id 
      LEFT OUTER JOIN (
      SELECT t1.candidateid, t1.senddate AS latest, t1.temppath
      FROM Tbl_offerletter_log t1
      INNER JOIN (
        SELECT candidateid, MAX(senddate) AS latest_senddate
        FROM Tbl_offerletter_log
        GROUP BY candidateid )
        t2 ON t1.candidateid = t2.candidateid 
        AND t1.senddate = t2.latest_senddate
    ) AS OLD ON OLD.candidateid = OL.candidate_id
    where 
      NP.Candidate_DelStatus = 0 
      and dbo.tbl_approval_log.delete_status = 0 
      and --dbo.tbl_approval_log.delete_status=0 and          
      (
        CPD.Campus = @organization_id 
        or @organization_id = ''0''
      ) 
      and (
        NA.Department_Id = @Department_id 
        or @Department_id = ''0''
      ) --and (NA.Batch_Id= @intake_id or @intake_id=''0'') and   
      and (
        im.id = @intake_id 
        or @intake_id = ''0''
      ) 
      and (
        (
          concat(
            CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
          ) like ''%'' + @SearchTerm + ''%''
        ) 
        or(
          CPD.AdharNumber like ''%'' + @SearchTerm + ''%''
        ) 
        or (
          NP.IDMatrixNo like ''%'' + @SearchTerm + ''%''
        ) 
        or @SearchTerm = '''' 
        or (
          CC.Candidate_Mob1 like ''%'' + @SearchTerm + ''%''
        )
      ) 
      and (
        NP.Active_Status = ''Active'' 
        or NP.Active_Status = ''ACTIVE''
      ) 
      and (
        NP.ApplicationStatus = @application_status 
        or @application_status is null
      ) 
      and NP.ApplicationStatus is not null
  ) 
order by 
  ID desc OFFSET @pagesize * (@CurrentPage -1) ROWS FETCH NEXT @pagesize ROWS ONLY end end


if(@Flag = 1) begin begin 
select 
  count(*) as counts 
from 
  (
    (
      SELECT 
        DISTINCT CPD.Candidate_Id AS counts 
      FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD 
        left JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
        and dbo.tbl_approval_log.delete_status = 0 
        LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
        AND SS.Student_Semester_Delete_Status = 0 
        AND SS.Student_Semester_Current_Status = 1 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id 
        left join Tbl_IntakeMaster im on im.id = cbd.intakemasterid 
        LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
        LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
        LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
          SELECT 
            Employee_Id 
          FROM 
            dbo.Tbl_Employee_User 
          WHERE 
            (User_Id = SR.UserId)
        ) 
        LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
      where 
        CPD.Candidate_DelStatus = 0 
        and dbo.tbl_approval_log.delete_status = 0 
        and --dbo.tbl_approval_log.delete_status=0 and          
        (
          CPD.Campus = @organization_id 
          or @organization_id = ''0''
        ) 
        and (
          NA.Department_Id = @Department_id 
          or @Department_id = ''0''
        ) 
        and (
          NA.Batch_Id = @intake_id 
          or @intake_id = ''0''
        ) 
        and (
          (
            concat(
              CPD.Candidate_Fname, '''', CPD.Candidate_Lname
            ) like ''%'' + @SearchTerm + ''%''
          ) 
          or(
            CPD.AdharNumber like ''%'' + @SearchTerm + ''%''
          ) 
          or (
            CPD.IDMatrixNo like ''%'' + @SearchTerm + ''%''
          ) 
          or @SearchTerm = '''' 
          or (
            CC.Candidate_Mob1 like ''%'' + @SearchTerm + ''%''
          )
        ) 
        and (
          CPD.Active_Status = ''Active'' 
          or CPD.Active_Status = ''ACTIVE''
        ) 
        and (
          CPD.ApplicationStatus = @application_status 
          or @application_status is null
        ) 
        and CPD.ApplicationStatus is not null
    ) 
    Union all 
      (
        SELECT 
          DISTINCT NP.Candidate_Id AS counts 
        FROM 
          Tbl_Student_NewApplication NP 
          inner join dbo.Tbl_Candidate_Personal_Det AS CPD on NP.Candidate_Id = CPD.Candidate_Id 
          left JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
          and dbo.tbl_approval_log.delete_status = 0 
          LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
          LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
          AND SS.Student_Semester_Delete_Status = 0 
          AND SS.Student_Semester_Current_Status = 1 
          LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
          LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = NP.New_Admission_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
          LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
          LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
          LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
            SELECT 
              Employee_Id 
            FROM 
              dbo.Tbl_Employee_User 
            WHERE 
              (User_Id = SR.UserId)
          ) 
          LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
        where 
          NP.Candidate_DelStatus = 0 
          and dbo.tbl_approval_log.delete_status = 0 
          and --dbo.tbl_approval_log.delete_status=0 and          
          (
            CPD.Campus = @organization_id 
            or @organization_id = ''0''
          ) 
          and (
            NA.Department_Id = @Department_id 
            or @Department_id = ''0''
          ) 
          and (
            NA.Batch_Id = @intake_id 
            or @intake_id = ''0''
          ) 
          and (
            (
              concat(
                CPD.Candidate_Fname, '''', CPD.Candidate_Lname
              ) like ''%'' + @SearchTerm + ''%''
            ) 
            or(
              CPD.AdharNumber like ''%'' + @SearchTerm + ''%''
            ) 
            or (
              NP.IDMatrixNo like ''%'' + @SearchTerm + ''%''
            ) 
            or @SearchTerm = '''' 
            or (
              CC.Candidate_Mob1 like ''%'' + @SearchTerm + ''%''
            )
          ) 
          and (
            NP.Active_Status = ''Active'' 
            or CPD.Active_Status = ''ACTIVE''
          ) 
          and (
            NP.ApplicationStatus = @application_status 
            or @application_status is null
          ) 
          and NP.ApplicationStatus is not null
      )
  ) t end end 
 if @flag = 2 begin begin (
   
   SELECT 
      DISTINCT CPD.Candidate_Id AS ID, 
      SG.BloodGroup, 
      CPD.IDMatrixNo, 
      CPD.Candidate_Gender, 
      CPD.IdentificationNo, 
      concat(
        CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
      ) AS CandidateName, 
      CPD.Candidate_Fname, 
      CPD.AdharNumber, 
      CPD.TypeOfStudent, 
      CPD.Status, 
      CPD.Candidate_Dob AS DOB, 
      CPD.New_Admission_Id AS AdmnID, 
      CPD.ApplicationStatus, 
      CC.Candidate_idNo AS IdentificationNumber, 
      CC.Candidate_ContAddress AS Address, 
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email, 
      CCat.Course_Category_Id, 
      cbd.Batch_Id AS BatchID, 
      cbd.Batch_Code AS Batch, 
      NA.Batch_Id, 
      im.Batch_Code as masterintake, 
      CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          cbd.Batch_Code 
        FROM 
          Tbl_Course_Batch_Duration cbd 
        WHERE 
          cbd.Batch_Id = NA.Batch_Id
      ) END AS Batch_Code, 
      CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END AS UserName, 
      NA.Course_Level_Id AS LevelID, 
      CL.Course_Level_Name AS LevelName, 
      NA.Course_Category_Id AS CategoryID, 
      CCat.Course_Category_Name AS Category, 
      NA.Department_Id AS DepartmentID, 
      CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          D.Department_Name 
        FROM 
          Tbl_Department D 
        WHERE 
          D.Department_Id = NA.Department_Id
      ) END AS Department_Name, 
      dbo.tbl_approval_log.Offerletter_sent as offerletter, 
      CASE WHEN dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL THEN CONVERT(
        VARCHAR(8), 
        dbo.tbl_approval_log.offer_letter_accept_date, 
        3
      ) ELSE ''-NA-'' END AS offerletter_acceptdate, 
      (
        SELECT 
          TOP 1 Offerletter_status 
        FROM 
          tbl_approval_log 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Offerletter_status
      ) AS offersentsts, 
      (
        SELECT 
          TOP 1 Conditional_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Conditional_offerletter
      ) AS Conditional_offerletter, 
      (
        SELECT 
          TOP 1 Resend_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Resend_offerletter
      ) AS Resend_offerletter, 
      cpd.verifiedby, 
      CASE WHEN ApprovalStatus = 1 
      AND R.RefundStatus IS NULL THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus IS NULL THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
      CONVERT(varchar, R.RequestDate, 103) AS RequestDate, 
      CONVERT(varchar, R.ApprovalDate, 103) AS ApprovalDate,
    OLD.temppath AS OfferLetterDocPath,
    Offer_letter_Skip_Status AS OfferLetterSkipStatus
    
    FROM 
      dbo.Tbl_Candidate_Personal_Det AS CPD 
      LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
      AND dbo.tbl_approval_log.delete_status = 0 
      LEFT JOIN Tbl_Offerlettre ol ON ol.candidate_id = CPD.Candidate_Id 
      AND ol.delete_status = 0 
      LEFT JOIN Approval_Request R ON CPD.candidate_id = R.StudentId 
      LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
      AND SS.Student_Semester_Delete_Status = 0 
      AND SS.Student_Semester_Current_Status = 1 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
      LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
      LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid 
      LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
      LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
        SELECT 
          Employee_Id 
        FROM 
          dbo.Tbl_Employee_User 
        WHERE 
          User_Id = SR.UserId
      ) 
      LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
    LEFT OUTER JOIN (
      SELECT t1.candidateid, t1.senddate AS latest, t1.temppath
      FROM Tbl_offerletter_log t1
      INNER JOIN (
        SELECT candidateid, MAX(senddate) AS latest_senddate
        FROM Tbl_offerletter_log
        GROUP BY candidateid )
        t2 ON t1.candidateid = t2.candidateid 
        AND t1.senddate = t2.latest_senddate
    ) AS OLD ON OLD.candidateid = OL.candidate_id
    WHERE 
      CPD.Candidate_DelStatus = 0 
      AND dbo.tbl_approval_log.delete_status = 0 
      AND (
        CPD.Campus = @organization_id 
        OR @organization_id = ''0''
      ) 
      AND (
        NA.Department_Id = @Department_id 
        OR @Department_id = ''0''
      ) 
      AND (
        NA.Batch_Id = @intake_id 
        OR @intake_id = ''0''
      ) 
      AND (
        (
          concat(
            CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
          ) LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          CPD.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR @SearchTerm = '''' 
        OR (
          CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        )
      ) 
      AND (
        CPD.Active_Status = ''Active'' 
        OR CPD.Active_Status = ''ACTIVE''
      ) 
      AND (
        CPD.ApplicationStatus = @application_status 
        OR @application_status IS NULL
      ) 
      AND CPD.ApplicationStatus IS NOT NULL 
      AND (
        CPD.CounselorEmployee_Id = @counselorid 
        OR @counselorid = 0
      )
  ) 
UNION ALL 
  (
    SELECT 
      DISTINCT NP.Candidate_Id AS ID, 
      SG.BloodGroup, 
      NP.IDMatrixNo, 
      CPD.Candidate_Gender, 
      CPD.IdentificationNo, 
      concat(
        CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
      ) AS CandidateName, 
      CPD.Candidate_Fname, 
      CPD.AdharNumber, 
      CPD.TypeOfStudent, 
      CPD.Status, 
      CPD.Candidate_Dob AS DOB, 
      NP.New_Admission_Id AS AdmnID, 
      NP.ApplicationStatus, 
      CC.Candidate_idNo AS IdentificationNumber, 
      CC.Candidate_ContAddress AS Address, 
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email, 
      CCat.Course_Category_Id, 
      cbd.Batch_Id AS BatchID, 
      cbd.Batch_Code AS Batch, 
      NA.Batch_Id, 
      im.Batch_Code as masterintake, 
      CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          cbd.Batch_Code 
        FROM 
          Tbl_Course_Batch_Duration cbd 
        WHERE 
          cbd.Batch_Id = NA.Batch_Id
      ) END AS Batch_Code, 
      CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END AS UserName, 
      NA.Course_Level_Id AS LevelID, 
      CL.Course_Level_Name AS LevelName, 
      NA.Course_Category_Id AS CategoryID, 
      CCat.Course_Category_Name AS Category, 
      NA.Department_Id AS DepartmentID, 
      CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          D.Department_Name 
        FROM 
          Tbl_Department D 
        WHERE 
          D.Department_Id = NA.Department_Id
      ) END AS Department_Name, 
      dbo.tbl_approval_log.Offerletter_sent AS offerletter, 
      CASE WHEN dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL THEN CONVERT(
        VARCHAR(8), 
        dbo.tbl_approval_log.offer_letter_accept_date, 
        3
      ) ELSE ''-NA-'' END AS offerletter_acceptdate, 
      (
        SELECT 
          TOP 1 Offerletter_status 
        FROM 
          tbl_approval_log 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Offerletter_status
      ) AS offersentsts, 
      (
        SELECT 
          TOP 1 Conditional_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Conditional_offerletter
      ) AS Conditional_offerletter, 
      (
        SELECT 
          TOP 1 Resend_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Resend_offerletter
      ) AS Resend_offerletter, 
      cpd.verifiedby, 
      CASE WHEN ApprovalStatus = 1 
      AND R.RefundStatus IS NULL THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus IS NULL THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
      CONVERT(varchar, R.RequestDate, 103) AS RequestDate, 
      CONVERT(varchar, R.ApprovalDate, 103) AS ApprovalDate ,
    OLD.temppath AS OfferLetterDocPath,
    
    Offer_letter_Skip_Status AS OfferLetterSkipStatus
    FROM 

      Tbl_Student_NewApplication NP 
      INNER JOIN dbo.Tbl_Candidate_Personal_Det AS CPD ON NP.Candidate_Id = CPD.Candidate_Id 
      LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
      LEFT JOIN Tbl_Offerlettre ol ON ol.candidate_id = CPD.Candidate_Id 
      AND ol.delete_status = 0 
      LEFT JOIN Approval_Request R ON CPD.candidate_id = R.StudentId 
      LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
      LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = NP.New_Admission_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
      LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdp.batch_id = na.batch_id 
      LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
      AND SS.Student_Semester_Delete_Status = 0 
      AND SS.Student_Semester_Current_Status = 1 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.duration_period_id = cdm.duration_period_id 
      LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
      LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
        SELECT 
          Employee_Id 
        FROM 
          dbo.Tbl_Employee_User 
        WHERE 
          User_Id = SR.UserId
      ) 
      LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id
    LEFT OUTER JOIN (
      SELECT t1.candidateid, t1.senddate AS latest, t1.temppath
      FROM Tbl_offerletter_log t1
      INNER JOIN (
        SELECT candidateid, MAX(senddate) AS latest_senddate
        FROM Tbl_offerletter_log
        GROUP BY candidateid )
        t2 ON t1.candidateid = t2.candidateid 
        AND t1.senddate = t2.latest_senddate
    ) AS OLD ON OLD.candidateid = OL.candidate_id
    WHERE 
      NP.Candidate_DelStatus = 0 
      AND dbo.tbl_approval_log.delete_status = 0 
      AND (
        CPD.Campus = @organization_id 
        OR @organization_id = ''0''
      ) 
      AND (
        NA.Department_Id = @Department_id 
        OR @Department_id = ''0''
      ) 
      AND (
        NA.Batch_Id = @intake_id 
        OR @intake_id = ''0''
      ) 
      AND (
        (
          concat(
            CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
          ) LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          NP.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR @SearchTerm = '''' 
        OR (
          CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        )
      ) 
      AND (
        NP.Active_Status = ''Active'' 
        OR NP.Active_Status = ''ACTIVE''
      ) 
      AND (
        NP.ApplicationStatus = @application_status 
        OR @application_status IS NULL
      ) 
      AND NP.ApplicationStatus IS NOT NULL 
      AND (
        NP.CounselorEmployee_id = @counselorid 
        OR @counselorid = 0
      )
  ) 
ORDER BY 
  ID DESC OFFSET @pagesize * (@CurrentPage -1) ROWS FETCH NEXT @pagesize ROWS ONLY end end 
 if @flag = 4 begin begin 
SELECT 
  COUNT(*) AS counts 
FROM 
  (
    (
      SELECT 
        DISTINCT CPD.Candidate_Id AS counts 
      FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD 
        LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
        AND dbo.tbl_approval_log.delete_status = 0 
        LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
        AND SS.Student_Semester_Delete_Status = 0 
        AND SS.Student_Semester_Current_Status = 1 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid 
        LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
        LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
        LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
          SELECT 
            Employee_Id 
          FROM 
            dbo.Tbl_Employee_User 
          WHERE 
            User_Id = SR.UserId
        ) 
        LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
      WHERE 
        CPD.Candidate_DelStatus = 0 
        AND dbo.tbl_approval_log.delete_status = 0 
        AND (
          CPD.Campus = @organization_id 
          OR @organization_id = ''0''
        ) 
        AND (
          NA.Department_Id = @Department_id 
          OR @Department_id = ''0''
        ) 
        AND (
          NA.Batch_Id = @intake_id 
          OR @intake_id = ''0''
        ) 
        AND (
          (
            CONCAT(
              CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
            ) LIKE ''%'' + @SearchTerm + ''%''
          ) 
          OR (
            CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
          ) 
          OR (
            CPD.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
          ) 
          OR @SearchTerm = '''' 
          OR (
            CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
          )
        ) 
        AND (
          CPD.Active_Status = ''Active'' 
          OR CPD.Active_Status = ''ACTIVE''
        ) 
        AND (
          CPD.ApplicationStatus = @application_status 
          OR @application_status IS NULL
        ) 
        AND CPD.ApplicationStatus IS NOT NULL 
        AND (
          CPD.CounselorEmployee_Id = @counselorid 
          OR @counselorid = 0
        )
    ) 
    UNION ALL 
      (
        SELECT 
          DISTINCT NP.Candidate_Id AS counts 
        FROM 
          Tbl_Student_NewApplication NP 
          INNER JOIN dbo.Tbl_Candidate_Personal_Det AS CPD ON NP.Candidate_Id = CPD.Candidate_Id 
          LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
          AND dbo.tbl_approval_log.delete_status = 0 
          LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
          LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
          AND SS.Student_Semester_Delete_Status = 0 
          AND SS.Student_Semester_Current_Status = 1 
          LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
          LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = NP.New_Admission_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
          LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
          LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
          LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
            SELECT 
              Employee_Id 
            FROM 
              dbo.Tbl_Employee_User 
            WHERE 
              User_Id = SR.UserId
          ) 
          LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
        WHERE 
          NP.Candidate_DelStatus = 0 
          AND dbo.tbl_approval_log.delete_status = 0 
          AND (
            CPD.Campus = @organization_id 
            OR @organization_id = ''0''
          ) 
          AND (
            NA.Department_Id = @Department_id 
            OR @Department_id = ''0''
          ) 
          AND (
            NA.Batch_Id = @intake_id 
            OR @intake_id = ''0''
          ) 
          AND (
            (
              CONCAT(
                CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
              ) LIKE ''%'' + @SearchTerm + ''%''
            ) 
            OR (
              CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
            ) 
            OR (
              NP.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
            ) 
            OR @SearchTerm = '''' 
            OR (
              CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
            )
          ) 
          AND (
            NP.Active_Status = ''Active'' 
            OR CPD.Active_Status = ''ACTIVE''
          ) 
          AND (
            NP.ApplicationStatus = @application_status 
            OR @application_status IS NULL
          ) 
          AND NP.ApplicationStatus IS NOT NULL 
          AND (
            CPD.CounselorEmployee_Id = @counselorid 
            OR @counselorid = 0
          )
      )
  ) t end end 
 if @flag = 3 begin (
    SELECT 
      DISTINCT CPD.Candidate_Id AS ID, 
      SG.BloodGroup, 
      CPD.IDMatrixNo, 
      CPD.Candidate_Gender, 
      CPD.IdentificationNo, 
      concat(
        CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
      ) AS CandidateName, 
      CPD.Candidate_Fname, 
      CPD.AdharNumber, 
      CPD.TypeOfStudent, 
      CPD.Status, 
      CPD.Candidate_Dob AS DOB, 
      CPD.New_Admission_Id AS AdmnID, 
      CPD.ApplicationStatus, 
      CC.Candidate_idNo AS IdentificationNumber, 
      CC.Candidate_ContAddress AS Address, 
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email, 
      CCat.Course_Category_Id, 
      cbd.Batch_Id AS BatchID, 
      cbd.Batch_Code AS Batch, 
      NA.Batch_Id, 
      im.Batch_Code as masterintake, 
      CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          cbd.Batch_Code 
        FROM 
          Tbl_Course_Batch_Duration cbd 
        WHERE 
          cbd.Batch_Id = NA.Batch_Id
      ) END AS Batch_Code, 
      CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END AS UserName, 
      NA.Course_Level_Id AS LevelID, 
      CL.Course_Level_Name AS LevelName, 
      NA.Course_Category_Id AS CategoryID, 
      CCat.Course_Category_Name AS Category, 
      NA.Department_Id AS DepartmentID, 
      CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          D.Department_Name 
        FROM 
          Tbl_Department D 
        WHERE 
          D.Department_Id = NA.Department_Id
      ) END AS Department_Name, 
      dbo.tbl_approval_log.Offerletter_sent as offerletter, 
      CASE WHEN dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL THEN CONVERT(
        VARCHAR(8), 
        dbo.tbl_approval_log.offer_letter_accept_date, 
        3
      ) ELSE ''-NA-'' END AS offerletter_acceptdate, 
      (
        SELECT 
          TOP 1 Offerletter_status 
        FROM 
          tbl_approval_log 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Offerletter_status
      ) AS offersentsts, 
      (
        SELECT 
          TOP 1 Conditional_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Conditional_offerletter
      ) AS Conditional_offerletter, 
      (
        SELECT 
          TOP 1 Resend_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Resend_offerletter
      ) AS Resend_offerletter, 
      cpd.verifiedby, 
      CASE WHEN ApprovalStatus = 1 
      AND R.RefundStatus IS NULL THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus IS NULL THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
      CONVERT(varchar, R.RequestDate, 103) AS RequestDate, 
      CONVERT(varchar, R.ApprovalDate, 103) AS ApprovalDate 
    FROM 
      dbo.Tbl_Candidate_Personal_Det AS CPD 
      LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
      AND dbo.tbl_approval_log.delete_status = 0 
      LEFT JOIN Tbl_Offerlettre ol ON ol.candidate_id = CPD.Candidate_Id 
      AND ol.delete_status = 0 
      LEFT JOIN Approval_Request R ON CPD.candidate_id = R.StudentId 
      LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
      AND SS.Student_Semester_Delete_Status = 0 
      AND SS.Student_Semester_Current_Status = 1 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
      LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
      LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid 
      LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
      LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
        SELECT 
          Employee_Id 
        FROM 
          dbo.Tbl_Employee_User 
        WHERE 
          User_Id = SR.UserId
      ) 
      LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
    WHERE 
      CPD.Candidate_DelStatus = 0 
      AND dbo.tbl_approval_log.delete_status = 0 
      AND (
        CPD.Campus = @organization_id 
        OR @organization_id = ''0''
      ) 
      AND (
        NA.Department_Id = @Department_id 
        OR @Department_id = ''0''
      ) 
      AND (
        NA.Batch_Id = @intake_id 
        OR @intake_id = ''0''
      ) 
      AND (
        (
          concat(
            CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
          ) LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          CPD.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR @SearchTerm = '''' 
        OR (
          CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        )
      ) 
      AND (
        CPD.Active_Status = ''Active'' 
        OR CPD.Active_Status = ''ACTIVE''
      ) 
      AND (
        CPD.ApplicationStatus = @application_status 
        OR @application_status IS NULL
      ) 
      AND CPD.ApplicationStatus IS NOT NULL 
      AND (
        CPD.Agent_ID = @counselorid 
        OR @counselorid = 0
      )
  ) 
UNION ALL 
  (
    SELECT 
      DISTINCT CPD.Candidate_Id AS ID, 
      SG.BloodGroup, 
      NP.IDMatrixNo, 
      CPD.Candidate_Gender, 
      CPD.IdentificationNo, 
      concat(
        CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
      ) AS CandidateName, 
      CPD.Candidate_Fname, 
      CPD.AdharNumber, 
      CPD.TypeOfStudent, 
      CPD.Status, 
      CPD.Candidate_Dob AS DOB, 
      NP.New_Admission_Id AS AdmnID, 
      NP.ApplicationStatus, 
      CC.Candidate_idNo AS IdentificationNumber, 
      CC.Candidate_ContAddress AS Address, 
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email, 
      CCat.Course_Category_Id, 
      cbd.Batch_Id AS BatchID, 
      cbd.Batch_Code AS Batch, 
      NA.Batch_Id, 
      im.Batch_Code as masterintake, 
      CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          cbd.Batch_Code 
        FROM 
          Tbl_Course_Batch_Duration cbd 
        WHERE 
          cbd.Batch_Id = NA.Batch_Id
      ) END AS Batch_Code, 
      CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END AS UserName, 
      NA.Course_Level_Id AS LevelID, 
      CL.Course_Level_Name AS LevelName, 
      NA.Course_Category_Id AS CategoryID, 
      CCat.Course_Category_Name AS Category, 
      NA.Department_Id AS DepartmentID, 
      CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          D.Department_Name 
        FROM 
          Tbl_Department D 
        WHERE 
          D.Department_Id = NA.Department_Id
      ) END AS Department_Name, 
      dbo.tbl_approval_log.Offerletter_sent AS offerletter, 
      CASE WHEN dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL THEN CONVERT(
        VARCHAR(8), 
        dbo.tbl_approval_log.offer_letter_accept_date, 
        3
      ) ELSE ''-NA-'' END AS offerletter_acceptdate, 
      (
        SELECT 
          TOP 1 Offerletter_status 
        FROM 
          tbl_approval_log 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Offerletter_status
      ) AS offersentsts, 
      (
        SELECT 
          TOP 1 Conditional_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Conditional_offerletter
      ) AS Conditional_offerletter, 
      (
        SELECT 
          TOP 1 Resend_offerletter 
        FROM 
          Tbl_Offerlettre 
        WHERE 
          Candidate_id = CPD.Candidate_Id 
        ORDER BY 
          Resend_offerletter
      ) AS Resend_offerletter, 
      cpd.verifiedby, 
      CASE WHEN ApprovalStatus = 1 
      AND R.RefundStatus IS NULL THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus IS NULL THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
      AND R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
      AND R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
      CONVERT(varchar, R.RequestDate, 103) AS RequestDate, 
      CONVERT(varchar, R.ApprovalDate, 103) AS ApprovalDate 
    FROM 
      Tbl_Student_NewApplication NP 
      INNER JOIN dbo.Tbl_Candidate_Personal_Det AS CPD ON NP.Candidate_Id = CPD.Candidate_Id 
      LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
      LEFT JOIN Tbl_Offerlettre ol ON ol.candidate_id = CPD.Candidate_Id 
      AND ol.delete_status = 0 
      LEFT JOIN Approval_Request R ON CPD.candidate_id = R.StudentId 
      LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
      LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = NP.New_Admission_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
      LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdp.batch_id = na.batch_id 
      LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
      AND SS.Student_Semester_Delete_Status = 0 
      AND SS.Student_Semester_Current_Status = 1 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.duration_period_id = cdm.duration_period_id 
      LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
      LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
        SELECT 
          Employee_Id 
        FROM 
          dbo.Tbl_Employee_User 
        WHERE 
          User_Id = SR.UserId
      ) 
      LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
    WHERE 
      NP.Candidate_DelStatus = 0 
      AND dbo.tbl_approval_log.delete_status = 0 
      AND (
        CPD.Campus = @organization_id 
        OR @organization_id = ''0''
      ) 
      AND (
        NA.Department_Id = @Department_id 
        OR @Department_id = ''0''
      ) 
      AND (
        NA.Batch_Id = @intake_id 
        OR @intake_id = ''0''
      ) 
      AND (
        (
          concat(
            CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
          ) LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR (
          NP.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
        ) 
        OR @SearchTerm = '''' 
        OR (
          CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        )
      ) 
      AND (
        NP.Active_Status = ''Active'' 
        OR NP.Active_Status = ''ACTIVE''
      ) 
      AND (
        NP.ApplicationStatus = @application_status 
        OR @application_status IS NULL
      ) 
      AND NP.ApplicationStatus IS NOT NULL 
      AND (
        CPD.Agent_ID = @counselorid 
        OR @counselorid = 0
      )
  ) 
ORDER BY 
  ID DESC OFFSET @pagesize * (@CurrentPage -1) ROWS FETCH NEXT @pagesize ROWS ONLY end 
if @flag = 6 begin begin 
SELECT 
  COUNT(*) AS counts 
FROM 
  (
    (
      SELECT 
        DISTINCT CPD.Candidate_Id AS counts 
      FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD 
        LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
        AND dbo.tbl_approval_log.delete_status = 0 
        LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
        AND SS.Student_Semester_Delete_Status = 0 
        AND SS.Student_Semester_Current_Status = 1 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster im ON im.id = cbd.intakemasterid 
        LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
        LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
        LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
          SELECT 
            Employee_Id 
          FROM 
            dbo.Tbl_Employee_User 
          WHERE 
            User_Id = SR.UserId
        ) 
        LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
      WHERE 
        CPD.Candidate_DelStatus = 0 
        AND dbo.tbl_approval_log.delete_status = 0 
        AND (
          CPD.Campus = @organization_id 
          OR @organization_id = ''0''
        ) 
        AND (
          NA.Department_Id = @Department_id 
          OR @Department_id = ''0''
        ) 
        AND (
          NA.Batch_Id = @intake_id 
          OR @intake_id = ''0''
        ) 
        AND (
          (
            CONCAT(
              CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
            ) LIKE ''%'' + @SearchTerm + ''%''
          ) 
          OR (
            CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
          ) 
          OR (
            CPD.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
          ) 
          OR @SearchTerm = '''' 
          OR (
            CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
          )
        ) 
        AND (
          CPD.Active_Status = ''Active'' 
          OR CPD.Active_Status = ''ACTIVE''
        ) 
        AND (
          CPD.ApplicationStatus = @application_status 
          OR @application_status IS NULL
        ) 
        AND CPD.ApplicationStatus IS NOT NULL 
        AND (
          CPD.Agent_ID = @counselorid 
          OR @counselorid = 0
        )
    ) 
    UNION ALL 
      (
        SELECT 
          DISTINCT NP.Candidate_Id AS counts 
        FROM 
          Tbl_Student_NewApplication NP 
          INNER JOIN dbo.Tbl_Candidate_Personal_Det AS CPD ON NP.Candidate_Id = CPD.Candidate_Id 
          LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
          AND dbo.tbl_approval_log.delete_status = 0 
          LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
          LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
          AND SS.Student_Semester_Delete_Status = 0 
          AND SS.Student_Semester_Current_Status = 1 
          LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
          LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = NP.New_Admission_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
          LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
          LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
          LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
          LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
            SELECT 
              Employee_Id 
            FROM 
              dbo.Tbl_Employee_User 
            WHERE 
              User_Id = SR.UserId
          ) 
          LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
        WHERE 
          NP.Candidate_DelStatus = 0 
          AND dbo.tbl_approval_log.delete_status = 0 
          AND (
            CPD.Campus = @organization_id 
            OR @organization_id = ''0''
          ) 
          AND (
            NA.Department_Id = @Department_id 
            OR @Department_id = ''0''
          ) 
          AND (
            NA.Batch_Id = @intake_id 
            OR @intake_id = ''0''
          ) 
          AND (
            (
              CONCAT(
                CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
              ) LIKE ''%'' + @SearchTerm + ''%''
            ) 
            OR (
              CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%''
            ) 
            OR (
              NP.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%''
            ) 
            OR @SearchTerm = '''' 
            OR (
              CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
            )
          ) 
          AND (
            NP.Active_Status = ''Active'' 
            OR CPD.Active_Status = ''ACTIVE''
          ) 
          AND (
            NP.ApplicationStatus = @application_status 
            OR @application_status IS NULL
          ) 
          AND NP.ApplicationStatus IS NOT NULL 
          AND (
            CPD.Agent_ID = @counselorid 
            OR @counselorid = 0
          )
      )
  ) t end end

 IF(@Flag=300)
BEGIN
   SELECT 
    DISTINCT CPD.Candidate_Id AS ID, 
    SG.BloodGroup, 
    CPD.IDMatrixNo, 
    CPD.Candidate_Gender, 
    CPD.IdentificationNo, 
    concat(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname ) AS CandidateName, 
    CPD.Candidate_Fname, 
    CPD.AdharNumber, 
    CPD.TypeOfStudent, 
    CPD.Status, 
    CPD.Candidate_Dob AS DOB, 
    CPD.New_Admission_Id AS AdmnID, 
    CPD.ApplicationStatus, 
    CC.Candidate_idNo AS IdentificationNumber, 
    CC.Candidate_ContAddress AS Address, 
    CC.Candidate_Mob1 AS MobileNumber, 
    CC.Candidate_Email, 
    CCat.Course_Category_Id, 
    cbd.Batch_Id AS BatchID, 
    cbd.Batch_Code AS Batch, 
    NA.Batch_Id, 
    im.Batch_Code as masterintake, 
    CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
      SELECT 
        cbd.Batch_Code 
      FROM 
        Tbl_Course_Batch_Duration cbd 
      WHERE 
        cbd.Batch_Id = NA.Batch_Id
    ) END AS Batch_Code, 
    (
      CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END
    ) AS UserName, 
    NA.Course_Level_Id AS LevelID, 
    CL.Course_Level_Name AS LevelName, 
    NA.Course_Category_Id AS CategoryID, 
    CCat.Course_Category_Name AS Category, 
    NA.Department_Id AS DepartmentID, 
    CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
      SELECT 
        D.Department_Name 
      FROM 
        Tbl_Department D 
      WHERE 
        D.Department_Id = NA.Department_Id
    ) END AS Department_Name, 
    dbo.tbl_approval_log.Offerletter_sent as offerletter,   
  CASE 
    WHEN ((dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL) AND (ISNULL(Offer_letter_Skip_Status,0) = 0))
    THEN CONVERT(VARCHAR(8), dbo.tbl_approval_log.offer_letter_accept_date, 3) 
    ELSE ''-NA-'' 
END AS offerletter_acceptdate, 
    
    (
      select 
        top 1 Offerletter_status 
      from 
        tbl_approval_log 
      where 
        Candidate_id = CPD.Candidate_Id 
      order by 
        Offerletter_status
    ) as offersentsts, 
    --  dbo.tbl_approval_log.Offerletter_status as offersentsts,
    (
      select 
        top 1 Conditional_offerletter 
      from 
        Tbl_Offerlettre 
      where 
        Candidate_id = CPD.Candidate_Id 
      order by 
        Conditional_offerletter
    ) as Conditional_offerletter, 
    --  ol.Conditional_offerletter,
    (
      select 
        top 1 Resend_offerletter 
      from 
        Tbl_Offerlettre 
      where 
        Candidate_id = CPD.Candidate_Id 
      order by 
        Resend_offerletter
    ) as Resend_offerletter, 
    --  ol.Resend_offerletter,
    cpd.verifiedby, 
    CASE WHEN ApprovalStatus = 1 
    and R.RefundStatus is null THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
    and R.RefundStatus is null THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
    and R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
    and R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
    and R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
    and R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
    and R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
    CONVERT(varchar, R.RequestDate, 103) as RequestDate, 
    CONVERT(varchar, R.ApprovalDate, 103) as ApprovalDate,
  OLD.temppath AS OfferLetterDocPath,
  Offer_letter_Skip_Status AS OfferLetterSkipStatus
  FROM 
    dbo.Tbl_Candidate_Personal_Det AS CPD 
    left JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
    and dbo.tbl_approval_log.delete_status = 0LEFT 
    JOIN Tbl_Offerlettre ol on ol.candidate_id = CPD.Candidate_Id 
    and ol.delete_status = 0 
    LEFT JOIN Approval_Request R on CPD.candidate_id = R.StudentId 
    LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
    LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 
    AND SS.Student_Semester_Current_Status = 1 
    LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
    LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
    left join Tbl_IntakeMaster im on im.id = cbd.intakemasterid 
    LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
    LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
    LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
    LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
    LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
      SELECT 
        Employee_Id 
      FROM 
        dbo.Tbl_Employee_User 
      WHERE 
        (User_Id = SR.UserId)
    ) 
    LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id
  --LEFT OUTER JOIN Tbl_offerletter_log AS OLD ON OLD.candidateid = OL.candidate_id
  LEFT OUTER JOIN (
      SELECT t1.candidateid, t1.senddate AS latest, t1.temppath
      FROM Tbl_offerletter_log t1
      INNER JOIN (
        SELECT candidateid, MAX(senddate) AS latest_senddate
        FROM Tbl_offerletter_log
        GROUP BY candidateid )
        t2 ON t1.candidateid = t2.candidateid 
        AND t1.senddate = t2.latest_senddate
    ) AS OLD ON OLD.candidateid = OL.candidate_id

  WHERE 
    CPD.ApplicationStatus = ''Verified''
    AND CPD.Candidate_DelStatus = 0
   AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    )
    AND (
        @IntakeId = 0 -- Ignore intake filter if @IntakeId is 0
        OR CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) 
        OR CDP.Duration_Period_Id = 0
    )


  Union all 
  (
    SELECT 
      DISTINCT NP.Candidate_Id AS ID, 
      SG.BloodGroup, 
      NP.IDMatrixNo, 
      CPD.Candidate_Gender, 
      CPD.IdentificationNo, 
      concat(
        CPD.Candidate_Fname, '' '', CPD.Candidate_Lname
      ) AS CandidateName, 
      CPD.Candidate_Fname, 
      CPD.AdharNumber, 
      CPD.TypeOfStudent, 
      CPD.Status, 
      CPD.Candidate_Dob AS DOB, 
      NP.New_Admission_Id AS AdmnID, 
      NP.ApplicationStatus, 
      CC.Candidate_idNo AS IdentificationNumber, 
      CC.Candidate_ContAddress AS Address, 
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email, 
      CCat.Course_Category_Id, 
      cbd.Batch_Id AS BatchID, 
      cbd.Batch_Code AS Batch, 
      NA.Batch_Id, 
      im.Batch_Code as masterintake, 
      CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          cbd.Batch_Code 
        FROM 
          Tbl_Course_Batch_Duration cbd 
        WHERE 
          cbd.Batch_Id = NA.Batch_Id
      ) END AS Batch_Code, 
      (
        CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END
      ) AS UserName, 
      NA.Course_Level_Id AS LevelID, 
      CL.Course_Level_Name AS LevelName, 
      NA.Course_Category_Id AS CategoryID, 
      CCat.Course_Category_Name AS Category, 
      NA.Department_Id AS DepartmentID, 
      CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE (
        SELECT 
          D.Department_Name 
        FROM 
          Tbl_Department D 
        WHERE 
          D.Department_Id = NA.Department_Id
      ) END AS Department_Name, 
      dbo.tbl_approval_log.Offerletter_sent as offerletter,   
  CASE 
    WHEN ((dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL) AND (ISNULL(Offer_letter_Skip_Status,0) = 0))
    THEN CONVERT(VARCHAR(8), dbo.tbl_approval_log.offer_letter_accept_date, 3) 
    ELSE ''-NA-'' 
END AS offerletter_acceptdate,
      (
        select 
          top 1 Offerletter_status 
        from 
          tbl_approval_log 
        where 
          Candidate_id = CPD.Candidate_Id 
        order by 
          Offerletter_status
      ) as offersentsts, 
      -- dbo.tbl_approval_log.Offerletter_status as offersentsts,
      (
        select 
          top 1 Conditional_offerletter 
        from 
          Tbl_Offerlettre 
        where 
          Candidate_id = CPD.Candidate_Id 
        order by 
          Conditional_offerletter
      ) as Conditional_offerletter, 
      --  ol.Conditional_offerletter,
      (
        select 
          top 1 Resend_offerletter 
        from 
          Tbl_Offerlettre 
        where 
          Candidate_id = CPD.Candidate_Id 
        order by 
          Resend_offerletter
      ) as Resend_offerletter, 
      --  ol.Resend_offerletter,
      cpd.verifiedby, 
      CASE WHEN ApprovalStatus = 1 
      and R.RefundStatus is null THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 2 
      and R.RefundStatus is null THEN ''Finance Approved'' WHEN ApprovalStatus = 2 
      and R.RefundStatus = 0 THEN ''Finance Approved'' WHEN ApprovalStatus = 1 
      and R.RefundStatus = 0 THEN ''Requested for Finance Clearance'' WHEN ApprovalStatus = 3 THEN ''Finance Rejected'' WHEN ApprovalStatus = 2 
      and R.RefundStatus = 3 THEN ''Paid'' WHEN ApprovalStatus = 1 
      and R.RefundStatus = 1 THEN ''Pending(Approved)'' WHEN ApprovalStatus = 1 
      and R.RefundStatus = 2 THEN ''Pending(Processing)'' ELSE ''Pending finance clearance'' END AS StatusApproval, 
      CONVERT(varchar, R.RequestDate, 103) as RequestDate, 
      CONVERT(varchar, R.ApprovalDate, 103) as ApprovalDate,
    OLD.temppath AS OfferLetterDocPath,
    Offer_letter_Skip_Status AS OfferLetterSkipStatus
    from 
      Tbl_Student_NewApplication NP 
      inner join dbo.Tbl_Candidate_Personal_Det AS CPD on NP.Candidate_Id = CPD.Candidate_Id 
      left JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
      LEFT JOIN Tbl_Offerlettre ol on ol.candidate_id = CPD.Candidate_Id 
      and ol.delete_status = 0 
      LEFT JOIN Approval_Request R on CPD.candidate_id = R.StudentId 
      LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
      LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = NP.New_Admission_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
      left join Tbl_IntakeMaster im on im.id = cbd.intakemasterid 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdp.batch_id = na.batch_id 
      LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
      AND SS.Student_Semester_Delete_Status = 0 
      AND SS.Student_Semester_Current_Status = 1 
      LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.duration_period_id = cdm.duration_period_id 
      LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id 
      LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id 
      LEFT OUTER JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id 
      LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id 
      LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
        SELECT 
          Employee_Id 
        FROM 
          dbo.Tbl_Employee_User 
        WHERE 
          (User_Id = SR.UserId)
      ) 
      LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id 
    --LEFT OUTER JOIN Tbl_offerletter_log AS OLD ON OLD.candidateid = OL.candidate_id 
      LEFT OUTER JOIN (
      SELECT t1.candidateid, t1.senddate AS latest, t1.temppath
      FROM Tbl_offerletter_log t1
      INNER JOIN (
        SELECT candidateid, MAX(senddate) AS latest_senddate
        FROM Tbl_offerletter_log
        GROUP BY candidateid )
        t2 ON t1.candidateid = t2.candidateid 
        AND t1.senddate = t2.latest_senddate
    ) AS OLD ON OLD.candidateid = OL.candidate_id
  WHERE 
    CPD.ApplicationStatus = ''Verified''
    AND CPD.Candidate_DelStatus = 0
   AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    )
    AND (
        @IntakeId = 0 -- Ignore intake filter if @IntakeId is 0
        OR CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) 
        OR CDP.Duration_Period_Id = 0
    )

  ) 
order by 
  ID desc OFFSET @pagesize * (@CurrentPage -1) ROWS FETCH NEXT @pagesize ROWS ONLY
  end 
  if(@Flag=301)
  begin
  SELECT COUNT(*) AS counts
         FROM Tbl_Candidate_Personal_Det CPD
         LEFT JOIN tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
     
     LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
         WHERE CPD.ApplicationStatus = ''Verified''
           AND CPD.Candidate_DelStatus = 0 
       
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    )
    AND (
        @IntakeId = 0 -- Ignore intake filter if @IntakeId is 0
        OR CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) 
        OR CDP.Duration_Period_Id = 0
    )

  end
    ')
END
