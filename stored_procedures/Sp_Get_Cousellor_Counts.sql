IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Cousellor_Counts]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_Get_Cousellor_Counts]
(@id bigint
,@emp_id bigint)
as
begin

    if(@id=1)
    begin
    --Todays Leads
    SELECT COUNT(*) AS num
FROM Tbl_Candidate_Personal_Det
WHERE CAST(RegDate AS DATE) = CAST(GETDATE() AS DATE) and CounselorEmployee_id=@emp_id and (applicationstatus=''pending'' or applicationstatus=''submited'') ;

end
    else if(@id=2)---Total enquiey
    begin
        SELECT COUNT(*) AS num
FROM Tbl_Candidate_Personal_Det WHERE CounselorEmployee_id=@emp_id and (applicationstatus=''pending'' or applicationstatus=''submited'');
    end

    else if(@id=3)---Total enquiey
    begin
        SELECT *
FROM Tbl_Candidate_Personal_Det WHERE CounselorEmployee_id=@emp_id and (applicationstatus=''pending'' or applicationstatus=''submited'');
    end
end
    ')
END;
