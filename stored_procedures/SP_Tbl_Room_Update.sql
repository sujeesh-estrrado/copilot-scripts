IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Room_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Room_Update]
            @Room_Id bigint,
            @Room_Name varchar(200),
            @Campus_Id bigint,
            @Block_Id bigint,
            @Floor_Id bigint,
            @Seat_Capacity int,
            @Exam_SeatCapacity int,
            @examhall_status bigint
        AS
        IF EXISTS (
            SELECT Room_Name 
            FROM Tbl_Room 
            WHERE Room_Name = @Room_Name
              AND Campus_Id = @Campus_Id
              AND Block_Id = @Block_Id
              AND Floor_Id = @Floor_Id
              AND Room_Status = 0
              AND Room_Id <> @Room_Id
        )
        BEGIN
            RAISERROR (
                ''Your data already exist.'', -- Message text.
                16, -- Severity.
                1 -- State.
            );
        END
        ELSE
        BEGIN
            UPDATE [Tbl_Room]
            SET 
                [Room_Name] = @Room_Name,
                [Campus_Id] = @Campus_Id,
                [Block_Id] = @Block_Id,
                [Floor_Id] = @Floor_Id,
                [Seat_Capacity] = @Seat_Capacity,
                [Exam_SeatCapacity] = @Exam_SeatCapacity,
                Room_Type = @examhall_status
            WHERE Room_Id = @Room_Id;
        END;
    ');
END;
