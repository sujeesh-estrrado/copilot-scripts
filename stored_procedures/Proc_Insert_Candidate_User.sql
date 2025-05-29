IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Candidate_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Insert_Candidate_User] 
	(@Candid_Id bigint,@User_Id int )
      
AS
BEGIN 
	
		insert into dbo.Tbl_Student_User(Candidate_Id,User_Id)
		values(@Candid_Id,@User_Id )

select Scope_Identity()

END

    ');
END;
