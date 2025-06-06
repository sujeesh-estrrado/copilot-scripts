IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_placement_result_with_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_Check_placement_result_with_id]

 (@candidateid bigint,
 @flag bigint=0)
as
begin
if( @flag=0)
    begin
         select top 1 result from Tbl_Placement_Log where candidate_id=@candidateid
   order by result desc
    end     
if( @flag=1)
    begin
        Update Tbl_Placement_Schedule_Log set delete_status=1 where candidate_id=@candidateid
    end         
    
    if( @flag=2)
    begin
        Select * from Tbl_Placement_Schedule_Log 
        where candidate_id=@candidateid
    end     
 end
    ')
END
