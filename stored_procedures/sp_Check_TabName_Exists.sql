IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Check_TabName_Exists]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Check_TabName_Exists]
    @TabName VARCHAR(255),
    @Councelor bigint
AS
BEGIN
    SET NOCOUNT ON;
     
    SELECT ID
    FROM tbl_Counsilor_Custom_Filter
    WHERE TabName COLLATE Latin1_General_CI_AI = @TabName COLLATE Latin1_General_CI_AI
    AND DeleteStatus = 0
    AND Dashboard = ''CounsellorLead''
    and CounselorEmployeeId=@Councelor;
END


');
END;
