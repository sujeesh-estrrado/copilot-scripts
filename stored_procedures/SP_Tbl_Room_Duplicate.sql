IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Room_Duplicate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Room_Duplicate]
            @roomName VARCHAR(50),
            @CampusId BIGINT,
            @BlockId BIGINT,
            @FloorId BIGINT
        AS
        BEGIN
            SELECT 
                R.[Room_Id],
                R.[Room_Name],
                R.[Campus_Id],
                R.[Block_Id],
                R.[Floor_Id],
                R.[Seat_Capacity],
                R.[Exam_SeatCapacity],
                R.[Room_Status],
                C.Campus_Name,
                B.Block_Name,
                F.Floor_Name
            FROM [Tbl_Room] R
            INNER JOIN Tbl_Campus C ON R.Campus_Id = C.Campus_Id
            INNER JOIN Tbl_Block B ON R.Block_Id = B.Block_Id
            INNER JOIN Tbl_Floor F ON R.Floor_Id = F.Floor_Id
            WHERE Room_Status = 0 
            AND R.Room_Name = @roomName 
            AND C.Campus_Id = @CampusId 
            AND F.Floor_Id = @FloorId
        END
    ')
END
