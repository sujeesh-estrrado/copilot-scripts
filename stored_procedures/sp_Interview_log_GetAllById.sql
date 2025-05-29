IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Interview_log_GetAllById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Interview_log_GetAllById]          
(
    @CandidateId BIGINT = 0          
)
AS          
BEGIN  
    SELECT 
        Interview_date,
        Interview_venue, 
        CONVERT(VARCHAR(10), Schedule_date, 21) AS Schedule_date,
        result,          
        C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname AS StudentName,
        E.Employee_FName + '' '' + E.Employee_LName AS StaffName,          
        E1.Employee_FName + '' '' + E1.Employee_LName AS ScheduledBy,
        Remark,
        CONVERT(VARCHAR(10), reschedule_date, 21) AS reschedule_date          
    FROM Tbl_Interview_log L           
    LEFT JOIN Tbl_Interview_Schedule_Log S ON S.Candidate_id = L.candidate_id          
    LEFT JOIN [dbo].[Tbl_Candidate_Personal_Det] C ON C.Candidate_Id = L.Candidate_id          
    LEFT JOIN Tbl_Employee_User U ON U.Employee_Id = S.Staff_id          
    LEFT JOIN Tbl_Employee_User U1 ON U1.User_Id = L.Scheduled_by          
    LEFT JOIN Tbl_Employee E ON E.Employee_Id = U.Employee_Id          
    LEFT JOIN Tbl_Employee E1 ON E1.Employee_Id = U1.Employee_Id          
    WHERE L.candidate_id = @CandidateId          
END 
');
END;