IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Followup_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Followup_Status]    
    @Status varchar(max)
As    
    
Begin    
    
insert into Tbl_FollowUpStatus(Status,Del_Status)values(@Status,0)
     
     
End');
END;
