IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Room_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE Procedure [dbo].[Sp_Room_Type](@flag bigint=0,@typeid bigint=0,@typename varchar(max)='''',@type_status bit=0)    
as    
begin    
if(@flag=1)--add room type    
begin    
  insert into Tbl_Room_Type(Room_type,Active_status,delete_status) values(@typename,@type_status,0)    
end    
if(@flag=2)--update room type    
begin    
 update  Tbl_Room_Type set Room_type=@typename,Active_status=@type_status where Room_type_id=@typeid   and Room_type_id!=1  
end    
if(@flag=3)--for delete    
begin    
 update  Tbl_Room_Type set delete_status=1 where Room_type_id=@typeid   and Room_type_id!=1  
end    
if(@flag=4)--select room type by type id    
begin    
  select * from Tbl_Room_Type where Room_type_id=@typeid and delete_status=0    
end    
if(@flag=5)--select all active room type     
begin    
  select Room_type,Room_type_id,case when Active_status=1 then ''Active'' else ''Inactive'' end as active_status from Tbl_Room_Type where delete_status=0   and Active_status=1     
end    
if(@flag=6)--select all   room type     
begin    
  select Room_type,Room_type_id,case when Active_status=1 then ''Active'' else ''Inactive'' end as active_status from Tbl_Room_Type where delete_status=0  
end 
end
');
END;