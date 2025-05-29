IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_User_By_User_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Student_User_By_User_Id]
(  
@User_Id bigint  
)  
as   
  
begin  
  
Select S.*,concat(C.Candidate_Fname,'' '',C.Candidate_Lname )as Candidate_Name,Display_Status,CC.Candidate_Email,C.AdharNumber,CC.Candidate_Email,CC.Candidate_FatherName
 from dbo.Tbl_Student_User S left join dbo.Tbl_Candidate_Personal_Det C on S.Candidate_Id=C.Candidate_Id
 left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=C.Candidate_Id
where User_Id=@User_Id  
  
end
')
END
