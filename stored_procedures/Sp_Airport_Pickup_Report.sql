IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Airport_Pickup_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Airport_Pickup_Report] -- 1,0,0
            
        @ProgramType bigint = 0,
        @Program bigint = 0,
        @Intake varchar(max) = ''''
        AS
        BEGIN
            SELECT 
                CONCAT(CPD.Candidate_Fname, '''', CPD.Candidate_Lname) AS CandidateName,
                CPD.Candidate_Id AS ID,
                CPD.AdharNumber,
                DD.Department_Name,
                SS.Candidate_Email,
                SS.Candidate_Mob1,
                CN.Country,
                IM.Batch_Code
            FROM Tbl_Candidate_AirportPickup AP
            INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_id = AP.Candidate_Id
            LEFT JOIN tbl_New_Admission RR ON RR.New_Admission_Id = CPD.New_Admission_Id
            LEFT JOIN Tbl_Department DD ON DD.Department_Id = RR.Department_Id
            LEFT JOIN Tbl_Course_Batch_Duration LL ON LL.Batch_Id = RR.Batch_Id
            LEFT JOIN Tbl_Candidate_ContactDetails SS ON SS.Candidate_Id = CPD.Candidate_Id
            LEFT JOIN Tbl_Candidate_ContactDetails PCD ON PCD.Candidate_id = CPD.Candidate_Id
            LEFT JOIN Tbl_Country CN ON CN.Country_id = PCD.Candidate_PermAddress_Country
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = LL.IntakeMasterID
            WHERE CPD.Candidate_DelStatus = 0 
              AND AP.AirportPickup_status = 1
              AND (@ProgramType = 0 OR RR.Course_Category_Id = @ProgramType) 
              AND (@Program = 0 OR RR.Department_Id = @Program)
              AND (IM.Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) 
                   OR @Intake = '''')
        END
    ')
END
