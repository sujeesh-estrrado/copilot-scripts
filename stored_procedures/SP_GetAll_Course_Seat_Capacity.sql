IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Seat_Capacity]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Seat_Capacity]

AS

BEGIN
            SELECT     
a.Course_Seat_Capacity_Id,a.FromDate,a.ToDate,a.NoofSeats,a.Seat_Capacity_Status,
dbo.Tbl_Course_Department.Course_Department_Id,
                      dbo.Tbl_Course_Department.Course_Category_Id,  dbo.Tbl_Course_Category.Course_Category_Name,
                       dbo.Tbl_Course_Department.Course_Department_Description, 
                      dbo.Tbl_Course_Department.Course_Department_Date,
dbo.Tbl_Department.Department_Id,dbo.Tbl_Department.Department_Name,b.Course_Level_Name


            FROM  
  dbo.tbl_Course_Seat_Capacity a left join  dbo.Tbl_Course_Department ON a.Course_Department_Id=dbo.Tbl_Course_Department.Course_Department_Id
             Left JOIN dbo.Tbl_Course_Category 
                       ON dbo.Tbl_Course_Category.Course_Category_Id = dbo.Tbl_Course_Department.Course_Category_Id
left join dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id=Tbl_Course_Department.Department_Id
left join dbo.Tbl_Course_Level b on b.Course_Level_Id=dbo.Tbl_Course_Category.Course_level_Id
	      where Tbl_Course_Department.Course_Department_Status=0 and
                 Tbl_Course_Category.Course_Category_Status=0
and a.Seat_Capacity_Status=0;
			
END
');
END;