IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Room_Select_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Room_Select_All]
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
                C.Organization_Name AS Campus_Name,
                B.Block_Name,
                F.Floor_Name,
                RT.Room_type
            FROM [Tbl_Room] R
            INNER JOIN [Tbl_Organzations] C ON R.Campus_Id = C.Organization_Id
            INNER JOIN Tbl_Block B ON R.Block_Id = B.Block_Id
            INNER JOIN Tbl_Floor F ON R.Floor_Id = F.Floor_Id
            INNER JOIN Tbl_Room_Type RT ON RT.Room_type_id = R.Room_Type
            WHERE Room_Status = 0
            ORDER BY Room_Id DESC
        END
    ')
END
