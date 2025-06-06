IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Room_Available]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Room_Available]
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
            INNER JOIN Tbl_Campus C 
                ON R.Campus_Id = C.Campus_Id
            INNER JOIN Tbl_Block B 
                ON R.Block_Id = B.Block_Id
            INNER JOIN Tbl_Floor F 
                ON R.Floor_Id = F.Floor_Id
            WHERE Room_Status = 0 
                AND R.[Room_Id] NOT IN 
                    (SELECT Room_Id FROM Tbl_Class_Allocation)
        END
    ')
END
