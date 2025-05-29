IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Agent_View_Chat]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Agent_View_Chat]  --2,30108
(
@Agent_ID bigint,
@Candidate_Id bigint
)          
AS            
BEGIN 
select Q.Message,type,date from Tbl_Quries Q

Inner join Tbl_Candidate_Personal_Det D  on Q.Student_Id=D.Candidate_Id
 where Agent_ID=@Agent_ID and Student_Id=@Candidate_Id
end


select * from Tbl_Quries

    ')
END;
