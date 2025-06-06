IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Check_Duplicate_TeamName]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE pROCEDURE [dbo].[Sp_Check_Duplicate_TeamName] --''''--''New Team''
    @SearchTerm varchar(100),
    @flag bigint=0
AS
BEGIN
if(@flag=0)
Begin
select distinct TeamLead,TeamName from Tbl_Counsellor_Teamforming where DelStatus=0 and TeamName like ''''+LTRIM(RTRIM(@SearchTerm))+''%''
end
if(@flag=1)
Begin
select distinct Event_Id,EventName from Tbl_Event_Details where Del_status=0 and EventName like @SearchTerm
end

END
    ')
END
