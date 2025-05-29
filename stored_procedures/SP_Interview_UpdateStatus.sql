IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Interview_UpdateStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Interview_UpdateStatus]
(
@candidate_id bigint=0,
@flag bigint=0
)
as
begin	
if(@flag=1)
	begin
		Update  Tbl_Interview_Schedule_Log set delete_status=1 where candidate_id=@candidate_id  
	end
 end 
');
END;