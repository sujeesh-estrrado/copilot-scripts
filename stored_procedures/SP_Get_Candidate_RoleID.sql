IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_RoleID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Candidate_RoleID]   

AS  
BEGIN
select * from dbo.tbl_Role
where role_Name=''candidate''
END');
END;