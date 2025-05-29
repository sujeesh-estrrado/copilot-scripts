IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Tabs_By_Counselor_Dashboard]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[sp_Get_Tabs_By_Counselor_Dashboard]
    @CounselorEmployeeId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    
      SELECT  
    TabName,
    STRING_AGG(CAST(ID AS VARCHAR(MAX)), '','') AS tabId, 
    (
        SELECT STRING_AGG(Faculty, '','') 
        FROM (
            SELECT DISTINCT Faculty 
            FROM tbl_Counsilor_Custom_Filter 
            WHERE CounselorEmployeeId = @CounselorEmployeeId 
              AND DeleteStatus = 0 
              AND Dashboard = ''Counsellor''
              AND TabName = t.TabName
        ) AS DistinctFaculty
    ) AS Faculty,  
    (
        SELECT STRING_AGG(Programme, '','') 
        FROM (
            SELECT DISTINCT Programme 
            FROM tbl_Counsilor_Custom_Filter 
            WHERE CounselorEmployeeId = @CounselorEmployeeId 
              AND DeleteStatus = 0 
              AND Dashboard = ''Counsellor''
              AND TabName = t.TabName
        ) AS DistinctProgramme
    ) AS Programme,  
    (
        SELECT STRING_AGG(Batch, '','') 
        FROM (
            SELECT DISTINCT Batch 
            FROM tbl_Counsilor_Custom_Filter 
            WHERE CounselorEmployeeId = @CounselorEmployeeId 
              AND DeleteStatus = 0 
              AND Dashboard = ''Counsellor''
              AND TabName = t.TabName
        ) AS DistinctBatch
    ) AS Batch  
FROM tbl_Counsilor_Custom_Filter t
WHERE CounselorEmployeeId = @CounselorEmployeeId 
  AND DeleteStatus = 0 
  AND Dashboard = ''Counsellor''
GROUP BY TabName;
END;
');
END;
