IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[usp_Check_Existing_Filter_Data]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[usp_Check_Existing_Filter_Data]
    @FacultyId INT,
    @ProgrammeId INT,
    @IntakeId INT,
    @CounselorEmployeeId BIGINT,
    @TabName NVARCHAR(50),
    @TabId BIGINT
AS
BEGIN
    SELECT * FROM tbl_Counsilor_Custom_Filter
    WHERE Faculty = @FacultyId
    AND Programme = @ProgrammeId
    AND Batch = @IntakeId
    AND CounselorEmployeeId = @CounselorEmployeeId
    AND TabName = @TabName
    AND Id = @TabId
	 AND Dashboard = ''CounsellorLead''
		AND DeleteStatus=0;
END; 


');
END;
