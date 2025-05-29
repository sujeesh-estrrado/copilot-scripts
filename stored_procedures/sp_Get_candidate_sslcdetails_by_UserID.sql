IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_candidate_sslcdetails_by_UserID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_candidate_sslcdetails_by_UserID] --20034,1
(@User_Id bigint,
@Flag bigint,
@Qualification varchar(MAX))
as
Begin
if(@Flag=1)
begin
select * from Tbl_Candidate_EducationDetails P
where P.Candidate_Id=@User_Id and Qualification=@Qualification
end
end
    ')
END;
