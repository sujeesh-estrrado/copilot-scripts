IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[usp_Update_Filter_Data]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[usp_Update_Filter_Data]
     @FacultyId INT,
    @ProgrammeId INT,
    @IntakeId INT,
    @CounselorEmployeeId BIGINT,
    @TabName NVARCHAR(50),
    @TabId BIGINT
AS
BEGIN
     UPDATE tbl_Counsilor_Custom_Filter
        SET TabName = @TabName,
            Faculty = @FacultyId,
            Programme = @ProgrammeId,
            Batch = @IntakeId
        WHERE ID = @TabId
        AND Dashboard = ''CounsellorLead'';
END;


');
END;
