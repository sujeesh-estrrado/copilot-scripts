IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Load_Approval_Hierarchy_by_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Load_Approval_Hierarchy_by_id]  
@AuthorityUserId bigint  
--@Name varchar(100),  
--@Type varchar(50),  
--@Priority bigint   
--@Employee_Id bigint  
as   
begin  
  
  select *  
  from   Tbl_Approval_Hierarchy where delstatus=0 and AuthorityUserId=@AuthorityUserId --ah join dbo.Tbl_Employee e on ah.AuthorityUserId=e.Employee_Id --where e.Employee_Id=@Employee_Id  
    
  end
    ');
END;
