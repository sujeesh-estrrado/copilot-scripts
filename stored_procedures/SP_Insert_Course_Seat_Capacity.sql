IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Course_Seat_Capacity]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_Course_Seat_Capacity] (
@Course_Department_Id bigint,@FromDate datetime,@ToDate datetime,@NoofSeats varchar(20)
)
AS
    
BEGIN 
    
        insert into Tbl_Course_Seat_Capacity(Course_Department_Id,FromDate,ToDate,NoofSeats,Seat_Capacity_Status)
        values(@Course_Department_Id,@FromDate,@ToDate,@NoofSeats,0)

END

    ')
END
GO