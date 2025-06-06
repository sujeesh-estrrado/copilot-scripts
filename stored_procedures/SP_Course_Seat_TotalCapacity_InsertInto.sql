IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Course_Seat_TotalCapacity_InsertInto]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Course_Seat_TotalCapacity_InsertInto]
        (@Org_Id BIGINT,
         @batchid BIGINT,
         @categoryid BIGINT,
         @totalcapacity INT,
         @Department_Id BIGINT)
        AS
        BEGIN
            IF NOT EXISTS(
                SELECT * 
                FROM Tbl_Course_Seat_TotalCapacity 
                WHERE Batch_Id = @batchid 
                  AND Department_Id = @Department_Id 
                  AND Delete_Status = 0)
            BEGIN
                INSERT INTO dbo.Tbl_Course_Seat_TotalCapacity(
                    Org_Id, 
                    Batch_Id, 
                    Category_Id, 
                    Total_Capacity, 
                    Department_Id, 
                    Created_Date, 
                    Updated_Date, 
                    Delete_Status)
                VALUES(@Org_Id, @batchid, @categoryid, @totalcapacity, @Department_Id, GETDATE(), GETDATE(), 0)
                SELECT 1
            END
            ELSE
            BEGIN
                UPDATE Tbl_Course_Seat_TotalCapacity
                SET 
                    Org_Id = @Org_Id,
                    Batch_Id = @batchid,
                    Category_Id = @categoryid,
                    Total_Capacity = @totalcapacity,
                    Department_Id = @Department_Id,
                    Created_Date = GETDATE(),
                    Updated_date = GETDATE(),
                    Delete_Status = 0
                WHERE Batch_Id = @batchid 
                  AND Department_Id = @Department_Id
                SELECT 2
            END
        END
    ')
END
