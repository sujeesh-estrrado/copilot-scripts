IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_intake_Seat_existance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Check_intake_Seat_existance]                  
 (
 @batchid BIGINT,                   
                 
@Department_Id bigint)                  
AS   
begin           
select * from Tbl_Course_Seat_TotalCapacity where Batch_Id=@batchid and Department_Id=@Department_Id and Delete_Status=0       
       

         
 END  
    ')
END
