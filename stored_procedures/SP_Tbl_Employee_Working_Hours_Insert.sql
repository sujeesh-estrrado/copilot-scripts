IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Working_Hours_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Working_Hours_Insert] 
        @Employee_Id bigint,
        @Hours_per_week int
        AS
        BEGIN
            -- Check if record exists in Tbl_Employee_Working_Hours
            IF NOT EXISTS (SELECT * FROM Tbl_Employee_Working_Hours WHERE Employee_Id = @Employee_Id)
            BEGIN
                -- Insert new record
                INSERT INTO Tbl_Employee_Working_Hours (Employee_Id, Hours_per_week)
                VALUES (@Employee_Id, @Hours_per_week)
            END
            ELSE
            BEGIN
                -- Update existing record
                UPDATE Tbl_Employee_Working_Hours
                SET Employee_Id = @Employee_Id,
                    Hours_per_week = @Hours_per_week
                WHERE Employee_Id = @Employee_Id
            END
        END
    ')
END
