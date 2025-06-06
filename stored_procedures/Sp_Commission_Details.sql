IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Commission_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Commission_Details]
    @Student_id bigint
AS
BEGIN
    select studentid,convert(varchar(10),dateissued,105) as dateissued,AG.Agent_Name,Amount from Tbl_Agent_Settlement as AGS
    left join Tbl_Agent as AG on AGS.AgentId=AG.Agent_ID  where studentid=@Student_id
END
    ')
END
