IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Room_Select_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Room_Select_By_Id]
            @Room_Id bigint
        AS
        BEGIN
            SELECT 
                [Room_Id],
                [Room_Name],
                [Campus_Id],
                [Block_Id],
                [Floor_Id],
                [Seat_Capacity],
                [Exam_SeatCapacity],
                [Room_Status],
                Room_Type AS Exam_hall_sts
            FROM [Tbl_Room]
            WHERE Room_Id = @Room_Id;
        END;
    ');
END;
