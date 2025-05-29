IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_SALES_TARGET]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE PROCEDURE [dbo].[SP_INSERT_SALES_TARGET]
    @Flag INT,                -- Flag: 1=Insert, 2=Update, 3=Delete, 4=Display
    @TargetId INT = NULL,     -- Primary Key for Update/Delete
    @TargetYear INT = NULL,   
    @MonthlyTarget INT = NULL,
    @YearlyTarget INT = NULL,
    @CounselorEmployee INT = NULL,
    @CreateDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Flag 1: Insert
    IF @Flag = 1
    BEGIN
        IF @CreateDate IS NULL
        BEGIN
            SET @CreateDate = GETDATE();
        END

        INSERT INTO tbl_Sales_Target (Target_Year, Monthly_Target, Yearly_Target, Councelor_Employee, Create_Date, DelStatus)
        VALUES (@TargetYear, @MonthlyTarget, @YearlyTarget, @CounselorEmployee, @CreateDate, 0);

        SELECT SCOPE_IDENTITY() AS NewTargetId; -- Return the ID of the newly inserted record
    END
    -- Flag 2: Update
    ELSE IF @Flag = 2
    BEGIN
        --IF @TargetId IS NULL
        --BEGIN
        --    RAISERROR(''TargetId is required for update.'', 16, 1);
        --    RETURN;
        --END

        --UPDATE tbl_Sales_Target
        --SET 
        --    Target_Year = ISNULL(@TargetYear, Target_Year),
        --    Monthly_Target = ISNULL(@MonthlyTarget, Monthly_Target),
        --    Yearly_Target = ISNULL(@YearlyTarget, Yearly_Target),
        --    Councelor_Employee = ISNULL(@CounselorEmployee, Councelor_Employee),
        --    Create_Date = ISNULL(@CreateDate, Create_Date)
        --WHERE Target_Id = @TargetId AND DelStatus = 0;

        update tbl_Sales_Target set Target_Year=@TargetYear,Monthly_Target=@MonthlyTarget,Yearly_Target=@YearlyTarget,Councelor_Employee=@CounselorEmployee,Create_Date=@CreateDate where Target_Id=@TargetId and DelStatus=0
    END

    -- Flag 3: Delete
    ELSE IF @Flag = 3
    BEGIN
        -- Ensure TargetId is provided
        IF @TargetId IS NULL
        BEGIN
            RAISERROR(''TargetId is required for delete.'', 16, 1);
            RETURN;
        END

        -- Perform a soft delete by updating DelStatus to 1
        UPDATE tbl_Sales_Target
        SET DelStatus = 1
        WHERE Target_Id = @TargetId;
    END
 -- Flag 5: Check if target exists for counselor in the same year
    ELSE IF @Flag = 4
    BEGIN
        IF @TargetYear IS NULL OR @CounselorEmployee IS NULL
        BEGIN
            RAISERROR(''TargetYear and CounselorEmployee are required for checking existence.'', 16, 1);
            RETURN;
        END

        IF EXISTS (
            SELECT 1
            FROM tbl_Sales_Target
            WHERE 
                Target_Year = @TargetYear 
                AND Councelor_Employee = @CounselorEmployee
                AND DelStatus = 0
        )
        BEGIN
            SELECT 1 AS ExistsFlag; -- Record exists
        END
        ELSE
        BEGIN
            SELECT 0 AS ExistsFlag; -- Record does not exist
        END
    END

    -- Handle invalid flag values
    ELSE
    BEGIN
        RAISERROR(''Invalid Flag value. Use 1=Insert, 2=Update, 3=Delete, 4=Display, 5=Check Exists.'', 16, 1);
    END
END;
    ');
END;
