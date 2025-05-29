IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_getEvent_ExpairyDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_getEvent_ExpairyDetails] --1,19  
(@flag bigint=0,@Event_id bigint=0)  
AS  
  
BEGIN  
 if(@flag=0)  
 begin  
   
   
  select *, DATEDIFF(DAY,End_Date,Getdate()) as DD from Tbl_Event_Details where  DATEDIFF(DAY,End_Date,Getdate())>5  
  and Event_Id   in (select Event_Id from Tbl_Particulars_Detailss where ActualExpense is  null) and Event_Id not in (select Event_Id from Tbl_Event_NotificationStatusLog)  
  
 end  
 if(@flag=1)  
 begin  
   
  select * from Tbl_Particulars_Detailss where Event_ID=@Event_id and ActualExpense is not null  
 end  
   
END  ');
END;
