IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_Username]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_Candidate_Username] (@Organization_Code varchar(10))
AS
BEGIN
SELECT distinct    convert(varchar,( select isnull(max(user_Id)+1,0)  from tbl_User))+''_''+ Tbl_Organzation.Organization_Code as Username
FROM         Tbl_Org_User_Mapping left JOIN
                      Tbl_Organzation ON Tbl_Org_User_Mapping.Organization_Id = Tbl_Organzation.Organization_Id left JOIN
                      tbl_User ON Tbl_Org_User_Mapping.user_Id = tbl_User.user_Id where Organization_Code=@Organization_Code
END
    ');
END;