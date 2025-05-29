IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_certificate_category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_certificate_category](@flag bigint,@categoryname varchar(max),@id bigint)      
as      
begin      
      
if(@flag=0)      
  begin      
  if not exists (select * from tbl_certificate_category where delete_status=0 and category=@categoryname)    
  begin    
insert into tbl_certificate_category (category,create_date,delete_status)values (@categoryname,GETDATE(),0);    
end    
end      
if(@flag=1)      
 begin      
   if not exists (select * from tbl_certificate_category where delete_status=0 and category=@categoryname and id!=@id )    
  begin    
  
 update tbl_certificate_category set category=@categoryname ,update_date=GETDATE() where delete_status=0 and id=@id    
end      
    end  
      
    if(@flag=2)  
 begin  
 if not exists (select * from tbl_certificate_master where Category_id=@id and Delete_Status=0)  
 begin  
 update tbl_certificate_category set delete_status=1 where id=@id  
 end  
 end  
      
   if(@flag=3)      
 begin      
 select * from tbl_certificate_category where delete_status=0 and id!=@id  and category=@categoryname  
end     
      
      
      
      
end');
END;
