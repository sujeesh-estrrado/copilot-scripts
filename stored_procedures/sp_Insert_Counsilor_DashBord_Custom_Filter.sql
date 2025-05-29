IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_Counsilor_DashBord_Custom_Filter]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[sp_Insert_Counsilor_DashBord_Custom_Filter]
    @TabId BIGINT = NULL,  
    @TabName VARCHAR(255),
    @FacultyId BIGINT,
    @ProgrammeId BIGINT,
    @IntakeId BIGINT,
    @CounselorEmployeeId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
     
    IF @TabId IS NOT NULL AND @TabId > 0
    BEGIN
        IF EXISTS (
            SELECT 1 FROM tbl_Counsilor_Custom_Filter 
            WHERE ID = @TabId
            AND CounselorEmployeeId = @CounselorEmployeeId 
            AND Dashboard = ''Counsellor ''
        )
        BEGIN 
            UPDATE tbl_Counsilor_Custom_Filter
            SET TabName = @TabName
            WHERE ID = @TabId;

            SELECT @TabId AS UpdatedId; -- Return updated ID
            RETURN;
        END
    END
     
    DECLARE @ExistingTabId BIGINT;
    SELECT @ExistingTabId = ID 
    FROM tbl_Counsilor_Custom_Filter
    WHERE CounselorEmployeeId = @CounselorEmployeeId 
        AND Faculty = @FacultyId 
        AND Programme = @ProgrammeId 
        AND ISNULL(Batch, 0) = ISNULL(@IntakeId, 0)  
        AND Dashboard = ''Counsellor ''
        AND DeleteStatus = 0
        AND Id=@TabId;
         
    IF @ExistingTabId IS NOT NULL
    BEGIN
        UPDATE tbl_Counsilor_Custom_Filter
        SET TabName = @TabName,
            Faculty = @FacultyId,
            Programme = @ProgrammeId,
            Batch = ISNULL(@IntakeId, 0)
        WHERE ID = @ExistingTabId;

        SELECT @ExistingTabId AS UpdatedId;  
    END
    ELSE
    BEGIN 
        INSERT INTO tbl_Counsilor_Custom_Filter (CounselorEmployeeId, TabName, Faculty, Programme, Batch, DeleteStatus, Dashboard)
        VALUES (@CounselorEmployeeId, @TabName, @FacultyId, @ProgrammeId, ISNULL(@IntakeId, 0), 0, ''Counsellor '');

        SELECT SCOPE_IDENTITY() AS InsertedId;
    END
END;');
END;
