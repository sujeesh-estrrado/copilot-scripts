IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Campus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Update_Campus]          
(@Campus_Id bigint,        
 @Campus_Name varchar(200),          
 @Campus_Code varchar(50))          
          
AS         
        
--IF  EXISTS (SELECT * FROM [Tbl_Campus] WHERE Campus_Name=@Campus_Name and Campus_Id<>@Campus_Id and Campus_DelStatus = 0 )       
--if exists (SELECT Organization_Id as  Campus_Id,Organization_Name as  Campus_Name,Organization_Code Campus_Code    
--  FROM [dbo].[Tbl_Organzations ] where Organization_DelStatus=0  and Organization_Id<>@Campus_Id)  
--BEGIN                  
--RAISERROR(''Your data already Exist.'',16,1);                  
--END               
--ELSE          
          
BEGIN          
          
--UPDATE [dbo].[Tbl_Campus]          
--SET Campus_Name = @Campus_Name,          
--    Campus_Code = @Campus_Code          
                         
--WHERE  Campus_Id = @Campus_Id      
if exists (select * from [Tbl_Organzations ] where Organization_Id!=@Campus_Id and Organization_Name=@Campus_Name )
begin

RAISERROR(''Your data already Exist.'',16,1)
end
else
begin
update [Tbl_Organzations ] set Organization_Name=@Campus_Name,Organization_Code=@Campus_Code where Organization_Id=@Campus_Id  
    end      
END  

   ')
END;
