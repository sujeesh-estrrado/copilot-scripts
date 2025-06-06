IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Employee_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        create PROCEDURE [dbo].[SP_Update_Employee_Details]
(
    @Employee_Id BIGINT,
    @Allocated_CourseDepartment_Id BIGINT,
    @Course_Department_Id BIGINT,
    @Duration_Mapping_Id BIGINT,
    @Course_Id NVARCHAR(MAX) -- Comma-separated list of Subject_Ids
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Update Tbl_Emp_CourseDepartment_Allocation
        UPDATE Tbl_Emp_CourseDepartment_Allocation
        SET Allocated_CourseDepartment_Id = @Allocated_CourseDepartment_Id
        WHERE Employee_Id = @Employee_Id;

        -- Delete old course mappings for this employee before inserting new ones
        DELETE FROM Tbl_Emp_Intake_Program_Course_Mapping
        WHERE Employee_Id = @Employee_Id AND Course_Department_Id = @Course_Department_Id;

        -- Insert new course mappings if there are courses provided
        IF (@Course_Id IS NOT NULL AND @Course_Id <> '''')
        BEGIN
            INSERT INTO Tbl_Emp_Intake_Program_Course_Mapping (Employee_Id, Course_Department_Id, Batch_Id, Subject_Id)
            SELECT @Employee_Id, @Course_Department_Id, @Duration_Mapping_Id, value
            FROM STRING_SPLIT(@Course_Id, '',''); -- Splitting the comma-separated course IDs
        END;
    END TRY
    BEGIN CATCH
        -- Handle errors
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
    ')
END
