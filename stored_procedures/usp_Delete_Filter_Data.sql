IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[usp_Delete_Filter_Data]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[usp_Delete_Filter_Data]
    @CounselorEmployeeId BIGINT,
    @TabName NVARCHAR(50),
    @TabId BIGINT
AS
BEGIN
    DELETE FROM tbl_Counsilor_Custom_Filter
    WHERE CounselorEmployeeId = @CounselorEmployeeId
    AND TabName = @TabName
    AND Id = @TabId
    AND Dashboard = ''CounsellorLead'';
END;

');
END;
