IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_ISSO_Attendance_Students_List]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_ISSO_Attendance_Students_List]
as
begin
SELECT 
    Concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as Candidate_Name,
    SA.Candidate_Id,
    COUNT(*) AS Total_Occurrences,
    SUM(CASE WHEN Absent_Type = ''Present'' THEN 1 ELSE 0 END) AS Total_Present,
    ROUND((SUM(CASE WHEN Absent_Type = ''Present'' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Attendance_Percentage
FROM Tbl_Student_Absence SA 
LEFT JOIN 
Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SA.Candidate_Id
where Try_parse(CPD.Candidate_Nationality as bigint) != 63
AND 
CPD.TypeOfStudent=''INTERNATIONAL''
GROUP BY SA.Candidate_Id,CPD.Candidate_Fname,CPD.Candidate_Lname;
end
    ')
END
