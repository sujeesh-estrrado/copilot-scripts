IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Event_Particulars]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Event_Particulars]  
(  
     @EventId  bigint,  
  @employeeId   bigint,  
  @Parthicular varchar(max),  
  @Budgent decimal(18,2)     
   
   
)  
As  
  
Begin  
  
 Insert into Tbl_Particulars_detailss(Event_ID,Employee_Id,Particulars,Budget,Del_status)values(@EventId,@employeeId,@Parthicular,@Budgent,0)  
   
   
End  
   ');
END;
