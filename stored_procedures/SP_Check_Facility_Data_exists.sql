IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_Facility_Data_exists]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Check_Facility_Data_exists](@flag bigint=0,@name varchar(max)='''',@id bigint=0)      
--SP_Check_Facility_Data_exists 8,''int!'',0    
as      
begin      
 If (@flag=1)      
 begin      
 select * from [Tbl_Organzations ] where Organization_Id!=@id and Organization_Name=@name and Organization_DelStatus=0      
 end      
 if(@flag=2)      
 begin      
      
 select * from [Tbl_Organzations ] where Organization_Id!=@id and Organization_Code=@name and Organization_DelStatus=0      
 end      
 if(@flag=3)      
 begin      
 select * from Tbl_Block where Block_Id!=@id and Block_Name=@name and Block_DelStatus=0      
 end      
 if(@flag=4)      
 begin      
 select * from Tbl_Block where Block_Id!=@id and Block_Code=@name and Block_DelStatus=0      
 end      
 if(@flag=5)      
 begin      
 select * from Tbl_Floor where Floor_Id!=@id and Floor_Name=@name and Floor_DelStatus=0      
 end      
 if(@flag=6)      
 begin      
 select * from Tbl_Floor where Floor_Id!=@id and Floor_Code=@name and Floor_DelStatus=0      
 end      
 if(@flag=7)      
 begin      
 select * from Tbl_Room where Room_Id!=@id and Room_Name=@name and Room_Status=0      
 end      
   if(@flag=8)    
    begin    
    
 select * from Tbl_Assessment_Type where Assessment_Type_Id!=@id and Assessment_Type_Code=@name     
 end    
  if(@flag=9)    
    begin    
    
 select * from Tbl_Assessment_Type where Assessment_Type_Id!=@id and Assesment_Type=@name     
 end    
  if(@flag=10)    
    begin    
    
 select * from Tbl_Assessment_Code_Master where Assessment_Code_Id!=@id and Assessment_Code=@name     
 end    
   if(@flag=11)    
    begin    
    
 select * from Tbl_Room_Type where Room_type_id!=@id and Room_type=@name  and delete_status=0   
 end   
 if(@flag=12)    
    begin    
    
 select * from Tbl_Partner_University where Partner_UniversityId!=@id and University_Name=@name   and delete_status=0  
 end 
 if(@flag=13)    
    begin    
    
 select * from Tbl_Partner_University where Partner_UniversityId!=@id and University_Code=@name   and delete_status=0  
 end 
end
    ')
END
