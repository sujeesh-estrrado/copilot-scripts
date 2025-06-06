IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Get_All_Student_Hostel_Fees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Get_All_Student_Hostel_Fees]
        @Duration_Mapping_Id bigint,
        @Month Datetime
        AS
        BEGIN

            SELECT 
                DISTINCT S.Student_Semester_Id,
                S.Candidate_Id AS Id,
                S.Duration_Mapping_Id,
                Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname AS [Name],
                Hostel_Name,
                hf.Amount,
                ISNULL(CAST(hfd.Hostel_Fee_Payment_Id AS varchar(100)), ''0'') AS Hostel_Fee_Payment_Id,
                (hf.Amount - ISNULL(hfd.Amount, 0)) AS BalanceAmount,
                hf.HostelId,
                CASE 
                    WHEN hfd.Amount IS NULL THEN 0 -- not settled
                    WHEN hfd.Amount = hf.Amount THEN 1 -- fully settled
                    ELSE 2 
                END AS PaymentStatus -- partially settled
            FROM
                Tbl_Hstl_Student_Admission ha
            INNER JOIN Tbl_Hostel_Fee hf ON hf.HostelId = ha.Hostel_Id
            INNER JOIN Tbl_Candidate_Personal_Det C ON ha.Student_Id = C.Candidate_Id AND ha.Status = 0
            LEFT JOIN Tbl_Student_Semester S ON S.Candidate_Id = C.Candidate_Id AND S.Duration_Mapping_Id = @Duration_Mapping_Id
            INNER JOIN Tbl_HostelRegistration hr ON hr.Hostel_Id = hf.HostelId
            LEFT JOIN Tbl_Hostel_Fee_Payment_Detail hfd ON hfd.HostelFeeId = hf.HostelFeeId 
                AND hfd.[Month] = @Month 
                AND C.Candidate_Id = (
                    SELECT StudentOrEmployee_Id 
                    FROM Tbl_Hostel_Fee_Payment 
                    WHERE Hostel_Fee_Payment_Id = hfd.Hostel_Fee_Payment_Id
                )
            WHERE 
                S.Duration_Mapping_Id = @Duration_Mapping_Id 
                AND Student_Semester_Current_Status = 1 
                AND Student_Semester_Delete_Status = 0 
                AND Date = @Month
                AND (DATEPART(MM, @Month) BETWEEN DATEPART(MM, Admission_Date) AND ISNULL(DATEPART(MM, Leaving_Date), DATEPART(MM, GETDATE())))
                AND (DATEPART(YYYY, @Month) BETWEEN DATEPART(YYYY, Admission_Date) AND ISNULL(DATEPART(YYYY, Leaving_Date), DATEPART(YYYY, GETDATE())))
            ORDER BY [Name] ASC

        END
    ')
END
