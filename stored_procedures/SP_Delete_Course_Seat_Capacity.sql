IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Course_Seat_Capacity]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Delete_Course_Seat_Capacity]

(@Course_Seat_Capacity_Id bigint)  
  
AS  
  
BEGIN  
  
 Update Tbl_Course_Seat_TotalCapacity set Delete_Status=1,Updated_Date=getdate()

  WHERE  totalCapacity_Id=@Course_Seat_Capacity_Id  
END


    ')
END
