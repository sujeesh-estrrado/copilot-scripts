IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_FinanceUserRole]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_FinanceUserRole]            
(            
@flag bigint=0,            
@id bigint=0,            
@RoleID bigint =0,            
@MenuID bigint =0,            
@status bit =0            
)            
as            
begin    

 if(@flag=1)--Get Finance User Roles details by userrole id            
 begin     
     
        
  SELECT FUR.id,[RoleID],[MenuID],[status],FAM.FinanceAccess            
  FROM [dbo].[tbl_FinanceUserRole] as FUR left join Tbl_FinanceAccessMaster as FAM            
   on  FUR.MenuID = FAM.id            
  where RoleID= @RoleID            
          
              
     
 end            
 if(@flag=2)--Insert Finance User Roles            
 begin             
  INSERT INTO [dbo].[tbl_FinanceUserRole]([RoleID],[MenuID],[status])            
  VALUES            
           (@RoleID,@MenuID,@status)            
 end            
 if(@flag=3)--Delete all Finance User Roles by userrole id            
 begin            
  if(@RoleID<>0)            
  begin            
   delete [tbl_FinanceUserRole] where [RoleID] = @RoleID            
  end            
 end            
 if(@flag=4)--Get All Finance Menus            
 begin            
  select * from tbl_FinanceAccessMaster             
 end            
 if(@flag=5)--Get Staus by userrole id and menu            
 begin            
  SELECT FUR.id,[RoleID],[MenuID],[status],FAM.FinanceAccess            
  FROM [dbo].[tbl_FinanceUserRole] as FUR left join Tbl_FinanceAccessMaster as FAM            
   on  FUR.MenuID = FAM.id            
  where RoleID= @RoleID and [MenuID] = @MenuID            
            
 end            
             
end            

    ')
END
