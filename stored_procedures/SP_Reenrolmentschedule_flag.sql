IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Reenrolmentschedule_flag]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Reenrolmentschedule_flag] --17,5        
(           
@Flag bigint=0,               
@StartDate Datetime ,  
@ReenrolmentscheduleId bigint=0  
)                   
AS                          
BEGIN                          
if(@Flag=0)  
Begin  
   select *,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name  from Tbl_Reenrolmentschedule as RE  
 left join Tbl_Department D on D.Department_Id=RE.Department_Id where   
 @StartDate    between StartDate and EndDate and FlagNotification=0   
End  
  
if(@Flag=1)  
Begin  
 update Tbl_Reenrolmentschedule set FlagNotification=1 where ReenrolmentscheduleId=@ReenrolmentscheduleId  
End  
 END 
');
END;