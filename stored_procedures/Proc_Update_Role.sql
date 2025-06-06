IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Role]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Update_Role](@role_Id int,@role_Name varchar(50),  
     @role_status bit , @Is_Authority bit ,@Is_PrimeAuthority bit,@Approval_limit_amount varchar(50) )  
  
AS  
  
BEGIN  
  if not exists (select role_Name from tbl_Role where role_DeleteStatus = 0 and role_Name = @role_Name  and role_Id != @role_Id)
    begin
        if exists(select role_Name from tbl_Role where [static] = 1 and role_Id = @role_Id)
        begin
             RAISERROR (''CannotUpdateStaticRole'', -- Message text.
                  16, -- Severity.
                  1 -- State.
                  );
        end
        else
        begin
            UPDATE [dbo].[tbl_Role]  
            SET role_Name    = @role_Name  ,  
                role_status  = @role_status  ,
                Is_Authority = @Is_Authority,
                Is_PrimeAuthority = @Is_PrimeAuthority,
                Approval_limit_amount = @Approval_limit_amount
            WHERE  role_Id = @role_Id  and ([static] != 1 or [static] is null)
        end
    end
    else
    begin 
         RAISERROR (''RoleAlreadyExists'', -- Message text.
                  16, -- Severity.
                  1 -- State.
                  );
    end

  
END



select * from [tbl_Role]
    ')
END
