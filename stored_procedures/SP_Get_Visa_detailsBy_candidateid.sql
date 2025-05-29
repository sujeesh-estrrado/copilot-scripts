IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Visa]')
    AND type = N'P'
)
BEGIN
    EXEC('
       create procedure [dbo].[Sp_Get_Visa]
@Candidate_Id bigint
as
begin
select * from Tbl_Visa_ISSO where Candidate_Id=@Candidate_Id and Expiry_Status=0 order by Visa_Id desc
end
    ')
END
GO
