IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_ClearOffer_letter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_ClearOffer_letter](@candidate_id bigint)          
as          
begin          
update Tbl_Offerlettre set  Sented_by=null,delete_status=1,Offerletter_type=null, Offerletter_Path=null,update_date=null where candidate_id=@candidate_id           
update tbl_approval_log set Offerletter_status =null,offer_letter_accept_date=null,Offerletter_sent=null where candidate_id=@candidate_id and delete_status=0;          
          Update  Tbl_Interview_Schedule_Log set delete_status=1 where candidate_id=@candidate_id    
        
        delete Tbl_Interview_log  where candidate_id=@candidate_id    
end 
    ')
END
