IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Notificationby_ExcelId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Notificationby_ExcelId](@user_id bigint,@excelid bigint,@type varchar(max))
as
begin
select distinct CounselorEmployee_id 
into #ControlTable  
from dbo.Tbl_Lead_Personal_Det  
where  Excel_id=@excelid
declare @TableID int  ,@counsillorid int
while exists (select * from #ControlTable)  
begin  
set @TableID=(  
    select top 1 CounselorEmployee_id  
    from #ControlTable)  ;
	declare @user int;
	set @counsillorid=(select top 1 CounselorEmployee_id from #ControlTable)
	set @user=(select user_id from Tbl_Employee_User where Employee_Id=@counsillorid)
	if(@counsillorid!='''' and @counsillorid!=0)
	begin

  EXEC  Sp_Insert_Notification_With_link @Notification_Msg=''A new Lead assigned!'',@User_Id=@user,@Senter=@user_id,@roleid=''0'',@Url=''#'',@Category=@type
   
	end
    -- Do something with your TableID  
    delete #ControlTable  
    where CounselorEmployee_id = @TableID  
end  
drop table #ControlTable  


end
   ');
END;
