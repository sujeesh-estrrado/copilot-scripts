IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ElvisUsers_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_ElvisUsers_ByID]  --30266
(@Userid bigint)      
AS      
BEGIN      
select   
tbl_User.[User_Id],  
tbl_User.role_Id,  
tbl_Role.role_Name as [Role],  
SS.Candidate_Id,cpd.Candidate_Img 
      
from tbl_User   
left JOIN tbl_Role ON tbl_User.role_Id=tbl_Role.role_Id   
left JOIN dbo.Tbl_Student_User SS ON SS.User_Id=tbl_User.User_Id
left join dbo.Tbl_Candidate_Personal_Det cpd on cpd.Candidate_Id=ss.Candidate_Id     
WHERE tbl_User.[User_Id]=@Userid     
END
');
END;
