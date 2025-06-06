IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_interview_result_with_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Check_interview_result_with_id]

 (@candidateid bigint,
 @flag bigint=0)
as
begin
if( @flag=0)
    begin
        Select *,FORMAT(CAST(DATEADD(DAY, -7, CAST(interview_date AS DATE)) AS DATE), ''yyyy-MMM-dd'') AS ELIGIBLEDATE  from Tbl_Interview_Schedule_Log where candidate_id=@candidateid and delete_status=0;
    end     
if( @flag=1)
    begin
        Update Tbl_Interview_Schedule_Log set delete_status=1 where candidate_id=@candidateid
    end 
    if( @flag=2)
    begin
        Select *,FORMAT(CAST(DATEADD(DAY, -7, CAST(interview_date AS DATE)) AS DATE), ''yyyy-MMM-dd'') AS ELIGIBLEDATE  from Tbl_Interview_Schedule_Log where candidate_id=@candidateid
    end 
 end
    ')
END
