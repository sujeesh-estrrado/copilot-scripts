IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_update_LMS_user]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_update_LMS_user](@Candidate_Id bigint=0,@Lmsuserid bigint=0,@flag bigint=0)        
AS    
BEGIN
 DECLARE @user_Id INT;
if(@flag=0)
        begin  
     

    SELECT @user_Id = user_id 
    FROM Tbl_Student_User 
    WHERE Candidate_Id = @Candidate_Id;

  update  Tbl_User  set Lms_userid=  @Lmsuserid 
 where user_Id =   @user_Id;
 end
 if(@flag=1)
        begin
             SELECT @user_Id = user_id 
    FROM Tbl_Employee_User 
    WHERE employee_id = @Candidate_Id;

     update  Tbl_User  set Lms_userid=  @Lmsuserid 
 where user_Id =   @user_Id;
 end
    
END
    ')
END;
